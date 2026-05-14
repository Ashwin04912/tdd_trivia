import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedBackground extends StatelessWidget {
  const AnimatedBackground({super.key, required this.animation});
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) => CustomPaint(
        painter: _BlobPainter(animation.value),
        size: MediaQuery.of(context).size,
      ),
    );
  }
}

class _BlobPainter extends CustomPainter {
  _BlobPainter(this.t);
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Blob 1 — top-left, indigo/purple
    paint.shader = RadialGradient(
      colors: [
        const Color(0xFF6C63FF).withValues(alpha: 0.35),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(
      center: Offset(
        size.width * 0.15 + math.sin(t * math.pi) * 20,
        size.height * 0.20 + math.cos(t * math.pi) * 15,
      ),
      radius: size.width * 0.55,
    ));
    canvas.drawCircle(
      Offset(
        size.width * 0.15 + math.sin(t * math.pi) * 20,
        size.height * 0.20 + math.cos(t * math.pi) * 15,
      ),
      size.width * 0.55,
      paint,
    );

    // Blob 2 — bottom-right, cyan
    paint.shader = RadialGradient(
      colors: [
        const Color(0xFF00D2FF).withValues(alpha: 0.25),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(
      center: Offset(
        size.width * 0.85 + math.cos(t * math.pi) * 15,
        size.height * 0.72 + math.sin(t * math.pi) * 20,
      ),
      radius: size.width * 0.5,
    ));
    canvas.drawCircle(
      Offset(
        size.width * 0.85 + math.cos(t * math.pi) * 15,
        size.height * 0.72 + math.sin(t * math.pi) * 20,
      ),
      size.width * 0.5,
      paint,
    );
  }

  @override
  bool shouldRepaint(_BlobPainter old) => old.t != t;
}
