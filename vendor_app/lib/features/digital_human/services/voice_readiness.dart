/// Voice-readiness contract for the digital humans.
///
/// Production microphone permission, speech-to-text, text-to-speech, response
/// playback, and lip-sync viseme streaming are NOT enabled yet. These are the
/// integration seams the voice lane will implement; every default is a stub
/// that reports "not available" so the app degrades gracefully to the
/// on-screen personas.
library;

import 'dart:async';

class VoiceCapabilities {
  final bool microphonePermissionAvailable;
  final bool speechToTextAvailable;
  final bool textToSpeechAvailable;
  final bool responsePlaybackAvailable;
  final bool lipSyncAvailable;
  final String reason;

  const VoiceCapabilities({
    this.microphonePermissionAvailable = false,
    this.speechToTextAvailable = false,
    this.textToSpeechAvailable = false,
    this.responsePlaybackAvailable = false,
    this.lipSyncAvailable = false,
    this.reason = 'Voice features are not enabled yet.',
  });

  static const VoiceCapabilities none = VoiceCapabilities();

  bool get isVoiceEnabled =>
      microphonePermissionAvailable &&
      speechToTextAvailable &&
      textToSpeechAvailable &&
      responsePlaybackAvailable;

  VoiceCapabilities copyWith({
    bool? microphonePermissionAvailable,
    bool? speechToTextAvailable,
    bool? textToSpeechAvailable,
    bool? responsePlaybackAvailable,
    bool? lipSyncAvailable,
    String? reason,
  }) {
    return VoiceCapabilities(
      microphonePermissionAvailable:
          microphonePermissionAvailable ?? this.microphonePermissionAvailable,
      speechToTextAvailable:
          speechToTextAvailable ?? this.speechToTextAvailable,
      textToSpeechAvailable:
          textToSpeechAvailable ?? this.textToSpeechAvailable,
      responsePlaybackAvailable:
          responsePlaybackAvailable ?? this.responsePlaybackAvailable,
      lipSyncAvailable: lipSyncAvailable ?? this.lipSyncAvailable,
      reason: reason ?? this.reason,
    );
  }
}

/// Abstraction over OS microphone permission.
abstract class MicrophonePermissionGateway {
  Future<bool> hasPermission();
  Future<bool> requestPermission();
}

/// Abstraction over speech-to-text engines.
abstract class SpeechToTextGateway {
  Future<bool> isAvailable();
  Stream<String> partialResults();
  Future<String> listenOnce(Duration timeout);
}

/// Abstraction over text-to-speech engines.
abstract class TextToSpeechGateway {
  Future<bool> isAvailable();
  Future<void> speak(String text);
  Future<void> stop();
}

/// Plays an AI response (audio + transcript) back to the user.
abstract class VoiceResponsePlayer {
  Future<bool> isAvailable();
  Future<void> playResponse(String text);
  Future<void> stop();
}

/// Streams viseme ids (see [DigitalHumanViseme]) from the voice/audio lane for
/// lip-sync. Values must match the `viseme_id` Rive input.
abstract class LipSyncVisemeGateway {
  Stream<int> get visemeStream;
}

/// Dependency bundle for the digital human voice stack. The [none] instance is
/// the production default until the voice lane ships.
class DigitalHumanVoiceGateway {
  final VoiceCapabilities capabilities;
  final MicrophonePermissionGateway? microphonePermission;
  final SpeechToTextGateway? speechToText;
  final TextToSpeechGateway? textToSpeech;
  final VoiceResponsePlayer? responsePlayer;
  final LipSyncVisemeGateway? visemes;

  const DigitalHumanVoiceGateway({
    this.capabilities = VoiceCapabilities.none,
    this.microphonePermission,
    this.speechToText,
    this.textToSpeech,
    this.responsePlayer,
    this.visemes,
  });

  static const DigitalHumanVoiceGateway none = DigitalHumanVoiceGateway();

  bool get isVoiceEnabled => capabilities.isVoiceEnabled;

  /// Safely expose the viseme stream if lip-sync is available.
  Stream<int>? visemeStream() => visemes?.visemeStream;
}
