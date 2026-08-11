import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/features/digital_human/controllers/digital_human_controller.dart';
import 'package:urban_goodz_vendor/features/digital_human/models/digital_human_state.dart';
import 'package:urban_goodz_vendor/features/digital_human/services/voice_readiness.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  tearDown(Get.reset);

  group('DigitalHumanController', () {
    test('defaults to Monique and idle state', () {
      final controller = DigitalHumanController();
      expect(controller.activePersona, DigitalHumanPersona.monique);
      expect(controller.currentState, DigitalHumanStateModel.idle);
      expect(controller.isVoiceEnabled, isFalse);
    });

    test('activatePersona switches persona and keeps state model', () {
      final controller = DigitalHumanController();
      controller.setEmotion(DigitalHumanEmotion.sassy);
      controller.activatePersona(DigitalHumanPersona.skylar);
      expect(controller.activePersona, DigitalHumanPersona.skylar);
      expect(controller.currentState.emotion, DigitalHumanEmotion.sassy);
      expect(
        controller.currentState.resolveState(DigitalHumanPersona.skylar),
        DigitalHumanState.speaking,
      );
      controller.togglePersona();
      expect(controller.activePersona, DigitalHumanPersona.monique);
    });

    test('speaking/listening/thinking/idle transitions', () {
      final controller = DigitalHumanController();
      controller.setSpeaking();
      expect(controller.currentState.isSpeaking, isTrue);
      expect(
        controller.currentState.resolveState(DigitalHumanPersona.monique),
        DigitalHumanState.speaking,
      );
      controller.setListening();
      expect(controller.currentState.isListening, isTrue);
      expect(controller.currentState.isSpeaking, isFalse);
      controller.setThinking();
      expect(controller.currentState.isThinking, isTrue);
      controller.setIdle();
      expect(controller.currentState, DigitalHumanStateModel.idle);
      expect(controller.currentState.visemeId, 0);
    });

    test('setMood maps tone to emotion through EmotionMapper', () {
      final controller = DigitalHumanController();
      controller.setMood('sassy and bold');
      expect(controller.currentState.emotion, DigitalHumanEmotion.sassy);
      controller.setMood('executive');
      expect(controller.currentState.emotion, DigitalHumanEmotion.executive);
    });

    test('confidence and gesture are settable', () {
      final controller = DigitalHumanController();
      controller.setConfidence(0.66);
      controller.setGesture(DigitalHumanGesture.nod);
      expect(controller.currentState.confidence, 0.66);
      expect(controller.currentState.gesture, DigitalHumanGesture.nod);
    });

    test('statusMessage mirrors resolved state label', () {
      final controller = DigitalHumanController();
      expect(controller.statusMessage.value, 'Idle');
      controller.setSpeaking();
      expect(controller.statusMessage.value, 'Speaking');
    });

    test('personalityResponse styles the brief in the persona voice', () {
      final controller = DigitalHumanController();
      final line = controller.personalityResponse(
        briefSummary: 'Revenue is trending up 12%.',
      );
      expect(line, contains('Revenue is trending up 12%.'));
      expect(line, contains('let me put you on'));
      controller.pausePersonality();
      final paused = controller.personalityResponse(
        briefSummary: 'Revenue is trending up 12%.',
      );
      expect(paused, contains('brings Urban Goodz to life'));
      expect(paused, contains('Revenue is trending up 12%.'));
    });

    test('catchphrase uses the active persona voice', () {
      final controller = DigitalHumanController();
      expect(controller.catchphrase(), "How you doin'? What's GOOD?");
      controller.activatePersona(DigitalHumanPersona.skylar);
      expect(controller.catchphrase(), isNotEmpty);
    });

    test('commentary and reaction hooks use the persona voice', () {
      final controller = DigitalHumanController();
      expect(controller.commentary(), contains('exactly what I\'m talking about'));
      expect(controller.reaction('discovery'),
          "Okay now... THIS is what I was looking for.");
      expect(controller.reaction('poor_choice'),
          "Baby... we're going to do better than that.");
    });

    test('personalityResponse can open with a situational reaction', () {
      final controller = DigitalHumanController();
      final line = controller.personalityResponse(
        briefSummary: 'A new spot just opened downtown.',
        reaction: 'discovery',
      );
      expect(line, startsWith('Okay now... THIS is what I was looking for.'));
      expect(line, contains('A new spot just opened downtown.'));
    });

    test('greeting uses persona voice', () {
      final controller = DigitalHumanController();
      expect(controller.greeting(), isNotEmpty);
      controller.activatePersona(DigitalHumanPersona.skylar);
      expect(controller.greeting(), isNotEmpty);
    });

    test('viseme timeline walks frames and resets to sil', () {
      fakeAsync((async) {
        final controller = DigitalHumanController();
        controller.playVisemeTimeline(const [
          {'id': 1, 'durationMs': 100},
          {'id': 3, 'durationMs': 100},
        ]);
        expect(controller.currentState.visemeId, 0);
        async.elapse(const Duration(milliseconds: 99));
        expect(controller.currentState.visemeId, 1);
        async.elapse(const Duration(milliseconds: 1));
        expect(controller.currentState.visemeId, 3);
        async.elapse(const Duration(milliseconds: 100));
        expect(controller.currentState.visemeId, 0);
      });
    });

    test('stopVisemeTimeline resets to sil', () {
      fakeAsync((async) {
        final controller = DigitalHumanController();
        controller.playVisemeTimeline(const [
          {'id': 1, 'durationMs': 5000},
        ]);
        async.elapse(const Duration(milliseconds: 100));
        expect(controller.currentState.visemeId, 1);
        controller.stopVisemeTimeline();
        expect(controller.currentState.visemeId, 0);
      });
    });

    test('voice gateway reports disabled by default', () {
      final controller = DigitalHumanController();
      expect(controller.isVoiceEnabled, isFalse);

      final enabled = DigitalHumanController(
        voiceGateway: DigitalHumanVoiceGateway(
          capabilities: const VoiceCapabilities(
            microphonePermissionAvailable: true,
            speechToTextAvailable: true,
            textToSpeechAvailable: true,
            responsePlaybackAvailable: true,
          ),
        ),
      );
      expect(enabled.isVoiceEnabled, isTrue);
    });
  });
}
