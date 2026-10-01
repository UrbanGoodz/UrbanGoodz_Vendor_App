import 'dart:async';

import 'package:get/get.dart';

import '../models/digital_human_state.dart';
import '../services/emotion_mapper.dart';
import '../services/persona_profiles.dart';
import '../services/voice_readiness.dart';

/// Drives the visible digital human state, persona switching, personality
/// hooks, and the viseme timeline used for lip-sync preview.
class DigitalHumanController extends GetxController {
  DigitalHumanController({
    this._voiceGateway = const DigitalHumanVoiceGateway(),
    this._emotionMapper = const EmotionMapper(),
  }) {
    statusMessage.value = _statusFor(state.value);
  }

  final DigitalHumanVoiceGateway _voiceGateway;
  final EmotionMapper _emotionMapper;

  final Rxn<DigitalHumanPersona> persona = Rxn<DigitalHumanPersona>();

  final Rx<DigitalHumanStateModel> state = Rx<DigitalHumanStateModel>(
    DigitalHumanStateModel.idle,
  );

  final RxString statusMessage = ''.obs;
  final RxBool isPersonalityPaused = false.obs;

  StreamSubscription<int>? _visemeSubscription;
  Timer? _visemeTimer;

  DigitalHumanPersona get activePersona =>
      persona.value ?? DigitalHumanPersona.monique;

  bool get isVoiceEnabled => _voiceGateway.isVoiceEnabled;

  DigitalHumanStateModel get currentState => state.value;

  @override
  void onInit() {
    super.onInit();
    persona.value ??= DigitalHumanPersona.monique;
  }

  @override
  void onClose() {
    _visemeTimer?.cancel();
    _visemeSubscription?.cancel();
    super.onClose();
  }

  void activatePersona(DigitalHumanPersona next) {
    if (persona.value == next) return;
    persona.value = next;
    setState(currentState);
  }

  void togglePersona() {
    final current = activePersona;
    activatePersona(
      current == DigitalHumanPersona.monique
          ? DigitalHumanPersona.skylar
          : DigitalHumanPersona.monique,
    );
  }

  void setState(DigitalHumanStateModel next) {
    state.value = next;
    statusMessage.value = _statusFor(next);
    update();
  }

  void setSpeaking({int? visemeId}) {
    setState(
      currentState.copyWith(
        isSpeaking: true,
        isListening: false,
        isThinking: false,
        visemeId: visemeId,
      ),
    );
  }

  void setListening() => setState(
    currentState.copyWith(isListening: true, isSpeaking: false),
  );

  void setThinking() => setState(
    currentState.copyWith(isThinking: true, isSpeaking: false),
  );

  void setIdle() => setState(
    currentState.copyWith(
      isSpeaking: false,
      isListening: false,
      isThinking: false,
      visemeId: DigitalHumanViseme.sil.id,
    ),
  );

  void setEmotion(DigitalHumanEmotion emotion) {
    setState(currentState.copyWith(emotion: emotion));
  }

  void setMood(String mood) => setEmotion(_emotionMapper.map(mood));

  void setGesture(DigitalHumanGesture gesture) {
    setState(currentState.copyWith(gesture: gesture));
  }

  void setConfidence(double confidence) {
    setState(currentState.copyWith(confidence: confidence));
  }

  void setViseme(int visemeId) {
    setState(currentState.copyWith(visemeId: visemeId));
  }

  void showMoment(String message) {
    statusMessage.value = message;
    update();
  }

  void pausePersonality() {
    isPersonalityPaused.value = true;
    update();
  }

  void resumePersonality() {
    isPersonalityPaused.value = false;
    update();
  }

  /// Plays a viseme timeline (list of `{id, durationMs}` frames) to preview
  /// lip-sync without the voice lane. Sil returns to closed-mouth at the end.
  void playVisemeTimeline(List<Map<String, Object?>> frames) {
    _visemeTimer?.cancel();
    if (frames.isEmpty) {
      setViseme(DigitalHumanViseme.sil.id);
      return;
    }
    var elapsed = Duration.zero;
    for (final frame in frames) {
      final id = (frame['id'] as num?)?.toInt() ?? DigitalHumanViseme.sil.id;
      final durationMs =
          (frame['durationMs'] as num?)?.toDouble() ?? 120.0;
      _visemeTimer = Timer(
        elapsed,
        () => setViseme(id),
      );
      elapsed += Duration(microseconds: (durationMs * 1000).round());
    }
    _visemeTimer = Timer(
      elapsed,
      () => setViseme(DigitalHumanViseme.sil.id),
    );
  }

  void stopVisemeTimeline() {
    _visemeTimer?.cancel();
    _visemeTimer = null;
    setViseme(DigitalHumanViseme.sil.id);
  }

  /// Personality hook — greets with the active persona's voice.
  String greeting() {
    final profile = PersonaProfiles.forPersona(activePersona);
    final greeting = profile.greeting();
    if (isPersonalityPaused.value) return profile.tagline;
    return greeting;
  }

  /// Personality hook — the active persona's signature line.
  String catchphrase() {
    return PersonaProfiles.forPersona(activePersona).catchphrase();
  }

  /// Personality hook — an observational line with the inside scoop.
  String commentary() {
    return PersonaProfiles.forPersona(activePersona).commentary();
  }

  /// Personality hook — reaction for a situation (`discovery`, `average`,
  /// `poor_choice`, ...) delivered like a friend with a point of view.
  String reaction(String category) {
    return PersonaProfiles.forPersona(activePersona).reactionFor(category);
  }

  /// Personality hook — styles a daily brief summary with the active
  /// persona's voice and resolved emotion. Pass [reaction] to open with a
  /// situational reaction line instead of the standard briefing lead.
  String personalityResponse({
    required String briefSummary,
    String? mood,
    String? reaction,
  }) {
    final profile = PersonaProfiles.forPersona(activePersona);
    final emotion = mood == null
        ? DigitalHumanEmotion.neutral
        : _emotionMapper.map(mood);
    final tag = _emotionMapper.personalityTag(emotion);
    final lead = reaction != null
        ? profile.reactionFor(reaction)
        : isPersonalityPaused.value
        ? profile.tagline
        : profile.briefingLines.first;
    return '$lead $briefSummary — $tag.';
  }

  String _statusFor(DigitalHumanStateModel model) {
    final resolved = model.resolveState(activePersona);
    return resolved.label(activePersona);
  }
}
