import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            _showSuccessDialog(state.result);
          }
        },
        builder: (context, state) {
          if (state is BluetoothLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BluetoothLoaded) {
            return ListView.builder(
              itemCount: state.devices.length,
              itemBuilder: (context, index) {
                var device = state.devices[index];
                return ListTile(
                  title: Text(device['name'] ?? 'Unknown Device'),
                  subtitle: Text(device['address'] ?? 'No Address'),
                  leading: const Icon(Icons.bluetooth),
                  onTap: () {
                    if (device['address']?.isNotEmpty ?? false) {
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
          } else if (state is BluetoothError) {
            return Center(child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Text(state.message),
            ));
          }
          return const Center(child: Text('Start searching for devices...'));
        },
      ),
    );
  }

  void _showSuccessDialog(String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Print Success'),
          content: Text(result),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
