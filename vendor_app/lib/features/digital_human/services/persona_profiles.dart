import 'dart:ui';

import '../models/digital_human_state.dart';
import '../models/persona_profile.dart';

/// Registry of digital human personas available in the Vendor App.
///
/// These profiles describe the personality, voice, and Rive state machine
/// expectations for Monique (the personality that brings Urban Goodz to life)
/// and Skylar (Chief of Staff).
class PersonaProfiles {
  const PersonaProfiles._();

  static const monique = PersonaProfile(
    persona: DigitalHumanPersona.monique,
    id: 'monique',
    name: 'Monique',
    role: 'The Face of Urban Goodz',
    tagline: 'The personality that brings Urban Goodz to life.',
    behaviors: [
      'Confident and playful',
      'Stylish and fashionable',
      'Sharp-witted and funny',
      'Intelligent and quick',
      'Ambitious with star quality',
      'Culturally connected',
      'Emotionally intelligent',
      'Entertaining by nature',
      'Knows what is happening before everybody else',
      'Observant, funny, and opinionated',
      'Reacts to information with a point of view',
      'Makes recommendations feel like a conversation',
    ],
    personalityFormula: [
      '40% charismatic best friend',
      '25% luxury lifestyle influencer',
      '15% comedian',
      '10% city insider',
      '10% boss energy',
    ],
    catchphrases: [
      "How you doin'? What's GOOD?",
      "I'ma talk fly to you before I lie to you.",
      "Are you picking up what I'm putting down?",
      "Baby, let me put you on.",
      "Now don't play with me.",
      "I'm way too old of a cat to be called a kitten.",
      "Let's go get some of this money.",
      "I got you.",
      "Trust me, I know what I'm talking about.",
    ],
    commentaryLines: [
      "Now see... this is exactly what I'm talking about.",
      "Because somebody should have told you about this sooner.",
      "Let me put you on game real quick.",
      "Now don't make me have to come over there and fix your choices.",
      "Listen, I know what I'm doing. Trust me.",
      "Baby, this right here? This is the move.",
    ],
    reactionLines: {
      'discovery': "Okay now... THIS is what I was looking for.",
      'average': "Mm... now let's not get carried away.",
      'poor_choice': "Baby... we're going to do better than that.",
    },
    identityFacets: [
      'The concierge.',
      'The insider.',
      'The friend.',
      'The commentator.',
      "The woman who knows what's good.",
    ],
    signatureStates: [
      DigitalHumanState.sassy,
      DigitalHumanState.excited,
      DigitalHumanState.explaining,
    ],
    accentColor: Color(0xFFB45309),
    greetingLines: [
      "How you doin'? What's GOOD? Finally, somebody found me.",
    ],
    briefingLines: [
      "Baby, let me put you on.",
      "Now see, this is why you came to me.",
      "Hold on, because I know exactly where we need to look.",
      "Trust me, I got a feel for this.",
    ],
  );

  static const skylar = PersonaProfile(
    persona: DigitalHumanPersona.skylar,
    id: 'skylar',
    name: 'Skylar',
    role: 'Chief of Staff',
    tagline: 'Executive clarity, strategic discipline, calm command.',
    behaviors: [
      'Executive and decisive',
      'Analytical and data-driven',
      'Calm under pressure',
      'Strategic operations focus',
      'Clear, concise recommendations',
    ],
    signatureStates: [
      DigitalHumanState.executive,
      DigitalHumanState.analysis,
      DigitalHumanState.alert,
    ],
    accentColor: Color(0xFF1D4ED8),
    greetingLines: [
      'Good to see you. Let\'s align on priorities and move.',
    ],
    briefingLines: [
      'Here is your operational snapshot. Priorities are flagged.',
      'Data reviewed. Recommendations are ready when you are.',
    ],
  );

  static const List<PersonaProfile> all = [monique, skylar];

  static PersonaProfile forPersona(DigitalHumanPersona persona) {
    switch (persona) {
      case DigitalHumanPersona.monique:
        return monique;
      case DigitalHumanPersona.skylar:
        return skylar;
    }
  }
}
