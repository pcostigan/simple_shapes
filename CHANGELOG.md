# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2024-05-22
Added an example program. 

## [1.0.0] - 2026-04-15

### Added
- Initial release of simple_shapes library
- RootShape base class with comprehensive styling options:
  - Border color and width
  - Fill color and shadow effects
  - Corner rounding via `radius` parameter
  - Rotation support
  - Child widget support with clipping
  - Theme integration via ShapeThemeProvider
- Polygon shapes:
  - Triangle (with angle-based factory constructor)
  - Square/Parallelogram
  - Pentagon
  - Hexagon
  - Septagon
  - Octagon
  - Rhombus
  - Diamond (with optional facet lines)
- Star shape with configurable points and inner radius
- Arrow shape with customizable head and notch angles
- Trapezoid (with inverted variant support)
- Cross/Plus shape with adjustable crossbar position
- Chevron (V-shape) with configurable opening angle
- Ticket shape with semicircular punch-out notches
- Badge shapes (Badge1, Badge2, Badge3)
- Heart shape with cubic Bézier curves
- Crescent shape with uniform thickness
- Wedge/Pie-slice shape with filled and outline modes
- Teardrop shape with circular base
- Circle and Ring (annulus) shapes
- Gear shape with configurable teeth
- ShapeTheme for consistent styling across widgets
- Full support for inheritance of parameters from RootShape and theme fallbacks

### Changed
- All widgets now properly use `radius` parameter from RootShape base class
- Ticket widget refactored to use inherited `radius` instead of custom `cornerRadius`

### Fixed
- Corrected package name from "simple_shapes.dart" to "simple_shapes"
- All shape widgets now consistently respect theme and inherited parameters

### Documentation
- Comprehensive dartdoc comments on all public APIs
- Parameter descriptions and default values documented
- LICENSE file added (MIT)

