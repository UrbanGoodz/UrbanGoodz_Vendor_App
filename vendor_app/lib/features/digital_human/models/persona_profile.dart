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
  });

  String get initials => name.isEmpty ? id : name.substring(0, 1).toUpperCase();

  String greeting() {
    return greetingLines.first;
  }

  String greetingFor(String timeOfDay) {
    return greetingLines.first;
  }
}
