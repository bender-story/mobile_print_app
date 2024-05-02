abstract class IPPrinterState {}

class IPPrinterInitial extends IPPrinterState {}

class IPPrinterLoading extends IPPrinterState {}

class IPPrintersLoaded extends IPPrinterState {
  final List<String> printers;
  IPPrintersLoaded(this.printers);
}

class IPPrinterError extends IPPrinterState {
  final String message;
  IPPrinterError(this.message);
}

class IPPrinterPrinted extends IPPrinterState {
  final String result;
  IPPrinterPrinted(this.result);
}
