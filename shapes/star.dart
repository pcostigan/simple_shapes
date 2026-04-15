import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'root_shape.dart';

/// A star polygon with evenly-spaced outer points connected through an inner
/// ring, producing the classic star silhouette.
class Star extends RootShape {
  /// Number of outer points. Must be between 4 and 100. Defaults to 5.
  final int points;

  /// Radius of the inner ring as a fraction of the outer radius (0.0–1.0).
  /// Smaller values produce longer, sharper points; values approaching 1.0
  /// produce shallow points that resemble a polygon. Defaults to 0.4.
  final double innerRadiusRatio;

  const Star({
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
    this.points = 5,
    this.innerRadiusRatio = 0.4,
  }) : assert(points >= 4 && points <= 100, 'Points must be between 4 and 7');

  @override
  List<Object?> get props => [
        ...super.props,
        points,
        innerRadiusRatio,
      ];

  @override
  Path getPath(Size size) {
    final double outerRadius = size.width / 2;
    final double innerRadius = outerRadius * innerRadiusRatio;
    final Offset center = Offset(size.width / 2, size.height / 2);

    final List<Offset> vertices = [];
    final double step = math.pi / points;

    for (int i = 0; i < 2 * points; i++) {
      final double r = (i % 2 == 0) ? outerRadius : innerRadius;
      final double angle = i * step - math.pi / 2;
      vertices.add(Offset(
        center.dx + r * math.cos(angle),
        center.dy + r * math.sin(angle),
      ));
    }

    return buildRoundedPath(vertices, size);
  }
}
