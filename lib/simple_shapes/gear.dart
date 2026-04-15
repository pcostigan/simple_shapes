import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'root_shape.dart';
/// A gear (cog) with evenly-spaced trapezoidal teeth around a circular body
/// and an optional central hole.
class Gear extends RootShape {
  /// Number of teeth. Must be at least 3. Defaults to 8.
  final int teeth;

  /// How far each tooth protrudes beyond the gear body, in logical pixels.
  /// Defaults to 10.
  final double toothDepth;

  /// Width of each tooth's base as a fraction of the arc it occupies (0.0–1.0).
  /// 1.0 means adjacent teeth are flush with no gap; 0.5 means each base
  /// occupies half the available arc. Defaults to 0.6.
  final double toothWidthRatio;

  /// Width of each tooth's tip relative to its base (0.0–1.0). 1.0 gives a
  /// rectangular tooth; lower values taper the tip narrower than the base.
  /// Defaults to 0.8.
  final double toothTipWidthRatio;

  /// Central hole size as a fraction of the inner gear radius (0.0–1.0).
  /// Ignored when [holeDiameter] is set. When neither is provided, defaults
  /// to 0.4.
  final double? holeRadiusRatio;

  /// Explicit diameter of the central hole in logical pixels. Takes
  /// precedence over [holeRadiusRatio] when set. Leave null for no hole.
  final double? holeDiameter;

  const Gear({
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
    this.teeth = 8,
    this.toothDepth = 10.0,
    this.toothWidthRatio = 0.6,
    this.toothTipWidthRatio = 0.8,
    this.holeRadiusRatio,
    this.holeDiameter,
  }) : assert(teeth >= 3, 'Gears must have at least 3 teeth'),
       assert(toothWidthRatio > 0 && toothWidthRatio < 1, 'toothWidthRatio must be between 0 and 1');

  @override
  List<Object?> get props => [
        ...super.props,
        teeth,
        toothDepth,
        toothWidthRatio,
        toothTipWidthRatio,
        holeRadiusRatio,
        holeDiameter,
      ];

  @override
  Path getPath(Size size) {
    final double w = size.width;
    final double h = size.height;
    final double outerRadius = math.min(w, h) / 2;
    final double innerRadius = outerRadius - toothDepth;
    final Offset center = Offset(w / 2, h / 2);

    final List<Offset> vertices = [];
    final double angleStep = 2 * math.pi / teeth;
    
    // Each tooth is a trapezoid. 
    // We adjust the tip angle so that when toothTipWidthRatio is 1.0, 
    // the linear width of the tip matches the linear width of the base.
    final double baseHalfAngle = (angleStep * toothWidthRatio) / 2;
    // Linear width at base = 2 * innerRadius * sin(baseHalfAngle)
    // We want Linear width at tip = toothTipWidthRatio * baseLinearWidth
    final double baseLinearHalfWidth = innerRadius * math.sin(baseHalfAngle);
    final double targetTipLinearHalfWidth = baseLinearHalfWidth * toothTipWidthRatio;
    
    // tipHalfAngle = asin(targetTipLinearHalfWidth / outerRadius)
    // We clamp the value to avoid asin(>1) errors
    final double tipHalfAngle = math.asin((targetTipLinearHalfWidth / outerRadius).clamp(-1.0, 1.0));

    for (int i = 0; i < teeth; i++) {
      final double centerAngle = i * angleStep;

      // Point 1: Base left
      vertices.add(Offset(
        center.dx + innerRadius * math.cos(centerAngle - baseHalfAngle),
        center.dy + innerRadius * math.sin(centerAngle - baseHalfAngle),
      ));

      // Point 2: Tip left
      vertices.add(Offset(
        center.dx + outerRadius * math.cos(centerAngle - tipHalfAngle),
        center.dy + outerRadius * math.sin(centerAngle - tipHalfAngle),
      ));

      // Point 3: Tip right
      vertices.add(Offset(
        center.dx + outerRadius * math.cos(centerAngle + tipHalfAngle),
        center.dy + outerRadius * math.sin(centerAngle + tipHalfAngle),
      ));

      // Point 4: Base right
      vertices.add(Offset(
        center.dx + innerRadius * math.cos(centerAngle + baseHalfAngle),
        center.dy + innerRadius * math.sin(centerAngle + baseHalfAngle),
      ));
    }

    final Path path = buildRoundedPath(vertices, size);

    // Add the central hole
    double hRadius = 0.0;
    if (holeDiameter != null) {
      hRadius = holeDiameter! / 2;
    } else {
      hRadius = innerRadius * (holeRadiusRatio ?? 0.4);
    }

    if (hRadius > 0) {
      path.addOval(Rect.fromCircle(center: center, radius: hRadius));
      path.fillType = PathFillType.evenOdd;
    }

    return path;
  }
}
