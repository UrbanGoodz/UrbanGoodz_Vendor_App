import 'dart:convert';
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:urban_goodz_vendor/repositories/vendor_repository.dart';
import 'package:urban_goodz_vendor/screens/inventory_screen.dart';
import 'package:urban_goodz_vendor/services/vendor_api_client.dart';

/// Regression test for: the vendor app's Inventory screen showed a correct
/// item count in the header but rendered no item cards, with no items and
/// without items alike. Root cause: the sort PopupMenuButton's Obx only read
/// c.sortBy.value inside itemBuilder, a callback PopupMenuButton invokes
/// lazily when the menu opens - never during Obx's own build pass - so Obx
/// registered zero subscriptions. GetX's "improper use of a GetX" throw for
/// that case took the whole screen's layout down with it.
class _FakeClient extends http.BaseClient {
  final Map<String, dynamic> body;
  _FakeClient(this.body);
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return http.StreamedResponse(
      Stream.value(utf8.encode(jsonEncode(body))),
      200,
      headers: {'content-type': 'application/json'},
    );
  }
}

Future<void> _useRealisticViewport(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('Inventory screen renders with zero items', (tester) async {
    Get.reset();
    await _useRealisticViewport(tester);
    final payload = <String, dynamic>{'total_size': 0, 'limit': '25', 'offset': '1', 'items': []};
    Get.put<VendorRepository>(VendorRepository(VendorApiClient(client: _FakeClient(payload))));

    await tester.pumpWidget(const GetMaterialApp(home: InventoryScreen()));
    await tester.pumpAndSettle();

    expect(find.text('0 items'), findsOneWidget);
    expect(find.text('No items found'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Inventory screen renders an item card for a real item', (tester) async {
    Get.reset();
    await _useRealisticViewport(tester);
    final payload = <String, dynamic>{
      'total_size': 1, 'limit': '25', 'offset': '1',
      'items': [
        {
          'id': 1530, 'name': 'Claude Audit Test Item', 'description': 'QA item',
          'category_id': 7, 'price': 1, 'status': 1, 'store_id': 286,
          'module_id': 4, 'stock': 100, 'is_approved': 1,
          'image_full_url': 'https://example.com/img.jpg',
        }
      ],
    };
    Get.put<VendorRepository>(VendorRepository(VendorApiClient(client: _FakeClient(payload))));

    await tester.pumpWidget(const GetMaterialApp(home: InventoryScreen()));
    await tester.pumpAndSettle();

    expect(find.text('1 items'), findsOneWidget);
    expect(find.text('Claude Audit Test Item'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
