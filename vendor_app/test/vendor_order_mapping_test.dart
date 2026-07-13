import 'package:flutter_test/flutter_test.dart';
import 'package:urban_goodz_vendor/controllers/orders_controller.dart';

void main() {
  test(
    'real backend order JSON maps status, customer, totals, and details',
    () {
      final order = OrdersController.fromJson({
        'id': 77,
        'order_status': 'processing',
        'order_amount': '25.50',
        'delivery_charge': '4.50',
        'payment_method': 'cash_on_delivery',
        'payment_status': 'unpaid',
        'created_at': '2026-07-12T12:00:00Z',
        'customer': {
          'f_name': 'Test',
          'l_name': 'Customer',
          'phone': 'redacted',
        },
        'delivery_address': {'address': 'Authorized test address'},
        'details': [
          {
            'quantity': 2,
            'price': '12.75',
            'item_details': {'name': 'Test item'},
          },
        ],
      });

      expect(order.id, '77');
      expect(order.status, 'preparing');
      expect(order.customerName, 'Test Customer');
      expect(order.total, 30);
      expect(order.items.single.name, 'Test item');
      expect(order.items.single.quantity, 2);
    },
  );
}
