import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'native_printer_method_channel.dart';

abstract class NativePrinterPlatform extends PlatformInterface {
  /// Constructs a NativePrinterPlatform.
  NativePrinterPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativePrinterPlatform _instance = MethodChannelNativePrinter();

  /// The default instance of [NativePrinterPlatform] to use.
  ///
  /// Defaults to [MethodChannelNativePrinter].
  static NativePrinterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NativePrinterPlatform] when
  /// they register themselves.
  static set instance(NativePrinterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
