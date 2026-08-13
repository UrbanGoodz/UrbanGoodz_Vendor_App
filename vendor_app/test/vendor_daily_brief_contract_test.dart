import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:urban_goodz_vendor/models/daily_brief_model.dart';
import 'package:urban_goodz_vendor/repositories/vendor_repository.dart';
import 'package:urban_goodz_vendor/services/vendor_api_client.dart';

void main() {
  test('dailyBrief hits the cross-app AI endpoint and parses nested brief',
      () async {
    late http.Request captured;
    final repository = VendorRepository(
      VendorApiClient(
        client: MockClient((request) async {
          captured = request;
          return http.Response(
            jsonEncode({
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
                'metrics': {'vendor_id': 7},
              },
            }),
            200,
          );
        }),
      )..setToken('fixture'),
    );

    final model = await repository.dailyBrief();

    expect(
      captured.url.path,
      '/api/v1/urban-goodz/cross-app/ai/vendor/daily-brief',
    );
    expect(captured.method, 'GET');
    expect(captured.headers['authorization'], 'Bearer fixture');
    expect(model, isA<DailyBriefModel>());
    expect(model.success, isTrue);
    expect(model.greeting, 'Good morning!');
    expect(model.keyMetrics.single.label, 'Orders Today');
    expect(model.actionItems, ['Accept pending orders']);
  });

  test('dailyBrief surfaces service failure without throwing', () async {
    final repository = VendorRepository(
      VendorApiClient(
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({
              'success': true,
              'brief': {
                'success': false,
                'error': 'Unable to generate daily briefing.',
              },
            }),
            200,
          ),
        ),
      ),
    );

    final model = await repository.dailyBrief();

    expect(model.success, isFalse);
    expect(model.error, 'Unable to generate daily briefing.');
  });

  test('dailyBrief handles malformed payload safely', () async {
    final repository = VendorRepository(
      VendorApiClient(
        client: MockClient(
          (_) async => http.Response(jsonEncode({'success': true}), 200),
        ),
      ),
    );

    final model = await repository.dailyBrief();

    expect(model.success, isFalse);
    expect(model.error, isNotNull);
  });
}
