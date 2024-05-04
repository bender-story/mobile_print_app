import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mobile_printer_app/data/item_type.dart';

void main() {
  group('ItemType iconData', () {
    test('returns correct icon for Shirts', () {
      expect(ItemType.Shirts.iconData, Icons.shopping_bag_outlined);
    });

    test('returns correct icon for Trousers', () {
      expect(ItemType.Trousers.iconData, Icons.terrain);
    });

    test('returns correct icon for Shoes', () {
      expect(ItemType.Shoes.iconData, Icons.directions_walk);
    });
  });

  group('ItemType unitPrice', () {
    test('returns correct price for Shirts', () {
      expect(ItemType.Shirts.unitPrice, 30.0);
    });

    test('returns correct price for Trousers', () {
      expect(ItemType.Trousers.unitPrice, 40.0);
    });

    test('returns correct price for Shoes', () {
      expect(ItemType.Shoes.unitPrice, 50.0);
    });
  });
}
