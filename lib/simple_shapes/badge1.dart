import 'package:flutter/material.dart';
import 'root_shape.dart';

/// A heraldic shield shape — a pointed top center, straight sides that curve
/// inward slightly, and a rounded bottom point.
class Badge1 extends RootShape {
  const Badge1({
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
    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w * 0.5, 0); // Top peak
    // Top right curve down to shoulder
    path.quadraticBezierTo(w * 0.8, h * 0.05, w * 0.9, h * 0.15);
    // Down the right side
    path.lineTo(w * 0.9, h * 0.5);
    // Curve down to bottom point
    path.quadraticBezierTo(w * 0.9, h * 0.85, w * 0.5, h);
    // Curve up to left side
    path.quadraticBezierTo(w * 0.1, h * 0.85, w * 0.1, h * 0.5);
    // Up the left side
    path.lineTo(w * 0.1, h * 0.15);
    // Top left curve back to peak
    path.quadraticBezierTo(w * 0.2, h * 0.05, w * 0.5, 0);

    path.close();
    return path;
  }
}
