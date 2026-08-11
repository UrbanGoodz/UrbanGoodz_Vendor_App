import 'package:flutter/material.dart';

import '../models/digital_human_state.dart';

/// Maps natural-language tone/mood signals from the AI response pipeline into
/// the digital human's [DigitalHumanEmotion] axis, along with a display color
/// and a short persona-flavored personality tag.
class EmotionMapper {
  const EmotionMapper();

  DigitalHumanEmotion map(String mood) {
    final normalized = mood.trim().toLowerCase();
    if (normalized.isEmpty) return DigitalHumanEmotion.neutral;
    if (normalized.contains('happy') || normalized.contains('excited')) {
      return DigitalHumanEmotion.excited;
    }
    if (normalized.contains('sassy') || normalized.contains('confident')) {
      return DigitalHumanEmotion.sassy;
    }
    if (normalized.contains('explain') || normalized.contains('educat')) {
      return DigitalHumanEmotion.explaining;
    }
    if (normalized.contains('executive') ||
        normalized.contains('formal') ||
        normalized.contains('professional')) {
      return DigitalHumanEmotion.executive;
    }
    if (normalized.contains('analys') || normalized.contains('strateg')) {
      return DigitalHumanEmotion.analysis;
    }
    if (normalized.contains('urgent') ||
        normalized.contains('alert') ||
        normalized.contains('warn')) {
      return DigitalHumanEmotion.alert;
    }
    if (normalized.contains('concern') || normalized.contains('care')) {
      return DigitalHumanEmotion.concerned;
    }
    if (normalized.contains('joy')) return DigitalHumanEmotion.happy;
    return DigitalHumanEmotion.neutral;
  }

  String moodLabel(DigitalHumanEmotion emotion) {
    switch (emotion) {
      case DigitalHumanEmotion.neutral:
        return 'Warm & Professional';
      case DigitalHumanEmotion.sassy:
        return 'Sassy & Bold';
      case DigitalHumanEmotion.excited:
        return 'Excited & Energized';
      case DigitalHumanEmotion.explaining:
        return 'Explaining Simply';
      case DigitalHumanEmotion.executive:
        return 'Executive & Decisive';
      case DigitalHumanEmotion.analysis:
        return 'Analytical & Clear';
      case DigitalHumanEmotion.alert:
        return 'Alert & Focused';
      case DigitalHumanEmotion.concerned:
        return 'Attentive & Caring';
      case DigitalHumanEmotion.happy:
        return 'Happy & Cheerful';
    }
  }

  Color accentFor(DigitalHumanEmotion emotion) {
    switch (emotion) {
      case DigitalHumanEmotion.sassy:
        return const Color(0xFFB45309); // amber-700
      case DigitalHumanEmotion.excited:
        return const Color(0xFF9333EA); // purple-600
      case DigitalHumanEmotion.explaining:
        return const Color(0xFF0EA5E9); // sky-500
      case DigitalHumanEmotion.executive:
        return const Color(0xFF1D4ED8); // blue-700
      case DigitalHumanEmotion.analysis:
        return const Color(0xFF0369A1); // sky-800
      case DigitalHumanEmotion.alert:
        return const Color(0xFFDC2626); // red-600
      case DigitalHumanEmotion.concerned:
        return const Color(0xFF059669); // emerald-600
      case DigitalHumanEmotion.happy:
        return const Color(0xFF16A34A); // green-600
      case DigitalHumanEmotion.neutral:
        return const Color(0xFF334155); // slate-700
    }
  }

  /// Short personality tag appended to the assistant's summary line.
  String personalityTag(DigitalHumanEmotion emotion) {
    switch (emotion) {
      case DigitalHumanEmotion.sassy:
        return 'keeping it real';
      case DigitalHumanEmotion.excited:
        return 'feeling this momentum';
      case DigitalHumanEmotion.explaining:
        return 'walking you through it';
      case DigitalHumanEmotion.executive:
        return 'decision-ready';
      case DigitalHumanEmotion.analysis:
        return 'here\'s the breakdown';
      case DigitalHumanEmotion.alert:
        return 'flagging this now';
      case DigitalHumanEmotion.concerned:
        return 'keeping an eye on this';
      case DigitalHumanEmotion.happy:
        return 'love to see it';
      case DigitalHumanEmotion.neutral:
        return 'on it';
    }
  }
}
