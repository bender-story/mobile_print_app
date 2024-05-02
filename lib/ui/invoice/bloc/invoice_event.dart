
import 'package:mobile_printer_app/data/item_type.dart';

abstract class InvoiceEvent {}
class UpdateQuantity extends InvoiceEvent {
  final ItemType itemType;
  final int quantity;
  UpdateQuantity(this.itemType, this.quantity);
}