import 'dart:ui';

import 'digital_human_state.dart';

/// Static profile data for a digital human persona. Designed to be
/// read-only and safe to reference from const contexts.
class PersonaProfile {
  final DigitalHumanPersona persona;
  final String id;
  final String name;
  final String role;
  final String tagline;
  final List<String> behaviors;
  final List<String> personalityFormula;
  final List<String> catchphrases;
  final List<String> commentaryLines;
  final Map<String, String> reactionLines;
  final List<String> identityFacets;
  final List<DigitalHumanState> signatureStates;
  final Color accentColor;
  final List<String> greetingLines;
  final List<String> briefingLines;

  const PersonaProfile({
    required this.persona,
    required this.id,
    required this.name,
    required this.role,
    required this.tagline,
    required this.behaviors,
    required this.signatureStates,
    required this.accentColor,
    required this.greetingLines,
    required this.briefingLines,
    this.personalityFormula = const [],
    this.catchphrases = const [],
    this.commentaryLines = const [],
    this.reactionLines = const {},
    this.identityFacets = const [],
  });

  String get initials => name.isEmpty ? id : name.substring(0, 1).toUpperCase();

  String greeting() {
    return greetingLines.first;
  }

  String greetingFor(String timeOfDay) {
    return greetingLines.first;
  }

  /// A signature line to drop naturally into a conversation.
  String catchphrase() => catchphrases.isEmpty ? greeting() : catchphrases.first;

  /// An observational reaction, said like a friend with the inside scoop.
  String commentary() {
    return commentaryLines.isEmpty ? greeting() : commentaryLines.first;
  }

  /// A reaction for a situation category (e.g. `discovery`, `average`,
  /// `poor_choice`). Falls back to commentary if the category is unknown.
  String reactionFor(String category) {
    final reaction = reactionLines[category];
    if (reaction != null) return reaction;
    if (reactionLines.isNotEmpty) return reactionLines.values.first;
    return commentary();
  }
}
