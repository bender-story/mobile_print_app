import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_printer_app/data/invoice_data.dart';
import 'package:mobile_printer_app/data/item.dart';
import 'package:mobile_printer_app/data/item_type.dart';


void main() {
  group('InvoiceData', () {
    test('toPrintableString outputs correctly formatted receipt', () {
      var invoice = InvoiceData(items: {
        ItemType.Shirts: Item(quantity: 2, totalPrice: 60.0),
        ItemType.Trousers: Item(quantity: 1, totalPrice: 40.0),
        ItemType.Shoes: Item(quantity: 3, totalPrice: 150.0)
      });
      invoice.subtotal = 250.0;
      invoice.gst = invoice.subtotal * 0.07;
      invoice.total = invoice.subtotal + invoice.gst;

      String result = invoice.toPrintableString('12345');

      var lines = result.split('\n');

      expect(lines[0].trim(), 'YOUR STORE NAME');
      expect(lines[2].trim(), 'Tel: 123-456-7890  Email: info@yourstore.com');
      expect(lines[4].contains('Receipt #: 12345'), true);
      expect(lines[5].contains('Date: 2024-05-03'), true);
      expect(lines[8].contains('Item'), true);
      expect(lines[10].contains('Shirts'), true);
      expect(lines[11].contains('Trousers'), true);
      expect(lines[12].contains('Shoes'), true);
      expect(lines[14].contains('Subtotal:'), true);
      expect(lines[15].contains('GST (5%):'), true);
      expect(lines[17].contains('Total:'), true);
      expect(lines[19].contains('Payment Method:'), true);
    });
  });
}
