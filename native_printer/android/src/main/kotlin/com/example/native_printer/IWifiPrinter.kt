package com.example.native_printer

import io.flutter.plugin.common.MethodChannel.Result

interface IWifiPrinter: Iprinter {
    fun discoverPrinters(networkBase: String, result: Result)

    fun print(ipAddress: String, data: String, result: Result)
}