# fly_to_target

A Flutter package for animating multiple widgets flying to target positions simultaneously with customizable paths and effects.

[![pub package](https://img.shields.io/pub/v/fly_to_target.svg)](https://pub.dev/packages/fly_to_target)

## Features

- Animate multiple widgets simultaneously to one or more targets
- Support for various animation paths (linear, parabolic, bezier curve)
- Built-in effects (rotation, scale, fade, trail)
- Decorative effects (feathers, particles, sparkles)
- Stagger effect for sequential animation starts
- Fully customizable animation timing and curves
- Easy-to-use API with factory methods and presets

## Example
|Basic|Coin|Cart|Multiple|
|---|---|---|---|
<video src = "https://github.com/user-attachments/assets/54166a12-f1c3-4957-8501-17644818091a">|<video src = "https://github.com/user-attachments/assets/534bea0c-39c0-43bc-bd69-c59dbd2e5f1c">|<video src = "https://github.com/user-attachments/assets/6b8b23df-3aee-438b-8271-6837553a2b35">|<video src = "https://github.com/user-attachments/assets/a072ed02-683d-4702-a2bf-5b783561d77a">

## Getting Started

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  fly_to_target: ^0.1.0
```

## Usage

### Basic Usage

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget>
    with TickerProviderStateMixin {
  final _controller = FlyToTargetController();
  final _targetKey = GlobalKey();
  final List<GlobalKey> _itemKeys = List.generate(5, (_) => GlobalKey());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_controller.isAttached) {
      _controller.attach(context, this);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _flyAll() async {
    final items = _itemKeys.map((key) {
      return FlyItem.fromKey(
        child: Icon(Icons.star),
        key: key,
      );
    }).toList();

    await _controller.flyAll(
      items: items,
      target: FlyTargetFromKey(_targetKey),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build your UI with _targetKey and _itemKeys
  }
}
```

### Coin Animation with Effects

```dart
await _controller.flyAll(
  items: items,
  target: FlyTargetFromKey(_walletKey),
  config: FlyAnimationConfig.coin(
    duration: Duration(milliseconds: 1000),
    staggerDelay: Duration(milliseconds: 60),
  ),
);
```

### Multiple Targets

```dart
final itemsWithTargets = [
  FlyItemWithTarget(
    item: FlyItem.fromKey(child: widget1, key: key1),
    target: FlyTargetFromKey(target1Key),
  ),
  FlyItemWithTarget(
    item: FlyItem.fromKey(child: widget2, key: key2),
    target: FlyTargetFromKey(target2Key),
  ),
];

await _controller.flyToTargets(
  itemsWithTargets: itemsWithTargets,
  config: FlyAnimationConfig(
    pathConfig: BezierPathConfig.auto(curvature: 0.4),
  ),
);
```

### Custom Animation Config

```dart
FlyAnimationConfig(
  duration: Duration(milliseconds: 800),
  curve: Curves.easeOut,
  staggerDelay: Duration(milliseconds: 80),
  pathConfig: BezierPathConfig.auto(
    curvature: 0.6,
    randomness: 0.2,
  ),
  effects: FlyEffects(
    rotation: RotationEffect(rotations: 4 * pi),
    scale: ScaleEffect(endScale: 0.5),
    fade: FadeEffect(startAt: 0.8),
  ),
  decorations: [
    FeatherDecorationConfig(count: 3),
    SparkleDecorationConfig(count: 5),
  ],
)
```

## API Reference

### FlyToTargetController

Main controller for managing animations.

```dart
// Fly multiple items to a single target
Future<void> flyAll({
  required List<FlyItem> items,
  required FlyTarget target,
  FlyAnimationConfig? config,
});

// Fly items to different targets
Future<void> flyToTargets({
  required List<FlyItemWithTarget> itemsWithTargets,
  FlyAnimationConfig? config,
});

// Fly a single item
Future<void> fly({
  required FlyItem item,
  required FlyTarget target,
  FlyAnimationConfig? config,
});
```

### FlyItem

Defines the widget and starting position.

```dart
// From GlobalKey (gets position from widget)
FlyItem.fromKey(child: widget, key: globalKey)

// From Offset (explicit position)
FlyItem.fromOffset(child: widget, offset: Offset(100, 200), size: Size(40, 40))
```

### FlyTarget

Defines the destination.

```dart
// From GlobalKey
FlyTargetFromKey(globalKey)

// From Offset
FlyTargetFromOffset(Offset(300, 50))
```

### Path Configurations

| Path | Description |
|------|-------------|
| `LinearPathConfig` | Straight line (default) |
| `ParabolicPathConfig` | Arc/parabola trajectory |
| `BezierPathConfig` | Smooth bezier curve |
| `CustomPathConfig` | Custom path function |

### Effects

| Effect | Description |
|--------|-------------|
| `RotationEffect` | Rotate during flight |
| `ScaleEffect` | Scale up/down |
| `FadeEffect` | Fade in/out |
| `TrailEffect` | Leave a trail |

### Decorations

| Decoration | Description |
|------------|-------------|
| `FeatherDecorationConfig` | Floating feathers |
| `ParticleDecorationConfig` | Particle effects |
| `SparkleDecorationConfig` | Sparkling stars |
| `CustomDecorationConfig` | Custom widget builder |

### Presets

```dart
FlyAnimationConfig.simple()     // Linear with fade
FlyAnimationConfig.parabolic()  // Arc trajectory
FlyAnimationConfig.bezier()     // Smooth curve
FlyAnimationConfig.coin()       // Full effects for coins
```

## Example

Check the [example](example) folder for a complete demo app with:
- Basic Animation
- Coin Collection
- Add to Cart
- Multiple Targets

## License

MIT License - see [LICENSE](LICENSE) for details.
