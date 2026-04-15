import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'root_shape.dart';

/// A rectangle or parallelogram. At the default [angle] of 90° the shape is
/// a standard rectangle. Any other angle shears it into a parallelogram by
/// slanting the top and bottom edges.
class Square extends RootShape {
  /// Corner angle in degrees, controlling how much the rectangle is sheared.
  /// - 90° (the default) gives a standard rectangle.
  /// - Values above 90° slant the top edge to the right.
  /// - Values below 90° slant the top edge to the left.
  /// Valid range: 1–179. Defaults to 90.
  final double angle;

  const Square({
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
    this.angle = 90.0,
  }) : assert(angle >= 1.0 && angle <= 179.0, 'Angle must be between 1 and 179 degrees');

  @override
  List<Object?> get props => [
        ...super.props,
        angle,
      ];

  @override
  Path getPath(Size size) {
    final w = size.width;
    final h = size.height;

    final List<Offset> vertices = [];
    if (angle == 90.0) {
      vertices.addAll([
        const Offset(0, 0),
        Offset(w, 0),
        Offset(w, h),
        Offset(0, h),
      ]);
    } else {
      final angleRadians = angle * math.pi / 180;
      final s = h * (1.0 / math.tan(angleRadians)).abs();
      if (angle > 90) {
        vertices.addAll([Offset(s, 0), Offset(w, 0), Offset(w - s, h), Offset(0, h)]);
      } else {
        vertices.addAll([Offset(0, 0), Offset(w - s, 0), Offset(w, h), Offset(s, h)]);
      }
    }

    return buildRoundedPath(vertices, size);
  }
}
