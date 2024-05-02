import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPrintPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Print Custom Text',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            maxLines: 20,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Trigger the print functionality
              print('Printing...');
            },
            child: Text('Print'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrangeAccent,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50), // Set minimum width and height
            ),
          ),
        ],
      ),
    );
  }
}