import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:urban_goodz_vendor/controllers/dashboard_controller.dart';
import 'package:urban_goodz_vendor/repositories/vendor_repository.dart';
import 'package:urban_goodz_vendor/services/vendor_api_client.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  tearDown(Get.reset);

  VendorRepository repositoryReturning(Object? body, {int status = 200}) {
    return VendorRepository(
      VendorApiClient(
        client: MockClient(
          (_) async => http.Response(jsonEncode(body), status),
        ),
      ),
    );
  }

  test('generateBrief success populates brief state', () async {
    final repository = repositoryReturning({
      'success': true,
      'brief': {
        'success': true,
        'brief': {
          'greeting': 'Good morning!',
          'todays_outlook': '12 orders so far today.',
          'key_metrics': [
            {'label': 'Orders Today', 'value': '12', 'status': 'good'},
          ],
          'action_items': ['Accept pending orders'],
          'revenue_forecast': 'Up from last week.',
          'staff_recommendations': [],
          'summary': 'Summary.',
        },
        'metrics': {},
      },
    });
    Get.put<VendorRepository>(repository);

    final controller = DashboardController();
    await controller.generateBrief();

    expect(controller.isGeneratingBrief.value, isFalse);
    expect(controller.briefError.value, isNull);
    expect(controller.brief.value, isNotNull);
    expect(controller.brief.value!.success, isTrue);
    expect(controller.brief.value!.greeting, 'Good morning!');
    expect(controller.brief.value!.keyMetrics, hasLength(1));
  });

  test('generateBrief service failure sets error state', () async {
    final repository = repositoryReturning({
      'success': true,
      'brief': {
        'success': false,
        'error': 'Unable to generate daily briefing.',
      },
    });
    Get.put<VendorRepository>(repository);

    final controller = DashboardController();
    await controller.generateBrief();

    expect(controller.brief.value, isNull);
    expect(controller.briefError.value, 'Unable to generate daily briefing.');
    expect(controller.isGeneratingBrief.value, isFalse);
  });

  test('generateBrief HTTP error sets error state', () async {
    final repository = VendorRepository(
      VendorApiClient(
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({'message': 'Vendor API request failed (500).'}),
            500,
          ),
        ),
      ),
    );
    Get.put<VendorRepository>(repository);

    final controller = DashboardController();
    await controller.generateBrief();

    expect(controller.brief.value, isNull);
    expect(controller.briefError.value, isNotNull);
    expect(controller.isGeneratingBrief.value, isFalse);
  });
}
