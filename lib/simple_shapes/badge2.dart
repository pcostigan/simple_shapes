import 'package:flutter/material.dart';
import 'root_shape.dart';

/// A badge shape with a concave dip at the top center, giving it a
/// collar or ribbon-like silhouette.
class Badge2 extends RootShape {
  const Badge2({
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
  });

  @override
  Path getPath(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w * 0.5, h * 0.2); // Top center (dipped)
    // Top right curve up to shoulder
    path.quadraticBezierTo(w * 0.8, h * 0.15, w * 0.9, h * 0.05);
    // Down the right side
    path.lineTo(w * 0.9, h * 0.5);
    // Curve down to bottom point
    path.quadraticBezierTo(w * 0.9, h * 0.85, w * 0.5, h);
    // Curve up to left side
    path.quadraticBezierTo(w * 0.1, h * 0.85, w * 0.1, h * 0.5);
    // Up the left side
    path.lineTo(w * 0.1, h * 0.05);
    // Top left curve back to dipped center
    path.quadraticBezierTo(w * 0.2, h * 0.15, w * 0.5, h * 0.2);

    path.close();
    return path;
  }
}
