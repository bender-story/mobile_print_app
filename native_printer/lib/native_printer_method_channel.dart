import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'native_printer_platform_interface.dart';

/// An implementation of [NativePrinterPlatform] that uses method channels.
class MethodChannelNativePrinter extends NativePrinterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('native_printer');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
