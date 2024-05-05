
import 'native_printer_bw_platform_interface.dart';

class NativePrinterBw {
  Future<String?> getPlatformVersion() {
    return NativePrinterBwPlatform.instance.getPlatformVersion();
  }
}
