package com.example.native_printer_bw

import android.util.Log
import kotlinx.coroutines.*
import java.io.IOException
import java.net.InetSocketAddress
import java.net.Socket
import io.flutter.plugin.common.MethodChannel.Result

class WifiPrinterImpl: IWifiPrinter {

    private val networkScope = CoroutineScope(Dispatchers.IO)
    override fun discoverPrinters(networkBase: String, result: Result) {
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
                        Log.d("ip printer", " $ipAddress")
                    }
                } catch (e: Exception) {
                    Log.e("BluetoothPlugin", "Failed to connect to $ipAddress: ${e.message}")
                }
            }
            withContext(Dispatchers.Main) {
                if (foundPrinters.isNotEmpty()) {
                    result.success(foundPrinters)
                } else {
                    result.error("NO_PRINTERS_FOUND", "No printers found on the network", null)
                }
            }
        }
    }

    override fun print(ipAddress: String, data: String, result: Result) {
        networkScope.launch {
            try {
                Socket().use { socket ->
                    socket.connect(InetSocketAddress(ipAddress, 9100), 10000)  // 10-second timeout
                    Log.d("PrinterConnection", "Connected to $ipAddress")
                    val out = socket.getOutputStream()
                    out.write(data.toByteArray(Charsets.US_ASCII))
                    out.flush()
                    Log.d("PrinterData", "Data sent to printer")

                    // Read response from the printer
                    val input = socket.getInputStream()
                    val response = ByteArray(1024)
                    val bytesRead = input.read(response)
                    val responseString = String(response, 0, bytesRead)
                    Log.d("PrinterResponse", "Received from printer: $responseString")

                    withContext(Dispatchers.Main) {
                        if (bytesRead > 0) {
                            result.success("Print successful: $responseString")
                        } else {
                            result.success("Data sent, but no response from printer")
                        }
                    }
                }
            } catch (e: IOException) {
                Log.e("PrinterError", "Failed to print: ${e.message}")
                withContext(Dispatchers.Main) {
                    result.error("PRINT_FAILED", "Failed to print: ${e.message}", null)
                }
            }
        }
    }
}