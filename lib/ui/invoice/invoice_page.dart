import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_printer_app/bluetooth_print.dart';
import 'package:mobile_printer_app/data/item_type.dart';
import 'package:mobile_printer_app/ui/bluetooth/bluetooth_devices_list.dart';
import 'package:mobile_printer_app/ui/custom_ui/custom_row.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/invoice_data.dart';
import '../../utils/app_utils.dart';
import '../custom_ui/loading_indicator.dart';
import '../custom_ui/product_row.dart';
import 'bloc/invoice_bloc.dart';
import 'bloc/invoice_event.dart';
import 'bloc/invoice_state.dart';

class InvoicePage extends StatefulWidget {
  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final String _invoiceNumber =
      AppUtils.generateRandomFiveDigitNumber().toString();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceBloc, InvoiceState>(
      builder: (context, state) {
        InvoiceData invoiceData = state.invoiceData;
        List<Widget> productRows = invoiceData.items.entries.map((entry) {
          return ProductRow(
            iconData: entry.key.iconData,
            productName: entry.key.name,
            cost: entry.value.totalPrice,
            quantity: entry.value.quantity,
            onQuantityChanged: (value) {
              int quantity = 0;
              if (value.isNotEmpty) {
                quantity = int.tryParse(value) ?? 0;
              }
              context
                  .read<InvoiceBloc>()
                  .add(UpdateQuantity(entry.key, quantity));
            },
          );
        }).toList();
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: productRows,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      CustomRow(
                          textOne: 'Invoice Number: ', textTwo: _invoiceNumber),
                      const SizedBox(height: 10),
                      CustomRow(
                          textOne: 'Subtotal: ',
                          textTwo:
                              '\$${invoiceData.subtotal.toStringAsFixed(2)}'),
                      CustomRow(
                          textOne: 'GST (7%): ',
                          textTwo: '\$${invoiceData.gst.toStringAsFixed(2)}'),
                      const SizedBox(height: 10),
                      const Divider(height: 1.0),
                      const SizedBox(height: 10),
                      CustomRow(
                          textOne: 'Total: ',
                          textTwo: '\$${invoiceData.total.toStringAsFixed(2)}'),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BluetoothDeviceList(dataToPrint: invoiceData.toPrintableString()),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrangeAccent,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Print'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
