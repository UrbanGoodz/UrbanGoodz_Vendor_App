/// Contract for the Skylar + Monique digital human state machine.
///
/// The Rive asset lane delivers rigged characters exposing the inputs defined
/// here. This model is the source of truth the app uses to drive the Rive
/// state machine (or the painted fallback) without depending on the .riv file
/// being present yet.
library;

/// Personas available in the Vendor App.
enum DigitalHumanPersona {
  monique,
  skylar;

  String get key => name;

  static DigitalHumanPersona fromKey(String? key) {
    final normalized = key?.toLowerCase();
    if (normalized == 'skylar' || normalized == 'chief_of_staff') {
      return DigitalHumanPersona.skylar;
    }
    return DigitalHumanPersona.monique;
  }
}

/// Core + persona-specific states.
///
/// Core states: Idle, Listening, Thinking, Speaking, Happy, Concerned.
/// Monique states: Sassy, Excited, Explaining.
/// Skylar states: Executive, Analysis, Alert.
enum DigitalHumanState {
  idle,
  listening,
  thinking,
  speaking,
  happy,
  concerned,
  sassy,
  excited,
  explaining,
  executive,
  analysis,
  alert;

  bool get isCore =>
      this == DigitalHumanState.idle ||
      this == DigitalHumanState.listening ||
      this == DigitalHumanState.thinking ||
      this == DigitalHumanState.speaking ||
      this == DigitalHumanState.happy ||
      this == DigitalHumanState.concerned;

  bool get isSpeakingLike =>
      this == DigitalHumanState.speaking ||
      this == DigitalHumanState.excited ||
      this == DigitalHumanState.explaining ||
      this == DigitalHumanState.analysis ||
      this == DigitalHumanState.alert;

  /// Human readable label for the given persona.
  String label(DigitalHumanPersona persona) {
    switch (this) {
      case DigitalHumanState.idle:
        return 'Idle';
      case DigitalHumanState.listening:
        return 'Listening';
      case DigitalHumanState.thinking:
        return 'Thinking';
      case DigitalHumanState.speaking:
        return 'Speaking';
      case DigitalHumanState.happy:
        return 'Happy';
      case DigitalHumanState.concerned:
        return 'Concerned';
      case DigitalHumanState.sassy:
        return persona == DigitalHumanPersona.monique ? 'Sassy' : 'Speaking';
      case DigitalHumanState.excited:
        return persona == DigitalHumanPersona.monique ? 'Excited' : 'Speaking';
      case DigitalHumanState.explaining:
        return persona == DigitalHumanPersona.monique
            ? 'Explaining'
            : 'Speaking';
      case DigitalHumanState.executive:
        return persona == DigitalHumanPersona.skylar
            ? 'Executive'
            : 'Speaking';
      case DigitalHumanState.analysis:
        return persona == DigitalHumanPersona.skylar
            ? 'Analysis'
            : 'Speaking';
      case DigitalHumanState.alert:
        return persona == DigitalHumanPersona.skylar ? 'Alert' : 'Speaking';
    }
  }
}

/// Emotion axis driven by the AI response tone.
enum DigitalHumanEmotion {
  neutral(0),
  sassy(1),
  excited(2),
  explaining(3),
  executive(4),
  analysis(5),
  alert(6),
  concerned(7),
  happy(8);

  final int value;
  const DigitalHumanEmotion(this.value);

  static DigitalHumanEmotion fromValue(Object? value) {
    final index = value is num ? value.toInt() : null;
    for (final emotion in DigitalHumanEmotion.values) {
      if (emotion.value == index) return emotion;
    }
    return DigitalHumanEmotion.neutral;
  }
}

/// Gesture axis for the animated body language.
enum DigitalHumanGesture {
  idle(0),
  nod(1),
  wave(2),
  thinkingPose(3),
  pointer(4),
  handGesture(5),
  subtleSmile(6),
  alertGesture(7);

  final int value;
  const DigitalHumanGesture(this.value);

  static DigitalHumanGesture fromValue(Object? value) {
    final index = value is num ? value.toInt() : null;
    for (final gesture in DigitalHumanGesture.values) {
      if (gesture.value == index) return gesture;
    }
    return DigitalHumanGesture.idle;
  }
}

/// Canonical viseme set used for lip-sync. Mirrors the `viseme_id` Rive input.
enum DigitalHumanViseme {
  sil(0, 'sil'),
  a(1, 'viseme_A'),
  e(2, 'viseme_E'),
  o(3, 'viseme_O'),
  u(4, 'viseme_U'),
  mbp(5, 'viseme_MBP'),
  fv(6, 'viseme_FV'),
  lndt(7, 'viseme_LNDT');

  final int id;
  final String name;
  const DigitalHumanViseme(this.id, this.name);

  static DigitalHumanViseme fromId(int id) {
    for (final viseme in DigitalHumanViseme.values) {
      if (viseme.id == id) return viseme;
    }
    return DigitalHumanViseme.sil;
  }
}

/// Immutable snapshot of the digital human inputs and their resolved state.
class DigitalHumanStateModel {
  final bool isSpeaking;
  final bool isListening;
  final bool isThinking;
  final DigitalHumanEmotion emotion;
  final DigitalHumanGesture gesture;
  final double confidence;
  final int visemeId;

  const DigitalHumanStateModel({
    this.isSpeaking = false,
    this.isListening = false,
    this.isThinking = false,
    this.emotion = DigitalHumanEmotion.neutral,
    this.gesture = DigitalHumanGesture.idle,
    this.confidence = 1.0,
    this.visemeId = 0,
  });

  static const idle = DigitalHumanStateModel();

  DigitalHumanStateModel copyWith({
    bool? isSpeaking,
    bool? isListening,
    bool? isThinking,
    DigitalHumanEmotion? emotion,
    DigitalHumanGesture? gesture,
    double? confidence,
    int? visemeId,
  }) {
    return DigitalHumanStateModel(
      isSpeaking: isSpeaking ?? this.isSpeaking,
      isListening: isListening ?? this.isListening,
      isThinking: isThinking ?? this.isThinking,
      emotion: emotion ?? this.emotion,
      gesture: gesture ?? this.gesture,
      confidence: confidence ?? this.confidence,
      visemeId: visemeId ?? this.visemeId,
    );
  }

  DigitalHumanStateModel clearFlags() => DigitalHumanStateModel(
    emotion: emotion,
    gesture: gesture,
    confidence: confidence,
    visemeId: visemeId,
  );

  /// Resolves the effective [DigitalHumanState] for a [persona] from the raw
  /// input flags and emotion.
  DigitalHumanState resolveState(DigitalHumanPersona persona) {
    if (isSpeaking) return DigitalHumanState.speaking;
    if (isListening) return DigitalHumanState.listening;
    if (isThinking) return DigitalHumanState.thinking;
    switch (emotion) {
      case DigitalHumanEmotion.happy:
        return DigitalHumanState.happy;
      case DigitalHumanEmotion.concerned:
        return DigitalHumanState.concerned;
      case DigitalHumanEmotion.sassy:
      case DigitalHumanEmotion.excited:
      case DigitalHumanEmotion.explaining:
        return persona == DigitalHumanPersona.monique
            ? _moniqueStateFor(emotion)
            : DigitalHumanState.speaking;
      case DigitalHumanEmotion.executive:
      case DigitalHumanEmotion.analysis:
      case DigitalHumanEmotion.alert:
        return persona == DigitalHumanPersona.skylar
            ? _skylarStateFor(emotion)
            : DigitalHumanState.speaking;
      case DigitalHumanEmotion.neutral:
        return DigitalHumanState.idle;
    }
  }

  static DigitalHumanState _moniqueStateFor(DigitalHumanEmotion emotion) {
    switch (emotion) {
      case DigitalHumanEmotion.sassy:
        return DigitalHumanState.sassy;
      case DigitalHumanEmotion.excited:
        return DigitalHumanState.excited;
      case DigitalHumanEmotion.explaining:
        return DigitalHumanState.explaining;
      default:
        return DigitalHumanState.idle;
    }
  }

  static DigitalHumanState _skylarStateFor(DigitalHumanEmotion emotion) {
    switch (emotion) {
      case DigitalHumanEmotion.executive:
        return DigitalHumanState.executive;
      case DigitalHumanEmotion.analysis:
        return DigitalHumanState.analysis;
      case DigitalHumanEmotion.alert:
        return DigitalHumanState.alert;
      default:
        return DigitalHumanState.idle;
    }
  }

  /// Serialized form contract with the backend digital-human endpoints.
  Map<String, dynamic> toJson() => {
    'isSpeaking': isSpeaking,
    'isListening': isListening,
    'isThinking': isThinking,
    'emotion': emotion.value,
    'gesture': gesture.value,
    'confidence': confidence,
    'viseme_id': visemeId,
  };

  factory DigitalHumanStateModel.fromJson(Map<String, dynamic> json) {
    final confidenceValue = json['confidence'];
    return DigitalHumanStateModel(
      isSpeaking: json['isSpeaking'] == true,
      isListening: json['isListening'] == true,
      isThinking: json['isThinking'] == true,
      emotion: DigitalHumanEmotion.fromValue(json['emotion']),
      gesture: DigitalHumanGesture.fromValue(json['gesture']),
      confidence: confidenceValue is num ? confidenceValue.toDouble() : 1.0,
      visemeId: (json['viseme_id'] as num?)?.toInt() ??
          DigitalHumanViseme.sil.id,
    );
  }

  /// Inputs as expected by the Rive state machine.
  Map<String, Object> toRiveInputs() => Map<String, Object>.from(toJson());

  @override
  bool operator ==(Object other) =>
      other is DigitalHumanStateModel &&
      other.isSpeaking == isSpeaking &&
      other.isListening == isListening &&
      other.isThinking == isThinking &&
      other.emotion == emotion &&
      other.gesture == gesture &&
      other.confidence == confidence &&
      other.visemeId == visemeId;

  @override
  int get hashCode => Object.hash(
    isSpeaking,
    isListening,
    isThinking,
    emotion,
    gesture,
    confidence,
    visemeId,
  );
}
