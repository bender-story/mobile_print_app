import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_printer_app/ui/custom_print_page.dart';
import 'package:mobile_printer_app/ui/invoice/invoice_page.dart';
import 'package:mobile_printer_app/ui/print_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    InvoicePage(),
    CustomPrintPage(),
    PrintList()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Printer App'),
        centerTitle: true,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Invoice',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.print),
            label: 'Custom Print',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Previous Prints',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}