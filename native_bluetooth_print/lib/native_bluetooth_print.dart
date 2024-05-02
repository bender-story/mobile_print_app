
import 'native_bluetooth_print_platform_interface.dart';

class NativeBluetoothPrint {
  Future<String?> getPlatformVersion() {
    return NativeBluetoothPrintPlatform.instance.getPlatformVersion();
  }
}
