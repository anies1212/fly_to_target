import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fly_to_target/fly_to_target.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fly To Target Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fly To Target Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          _DemoTile(
            title: 'Basic Animation',
            subtitle: 'Simple linear animation',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BasicExample()),
            ),
          ),
          _DemoTile(
            title: 'Coin Animation',
            subtitle: 'Multiple coins with effects',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CoinExample()),
            ),
          ),
          _DemoTile(
            title: 'Cart Animation',
            subtitle: 'Add to cart with stagger effect',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartExample()),
            ),
          ),
          _DemoTile(
            title: 'Multiple Targets',
            subtitle: 'Items fly to different destinations',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MultipleTargetsExample()),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Custom Animations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          _DemoTile(
            title: 'Custom Path',
            subtitle: 'Spiral and wave trajectories',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CustomPathExample()),
            ),
          ),
          _DemoTile(
            title: 'Decoration Effects',
            subtitle: 'Feathers, particles, and sparkles',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DecorationExample()),
            ),
          ),
          _DemoTile(
            title: 'Full Effects',
            subtitle: 'Rotation, scale, fade combined',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FullEffectsExample()),
            ),
          ),
          _DemoTile(
            title: 'Heart Burst',
            subtitle: 'Hearts flying with love',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HeartBurstExample()),
            ),
          ),
          _DemoTile(
            title: 'Game Rewards',
            subtitle: 'Stars and gems collection',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GameRewardsExample()),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Pre-Phase Animations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          _DemoTile(
            title: 'Spread & Fly',
            subtitle: 'Items spread from center then fly to target',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SpreadAndFlyExample()),
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DemoTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

/// Basic animation example
class BasicExample extends StatefulWidget {
  const BasicExample({super.key});

  @override
  State<BasicExample> createState() => _BasicExampleState();
}

class _BasicExampleState extends State<BasicExample>
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
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.star, color: Colors.white, size: 24),
        ),
        key: key,
      );
    }).toList();

    await _controller.flyAll(
      items: items,
      target: FlyTargetFromKey(_targetKey),
      config: const FlyAnimationConfig(
        duration: Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        staggerDelay: Duration(milliseconds: 100),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Animation'),
        actions: [
          Container(
            key: _targetKey,
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.star_border, size: 32),
          ),
        ],
      ),
      body: Center(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: List.generate(5, (index) {
            return Container(
              key: _itemKeys[index],
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.star, color: Colors.blue),
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _flyAll,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Fly All'),
      ),
    );
  }
}

/// Coin animation example
class CoinExample extends StatefulWidget {
  const CoinExample({super.key});

  @override
  State<CoinExample> createState() => _CoinExampleState();
}

class _CoinExampleState extends State<CoinExample>
    with TickerProviderStateMixin {
  final _controller = FlyToTargetController();
  final _walletKey = GlobalKey();
  int _coinCount = 0;

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

  Future<void> _collectCoins() async {
    final random = Random();
    final screenSize = MediaQuery.of(context).size;

    // Generate coins at random positions
    final coinPositions = List.generate(8, (_) {
      return Offset(
        50 + random.nextDouble() * (screenSize.width - 100),
        200 + random.nextDouble() * (screenSize.height - 400),
      );
    });

    final items = coinPositions.map((offset) {
      return FlyItem.fromOffset(
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.amber.shade300, Colors.orange.shade600],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.5),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              '\$',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        offset: offset,
        size: const Size(40, 40),
      );
    }).toList();

    await _controller.flyAll(
      items: items,
      target: FlyTargetFromKey(_walletKey),
      config: FlyAnimationConfig.coin(
        duration: const Duration(milliseconds: 1000),
        staggerDelay: const Duration(milliseconds: 60),
      ),
    );

    setState(() {
      _coinCount += items.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Animation'),
        actions: [
          Container(
            key: _walletKey,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.wallet, size: 28),
                const SizedBox(width: 8),
                Text(
                  '$_coinCount',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Tap the button to collect coins!',
          style: TextStyle(fontSize: 18),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _collectCoins,
        icon: const Icon(Icons.monetization_on),
        label: const Text('Collect Coins'),
      ),
    );
  }
}

/// Add to cart animation example
class CartExample extends StatefulWidget {
  const CartExample({super.key});

  @override
  State<CartExample> createState() => _CartExampleState();
}

class _CartExampleState extends State<CartExample>
    with TickerProviderStateMixin {
  final _controller = FlyToTargetController();
  final _cartKey = GlobalKey();
  final Map<int, GlobalKey> _productKeys = {};
  int _cartCount = 0;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 6; i++) {
      _productKeys[i] = GlobalKey();
    }
  }

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

  Future<void> _addToCart(int index) async {
    final key = _productKeys[index]!;

    await _controller.fly(
      item: FlyItem.fromKey(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.primaries[index % Colors.primaries.length],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.shopping_bag, color: Colors.white),
        ),
        key: key,
      ),
      target: FlyTargetFromKey(_cartKey),
      config: const FlyAnimationConfig(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
        pathConfig: ParabolicPathConfig(height: -80),
        effects: FlyEffects(
          scale: ScaleEffect(endScale: 0.5),
          fade: FadeEffect(startAt: 0.7),
        ),
      ),
    );

    setState(() {
      _cartCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Animation'),
        actions: [
          Stack(
            children: [
              Container(
                key: _cartKey,
                padding: const EdgeInsets.all(12),
                child: const Icon(Icons.shopping_cart, size: 28),
              ),
              if (_cartCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$_cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              onTap: () => _addToCart(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    key: _productKeys[index],
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors
                          .primaries[index % Colors.primaries.length].shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.shopping_bag,
                      color: Colors.primaries[index % Colors.primaries.length],
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Product ${index + 1}'),
                  const SizedBox(height: 4),
                  const Text(
                    'Tap to add',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Multiple targets animation example
class MultipleTargetsExample extends StatefulWidget {
  const MultipleTargetsExample({super.key});

  @override
  State<MultipleTargetsExample> createState() => _MultipleTargetsExampleState();
}

class _MultipleTargetsExampleState extends State<MultipleTargetsExample>
    with TickerProviderStateMixin {
  final _controller = FlyToTargetController();
  final _target1Key = GlobalKey();
  final _target2Key = GlobalKey();
  final _target3Key = GlobalKey();
  final List<GlobalKey> _itemKeys = List.generate(9, (_) => GlobalKey());
  final List<int> _targetCounts = [0, 0, 0];

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

  Future<void> _distributeItems() async {
    final targets = [_target1Key, _target2Key, _target3Key];
    final colors = [Colors.red, Colors.green, Colors.blue];

    final itemsWithTargets = _itemKeys.asMap().entries.map((entry) {
      final index = entry.key;
      final key = entry.value;
      final targetIndex = index % 3;

      return FlyItemWithTarget(
        item: FlyItem.fromKey(
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: colors[targetIndex],
              shape: BoxShape.circle,
            ),
          ),
          key: key,
          id: 'item_$index',
        ),
        target: FlyTargetFromKey(targets[targetIndex]),
      );
    }).toList();

    await _controller.flyToTargets(
      itemsWithTargets: itemsWithTargets,
      config: FlyAnimationConfig(
        duration: const Duration(milliseconds: 800),
        staggerDelay: const Duration(milliseconds: 50),
        pathConfig: BezierPathConfig.auto(
          curvature: 0.4,
          randomness: 0.1,
        ),
        effects: const FlyEffects(
          scale: ScaleEffect(endScale: 0.5, startAt: 0.6),
          fade: FadeEffect(startAt: 0.8),
        ),
      ),
    );

    setState(() {
      _targetCounts[0] += 3;
      _targetCounts[1] += 3;
      _targetCounts[2] += 3;
    });
  }

  Widget _buildTarget(GlobalKey key, Color color, int count) {
    return Container(
      key: key,
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          '$count',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiple Targets'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTarget(_target1Key, Colors.red, _targetCounts[0]),
              _buildTarget(_target2Key, Colors.green, _targetCounts[1]),
              _buildTarget(_target3Key, Colors.blue, _targetCounts[2]),
            ],
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Center(
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: List.generate(9, (index) {
                  final colors = [Colors.red, Colors.green, Colors.blue];
                  return Container(
                    key: _itemKeys[index],
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors[index % 3].shade200,
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _distributeItems,
        icon: const Icon(Icons.send),
        label: const Text('Distribute'),
      ),
    );
  }
}

/// Custom path animation example
class CustomPathExample extends StatefulWidget {
  const CustomPathExample({super.key});

  @override
  State<CustomPathExample> createState() => _CustomPathExampleState();
}

class _CustomPathExampleState extends State<CustomPathExample>
    with TickerProviderStateMixin {
  final _controller = FlyToTargetController();
  final _targetKey = GlobalKey();
  String _selectedPath = 'spiral';

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

  PathConfig _getPathConfig() {
    return switch (_selectedPath) {
      'spiral' => CustomPathConfig(
          pathFunction: (t, start, end) {
            // Spiral path
            final angle = t * 4 * pi;
            final radius = (1 - t) * 100;
            final linearX = start.dx + (end.dx - start.dx) * t;
            final linearY = start.dy + (end.dy - start.dy) * t;
            return Offset(
              linearX + cos(angle) * radius,
              linearY + sin(angle) * radius,
            );
          },
        ),
      'wave' => CustomPathConfig(
          pathFunction: (t, start, end) {
            // Wave path
            final linearX = start.dx + (end.dx - start.dx) * t;
            final linearY = start.dy + (end.dy - start.dy) * t;
            final wave = sin(t * 6 * pi) * 50 * (1 - t);
            return Offset(linearX, linearY + wave);
          },
        ),
      'zigzag' => CustomPathConfig(
          pathFunction: (t, start, end) {
            // Zigzag path
            final linearX = start.dx + (end.dx - start.dx) * t;
            final linearY = start.dy + (end.dy - start.dy) * t;
            final segments = 5;
            final segmentT = (t * segments) % 1.0;
            final zigzag = (segmentT < 0.5 ? segmentT * 2 : 2 - segmentT * 2) *
                80 *
                (1 - t);
            return Offset(linearX + zigzag, linearY);
          },
        ),
      'bounce' => CustomPathConfig(
          pathFunction: (t, start, end) {
            // Bounce path
            final linearX = start.dx + (end.dx - start.dx) * t;
            final linearY = start.dy + (end.dy - start.dy) * t;
            final bounceHeight = sin(t * pi) * 150 * pow(1 - t, 0.5);
            return Offset(linearX, linearY - bounceHeight);
          },
        ),
      _ => const LinearPathConfig(),
    };
  }

  Future<void> _flyWithCustomPath() async {
    final screenSize = MediaQuery.of(context).size;
    final random = Random();

    final items = List.generate(5, (i) {
      return FlyItem.fromOffset(
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.purple.shade300,
                Colors.purple.shade700,
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
        ),
        offset: Offset(
          50 + random.nextDouble() * (screenSize.width - 100),
          screenSize.height * 0.6 + random.nextDouble() * 100,
        ),
        size: const Size(36, 36),
      );
    });

    await _controller.flyAll(
      items: items,
      target: FlyTargetFromKey(_targetKey),
      config: FlyAnimationConfig(
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeInOut,
        staggerDelay: const Duration(milliseconds: 100),
        pathConfig: _getPathConfig(),
        effects: const FlyEffects(
          rotation: RotationEffect(rotations: 2 * pi),
          scale: ScaleEffect(endScale: 0.6, startAt: 0.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Path'),
        actions: [
          Container(
            key: _targetKey,
            padding: const EdgeInsets.all(12),
            child: const Icon(Icons.flag, size: 32),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              children: [
                _PathChip(
                  label: 'Spiral',
                  selected: _selectedPath == 'spiral',
                  onTap: () => setState(() => _selectedPath = 'spiral'),
                ),
                _PathChip(
                  label: 'Wave',
                  selected: _selectedPath == 'wave',
                  onTap: () => setState(() => _selectedPath = 'wave'),
                ),
                _PathChip(
                  label: 'Zigzag',
                  selected: _selectedPath == 'zigzag',
                  onTap: () => setState(() => _selectedPath = 'zigzag'),
                ),
                _PathChip(
                  label: 'Bounce',
                  selected: _selectedPath == 'bounce',
                  onTap: () => setState(() => _selectedPath = 'bounce'),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('Select a path type and tap Play'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _flyWithCustomPath,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Play'),
      ),
    );
  }
}

class _PathChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PathChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}

/// Decoration effects animation example
class DecorationExample extends StatefulWidget {
  const DecorationExample({super.key});

  @override
  State<DecorationExample> createState() => _DecorationExampleState();
}

class _DecorationExampleState extends State<DecorationExample>
    with TickerProviderStateMixin {
  final _controller = FlyToTargetController();
  final _targetKey = GlobalKey();
  String _selectedDecoration = 'feather';

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

  List<DecorationConfig> _getDecorations() {
    return switch (_selectedDecoration) {
      'feather' => [
          FeatherDecorationConfig(
            count: 6,
            colors: [
              Colors.white,
              Colors.pink.shade100,
              Colors.purple.shade100,
            ],
            size: const Size(12, 24),
            spread: 40,
            flutter: 1.5,
          ),
        ],
      'particle' => [
          ParticleDecorationConfig(
            count: 20,
            colors: [
              Colors.orange,
              Colors.yellow,
              Colors.red,
            ],
            minSize: 3,
            maxSize: 8,
            speed: 1.5,
          ),
        ],
      'sparkle' => [
          const SparkleDecorationConfig(
            count: 8,
            size: 12,
            color: Colors.amber,
            intensity: 1.0,
            blinkSpeed: 3.0,
          ),
        ],
      'all' => [
          FeatherDecorationConfig(
            count: 4,
            colors: [Colors.white, Colors.pink.shade100],
            size: const Size(10, 20),
          ),
          ParticleDecorationConfig(
            count: 15,
            colors: [Colors.orange, Colors.yellow],
            minSize: 2,
            maxSize: 6,
          ),
          const SparkleDecorationConfig(
            count: 6,
            size: 10,
            color: Colors.amber,
          ),
        ],
      _ => [],
    };
  }

  Future<void> _flyWithDecoration() async {
    final screenSize = MediaQuery.of(context).size;

    final item = FlyItem.fromOffset(
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.pink.shade300, Colors.purple.shade500],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withValues(alpha: 0.5),
              blurRadius: 12,
            ),
          ],
        ),
        child: const Icon(Icons.favorite, color: Colors.white, size: 28),
      ),
      offset: Offset(screenSize.width / 2, screenSize.height * 0.7),
      size: const Size(50, 50),
    );

    await _controller.fly(
      item: item,
      target: FlyTargetFromKey(_targetKey),
      config: FlyAnimationConfig(
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeOut,
        pathConfig: const ParabolicPathConfig(height: -120),
        effects: const FlyEffects(
          rotation: RotationEffect(rotations: pi),
        ),
        decorations: _getDecorations(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decoration Effects'),
        actions: [
          Container(
            key: _targetKey,
            padding: const EdgeInsets.all(12),
            child: const Icon(Icons.catching_pokemon, size: 32),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              children: [
                _PathChip(
                  label: '🪶 Feather',
                  selected: _selectedDecoration == 'feather',
                  onTap: () => setState(() => _selectedDecoration = 'feather'),
                ),
                _PathChip(
                  label: '✨ Particle',
                  selected: _selectedDecoration == 'particle',
                  onTap: () => setState(() => _selectedDecoration = 'particle'),
                ),
                _PathChip(
                  label: '⭐ Sparkle',
                  selected: _selectedDecoration == 'sparkle',
                  onTap: () => setState(() => _selectedDecoration = 'sparkle'),
                ),
                _PathChip(
                  label: '🎆 All',
                  selected: _selectedDecoration == 'all',
                  onTap: () => setState(() => _selectedDecoration = 'all'),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('Select decoration type and tap Play'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _flyWithDecoration,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Play'),
      ),
    );
  }
}

/// Full effects animation example
class FullEffectsExample extends StatefulWidget {
  const FullEffectsExample({super.key});

  @override
  State<FullEffectsExample> createState() => _FullEffectsExampleState();
}

class _FullEffectsExampleState extends State<FullEffectsExample>
    with TickerProviderStateMixin {
  final _controller = FlyToTargetController();
  final _targetKey = GlobalKey();

  double _rotationSpeed = 2.0;
  double _endScale = 0.3;
  double _fadeStart = 0.7;
  bool _clockwise = true;

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

  Future<void> _flyWithEffects() async {
    final screenSize = MediaQuery.of(context).size;

    final items = List.generate(6, (i) {
      final hue = (i / 6 * 360).toDouble();
      return FlyItem.fromOffset(
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: HSVColor.fromAHSV(1, hue, 0.7, 0.9).toColor(),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: HSVColor.fromAHSV(0.5, hue, 0.7, 0.9).toColor(),
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Text(
              '${i + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        offset: Offset(
          40 + (i % 3) * (screenSize.width - 80) / 2,
          screenSize.height * 0.5 + (i ~/ 3) * 80,
        ),
        size: const Size(44, 44),
      );
    });

    await _controller.flyAll(
      items: items,
      target: FlyTargetFromKey(_targetKey),
      config: FlyAnimationConfig(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        staggerDelay: const Duration(milliseconds: 80),
        pathConfig: BezierPathConfig.auto(curvature: 0.5, randomness: 0.2),
        effects: FlyEffects(
          rotation: RotationEffect(
            rotations: _rotationSpeed * pi,
            direction: _clockwise
                ? RotationDirection.clockwise
                : RotationDirection.counterClockwise,
          ),
          scale: ScaleEffect(
            startScale: 1.0,
            endScale: _endScale,
            startAt: 0.4,
          ),
          fade: FadeEffect(
            startOpacity: 1.0,
            endOpacity: 0.0,
            startAt: _fadeStart,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Effects'),
        actions: [
          Container(
            key: _targetKey,
            padding: const EdgeInsets.all(12),
            child: const Icon(Icons.blur_on, size: 32),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rotation Speed',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _rotationSpeed,
              min: 0,
              max: 6,
              divisions: 12,
              label: '${_rotationSpeed.toStringAsFixed(1)}π',
              onChanged: (v) => setState(() => _rotationSpeed = v),
            ),
            Row(
              children: [
                const Text('Direction: '),
                ChoiceChip(
                  label: const Text('Clockwise'),
                  selected: _clockwise,
                  onSelected: (_) => setState(() => _clockwise = true),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Counter'),
                  selected: !_clockwise,
                  onSelected: (_) => setState(() => _clockwise = false),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('End Scale',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _endScale,
              min: 0.1,
              max: 1.0,
              divisions: 9,
              label: _endScale.toStringAsFixed(1),
              onChanged: (v) => setState(() => _endScale = v),
            ),
            const SizedBox(height: 16),
            const Text('Fade Start',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _fadeStart,
              min: 0,
              max: 1,
              divisions: 10,
              label: _fadeStart.toStringAsFixed(1),
              onChanged: (v) => setState(() => _fadeStart = v),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                onPressed: _flyWithEffects,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play Animation'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Heart burst animation example
class HeartBurstExample extends StatefulWidget {
  const HeartBurstExample({super.key});

  @override
  State<HeartBurstExample> createState() => _HeartBurstExampleState();
}

class _HeartBurstExampleState extends State<HeartBurstExample>
    with TickerProviderStateMixin {
  final _controller = FlyToTargetController();
  final _targetKey = GlobalKey();
  final _sourceKey = GlobalKey();
  int _heartCount = 0;

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

  Future<void> _burstHearts() async {
    // Get source position
    final sourceBox =
        _sourceKey.currentContext?.findRenderObject() as RenderBox?;
    if (sourceBox == null) return;

    final sourcePosition = sourceBox.localToGlobal(
      Offset(sourceBox.size.width / 2, sourceBox.size.height / 2),
    );

    final random = Random();
    final heartColors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
    ];

    final items = List.generate(12, (i) {
      final color = heartColors[random.nextInt(heartColors.length)];
      final size = 24.0 + random.nextDouble() * 20;
      return FlyItem.fromOffset(
        child: Icon(
          Icons.favorite,
          color: color,
          size: size,
          shadows: [
            Shadow(
              color: color.withValues(alpha: 0.5),
              blurRadius: 8,
            ),
          ],
        ),
        offset: Offset(
          sourcePosition.dx + (random.nextDouble() - 0.5) * 60,
          sourcePosition.dy + (random.nextDouble() - 0.5) * 40,
        ),
        size: Size(size, size),
      );
    });

    await _controller.flyAll(
      items: items,
      target: FlyTargetFromKey(_targetKey),
      config: FlyAnimationConfig(
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeOutCubic,
        staggerDelay: const Duration(milliseconds: 40),
        pathConfig: BezierPathConfig.auto(curvature: 0.6, randomness: 0.3),
        effects: const FlyEffects(
          rotation: RotationEffect(
            rotations: pi / 2,
            direction: RotationDirection.counterClockwise,
          ),
          scale: ScaleEffect(
            startScale: 1.2,
            endScale: 0.4,
            startAt: 0.3,
          ),
          fade: FadeEffect(startAt: 0.75),
        ),
        decorations: [
          ParticleDecorationConfig(
            count: 8,
            colors: [Colors.pink.shade200, Colors.red.shade200],
            minSize: 2,
            maxSize: 5,
            lifetime: 0.6,
          ),
        ],
      ),
    );

    setState(() {
      _heartCount += items.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart Burst'),
        backgroundColor: Colors.pink.shade100,
        actions: [
          Container(
            key: _targetKey,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red),
                const SizedBox(width: 4),
                Text(
                  '$_heartCount',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pink.shade50, Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            key: _sourceKey,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.favorite_border, size: 80, color: Colors.pink),
              SizedBox(height: 16),
              Text(
                'Tap to send love!',
                style: TextStyle(fontSize: 20, color: Colors.pink),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: _burstHearts,
        backgroundColor: Colors.pink,
        child: const Icon(Icons.favorite, size: 36),
      ),
    );
  }
}

/// Game rewards animation example
class GameRewardsExample extends StatefulWidget {
  const GameRewardsExample({super.key});

  @override
  State<GameRewardsExample> createState() => _GameRewardsExampleState();
}

class _GameRewardsExampleState extends State<GameRewardsExample>
    with TickerProviderStateMixin {
  final _controller = FlyToTargetController();
  final _starTargetKey = GlobalKey();
  final _gemTargetKey = GlobalKey();
  int _starCount = 0;
  int _gemCount = 0;

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

  Future<void> _collectRewards() async {
    final screenSize = MediaQuery.of(context).size;
    final random = Random();

    // Stars
    final stars = List.generate(6, (i) {
      return FlyItemWithTarget(
        item: FlyItem.fromOffset(
          child: const Icon(Icons.star, color: Colors.amber, size: 32),
          offset: Offset(
            50 + random.nextDouble() * (screenSize.width - 100),
            screenSize.height * 0.4 + random.nextDouble() * 150,
          ),
          size: const Size(32, 32),
          id: 'star_$i',
        ),
        target: FlyTargetFromKey(_starTargetKey),
      );
    });

    // Gems
    final gems = List.generate(4, (i) {
      final gemColors = [Colors.cyan, Colors.purple, Colors.green, Colors.red];
      return FlyItemWithTarget(
        item: FlyItem.fromOffset(
          child: Icon(
            Icons.diamond,
            color: gemColors[i],
            size: 28,
            shadows: [
              Shadow(
                color: gemColors[i].withValues(alpha: 0.5),
                blurRadius: 8,
              ),
            ],
          ),
          offset: Offset(
            80 + random.nextDouble() * (screenSize.width - 160),
            screenSize.height * 0.5 + random.nextDouble() * 100,
          ),
          size: const Size(28, 28),
          id: 'gem_$i',
        ),
        target: FlyTargetFromKey(_gemTargetKey),
      );
    });

    await _controller.flyToTargets(
      itemsWithTargets: [...stars, ...gems],
      config: FlyAnimationConfig(
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutBack,
        staggerDelay: const Duration(milliseconds: 50),
        pathConfig: BezierPathConfig.auto(curvature: 0.5),
        effects: const FlyEffects(
          rotation: RotationEffect(rotations: 2 * pi),
          scale: ScaleEffect(endScale: 0.5, startAt: 0.5),
          fade: FadeEffect(startAt: 0.8),
        ),
        decorations: [
          const SparkleDecorationConfig(
            count: 5,
            size: 8,
            color: Colors.white,
            blinkSpeed: 4,
          ),
        ],
      ),
    );

    setState(() {
      _starCount += stars.length;
      _gemCount += gems.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Rewards'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade900, Colors.indigo.shade700],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _RewardCounter(
                    key: _starTargetKey,
                    icon: Icons.star,
                    color: Colors.amber,
                    count: _starCount,
                  ),
                  _RewardCounter(
                    key: _gemTargetKey,
                    icon: Icons.diamond,
                    color: Colors.cyan,
                    count: _gemCount,
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.celebration,
                      size: 80,
                      color: Colors.white54,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Collect your rewards!',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _collectRewards,
        backgroundColor: Colors.amber,
        icon: const Icon(Icons.card_giftcard),
        label: const Text('Collect!'),
      ),
    );
  }
}

class _RewardCounter extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int count;

  const _RewardCounter({
    super.key,
    required this.icon,
    required this.color,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Spread & Fly animation example
/// Items spread from a center point, then fly to the target
class SpreadAndFlyExample extends StatefulWidget {
  const SpreadAndFlyExample({super.key});

  @override
  State<SpreadAndFlyExample> createState() => _SpreadAndFlyExampleState();
}

class _SpreadAndFlyExampleState extends State<SpreadAndFlyExample>
    with TickerProviderStateMixin {
  final _controller = FlyToTargetController();
  final _targetKey = GlobalKey();
  final _sourceKey = GlobalKey();
  int _ticketCount = 0;

  // Configurable parameters
  Duration _spreadDuration = const Duration(milliseconds: 400);
  Curve _spreadCurve = Curves.easeOutBack;
  Duration _flyDuration = const Duration(milliseconds: 800);

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

  Future<void> _spreadAndFly() async {
    // Get source (FAB) position
    final sourceBox =
        _sourceKey.currentContext?.findRenderObject() as RenderBox?;
    if (sourceBox == null) return;

    final sourcePosition = sourceBox.localToGlobal(Offset.zero);
    final sourceSize = sourceBox.size;
    final centerPoint = Offset(
      sourcePosition.dx + sourceSize.width / 2,
      sourcePosition.dy + sourceSize.height / 2,
    );

    // Generate spread positions for tickets (zigzag pattern above the FAB)
    const ticketSize = 36.0;
    const verticalSpacing = 20.0;
    const horizontalRange = 60.0;
    const itemCount = 6;

    final items = List.generate(itemCount, (i) {
      // Zigzag offset
      final dy = -i * verticalSpacing - 40;
      final dx = switch (i % 4) {
        0 => 0.0,
        1 => -horizontalRange * 0.8,
        2 => horizontalRange * 0.5,
        3 => -horizontalRange * 0.4,
        _ => 0.0,
      };

      return FlyItem.fromOffset(
        child: Container(
          width: ticketSize,
          height: ticketSize,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.amber.shade300, Colors.orange.shade600],
            ),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.4),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.confirmation_number,
            color: Colors.white,
            size: 22,
          ),
        ),
        // Spread destination position (startPosition)
        offset: Offset(
          centerPoint.dx + dx - ticketSize / 2,
          centerPoint.dy + dy - ticketSize / 2,
        ),
        size: const Size(ticketSize, ticketSize),
      );
    });

    await _controller.flyAll(
      items: items,
      target: FlyTargetFromKey(_targetKey),
      // Using factory method for spread & fly animation
      config: FlyAnimationConfig.spreadAndFly(
        gatherPoint: centerPoint,
        spreadDuration: _spreadDuration,
        spreadCurve: _spreadCurve,
        flyDuration: _flyDuration,
        flyCurve: Curves.easeIn,
        staggerDelay: Duration.zero,
        effects: const FlyEffects(
          scale: ScaleEffect(endScale: 0.5, startAt: 0.5),
        ),
      ),
    );

    setState(() {
      _ticketCount += itemCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spread & Fly'),
        backgroundColor: Colors.orange.shade100,
        actions: [
          Container(
            key: _targetKey,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.confirmation_number, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  '$_ticketCount',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pre-Phase (Spread) Settings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text('Spread Duration: ${_spreadDuration.inMilliseconds}ms'),
            Slider(
              value: _spreadDuration.inMilliseconds.toDouble(),
              min: 100,
              max: 800,
              divisions: 7,
              label: '${_spreadDuration.inMilliseconds}ms',
              onChanged: (v) => setState(
                () => _spreadDuration = Duration(milliseconds: v.toInt()),
              ),
            ),
            const SizedBox(height: 8),
            const Text('Spread Curve:'),
            Wrap(
              spacing: 8,
              children: [
                _CurveChip(
                  label: 'easeOutBack',
                  selected: _spreadCurve == Curves.easeOutBack,
                  onTap: () =>
                      setState(() => _spreadCurve = Curves.easeOutBack),
                ),
                _CurveChip(
                  label: 'easeOut',
                  selected: _spreadCurve == Curves.easeOut,
                  onTap: () => setState(() => _spreadCurve = Curves.easeOut),
                ),
                _CurveChip(
                  label: 'elasticOut',
                  selected: _spreadCurve == Curves.elasticOut,
                  onTap: () => setState(() => _spreadCurve = Curves.elasticOut),
                ),
              ],
            ),
            const Divider(height: 32),
            const Text(
              'Main Phase (Fly) Settings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text('Fly Duration: ${_flyDuration.inMilliseconds}ms'),
            Slider(
              value: _flyDuration.inMilliseconds.toDouble(),
              min: 300,
              max: 1500,
              divisions: 12,
              label: '${_flyDuration.inMilliseconds}ms',
              onChanged: (v) => setState(
                () => _flyDuration = Duration(milliseconds: v.toInt()),
              ),
            ),
            const SizedBox(height: 32),
            const Center(
              child: Text(
                'Tap the FAB to see the spread & fly animation!',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: _sourceKey,
        onPressed: _spreadAndFly,
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.confirmation_number),
        label: const Text('Collect Tickets'),
      ),
    );
  }
}

class _CurveChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CurveChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
