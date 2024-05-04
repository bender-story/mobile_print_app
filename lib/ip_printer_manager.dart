import 'package:flutter/services.dart';

class IPPrinterManager {
  static const MethodChannel _channel = MethodChannel('native_printer');

  static Future<List<String>> discoverIPPrinters() async {
    final List<dynamic> devices = await _channel.invokeMethod('discoverWifiPrinters');
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
