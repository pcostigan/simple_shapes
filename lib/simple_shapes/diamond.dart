import 'package:flutter/material.dart';
import 'root_shape.dart';

/// A gem/diamond silhouette with a flat top edge, a widest point (shoulder)
/// partway down, and a single pointed bottom vertex. Optional facet lines
/// can be drawn to suggest a cut gemstone.
class Diamond extends RootShape {
  /// Width of the flat top edge in logical pixels. Defaults to 60.
  final double topWidth;

  /// Vertical position of the widest point (shoulder) as a fraction of the
  /// total height (0.0–1.0). 0.0 puts the shoulder at the top; 1.0 at the
  /// bottom. Defaults to 0.35 (roughly one-third from the top, like a classic
  /// brilliant cut).
  final double shoulderFraction;

  /// Number of facet lines drawn on each half (crown and pavilion) when
  /// [showFacets] is true. Defaults to 3.
  final int facets;

  /// Whether to draw facet lines over the shape to suggest a cut gemstone.
  /// Defaults to false.
  final bool showFacets;

  const Diamond({
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
    super.width,
    super.height,
    this.topWidth = 60.0,
    this.shoulderFraction = 0.35,
    this.facets = 3,
    this.showFacets = false,
  }) : assert(shoulderFraction >= 0.0 && shoulderFraction <= 1.0, 'shoulderFraction must be between 0.0 and 1.0'),
       assert(facets >= 1, 'facets must be at least 1');

  @override
  List<Object?> get props => [
        ...super.props,
        topWidth,
        shoulderFraction,
        facets,
        showFacets,
      ];

  @override
  Path getPath(Size size) {
    final double w = size.width;
    final double h = size.height;

    // Center the topWidth
    final double horizontalInset = (w - topWidth) / 2;
    // The widest part (shoulder) position
    final double midY = h * shoulderFraction;

    final List<Offset> vertices = [
      Offset(horizontalInset, 0), // Top left
      Offset(w - horizontalInset, 0), // Top right
      Offset(w, midY), // Mid right (widest)
      Offset(w / 2, h), // Bottom point
      Offset(0, midY), // Mid left (widest)
    ];

    final Path path = buildRoundedPath(vertices, size);

    if (showFacets) {
      // Shoulder line
      path.moveTo(0, midY);
      path.lineTo(w, midY);

      // Bottom facets (pavilion)
      // Number of vertical lines is facets - 1
      for (int i = 1; i < facets; i++) {
        final double x = (i * w) / facets;
        path.moveTo(x, midY);
        path.lineTo(w / 2, h);

        // Top facets (crown) - meeting the pavilion lines at the shoulder
        if (x <= w / 2) {
          path.moveTo(horizontalInset, 0);
          path.lineTo(x, midY);
        }
        if (x >= w / 2) {
          path.moveTo(w - horizontalInset, 0);
          path.lineTo(x, midY);
        }
      }
    }

    return path;
  }
}
