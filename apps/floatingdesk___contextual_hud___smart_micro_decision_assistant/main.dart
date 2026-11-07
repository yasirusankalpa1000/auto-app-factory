import 'package:flutter/material.dart';

void main() {
  runApp(const FloatingDeskApp());
}

class FloatingDeskApp extends StatelessWidget {
  const FloatingDeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatingDesk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFA5B4FC),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  bool _isOverlayEnabled = true;
  double _savedAmountToday = 14.80;
  
  // Floating Widget position simulation
  double _overlayTop = 90.0;
  double _overlayLeft = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Body Tabs
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                HudDashboardTab(
                  isOverlayEnabled: _isOverlayEnabled,
                  savedAmount: _savedAmountToday,
                  onToggleOverlay: (val) {
                    setState(() {
                      _isOverlayEnabled = val;
                    });
                  },
                ),
                UnitPriceComparatorTab(
                  onSavingsFound: (savings) {
                    setState(() {
                      _savedAmountToday += savings;
                    });
                  },
                ),
                DecisionResolverTab(),
                SnippetsAndAmbientTab(),
              ],
            ),
          ),

          // Simulated Interactive Floating HUD Bar
          if (_isOverlayEnabled)
            Positioned(
              top: _overlayTop,
              left: _overlayLeft,
              child: GestureContainer(
                onPanUpdate: (details) {
                  setState(() {
                    _overlayTop += details.delta.dy;
                    _overlayLeft += details.delta.dx;
                    // Keep roughly in screen bounds
                    if (_overlayTop < 40) _overlayTop = 40;
                    if (_overlayLeft < 10) _overlayLeft = 10;
                  });
                },
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.indigo,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.widgets, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'FloatingDesk Active',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              'Saved Today: \$${_savedAmountToday.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Quick HUD Clipboard Action Triggered!'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.flash_on, color: Colors.indigo, size: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_customize),
            label: 'HUD Desk',
          ),
          NavigationDestination(
            icon: Icon(Icons.compare_arrows),
            label: 'Deal Saver',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology),
            label: 'Resolver',
          ),
          NavigationDestination(
            icon: Icon(Icons.layers),
            label: 'Stash & Sound',
          ),
        ],
      ),
    );
  }
}

// Wrapper for gesture recognizer without invalid syntax
class GestureContainer extends StatelessWidget {
  final Widget child;
  final Function(DragUpdateDetails) onPanUpdate;

  const GestureContainer({super.key, required this.child, required this.onPanUpdate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onPanUpdate,
      child: child,
    );
  }
}

// ==========================================================
// TAB 1: HUD DASHBOARD & DAILY MICRO-BUDGET LOG
// ==========================================================
class HudDashboardTab extends StatefulWidget {
  final bool isOverlayEnabled;
  final double savedAmount;
  final ValueChanged<bool> onToggleOverlay;

  const HudDashboardTab({
    super.key,
    required this.isOverlayEnabled,
    required.savedAmount,
    required this.onToggleOverlay,
  });

  @override
  State<HudDashboardTab> createState() => _HudDashboardTabState();
}

class _HudDashboardTabState extends State<HudDashboardTab> {
  double _dailyLimit = 50.0;
  double _spentToday = 18.50;
  final TextEditingController _expenseController = TextEditingController();

  void _addExpense() {
    final val = double.tryParse(_expenseController.text);
    if (val != null && val > 0) {
      setState(() {
        _spentToday += val;
        _expenseController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_spentToday / _dailyLimit).clamp(0.0, 1.0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Banner Card
          Card(
            color: Colors.indigo,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Floating Screen Assistant',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Switch(
                        value: widget.isOverlayEnabled,
                        activeColor: Colors.amber,
                        onChanged: widget.onToggleOverlay,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.isOverlayEnabled
                        ? 'HUD Overlay is active on top of all screens. Drag the top bubble anywhere!'
                        : 'Enable HUD Overlay to keep quick decision tools floating while using other apps.',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Savings Summary Cards
          Row(
            children: [
              Expanded(
                child: Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      children: [
                        const Icon(Icons.monetization_on, color: Colors.green, size: 28),
                        const SizedBox(height: 6),
                        const Text('Money Saved', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(
                          '\$${widget.savedAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      children: [
                        const Icon(Icons.shield, color: Colors.indigo, size: 28),
                        const SizedBox(height: 6),
                        const Text('Status', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(
                          widget.isOverlayEnabled ? 'HUD READY' : 'STANDBY',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: widget.isOverlayEnabled ? Colors.indigo : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Quick Micro-Budget Tracker
          const Text(
            'Daily Micro-Spend Guard',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Spent: \$${_spentToday.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        'Limit: \$${_dailyLimit.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                    backgroundColor: Colors.grey,
                    color: progress >= 0.85 ? Colors.red : Colors.indigo,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _expenseController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Add quick spend (e.g. 4.50)',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addExpense,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Simulated floating banner alert
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.indigo,
                  content: Row(
                    children: const [
                      Icon(Icons.notifications_active, color: Colors.amber),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text('Simulated Floating Heads-Up Notification active!'),
                      ),
                    ],
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: Colors.white,
              foregroundColor: Colors.indigo,
              side: const BorderSide(color: Colors.indigo),
            ),
            icon: const Icon(Icons.notifications_active),
            label: const Text('Test HUD Floating Alert Banner'),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// TAB 2: SMART UNIT PRICE & DEAL COMPARATOR
// ==========================================================
class UnitPriceComparatorTab extends StatefulWidget {
  final ValueChanged<double> onSavingsFound;

  const UnitPriceComparatorTab({super.key, required this.onSavingsFound});

  @override
  State<UnitPriceComparatorTab> createState() => _UnitPriceComparatorTabState();
}

class _UnitPriceComparatorTabState extends State<UnitPriceComparatorTab> {
  final _priceAController = TextEditingController(text: '4.50');
  final _qtyAController = TextEditingController(text: '250');

  final _priceBController = TextEditingController(text: '7.20');
  final _qtyBController = TextEditingController(text: '450');

  String _resultText = '';
  double _savingsAmount = 0.0;
  String _winner = '';

  void _calculateComparison() {
    final pA = double.tryParse(_priceAController.text) ?? 0.0;
    final qA = double.tryParse(_qtyAController.text) ?? 0.0;
    final pB = double.tryParse(_priceBController.text) ?? 0.0;
    final qB = double.tryParse(_qtyBController.text) ?? 0.0;

    if (pA <= 0 || qA <= 0 || pB <= 0 || qB <= 0) {
      setState(() {
        _resultText = 'Please enter valid prices and quantities for both options.';
        _winner = '';
      });
      return;
    }

    final unitA = pA / qA;
    final unitB = pB / qB;

    setState(() {
      if (unitA < unitB) {
        final diffPercent = ((unitB - unitA) / unitB) * 100;
        final actualSavings = (unitB * qA) - pA;
        _winner = 'Option A is Better Value!';
        _savingsAmount = actualSavings > 0 ? actualSavings : 0.0;
        _resultText =
            'Option A is ${diffPercent.toStringAsFixed(1)}% CHEAPER per unit.\n'
            'Cost A: \$${(unitA * 100).toStringAsFixed(2)} / 100 units\n'
            'Cost B: \$${(unitB * 100).toStringAsFixed(2)} / 100 units\n'
            'You save approximately \$${_savingsAmount.toStringAsFixed(2)}!';
      } else if (unitB < unitA) {
        final diffPercent = ((unitA - unitB) / unitA) * 100;
        final actualSavings = (unitA * qB) - pB;
        _winner = 'Option B is Better Value!';
        _savingsAmount = actualSavings > 0 ? actualSavings : 0.0;
        _resultText =
            'Option B is ${diffPercent.toStringAsFixed(1)}% CHEAPER per unit.\n'
            'Cost A: \$${(unitA * 100).toStringAsFixed(2)} / 100 units\n'
            'Cost B: \$${(unitB * 100).toStringAsFixed(2)} / 100 units\n'
            'You save approximately \$${_savingsAmount.toStringAsFixed(2)}!';
      } else {
        _winner = 'Both are identical in value!';
        _savingsAmount = 0.0;
        _resultText = 'Both options cost exactly the same per unit.';
      }
    });

    if (_savingsAmount > 0) {
      widget.onSavingsFound(_savingsAmount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Deal & Unit Price Comparator',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Instantly calculate which package size yields real savings while shopping.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Product A Card
          Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Option A (Standard Pack)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _priceAController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price (\$)',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _qtyAController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Qty (g / ml / units)',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Product B Card
          Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Option B (Bulk / Promo Pack)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _priceBController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price (\$)',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _qtyBController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Qty (g / ml / units)',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: _calculateComparison,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.calculate),
            label: const Text('Compare Unit Price & Save', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),

          // Result Display
          if (_resultText.isNotEmpty)
            Card(
              color: Colors.amber,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.indigo),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _winner,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.indigo),
                    const SizedBox(height: 6),
                    Text(
                      _resultText,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ==========================================================
// TAB 3: MICRO-DILEMMA & DECISION MATRIX
// ==========================================================
class DecisionResolverTab extends StatefulWidget {
  const DecisionResolverTab({super.key});

  @override
  State<DecisionResolverTab> createState() => _DecisionResolverTabState();
}

class _DecisionResolverTabState extends State<DecisionResolverTab> {
  final _opt1Controller = TextEditingController(text: 'Buy New Tech Gadget');
  final _opt2Controller = TextEditingController(text: 'Save Money for Travel');

  double _urgency1 = 3;
  double _satisfaction1 = 4;

  double _urgency2 = 2;
  double _satisfaction2 = 5;

  String _verdict = '';
  int _score1 = 0;
  int _score2 = 0;

  void _resolveDilemma() {
    final s1 = (_urgency1 * 2 + _satisfaction1 * 3).toInt();
    final s2 = (_urgency2 * 2 + _satisfaction2 * 3).toInt();

    setState(() {
      _score1 = s1;
      _score2 = s2;
      if (s1 > s2) {
        _verdict = 'Verdict: "${_opt1Controller.text}" is your best choice right now!';
      } else if (s2 > s1) {
        _verdict = 'Verdict: "${_opt2Controller.text}" brings higher long-term value!';
      } else {
        _verdict = 'Verdict: It\'s a tie! Flip a coin or balance both options equally.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Dilemma Choice Resolver',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Overcome daily indecision by scoring micro-choices on value & urgency.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Option 1 Matrix
          Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _opt1Controller,
                    decoration: const InputDecoration(
                      labelText: 'Option 1',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Urgency Level: ${_urgency1.toInt()}/5', style: const TextStyle(fontSize: 12)),
                  Slider(
                    value: _urgency1,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    activeColor: Colors.indigo,
                    onChanged: (val) => setState(() => _urgency1 = val),
                  ),
                  Text('Satisfaction Value: ${_satisfaction1.toInt()}/5', style: const TextStyle(fontSize: 12)),
                  Slider(
                    value: _satisfaction1,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    activeColor: Colors.indigo,
                    onChanged: (val) => setState(() => _satisfaction1 = val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Option 2 Matrix
          Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _opt2Controller,
                    decoration: const InputDecoration(
                      labelText: 'Option 2',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Urgency Level: ${_urgency2.toInt()}/5', style: const TextStyle(fontSize: 12)),
                  Slider(
                    value: _urgency2,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    activeColor: Colors.deepPurple,
                    onChanged: (val) => setState(() => _urgency2 = val),
                  ),
                  Text('Satisfaction Value: ${_satisfaction2.toInt()}/5', style: const TextStyle(fontSize: 12)),
                  Slider(
                    value: _satisfaction2,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    activeColor: Colors.deepPurple,
                    onChanged: (val) => setState(() => _satisfaction2 = val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: _resolveDilemma,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.psychology),
            label: const Text('Compute Weighted Recommendation', style: TextStyle(fontWeight: FontWeight.bold)),
          ),

          if (_verdict.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              color: Colors.indigo,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('Score Opt 1', style: TextStyle(color: Colors.white70, fontSize: 12)),
                            Text('$_score1 pts', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Container(width: 1, height: 30, color: Colors.white),
                        Column(
                          children: [
                            const Text('Score Opt 2', style: TextStyle(color: Colors.white70, fontSize: 12)),
                            Text('$_score2 pts', style: const TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _verdict,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ==========================================================
// TAB 4: STASH SNIPPETS & AMBIENT AUDIO HUBS
// ==========================================================
class SnippetsAndAmbientTab extends StatefulWidget {
  const SnippetsAndAmbientTab({super.key});

  @override
  State<SnippetsAndAmbientTab> createState() => _SnippetsAndAmbientTabState();
}

class _SnippetsAndAmbientTabState extends State<SnippetsAndAmbientTab> {
  final List<Map<String, String>> _snippets = [
    {'title': 'WiFi Password', 'content': 'Home_Guest_9921'},
    {'title': 'Promo Code', 'content': 'DISCOUNT2025'},
    {'title': 'Delivery Note', 'content': 'Leave at door near blue plant pot.'},
  ];

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  bool _isPlayingSound = false;
  String _selectedSound = 'Deep Rain';

  void _addSnippet() {
    if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
      setState(() {
        _snippets.add({
          'title': _titleController.text,
          'content': _contentController.text,
        });
        _titleController.clear();
        _contentController.clear();
      });
    }
  }

  void _removeSnippet(int index) {
    setState(() {
      _snippets.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Floating Quick Snippets Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Floating Sticky Snippets',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.content_paste, color: Colors.indigo),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Quick-copy stashes available for rapid screen pasting.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Snippet Title (e.g. Tax ID)',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: 'Content / Code',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _addSnippet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Sticky Snippet'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _snippets.length,
            itemBuilder: (context, index) {
              final snip = _snippets[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text(snip['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(snip['content'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.indigo, size: 20),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Copied "${snip['title']}" to clipboard!'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        onPressed: () => _removeSnippet(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Ambient Background Sound Engine Simulator
          const Text(
            'Ambient Session Audio Engine',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Keep ambient sound playing while using FloatingDesk & other apps.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          Card(
            color: Colors.indigo,
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isPlayingSound ? Icons.volume_up : Icons.volume_off,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _selectedSound,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          _isPlayingSound ? Icons.pause_circle_filled : Icons.play_circle_fill,
                          color: Colors.amber,
                          size: 36,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPlayingSound = !_isPlayingSound;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: ['Deep Rain', 'Cozy Cafe', 'White Noise', 'Forest Stream'].map((sound) {
                      final isSelected = _selectedSound == sound;
                      return ChoiceChip(
                        label: Text(sound),
                        selected: isSelected,
                        selectedColor: Colors.amber,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black : Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (val) {
                          if (val) {
                            setState(() {
                              _selectedSound = sound;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}