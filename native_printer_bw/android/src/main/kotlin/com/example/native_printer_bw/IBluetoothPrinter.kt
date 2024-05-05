package com.example.native_printer_bw
import io.flutter.plugin.common.MethodChannel.Result
interface IBluetoothPrinter : Iprinter{
    fun discoverDevices(result: Result)
    fun connectToPrinter(address: String, data: String, result: Result)
    fun checkAndRequestPermissions(result: Result): Boolean
    fun closeConnection()
}