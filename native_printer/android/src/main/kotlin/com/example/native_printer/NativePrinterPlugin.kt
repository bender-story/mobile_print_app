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

class NativePrinterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var result: Result? = null
    private var bluetoothPrinter: IBluetoothPrinter? = null

    private lateinit var context: Context

    private val REQUEST_BLUETOOTH_PERMISSIONS_CODE = 100

    private val networkScope = CoroutineScope(Dispatchers.IO)
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "native_printer")
        context = flutterPluginBinding.applicationContext
        channel.setMethodCallHandler(this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        bluetoothPrinter = BluetoothPrinterImpl(context, activity!!)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        this.result = result
        when (call.method) {
            "discoverBluetoothPrinter" -> bluetoothPrinter!!.discoverDevices(result)
            "printToBluetoothPrinter" -> {
                val address: String = call.argument("address") ?: ""
                val data: String = call.argument("data") ?: ""
                if (address != null) {
                    bluetoothPrinter!!.connectToPrinter(address, data, result)
                } else {
                    result.error("NO_ADDRESS", "Bluetooth address is required", null)
                }
            }

            "discoverWifiPrinters" -> {
                val networkBase = call.argument<String>("networkBase") ?: "192.168.50"
                val wifiPrinter = WifiIppPrinterImpl()
                wifiPrinter.discoverPrinters(networkBase, result)
            }

            "printToWifiPrinter" -> {
                val ipAddress = call.argument<String>("ipAddress")
                val data = call.argument<String>("data")
                val wifiPrinter = WifiIppPrinterImpl()
                if (ipAddress != null && data != null) {
                    wifiPrinter.print(ipAddress, data, result)
                } else {
                    result.error("INVALID_ARGUMENTS", "Invalid or missing arguments", null)
                }
            }

            else -> result.notImplemented()
        }
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
            bluetoothPrinter?.closeConnection()
        } catch (e: Exception) {
            e.printStackTrace()
        }
        channel.setMethodCallHandler(null)
    }
}

