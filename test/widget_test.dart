import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/main.dart';

import 'helpers/test_bootstrap.dart';

void main() {
  late Map<String, Map<String, String>> languages;

  setUp(() async {
    Get.testMode = true;
    languages = await initTestDependencies();
  });

  tearDown(resetGetx);

  testWidgets('Urban Goodz app renders GetMaterialApp on startup', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp(languages: languages, body: null));
    await tester.pump();

    expect(find.byType(GetMaterialApp), findsOneWidget);

    // Advance past any pending timers (drift database init, splash async work).
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  });
}
