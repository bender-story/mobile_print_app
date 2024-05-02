import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  final String textOne;
  final String textTwo;

  const CustomRow({
    Key? key,
    required this.textOne,
    required this.textTwo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(textOne),
        const SizedBox(width: 10),
        Text(
          textTwo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
