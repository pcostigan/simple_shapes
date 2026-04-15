# ShapeTheme Guide

The `ShapeTheme` system allows you to set default styling parameters for all shapes in your app, similar to how Flutter's built-in `TextTheme` or `AppBarTheme` work. This eliminates the need to repeat styling parameters across multiple shape widgets.

## Quick Start

### 1. Define a ShapeTheme

```dart
const myShapeTheme = ShapeTheme(
  insideColor: Colors.blue,
  borderColor: Colors.blueAccent,
  borderWidth: 2.0,
  radius: 8.0,
  shadowColor: Colors.black26,
  shadowOffset: Offset(2, 2),
  shadowBlurRadius: 4.0,
);
```

### 2. Wrap your app with ShapeThemeProvider

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const myShapeTheme = ShapeTheme(
      insideColor: Colors.blue,
      borderColor: Colors.blueAccent,
      borderWidth: 2.0,
      radius: 8.0,
    );

    return ShapeThemeProvider(
      shapeTheme: myShapeTheme,
      child: MaterialApp(
        title: 'My App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
```

### 3. Use shapes normally

All shapes will automatically use your theme defaults:

```dart
// Uses all theme defaults
Pentagon(size: 100)

// Override specific properties
Pentagon(
  size: 100,
  borderColor: Colors.red,  // Overrides theme's borderColor
  // Other properties still use theme defaults
)
```

## ShapeTheme Properties

The `ShapeTheme` class supports the following properties:

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `insideColor` | `Color?` | null (uses ColorScheme.primaryContainer) | Fill color for shape interior |
| `borderColor` | `Color?` | null (uses ColorScheme.outline) | Color of the outline stroke |
| `borderWidth` | `double` | 1.0 | Thickness of the outline in pixels |
| `radius` | `double` | 0.0 | Corner rounding radius (polygon vertices) |
| `shadowColor` | `Color` | Colors.transparent | Color of the drop shadow |
| `shadowOffset` | `Offset` | Offset.zero | Distance the shadow is shifted |
| `shadowBlurRadius` | `double` | 0.0 | Softness of the shadow edge |

## Priority Order

When a shape is rendered, property values are resolved in this order:

1. **Explicit parameter** (highest priority) - passed directly to the shape constructor
2. **ShapeTheme value** - defined in your theme
3. **Widget default** (lowest priority) - fallback to RootShape defaults

For example:
```dart
// This Pentagon will have:
// - borderColor: Colors.red (explicit param, wins)
// - insideColor: theme's insideColor (no explicit param, uses theme)
// - radius: theme's radius (no explicit param, uses theme)
// - shadowOffset: Offset(1, 1) (explicit param, wins)
Pentagon(
  size: 100,
  borderColor: Colors.red,
  shadowOffset: Offset(1, 1),
)
```

## Multiple Themes (Light/Dark Mode)

You can create different themes for light and dark modes using a stateful widget:

```dart
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final lightShapeTheme = const ShapeTheme(
      insideColor: Colors.blue,
      borderColor: Colors.blueAccent,
      borderWidth: 2.0,
      radius: 8.0,
    );

    final darkShapeTheme = const ShapeTheme(
      insideColor: Colors.blueGrey,
      borderColor: Colors.grey,
      borderWidth: 2.0,
      radius: 8.0,
    );

    final shapeTheme = _isDarkMode ? darkShapeTheme : lightShapeTheme;

    return ShapeThemeProvider(
      shapeTheme: shapeTheme,
      child: MaterialApp(
        title: 'My App',
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: HomePage(
          onThemeChanged: (isDark) => setState(() => _isDarkMode = isDark),
        ),
      ),
    );
  }
}
```

## Using ShapeTheme.copyWith()

Create variations of an existing theme:

```dart
final baseTheme = const ShapeTheme(
  borderColor: Colors.blue,
  borderWidth: 2.0,
  radius: 8.0,
);

// Create a variant with different colors
final accentTheme = baseTheme.copyWith(
  borderColor: Colors.orange,
  insideColor: Colors.orangeAccent,
);
```

## Shapes That Support All Theme Properties

All shape classes that extend `RootShape` support the full set of theme properties. This includes:

- `Pentagon`, `Hexagon`, `Heptagon`, `Octagon` (polygons)
- `Star`, `Arrow`, `Chevron` (directional shapes)
- `Circle`, `Square`, `Triangle`, `Diamond` (basic shapes)
- `Heart`, `Crescent`, `Teardrop` (organic shapes)
- `Ring`, `Gear`, `Badge1`, `Badge2`, `Badge3` (special shapes)
- `Cross`, `Trapezoid`, `Rhombus`, `Wedge` (geometric shapes)
- `MessageBubble`, `Ticket` (functional shapes)

## Example: Dark Mode with ShapeTheme

See `lib/shape_theme_example.dart` for a complete, runnable example demonstrating:
- How to define and apply a ShapeTheme
- How to override theme properties on individual shapes
- How theme defaults cascade through to all shapes in your app

Run it with:
```bash
flutter run -t lib/shape_theme_example.dart
```

## How It Works Internally

1. **Theme Resolution**: When `RootShape.build()` is called, it resolves values using the priority order above.
2. **Path Computation**: The resolved theme is temporarily stored so that `buildRoundedPath()` (and other geometry methods) can access theme values during path computation.
3. **Painter Creation**: The painter is created with all resolved values, ensuring consistent rendering.

This approach integrates seamlessly with Flutter's theming system and respects Material Design principles.
