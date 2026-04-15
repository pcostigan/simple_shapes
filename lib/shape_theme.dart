import 'package:flutter/material.dart';

/// Defines the default appearance of simple_shapes.dart across your app.
/// Similar to how [TextTheme] or [AppBarTheme] work in Flutter.
///
/// Use [ShapeThemeProvider] to add a [ShapeTheme] to your app:
/// ```dart
/// ShapeThemeProvider(
///   shapeTheme: const ShapeTheme(
///     insideColor: Colors.blue,
///     borderColor: Colors.blueAccent,
///     borderWidth: 2.0,
///   ),
///   child: MaterialApp(
///     theme: ThemeData(useMaterial3: true),
///     home: MyApp(),
///   ),
/// )
/// ```
class ShapeTheme {
  /// Default fill color for the interior of simple_shapes.dart.
  /// If null, simple_shapes.dart will use [ColorScheme.primaryContainer].
  final Color? insideColor;

  /// Default color for the outline stroke.
  /// If null, simple_shapes.dart will use [ColorScheme.outline].
  final Color? borderColor;

  /// Default thickness of the outline stroke in logical pixels.
  final double borderWidth;

  /// Default corner rounding radius applied to polygon vertices, in logical pixels.
  final double radius;

  /// Default color of the drop shadow cast behind simple_shapes.dart.
  final Color shadowColor;

  /// Default distance the shadow is shifted from the shape, in logical pixels.
  final Offset shadowOffset;

  /// Default softness of the shadow edge. Higher values produce a more diffuse blur.
  final double shadowBlurRadius;

  const ShapeTheme({
    this.insideColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.radius = 0.0,
    this.shadowColor = Colors.transparent,
    this.shadowOffset = Offset.zero,
    this.shadowBlurRadius = 0.0,
  });

  /// Create a copy of this theme with some fields replaced.
  ShapeTheme copyWith({
    Color? insideColor,
    Color? borderColor,
    double? borderWidth,
    double? radius,
    Color? shadowColor,
    Offset? shadowOffset,
    double? shadowBlurRadius,
  }) {
    return ShapeTheme(
      insideColor: insideColor ?? this.insideColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      radius: radius ?? this.radius,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShapeTheme &&
          runtimeType == other.runtimeType &&
          insideColor == other.insideColor &&
          borderColor == other.borderColor &&
          borderWidth == other.borderWidth &&
          radius == other.radius &&
          shadowColor == other.shadowColor &&
          shadowOffset == other.shadowOffset &&
          shadowBlurRadius == other.shadowBlurRadius;

  @override
  int get hashCode =>
      insideColor.hashCode ^
      borderColor.hashCode ^
      borderWidth.hashCode ^
      radius.hashCode ^
      shadowColor.hashCode ^
      shadowOffset.hashCode ^
      shadowBlurRadius.hashCode;
}

/// Provides a [ShapeTheme] to all descendant widgets.
///
/// Wrap your [MaterialApp] or app widget tree with this to make a [ShapeTheme]
/// available to all shape widgets via [ShapeTheme.of].
///
/// Example:
/// ```dart
/// ShapeThemeProvider(
///   shapeTheme: const ShapeTheme(
///     insideColor: Colors.blue,
///     borderColor: Colors.blueAccent,
///   ),
///   child: MaterialApp(
///     home: MyApp(),
///   ),
/// )
/// ```
class ShapeThemeProvider extends InheritedWidget {
  /// The shape theme to provide to descendants.
  final ShapeTheme shapeTheme;

  const ShapeThemeProvider({
    super.key,
    required this.shapeTheme,
    required super.child,
  });

  @override
  bool updateShouldNotify(ShapeThemeProvider oldWidget) {
    return shapeTheme != oldWidget.shapeTheme;
  }

  /// Retrieves the [ShapeTheme] for the current context.
  ///
  /// Returns an empty [ShapeTheme] if no provider is found in the widget tree.
  static ShapeTheme of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ShapeThemeProvider>();
    return provider?.shapeTheme ?? const ShapeTheme();
  }
}

/// Convenience extension for accessing [ShapeTheme] from [BuildContext].
extension ShapeThemeExtension on BuildContext {
  /// Retrieves the [ShapeTheme] from the nearest [ShapeThemeProvider].
  ShapeTheme get shapeTheme => ShapeThemeProvider.of(this);

  /// Convenience for wrapping MaterialApp with [ShapeThemeProvider].
  ///
  /// Example:
  /// ```dart
  /// void main() {
  ///   runApp(
  ///     ShapeThemeProvider(
  ///       shapeTheme: const ShapeTheme(insideColor: Colors.blue),
  ///       child: MyApp(),
  ///     ),
  ///   );
  /// }
  /// ```
  static Widget withShapeTheme(ShapeTheme shapeTheme, Widget child) {
    return ShapeThemeProvider(shapeTheme: shapeTheme, child: child);
  }
}
