import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'native_bluetooth_print_platform_interface.dart';

/// An implementation of [NativeBluetoothPrintPlatform] that uses method channels.
class MethodChannelNativeBluetoothPrint extends NativeBluetoothPrintPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('native_bluetooth_print');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
