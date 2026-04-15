import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'root_shape.dart';

/// A regular six-sided polygon, vertex-up by default.
/// Use [rotation] to reorient it and [radius] to round the corners.
class Hexagon extends RootShape {
  const Hexagon({
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
  });

  @override
  Path getPath(Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    final List<Offset> vertices = [];
    for (int i = 0; i < 6; i++) {
      final double angle = (i * 60 - 90) * math.pi / 180;
      final double x = center.dx + radius * math.cos(angle);
      final double y = center.dy + radius * math.sin(angle);
      vertices.add(Offset(x, y));
    }
    
    return buildRoundedPath(vertices, size);
  }
}
