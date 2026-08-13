import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/digital_human_state.dart';

/// Paints a stylized mouth shape for the current [DigitalHumanViseme].
///
/// Used by the painted fallback avatar when the Rive .riv asset has not been
/// delivered yet. Shapes are keyed off the `viseme_id` contract shared with
/// the Rive state machine so the two visuals stay consistent.
class VisemeMouthPainter extends CustomPainter {
  final int visemeId;
  final Color mouthColor;
  final Color tongueColor;
  final Color toothColor;

  const VisemeMouthPainter({
    required this.visemeId,
    this.mouthColor = const Color(0xFF7F1D1D),
    this.tongueColor = const Color(0xFFE11D48),
    this.toothColor = const Color(0xFFFEF3C7),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final viseme = DigitalHumanViseme.fromId(visemeId);
    final center = Offset(size.width / 2, size.height / 2);
    final width = size.width * 0.72;
    final height = size.height * 0.7;

    final lips = Paint()
      ..color = mouthColor
      ..style = PaintingStyle.fill;

    final tongue = Paint()
      ..color = tongueColor
      ..style = PaintingStyle.fill;

    final teeth = Paint()
      ..color = toothColor
      ..style = PaintingStyle.fill;

    switch (viseme) {
      case DigitalHumanViseme.sil:
        _closedLips(canvas, center, width, lips);
      case DigitalHumanViseme.a:
        _openEllipse(canvas, center, width, height * 1.2, lips, teeth);
      case DigitalHumanViseme.e:
        _openEllipse(canvas, center, width, height * 0.7, lips, teeth);
      case DigitalHumanViseme.o:
        _circle(canvas, center, width * 0.4, lips, teeth);
      case DigitalHumanViseme.u:
        _pucker(canvas, center, width * 0.45, height * 0.3, lips);
      case DigitalHumanViseme.mbp:
        _pressedLips(canvas, center, width, lips);
      case DigitalHumanViseme.fv:
        _fricative(canvas, center, width, height * 0.55, lips, teeth);
      case DigitalHumanViseme.lndt:
        _tongueOut(canvas, center, width * 0.6, height * 0.8, lips, tongue);
    }
  }

  void _closedLips(Canvas canvas, Offset center, double width, Paint lips) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: width, height: width * 0.12),
        const Radius.circular(12),
      ),
      lips,
    );
  }

  void _pressedLips(Canvas canvas, Offset center, double width, Paint lips) {
    final w = width * 0.85;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: w, height: w * 0.14),
        const Radius.circular(14),
      ),
      lips,
    );
    final seam = Paint()
      ..color = Colors.black.withValues(alpha: 0.35)
      ..strokeWidth = w * 0.03;
    canvas.drawLine(
      center.translate(-w * 0.35, 0),
      center.translate(w * 0.35, 0),
      seam,
    );
  }

  void _openEllipse(
    Canvas canvas,
    Offset center,
    double width,
    double height,
    Paint lips,
    Paint teeth,
  ) {
    final rect = Rect.fromCenter(
      center: center,
      width: width,
      height: height.clamp(4, width * 1.4),
    );
    canvas.drawOval(rect, lips);
    final inner = rect.deflate(rect.width * 0.12);
    canvas.drawOval(inner, Paint()..color = Colors.black87);
    // top teeth strip
    final teethRect = Rect.fromLTWH(
      inner.left + inner.width * 0.1,
      inner.top + inner.height * 0.06,
      inner.width * 0.8,
      inner.height * 0.28,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(teethRect, const Radius.circular(8)),
      teeth,
    );
  }

  void _circle(Canvas canvas, Offset center, double radius, Paint lips, Paint teeth) {
    canvas.drawCircle(center, radius, lips);
    canvas.drawCircle(
      center,
      radius * 0.78,
      Paint()..color = Colors.black87,
    );
    final teethRect = Rect.fromCenter(
      center: center.translate(0, -radius * 0.2),
      width: radius * 1.3,
      height: radius * 0.45,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(teethRect, const Radius.circular(8)),
      teeth,
    );
  }

  void _pucker(Canvas canvas, Offset center, double width, double height, Paint lips) {
    canvas.drawOval(
      Rect.fromCenter(center: center, width: width, height: height),
      lips,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: width * 0.55,
        height: height * 0.5,
      ),
      Paint()..color = Colors.black87,
    );
  }

  void _fricative(
    Canvas canvas,
    Offset center,
    double width,
    double height,
    Paint lips,
    Paint teeth,
  ) {
    // lower lip raised toward upper teeth (F/V)
    final lowerLip = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center.translate(0, height * 0.14),
        width: width,
        height: height * 0.62,
      ),
      const Radius.circular(24),
    );
    canvas.drawRRect(lowerLip, lips);
    final teethRect = Rect.fromCenter(
      center: center.translate(0, -height * 0.28),
      width: width * 0.82,
      height: height * 0.3,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(teethRect, const Radius.circular(6)),
      teeth,
    );
  }

  void _tongueOut(
    Canvas canvas,
    Offset center,
    double width,
    double height,
    Paint lips,
    Paint tongue,
  ) {
    final rect = Rect.fromCenter(
      center: center,
      width: width,
      height: height * 0.9,
    );
    canvas.drawOval(rect, lips);
    canvas.drawOval(rect.deflate(width * 0.1), Paint()..color = Colors.black87);
    final tongueRect = Rect.fromCenter(
      center: center.translate(0, height * 0.18),
      width: width * 0.52,
      height: height * 0.5,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(tongueRect, const Radius.circular(18)),
      tongue,
    );
  }

  @override
  bool shouldRepaint(covariant VisemeMouthPainter oldDelegate) {
    return oldDelegate.visemeId != visemeId ||
        oldDelegate.mouthColor != mouthColor;
  }
}

/// Convenience: openness (0.0–1.0) per viseme, used to drive a subtle scale
/// animation on the mouth surface.
double visemeOpenness(int visemeId) {
  switch (DigitalHumanViseme.fromId(visemeId)) {
    case DigitalHumanViseme.sil:
    case DigitalHumanViseme.mbp:
      return 0.05;
    case DigitalHumanViseme.u:
    case DigitalHumanViseme.fv:
      return 0.2;
    case DigitalHumanViseme.e:
      return 0.45;
    case DigitalHumanViseme.o:
    case DigitalHumanViseme.lndt:
      return 0.7;
    case DigitalHumanViseme.a:
      return 1.0;
  }
}

/// Deterministic per-viseme mouth anchor jitter used by the fallback renderer.
Offset visemeAnchor(int visemeId, Size size, math.Random random) {
  switch (DigitalHumanViseme.fromId(visemeId)) {
    case DigitalHumanViseme.sil:
    case DigitalHumanViseme.mbp:
      return Offset.zero;
    case DigitalHumanViseme.fv:
      return Offset(size.width * 0.02, size.height * 0.04);
    case DigitalHumanViseme.lndt:
      return Offset(size.width * 0.02, -size.height * 0.02);
    default:
      return Offset(
        (random.nextDouble() - 0.5) * size.width * 0.04,
        (random.nextDouble() - 0.5) * size.height * 0.04,
      );
  }
}
