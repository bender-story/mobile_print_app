import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrintList extends StatelessWidget {
  final List<String> prints = [
    "Print Job 001",
    "Print Job 002",
    "Print Job 003",
    "Print Job 004",
    "Print Job 005",
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: prints.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(prints[index]),
          leading: Icon(Icons.print),
          trailing: Icon(Icons.arrow_forward),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}

