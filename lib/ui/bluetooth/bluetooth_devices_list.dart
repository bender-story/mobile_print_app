import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_printer_app/utils/ui_utils.dart';

import 'bloc/bluetooth_bloc.dart';
import 'bloc/bluetooth_event.dart';
import 'bloc/bluetooth_state.dart';

class BluetoothDeviceList extends StatefulWidget {
  final String dataToPrint;

  const BluetoothDeviceList({Key? key, required this.dataToPrint})
      : super(key: key);

  @override
  _BluetoothDeviceListState createState() => _BluetoothDeviceListState();
}

class _BluetoothDeviceListState extends State<BluetoothDeviceList> {
  List<Map<String?, String?>> devices = [];
  String loaderText = "Searching for nearby devices...";

  @override
  void initState() {
    super.initState();
    context.read<BluetoothBloc>().add(FetchBluetoothDevices());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Bluetooth Devices'),
      ),
      body: BlocConsumer<BluetoothBloc, BluetoothState>(
        listener: (context, state) {
          if (state is BluetoothPrinted) {
            UiUtils.showSuccessDialog(context, state.result);
          } else if (state is BluetoothError) {
            UiUtils.showErrorDialog(context, state.message);
          } else if (state is BluetoothLoaded) {
            setState(() {
              devices = state.devices;
            });
          }
        },
        builder: (context, state) {
          if (state is BluetoothLoading) {
            return Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20,),
                Text(loaderText)
              ],
            ));
          } else {
            return _buildListView();
          }
        },
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        var device = devices[index];
        return ListTile(
          title: Text(device['name'] ?? 'Unknown Device'),
          subtitle: Text(device['address'] ?? 'No Address'),
          leading: const Icon(Icons.bluetooth),
          onTap: () {
            if (device['address']?.isNotEmpty ?? false) {
              setState(() {
                loaderText = "Printing data...";
              });
              context.read<BluetoothBloc>().add(ConnectAndPrint(
                  deviceAddress: device['address'] ?? '',
                  dataToPrint: widget.dataToPrint));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Device address is empty'),
                ),
              );
            }
          },
        );
      },
    );
  }
}
