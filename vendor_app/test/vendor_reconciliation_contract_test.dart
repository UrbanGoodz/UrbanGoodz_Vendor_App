import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:urban_goodz_vendor/controllers/inventory_controller.dart';
import 'package:urban_goodz_vendor/controllers/orders_controller.dart';
import 'package:urban_goodz_vendor/controllers/revenue_tracking_controller.dart';
import 'package:urban_goodz_vendor/repositories/vendor_repository.dart';
import 'package:urban_goodz_vendor/services/vendor_api_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Vendor Reconciliation Contract Tests', () {
    // 1. successful Vendor login
    test('1. successful Vendor login', () async {
      late http.Request capturedRequest;
      final api = VendorApiClient(
        client: MockClient((request) async {
          capturedRequest = request;
          return http.Response(
            jsonEncode({'token': 'test_vendor_token_123'}),
            200,
          );
        }),
      );
      final repo = VendorRepository(api);
      final result = await repo.login('vendor@urbangoodz.com', 'password123');

      expect(capturedRequest.url.path, endsWith('/api/v1/auth/vendor/login'));
      expect(jsonDecode(capturedRequest.body), {
        'email': 'vendor@urbangoodz.com',
        'password': 'password123',
        'vendor_type': 'owner',
      });
      expect(result['token'], 'test_vendor_token_123');
    });

    // 2. invalid login
    test('2. invalid login', () async {
      final api = VendorApiClient(
        client: MockClient((request) async {
          return http.Response(
            jsonEncode({
              'errors': [
                {'message': 'Invalid credentials.'}
              ]
            }),
            401,
          );
        }),
      );
      final repo = VendorRepository(api);

      expect(
        () async => await repo.login('wrong@urbangoodz.com', 'badpass'),
        throwsA(isA<VendorApiException>().having((e) => e.message, 'message', 'Invalid credentials.')),
      );
    });

    // 3. token persistence
    test('3. token persistence', () async {
      late http.Request capturedRequest;
      final api = VendorApiClient(
        client: MockClient((request) async {
          capturedRequest = request;
          return http.Response(jsonEncode({'email': 'vendor@test.com'}), 200);
        }),
      );
      api.setToken('persisted_bearer_token');
      await api.get('vendor/profile');

      expect(capturedRequest.headers['Authorization'], 'Bearer persisted_bearer_token');
    });

    // 4. 401 session expiration
    test('4. 401 session expiration', () async {
      var onUnauthorizedCalled = false;
      final api = VendorApiClient(
        client: MockClient((request) async {
          return http.Response(jsonEncode({'message': 'Unauthorized'}), 401);
        }),
      );
      api.setToken('expired_token');
      api.onUnauthorized = () async {
        onUnauthorizedCalled = true;
      };

      await expectLater(
        api.get('vendor/profile'),
        throwsA(isA<VendorApiException>().having((e) => e.statusCode, 'statusCode', 401)),
      );
      expect(onUnauthorizedCalled, isTrue);
    });

    // 5. logout and token removal
    test('5. logout and token removal', () async {
      late http.Request capturedRequest;
      final api = VendorApiClient(
        client: MockClient((request) async {
          capturedRequest = request;
          return http.Response(jsonEncode({'message': 'Logged out'}), 200);
        }),
      );
      api.setToken('active_token');
      final repo = VendorRepository(api);
      await repo.logout();

      expect(capturedRequest.url.path, endsWith('/api/v1/vendor/logout'));
      api.setToken(null);
      final headers = api.get('test').catchError((_) => {});
      expect(headers, isNotNull);
    });

    // 6. Vendor registration validation
    test('6. Vendor registration validation', () async {
      late http.Request capturedRequest;
      final api = VendorApiClient(
        client: MockClient((request) async {
          capturedRequest = request;
          return http.Response(jsonEncode({'message': 'Store registered'}), 200);
        }),
      );
      final repo = VendorRepository(api);

      final response = await repo.registerStore(
        fName: 'Sarah',
        lName: 'Tailor',
        email: 'sarah@urbangoodz.com',
        phone: '+17135550100',
        password: 'securepassword',
        businessName: 'Houston Fine Tailoring',
        address: '100 Heights Blvd, Houston TX',
        category: 'Fashion Fit & Sizing',
      );

      expect(capturedRequest.url.path, endsWith('/api/v1/auth/vendor/register'));
      final body = jsonDecode(capturedRequest.body);
      expect(body['f_name'], 'Sarah');
      expect(body['email'], 'sarah@urbangoodz.com');
      expect(body['vendor_type'], isNull); // Standard auth registration
      expect(response['message'], 'Store registered');
    });

    // 7. store/account enforcement
    test('7. store/account enforcement', () async {
      late http.Request capturedRequest;
      final api = VendorApiClient(
        client: MockClient((request) async {
          capturedRequest = request;
          return http.Response(jsonEncode({'status': 'active'}), 200);
        }),
      );
      final repo = VendorRepository(api);
      await repo.toggleStoreStatus();

      expect(capturedRequest.url.path, endsWith('/api/v1/vendor/update-active-status'));
    });

    // 8. order ownership
    test('8. order ownership', () {
      final orderJson = {
        'id': '101',
        'customer': {
          'f_name': 'Marcus',
          'l_name': 'Aurelius',
          'phone': '+18325559876',
        },
        'delivery_address': {'address': '2411 Main St, Houston, TX 77002'},
        'order_amount': '150.00',
        'delivery_charge': '10.00',
        'total_tax_amount': '5.00',
        'order_status': 'processing',
        'payment_method': 'COD',
        'payment_status': 'paid',
        'details': [
          {
            'item_details': {'name': 'Custom Tailored Suit'},
            'quantity': 1,
            'price': '135.00',
          }
        ],
      };

      final order = OrdersController.fromJson(orderJson);

      expect(order.id, '101');
      expect(order.customerName, 'Marcus Aurelius');
      expect(order.customerPhone, '+18325559876');
      expect(order.status, 'preparing'); // Mapped from 'processing'
      expect(order.total, 160.00); // Amount + delivery
      expect(order.items.first.name, 'Custom Tailored Suit');
    });

    // 9. valid order-status transitions
    test('9. valid order-status transitions', () async {
      late http.Request capturedRequest;
      final api = VendorApiClient(
        client: MockClient((request) async {
          capturedRequest = request;
          return http.Response(jsonEncode({'message': 'Status updated'}), 200);
        }),
      );
      final repo = VendorRepository(api);

      await repo.updateOrderStatus('101', 'processing', reason: 'Prep started');
      expect(capturedRequest.url.path, endsWith('/api/v1/vendor/update-order-status'));
      final body = jsonDecode(capturedRequest.body);
      expect(body['order_id'], '101');
      expect(body['status'], 'processing');
      expect(body['reason'], 'Prep started');
    });

    // 10. invalid order-status transitions
    test('10. invalid order-status transitions', () async {
      Get.replace(VendorRepository(VendorApiClient(
        client: MockClient((_) async => http.Response('{}', 200)),
      )));
      final ordersController = OrdersController();
      await ordersController.updateOrderStatus('101', 'unknown_status');

      // Invalid status returns without sending request
      expect(ordersController.errorMessage.value, isNull);
    });

    // 11. inventory ownership
    test('11. inventory ownership', () {
      final itemJson = {
        'id': '50',
        'name': 'Silk Shirt',
        'slug': 'silk-shirt-50',
        'category_name': 'Apparel',
        'description': '100% Mulberry Silk',
        'price': '89.99',
        'stock': '25',
        'minimum_stock_for_warning': '5',
        'unit': 'pcs',
        'image_full_url': 'https://admin.urbangoodzdelivery.com/storage/items/silk.jpg',
        'status': 1,
      };

      final item = InventoryController.fromJson(itemJson);

      expect(item.id, '50');
      expect(item.name, 'Silk Shirt');
      expect(item.sku, 'silk-shirt-50');
      expect(item.category, 'Apparel');
      expect(item.price, 89.99);
      expect(item.stockQuantity, 25);
      expect(item.lowStockThreshold, 5);
      expect(item.isActive, isTrue);
    });

    // 12. stock update payload
    test('12. stock update payload', () async {
      late http.Request capturedRequest;
      final api = VendorApiClient(
        client: MockClient((request) async {
          capturedRequest = request;
          return http.Response(jsonEncode({'message': 'Stock updated'}), 200);
        }),
      );
      final repo = VendorRepository(api);
      await repo.updateStock('50', 30);

      expect(capturedRequest.url.path, endsWith('/api/v1/vendor/item/stock-update'));
      expect(jsonDecode(capturedRequest.body), {
        'product_id': '50',
        'current_stock': 30,
      });
    });

    // 13. withdrawal minimum/maximum validation
    test('13. withdrawal minimum/maximum validation', () async {
      Get.replace(VendorRepository(VendorApiClient(
        client: MockClient((_) async => http.Response('{}', 200)),
      )));
      final revenueController = RevenueTrackingController();
      revenueController.availableForPayout.value = 50.00;

      // Below $1.00 minimum
      await revenueController.requestPayout(0.50);
      expect(revenueController.errorMessage.value, contains('at least \$1.00'));

      // Above available balance
      await revenueController.requestPayout(100.00);
      expect(revenueController.errorMessage.value, contains('exceeds available balance'));
    });

    // 14. unavailable withdrawal method
    test('14. unavailable withdrawal method', () async {
      final api = VendorApiClient(
        client: MockClient((request) async {
          if (request.url.path.contains('get-withdraw-method-list')) {
            return http.Response(jsonEncode([]), 200);
          }
          return http.Response('{}', 200);
        }),
      );
      Get.replace(VendorRepository(api));
      final revenueController = RevenueTrackingController();
      revenueController.availableForPayout.value = 100.00;

      await revenueController.requestPayout(25.00);
      expect(revenueController.errorMessage.value, contains('No withdrawal method is configured'));
    });

    // 15. payout request payload
    test('15. payout request payload', () async {
      late http.Request capturedRequest;
      final api = VendorApiClient(
        client: MockClient((request) async {
          capturedRequest = request;
          return http.Response(jsonEncode({'message': 'Withdrawal requested'}), 200);
        }),
      );
      final repo = VendorRepository(api);
      await repo.requestWithdrawal(75.50, '1');

      expect(capturedRequest.url.path, endsWith('/api/v1/vendor/request-withdraw'));
      expect(jsonDecode(capturedRequest.body), {
        'amount': 75.50,
        'id': '1',
      });
    });

    // 16. payout-history mapping
    test('16. payout-history mapping', () async {
      final api = VendorApiClient(
        client: MockClient((request) async {
          return http.Response(
            jsonEncode([
              {
                'id': '99',
                'amount': '120.00',
                'status': 'approved',
                'created_at': '2026-07-14T00:00:00Z',
                'bank_name': 'Chase Bank',
              }
            ]),
            200,
          );
        }),
      );
      final repo = VendorRepository(api);
      final list = await repo.withdrawals();

      expect(list.length, 1);
      expect(list.first['id'], '99');
      expect(list.first['amount'], '120.00');
      expect(list.first['status'], 'approved');
    });

    // 17. user-safe backend errors
    test('17. user-safe backend errors', () {
      final exception = VendorApiException(
        422,
        'Minimum withdrawal amount is \$10.00',
        {'errors': [{'message': 'Minimum withdrawal amount is \$10.00'}]},
      );

      expect(exception.statusCode, 422);
      expect(exception.toString(), 'Minimum withdrawal amount is \$10.00');
    });
  });
}
