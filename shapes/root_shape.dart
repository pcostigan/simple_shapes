import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'shape_theme.dart';

/// The ratio of height to base for an equilateral triangle: √(3/2) ≈ 0.866.
/// Use this as a multiplier when you want a truly equilateral triangle:
///   width: 100, height: 100 * equilateralHeightToBase
double equilateralHeightToBase = math.sqrt(3 / 2);

/// Temporarily stores the current [ShapeTheme] during path computation.
/// Set in build() and used by resolved getters in getPath() implementations.
ShapeTheme? _currentShapeTheme;

/// Abstract base class for all shape widgets in this library.
///
/// Subclasses must implement [getPath], which returns the [Path] that defines
/// the shape's outline. Everything else — painting, clipping, shadow, rotation,
/// child layout — is handled here.
///
/// To create a new shape, extend [RootShape] and override [getPath]:
/// ```dart
/// class MyShape extends RootShape {
///   const MyShape({super.key, super.size});
///
///   @override
///   Path getPath(Size size) {
///     return Path()..addRect(Offset.zero & size);
///   }
/// }
/// ```
abstract class RootShape extends StatelessWidget {
  /// Sets both [width] and [height] to the same value, producing a square
  /// bounding box. Takes precedence over [width] and [height] when all three
  /// are provided.
  final double? size;

  /// Explicit width of the bounding box. Ignored when [size] is set.
  /// Falls back to [height] if neither [size] nor [width] is provided.
  final double? width;

  /// Explicit height of the bounding box. Ignored when [size] is set.
  /// Falls back to [width] if neither [size] nor [height] is provided.
  final double? height;

  /// Color of the shape's outline stroke.
  /// Defaults to the theme's [ColorScheme.outline] when null.
  final Color? borderColor;

  /// Thickness of the outline stroke in logical pixels.
  final double? borderWidth;

  /// Fill color of the shape's interior.
  /// Defaults to the theme's [ColorScheme.primaryContainer] when null.
  final Color? insideColor;

  /// Clockwise rotation applied to the entire shape, in degrees.
  final double? rotation;

  /// Color of the drop shadow cast behind the shape.
  final Color? shadowColor;

  /// How far the shadow is shifted from the shape, in logical pixels.
  /// Positive x moves the shadow right; positive y moves it down.
  final Offset? shadowOffset;

  /// Softness of the shadow edge. Higher values produce a more diffuse blur.
  /// Has no visual effect when the resolved shadow color is transparent.
  final double? shadowBlurRadius;

  /// How large the [child] widget is rendered relative to the shape's bounding
  /// box, expressed as a fraction (0.0–1.0). At 1.0 the child fills the full
  /// bounding box; at 0.5 it is half the width and height.
  final double? childSizeFactor;

  /// Corner rounding radius applied to polygon vertices, in logical pixels.
  /// Only has an effect on simple_shapes.dart that use [buildRoundedPath].
  final double? radius;

  /// Optional widget to render inside the shape.
  /// It is clipped to the shape's outline and centered within the bounding box.
  /// Its rendered size is controlled by [childSizeFactor].
  final Widget? child;

  const RootShape({
    super.key,
    this.borderColor,
    this.borderWidth,
    this.insideColor,
    this.child,
    this.rotation,
    this.shadowColor,
    this.shadowOffset,
    this.shadowBlurRadius,
    this.size,
    this.width,
    this.height,
    this.childSizeFactor,
    this.radius,
  });

  // ---------------------------------------------------------------------------
  // Resolved value getters — priority: explicit param → default.
  // These are used internally by build(), buildRoundedPath(), and the painter.
  // ---------------------------------------------------------------------------

  double get resolvedBorderWidth =>
      borderWidth ?? _currentShapeTheme?.borderWidth ?? 1.0;
  double get resolvedRotation => rotation ?? 0.0;
  Color get resolvedShadowColor =>
      shadowColor ?? _currentShapeTheme?.shadowColor ?? Colors.transparent;
  Offset get resolvedShadowOffset =>
      shadowOffset ?? _currentShapeTheme?.shadowOffset ?? Offset.zero;
  double get resolvedShadowBlurRadius =>
      shadowBlurRadius ?? _currentShapeTheme?.shadowBlurRadius ?? 0.0;
  double get resolvedChildSizeFactor => childSizeFactor ?? 1.0;
  double get resolvedRadius => radius ?? _currentShapeTheme?.radius ?? 0.0;

  /// Subclasses implement this to return the shape's outline as a [Path].
  ///
  /// The path should fill the full [size] rectangle — i.e. the coordinate
  /// space is (0,0) at the top-left to (size.width, size.height) at the
  /// bottom-right. The framework scales the bounding box to [width]/[height]
  /// before calling this method, so the path does not need to handle sizing.
  Path getPath(Size size);

  /// Builds a closed path from a list of [vertices] with optional corner
  /// rounding controlled by [radius].
  ///
  /// When [radius] is 0 or negative the vertices are connected with straight
  /// lines. When [radius] is positive each corner is replaced with a quadratic
  /// Bézier curve whose control point sits exactly at the original vertex —
  /// this gives a smooth, circular-ish rounding effect.
  Path buildRoundedPath(List<Offset> vertices, Size size) {
    if (vertices.isEmpty) return Path();

    // No rounding requested — connect vertices directly.
    if (resolvedRadius <= 0) {
      return Path()..addPolygon(vertices, true);
    }

    final Path roundedPath = Path();

    for (int i = 0; i < vertices.length; i++) {
      // For each vertex p2, we also need its neighbours p1 (previous) and
      // p3 (next) so we can compute the angle of the corner and determine
      // how far along each edge the rounding arc should start and end.
      final Offset p1 = vertices[i == 0 ? vertices.length - 1 : i - 1];
      final Offset p2 = vertices[i]; // The corner being rounded.
      final Offset p3 = vertices[(i + 1) % vertices.length];

      // Vectors from the corner outward along each adjacent edge.
      final Offset v1 = p1 - p2; // Points toward the previous vertex.
      final double d1 = v1.distance; // Length of that edge segment.
      final Offset v2 = p3 - p2; // Points toward the next vertex.
      final double d2 = v2.distance;

      // Skip degenerate corners where two vertices are on top of each other.
      // Avoid division by zero
      if (d1 < 0.001 || d2 < 0.001) {
        if (i == 0) {
          roundedPath.moveTo(p2.dx, p2.dy);
        } else {
          roundedPath.lineTo(p2.dx, p2.dy);
        }
        continue;
      }

      // Dot product of the two unit vectors gives cos(θ) where θ is the
      // interior angle at p2. Clamped to [-1, 1] to guard against floating-
      // point values slightly outside that range before passing to acos.
      // Clamp for precision issues
      final double dotProduct = (v1.dx * v2.dx + v1.dy * v2.dy) / (d1 * d2);
      final double angleAtP2 = math.acos(dotProduct.clamp(-1.0, 1.0));
      final double angleDeg = angleAtP2 * 180 / math.pi;

      // Only round corners whose interior angle is between 10° and 170°.
      // Very acute (<10°) or very obtuse (>170°) corners are drawn sharp
      // because rounding them would either overshoot the adjacent edges or
      // produce imperceptibly small arcs.
      // Apply rounding if angle is between 10 and 170 degrees
      if (angleDeg >= 10 && angleDeg <= 170) {
        final double halfAngle = angleAtP2 / 2;

        // The tangent length is how far from the corner vertex the arc
        // must start (and end) on each edge so that a circle of [resolvedRadius]
        // fits snugly in the corner.  Formula: tanLen = radius / tan(θ/2).
        final double tanLen = resolvedRadius / math.tan(halfAngle);

        // Cap the tangent length at half the shorter adjacent edge so the
        // arcs from neighbouring corners never overlap each other.
        final double actualTanLen = math.min(tanLen, math.min(d1, d2) / 2);

        // Walk actualTanLen along each edge away from the corner to find
        // the start and end points of the Bézier arc.
        final Offset startPoint = p2 + (v1 / d1) * actualTanLen;
        final Offset endPoint = p2 + (v2 / d2) * actualTanLen;

        if (i == 0) {
          roundedPath.moveTo(startPoint.dx, startPoint.dy);
        } else {
          roundedPath.lineTo(startPoint.dx, startPoint.dy);
        }

        // Draw a quadratic Bézier from startPoint to endPoint, with the
        // original corner vertex p2 as the control point. This pulls the
        // curve toward the corner, approximating a circular arc.
        roundedPath.quadraticBezierTo(p2.dx, p2.dy, endPoint.dx, endPoint.dy);
      } else {
        // Corner is too sharp or too flat to round — draw it as-is.
        if (i == 0) {
          roundedPath.moveTo(p2.dx, p2.dy);
        } else {
          roundedPath.lineTo(p2.dx, p2.dy);
        }
      }
    }

    roundedPath.close();
    return roundedPath;
  }

  /// Returns the list of properties that influence how the shape looks.
  ///
  /// Used by [_RootShapePainter.shouldRepaint] and [_RootShapeClipper.shouldReclip]
  /// to decide whether a repaint is necessary. Subclasses should override this,
  /// spread [super.props], and append their own fields:
  /// ```dart
  /// @override
  /// List<Object?> get props => [...super.props, myExtraField];
  /// ```
  @mustCallSuper
  List<Object?> get props => [
        size,
        width,
        height,
        borderColor,
        borderWidth,
        insideColor,
        rotation,
        shadowColor,
        shadowOffset,
        shadowBlurRadius,
        childSizeFactor,
        radius,
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shapeTheme = ShapeThemeProvider.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    // Color resolution: explicit param → shape theme → color scheme.
    final Color effectiveBorderColor =
        borderColor ?? shapeTheme.borderColor ?? colorScheme.outline;
    final Color effectiveInsideColor =
        insideColor ?? shapeTheme.insideColor ?? colorScheme.primaryContainer;

    // Other property resolution: explicit param → shape theme → default.
    final double effectiveBorderWidth =
        borderWidth ?? shapeTheme.borderWidth;
    final Color effectiveShadowColor =
        shadowColor ?? shapeTheme.shadowColor;
    final Offset effectiveShadowOffset =
        shadowOffset ?? shapeTheme.shadowOffset;
    final double effectiveShadowBlurRadius =
        shadowBlurRadius ?? shapeTheme.shadowBlurRadius;

    // Size resolution: explicit param → other dimension → 100.
    final double effectiveWidth = size ?? width ?? height ?? 100.0;
    final double effectiveHeight = size ?? height ?? width ?? 100.0;

    // Wrap the child in a SizedBox scaled by resolvedChildSizeFactor so it
    // renders at the right proportion without the caller needing to do math.
    Widget? effectiveChild = child;
    if (effectiveChild != null) {
      effectiveChild = SizedBox(
        width: effectiveWidth * resolvedChildSizeFactor,
        height: effectiveHeight * resolvedChildSizeFactor,
        child: Center(child: effectiveChild),
      );
    }

    // Set the current theme so resolved getters can access it during path computation.
    _currentShapeTheme = shapeTheme;

    return Transform.rotate(
      // Convert degrees to radians for Flutter's rotation API.
      angle: resolvedRotation * math.pi / 180,
      child: SizedBox(
        width: effectiveWidth,
        height: effectiveHeight,
        child: CustomPaint(
          // _RootShapePainter draws the filled shape and its border.
          painter: _RootShapePainter(
            shape: this,
            borderColor: effectiveBorderColor,
            insideColor: effectiveInsideColor,
            borderWidth: effectiveBorderWidth,
            shadowColor: effectiveShadowColor,
            shadowOffset: effectiveShadowOffset,
            shadowBlurRadius: effectiveShadowBlurRadius,
          ),
          // If there's a child, clip it to the shape's outline so it doesn't
          // bleed outside the shape boundary.
          child: effectiveChild != null
              ? ClipPath(
                  clipper: _RootShapeClipper(shape: this),
                  child: Center(
                    child: effectiveChild,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private painter — draws the shape fill, optional shadow, and border stroke.
// ---------------------------------------------------------------------------

class _RootShapePainter extends CustomPainter {
  final RootShape shape;
  final Color borderColor;
  final Color insideColor;
  final double borderWidth;
  final Color shadowColor;
  final Offset shadowOffset;
  final double shadowBlurRadius;

  _RootShapePainter({
    required this.shape,
    required this.borderColor,
    required this.insideColor,
    required this.borderWidth,
    required this.shadowColor,
    required this.shadowOffset,
    required this.shadowBlurRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = shape.getPath(size);

    // Draw the shadow first so it sits underneath the filled shape.
    // We only bother when the shadow is visible (non-transparent color and
    // either a blur or an offset — a zero-blur shadow at Offset.zero is
    // invisible and not worth the paint overhead).
    if (shadowColor != Colors.transparent &&
        (shadowBlurRadius > 0 || shadowOffset != Offset.zero)) {
      final shadowPaint = Paint()
        ..color = shadowColor
        // MaskFilter.blur spreads the shadow outward by shadowBlurRadius pixels.
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlurRadius);
      // path.shift moves the path by the shadow offset without affecting the
      // original path used for the fill and border below.
      canvas.drawPath(path.shift(shadowOffset), shadowPaint);
    }

    // Solid fill — drawn before the border so the stroke sits on top.
    final fillPaint = Paint()
      ..color = insideColor
      ..style = PaintingStyle.fill;

    // Outline stroke — PaintingStyle.stroke draws only the edge, not the interior.
    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _RootShapePainter oldDelegate) {
    // Repaint if any resolved styling changed (e.g. theme switch or property override).
    if (oldDelegate.borderColor != borderColor ||
        oldDelegate.insideColor != insideColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.shadowColor != shadowColor ||
        oldDelegate.shadowOffset != shadowOffset ||
        oldDelegate.shadowBlurRadius != shadowBlurRadius) {
      return true;
    }
    // Otherwise delegate to the shape's own props list so subclasses control
    // when their custom parameters require a redraw.
    return !_listEquals(oldDelegate.shape.props, shape.props);
  }
}

// ---------------------------------------------------------------------------
// Private clipper — clips the child widget to the shape's outline path.
// ---------------------------------------------------------------------------

class _RootShapeClipper extends CustomClipper<Path> {
  final RootShape shape;
  _RootShapeClipper({required this.shape});

  @override
  Path getClip(Size size) {
    final path = shape.getPath(size);
    // Use nonZero fill type for clipping to ensure children are visible in "holes"
    // of simple_shapes.dart like Ring (donut). The painter uses evenOdd for the visual
    // cut-out effect, but evenOdd would also clip out the child in those holes.
    path.fillType = PathFillType.nonZero;
    return path;
  }

  @override
  bool shouldReclip(covariant _RootShapeClipper oldClipper) {
    return !_listEquals(oldClipper.shape.props, shape.props);
  }
}

// ---------------------------------------------------------------------------
// Utility
// ---------------------------------------------------------------------------

/// Element-wise equality check for two lists.
/// Used by the painter and clipper to compare props lists without pulling in
/// the `collection` package.
bool _listEquals(List<Object?> a, List<Object?> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
