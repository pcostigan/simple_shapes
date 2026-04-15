import 'package:flutter/material.dart';
import 'root_shape.dart';

/// A plus or cross shape formed by a vertical shaft and a horizontal crossbar
/// that share the same [thickness]. Use [crossAt] to position the crossbar
/// anywhere along the shaft — 0.5 gives a symmetrical plus sign, 0.66 gives
/// Christian-cross proportions.
class Cross extends RootShape {
  /// Thickness of both the vertical shaft and the horizontal crossbar, in
  /// logical pixels. Defaults to 20.
  final double thickness;

  /// Vertical position of the crossbar as a fraction of the shaft height
  /// (0.0–1.0). 0.0 places it at the bottom; 1.0 at the top. Defaults to 0.66.
  final double crossAt;

  const Cross({
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
    double width = 60.0,   // Length of the crossbar
    double height = 100.0, // Length of the shaft
    this.thickness = 20.0,
    this.crossAt = 0.66,   // Crossbar ~1/3 from top by default (Christian cross proportion)
  })  : assert(thickness > 0, 'thickness must be positive'),
        assert(crossAt >= 0.0 && crossAt <= 1.0, 'crossAt must be between 0.0 and 1.0'),
        super(width: width, height: height);

  @override
  List<Object?> get props => [
        ...super.props,
        thickness,
        crossAt,
      ];

  @override
  Path getPath(Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double halfT = thickness / 2;

    // crossbarCenterY: 0.0 → bottom (y=h), 1.0 → top (y=0)
    final double crossbarCenterY = h * (1.0 - crossAt);

    final double crossbarTop    = crossbarCenterY - halfT;
    final double crossbarBottom = crossbarCenterY + halfT;

    // List the 12 vertices of the cross polygon:
    final List<Offset> vertices = [
      Offset(cx - halfT, 0),                         //  1: top-left of shaft
      Offset(cx + halfT, 0),                         //  2: top-right of shaft
      Offset(cx + halfT, crossbarTop),               //  3: right shaft meets crossbar top
      Offset(w,          crossbarTop),               //  4: top-right of crossbar
      Offset(w,          crossbarBottom),            //  5: bottom-right of crossbar
      Offset(cx + halfT, crossbarBottom),            //  6: right shaft meets crossbar bottom
      Offset(cx + halfT, h),                         //  7: bottom-right of shaft
      Offset(cx - halfT, h),                         //  8: bottom-left of shaft
      Offset(cx - halfT, crossbarBottom),            //  9: left shaft meets crossbar bottom
      Offset(0,          crossbarBottom),            // 10: bottom-left of crossbar
      Offset(0,          crossbarTop),               // 11: top-left of crossbar
      Offset(cx - halfT, crossbarTop),               // 12: left shaft meets crossbar top
    ];

    return buildRoundedPath(vertices, size);
  }
}
