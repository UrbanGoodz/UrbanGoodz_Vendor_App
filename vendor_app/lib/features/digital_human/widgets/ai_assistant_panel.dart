import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/daily_brief_model.dart';
import '../controllers/digital_human_controller.dart';
import '../models/digital_human_state.dart';
import '../models/persona_profile.dart';
import '../services/persona_profiles.dart';
import 'digital_human_avatar_widget.dart';

/// High-level assistant surface for the digital humans.
///
/// Renders the avatar (Rive or painted fallback), the persona greeting, the
/// status line, optional personality-styled Daily Brief summary, mood controls,
/// and a voice-readiness notice until the voice lane ships.
class AiAssistantPanel extends StatelessWidget {
  const AiAssistantPanel({
    super.key,
    required this.controller,
    this.dailyBrief,
    this.briefLoading = false,
  });

  final DigitalHumanController controller;
  final DailyBriefModel? dailyBrief;
  final bool briefLoading;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final persona = controller.activePersona;
      final profile = PersonaProfiles.forPersona(persona);
      final status = controller.statusMessage.value;
      final brief = dailyBrief;

      return Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              profile.accentColor.withValues(alpha: 0.12),
              Colors.black.withValues(alpha: 0.25),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: profile.accentColor.withValues(alpha: 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(profile),
            const SizedBox(height: 12),
            Center(
              child: DigitalHumanAvatarWidget(
                controller: controller,
                size: 240,
              ),
            ),
            const SizedBox(height: 8),
            if (status.isNotEmpty)
              Center(
                child: Text(
                  status,
                  style: TextStyle(
                    color: profile.accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            if (briefLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else if (brief != null && brief.success)
              _buildBriefCard(profile, brief)
            else if (brief != null && !brief.success)
              _buildBriefError(profile, brief.error),
            if (!controller.isVoiceEnabled)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.mic_off,
                      size: 14,
                      color: Colors.white38,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Voice is not enabled yet. Lip-sync and visual responses '
                        'are available; microphone/voice playback ships with the '
                        'voice lane.',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(PersonaProfile profile) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: profile.accentColor,
          child: Text(
            profile.initials,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                profile.role,
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
        ),
        PopupMenuButton<DigitalHumanPersona>(
          icon: const Icon(Icons.swap_horiz, color: Colors.white70),
          tooltip: 'Switch assistant',
          onSelected: (persona) => controller.activatePersona(persona),
          itemBuilder: (context) => [
            for (final persona in DigitalHumanPersona.values)
              PopupMenuItem(
                value: persona,
                child: Text(PersonaProfiles.forPersona(persona).name),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildBriefCard(PersonaProfile profile, DailyBriefModel brief) {
    final personality = controller.personalityResponse(
      briefSummary: brief.summary.isEmpty ? brief.todaysOutlook : brief.summary,
      mood: brief.todaysOutlook,
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: profile.accentColor.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            personality,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final emotion in DigitalHumanEmotion.values.take(6))
                _emotionChip(profile, emotion),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBriefError(PersonaProfile profile, String? error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFDC2626).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDC2626).withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        error ?? 'Daily brief could not be loaded.',
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }

  Widget _emotionChip(PersonaProfile profile, DigitalHumanEmotion emotion) {
    final controller = this.controller;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => controller.setEmotion(emotion),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: controller.currentState.emotion == emotion
              ? profile.accentColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: profile.accentColor.withValues(alpha: 0.5)),
        ),
        child: Text(
          emotion.name,
          style: TextStyle(
            color: controller.currentState.emotion == emotion
                ? Colors.white
                : Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
