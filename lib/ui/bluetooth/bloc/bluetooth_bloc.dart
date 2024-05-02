import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_printer_app/bluetooth_print.dart';

import 'bluetooth_event.dart';
import 'bluetooth_state.dart';

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothState> {
  BluetoothBloc() : super(BluetoothInitial()) {
    on<FetchBluetoothDevices>(_onFetchBluetoothDevices);
    on<ConnectAndPrint>(_onConnectAndPrint);
  }

  Future<void> _onFetchBluetoothDevices(FetchBluetoothDevices event, Emitter<BluetoothState> emit) async {
    emit(BluetoothLoading());
    try {
      List<Map<String, String>> devices = await BluetoothPrinter.discoverDevices();
      emit(BluetoothLoaded(devices));
    } catch (e) {
      emit(BluetoothError('Failed to fetch devices'));
    }
  }

  Future<void> _onConnectAndPrint(ConnectAndPrint event, Emitter<BluetoothState> emit) async {
    emit(BluetoothLoading());
    try {
      String? result = await BluetoothPrinter.printData(event.deviceAddress, event.dataToPrint);
      if(result == "Success"){
        emit(BluetoothPrinted(result ?? 'Success'));
      }else{
        emit(BluetoothError(result ?? 'Failed to print data'));
        return;
      }
    } catch (e) {
      emit(BluetoothError('Failed to fetch devices'));
    }
  }
}
