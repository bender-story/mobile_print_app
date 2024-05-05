package com.example.native_printer_bw

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
import io.flutter.plugin.common.MethodChannel.Result
import android.util.Log

class WifiIppPrinterImpl : IWifiPrinter {
    private val networkScope = CoroutineScope(Dispatchers.IO)
    override fun discoverPrinters(networkBase: String, result: Result) {
        networkScope.launch {
            val foundPrinters = mutableListOf<String>()
            for (i in 1..254) {
                val ipAddress = "$networkBase.$i"
                try {
                    Socket().use { socket ->
                        socket.connect(
                            InetSocketAddress(ipAddress, 631),
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
            val tempFile = Files.createTempFile("printData", ".txt").toFile().apply {
                writeText(data, Charsets.UTF_8)
            }

            try {
                val printerUrl = URI("ipp://$ipAddress:631/ipp/print")
                val ippPrinter = IppPrinter(printerUrl)
                val printJob = ippPrinter.printJob(
                    tempFile,
                    DocumentFormat("application/octet-stream"), // Use 'application/octet-stream' for binary data
                    copies(1),
                    jobName("FlutterPrintJob"),
                    printerResolution(600, IppResolution.Unit.DPI),
                    Sides.OneSided,
                    ColorMode.Color,
                    PrintQuality.High,
                    Media.ISO_A4
                )

                printJob.waitForTermination()
                withContext(Dispatchers.Main) {
                    result.success("Print job completed successfully")
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.error("PRINT_FAILED", "Failed to print: ${e.message}", null)
                }
            } finally {
                Files.deleteIfExists(tempFile.toPath())
            }
        }
    }
}