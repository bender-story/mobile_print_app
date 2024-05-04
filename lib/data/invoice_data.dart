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

  String toPrintableString(String invoiceNumber) {
    var result = StringBuffer();
    result.writeln('            YOUR STORE NAME');
    result.writeln('          Address Line 1, City');
    result.writeln('      Tel: 123-456-7890  Email: info@yourstore.com');
    result.writeln('------------------------------------------------');
    result.writeln('           Receipt #: $invoiceNumber');
    result.writeln('           Date: 2024-05-03');
    result.writeln('           Time: 14:35:22');
    result.writeln('------------------------------------------------');

    // Header for item details
    result.writeln('Item                Quantity    Unit Price    Total');
    result.writeln('------------------------------------------------');
    items.forEach((type, item) {
      result.write('${type.name}'.padRight(20));
      result.write('${item.quantity} x'.padRight(12));
      result.write('\$${type.unitPrice}'.padRight(12));
      result.writeln('= \$${item.totalPrice}');
    });

    result.writeln('------------------------------------------------');
    result.writeln('Subtotal:'.padRight(31) + '\$${subtotal}');
    result.writeln('GST (5%):'.padRight(30) + '\$${gst}');
    result.writeln('------------------------------------------------');
    result.writeln('Total:'.padRight(33) + '\$${total}');
    result.writeln('------------------------------------------------');
    result.writeln('Payment Method:'.padRight(30) + 'Visa Ending in 4242');
    result.writeln('Authorized Code:'.padRight(30) + '123456');
    result.writeln('------------------------------------------------');
    result.writeln('               CUSTOMER COPY');
    result.writeln('          THANK YOU FOR YOUR VISIT!');
    result.writeln('               HAVE A GREAT DAY!');
    return result.toString();
  }
}
