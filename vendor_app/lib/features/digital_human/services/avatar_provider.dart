/// Capabilities a provider may support.
enum AvatarCapability {
  voice,
  video,
  liveAvatar,
  facialExpression,
  bodyAnimation,
  lipSync,
  realTimeConversation,
  stateMachines,
}

/// Supported provider identifiers.
enum AvatarProviderId {
  elevenlabs,
  heygen,
  did,
  metahuman,
  newportai,
  rive,
}

/// Base contract for all avatar providers.
abstract class AvatarProvider {
  AvatarProviderId get id;
  String get displayName;
  Set<AvatarCapability> get capabilities;
  bool supports(AvatarCapability capability) => capabilities.contains(capability);
  Future<bool> isAvailable();
  Future<void> initialize(Map<String, String> config);
  Future<void> dispose();
}

/// Voice provider contract.
abstract class VoiceProvider extends AvatarProvider {
  Future<dynamic> synthesize(String text, {String? voiceId});
  Future<Stream<List<int>>?> synthesizeStream(String text, {String? voiceId});
}

/// Video generation provider contract.
abstract class VideoProvider extends AvatarProvider {
  Future<dynamic> generateVideo({required String text, required String avatarImagePath});
}

/// Real-time avatar provider contract.
abstract class LiveAvatarProvider extends AvatarProvider {
  Future<void> startSession({required String avatarImagePath, Map<String, dynamic>? options});
  Future<void> sendMessage(String text);
  Future<void> endSession();
}

/// Animation/expression provider contract (Rive, MetaHuman).
abstract class AnimationProvider extends AvatarProvider {
  Future<void> setEmotion(int emotionValue);
  Future<void> setGesture(int gestureValue);
  Future<void> setViseme(int visemeId);
  Future<void> setState(Map<String, Object> inputs);
}

/// Registry and resolver for providers.
class AvatarProviderRegistry {
  final Map<AvatarProviderId, AvatarProvider> _providers = {};

  void register(AvatarProvider provider) {
    _providers[provider.id] = provider;
  }

  void unregister(AvatarProviderId id) {
    _providers.remove(id);
  }

  AvatarProvider? get(AvatarProviderId id) => _providers[id];

  T? getAs<T extends AvatarProvider>(AvatarProviderId id) {
    final provider = _providers[id];
    return provider is T ? provider : null;
  }

  List<AvatarProvider> withCapability(AvatarCapability capability) {
    return _providers.values
        .where((p) => p.supports(capability))
        .toList();
  }

  VoiceProvider? get voiceProvider {
    final providers = withCapability(AvatarCapability.voice);
    return providers.isEmpty ? null : providers.first as VoiceProvider;
  }

  AnimationProvider? get animationProvider {
    final providers = withCapability(AvatarCapability.stateMachines);
    return providers.isEmpty ? null : providers.first as AnimationProvider;
  }

  List<AvatarProviderId> get registeredIds => _providers.keys.toList();

  Future<void> disposeAll() async {
    for (final provider in _providers.values) {
      await provider.dispose();
    }
    _providers.clear();
  }
}
