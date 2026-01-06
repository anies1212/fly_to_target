## 1.0.1

### Changed
- Converted README videos from mp4 to GIF for pub.dev compatibility
- Updated README version reference to 1.0.0

## 1.0.0

### Added
- First stable release
- Translated all documentation comments to English
- Added 5 custom animation examples:
  - Custom Path (spiral, wave, zigzag, bounce)
  - Decoration Effects (feather, particle, sparkle)
  - Full Effects (adjustable parameters with sliders)
  - Heart Burst
  - Game Rewards

### Removed
- Empty directories

## 0.1.0

Initial release with the following features:

### Core Features
- `FlyToTargetController` for managing animations
- `FlyItem` and `FlyTarget` for defining start/end positions
- Support for `GlobalKey` and `Offset` based positioning
- `FlyToTargetScope` widget for easy controller management

### Animation Paths
- `LinearPathConfig` - Straight line movement
- `ParabolicPathConfig` - Arc/parabola trajectory
- `BezierPathConfig` - Smooth bezier curves with auto-calculation
- `CustomPathConfig` - Custom path functions

### Effects
- `RotationEffect` - Rotate widgets during flight
- `ScaleEffect` - Scale up/down during animation
- `FadeEffect` - Fade in/out
- `TrailEffect` - Leave a trail behind

### Decorations
- `FeatherDecorationConfig` - Floating feather particles
- `ParticleDecorationConfig` - Particle effects
- `SparkleDecorationConfig` - Sparkling stars
- `CustomDecorationConfig` - Custom widget builder

### Presets
- `FlyAnimationConfig.simple()` - Basic linear animation
- `FlyAnimationConfig.parabolic()` - Arc trajectory
- `FlyAnimationConfig.bezier()` - Smooth curve
- `FlyAnimationConfig.coin()` - Full effects for coin animations
