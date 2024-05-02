package com.example.native_bluetooth_print

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

class NativeBluetoothPrintPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var bluetoothAdapter: BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()
    private var bluetoothSocket: BluetoothSocket? = null
    private var activity: Activity? = null
    private var result: Result? = null

    private val bluetoothDevices = mutableListOf<BluetoothDevice>()
    private lateinit var context: Context

    private val REQUEST_BLUETOOTH_PERMISSIONS_CODE = 100

    private val networkScope = CoroutineScope(Dispatchers.IO)

    private val discoveryReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            when (intent.action) {
                BluetoothDevice.ACTION_FOUND -> {
                    val device: BluetoothDevice? =
                        intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
                    device?.let {
                        if (!bluetoothDevices.contains(it)) {
                            bluetoothDevices.add(it)
                        }
                    }
                    Log.d("BluetoothPlugin", "Device found: ${device?.name}")
                }

                BluetoothAdapter.ACTION_DISCOVERY_FINISHED -> {
                    Log.d("BluetoothPlugin", "Discovery finished")
                    context.unregisterReceiver(this)
                    val deviceList = bluetoothDevices.map { device ->
                        mapOf("name" to (device.name ?: "Unknown"), "address" to device.address)
                    }
                    result?.success(deviceList)
                    result = null  // Reset the result after use
                }
            }
        }
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "native_bluetooth_print")
        context = flutterPluginBinding.applicationContext
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        this.result = result
        when (call.method) {
            "discoverDevices" -> discoverDevices(result)
            "connect" -> {
                val address: String = call.argument("address") ?: ""
                val data: String = call.argument("data") ?: ""
                if (address != null) {
                    connectToPrinter(address, data, result)
                } else {
                    result.error("NO_ADDRESS", "Bluetooth address is required", null)
                }
            }

            "discoverIPPrinters" -> {
                val networkBase = call.argument<String>("networkBase") ?: "192.168.1"
                discoverIPPrinters(networkBase, { printers ->
                    if (printers.isNotEmpty()) {
                        result.success(printers)
                    } else {
                        result.error("NO_PRINTERS_FOUND", "No printers found on the network", null)
                    }
                }) { errorMessage ->
                    result.error("DISCOVERY_ERROR", errorMessage, null)
                }
            }

            "printToNetworkPrinter" -> {
                val ipAddress = call.argument<String>("ipAddress")
                val data = call.argument<String>("data")
                if (ipAddress != null && data != null) {
                    printToNetworkPrinter(ipAddress, data) { success, message ->
                        if (success) {
                            result.success(message)
                        } else {
                            result.error("PRINT_ERROR", message, null)
                        }
                    }
                } else {
                    result.error("INVALID_ARGUMENTS", "Invalid or missing arguments", null)
                }
            }

            else -> result.notImplemented()
        }
    }

    private fun discoverDevices(result: Result) {
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

    private fun connectToPrinter(address: String, data: String, result: Result) {
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

    private fun checkAndRequestPermissions(result: Result): Boolean {
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

    fun discoverIPPrinters(
        networkBase: String,
        result: (List<String>) -> Unit,
        error: (String) -> Unit
    ) {
        networkScope.launch {
            val foundPrinters = mutableListOf<String>()
            for (i in 1..254) {
                val ipAddress = "$networkBase.$i"
                try {
                    Socket().use { socket ->
                        socket.connect(
                            InetSocketAddress(ipAddress, 9100),
                            1000
                        )
                        foundPrinters.add(ipAddress)
                    }
                } catch (e: Exception) {
                    error("Failed to connect to $ipAddress: ${e.message}")
                }
            }
            withContext(Dispatchers.Main) {
                result(foundPrinters)
            }
        }
    }

    fun printToNetworkPrinter(
        ipAddress: String,
        data: String,
        callback: (Boolean, String) -> Unit
    ) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                Socket().use { socket ->
                    // Connect to the printer IP on port 9100
                    socket.connect(
                        InetSocketAddress(ipAddress, 9100),
                        2000
                    ) // Timeout for 2 seconds
                    val out: OutputStream = socket.getOutputStream()

                    // Prepare data to send (encode your data as needed)
                    val bytes = data.toByteArray(Charsets.US_ASCII)

                    // Send data
                    out.write(bytes)
                    out.flush()

                    // Optionally handle response or assume success
                    withContext(Dispatchers.Main) {
                        callback(true, "Success")
                    }
                }
            } catch (e: Exception) {
                // Handle exceptions, such as connection failures
                withContext(Dispatchers.Main) {
                    callback(false, "Failed to print: ${e.message}")
                }
            }
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        try {
            context.unregisterReceiver(discoveryReceiver)
            bluetoothSocket?.close()
        } catch (e: Exception) {
            e.printStackTrace()
        }
        channel.setMethodCallHandler(null)
    }
}
