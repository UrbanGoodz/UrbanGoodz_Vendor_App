import 'package:flutter/services.dart';

import '../models/digital_human_state.dart';

/// Locates and validates the Rive animation files backing each persona.
///
/// The .riv assets are delivered by the digital-human asset lane in a later
/// release. Until `assets/digital_human/monique.riv` and
/// `assets/digital_human/skylar.riv` exist, [isAssetAvailable] returns false
/// and the app renders the painted fallback avatar instead — no placeholders,
/// no fabricated binaries, no crash.
class RiveAssetManager {
  RiveAssetManager._();

  static final RiveAssetManager instance = RiveAssetManager._();

  static const String moniqueAssetPath = 'assets/digital_human/monique.riv';
  static const String skylarAssetPath = 'assets/digital_human/skylar.riv';

  final Map<String, bool> _cache = <String, bool>{};

  String pathFor(DigitalHumanPersona persona) {
    switch (persona) {
      case DigitalHumanPersona.monique:
        return moniqueAssetPath;
      case DigitalHumanPersona.skylar:
        return skylarAssetPath;
    }
  }

  /// Returns true only when the persona's .riv file is bundled and readable.
  Future<bool> isAssetAvailable(DigitalHumanPersona persona) async {
    final key = persona.key;
    final cached = _cache[key];
    if (cached != null) return cached;

    var available = false;
    try {
      final data = await rootBundle.load(pathFor(persona));
      available = data.lengthInBytes > 0;
    } catch (_) {
      available = false;
    }
    _cache[key] = available;
    return available;
  }

  void clearCache() => _cache.clear();
}
