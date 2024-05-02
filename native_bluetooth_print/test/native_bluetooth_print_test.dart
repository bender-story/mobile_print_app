import 'package:flutter_test/flutter_test.dart';
import 'package:native_bluetooth_print/native_bluetooth_print.dart';
import 'package:native_bluetooth_print/native_bluetooth_print_platform_interface.dart';
import 'package:native_bluetooth_print/native_bluetooth_print_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNativeBluetoothPrintPlatform
    with MockPlatformInterfaceMixin
    implements NativeBluetoothPrintPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NativeBluetoothPrintPlatform initialPlatform = NativeBluetoothPrintPlatform.instance;

  test('$MethodChannelNativeBluetoothPrint is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNativeBluetoothPrint>());
  });

  test('getPlatformVersion', () async {
    NativeBluetoothPrint nativeBluetoothPrintPlugin = NativeBluetoothPrint();
    MockNativeBluetoothPrintPlatform fakePlatform = MockNativeBluetoothPrintPlatform();
    NativeBluetoothPrintPlatform.instance = fakePlatform;

    expect(await nativeBluetoothPrintPlugin.getPlatformVersion(), '42');
  });
}
