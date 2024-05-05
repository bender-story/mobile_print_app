import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_printer_bw/native_printer_bw_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelNativePrinterBw platform = MethodChannelNativePrinterBw();
  const MethodChannel channel = MethodChannel('native_printer_bw');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
