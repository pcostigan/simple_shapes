import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'root_shape.dart';

/// A crescent drawn between [startAngle] and [stopAngle]. The outer edge is
/// a circular arc; the inner edge is a smaller arc that closes the shape,
/// producing a uniform [thickness] along the arc.
///
/// Angles follow standard math convention: 0° is 3 o'clock, increasing
/// clockwise. The default 90°–270° sweep produces a left-facing crescent.
class Crescent extends RootShape {
  /// Start angle of the outer arc in degrees. Defaults to 90 (6 o'clock).
  final double startAngle;

  /// End angle of the outer arc in degrees. Defaults to 270 (12 o'clock).
  final double stopAngle;

  /// Radial thickness of the crescent in logical pixels — the distance from
  /// the outer arc to the inner arc. Defaults to 20.
  final double thickness;

  const Crescent({
    super.key,
    super.borderColor,
    super.borderWidth,
    super.insideColor,
    super.child,
    super.childSizeFactor,
    super.size,
    super.width,
    super.height,
    super.rotation,
    super.shadowColor,
    super.shadowOffset,
    super.shadowBlurRadius,
    super.radius,
    this.startAngle = 90.0,
    this.stopAngle = 270.0,
    this.thickness = 20.0,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        startAngle,
        stopAngle,
        thickness,
      ];

  @override
  Path getPath(Size size) {
    final double w = size.width;
    final double h = size.height;
    final double r = math.min(w, h) / 2;
    final Offset center = Offset(w / 2, h / 2);

    final double startRad = startAngle * math.pi / 180;
    final double stopRad = stopAngle * math.pi / 180;
    final double sweepRad = stopRad - startRad;

    final Path path = Path();

    // Outer Arc Point A (Start)
    final double ax = center.dx + r * math.cos(startRad);
    final double ay = center.dy + r * math.sin(startRad);

    // Outer Arc Point B (End)
    final double bx = center.dx + r * math.cos(stopRad);
    final double by = center.dy + r * math.sin(stopRad);

    path.moveTo(ax, ay);

    // Draw outer arc from A to B
    path.arcTo(
      Rect.fromCircle(center: center, radius: r),
      startRad,
      sweepRad,
      false,
    );

    // Calculate midpoint of outer arc
    final double midRad = (startRad + stopRad) / 2;
    // Calculate point M on the inner boundary at the midpoint angle
    final double mx = center.dx + (r - thickness) * math.cos(midRad);
    final double my = center.dy + (r - thickness) * math.sin(midRad);

    // To draw the inner circular arc from B back to A passing through M:
    // We need the radius of the circle passing through A, B, and M.
    // Chord length L between A and B
    final double chordL = math.sqrt(math.pow(bx - ax, 2) + math.pow(by - ay, 2));

    // Midpoint of chord AB
    final Offset chordMid = Offset((ax + bx) / 2, (ay + by) / 2);
    // Distance from midpoint of chord AB to point M (sagitta of the inner arc)
    final double sagitta = math.sqrt(math.pow(mx - chordMid.dx, 2) + math.pow(my - chordMid.dy, 2));

    if (sagitta > 0.1 && chordL > 0.1) {
      // Radius of circle through A, B, M
      final double innerRadius = (sagitta / 2) + (math.pow(chordL, 2) / (8 * sagitta));

      // Use arcToPoint to draw back to A
      // We use clockwise: sweepRad < 0 because we are going from B back to A
      path.arcToPoint(
        Offset(ax, ay),
        radius: Radius.circular(innerRadius),
        clockwise: sweepRad < 0,
        largeArc: false,
      );
    } else {
      path.lineTo(ax, ay);
    }

    path.close();
    return path;
  }
}
