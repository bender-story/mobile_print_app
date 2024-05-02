abstract class BluetoothState {}

class BluetoothInitial extends BluetoothState {}

class BluetoothLoading extends BluetoothState {}

class BluetoothLoaded extends BluetoothState {
  final List<Map<String?, String?>> devices;
  BluetoothLoaded(this.devices);
}

class BluetoothPrinted extends BluetoothState {
  final String result;
  BluetoothPrinted(this.result);
}

class BluetoothError extends BluetoothState {
  final String message;
  BluetoothError(this.message);
}
