import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../controllers/digital_human_controller.dart';
import '../models/digital_human_state.dart';
import '../models/persona_profile.dart';
import '../services/persona_profiles.dart';
import '../services/rive_asset_manager.dart';
import 'rive_digital_human_view.dart';
import 'viseme_mouth_painter.dart';

/// Interactive digital human avatar.
///
/// When the persona's .riv asset is available the widget renders the Rive
/// animation and pushes the state machine inputs from the controller. Until
/// the assets ship, a painted fallback avatar (monogram, eyes, lip-sync mouth)
/// is rendered so the integration can be developed and tested end-to-end.
class DigitalHumanAvatarWidget extends StatefulWidget {
  const DigitalHumanAvatarWidget({
    super.key,
    required this.controller,
    this.size = 220,
    this.showBadge = true,
    this.showControls = true,
    this.onTap,
  });

  final DigitalHumanController controller;
  final double size;
  final bool showBadge;
  final bool showControls;
  final VoidCallback? onTap;

  @override
  State<DigitalHumanAvatarWidget> createState() =>
      _DigitalHumanAvatarWidgetState();
}

class _DigitalHumanAvatarWidgetState extends State<DigitalHumanAvatarWidget>
    with TickerProviderStateMixin {
  late final AnimationController _breathing;
  late final AnimationController _blink;
  late final AnimationController _pulse;
  final math.Random _random = math.Random(42);
  bool? _riveAvailable;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
    _breathing = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
    _blink = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4600),
    )..repeat();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
    _resolveRiveAvailability();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _breathing.dispose();
    _blink.dispose();
    _pulse.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _resolveRiveAvailability() async {
    final persona = widget.controller.activePersona;
    final available = await RiveAssetManager.instance
        .isAssetAvailable(persona);
    if (mounted) {
      setState(() => _riveAvailable = available);
    }
  }

  @override
  void didUpdateWidget(covariant DigitalHumanAvatarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
      _riveAvailable = null;
      _resolveRiveAvailability();
    }
  }

  DigitalHumanState get _resolvedState =>
      widget.controller.currentState.resolveState(widget.controller.activePersona);

  bool get _speaking =>
      widget.controller.currentState.isSpeaking ||
      _resolvedState.isSpeakingLike;

  double get _breathScale => 1 + math.sin(_breathing.value * 2 * math.pi) * 0.018;

  double get _eyeHeightFactor {
    final t = _blink.value;
    if (t < 0.88) return 1.0;
    final local = (t - 0.88) / 0.12;
    return 1.0 - math.sin(local * math.pi) * 0.92;
  }

  @override
  Widget build(BuildContext context) {
    final persona = widget.controller.activePersona;
    final profile = PersonaProfiles.forPersona(persona);
    final model = widget.controller.currentState;
    final useRive = _riveAvailable == true;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (useRive)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: RiveDigitalHumanView(
                  assetPath: RiveAssetManager.instance.pathFor(persona),
                  controller: widget.controller,
                ),
              ),
            )
          else
            Positioned.fill(child: _buildFallbackFace(profile, model)),
          if (widget.showBadge)
            Positioned(top: 10, left: 10, child: _buildBadge(profile, model)),
          if (widget.showControls)
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: _buildControls(),
            ),
          if (widget.onTap != null)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: widget.onTap,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFallbackFace(PersonaProfile profile, DigitalHumanStateModel model) {
    final accent = profile.accentColor;
    final monogramSize = widget.size * 0.44;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accent.withValues(alpha: 0.22),
                accent.withValues(alpha: 0.06),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: accent.withValues(alpha: 0.35)),
          ),
        ),
        if (_speaking)
          AnimatedBuilder(
            animation: _pulse,
            builder: (context, _) {
              final t = _pulse.value;
              return Container(
                width: monogramSize * (1 + t * 0.28),
                height: monogramSize * (1 + t * 0.28),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accent.withValues(alpha: (1 - t) * 0.5),
                    width: 3,
                  ),
                ),
              );
            },
          ),
        AnimatedBuilder(
          animation: _breathing,
          builder: (context, _) {
            return Transform.scale(
              scale: _breathScale,
              child: Container(
                width: monogramSize,
                height: monogramSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      accent.withValues(alpha: 0.9),
                      Color.lerp(accent, Colors.black, 0.45)!,
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.4),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Text(
                  profile.initials,
                  style: TextStyle(
                    fontSize: monogramSize * 0.44,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
        // Eyes
        AnimatedBuilder(
          animation: _blink,
          builder: (context, _) {
            return Positioned(
              left: widget.size * 0.36,
              top: widget.size * 0.38,
              child: Row(
                children: [
                  _Eye(size: monogramSize * 0.055, heightFactor: _eyeHeightFactor),
                  SizedBox(width: monogramSize * 0.16),
                  _Eye(size: monogramSize * 0.055, heightFactor: _eyeHeightFactor),
                ],
              ),
            );
          },
        ),
        // Mouth / lip-sync
        Positioned(
          bottom: monogramSize * 0.06,
          child: AnimatedBuilder(
            animation: _blink,
            builder: (context, _) {
              final openness = visemeOpenness(model.visemeId);
              final anchor = visemeAnchor(model.visemeId, Size(widget.size, widget.size), _random);
              final mouthSize = monogramSize * (0.26 + openness * 0.3);
              return Transform.translate(
                offset: anchor,
                child: AnimatedScale(
                  scale: 0.6 + openness * 0.5,
                  duration: const Duration(milliseconds: 90),
                  child: CustomPaint(
                    size: Size(mouthSize, mouthSize * 0.55),
                    painter: VisemeMouthPainter(visemeId: model.visemeId),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(PersonaProfile profile, DigitalHumanStateModel model) {
    final label = model.resolveState(widget.controller.activePersona).label(
      widget.controller.activePersona,
    );
    final color = profile.accentColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _speaking ? Colors.redAccent : color,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '${profile.name.toUpperCase()} · ${label.toUpperCase()}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    final controller = widget.controller;
    final active = controller.activePersona;
    final voiceEnabled = controller.isVoiceEnabled;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        runSpacing: 4,
        children: [
          _personaChip(
            DigitalHumanPersona.monique,
            active == DigitalHumanPersona.monique,
          ),
          _personaChip(
            DigitalHumanPersona.skylar,
            active == DigitalHumanPersona.skylar,
          ),
          _iconButton(
            tooltip: 'Lip-sync preview',
            icon: Icons.record_voice_over_outlined,
            onPressed: () => _playPreview(),
          ),
          _iconButton(
            tooltip: voiceEnabled
                ? 'Mic ready'
                : 'Voice not enabled yet',
            icon: Icons.mic_none,
            enabled: voiceEnabled,
            onPressed: () {
              controller.setListening();
              controller.showMoment('Listening...');
            },
          ),
        ],
      ),
    );
  }

  Widget _personaChip(DigitalHumanPersona persona, bool selected) {
    final profile = PersonaProfiles.forPersona(persona);
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => widget.controller.activatePersona(persona),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? profile.accentColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          profile.name,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _iconButton({
    required String tooltip,
    required IconData icon,
    required VoidCallback onPressed,
    bool enabled = true,
  }) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        visualDensity: VisualDensity.compact,
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.all(6),
        iconSize: 16,
        color: enabled ? Colors.white : Colors.white38,
        icon: Icon(icon),
        onPressed: enabled ? onPressed : null,
      ),
    );
  }

  void _playPreview() {
    final controller = widget.controller;
    controller.setSpeaking(visemeId: DigitalHumanViseme.a.id);
    controller.showMoment('Lip-sync preview');
    controller.playVisemeTimeline(const [
      {'id': 1, 'durationMs': 160}, // A
      {'id': 3, 'durationMs': 150}, // O
      {'id': 2, 'durationMs': 140}, // E
      {'id': 5, 'durationMs': 120}, // MBP
      {'id': 1, 'durationMs': 160}, // A
      {'id': 6, 'durationMs': 130}, // FV
      {'id': 7, 'durationMs': 140}, // LNDT
    ]);
    Future.delayed(const Duration(milliseconds: 1300), () {
      if (mounted) controller.setIdle();
    });
  }
}

class _Eye extends StatelessWidget {
  const _Eye({required this.size, required this.heightFactor});

  final double size;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 80),
      width: size,
      height: size * 2 * heightFactor,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(size),
      ),
    );
  }
}
