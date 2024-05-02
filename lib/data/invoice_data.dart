import 'item.dart';
import 'item_type.dart';

class InvoiceData {
  Map<ItemType, Item> items;
  final double gstRate;
  double subtotal;
  double gst;
  double total;

  InvoiceData({
    Map<ItemType, Item>? items,
    this.gstRate = 0.07,
    this.subtotal = 0.0,
    this.gst = 0.0,
    this.total = 0.0,
  }) : items = {
          ItemType.Shirts: Item(),
          ItemType.Trousers: Item(),
          ItemType.Shoes: Item(),
        };

  String toPrintableString() {
    var result = StringBuffer();
    items.forEach((type, item) {
      result.writeln('${type.name}: ${item.quantity} x ${type.unitPrice} = ${item.totalPrice}');
    });
    result.writeln('Subtotal: $subtotal');
    result.writeln('GST: $gst');
    result.writeln('--------------------------------');
    result.writeln('Total: $total');
    return result.toString();
  }
}
