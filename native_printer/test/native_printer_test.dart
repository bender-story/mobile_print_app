import 'package:flutter_test/flutter_test.dart';
import 'package:native_printer/native_printer.dart';
import 'package:native_printer/native_printer_platform_interface.dart';
import 'package:native_printer/native_printer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNativePrinterPlatform
    with MockPlatformInterfaceMixin
    implements NativePrinterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NativePrinterPlatform initialPlatform = NativePrinterPlatform.instance;

  test('$MethodChannelNativePrinter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNativePrinter>());
  });

  test('getPlatformVersion', () async {
    NativePrinter nativePrinterPlugin = NativePrinter();
    MockNativePrinterPlatform fakePlatform = MockNativePrinterPlatform();
    NativePrinterPlatform.instance = fakePlatform;

    expect(await nativePrinterPlugin.getPlatformVersion(), '42');
  });
}
