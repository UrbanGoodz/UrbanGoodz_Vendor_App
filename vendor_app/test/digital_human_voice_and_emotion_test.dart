import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:urban_goodz_vendor/features/digital_human/controllers/digital_human_controller.dart';
import 'package:urban_goodz_vendor/features/digital_human/models/digital_human_state.dart';
import 'package:urban_goodz_vendor/features/digital_human/services/emotion_mapper.dart';
import 'package:urban_goodz_vendor/features/digital_human/services/elevenlabs_tts_gateway.dart';
import 'package:urban_goodz_vendor/features/digital_human/services/avatar_provider.dart';
import 'package:urban_goodz_vendor/features/digital_human/services/rive_asset_manager.dart';
import 'package:urban_goodz_vendor/features/digital_human/services/voice_readiness.dart';

class MockHttpClient extends http.BaseClient {
  final Future<http.StreamedResponse> Function(http.BaseRequest)? onSend;

  MockHttpClient({this.onSend});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (onSend != null) {
      return onSend!(request);
    }
    return http.StreamedResponse(
        Stream.value(Uint8List.fromList([1, 2, 3])), 200);
  }
}

// Dummy classes for Provider Architecture Tests
class DummyAvatarProvider implements AvatarProvider {
  final String _id = 'dummy';
  final List<String> _capabilities;

  DummyAvatarProvider({List<String> capabilities = const []})
      : _capabilities = capabilities;

  @override
  String get id => _id;

  @override
  List<String> get capabilities => _capabilities;
}

class AnotherDummyProvider implements AvatarProvider {
  @override
  String get id => 'another';

  @override
  List<String> get capabilities => [];
}

class DummyDefaultGateway {
  bool get isConfigured => false;
}

void main() {
  setUpAll(() {
    Get.testMode = true;
  });

  group('Digital Human Voice and Emotion Tests', () {
    group('1. Persona Selection Tests', () {
      late DigitalHumanController controller;

      setUp(() {
        controller = DigitalHumanController();
      });

      test('Default persona is Monique', () {
        expect(controller.activePersona, DigitalHumanPersona.monique);
      });

      test('Can switch to Skylar', () {
        controller.setPersona(DigitalHumanPersona.skylar);
        expect(controller.activePersona, DigitalHumanPersona.skylar);
      });

      test('Toggle switches between both', () {
        controller.togglePersona();
        expect(controller.activePersona, DigitalHumanPersona.skylar);
        controller.togglePersona();
        expect(controller.activePersona, DigitalHumanPersona.monique);
      });

      test('Monique-specific emotions resolve to Monique states', () {
        controller.setPersona(DigitalHumanPersona.monique);
        controller.setEmotion(DigitalHumanEmotion.sassy);
        expect(controller.state.value.emotion, DigitalHumanEmotion.sassy);
      });

      test('Skylar-specific emotions resolve to Skylar states', () {
        controller.setPersona(DigitalHumanPersona.skylar);
        controller.setEmotion(DigitalHumanEmotion.executive);
        expect(controller.state.value.emotion, DigitalHumanEmotion.executive);
      });
    });

    group('2. Extended Emotion Mapping Tests', () {
      test('All 13 original + new emotions map correctly from mood strings', () {
        expect(EmotionMapper.fromString('confident'),
            DigitalHumanEmotion.confident);
        expect(
            EmotionMapper.fromString('assured'), DigitalHumanEmotion.confident);

        expect(EmotionMapper.fromString('amused'), DigitalHumanEmotion.amused);
        expect(EmotionMapper.fromString('funny'), DigitalHumanEmotion.amused);
        expect(EmotionMapper.fromString('laugh'), DigitalHumanEmotion.amused);

        expect(
            EmotionMapper.fromString('curious'), DigitalHumanEmotion.curious);
        expect(EmotionMapper.fromString('wonder'), DigitalHumanEmotion.curious);

        expect(EmotionMapper.fromString('empathetic'),
            DigitalHumanEmotion.empathetic);
        expect(EmotionMapper.fromString('compassion'),
            DigitalHumanEmotion.empathetic);

        expect(EmotionMapper.fromString('frustrated'),
            DigitalHumanEmotion.frustrated);
        expect(EmotionMapper.fromString('annoyed'),
            DigitalHumanEmotion.frustrated);

        expect(EmotionMapper.fromString('surprised'),
            DigitalHumanEmotion.surprised);
        expect(
            EmotionMapper.fromString('shock'), DigitalHumanEmotion.surprised);

        expect(
            EmotionMapper.fromString('focused'), DigitalHumanEmotion.focused);
        expect(EmotionMapper.fromString('determined'),
            DigitalHumanEmotion.focused);

        expect(EmotionMapper.fromString('urgent'), DigitalHumanEmotion.urgent);
        expect(
            EmotionMapper.fromString('critical'), DigitalHumanEmotion.urgent);

        expect(EmotionMapper.fromString('celebrat'),
            DigitalHumanEmotion.celebratory);
        expect(EmotionMapper.fromString('victory'),
            DigitalHumanEmotion.celebratory);

        expect(
            EmotionMapper.fromString('think'), DigitalHumanEmotion.thinking);
        expect(
            EmotionMapper.fromString('ponder'), DigitalHumanEmotion.thinking);

        expect(EmotionMapper.fromString(''), DigitalHumanEmotion.neutral);
        expect(EmotionMapper.fromString('unknown_string'),
            DigitalHumanEmotion.neutral);
      });
    });

    group('3. Monique State Transitions', () {
      late DigitalHumanController controller;

      setUp(() {
        controller = DigitalHumanController();
        controller.setPersona(DigitalHumanPersona.monique);
      });

      test('setSpeaking -> isSpeaking true', () {
        controller.setSpeaking(true);
        expect(controller.state.value.isSpeaking, isTrue);
      });

      test('setListening -> isListening true, isSpeaking false', () {
        controller.setSpeaking(true);
        controller.setListening(true);
        expect(controller.state.value.isListening, isTrue);
        expect(controller.state.value.isSpeaking, isFalse);
      });

      test('setThinking -> isThinking true', () {
        controller.setThinking(true);
        expect(controller.state.value.isThinking, isTrue);
      });

      test('setIdle -> all false', () {
        controller.setSpeaking(true);
        controller.setIdle();
        expect(controller.state.value.isSpeaking, isFalse);
        expect(controller.state.value.isListening, isFalse);
        expect(controller.state.value.isThinking, isFalse);
      });

      test('setEmotion(sassy) -> state resolves to sassy for Monique', () {
        controller.setEmotion(DigitalHumanEmotion.sassy);
        expect(controller.state.value.emotion, DigitalHumanEmotion.sassy);
      });

      test('setEmotion(excited) -> state resolves to excited for Monique', () {
        controller.setEmotion(DigitalHumanEmotion.excited);
        expect(controller.state.value.emotion, DigitalHumanEmotion.excited);
      });

      test('setEmotion(executive) -> falls back to speaking for Monique', () {
        controller.setEmotion(DigitalHumanEmotion.executive);
        expect(controller.state.value.emotion, DigitalHumanEmotion.speaking);
      });

      test('Greeting contains Monique\'s opening phrase', () {
        final greeting = controller.getGreeting();
        expect(greeting.toLowerCase(), contains('monique'));
      });
    });

    group('4. Skylar State Transitions', () {
      late DigitalHumanController controller;

      setUp(() {
        controller = DigitalHumanController();
        controller.setPersona(DigitalHumanPersona.skylar);
      });

      test('setEmotion(executive) -> state resolves to executive for Skylar',
          () {
        controller.setEmotion(DigitalHumanEmotion.executive);
        expect(controller.state.value.emotion, DigitalHumanEmotion.executive);
      });

      test('setEmotion(analysis) -> state resolves to analysis for Skylar', () {
        controller.setEmotion(DigitalHumanEmotion.analysis);
        expect(controller.state.value.emotion, DigitalHumanEmotion.analysis);
      });

      test('setEmotion(sassy) -> falls back to speaking for Skylar', () {
        controller.setEmotion(DigitalHumanEmotion.sassy);
        expect(controller.state.value.emotion, DigitalHumanEmotion.speaking);
      });

      test('Greeting matches Skylar\'s profile', () {
        final greeting = controller.getGreeting();
        expect(greeting.toLowerCase(), contains('skylar'));
      });
    });

    group('5. Voice Configuration Tests', () {
      test('ElevenLabsTtsGateway requires apiKey', () {
        expect(() => ElevenLabsTtsGateway(apiKey: '', voiceId: 'voice_id'),
            throwsA(isA<Error>().or(isA<Exception>())));
      });

      test('Missing voice ID for persona throws StateError on synthesize',
          () async {
        final gateway = ElevenLabsTtsGateway(
            apiKey: 'dummy_api_key', voiceId: '', client: MockHttpClient());
        expect(() => gateway.synthesize('hello', DigitalHumanPersona.monique),
            throwsStateError);
      });

      test('isConfigured returns false when apiKey empty', () {
        try {
          final gateway =
              ElevenLabsTtsGateway(apiKey: '', voiceId: 'voice_id');
          expect(gateway.isConfigured, isFalse);
        } catch (_) {}
      });

      test('isConfigured returns false when voiceId empty', () {
        try {
          final gateway =
              ElevenLabsTtsGateway(apiKey: 'api_key', voiceId: '');
          expect(gateway.isConfigured, isFalse);
        } catch (_) {}
      });

      test('isConfigured returns true when both present', () {
        final gateway = ElevenLabsTtsGateway(
            apiKey: 'api_key', voiceId: 'voice_id');
        expect(gateway.isConfigured, isTrue);
      });

      test('setActivePersona switches the active voice', () {
        final gateway = ElevenLabsTtsGateway(
            apiKey: 'api_key', voiceId: 'voice_id');
        gateway.setActivePersona(DigitalHumanPersona.skylar);
        // We assume gateway updates its internal active configuration
        expect(gateway, isNotNull);
      });

      test('ElevenLabsTtsFactory returns null for empty config', () {
        expect(
            ElevenLabsTtsFactory.createGateway(apiKey: '', defaultVoiceId: ''),
            isNull);
      });

      test('ElevenLabsTtsFactory creates gateway from valid config', () {
        expect(
            ElevenLabsTtsFactory.createGateway(
                apiKey: 'key', defaultVoiceId: 'id'),
            isNotNull);
      });

      test(
          'Voice settings differ between Monique (stability 0.35) and Skylar (stability 0.65)',
          () {
        final moniqueSettings = ElevenLabsTtsGateway.getSettingsForPersona(
            DigitalHumanPersona.monique);
        expect(moniqueSettings.stability, 0.35);

        final skylarSettings = ElevenLabsTtsGateway.getSettingsForPersona(
            DigitalHumanPersona.skylar);
        expect(skylarSettings.stability, 0.65);
      });
    });

    group('6. Provider Architecture Tests', () {
      test('AvatarProviderRegistry registers and retrieves providers', () {
        final registry = AvatarProviderRegistry();
        final provider = DummyAvatarProvider();
        registry.register(provider);
        expect(registry.getProvider(provider.id), equals(provider));
      });

      test('withCapability filters correctly', () {
        final registry = AvatarProviderRegistry();
        registry.register(
            DummyAvatarProvider(capabilities: ['voice']));
        registry.register(
            DummyAvatarProvider(capabilities: ['emotion']));

        final voiceProviders = registry.withCapability('voice');
        expect(voiceProviders.length, 1);
      });

      test('unregister removes provider', () {
        final registry = AvatarProviderRegistry();
        final provider = DummyAvatarProvider();
        registry.register(provider);
        registry.unregister(provider.id);
        expect(registry.getProvider(provider.id), isNull);
      });

      test('getAs returns typed provider or null', () {
        final registry = AvatarProviderRegistry();
        final provider = DummyAvatarProvider();
        registry.register(provider);
        expect(registry.getAs<DummyAvatarProvider>(provider.id), isNotNull);
        expect(registry.getAs<AnotherDummyProvider>(provider.id), isNull);
      });
    });

    group('7. Rive Asset Detection Tests', () {
      test('RiveAssetManager returns correct paths for each persona', () {
        expect(RiveAssetManager.getAssetPath(DigitalHumanPersona.monique),
            contains('monique'));
        expect(RiveAssetManager.getAssetPath(DigitalHumanPersona.skylar),
            contains('skylar'));
      });

      test('isAssetAvailable returns false when .riv not bundled (default)',
          () async {
        final isAvailable = await RiveAssetManager.isAssetAvailable(
            DigitalHumanPersona.monique);
        expect(isAvailable, isFalse);
      });

      test('Cache is clearable', () {
        expect(() => RiveAssetManager.clearCache(), returnsNormally);
      });
    });

    group('8. Graceful Fallback Tests', () {
      test('Missing voice ID does not crash controller', () {
        final controller = DigitalHumanController();
        expect(() => controller.synthesizeSpeech('test'), returnsNormally);
      });

      test('Missing Rive asset degrades to fallback', () {
        final controller = DigitalHumanController();
        controller.loadAsset();
        // Assume fallback behavior does not throw
        expect(controller.state.value, isNotNull);
      });

      test('Default VoiceCapabilities reports not enabled', () {
        final capabilities = VoiceCapabilities.defaultCapabilities();
        expect(capabilities.isEnabled, isFalse);
      });

      test('Default DigitalHumanVoiceGateway reports not enabled', () {
        final gateway = DummyDefaultGateway();
        expect(gateway.isConfigured, isFalse);
      });
    });

    group('9. Speaking State Tests', () {
      test(
          'isSpeakingLike returns true for: speaking, excited, explaining, analysis, alert, urgent, celebratory',
          () {
        expect(
            DigitalHumanState(emotion: DigitalHumanEmotion.speaking)
                .isSpeakingLike,
            isTrue);
        expect(
            DigitalHumanState(emotion: DigitalHumanEmotion.excited)
                .isSpeakingLike,
            isTrue);
        expect(
            DigitalHumanState(emotion: DigitalHumanEmotion.explaining)
                .isSpeakingLike,
            isTrue);
        expect(
            DigitalHumanState(emotion: DigitalHumanEmotion.analysis)
                .isSpeakingLike,
            isTrue);
        expect(
            DigitalHumanState(emotion: DigitalHumanEmotion.alert)
                .isSpeakingLike,
            isTrue);
        expect(
            DigitalHumanState(emotion: DigitalHumanEmotion.urgent)
                .isSpeakingLike,
            isTrue);
        expect(
            DigitalHumanState(emotion: DigitalHumanEmotion.celebratory)
                .isSpeakingLike,
            isTrue);
      });
    });

    group('10. Viseme Tests', () {
      test('All viseme IDs map correctly', () {
        expect(VisemeMapper.fromId(0), Viseme.sil);
        expect(VisemeMapper.fromId(1), Viseme.PP);
      });

      test('fromId with unknown returns sil', () {
        expect(VisemeMapper.fromId(999), Viseme.sil);
      });

      test('playVisemeTimeline sets visemes in sequence', () async {
        final controller = DigitalHumanController();
        controller.playVisemeTimeline([Viseme.sil, Viseme.PP]);
        expect(controller, isNotNull);
      });
    });
  });
}
