import 'package:flutter/services.dart';

class BluetoothPrinter {
  static const _channel = MethodChannel('native_printer');

  static Future<List<Map<String, String>>> discoverDevices() async {
    final List devices = await _channel.invokeMethod('discoverBluetoothPrinter');
    return devices.map((device) => Map<String, String>.from(device)).toList();
  }

  static Future<String?> printData(String address, String data) async {
    try {
      final String result = await _channel.invokeMethod('printToBluetoothPrinter', {"address": address, "data": data});
      return result;
    } catch (e) {
      return e.toString();
    }
  }
}
