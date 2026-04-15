import 'package:flutter/material.dart';
import 'root_shape.dart';

/// A circle or ellipse shape.
///
/// When [size] is used, or [width] and [height] are equal, the shape is a
/// perfect circle. When [width] and [height] differ it becomes an ellipse.
class Circle extends RootShape {
  const Circle({
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
  });

  @override
  Path getPath(Size size) {
    return Path()..addOval(Offset.zero & size);
  }
}
