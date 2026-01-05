import 'package:flutter_test/flutter_test.dart';

import 'package:fly_to_target/fly_to_target.dart';

void main() {
  group('PathConfig', () {
    test('LinearPathConfig calculates correct position', () {
      const config = LinearPathConfig();
      final start = const Offset(0, 0);
      final end = const Offset(100, 100);

      expect(config.calculatePosition(0.0, start, end), const Offset(0, 0));
      expect(config.calculatePosition(0.5, start, end), const Offset(50, 50));
      expect(config.calculatePosition(1.0, start, end), const Offset(100, 100));
    });

    test('ParabolicPathConfig calculates curved position', () {
      const config = ParabolicPathConfig(height: -100);
      final start = const Offset(0, 0);
      final end = const Offset(100, 0);

      final midPosition = config.calculatePosition(0.5, start, end);
      expect(midPosition.dx, 50);
      expect(midPosition.dy, lessThan(0)); // 上に膨らむ
    });
  });

  group('FlyEffects', () {
    test('RotationEffect calculates rotation', () {
      const effect = RotationEffect(rotations: 3.14159);
      expect(effect.calculateRotation(0.0), 0.0);
      expect(effect.calculateRotation(1.0), closeTo(3.14159, 0.0001));
    });

    test('ScaleEffect calculates scale', () {
      const effect = ScaleEffect(startScale: 1.0, endScale: 0.5, startAt: 0.5);
      expect(effect.calculateScale(0.0), 1.0);
      expect(effect.calculateScale(0.5), 1.0);
      expect(effect.calculateScale(1.0), 0.5);
    });

    test('FadeEffect calculates opacity', () {
      const effect = FadeEffect(startAt: 0.7, endOpacity: 0.0);
      expect(effect.calculateOpacity(0.0), 1.0);
      expect(effect.calculateOpacity(0.7), 1.0);
      expect(effect.calculateOpacity(1.0), 0.0);
    });
  });

  group('FlyAnimationConfig', () {
    test('default config has expected values', () {
      const config = FlyAnimationConfig();
      expect(config.duration, const Duration(milliseconds: 800));
      expect(config.staggerDelay, const Duration(milliseconds: 50));
      expect(config.pathConfig, isA<LinearPathConfig>());
    });

    test('coin preset has expected effects', () {
      final config = FlyAnimationConfig.coin();
      expect(config.effects.rotation, isNotNull);
      expect(config.effects.scale, isNotNull);
      expect(config.effects.fade, isNotNull);
      expect(config.decorations.length, 2);
    });
  });
}
