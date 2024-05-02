import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'native_bluetooth_print_method_channel.dart';

abstract class NativeBluetoothPrintPlatform extends PlatformInterface {
  /// Constructs a NativeBluetoothPrintPlatform.
  NativeBluetoothPrintPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativeBluetoothPrintPlatform _instance = MethodChannelNativeBluetoothPrint();

  /// The default instance of [NativeBluetoothPrintPlatform] to use.
  ///
  /// Defaults to [MethodChannelNativeBluetoothPrint].
  static NativeBluetoothPrintPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NativeBluetoothPrintPlatform] when
  /// they register themselves.
  static set instance(NativeBluetoothPrintPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
