import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../models/digital_human_state.dart';
import 'voice_readiness.dart';

/// ElevenLabs Text-to-Speech gateway implementation.
///
/// Implements [TextToSpeechGateway] using the ElevenLabs REST API.
/// Voice IDs are resolved from environment configuration — never hardcoded.
///
/// Monique's canonical voice: "Sassy Aeristia"
/// Skylar's canonical voice: TBD
///
/// Configuration is supplied via:
///   ELEVENLABS_API_KEY
///   MONIQUE_ELEVENLABS_VOICE_ID
///   SKYLAR_ELEVENLABS_VOICE_ID
class ElevenLabsTtsGateway implements TextToSpeechGateway {
  ElevenLabsTtsGateway({
    required this.apiKey,
    required this.voiceIds,
    this.modelId = 'eleven_turbo_v2_5',
    this.outputFormat = 'mp3_44100_128',
    this.baseUrl = 'https://api.elevenlabs.io/v1',
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final String apiKey;
  final Map<DigitalHumanPersona, String> voiceIds;
  final String modelId;
  final String outputFormat;
  final String baseUrl;
  final http.Client _httpClient;

  DigitalHumanPersona _activePersona = DigitalHumanPersona.monique;

  /// Voice settings tuned per persona.
  static const Map<DigitalHumanPersona, Map<String, dynamic>> voiceSettings = {
    DigitalHumanPersona.monique: {
      'stability': 0.35,
      'similarity_boost': 0.82,
      'style': 0.75,
      'use_speaker_boost': true,
    },
    DigitalHumanPersona.skylar: {
      'stability': 0.65,
      'similarity_boost': 0.78,
      'style': 0.40,
      'use_speaker_boost': true,
    },
  };

  void setActivePersona(DigitalHumanPersona persona) {
    _activePersona = persona;
  }

  String? get activeVoiceId => voiceIds[_activePersona];

  bool get isConfigured =>
      apiKey.isNotEmpty && (activeVoiceId?.isNotEmpty ?? false);

  @override
  Future<bool> isAvailable() async => isConfigured;

  @override
  Future<void> speak(String text) async {
    final audio = await synthesize(text);
    if (audio == null) return;
    // Audio playback is handled by the voice response player lane.
    // This gateway only synthesizes; playback is delegated.
  }

  @override
  Future<void> stop() async {
    // Cancellation handled by the response player.
  }

  /// Synthesizes speech audio from [text] using the active persona's voice.
  /// Returns raw audio bytes or null on failure.
  Future<Uint8List?> synthesize(String text) async {
    final voiceId = activeVoiceId;
    if (voiceId == null || voiceId.isEmpty) {
      throw StateError(
        'No ElevenLabs voice ID configured for $_activePersona. '
        'Set ${_activePersona == DigitalHumanPersona.monique ? "MONIQUE_ELEVENLABS_VOICE_ID" : "SKYLAR_ELEVENLABS_VOICE_ID"} '
        'in your environment configuration.',
      );
    }

    final url = Uri.parse(
      '$baseUrl/text-to-speech/$voiceId?output_format=$outputFormat',
    );

    final settings = voiceSettings[_activePersona] ?? voiceSettings[DigitalHumanPersona.monique]!;

    final response = await _httpClient.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'xi-api-key': apiKey,
      },
      body: jsonEncode({
        'text': text,
        'model_id': modelId,
        'voice_settings': settings,
      }),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    return null;
  }

  /// Synthesizes speech and returns a stream of audio chunks for
  /// real-time playback with lower latency.
  Future<Stream<List<int>>?> synthesizeStream(String text) async {
    final voiceId = activeVoiceId;
    if (voiceId == null || voiceId.isEmpty) return null;

    final url = Uri.parse(
      '$baseUrl/text-to-speech/$voiceId/stream?output_format=$outputFormat',
    );

    final settings = voiceSettings[_activePersona] ?? voiceSettings[DigitalHumanPersona.monique]!;

    final request = http.Request('POST', url);
    request.headers.addAll({
      'Content-Type': 'application/json',
      'xi-api-key': apiKey,
    });
    request.body = jsonEncode({
      'text': text,
      'model_id': modelId,
      'voice_settings': settings,
    });

    final streamedResponse = await _httpClient.send(request);
    if (streamedResponse.statusCode == 200) {
      return streamedResponse.stream;
    }
    return null;
  }

  void dispose() {
    _httpClient.close();
  }
}

/// Factory that creates an [ElevenLabsTtsGateway] from environment configuration.
class ElevenLabsTtsFactory {
  const ElevenLabsTtsFactory();

  /// Creates a gateway from a configuration map.
  /// Expected keys: 'api_key', 'monique_voice_id', 'skylar_voice_id',
  /// and optionally 'model_id', 'output_format', 'base_url'.
  ElevenLabsTtsGateway? fromConfig(Map<String, String> config) {
    final apiKey = config['api_key'] ?? config['ELEVENLABS_API_KEY'] ?? '';
    if (apiKey.isEmpty) return null;

    final moniqueVoiceId =
        config['monique_voice_id'] ?? config['MONIQUE_ELEVENLABS_VOICE_ID'] ?? '';
    final skylarVoiceId =
        config['skylar_voice_id'] ?? config['SKYLAR_ELEVENLABS_VOICE_ID'] ?? '';

    return ElevenLabsTtsGateway(
      apiKey: apiKey,
      voiceIds: {
        DigitalHumanPersona.monique: moniqueVoiceId,
        DigitalHumanPersona.skylar: skylarVoiceId,
      },
      modelId: config['model_id'] ?? 'eleven_turbo_v2_5',
      outputFormat: config['output_format'] ?? 'mp3_44100_128',
      baseUrl: config['base_url'] ?? 'https://api.elevenlabs.io/v1',
    );
  }
}
