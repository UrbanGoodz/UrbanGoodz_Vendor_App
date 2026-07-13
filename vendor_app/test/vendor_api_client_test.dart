import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:urban_goodz_vendor/services/vendor_api_client.dart';

void main() {
  test('authenticated requests include the Vendor bearer contract', () async {
    late http.Request captured;
    final client = MockClient((request) async {
      captured = request;
      return http.Response(jsonEncode({'ok': true}), 200);
    });
    final api = VendorApiClient(client: client)..setToken('test-token');

    await api.put(
      'vendor/update-order-status',
      body: {'order_id': '42', 'status': 'processing'},
    );

    expect(captured.method, 'PUT');
    expect(captured.headers['authorization'], 'Bearer test-token');
    expect(captured.headers['vendorType'], 'owner');
    expect(jsonDecode(captured.body)['status'], 'processing');
  });

  test('API errors preserve safe backend account-state messages', () async {
    final client = MockClient(
      (_) async => http.Response(
        jsonEncode({
          'errors': [
            {'code': 'auth-002', 'message': 'Vendor approval is pending.'},
          ],
        }),
        403,
      ),
    );
    final api = VendorApiClient(client: client);

    expect(
      () => api.post(
        'auth/vendor/login',
        body: {
          'email': 'vendor@example.test',
          'password': 'not-a-real-password',
        },
      ),
      throwsA(
        isA<VendorApiException>().having(
          (error) => error.message,
          'message',
          'Vendor approval is pending.',
        ),
      ),
    );
  });
}
