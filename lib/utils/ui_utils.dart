import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ui/bluetooth/bluetooth_devices_list.dart';
import '../ui/printers/ip_device_list.dart';

class UiUtils{
  static void printViaBluetooth(BuildContext context, String data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BluetoothDeviceList(dataToPrint: data),
      ),
    );
  }

  static void printViaNetwork(BuildContext context, String data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => IPDeviceList(dataToPrint: data),
      ),
    );
  }

  static void showPrintOptions(BuildContext context, String data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Print Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider(),
              SizedBox(height: 20,),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    printViaBluetooth(context, data); // Trigger Bluetooth printing
                  },
                  child: const Text('Bluetooth'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  )
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    printViaNetwork(context, data); // Trigger Network printing
                  },
                  child: const Text('Network'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  )
              ),
            ],
          ),
        );
      },
    );
  }
}