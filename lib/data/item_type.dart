import 'package:flutter/material.dart';

enum ItemType { Shirts, Trousers, Shoes }

extension ItemTypeExtension on ItemType {
  double get unitPrice {
    switch (this) {
      case ItemType.Shirts:
        return 30.0; // Price for Shirts
      case ItemType.Trousers:
        return 40.0; // Price for Trousers
      case ItemType.Shoes:
        return 50.0; // Price for Shoes
      default:
        return 0.0;
    }
  }

  IconData get iconData {
    switch (this) {
      case ItemType.Shirts:
        return Icons.shopping_bag_outlined; // Price for Shirts
      case ItemType.Trousers:
        return Icons.terrain; // Price for Trousers
      case ItemType.Shoes:
        return Icons.directions_walk; // Price for Shoes
      default:
        return Icons.shopping_bag_outlined;
    }
  }
}
