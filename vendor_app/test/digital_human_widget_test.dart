import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/features/digital_human/controllers/digital_human_controller.dart';
import 'package:urban_goodz_vendor/features/digital_human/models/digital_human_state.dart';
import 'package:urban_goodz_vendor/features/digital_human/services/rive_asset_manager.dart';
import 'package:urban_goodz_vendor/features/digital_human/widgets/ai_assistant_panel.dart';
import 'package:urban_goodz_vendor/features/digital_human/widgets/digital_human_avatar_widget.dart';
import 'package:urban_goodz_vendor/models/daily_brief_model.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  tearDown(Get.reset);

  group('RiveAssetManager', () {
    test('reports assets unavailable until .riv files ship', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final manager = RiveAssetManager.instance;
      manager.clearCache();
      expect(
        manager.pathFor(DigitalHumanPersona.monique),
        'assets/digital_human/monique.riv',
      );
      expect(
        manager.pathFor(DigitalHumanPersona.skylar),
        'assets/digital_human/skylar.riv',
      );
      expect(
        await manager.isAssetAvailable(DigitalHumanPersona.monique),
        isFalse,
      );
      expect(
        await manager.isAssetAvailable(DigitalHumanPersona.skylar),
        isFalse,
      );
    });
  });

  group('DigitalHumanAvatarWidget', () {
    testWidgets('renders painted fallback with persona monogram and badge',
        (tester) async {
      final controller = DigitalHumanController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DigitalHumanAvatarWidget(
                controller: controller,
                size: 240,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('M'), findsOneWidget);
      expect(find.textContaining('MONIQUE'), findsOneWidget);
      expect(find.textContaining('IDLE'), findsOneWidget);
    });

    testWidgets('switches persona from Monique to Skylar', (tester) async {
      final controller = DigitalHumanController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DigitalHumanAvatarWidget(
                controller: controller,
                size: 240,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Skylar'));
      await tester.pump();
      expect(controller.activePersona, DigitalHumanPersona.skylar);
      expect(find.text('S'), findsOneWidget);
      expect(find.textContaining('SKYLAR'), findsOneWidget);
    });

    testWidgets('lip-sync preview walks visemes then returns to idle',
        (tester) async {
      final controller = DigitalHumanController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DigitalHumanAvatarWidget(
                controller: controller,
                size: 240,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byIcon(Icons.record_voice_over_outlined));
      await tester.pump();
      expect(controller.currentState.isSpeaking, isTrue);
      await tester.pump(const Duration(milliseconds: 1500));
      expect(controller.currentState, DigitalHumanStateModel.idle);
    });

    testWidgets('mic control is disabled until voice lane ships',
        (tester) async {
      final controller = DigitalHumanController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DigitalHumanAvatarWidget(
                controller: controller,
                size: 240,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      final mic = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.mic_none),
      );
      expect(mic.onPressed, isNull);
    });
  });

  group('AiAssistantPanel', () {
    testWidgets('renders greeting and voice readiness notice',
        (tester) async {
      final controller = DigitalHumanController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AiAssistantPanel(controller: controller),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('The Face of Urban Goodz'), findsOneWidget);
      expect(find.text('Monique'), findsWidgets);
      expect(find.textContaining('Voice is not enabled yet'), findsOneWidget);
    });

    testWidgets('shows personality-styled daily brief summary',
        (tester) async {
      final controller = DigitalHumanController();
      final brief = DailyBriefModel(
        success: true,
        greeting: 'Good morning!',
        todaysOutlook: 'steady momentum',
        summary: 'Revenue up 12%, two alerts.',
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AiAssistantPanel(
                controller: controller,
                dailyBrief: brief,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining('Revenue up 12%, two alerts.'), findsOneWidget);
      expect(find.textContaining('—'), findsOneWidget);
    });

    testWidgets('mood chip drives controller emotion', (tester) async {
      final controller = DigitalHumanController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AiAssistantPanel(
                controller: controller,
                dailyBrief: const DailyBriefModel(
                  success: true,
                  summary: 'summary line',
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('excited').first);
      await tester.pump();
      expect(controller.currentState.emotion, DigitalHumanEmotion.excited);
    });
  });
}
