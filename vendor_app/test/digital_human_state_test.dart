import 'package:flutter_test/flutter_test.dart';
import 'package:urban_goodz_vendor/features/digital_human/models/digital_human_state.dart';
import 'package:urban_goodz_vendor/features/digital_human/services/emotion_mapper.dart';
import 'package:urban_goodz_vendor/features/digital_human/services/persona_profiles.dart';

void main() {
  group('DigitalHumanStateModel', () {
    test('toJson emits the Rive contract input keys', () {
      const model = DigitalHumanStateModel(
        isSpeaking: true,
        emotion: DigitalHumanEmotion.sassy,
        gesture: DigitalHumanGesture.pointer,
        confidence: 0.92,
        visemeId: 1,
      );
      final json = model.toJson();
      expect(json.keys, containsAll([
        'isSpeaking',
        'isListening',
        'isThinking',
        'emotion',
        'gesture',
        'confidence',
        'viseme_id',
      ]));
      expect(json['isSpeaking'], isTrue);
      expect(json['emotion'], 1);
      expect(json['confidence'], 0.92);
    });

    test('toRiveInputs mirrors toJson values', () {
      const model = DigitalHumanStateModel(isThinking: true, visemeId: 4);
      final inputs = model.toRiveInputs();
      expect(inputs['isThinking'], isTrue);
      expect(inputs['viseme_id'], 4);
    });

    test('fromJson parses all fields and tolerates unknowns', () {
      final model = DigitalHumanStateModel.fromJson({
        'isSpeaking': true,
        'emotion': 8,
        'gesture': 3,
        'confidence': 0.5,
        'viseme_id': 7,
      });
      expect(model.isSpeaking, isTrue);
      expect(model.emotion, DigitalHumanEmotion.happy);
      expect(model.gesture, DigitalHumanGesture.thinkingPose);
      expect(model.confidence, 0.5);
      expect(model.visemeId, 7);

      final tolerant = DigitalHumanStateModel.fromJson({
        'emotion': 99,
        'gesture': -1,
        'confidence': 'nope',
      });
      expect(tolerant.emotion, DigitalHumanEmotion.neutral);
      expect(tolerant.gesture, DigitalHumanGesture.idle);
      expect(tolerant.confidence, 1.0);
      expect(tolerant.visemeId, 0);
    });

    test('resolveState precedence: speaking over listening over thinking', () {
      final model = DigitalHumanStateModel(
        isSpeaking: true,
        isListening: true,
        isThinking: true,
      );
      expect(model.resolveState(DigitalHumanPersona.monique),
          DigitalHumanState.speaking);
      expect(
        model
            .copyWith(isSpeaking: false)
            .resolveState(DigitalHumanPersona.monique),
        DigitalHumanState.listening,
      );
      expect(
        model
            .copyWith(isSpeaking: false, isListening: false)
            .resolveState(DigitalHumanPersona.monique),
        DigitalHumanState.thinking,
      );
    });

    test('resolveState maps persona signature emotions to persona states', () {
      const monique = DigitalHumanStateModel(
        emotion: DigitalHumanEmotion.sassy,
      );
      const skylar = DigitalHumanStateModel(
        emotion: DigitalHumanEmotion.executive,
      );
      const crossMonique = DigitalHumanStateModel(
        emotion: DigitalHumanEmotion.executive,
      );
      const crossSkylar = DigitalHumanStateModel(
        emotion: DigitalHumanEmotion.sassy,
      );
      expect(monique.resolveState(DigitalHumanPersona.monique),
          DigitalHumanState.sassy);
      expect(skylar.resolveState(DigitalHumanPersona.skylar),
          DigitalHumanState.executive);
      expect(crossMonique.resolveState(DigitalHumanPersona.monique),
          DigitalHumanState.speaking);
      expect(crossSkylar.resolveState(DigitalHumanPersona.skylar),
          DigitalHumanState.speaking);
    });

    test('resolveState falls back to happy/concerned/idle', () {
      const happy = DigitalHumanStateModel(emotion: DigitalHumanEmotion.happy);
      const concerned = DigitalHumanStateModel(
        emotion: DigitalHumanEmotion.concerned,
      );
      expect(happy.resolveState(DigitalHumanPersona.skylar),
          DigitalHumanState.happy);
      expect(concerned.resolveState(DigitalHumanPersona.monique),
          DigitalHumanState.concerned);
      expect(DigitalHumanStateModel.idle
              .resolveState(DigitalHumanPersona.monique),
          DigitalHumanState.idle);
    });
  });

  group('EmotionMapper', () {
    const mapper = EmotionMapper();

    test('maps natural language moods', () {
      expect(mapper.map('Sassy and confident'), DigitalHumanEmotion.sassy);
      expect(mapper.map('excited about the launch'), DigitalHumanEmotion.excited);
      expect(mapper.map('explain the numbers'), DigitalHumanEmotion.explaining);
      expect(mapper.map('executive summary'), DigitalHumanEmotion.executive);
      expect(mapper.map('strategic analysis'), DigitalHumanEmotion.analysis);
      expect(mapper.map('urgent alert'), DigitalHumanEmotion.alert);
      expect(mapper.map('concerned about inventory'), DigitalHumanEmotion.concerned);
      expect(mapper.map(''), DigitalHumanEmotion.neutral);
      expect(mapper.map('nothing here'), DigitalHumanEmotion.neutral);
    });

    test('personalityTag is persona friendly', () {
      expect(mapper.personalityTag(DigitalHumanEmotion.sassy), contains('real'));
      expect(mapper.personalityTag(DigitalHumanEmotion.excited),
          contains('momentum'));
    });
  });

  group('PersonaProfiles', () {
    test('defines Monique and Skylar personas', () {
      expect(PersonaProfiles.all, hasLength(2));
      final monique = PersonaProfiles.monique;
      final skylar = PersonaProfiles.skylar;
      expect(monique.name, 'Monique');
      expect(monique.role, 'The Face of Urban Goodz');
      expect(monique.behaviors, contains('Confident and playful'));
      expect(monique.behaviors,
          contains('Knows what is happening before everybody else'));
      expect(monique.personalityFormula,
          contains('40% charismatic best friend'));
      expect(monique.catchphrases, contains("Baby, let me put you on."));
      expect(monique.catchphrase(), "How you doin'? What's GOOD?");
      expect(monique.commentaryLines,
          contains("Now see... this is exactly what I'm talking about."));
      expect(monique.commentary(), contains('exactly what I\'m talking about'));
      expect(monique.reactionFor('discovery'),
          "Okay now... THIS is what I was looking for.");
      expect(monique.reactionFor('average'),
          "Mm... now let's not get carried away.");
      expect(monique.reactionFor('poor_choice'),
          "Baby... we're going to do better than that.");
      expect(monique.reactionFor('unknown_category'), isNotEmpty);
      expect(monique.identityFacets, contains('The insider.'));
      expect(monique.identityFacets, contains('The commentator.'));
      expect(monique.signatureStates,
          containsAll([DigitalHumanState.sassy, DigitalHumanState.excited]));
      expect(skylar.name, 'Skylar');
      expect(skylar.role, 'Chief of Staff');
      expect(skylar.signatureStates,
          containsAll([DigitalHumanState.executive, DigitalHumanState.analysis]));
    });

    test('forPersona resolves by key', () {
      expect(
        PersonaProfiles.forPersona(DigitalHumanPersona.monique).id,
        'monique',
      );
      expect(
        PersonaProfiles.forPersona(DigitalHumanPersona.skylar).id,
        'skylar',
      );
    });
  });
}
