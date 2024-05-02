import 'package:flutter/material.dart';

class ProductRow extends StatelessWidget {
  final IconData iconData;
  final String productName;
  final double cost;
  final int quantity;
  final void Function(String) onQuantityChanged;

  const ProductRow({
    Key? key,
    required this.iconData,
    required this.productName,
    required this.cost,
    required this.quantity,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Icon(
              iconData,
              size: 30, // Size of the icon
              color: Colors
                  .blue, // Color of the icon, you can customize this as needed
            ),
            SizedBox(width: 10),
            Expanded(child: Text(productName, style: TextStyle(fontWeight: FontWeight.bold),)),
            SizedBox(width: 10),
            Expanded(child: Text('\$${cost.toStringAsFixed(2)}')),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: quantity.toString()),
                decoration: InputDecoration(
                  hintText: 'Qty',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                onChanged: onQuantityChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
