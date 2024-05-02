import 'package:flutter/services.dart';

class BluetoothPrinter {
  static const _channel = MethodChannel('native_bluetooth_print');

  static Future<List<Map<String, String>>> discoverDevices() async {
    final List devices = await _channel.invokeMethod('discoverDevices');
    return devices.map((device) => Map<String, String>.from(device)).toList();
  }

  static Future<String> connect(String address, String data) async {
    final String result =
        await _channel.invokeMethod('connect', {"address": address, "data": data});
    return result;
  }

  // static Future<String> pair(String address, String data) async {
  //   final String result =
  //       await _channel.invokeMethod('pair', {"address": address, "data": data});
  //   return result;
  // }

  // static Future<String> print(String data) async {
  //   final String result = await _channel.invokeMethod('print', {"data": data});
  //   return result;
  // }

  static Future<String?> printData(String address, String data) async {
    try {
      // final String pairResult = await pair(address);
      // if (pairResult == 'paired') {
      final String result = await connect(address,data);
      // if (result == 'connected') {
      //   final String result = await print(data);
      //   return result;
      // }
      return result;
      // }
      // return pairResult;
    } catch (e) {
      return e.toString();
    }
  }
}
