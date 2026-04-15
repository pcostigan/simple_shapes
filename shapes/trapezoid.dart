import 'package:flutter/material.dart';
import 'root_shape.dart';

/// A trapezoid with a full-width base at the bottom and a shorter top edge
/// centered above it. When [topWidth] exceeds [width] the slant reverses,
/// producing an inverted trapezoid.
class Trapezoid extends RootShape {
  /// Width of the top edge in logical pixels. The bottom edge spans the full
  /// [width]. Defaults to 80.
  final double topWidth;

  const Trapezoid({
    super.key,
    super.borderColor,
    super.borderWidth,
    super.insideColor,
    super.child,
    // super.size,
    super.rotation,
    super.shadowColor,
    super.shadowOffset,
    super.shadowBlurRadius,
    super.radius,
    double width = 100.0, // Width of the base
    double height = 80.0, // Height
    this.topWidth = 80.0,
  })  : assert(topWidth > 0, 'topWidth must be positive'),
        super(width: width, height: height);

  @override
  List<Object?> get props => [...super.props, topWidth];

  @override
  Path getPath(Size size) {
    final double w = size.width;
    final double h = size.height;

    // Calculate the inset from each side to center the top edge
    final double horizontalInset = (w - topWidth) / 2;

    final List<Offset> vertices = [
      Offset(0, h), // bottom-left
      Offset(w, h), // bottom-right
      Offset(w - horizontalInset, 0), // top-right
      Offset(horizontalInset, 0), // top-left
    ];

    return buildRoundedPath(vertices, size);
  }
}
