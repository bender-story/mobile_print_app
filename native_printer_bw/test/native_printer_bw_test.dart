import 'package:flutter_test/flutter_test.dart';
import 'package:native_printer_bw/native_printer_bw.dart';
import 'package:native_printer_bw/native_printer_bw_platform_interface.dart';
import 'package:native_printer_bw/native_printer_bw_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNativePrinterBwPlatform
    with MockPlatformInterfaceMixin
    implements NativePrinterBwPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NativePrinterBwPlatform initialPlatform = NativePrinterBwPlatform.instance;

  test('$MethodChannelNativePrinterBw is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNativePrinterBw>());
  });

  test('getPlatformVersion', () async {
    NativePrinterBw nativePrinterBwPlugin = NativePrinterBw();
    MockNativePrinterBwPlatform fakePlatform = MockNativePrinterBwPlatform();
    NativePrinterBwPlatform.instance = fakePlatform;

    expect(await nativePrinterBwPlugin.getPlatformVersion(), '42');
  });
}
