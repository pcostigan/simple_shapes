import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'root_shape.dart';

/// An arrow shape pointing upward by default. Use [rotation] to point it in
/// any direction.
///
/// The arrow is made up of two parts: a rectangular **shaft** and a triangular
/// **head**. [width] sets the shaft thickness and [height] sets the total
/// length including the head. Use [headLength] and either [headAngle] or
/// [headWidth] to control the proportions of the head, and [notchAngle] to
/// add a concave or convex indent at the junction between the head and shaft.
class Arrow extends RootShape {
  /// Thickness of the arrow shaft in logical pixels.
  /// Set via the [width] constructor parameter, which defaults to 20.
  final double shaftWidth;

  /// The angle of each barb of the arrowhead measured from the shaft axis,
  /// in degrees. A larger angle produces a wider, flatter head; a smaller
  /// angle produces a longer, narrower head. Valid range: 1–90. Defaults to 45.
  ///
  /// Ignored when [headWidth] is provided.
  final double headAngle;

  /// Length of the arrowhead along the shaft axis, in logical pixels.
  /// This is the distance from the tip to where the barbs meet the shaft.
  /// Defaults to 30.
  final double headLength;

  /// Explicit width of the arrowhead at its widest point, in logical pixels.
  /// When set, this overrides [headAngle] — the barb angle is calculated to
  /// produce exactly this width instead.
  final double? headWidth;

  /// Adjusts the angle of the inner junction where the barbs meet the shaft,
  /// in degrees. Defaults to 0 (flat, perpendicular junction).
  ///
  /// - Positive values push the junction away from the tip, creating a
  ///   **concave notch** at the back of the head (like a military chevron arrow).
  /// - Negative values pull the junction toward the tip, creating a
  ///   **convex back** (like a diamond or kite shape).
  ///
  /// Valid range: -90 to 90 (exclusive).
  final double notchAngle;

  const Arrow({
    super.key,
    super.borderColor,
    super.borderWidth,
    super.insideColor,
    super.child,
    super.childSizeFactor,
    super.size,
    /// Shaft thickness in logical pixels.
    double width = 20.0,
    /// Total arrow length in logical pixels, tip to tail.
    double height = 100.0,
    super.rotation,
    super.shadowColor,
    super.shadowOffset,
    super.shadowBlurRadius,
    super.radius,
    this.headAngle = 45.0,
    this.headLength = 30.0,
    this.headWidth,
    this.notchAngle = 0.0,
  })  : shaftWidth = width,
        assert(headAngle >= 1.0 && headAngle <= 90.0, 'headAngle must be between 1 and 90 degrees'),
        assert(headWidth == null || headWidth > 0, 'headWidth must be positive'),
        assert(notchAngle > -90.0 && notchAngle < 90.0, 'notchAngle must be between -90 and 90 degrees'),
        super(
          // width is repurposed as shaft thickness and stored in shaftWidth;
          // pass 0 here so RootShape sizes the bounding box from height only.
          width: 0,
          height: height,
        );

  @override
  List<Object?> get props => [
        ...super.props,
        shaftWidth,
        headAngle,
        headLength,
        headWidth,
        notchAngle,
      ];

  @override
  Path getPath(Size size) {
    final double centerX = size.width / 2;
    final double h = size.height;

    // Arrow points UP: tip at y=0, shaft tail at y=h.
    // headAngle is the angle of each barb from the shaft axis (vertical).
    // headWidth overrides the angle-derived width when explicitly set.
    final double headHalfWidth = headWidth != null
        ? headWidth! / 2
        : headLength * math.tan(headAngle * math.pi / 180);

    // Wing tips sit headLength below the tip (y = headLength).
    final double wingY = headLength;

    // notchAngle shifts the shaft/head junction away from the tip relative to the wing tips.
    // Positive → junction moves down (away from tip) → concave notch.
    // Negative → junction moves up (toward tip) → convex/diamond back.
    final double dx = headHalfWidth - shaftWidth / 2;
    final double notchYOffset = dx * math.tan(notchAngle * math.pi / 180);
    final double shaftBaseY = wingY + notchYOffset;

    final List<Offset> vertices = [
      Offset(centerX, 0), // Tip at top
      Offset(centerX + headHalfWidth, wingY), // Right barb to right wing tip
      Offset(centerX + shaftWidth / 2, shaftBaseY), // Right wing tip across to shaft junction
      Offset(centerX + shaftWidth / 2, h), // Right side of shaft down to tail
      Offset(centerX - shaftWidth / 2, h), // Shaft tail (bottom)
      Offset(centerX - shaftWidth / 2, shaftBaseY), // Left side of shaft up to junction
      Offset(centerX - headHalfWidth, wingY), // Left wing tip
    ];

    return buildRoundedPath(vertices, size);
  }
}
