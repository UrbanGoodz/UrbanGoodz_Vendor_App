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
    if (normalized.contains('sassy')) {
      return DigitalHumanEmotion.sassy;
    }
    if (normalized.contains('confident') || normalized.contains('assured')) {
      return DigitalHumanEmotion.confident;
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
    if (normalized.contains('amused') || normalized.contains('funny') || normalized.contains('humor') || normalized.contains('laugh')) {
      return DigitalHumanEmotion.amused;
    }
    if (normalized.contains('curious') || normalized.contains('wonder') || normalized.contains('interest')) {
      return DigitalHumanEmotion.curious;
    }
    if (normalized.contains('empathetic') || normalized.contains('sympathetic') || normalized.contains('compassion')) {
      return DigitalHumanEmotion.empathetic;
    }
    if (normalized.contains('frustrated') || normalized.contains('annoyed') || normalized.contains('irritat')) {
      return DigitalHumanEmotion.frustrated;
    }
    if (normalized.contains('surprised') || normalized.contains('shock') || normalized.contains('unexpected')) {
      return DigitalHumanEmotion.surprised;
    }
    if (normalized.contains('focused') || normalized.contains('concentrat') || normalized.contains('determined')) {
      return DigitalHumanEmotion.focused;
    }
    if (normalized.contains('urgent') || normalized.contains('immediate') || normalized.contains('critical')) {
      return DigitalHumanEmotion.urgent;
    }
    if (normalized.contains('celebrat') || normalized.contains('victory') || normalized.contains('accomplish')) {
      return DigitalHumanEmotion.celebratory;
    }
    if (normalized.contains('think') || normalized.contains('ponder') || normalized.contains('consider')) {
      return DigitalHumanEmotion.thinking;
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
      case DigitalHumanEmotion.confident:
        return 'Bold & Assured';
      case DigitalHumanEmotion.amused:
        return 'Playful & Amused';
      case DigitalHumanEmotion.curious:
        return 'Curious & Engaged';
      case DigitalHumanEmotion.empathetic:
        return 'Warm & Understanding';
      case DigitalHumanEmotion.frustrated:
        return 'Direct & Persistent';
      case DigitalHumanEmotion.surprised:
        return 'Surprised & Reactive';
      case DigitalHumanEmotion.focused:
        return 'Locked In';
      case DigitalHumanEmotion.urgent:
        return 'Urgent & Decisive';
      case DigitalHumanEmotion.celebratory:
        return 'Celebrating Wins';
      case DigitalHumanEmotion.thinking:
        return 'Processing & Considering';
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
      case DigitalHumanEmotion.confident:
        return const Color(0xFFF59E0B); // amber-500
      case DigitalHumanEmotion.amused:
        return const Color(0xFFEC4899); // pink-500
      case DigitalHumanEmotion.curious:
        return const Color(0xFF8B5CF6); // violet-500
      case DigitalHumanEmotion.empathetic:
        return const Color(0xFF14B8A6); // teal-500
      case DigitalHumanEmotion.frustrated:
        return const Color(0xFFF97316); // orange-500
      case DigitalHumanEmotion.surprised:
        return const Color(0xFFEAB308); // yellow-500
      case DigitalHumanEmotion.focused:
        return const Color(0xFF6366F1); // indigo-500
      case DigitalHumanEmotion.urgent:
        return const Color(0xFFEF4444); // red-500
      case DigitalHumanEmotion.celebratory:
        return const Color(0xFF22C55E); // green-500
      case DigitalHumanEmotion.thinking:
        return const Color(0xFF64748B); // slate-500
      case DigitalHumanEmotion.neutral:
        return const Color(0xFF334155); // slate-700
    }
  }

  /// Short personality tag appended to the persona's summary line.
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
      case DigitalHumanEmotion.confident:
        return 'standing on business';
      case DigitalHumanEmotion.amused:
        return 'this is funny';
      case DigitalHumanEmotion.curious:
        return 'tell me more';
      case DigitalHumanEmotion.empathetic:
        return 'I hear you';
      case DigitalHumanEmotion.frustrated:
        return 'let\'s fix this';
      case DigitalHumanEmotion.surprised:
        return 'wait, what?';
      case DigitalHumanEmotion.focused:
        return 'locked in';
      case DigitalHumanEmotion.urgent:
        return 'right now';
      case DigitalHumanEmotion.celebratory:
        return 'let\'s gooo';
      case DigitalHumanEmotion.thinking:
        return 'processing';
      case DigitalHumanEmotion.neutral:
        return 'on it';
    }
  }
}
