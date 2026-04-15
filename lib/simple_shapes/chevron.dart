import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'root_shape.dart';

/// An open V-shape (chevron), pointing upward by default.
/// Use [rotation] to flip it or point it sideways.
class Chevron extends RootShape {
  /// Opening angle of the V in degrees, measured between the two arms.
  /// 90° (the default) gives a right-angle V. Smaller values produce a
  /// narrower, more pointed V; larger values produce a shallower, wider V.
  final double angle;

  /// Thickness of each arm of the V in logical pixels. Defaults to 20.
  final double thickness;

  const Chevron({
    super.key,
    super.borderColor,
    super.borderWidth,
    super.insideColor,
    super.child,
    super.childSizeFactor,
    super.size,
    super.rotation,
    this.angle = 90.0,
    this.thickness = 20.0,
    super.shadowColor,
    super.shadowOffset,
    super.shadowBlurRadius,
    super.radius,
    super.width,
    super.height,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        angle,
        thickness,
      ];

  @override
  Path getPath(Size size) {
    final double w = size.width;
    final double h = size.height;

    // Angle of one arm relative to the vertical centerline
    final double halfAngleRad = (angle / 2) * math.pi / 180;
    
    // Ratio of width to height for the outer V
    final double ratio = math.tan(halfAngleRad);

    // Calculate outer V dimensions to fit in size
    double outerW, outerH;
    if (ratio > (w / 2) / h) {
      // Limited by width
      outerW = w;
      outerH = (w / 2) / ratio;
    } else {
      // Limited by height
      outerH = h;
      outerW = 2 * h * ratio;
    }

    final double centerX = w / 2;
    final double topY = (h - outerH) / 2;
    final double bottomY = topY + outerH;

    // Thickness adjustments
    // Vertical offset for thickness T: T / sin(halfAngleRad)
    // Horizontal offset for thickness T: T / cos(halfAngleRad)
    final double tVert = thickness / math.sin(halfAngleRad);
    final double tHoriz = thickness / math.cos(halfAngleRad);

    // Ensure thickness doesn't exceed the shape
    final double effectiveTVert = math.min(tVert, outerH);
    final double effectiveTHoriz = math.min(tHoriz, outerW / 2);

    final path = Path();
    path.moveTo(centerX, topY); // Top peak
    path.lineTo(centerX + outerW / 2, bottomY); // Bottom right outer
    path.lineTo(centerX + outerW / 2 - effectiveTHoriz, bottomY); // Bottom right inner
    path.lineTo(centerX, topY + effectiveTVert); // Inner peak
    path.lineTo(centerX - outerW / 2 + effectiveTHoriz, bottomY); // Bottom left inner
    path.lineTo(centerX - outerW / 2, bottomY); // Bottom left outer
    path.close();

    return path;
  }
}
