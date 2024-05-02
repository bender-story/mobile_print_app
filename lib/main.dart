import 'package:flutter/material.dart';
import 'package:mobile_printer_app/ui/bluetooth/bloc/bluetooth_bloc.dart';
import 'package:mobile_printer_app/ui/bluetooth/bluetooth_devices_list.dart';
import 'package:mobile_printer_app/ui/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_printer_app/ui/invoice/bloc/invoice_bloc.dart';
import 'package:mobile_printer_app/ui/invoice/invoice_page.dart';
import 'package:mobile_printer_app/ui/printers/bloc/ip_printer_bloc.dart';
import 'package:mobile_printer_app/ui/printers/bloc/ip_printer_state.dart';
import 'package:mobile_printer_app/ui/printers/ip_device_list.dart';


void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<InvoiceBloc>(
          create: (context) {
            return InvoiceBloc(); // Initialize your bloc with the Dio API client
          },
          child: InvoicePage(),
        ),
        BlocProvider<BluetoothBloc>(
          create: (context) {
            return BluetoothBloc(); // Initialize your bloc with the Dio API client
          },
          child: BluetoothDeviceList(dataToPrint: ""),
        ),
        BlocProvider<IPPrinterBloc>(
          create: (context) {
            return IPPrinterBloc(); // Initialize your bloc with the Dio API client
          },
          child: IPDeviceList(dataToPrint: ""),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}


