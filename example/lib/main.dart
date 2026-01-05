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

/// 基本的なアニメーション例
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

/// コインアニメーション例
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

    // ランダムな位置からコインを生成
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

/// カートへ追加アニメーション例
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
                      color: Colors.primaries[index % Colors.primaries.length]
                          .shade100,
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

/// 複数目的地への同時アニメーション例
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
