import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'root_shape.dart';

/// A pie-slice (wedge) shape defined by two angles. When [isFilled] is true
/// the wedge is a solid filled sector. When false, only the outer arc stroke
/// is drawn — useful as a progress arc or gauge indicator.
///
/// Angles follow standard math convention: 0° is 3 o'clock, increasing
/// clockwise.
class Wedge extends RootShape {
  /// Start angle of the wedge in degrees. Defaults to 0 (3 o'clock).
  final double startAngle;

  /// End angle of the wedge in degrees. The wedge sweeps clockwise from
  /// [startAngle] to [stopAngle]. Defaults to 90 (6 o'clock).
  final double stopAngle;

  /// Whether to fill the wedge as a solid sector. When false, only the outer
  /// arc stroke is drawn and [insideColor] has no effect. Defaults to true.
  final bool isFilled;

  const Wedge({
    super.key,
    super.borderColor,
    super.borderWidth,
    Color? insideColor,
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
    this.startAngle = 0.0,
    this.stopAngle = 90.0,
    this.isFilled = true,
  }) : super(insideColor: isFilled ? insideColor : Colors.transparent);

  @override
  List<Object?> get props => [
        ...super.props,
        startAngle,
        stopAngle,
        isFilled,
      ];

  @override
  Path getPath(Size size) {
    final double w = size.width;
    final double h = size.height;
    final double r = math.min(w, h) / 2;
    final Offset center = Offset(w / 2, h / 2);

    final double startRad = startAngle * math.pi / 180;
    final double stopRad = stopAngle * math.pi / 180;
    final double sweepRad = stopRad - startRad;

    final Path path = Path();
    if (isFilled) {
      path.moveTo(center.dx, center.dy);
      path.arcTo(
        Rect.fromCircle(center: center, radius: r),
        startRad,
        sweepRad,
        false,
      );
      path.close();
    } else {
      path.arcTo(
        Rect.fromCircle(center: center, radius: r),
        startRad,
        sweepRad,
        true,
      );
    }

    return path;
  }
}
