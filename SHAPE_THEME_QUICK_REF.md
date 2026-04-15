# ShapeTheme Quick Reference

## Import
```dart
import 'simple_shapes.dart/shape_theme.dart';
```

## Create a Theme
```dart
const shapeTheme = ShapeTheme(
  insideColor: Colors.blue,
  borderColor: Colors.blueAccent,
  borderWidth: 2.0,
  radius: 8.0,
  shadowColor: Colors.black26,
  shadowOffset: Offset(2, 2),
  shadowBlurRadius: 4.0,
);
```

## Apply to App (Wrap with Provider)
```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShapeThemeProvider(
      shapeTheme: shapeTheme,
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
```

## Use Shapes
```dart
// All theme defaults applied
Pentagon(size: 100)

// Override specific properties
Pentagon(
  size: 100,
  borderColor: Colors.red,
  insideColor: Colors.pink,
)
```

## ShapeTheme Properties
```dart
ShapeTheme({
  Color? insideColor,              // Fill color (defaults to ColorScheme.primaryContainer)
  Color? borderColor,              // Stroke color (defaults to ColorScheme.outline)
  double borderWidth = 1.0,        // Border thickness
  double radius = 0.0,             // Corner rounding
  Color shadowColor = transparent, // Shadow color
  Offset shadowOffset = (0, 0),    // Shadow offset
  double shadowBlurRadius = 0.0,   // Shadow blur
})
```

## Create Variations
```dart
final variant = baseTheme.copyWith(
  borderColor: Colors.orange,
  borderWidth: 3.0,
);
```

## Property Resolution Order
1. Explicit parameter (highest priority)
2. ShapeTheme value from provider
3. Widget default (lowest priority)

## Dark Mode
```dart
// In StatefulWidget or using state management:
return ShapeThemeProvider(
  shapeTheme: isDarkMode ? darkShapeTheme : lightShapeTheme,
  child: MaterialApp(
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
  ),
);
```

## Example Shapes
```dart
Pentagon(size: 100)
Hexagon(size: 100)
Circle(size: 100)
Star(size: 100)
Triangle(size: 100)
Heart(size: 100)
Ring(size: 100)
// ... and many more
```

## Get Theme in a Widget
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shapeTheme = ShapeThemeProvider.of(context);
    // or use the extension: context.shapeTheme
    return Text('Border width: ${shapeTheme.borderWidth}');
  }
}
```
