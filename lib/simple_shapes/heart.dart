import 'package:flutter/material.dart';
import 'root_shape.dart';

/// A heart shape, oriented with the two lobes at the top and the point at
/// the bottom.
class Heart extends RootShape {
  const Heart({
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
    final double w = size.width;
    final double h = size.height;

    path.moveTo(w * 0.5, h * 0.25);
    // Top left curve
    path.cubicTo(w * 0.5, h * 0.22, w * 0.45, h * 0.15, w * 0.25, h * 0.15);
    // Left side
    path.cubicTo(0, h * 0.15, 0, h * 0.45, 0, h * 0.45);
    // Bottom left curve to bottom point
    path.cubicTo(0, h * 0.65, w * 0.2, h * 0.85, w * 0.5, h);
    // Bottom right curve to right side
    path.cubicTo(w * 0.8, h * 0.85, w, h * 0.65, w, h * 0.45);
    // Right side
    path.cubicTo(w, h * 0.45, w, h * 0.15, w * 0.75, h * 0.15);
    // Top right curve
    path.cubicTo(w * 0.6, h * 0.15, w * 0.5, h * 0.22, w * 0.5, h * 0.25);

    path.close();
    return path;
  }
}
