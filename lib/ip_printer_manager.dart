import 'package:flutter/services.dart';

class IPPrinterManager {
  static const MethodChannel _channel = MethodChannel('native_bluetooth_print');

  static Future<List<String>> discoverIPPrinters() async {
    final List<dynamic> devices = await _channel.invokeMethod('discoverIPPrinters');
    return devices.cast<String>();
  }

  static Future<String> printToIPPrinter(String address, String data) async {
    try {
      final String result = await _channel.invokeMethod('printToWifiPrinter', {"ipAddress": address, "data": data});
      return result;
    } catch (e) {
      return e.toString();
    }
  }
}
