import 'package:flutter/material.dart';
import 'circle.dart';

/// A ring (annulus) — a circle with a concentric circular hole.
///
/// [insideColor] fills the ring band only, not the hole. Any [child] is
/// rendered inside the hole area and clipped to its boundary.
class Ring extends Circle {
  /// Diameter of the inner hole as a fraction of the outer diameter (0.0–1.0).
  /// 0.0 produces a filled disc; 1.0 would make the ring invisible.
  /// Defaults to 0.5.
  final double innerRadiusRatio;

  const Ring({
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
    this.innerRadiusRatio = 0.5,
  }) : assert(innerRadiusRatio >= 0.0 && innerRadiusRatio <= 1.0, 'innerRadiusRatio must be between 0.0 and 1.0');

  @override
  List<Object?> get props => [
        ...super.props,
        innerRadiusRatio,
      ];

  @override
  Path getPath(Size size) {
    final path = Path();
    path.fillType = PathFillType.evenOdd;
    
    // Outer circle (oval)
    path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    
    // Inner circle (oval)
    final double innerW = size.width * innerRadiusRatio;
    final double innerH = size.height * innerRadiusRatio;
    final double left = (size.width - innerW) / 2;
    final double top = (size.height - innerH) / 2;
    
    path.addOval(Rect.fromLTWH(left, top, innerW, innerH));
    
    return path;
  }
}
