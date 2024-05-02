abstract class BluetoothEvent {}

class FetchBluetoothDevices extends BluetoothEvent {}

class ConnectAndPrint extends BluetoothEvent {
  final String deviceAddress;
  final String dataToPrint;

    ConnectAndPrint({required this.deviceAddress,required this.dataToPrint});
}
