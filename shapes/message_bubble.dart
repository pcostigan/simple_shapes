import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'root_shape.dart';

/// A rounded-rectangle speech bubble with a triangular tail that can be
/// positioned anywhere along the perimeter and pointed in any direction.
///
/// The bubble body is inset from the bounding box by [tailLength] on all
/// sides so the tail can extend outward without being clipped.
class MessageBubble extends RootShape {
  /// Position of the tail's base along the bubble perimeter, as a fraction
  /// of the total perimeter (0.0–1.0). 0.0 is the top-center, moving
  /// clockwise. Defaults to 0.5 (bottom-center).
  final double tailPosition;

  /// Length of the tail from the bubble edge to its tip, in logical pixels.
  /// Also controls how much the bubble body is inset from the bounding box,
  /// so larger values shrink the bubble. Defaults to 15.
  final double tailLength;

  /// Direction the tail points, in degrees. 0° points up, 90° points right,
  /// 180° points down (the default), 270° points left.
  final double tailAngle;

  /// Width of the tail at its base in logical pixels. Defaults to 15.
  final double tailWidth;

  /// Corner radius of the rounded-rectangle bubble body in logical pixels.
  /// Independent of [radius], which is not used by this shape. Defaults to 12.
  final double borderRadius;

  const MessageBubble({
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
    this.tailPosition = 0.5, // Default to bottom-center
    this.tailLength = 15.0,
    this.tailAngle = 180.0, // Default to pointing down
    this.tailWidth = 15.0,
    this.borderRadius = 12.0,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        tailPosition,
        tailLength,
        tailAngle,
        tailWidth,
        borderRadius,
      ];

  @override
  Path getPath(Size size) {
    final double w = size.width;
    final double h = size.height;

    // We reserve space for the tail by insetting the bubble body.
    final double inset = tailLength;
    final Rect bubbleRect = Rect.fromLTWH(
      inset, 
      inset, 
      math.max(0, w - 2 * inset), 
      math.max(0, h - 2 * inset)
    );

    final path = Path();
    if (bubbleRect.isEmpty) return path;

    // Add the main rounded rectangle body
    path.addRRect(RRect.fromRectAndRadius(bubbleRect, Radius.circular(borderRadius)));

    // Calculate tail base position on the bubble perimeter
    final Offset basePoint = _getPerimeterPoint(bubbleRect, tailPosition);
    final double normalAngle = _getNormalAngle(bubbleRect, tailPosition);

    // Calculate tail tip position
    // Map tailAngle where 0 is Up (-90 degrees in math standard)
    final double tipRad = (tailAngle - 90) * math.pi / 180;
    final Offset tip = Offset(
      basePoint.dx + tailLength * math.cos(tipRad),
      basePoint.dy + tailLength * math.sin(tipRad),
    );

    // Calculate tail base side points to give it width
    final double perpRad = tipRad + math.pi / 2;
    
    // To ensure connection, especially when the tail is tilted, we need to
    // move the base points deeper into the bubble. 
    // The "gap" occurs because one corner of the tilted base pulls away from the edge.
    double theta = tipRad - normalAngle;
    // Normalize theta to [-pi, pi]
    theta = (theta + math.pi) % (2 * math.pi) - math.pi;
    
    // Calculate how much extra inward shift is needed based on the tilt angle (theta).
    // We use tan(theta) to calculate the depth required so that the outer corner stays flush.
    final double tiltCompensation = (tailWidth / 2) * math.tan(theta.abs().clamp(0.0, math.pi / 2.2));
    
    final Offset inwardShift = Offset(
      math.cos(normalAngle) * (2.0 + tiltCompensation),
      math.sin(normalAngle) * (2.0 + tiltCompensation),
    );
    
    final Offset p1 = Offset(
      (basePoint.dx - inwardShift.dx) + (tailWidth / 2) * math.cos(perpRad),
      (basePoint.dy - inwardShift.dy) + (tailWidth / 2) * math.sin(perpRad),
    );
    final Offset p2 = Offset(
      (basePoint.dx - inwardShift.dx) - (tailWidth / 2) * math.cos(perpRad),
      (basePoint.dy - inwardShift.dy) - (tailWidth / 2) * math.sin(perpRad),
    );

    // Create the tail triangle
    final tailPath = Path();
    tailPath.moveTo(p1.dx, p1.dy);
    tailPath.lineTo(tip.dx, tip.dy);
    tailPath.lineTo(p2.dx, p2.dy);
    tailPath.close();

    // Union the bubble and the tail
    try {
      return Path.combine(PathOperation.union, path, tailPath);
    } catch (e) {
      path.addPath(tailPath, Offset.zero);
      return path;
    }
  }

  // Helper to find a point on the perimeter of a rectangle by fraction (0.0–1.0).
  // 0.0 is top-center, moving clockwise.
  Offset _getPerimeterPoint(Rect rect, double percent) {
    final double w = rect.width;
    final double h = rect.height;
    final double totalP = 2 * (w + h);
    double d = (percent % 1.0) * totalP;

    final double d1 = w / 2;      // Top-center to top-right
    final double d2 = d1 + h;     // Right edge
    final double d3 = d2 + w;     // Bottom edge
    final double d4 = d3 + h;     // Left edge

    if (d < d1) {
      return Offset(rect.center.dx + d, rect.top);
    } else if (d < d2) {
      return Offset(rect.right, rect.top + (d - d1));
    } else if (d < d3) {
      return Offset(rect.right - (d - d2), rect.bottom);
    } else if (d < d4) {
      return Offset(rect.left, rect.bottom - (d - d3));
    } else {
      return Offset(rect.left + (d - d4), rect.top);
    }
  }

  // Returns the outward normal angle in radians for a given perimeter fraction (0.0–1.0).
  double _getNormalAngle(Rect rect, double percent) {
    final double w = rect.width;
    final double h = rect.height;
    final double totalP = 2 * (w + h);
    double d = (percent % 1.0) * totalP;

    final double d1 = w / 2;
    final double d2 = d1 + h;
    final double d3 = d2 + w;
    final double d4 = d3 + h;

    if (d < d1) return -math.pi / 2; // Top
    if (d < d2) return 0.0;          // Right
    if (d < d3) return math.pi / 2;  // Bottom
    if (d < d4) return math.pi;      // Left
    return -math.pi / 2;             // Top (wrapping)
  }
}
