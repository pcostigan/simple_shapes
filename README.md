# simple_shapes

A Flutter package providing a collection of customisable shape widgets. Every shape supports fill colour, border, shadow, rotation, corner rounding, and an optional child widget clipped to the shape's outline.

---

## Shapes included

| | | | |
|---|---|---|---|
| Arrow | Badge2 | Badge3 | Chevron |
| Circle | Crescent | Cross | Diamond |
| Gear | Heart | Hexagon | MessageBubble |
| Octagon | Pentagon | Rhombus | Ring |
| Septagon | Shield | Square | Star |
| Teardrop | Ticket | Trapezoid | Triangle |
| Wedge | | | |

---

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  simple_shapes: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

## Usage

Import the library with a single line:

```dart
import 'package:simple_shapes/simple_shapes.dart';
```

---

## Examples

### Basic shape

The simplest possible usage — size and colour only:

```dart
Circle(
  size: 80,
  insideColor: Colors.blue,
)
```

---

### Border and corner rounding

Use `borderColor`, `borderWidth`, and `radius` to style the edge. `radius`
rounds polygon corners — the higher the value the softer the corner:

```dart
Cross(
  size: 100,
  thickness: 22,
  crossAt: 0.5,          // centred plus sign
  insideColor: Colors.red,
  borderColor: Colors.red.shade900,
  borderWidth: 2,
  radius: 10,            // rounds all 12 corners
)
```

---

### Child widget clipped to the shape

Any widget passed to `child` is centered inside the shape and clipped to its
outline. Use `childSizeFactor` to scale the child relative to the bounding box:

```dart
Pentagon(
  size: 120,
  insideColor: Colors.amber,
  radius: 8,
  childSizeFactor: 0.6,
  child: const Icon(Icons.star, color: Colors.white, size: 40),
)
```

---

### Drop shadow

Pass `shadowColor`, `shadowOffset`, and `shadowBlurRadius` to add a shadow
behind the shape:

```dart
Heart(
  size: 100,
  insideColor: Colors.pink,
  shadowColor: Colors.pink.withOpacity(0.5),
  shadowOffset: const Offset(4, 6),
  shadowBlurRadius: 12,
)
```

---

### Rotation

All shapes accept a `rotation` parameter in degrees, applied around the centre
of the bounding box. Combine with animation for spinning or pulsing effects:

```dart
Star(
  size: 100,
  points: 4,
  innerRadiusRatio: 0.4,
  insideColor: Colors.yellow,
  borderColor: Colors.orange,
  rotation: 45,          // tilts to a four-pointed compass star
)
```

---

### Width and height independently

Use `width` and `height` instead of `size` to stretch a shape:

```dart
Rhombus(
  width: 80,
  height: 120,
  angle: 70,
  insideColor: Colors.teal,
)
```

---

### Speech bubble

`MessageBubble` places a tail anywhere on the perimeter. `tailPosition`
(0.0–1.0) walks clockwise from the top-centre; `tailAngle` controls which
direction the tail points:

```dart
MessageBubble(
  width: 160,
  height: 90,
  insideColor: Colors.white,
  borderColor: Colors.grey,
  tailPosition: 0.65,    // bottom-right area
  tailAngle: 210,        // points down-left
  tailLength: 18,
  borderRadius: 14,
  child: const Padding(
    padding: EdgeInsets.all(8),
    child: Text('Hello!'),
  ),
)
```

---

### Gear with a central icon

`holeDiameter` cuts a circular hole and the child renders inside it:

```dart
Gear(
  size: 110,
  teeth: 10,
  toothDepth: 10,
  toothWidthRatio: 0.6,
  holeDiameter: 50,
  insideColor: Colors.blueGrey,
  child: const Icon(Icons.settings, color: Colors.white, size: 28),
)
```

---

## Common parameters

These parameters are available on every shape.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `size` | `double?` | — | Sets width and height to the same value. |
| `width` | `double?` | — | Bounding box width. Falls back to `height`. |
| `height` | `double?` | — | Bounding box height. Falls back to `width`. |
| `insideColor` | `Color?` | `primaryContainer` | Fill colour. |
| `borderColor` | `Color?` | `outline` | Stroke colour. |
| `borderWidth` | `double` | `1.0` | Stroke thickness in logical pixels. |
| `rotation` | `double` | `0.0` | Clockwise rotation in degrees. |
| `radius` | `double` | `0.0` | Corner rounding radius for polygon shapes. |
| `childSizeFactor` | `double` | `1.0` | Child size as a fraction of the bounding box. |
| `shadowColor` | `Color` | `transparent` | Drop shadow colour. |
| `shadowOffset` | `Offset` | `Offset.zero` | Drop shadow offset. |
| `shadowBlurRadius` | `double` | `0.0` | Drop shadow blur softness. |
| `child` | `Widget?` | — | Widget rendered inside and clipped to the shape. |

---

## Extending the library

All shapes extend `RootShape`. To create a custom shape, extend `RootShape`
and implement `getPath`:

```dart
class Blob extends RootShape {
  const Blob({super.key, super.size, super.insideColor});

  @override
  Path getPath(Size size) {
    // Return a Path that fills the given size rectangle.
    return Path()
      ..addOval(Rect.fromLTWH(0, 0, size.width, size.height));
  }
}
```

Override `props` if your shape has extra parameters that should trigger a
repaint when they change:

```dart
@override
List<Object?> get props => [...super.props, myExtraField];
```

---

## License

MIT — see [LICENSE](LICENSE) for details.
