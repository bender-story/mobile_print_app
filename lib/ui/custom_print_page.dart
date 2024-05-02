import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/ui_utils.dart';

class CustomPrintPage extends StatelessWidget {
  TextEditingController controller = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            keyboardType: TextInputType.text,
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Print Custom Text',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            maxLines: 20,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if(controller.text.isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter some text to print'),
                  ),
                );
              } else {
                UiUtils.showPrintOptions(context, controller.text);
              }
            },
            child: Text('Print'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrangeAccent,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}