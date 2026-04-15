import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'root_shape.dart';

/// A triangle shape whose lower-left and lower-right corners are more or less
/// fixed at the bottom of the bounding box. The apex floats horizontally
/// based on the internal angles.
class Triangle extends RootShape {
  /// Interior angle at the lower-right corner, in degrees.
  final double lowerRightAngle;

  /// Interior angle at the lower-left corner, in degrees.
  /// When using the default constructor, this is effectively 0 in the
  /// coordinate space as the left corner is fixed at (0, height).
  final double lowerLeftAngle;

  /// Primary constructor: Specify width, height, and the lower-right angle.
  ///
  /// The [width] defines the base length, and [height] defines the vertical
  /// distance from the base to the apex. [lowerRightAngle] determines the
  /// horizontal position of the apex relative to the right corner.
  const Triangle({
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
    double width = 100.0,
    double height = 87.0,
    this.lowerRightAngle = 60.0,
  })  : lowerLeftAngle = 0.0,
        assert(lowerRightAngle > 0.0 && lowerRightAngle < 180.0,
        'lowerRightAngle must be between 0 and 180 degrees'),
        super(width: width, height: height);

  /// Factory constructor that defines a triangle using its interior angles.
  ///
  /// You must provide the [width] (base length) and exactly two of the three
  /// possible interior angles: [lowerLeftAngle], [lowerRightAngle], or [topAngle].
  /// The third angle is automatically calculated (summing to 180°).
  ///
  /// The resulting [height] is calculated automatically using the Sine Rule:
  /// ```
  /// height = width * (sin(leftAngle) * sin(rightAngle)) / sin(topAngle)
  /// ```
  /// This ensures the triangle is geometrically "correct" for the given angles
  /// rather than being squashed into an arbitrary height.
  factory Triangle.fromAngles({
    Key? key,
    Color? borderColor,
    double? borderWidth,
    Color? insideColor,
    Widget? child,
    double? childSizeFactor,
    Size? size,
    double? rotation,
    Color? shadowColor,
    Offset? shadowOffset,
    double? shadowBlurRadius,
    double? radius,
    required double width,
    double? lowerLeftAngle,
    double? lowerRightAngle,
    double? topAngle,
  }) {
    // Determine the two angles provided
    double? a = lowerLeftAngle;
    double? b = lowerRightAngle;
    double? c = topAngle;

    // Calculate missing angles (Sum must be 180)
    if (a != null && b != null) {
      c = 180 - a - b;
    } else if (a != null && c != null) {
      b = 180 - a - c;
    } else if (b != null && c != null) {
      a = 180 - b - c;
    } else {
      throw ArgumentError('At least two angles must be provided.');
    }

    if (a <= 0 || b <= 0 || c <= 0) {
      throw ArgumentError('Angles must result in a valid triangle (all > 0).');
    }

    // Calculate height using trigonometry:
    // height = width * (sin(leftAngle) * sin(rightAngle)) / sin(topAngle)
    final double radA = a * math.pi / 180;
    final double radB = b * math.pi / 180;
    final double radC = c * math.pi / 180;
    final double calculatedHeight = width * (math.sin(radA) * math.sin(radB)) / math.sin(radC);

    return Triangle(
      key: key,
      borderColor: borderColor,
      borderWidth: borderWidth,
      insideColor: insideColor,
      childSizeFactor: childSizeFactor,
      // size: size?.width, // Using width as the uniform size
      rotation: rotation,
      shadowColor: shadowColor,
      shadowOffset: shadowOffset,
      shadowBlurRadius: shadowBlurRadius,
      radius: radius,
      width: width,
      height: calculatedHeight,
      lowerRightAngle: b,
      child: child,
    );
  }

  @override
  List<Object?> get props => [...super.props, lowerRightAngle, lowerLeftAngle];

  @override
  Path getPath(Size size) {
    final double w = size.width;
    final double h = size.height;

    // The apex sits at x = w - h / tan(lowerRightAngle).
    // Note: math.tan expects radians.
    final double radRight = lowerRightAngle * math.pi / 180;
    final double apexX = w - (h / math.tan(radRight));

    final List<Offset> vertices = [
      Offset(apexX, 0), // apex
      Offset(w, h),     // lower-right
      Offset(0, h),     // lower-left
    ];

    return buildRoundedPath(vertices, size);
  }
}