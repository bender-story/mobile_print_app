import 'package:bloc/bloc.dart';
import 'package:mobile_printer_app/data/item_type.dart';

import '../../../data/invoice_data.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final InvoiceData _invoiceData = InvoiceData();

  InvoiceBloc() : super(InvoiceState(InvoiceData())) {
    on<UpdateQuantity>(_handleUpdateQuantity);
  }

  void _handleUpdateQuantity(UpdateQuantity event, Emitter<InvoiceState> emit) {
    var item = _invoiceData.items[event.itemType];
    if (item != null) {
      item.quantity = event.quantity;
      item.totalPrice = item.quantity * event.itemType.unitPrice;
    }

    _calculateTotals();

    emit(InvoiceState(_invoiceData));
  }

  void _calculateTotals() {
    _invoiceData.subtotal = _invoiceData.items.values.fold(0, (prev, item) => prev + item.totalPrice);
    _invoiceData.gst = _invoiceData.subtotal * _invoiceData.gstRate;
    _invoiceData.total = _invoiceData.subtotal + _invoiceData.gst;
  }
}