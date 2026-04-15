import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'root_shape.dart';

/// A teardrop shape with a pointed tip at the top and a circular base at the
/// bottom. Straight tangent lines connect the tip to the circle's edge.
///
/// When [height] is less than or equal to half [width] the shape degrades
/// gracefully to an ellipse. Use [radius] to soften the pointed tip.
class Teardrop extends RootShape {
  const Teardrop({
    super.key,
    super.borderColor,
    super.borderWidth,
    super.insideColor,
    super.child,
    super.childSizeFactor,
    super.size,
    super.rotation,
    super.shadowColor,
    super.shadowOffset,
    super.shadowBlurRadius,
    super.radius,
    double width = 80.0,
    double height = 120.0,
  }) : super(width: width, height: height);

  @override
  Path getPath(Size size) {
    final double w = size.width;
    final double h = size.height;
    
    // The radius of the bottom circular part
    final double r = w / 2;
    
    // Center of the circular bottom
    final double cx = w / 2;
    final double cy = h - r;

    // Handle case where height is too small for a teardrop
    if (h <= r) {
      final Path path = Path();
      path.addOval(Rect.fromLTWH(0, 0, w, h));
      return path;
    }

    final double d = h - r; // distance from tip (w/2, 0) to center (w/2, h-r)
    
    // Calculate tangency
    final double cosAlpha = (r / d).clamp(0.0, 1.0);
    final double alpha = math.acos(cosAlpha);

    final List<Offset> vertices = [];
    
    // 1. Tip point
    vertices.add(Offset(w / 2, 0));

    // 2. Points along the bottom arc
    // Arc starts from the tangent point on the right and goes around the bottom to the left tangent point.
    final double angleTip = -math.pi / 2;
    final double startAngle = angleTip + alpha;
    final double sweepAngle = 2 * (math.pi - alpha);
    
    const int segments = 30; // Sufficient segments to make the arc look smooth
    for (int i = 0; i <= segments; i++) {
      final double theta = startAngle + (sweepAngle * i / segments);
      vertices.add(Offset(
        cx + r * math.cos(theta),
        cy + r * math.sin(theta),
      ));
    }

    // Using buildRoundedPath allows us to use the 'radius' parameter for the sharp tip
    return buildRoundedPath(vertices, size);
  }
}
