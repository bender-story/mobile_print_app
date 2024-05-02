import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_printer_app/ip_printer_manager.dart';

import 'ip_printer_event.dart';
import 'ip_printer_state.dart';

class IPPrinterBloc extends Bloc<IPPrinterEvent, IPPrinterState> {
  IPPrinterBloc() : super(IPPrinterInitial()) {
    on<FetchIPPrinters>(_onFetchIPPrinters);
    on<ConnectAndPrint>(_onConnectAndPrint);
  }

  Future<void> _onFetchIPPrinters(FetchIPPrinters event, Emitter<IPPrinterState> emit) async {
    emit(IPPrinterLoading());
    try {
      List<String> printers = await IPPrinterManager.discoverIPPrinters();
      emit(IPPrintersLoaded(printers));
    } catch (e) {
      emit(IPPrinterError("Failed to fetch printers"));
    }
  }

  Future<void> _onConnectAndPrint(ConnectAndPrint event, Emitter<IPPrinterState> emit) async {
    String result =await IPPrinterManager.printToIPPrinter(event.deviceAddress, event.dataToPrint);
    if(result == "Success") {
      emit(IPPrinterPrinted("Print successful to ${event.deviceAddress}"));
    }
      else {
      emit(IPPrinterError(result));
    }
  }
}
