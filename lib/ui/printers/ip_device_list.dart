import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_printer_app/utils/ui_utils.dart';

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
  List<String> printers = [];
  String loaderText = "Searching for nearby printers, this may take a while...";
  TextEditingController ipController = TextEditingController();
  bool searchingPrinters = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby IP Printers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!searchingPrinters)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: ipController,
                      decoration: InputDecoration(
                        hintText: 'Enter IP Address',
                        labelText: 'IP Address',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String ipAddress = ipController.text.trim();
                      if (ipAddress.isNotEmpty) {
                        setState(() {
                          loaderText = "Printing data...";
                        });
                        context.read<IPPrinterBloc>().add(
                              ConnectAndPrint(
                                deviceAddress: ipAddress,
                                dataToPrint: widget.dataToPrint,
                              ),
                            );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter IP address'),
                          ),
                        );
                      }
                    },
                    child: const Text('Print'),
                  ),
                ],
              ),
            if (!searchingPrinters)...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    searchingPrinters = true;
                    loaderText = "Searching for nearby printers...";
                  });
                  context.read<IPPrinterBloc>().add(FetchIPPrinters());
                },
                child: Text('Search for Nearby Printers'),
              ),
            ],
            if (searchingPrinters)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      Text(loaderText),
                    ],
                  ),
                ),
              ),
            if (!searchingPrinters)
              Expanded(
                child: BlocConsumer<IPPrinterBloc, IPPrinterState>(
                  listener: (context, state) {
                    if (state is IPPrinterPrinted) {
                      UiUtils.showSuccessDialog(context, state.result);
                    } else if (state is IPPrinterError) {
                      UiUtils.showErrorDialog(context, state.message);
                    } else if (state is IPPrintersLoaded) {
                      setState(() {
                        printers = state.printers;
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is IPPrinterLoading) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 20),
                            Text(loaderText),
                          ],
                        ),
                      );
                    } else {
                      return _buildListView();
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: printers.length,
      itemBuilder: (context, index) {
        var printer = printers[index];
        return ListTile(
          title: Text(printer),
          leading: const Icon(Icons.print),
          onTap: () {
            setState(() {
              loaderText = "Printing data...";
            });
            context.read<IPPrinterBloc>().add(
                  ConnectAndPrint(
                    deviceAddress: printer,
                    dataToPrint: widget.dataToPrint,
                  ),
                );
          },
        );
      },
    );
  }
}
