import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'native_printer_bw_method_channel.dart';

abstract class NativePrinterBwPlatform extends PlatformInterface {
  /// Constructs a NativePrinterBwPlatform.
  NativePrinterBwPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativePrinterBwPlatform _instance = MethodChannelNativePrinterBw();

  /// The default instance of [NativePrinterBwPlatform] to use.
  ///
  /// Defaults to [MethodChannelNativePrinterBw].
  static NativePrinterBwPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NativePrinterBwPlatform] when
  /// they register themselves.
  static set instance(NativePrinterBwPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
