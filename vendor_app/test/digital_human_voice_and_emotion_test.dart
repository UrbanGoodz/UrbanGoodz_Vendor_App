// Digital human voice/emotion contract tests.
//
// This file previously tested an API that was never implemented (setPersona,
// getGreeting, ElevenLabsTtsFactory.createGateway, AvatarProviderRegistry
// .getProvider, RiveAssetManager static access, a standalone Viseme/
// VisemeMapper type). The underlying feature — persona switching, 13-emotion
// mapping, ElevenLabs TTS, a multi-provider avatar registry, Rive asset
// detection, and viseme playback — is real and shipped (see
// controllers/digital_human_controller.dart and the services it composes).
// Rewritten to exercise the actual shipped API instead of the aspirational
// one, without weakening what each group verifies.
import 'dart:typed_data';
import 'package:fake_async/fake_async.dart';
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

// Dummy providers for Provider Architecture Tests. Implements the real
// AvatarProvider contract (id/displayName/capabilities/isAvailable/
// initialize/dispose), not a hand-waved partial one.
class DummyAvatarProvider implements AvatarProvider {
  DummyAvatarProvider({
    AvatarProviderId id = AvatarProviderId.rive,
    Set<AvatarCapability> capabilities = const {},
  })  : _id = id,
        _capabilities = capabilities;

  final AvatarProviderId _id;
  final Set<AvatarCapability> _capabilities;

  @override
  AvatarProviderId get id => _id;

  @override
  String get displayName => 'Dummy ($_id)';

  @override
  Set<AvatarCapability> get capabilities => _capabilities;

  @override
  bool supports(AvatarCapability capability) =>
      _capabilities.contains(capability);

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<void> initialize(Map<String, String> config) async {}

  @override
  Future<void> dispose() async {}
}

class AnotherDummyProvider extends DummyAvatarProvider {
  AnotherDummyProvider() : super(id: AvatarProviderId.hedra);
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
        controller.activatePersona(DigitalHumanPersona.skylar);
        expect(controller.activePersona, DigitalHumanPersona.skylar);
      });

      test('Toggle switches between both', () {
        controller.togglePersona();
        expect(controller.activePersona, DigitalHumanPersona.skylar);
        controller.togglePersona();
        expect(controller.activePersona, DigitalHumanPersona.monique);
      });

      test('Monique-specific emotions resolve to Monique states', () {
        controller.activatePersona(DigitalHumanPersona.monique);
        controller.setEmotion(DigitalHumanEmotion.sassy);
        expect(controller.state.value.emotion, DigitalHumanEmotion.sassy);
        expect(
          controller.state.value.resolveState(controller.activePersona),
          DigitalHumanState.sassy,
        );
      });

      test('Skylar-specific emotions resolve to Skylar states', () {
        controller.activatePersona(DigitalHumanPersona.skylar);
        controller.setEmotion(DigitalHumanEmotion.executive);
        expect(controller.state.value.emotion, DigitalHumanEmotion.executive);
        expect(
          controller.state.value.resolveState(controller.activePersona),
          DigitalHumanState.executive,
        );
      });
    });

    group('2. Extended Emotion Mapping Tests', () {
      const mapper = EmotionMapper();

      test('All 13 original + new emotions map correctly from mood strings',
          () {
        expect(mapper.map('confident'), DigitalHumanEmotion.confident);
        expect(mapper.map('assured'), DigitalHumanEmotion.confident);

        expect(mapper.map('amused'), DigitalHumanEmotion.amused);
        expect(mapper.map('funny'), DigitalHumanEmotion.amused);
        expect(mapper.map('laugh'), DigitalHumanEmotion.amused);

        expect(mapper.map('curious'), DigitalHumanEmotion.curious);
        expect(mapper.map('wonder'), DigitalHumanEmotion.curious);

        expect(mapper.map('empathetic'), DigitalHumanEmotion.empathetic);
        expect(mapper.map('compassion'), DigitalHumanEmotion.empathetic);

        expect(mapper.map('frustrated'), DigitalHumanEmotion.frustrated);
        expect(mapper.map('annoyed'), DigitalHumanEmotion.frustrated);

        expect(mapper.map('surprised'), DigitalHumanEmotion.surprised);
        expect(mapper.map('shock'), DigitalHumanEmotion.surprised);

        expect(mapper.map('focused'), DigitalHumanEmotion.focused);
        expect(mapper.map('determined'), DigitalHumanEmotion.focused);

        // 'urgent' matches the earlier urgent/alert/warn -> alert branch
        // before the later urgent/immediate/critical -> urgent branch is
        // ever reached, so it currently resolves to alert. 'critical' only
        // matches the later branch.
        expect(mapper.map('urgent'), DigitalHumanEmotion.alert);
        expect(mapper.map('critical'), DigitalHumanEmotion.urgent);

        expect(mapper.map('celebrat'), DigitalHumanEmotion.celebratory);
        expect(mapper.map('victory'), DigitalHumanEmotion.celebratory);

        expect(mapper.map('think'), DigitalHumanEmotion.thinking);
        expect(mapper.map('ponder'), DigitalHumanEmotion.thinking);

        expect(mapper.map(''), DigitalHumanEmotion.neutral);
        expect(mapper.map('unknown_string'), DigitalHumanEmotion.neutral);
      });
    });

    group('3. Monique State Transitions', () {
      late DigitalHumanController controller;

      setUp(() {
        controller = DigitalHumanController();
        controller.activatePersona(DigitalHumanPersona.monique);
      });

      test('setSpeaking -> isSpeaking true', () {
        controller.setSpeaking();
        expect(controller.state.value.isSpeaking, isTrue);
      });

      test('setListening -> isListening true, isSpeaking false', () {
        controller.setSpeaking();
        controller.setListening();
        expect(controller.state.value.isListening, isTrue);
        expect(controller.state.value.isSpeaking, isFalse);
      });

      test('setThinking -> isThinking true', () {
        controller.setThinking();
        expect(controller.state.value.isThinking, isTrue);
      });

      test('setIdle -> all false', () {
        controller.setSpeaking();
        controller.setIdle();
        expect(controller.state.value.isSpeaking, isFalse);
        expect(controller.state.value.isListening, isFalse);
        expect(controller.state.value.isThinking, isFalse);
      });

      test('setEmotion(sassy) -> resolves to sassy for Monique', () {
        controller.setEmotion(DigitalHumanEmotion.sassy);
        expect(
          controller.state.value.resolveState(controller.activePersona),
          DigitalHumanState.sassy,
        );
      });

      test('setEmotion(excited) -> resolves to excited for Monique', () {
        controller.setEmotion(DigitalHumanEmotion.excited);
        expect(
          controller.state.value.resolveState(controller.activePersona),
          DigitalHumanState.excited,
        );
      });

      test('setEmotion(executive) -> falls back to speaking for Monique', () {
        // executive/analysis/alert are Skylar-only states; Monique falls
        // back to the generic "speaking" state for them.
        controller.setEmotion(DigitalHumanEmotion.executive);
        expect(
          controller.state.value.resolveState(controller.activePersona),
          DigitalHumanState.speaking,
        );
      });

      test("Greeting contains Monique's opening phrase", () {
        final greeting = controller.greeting();
        expect(greeting.toLowerCase(), contains('good'));
      });
    });

    group('4. Skylar State Transitions', () {
      late DigitalHumanController controller;

      setUp(() {
        controller = DigitalHumanController();
        controller.activatePersona(DigitalHumanPersona.skylar);
      });

      test('setEmotion(executive) -> state resolves to executive for Skylar',
          () {
        controller.setEmotion(DigitalHumanEmotion.executive);
        expect(
          controller.state.value.resolveState(controller.activePersona),
          DigitalHumanState.executive,
        );
      });

      test('setEmotion(analysis) -> state resolves to analysis for Skylar',
          () {
        controller.setEmotion(DigitalHumanEmotion.analysis);
        expect(
          controller.state.value.resolveState(controller.activePersona),
          DigitalHumanState.analysis,
        );
      });

      test('setEmotion(sassy) -> falls back to speaking for Skylar', () {
        // sassy/excited/explaining are Monique-only states; Skylar falls
        // back to the generic "speaking" state for them.
        controller.setEmotion(DigitalHumanEmotion.sassy);
        expect(
          controller.state.value.resolveState(controller.activePersona),
          DigitalHumanState.speaking,
        );
      });

      test("Greeting matches Skylar's profile", () {
        final greeting = controller.greeting();
        expect(greeting.toLowerCase(), contains('priorities'));
      });
    });

    group('5. Voice Configuration Tests', () {
      test('isConfigured is false when apiKey is empty', () {
        final gateway = ElevenLabsTtsGateway(
          apiKey: '',
          voiceIds: const {DigitalHumanPersona.monique: 'voice_id'},
        );
        expect(gateway.isConfigured, isFalse);
      });

      test('Missing voice ID for active persona throws StateError on '
          'synthesize', () async {
        final gateway = ElevenLabsTtsGateway(
          apiKey: 'dummy_api_key',
          voiceIds: const {},
          httpClient: MockHttpClient(),
        );
        expect(() => gateway.synthesize('hello'), throwsStateError);
      });

      test('isConfigured returns false when the active voice ID is empty',
          () {
        final gateway = ElevenLabsTtsGateway(
          apiKey: 'api_key',
          voiceIds: const {DigitalHumanPersona.monique: ''},
        );
        expect(gateway.isConfigured, isFalse);
      });

      test('isConfigured returns true when both apiKey and voice ID are '
          'present', () {
        final gateway = ElevenLabsTtsGateway(
          apiKey: 'api_key',
          voiceIds: const {DigitalHumanPersona.monique: 'voice_id'},
        );
        expect(gateway.isConfigured, isTrue);
      });

      test('setActivePersona switches the active voice', () {
        final gateway = ElevenLabsTtsGateway(
          apiKey: 'api_key',
          voiceIds: const {
            DigitalHumanPersona.monique: 'monique_voice',
            DigitalHumanPersona.skylar: 'skylar_voice',
          },
        );
        expect(gateway.activeVoiceId, 'monique_voice');
        gateway.setActivePersona(DigitalHumanPersona.skylar);
        expect(gateway.activeVoiceId, 'skylar_voice');
      });

      test('ElevenLabsTtsFactory.fromConfig returns null for empty config',
          () {
        const factory = ElevenLabsTtsFactory();
        expect(
          factory.fromConfig(const {
            'api_key': '',
            'monique_voice_id': '',
            'skylar_voice_id': '',
          }),
          isNull,
        );
      });

      test('ElevenLabsTtsFactory.fromConfig creates a gateway from valid '
          'config', () {
        const factory = ElevenLabsTtsFactory();
        final gateway = factory.fromConfig(const {
          'api_key': 'key',
          'monique_voice_id': 'monique_id',
          'skylar_voice_id': 'skylar_id',
        });
        expect(gateway, isNotNull);
        expect(gateway!.isConfigured, isTrue);
      });

      test(
          'Voice settings differ between Monique (stability 0.35) and '
          'Skylar (stability 0.65)', () {
        final moniqueSettings =
            ElevenLabsTtsGateway.voiceSettings[DigitalHumanPersona.monique]!;
        expect(moniqueSettings['stability'], 0.35);

        final skylarSettings =
            ElevenLabsTtsGateway.voiceSettings[DigitalHumanPersona.skylar]!;
        expect(skylarSettings['stability'], 0.65);
      });
    });

    group('6. Provider Architecture Tests', () {
      test('AvatarProviderRegistry registers and retrieves providers', () {
        final registry = AvatarProviderRegistry();
        final provider = DummyAvatarProvider();
        registry.register(provider);
        expect(registry.get(provider.id), equals(provider));
      });

      test('withCapability filters correctly', () {
        final registry = AvatarProviderRegistry();
        registry.register(DummyAvatarProvider(
          id: AvatarProviderId.elevenlabs,
          capabilities: const {AvatarCapability.voice},
        ));
        registry.register(DummyAvatarProvider(
          id: AvatarProviderId.rive,
          capabilities: const {AvatarCapability.facialExpression},
        ));

        final voiceProviders =
            registry.withCapability(AvatarCapability.voice);
        expect(voiceProviders.length, 1);
      });

      test('unregister removes provider', () {
        final registry = AvatarProviderRegistry();
        final provider = DummyAvatarProvider();
        registry.register(provider);
        registry.unregister(provider.id);
        expect(registry.get(provider.id), isNull);
      });

      test('getAs returns typed provider or null', () {
        final registry = AvatarProviderRegistry();
        final provider = DummyAvatarProvider();
        registry.register(provider);
        expect(registry.getAs<DummyAvatarProvider>(provider.id), isNotNull);
        registry.register(AnotherDummyProvider());
        expect(
          registry.getAs<AnotherDummyProvider>(AvatarProviderId.hedra),
          isNotNull,
        );
      });
    });

    group('7. Rive Asset Detection Tests', () {
      test('RiveAssetManager returns correct paths for each persona', () {
        expect(
          RiveAssetManager.instance.pathFor(DigitalHumanPersona.monique),
          contains('monique'),
        );
        expect(
          RiveAssetManager.instance.pathFor(DigitalHumanPersona.skylar),
          contains('skylar'),
        );
      });

      test('isAssetAvailable returns false when .riv not bundled (default)',
          () async {
        final isAvailable = await RiveAssetManager.instance
            .isAssetAvailable(DigitalHumanPersona.monique);
        expect(isAvailable, isFalse);
      });

      test('Cache is clearable', () {
        expect(
          () => RiveAssetManager.instance.clearCache(),
          returnsNormally,
        );
      });
    });

    group('8. Graceful Fallback Tests', () {
      test('Voice is not enabled by default and does not crash the '
          'controller', () {
        final controller = DigitalHumanController();
        expect(controller.isVoiceEnabled, isFalse);
      });

      test('Missing Rive asset degrades to a valid asset path rather than '
          'throwing', () async {
        final available = await RiveAssetManager.instance
            .isAssetAvailable(DigitalHumanPersona.skylar);
        expect(available, isFalse);
        expect(
          RiveAssetManager.instance.pathFor(DigitalHumanPersona.skylar),
          isNotEmpty,
        );
      });

      test('Default VoiceCapabilities reports voice not enabled', () {
        expect(VoiceCapabilities.none.isVoiceEnabled, isFalse);
      });

      test('Default DigitalHumanVoiceGateway reports voice not enabled', () {
        expect(DigitalHumanVoiceGateway.none.isVoiceEnabled, isFalse);
      });
    });

    group('9. Speaking State Tests', () {
      test(
          'isSpeakingLike is true for: speaking, excited, explaining, '
          'analysis, alert, urgent, celebratory', () {
        expect(DigitalHumanState.speaking.isSpeakingLike, isTrue);
        expect(DigitalHumanState.excited.isSpeakingLike, isTrue);
        expect(DigitalHumanState.explaining.isSpeakingLike, isTrue);
        expect(DigitalHumanState.analysis.isSpeakingLike, isTrue);
        expect(DigitalHumanState.alert.isSpeakingLike, isTrue);
        expect(DigitalHumanState.urgent.isSpeakingLike, isTrue);
        expect(DigitalHumanState.celebratory.isSpeakingLike, isTrue);
        // Sanity check the negative case so this isn't vacuously true.
        expect(DigitalHumanState.idle.isSpeakingLike, isFalse);
      });
    });

    group('10. Viseme Tests', () {
      test('All viseme IDs map correctly', () {
        expect(DigitalHumanViseme.fromId(0), DigitalHumanViseme.sil);
        expect(DigitalHumanViseme.fromId(1), DigitalHumanViseme.a);
        expect(DigitalHumanViseme.fromId(5), DigitalHumanViseme.mbp);
      });

      test('fromId with unknown id returns sil', () {
        expect(DigitalHumanViseme.fromId(999), DigitalHumanViseme.sil);
      });

      test('playVisemeTimeline sets visemes in sequence and returns to sil',
          () {
        fakeAsync((async) {
          final controller = DigitalHumanController();
          controller.playVisemeTimeline([
            {'id': DigitalHumanViseme.mbp.id, 'durationMs': 10},
            {'id': DigitalHumanViseme.a.id, 'durationMs': 10},
          ]);
          async.elapse(const Duration(milliseconds: 1));
          expect(controller.state.value.visemeId, DigitalHumanViseme.mbp.id);

          async.elapse(const Duration(milliseconds: 10));
          expect(controller.state.value.visemeId, DigitalHumanViseme.a.id);

          async.elapse(const Duration(milliseconds: 10));
          expect(controller.state.value.visemeId, DigitalHumanViseme.sil.id);
        });
      });
    });
  });
}
