import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'root_shape.dart';

/// A rhombus (equilateral parallelogram) centered in the bounding box.
/// All four sides are equal length; the top/bottom vertices share one
/// interior angle and the left/right vertices share the supplementary angle.
class Rhombus extends RootShape {
  /// Interior angle at the top and bottom vertices, in degrees.
  /// - 90° produces a square rotated 45°.
  /// - Smaller values give a taller, more elongated shape.
  /// - Larger values give a flatter, wider shape.
  /// Valid range: 0–180 (exclusive). Defaults to 60.
  final double angle;

  const Rhombus({
    super.key,
    super.borderColor,
    super.borderWidth,
    super.insideColor,
    super.child,
    super.childSizeFactor,
    super.size,
    super.rotation,
    this.angle = 60.0,
    super.shadowColor,
    super.shadowOffset,
    super.shadowBlurRadius,
    super.radius,
  }) : assert(angle > 0 && angle < 180, 'Angle must be between 0 and 180 degrees');

  @override
  List<Object?> get props => [
        ...super.props,
        angle,
      ];

  @override
  Path getPath(Size size) {
    final double w = size.width;
    final double h = size.height;

    // A rhombus with internal angle 'angle' at the top and bottom vertices.
    final angleRadians = angle * math.pi / 180;
    final double targetRatio = math.tan(angleRadians / 2);

    double rhW, rhH;
    if (targetRatio > w / h) {
      // Rhombus is limited by width
      rhW = w;
      rhH = w / targetRatio;
    } else {
      // Rhombus is limited by height
      rhH = h;
      rhW = h * targetRatio;
    }

    final double centerX = w / 2;
    final double centerY = h / 2;

    final List<Offset> vertices = [
      Offset(centerX, centerY - rhH / 2), // Top
      Offset(centerX + rhW / 2, centerY), // Right
      Offset(centerX, centerY + rhH / 2), // Bottom
      Offset(centerX - rhW / 2, centerY), // Left
    ];

    return buildRoundedPath(vertices, size);
  }
}
