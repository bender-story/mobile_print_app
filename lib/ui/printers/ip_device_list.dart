import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/ip_printer_bloc.dart';
import 'bloc/ip_printer_event.dart';
import 'bloc/ip_printer_state.dart';

class IPDeviceList extends StatefulWidget {
  final String dataToPrint;

  const IPDeviceList({Key? key, required this.dataToPrint}) : super(key: key);

  @override
  _IPDeviceListState createState() => _IPDeviceListState();
}

class _IPDeviceListState extends State<IPDeviceList> {
  @override
  void initState() {
    super.initState();
    context.read<IPPrinterBloc>().add(FetchIPPrinters());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby IP Printers'),
      ),
      body: BlocConsumer<IPPrinterBloc, IPPrinterState>(
        listener: (context, state) {
          if (state is IPPrinterPrinted) {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Print Success'),
                content: Text(state.result),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is IPPrinterLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is IPPrintersLoaded) {
            return ListView.builder(
              itemCount: state.printers.length,
              itemBuilder: (context, index) {
                var printer = state.printers[index];
                return ListTile(
                  title: Text(printer),
                  leading: const Icon(Icons.print),
                  onTap: () => context.read<IPPrinterBloc>().add(
                      ConnectAndPrint(
                          deviceAddress: printer,
                          dataToPrint: widget.dataToPrint
                      )
                  ),
                );
              },
            );
          } else if (state is IPPrinterError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Start searching for IP printers...'));
        },
      ),
    );
  }
}
