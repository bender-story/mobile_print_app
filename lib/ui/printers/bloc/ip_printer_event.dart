abstract class IPPrinterEvent {}

class FetchIPPrinters extends IPPrinterEvent {}

class ConnectAndPrint extends IPPrinterEvent {
  final String deviceAddress;
  final String dataToPrint;

  ConnectAndPrint({required this.deviceAddress, required this.dataToPrint});
}
