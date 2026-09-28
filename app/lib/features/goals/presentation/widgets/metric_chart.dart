import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../goals_strings.dart';

class MetricChartPoint {
  const MetricChartPoint({required this.at, required this.value});

  final DateTime at;
  final num value;
}

/// Dependency-free line chart for measurement trends (CustomPaint).
class MetricChart extends StatelessWidget {
  const MetricChart({
    super.key,
    required this.points,
    this.height = 160,
  });

  final List<MetricChartPoint> points;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) {
      return SizedBox(
        height: height,
        child: const Center(child: Text(GoalsStrings.chartsEmpty)),
      );
    }
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _MetricChartPainter(
          points: [...points]..sort((a, b) => a.at.compareTo(b.at)),
          lineColor: scheme.primary,
          gridColor: scheme.outlineVariant,
        ),
      ),
    );
  }
}

class _MetricChartPainter extends CustomPainter {
  _MetricChartPainter({
    required this.points,
    required this.lineColor,
    required this.gridColor,
  });

  final List<MetricChartPoint> points;
  final Color lineColor;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    final minV = points.map((p) => p.value.toDouble()).reduce(math.min);
    final maxV = points.map((p) => p.value.toDouble()).reduce(math.max);
    final span = (maxV - minV).abs() < 1e-9 ? 1.0 : (maxV - minV);
    final minT = points.first.at.millisecondsSinceEpoch.toDouble();
    final maxT = points.last.at.millisecondsSinceEpoch.toDouble();
    final tSpan = (maxT - minT).abs() < 1e-9 ? 1.0 : (maxT - minT);

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final p = points[i];
      final x = ((p.at.millisecondsSinceEpoch - minT) / tSpan) * size.width;
      final y =
          size.height -
          ((p.value.toDouble() - minV) / span) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = lineColor;
    for (final p in points) {
      final x = ((p.at.millisecondsSinceEpoch - minT) / tSpan) * size.width;
      final y =
          size.height -
          ((p.value.toDouble() - minV) / span) * size.height;
      canvas.drawCircle(Offset(x, y), 3.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MetricChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.gridColor != gridColor;
  }
}
