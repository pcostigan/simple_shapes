import 'package:flutter/material.dart';
import 'root_shape.dart';

/// A rectangular ticket with rounded corners and a semicircular punch-out
/// notch on each of two opposite edges, as seen on admission tickets or
/// coupons.
class Ticket extends RootShape {
  /// Corner radius of the ticket rectangle in logical pixels. Defaults to 8.
  final double cornerRadius;

  /// Radius of each semicircular punch-out notch in logical pixels. Defaults to 10.
  final double punchRadius;

  /// Which pair of edges the punch notches appear on. true places them on
  /// the left and right edges; false places them on the top and bottom edges.
  /// Defaults to true.
  final bool punchOnSides;

  /// Position of the punch notches along their respective edges as a fraction
  /// (0.0–1.0). 0.0 is the start of the edge; 1.0 is the end. Defaults to
  /// 0.5 (centered).
  final double punchPosition;

  const Ticket({
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
    this.cornerRadius = 8.0,
    this.punchRadius = 10.0,
    this.punchOnSides = true,
    this.punchPosition = 0.5,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        cornerRadius,
        punchRadius,
        punchOnSides,
        punchPosition,
      ];

  @override
  Path getPath(Size size) {
    final Path path = Path();
    final double w = size.width;
    final double h = size.height;

    // We draw a rectangle but with concave "punches"
    final Rect rect = Rect.fromLTWH(0, 0, w, h);
    
    // Main body with rounded corners
    path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(cornerRadius)));

    // Create the "punches" (concave cutouts)
    final Path punches = Path();
    
    if (punchOnSides) {
      // Left side punch
      final double y = h * (punchPosition);
      punches.addOval(Rect.fromCircle(center: Offset(0, y), radius: punchRadius));
      // Right side punch
      punches.addOval(Rect.fromCircle(center: Offset(w, y), radius: punchRadius));
    } else {
      // Top side punch
      final double x = w * (punchPosition);
      punches.addOval(Rect.fromCircle(center: Offset(x, 0), radius: punchRadius));
      // Bottom side punch
      punches.addOval(Rect.fromCircle(center: Offset(x, h), radius: punchRadius));
    }

    // Subtract the punches from the main body
    return Path.combine(PathOperation.difference, path, punches);
  }
}
