
import 'native_printer_platform_interface.dart';

class NativePrinter {
  Future<String?> getPlatformVersion() {
    return NativePrinterPlatform.instance.getPlatformVersion();
  }
}
