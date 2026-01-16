## 1.6.0

### Added
- Group animation support for `FlyAnimationConfig`
  - `groupSize` - Number of items per group (default: 1)
  - `groupStaggerDelay` - Delay between groups
  - `calculateDelay(index)` - Helper method to calculate delay for each item
- Items within the same group start simultaneously
- Example: `groupSize: 2, groupStaggerDelay: 100ms` makes pairs of items appear together

## 1.5.0

### Added
- Progress-based callback triggers for `flyAll` method
  - `spreadTriggerAt` - Progress (0.0-1.0) at which to trigger spread callback
  - `flyTriggerAt` - Progress (0.0-1.0) at which to trigger fly callback
  - Allows triggering haptics/effects before animation completes
- Updated example with sliders to test trigger points

## 1.4.0

### Added
- `onSpreadComplete` callback for `flyAll` method
  - Called each time an individual item completes its spread phase
  - Receives the index of the item that finished spreading
  - Useful for triggering haptics or effects when items spread out

## 1.3.0

### Added
- `onItemComplete` callback for `flyAll` method
  - Called each time an individual item reaches its target
  - Receives the index of the completed item
- Stagger delay slider in Star Trail example

## 1.2.0

### Added
- `StarTrailDecorationConfig` - Stars trailing behind items like game effects
  - `count` - Number of stars in the trail
  - `startDistance` - Distance from item to first star
  - `spreadWidth` - Horizontal spread width
  - `twinkle` - Twinkle animation effect
- New example: Star Trail demo

## 1.1.0

### Added
- Pre-phase animation support with `SpreadPhaseConfig`
  - Items can gather at a point and spread before flying to target
- New factory methods:
  - `FlyAnimationConfig.spreadAndFly()` - Spread from point then fly to target
  - `FlyAnimationConfig.cart()` - Add to cart animation (parabolic + scale + fade)
  - `FlyAnimationConfig.heart()` - Like/burst animation (bezier + rotation + particles)
  - `FlyAnimationConfig.gameReward()` - Game reward collection (bezier + rotation + sparkles)
- New example: Spread & Fly demo

### Changed
- Updated existing examples to use new factory methods

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
