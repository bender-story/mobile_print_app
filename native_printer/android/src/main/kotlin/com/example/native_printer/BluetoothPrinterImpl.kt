package com.example.native_printer
import android.app.Activity
import android.util.Log
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothSocket
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.Manifest
import android.os.Build
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.app.Instrumentation
import android.view.KeyEvent
import java.io.IOException
import java.util.*
import java.util.concurrent.CountDownLatch

import kotlinx.coroutines.*
import java.net.InetSocketAddress
import java.net.Socket
import java.io.OutputStream

import de.gmuth.ipp.attributes.ColorMode
import de.gmuth.ipp.attributes.DocumentFormat
import de.gmuth.ipp.attributes.Media
import de.gmuth.ipp.attributes.PrintQuality
import de.gmuth.ipp.attributes.Sides
import de.gmuth.ipp.attributes.TemplateAttributes.copies
import de.gmuth.ipp.attributes.TemplateAttributes.jobName
import de.gmuth.ipp.attributes.TemplateAttributes.printerResolution
import de.gmuth.ipp.client.IppPrinter
import de.gmuth.ipp.core.IppResolution
import java.io.File
import java.net.URI
import java.nio.file.Files
import java.nio.file.attribute.FileAttribute
class BluetoothPrinterImpl(
    private val context: Context,
    private val activity: Activity
) : IBluetoothPrinter {
    private var bluetoothAdapter: BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()
    private var bluetoothSocket: BluetoothSocket? = null
    private val bluetoothDevices = mutableListOf<BluetoothDevice>()
    private val REQUEST_BLUETOOTH_PERMISSIONS_CODE = 100
    private var result: Result? = null

    private val discoveryReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            when (intent.action) {
                BluetoothDevice.ACTION_FOUND -> {
                    val device: BluetoothDevice? = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
                    device?.let {
                        if (!bluetoothDevices.contains(it)) {
                            bluetoothDevices.add(it)
                        }
                    }
                    Log.d("BluetoothManager", "Device found: ${device?.name}")
                }
                BluetoothAdapter.ACTION_DISCOVERY_FINISHED -> {
                    Log.d("BluetoothManager", "Discovery finished")
                    context.unregisterReceiver(this)
                    val deviceList = bluetoothDevices.map { device ->
                        mapOf("name" to (device.name ?: "Unknown"), "address" to device.address)
                    }
                    result?.success(deviceList)
                }
            }
        }
    }

    override fun discoverDevices(result: Result) {
        this.result = result
        if (!checkAndRequestPermissions(result)) {
            Log.d("BluetoothPlugin", "Permissions are not granted")
            return
        }

        // Check if Bluetooth is enabled
        if (bluetoothAdapter == null || !bluetoothAdapter!!.isEnabled) {
            Log.d("BluetoothPlugin", "Bluetooth is disabled")
            result.error("BLUETOOTH_DISABLED", "Bluetooth is disabled", null)
            return
        }

        bluetoothDevices.clear()

        val filter = IntentFilter().apply {
            addAction(BluetoothDevice.ACTION_FOUND)
            addAction(BluetoothAdapter.ACTION_DISCOVERY_FINISHED)
        }
        context.registerReceiver(discoveryReceiver, filter)

        // Cancel any existing discovery
        if (bluetoothAdapter!!.isDiscovering) {
            bluetoothAdapter!!.cancelDiscovery()
        }
        Log.d("BluetoothPlugin", bluetoothAdapter!!.startDiscovery().toString())
        if (bluetoothAdapter!!.startDiscovery()) {
            Log.d("BluetoothPlugin", "Discovery started")
        } else {
            Log.d("BluetoothPlugin", "Failed to start discovery")
            result.error("DISCOVERY_ERROR", "Failed to start discovery", null)
        }
    }

    override fun connectToPrinter(address: String, data: String, result: Result) {
        this.result = result
        val device: BluetoothDevice? = bluetoothAdapter?.getRemoteDevice(address)

        // Check if the device is already paired
        val pairedDevices: Set<BluetoothDevice>? = bluetoothAdapter?.bondedDevices
        if (pairedDevices == null || device !in pairedDevices) {
            result.error("DEVICE_NOT_PAIRED", "Device not paired", null)
            return
        }
        try {
            bluetoothSocket?.close()
            bluetoothSocket =
                device?.createRfcommSocketToServiceRecord(UUID.fromString("00001101-0000-1000-8000-00805F9B34FB"))
            bluetoothSocket?.connect()
//            result.success("Connected")
            printData(data, result)
        } catch (e: IOException) {
            result.error("CONNECTION_FAILED", "Failed to connect to $address: ${e.message}", null)
        }
    }

    private fun printData(data: String, result: Result) {
        try {
            val outputStream = bluetoothSocket?.outputStream
            outputStream?.write(data.toByteArray())
            outputStream?.flush()
            result.success("Success")
        } catch (e: IOException) {
            result.error("PRINT_FAILED", "Failed to send data: ${e.message}", null)
        }
    }

    override fun checkAndRequestPermissions(result: Result): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // For Android 12 and above, request Bluetooth and location permissions
            if (ContextCompat.checkSelfPermission(
                    context,
                    Manifest.permission.BLUETOOTH_SCAN
                ) != PackageManager.PERMISSION_GRANTED ||
                ContextCompat.checkSelfPermission(
                    context,
                    Manifest.permission.BLUETOOTH_CONNECT
                ) != PackageManager.PERMISSION_GRANTED ||
                ContextCompat.checkSelfPermission(
                    context,
                    Manifest.permission.ACCESS_FINE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                ActivityCompat.requestPermissions(
                    activity!!,
                    arrayOf(
                        Manifest.permission.BLUETOOTH_SCAN,
                        Manifest.permission.BLUETOOTH_CONNECT,
                        Manifest.permission.ACCESS_FINE_LOCATION  // Added fine location permission
                    ),
                    REQUEST_BLUETOOTH_PERMISSIONS_CODE
                )

                result.error(
                    "PERMISSION_DENIED",
                    "Bluetooth and location permissions not granted",
                    null
                )
                return false
            }
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            // For Android 6.0 to Android 11, request coarse location for Bluetooth discovery
            if (ContextCompat.checkSelfPermission(
                    context,
                    Manifest.permission.ACCESS_COARSE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                ActivityCompat.requestPermissions(
                    activity!!,
                    arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION),
                    REQUEST_BLUETOOTH_PERMISSIONS_CODE
                )

                result.error("PERMISSION_DENIED", "Location permission not granted", null)
                return false
            }
        }
        return true
    }

    override fun closeConnection() {
        try {
            context.unregisterReceiver(discoveryReceiver)
            bluetoothSocket?.close()
        } catch (e: IOException) {
            Log.e("BluetoothPrinterImpl", "Failed to close connection: ${e.message}")
        }
    }
}
