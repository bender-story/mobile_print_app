import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'native_printer_bw_platform_interface.dart';

/// An implementation of [NativePrinterBwPlatform] that uses method channels.
class MethodChannelNativePrinterBw extends NativePrinterBwPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('native_printer_bw');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
