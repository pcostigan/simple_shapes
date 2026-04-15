import 'package:flutter/material.dart';

class ShapeSettings {
  final double? size;
  final double? width;
  final double? height;
  final Color? borderColor;
  final double borderWidth;
  final Color? insideColor;
  final double rotation;
  final Color shadowColor;
  final Offset shadowOffset;
  final double shadowBlurRadius;
  final double childSizeFactor;
  final double radius;

  const ShapeSettings({
    this.size,
    this.width,
    this.height,
    this.borderColor,
    this.borderWidth = 1.0,
    this.insideColor,
    this.rotation = 0.0,
    this.shadowColor = Colors.transparent,
    this.shadowOffset = Offset.zero,
    this.shadowBlurRadius = 0.0,
    this.childSizeFactor = 1.0,
    this.radius = 0.0,
  });

  factory ShapeSettings.red() {
    return const ShapeSettings(
      insideColor: Colors.red,
      borderColor: Color(0xFFB71C1C), // Red 900
      borderWidth: 2.0,
      radius: 12.0,
      shadowColor: Colors.black26,
      shadowOffset: Offset(4, 4),
      shadowBlurRadius: 8.0,
    );
  }

  ShapeSettings copyWith({
    double? size,
    double? width,
    double? height,
    Color? borderColor,
    double? borderWidth,
    Color? insideColor,
    double? rotation,
    Color? shadowColor,
    Offset? shadowOffset,
    double? shadowBlurRadius,
    double? childSizeFactor,
    double? radius,
  }) {
    return ShapeSettings(
      size: size ?? this.size,
      width: width ?? this.width,
      height: height ?? this.height,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      insideColor: insideColor ?? this.insideColor,
      rotation: rotation ?? this.rotation,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      childSizeFactor: childSizeFactor ?? this.childSizeFactor,
      radius: radius ?? this.radius,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShapeSettings &&
          runtimeType == other.runtimeType &&
          size == other.size &&
          width == other.width &&
          height == other.height &&
          borderColor == other.borderColor &&
          borderWidth == other.borderWidth &&
          insideColor == other.insideColor &&
          rotation == other.rotation &&
          shadowColor == other.shadowColor &&
          shadowOffset == other.shadowOffset &&
          shadowBlurRadius == other.shadowBlurRadius &&
          childSizeFactor == other.childSizeFactor &&
          radius == other.radius;

  @override
  int get hashCode =>
      size.hashCode ^
      width.hashCode ^
      height.hashCode ^
      borderColor.hashCode ^
      borderWidth.hashCode ^
      insideColor.hashCode ^
      rotation.hashCode ^
      shadowColor.hashCode ^
      shadowOffset.hashCode ^
      shadowBlurRadius.hashCode ^
      childSizeFactor.hashCode ^
      radius.hashCode;
}
