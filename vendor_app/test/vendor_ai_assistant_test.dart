import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urban_goodz_vendor/controllers/vendor_ai_assistant_controller.dart';
import 'package:urban_goodz_vendor/controllers/vendor_auth_controller.dart';
import 'package:urban_goodz_vendor/repositories/vendor_repository.dart';
import 'package:urban_goodz_vendor/screens/vendor_ai_assistant_screen.dart';
import 'package:urban_goodz_vendor/services/vendor_api_client.dart';
import 'package:urban_goodz_vendor/theme/app_theme.dart';

class _Repo extends VendorRepository {
  _Repo(super.api);
}

/// Answers the requested vendor AI endpoints from [routes]; anything else is a 404,
/// which is what the real backend does today for three of the four sections.
MockClient _client(Map<String, Object> routes) => MockClient((request) async {
      final body = routes[request.url.path.replaceFirst('/api/v1', '')];
      if (body == null) {
        return http.Response(jsonEncode({'message': 'Not found'}), 404);
      }
      return http.Response(jsonEncode(body), 200, headers: {'content-type': 'application/json'});
    });

void main() {
  const briefPath = '/urban-goodz/cross-app/ai/vendor/daily-brief';
  const catalogPath = '/urban-goodz/cross-app/ai/vendor/catalog-suggestions';
  const actionsPath = '/urban-goodz/cross-app/ai/vendor/recommended-actions';
  const settlementPath = '/urban-goodz/cross-app/ai/vendor/settlement-metrics';

  setUp(() {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({});
  });
  tearDown(Get.reset);

  VendorAiAssistantController build(Map<String, Object> routes) {
    Get.put<VendorApiClient>(VendorApiClient(client: _client(routes)));
    return VendorAiAssistantController();
  }

  group('VendorAiAssistantController', () {
    test('a missing endpoint no longer blanks the sections that did load', () async {
      final c = build({briefPath: {'brief': '3 orders waiting'}});

      await c.fetchAssistantBrief();

      expect(c.dailyBrief.value, '3 orders waiting');
      expect(c.isUnavailable(VendorAiAssistantController.sectionBrief), isFalse);
      expect(c.isUnavailable(VendorAiAssistantController.sectionCatalog), isTrue);
      expect(c.isUnavailable(VendorAiAssistantController.sectionActions), isTrue);
      expect(c.isUnavailable(VendorAiAssistantController.sectionSettlement), isTrue);
      expect(c.errorMessage.value, isEmpty, reason: 'one section loaded, so this is a partial result');
      expect(c.isLoading.value, isFalse);
    });

    test('when every section fails the screen-level error is set', () async {
      final c = build({});

      await c.fetchAssistantBrief();

      expect(c.unavailableSections.length, 4);
      expect(c.errorMessage.value, isNotEmpty);
    });

    test('a fully served response populates everything and flags nothing', () async {
      final c = build({
        briefPath: {'brief': 'All good'},
        catalogPath: {
          'suggestions': [
            {'item_id': 1, 'item_name': 'Tea', 'proposed_price': 4.5}
          ]
        },
        actionsPath: {
          'actions': [
            {'title': 'Restock', 'description': 'Low stock'}
          ]
        },
        settlementPath: {'last_settlement': 120.5, 'next_settlement_date': '2026-11-14', 'status': 'scheduled'},
      });

      await c.fetchAssistantBrief();

      expect(c.unavailableSections, isEmpty);
      expect(c.catalogSuggestions.single['item_name'], 'Tea');
      expect(c.recommendedActions.single['title'], 'Restock');
      expect(c.settlementBrief['last_settlement'], 120.5);
    });

    test('a malformed response is treated as unavailable, not as an empty result', () async {
      final c = build({
        briefPath: {'brief': 'ok'},
        catalogPath: {'suggestions': 'not-a-list'},
        actionsPath: {'actions': []},
        settlementPath: {'last_settlement': 1},
      });

      await c.fetchAssistantBrief();

      expect(c.isUnavailable(VendorAiAssistantController.sectionCatalog), isTrue);
      expect(c.isUnavailable(VendorAiAssistantController.sectionActions), isFalse,
          reason: 'a valid empty list really does mean nothing to do');
    });

    test('a retry clears a previous failure', () async {
      final routes = <String, Object>{briefPath: {'brief': 'ok'}};
      final c = build(routes);
      await c.fetchAssistantBrief();
      expect(c.isUnavailable(VendorAiAssistantController.sectionCatalog), isTrue);

      Get.reset();
      routes[catalogPath] = {'suggestions': []};
      final again = build(routes);
      await again.fetchAssistantBrief();
      expect(again.isUnavailable(VendorAiAssistantController.sectionCatalog), isFalse);
    });
  });

  group('VendorAiAssistantScreen', () {
    Future<void> pump(WidgetTester tester, Map<String, Object> routes) async {
      final api = VendorApiClient(client: _client(routes));
      final repository = _Repo(api);
      Get.put<VendorApiClient>(api);
      Get.put<VendorRepository>(repository);
      final auth = VendorAuthController(repository, api)..isLoggedIn.value = true;
      Get.put<VendorAuthController>(auth);

      await tester.pumpWidget(GetMaterialApp(theme: AppTheme.lightTheme, home: const VendorAiAssistantScreen()));
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    testWidgets('unavailable sections say so and never show a reassuring empty state or a zero amount', (tester) async {
      await pump(tester, {briefPath: {'brief': '3 orders waiting'}});

      expect(find.text('3 orders waiting'), findsOneWidget);
      expect(find.byKey(const Key('vendor_ai_section_unavailable')), findsNWidgets(3));
      expect(find.text('All catalog item listings are fully optimized.'), findsNothing);
      expect(find.text('No recommended operational changes at this time.'), findsNothing);
      expect(find.textContaining(r'$0.00'), findsNothing);
      expect(find.text('Failed to load Vendor AI briefing.'), findsNothing);
    });

    testWidgets('a genuinely empty, successfully loaded list still shows the empty state', (tester) async {
      await pump(tester, {
        briefPath: {'brief': 'ok'},
        catalogPath: {'suggestions': []},
        actionsPath: {'actions': []},
        settlementPath: {'last_settlement': 10.0, 'next_settlement_date': '2026-11-14', 'status': 'scheduled'},
      });

      expect(find.byKey(const Key('vendor_ai_section_unavailable')), findsNothing);
      expect(find.text('All catalog item listings are fully optimized.'), findsOneWidget);
      expect(find.text('No recommended operational changes at this time.'), findsOneWidget);
    });
  });
}
