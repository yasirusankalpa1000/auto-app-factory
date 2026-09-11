import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const ImpulseGuardApp());
}

class ImpulseGuardApp extends StatelessWidget {
  const ImpulseGuardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImpulseGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xF2F5F8),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class UrgeLog {
  final String title;
  final String category;
  final double estimatedCost;
  final DateTime timestamp;
  final bool resisted;

  UrgeLog({
    required this.title,
    required this.category,
    required this.estimatedCost,
    required this.timestamp,
    required this.resisted,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  // Global State for Gamification & Logs
  double _totalMoneySaved = 145.50;
  int _urgesResisted = 12;
  int _currentStreak = 4;
  
  final List<UrgeLog> _logs = [
    UrgeLog(
      title: 'Sneakers Sale',
      category: 'Shopping',
      estimatedCost: 65.00,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      resisted: true,
    ),
    UrgeLog(
      title: 'Late Night Fast Food',
      category: 'Snacks',
      estimatedCost: 18.50,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      resisted: true,
    ),
    UrgeLog(
      title: 'In-Game Digital Skin',
      category: 'Gaming',
      estimatedCost: 12.00,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      resisted: true,
    ),
    UrgeLog(
      title: 'Designer Sunglasses',
      category: 'Shopping',
      estimatedCost: 50.00,
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      resisted: true,
    ),
  ];

  void _addLog(UrgeLog log) {
    setState(() {
      _logs.insert(0, log);
      if (log.resisted) {
        _totalMoneySaved += log.estimatedCost;
        _urgesResisted += 1;
        _currentStreak += 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      UrgeTamerTab(onUrgeResisted: _addLog),
      WorkCostCalculatorTab(onSaveImpulse: _addLog),
      DecisionMatrixTab(),
      WillpowerStatsTab(
        totalSaved: _totalMoneySaved,
        urgesResisted: _urgesResisted,
        streak: _currentStreak,
        logs: _logs,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.shield, color: Colors.amber),
            SizedBox(width: 8),
            Text(
              'ImpulseGuard',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '\$${_totalMoneySaved.toStringAsFixed(0)} Saved',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Urge Tamer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Work Cost',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Decision Wheel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Willpower Log',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 1: URGE TAMER (Timer & Distraction Game)
// -----------------------------------------------------------------------------
class UrgeTamerTab extends StatefulWidget {
  final Function(UrgeLog) onUrgeResisted;
  const UrgeTamerTab({Key? key, required this.onUrgeResisted}) : super(key: key);

  @override
  State<UrgeTamerTab> createState() => _UrgeTamerTabState();
}

class _UrgeTamerTabState extends State<UrgeTamerTab> {
  String _selectedCategory = 'Shopping';
  final TextEditingController _itemController = TextEditingController(text: 'Impulse Item');
  final TextEditingController _priceController = TextEditingController(text: '25.00');

  Timer? _timer;
  int _secondsRemaining = 180; // 3 minutes standard pause
  bool _isTimerRunning = false;
  
  // Interactive mini distraction counter during timer
  int _tapCount = 0;
  String _mindfulnessPrompt = "Breathe in deeply as the circle expands...";

  final List<String> _categories = ['Shopping', 'Snacks', 'Gaming', 'Social Media', 'Other'];

  void _startTimer() {
    if (_isTimerRunning) return;
    setState(() {
      _isTimerRunning = true;
      _secondsRemaining = 180;
      _tapCount = 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
          if (_secondsRemaining % 10 == 0) {
            _updatePrompt();
          }
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isTimerRunning = false;
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
    });
  }

  void _updatePrompt() {
    final prompts = [
      "Ask yourself: Will I care about this item in 30 days?",
      "Take 3 deep, slow breaths right now.",
      "Consider what else this money or time could achieve.",
      "Urges peak like ocean waves and naturally pass.",
      "You are in total control of your impulses."
    ];
    _mindfulnessPrompt = prompts[Random().nextInt(prompts.length)];
  }

  @override
  void dispose() {
    _timer?.cancel();
    _itemController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = 1.0 - (_secondsRemaining / 180.0);
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.shield, color: Colors.teal, size: 28),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Urge Cool-Down Zone',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Neuroscience shows that delaying an impulse for just 3 minutes reduces the urge by over 80%.',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Inputs
            if (!_isTimerRunning) ...[
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'What impulse are you facing?',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _categories.map((cat) {
                          final isSelected = _selectedCategory == cat;
                          return ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            selectedColor: Colors.teal,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (val) {
                              if (val) setState(() => _selectedCategory = cat);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _itemController,
                        decoration: const InputDecoration(
                          labelText: 'Name / Description',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Estimated Cost (\$) or Hours Spent',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _startTimer,
                          icon: const Icon(Icons.play_arrow, color: Colors.white),
                          label: const Text(
                            'START 3-MIN COOL DOWN',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Active Cool-Down View
            if (_isTimerRunning) ...[
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.teal.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Resisting: ${_itemController.text.isEmpty ? "Impulse" : _itemController.text}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 10,
                              backgroundColor: Colors.teal.shade100,
                              color: Colors.teal,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const Text(
                                'Remaining',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _mindfulnessPrompt,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Distraction Tap Tool to stay in app
                      const Text(
                        'Tap the zen circle to focus your mind:',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _tapCount++;
                          });
                        },
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.teal,
                          child: Text(
                            '$_tapCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                _stopTimer();
                                double cost = double.tryParse(_priceController.text) ?? 0.0;
                                widget.onUrgeResisted(
                                  UrgeLog(
                                    title: _itemController.text.isEmpty ? 'Impulse' : _itemController.text,
                                    category: _selectedCategory,
                                    estimatedCost: cost,
                                    timestamp: DateTime.now(),
                                    resisted: false,
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Log updated. Keep building your awareness!')),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                              ),
                              child: const Text('Gave In'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _stopTimer();
                                double cost = double.tryParse(_priceController.text) ?? 0.0;
                                widget.onUrgeResisted(
                                  UrgeLog(
                                    title: _itemController.text.isEmpty ? 'Impulse' : _itemController.text,
                                    category: _selectedCategory,
                                    estimatedCost: cost,
                                    timestamp: DateTime.now(),
                                    resisted: true,
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Victory! Beat urge & saved \$${cost.toStringAsFixed(2)}!'),
                                    backgroundColor: Colors.teal,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Beat Urge!'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 2: WORK-HOURS TO COST CALCULATOR
// -----------------------------------------------------------------------------
class WorkCostCalculatorTab extends StatefulWidget {
  final Function(UrgeLog) onSaveImpulse;
  const WorkCostCalculatorTab({Key? key, required this.onSaveImpulse}) : super(key: key);

  @override
  State<WorkCostCalculatorTab> createState() => _WorkCostCalculatorTabState();
}

class _WorkCostCalculatorTabState extends State<WorkCostCalculatorTab> {
  final TextEditingController _hourlyWageController = TextEditingController(text: '22.50');
  final TextEditingController _itemPriceController = TextEditingController(text: '89.99');
  final TextEditingController _itemNameController = TextEditingController(text: 'Designer Hoodie');

  double _hoursToWork = 0.0;
  double _groceriesEquivalent = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateRealCost();
  }

  void _calculateRealCost() {
    double wage = double.tryParse(_hourlyWageController.text) ?? 1.0;
    double price = double.tryParse(_itemPriceController.text) ?? 0.0;

    if (wage <= 0) wage = 1.0;

    // After-tax wage estimation (~80%)
    double netWage = wage * 0.80;

    setState(() {
      _hoursToWork = price / netWage;
      // Average standard meal estimated at \$12
      _groceriesEquivalent = price / 12.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.calculate, color: Colors.indigo, size: 28),
                        SizedBox(width: 8),
                        Text(
                          'Real Work-Hours Converter',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Convert prices into actual hours of life and labor required to pay for them.',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Form inputs
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _hourlyWageController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculateRealCost(),
                      decoration: const InputDecoration(
                        labelText: 'Your Hourly Wage (\$/hr)',
                        prefixIcon: Icon(Icons.monetization_on, color: Colors.indigo),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _itemNameController,
                      decoration: const InputDecoration(
                        labelText: 'Item Name',
                        prefixIcon: Icon(Icons.shopping_bag, color: Colors.indigo),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _itemPriceController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculateRealCost(),
                      decoration: const InputDecoration(
                        labelText: 'Item Price (\$) = \$',
                        prefixIcon: Icon(Icons.tag, color: Colors.indigo),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Results View Card
            Card(
              elevation: 3,
              color: Colors.indigo.shade900,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'REAL COST BREAKDOWN',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${_hoursToWork.toStringAsFixed(1)} Hours',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(
                      'of your life spent working (after taxes)',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white70),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Icon(Icons.fastfood, color: Colors.amber, size: 24),
                            const SizedBox(height: 4),
                            Text(
                              '~${_groceriesEquivalent.toStringAsFixed(1)} Meals',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Equivalent',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            const Icon(Icons.schedule, color: Colors.amber, size: 24),
                            const SizedBox(height: 4),
                            Text(
                              '${(_hoursToWork / 8.0).toStringAsFixed(1)} Workdays',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Full Labor',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          double price = double.tryParse(_itemPriceController.text) ?? 0.0;
                          widget.onSaveImpulse(
                            UrgeLog(
                              title: _itemNameController.text.isEmpty ? 'Item' : _itemNameController.text,
                              category: 'Shopping',
                              estimatedCost: price,
                              timestamp: DateTime.now(),
                              resisted: true,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Saved \$${price.toStringAsFixed(2)} by skipping this purchase!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        icon: const Icon(Icons.check_circle, color: Colors.white),
                        label: const Text(
                          'I WON\'T BUY THIS (SAVE MONEY)',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 3: DECISION MATRIX WHEEL (Solves Micro-Decision Fatigue)
// -----------------------------------------------------------------------------
class DecisionMatrixTab extends StatefulWidget {
  const DecisionMatrixTab({Key? key}) : super(key: key);

  @override
  State<DecisionMatrixTab> createState() => _DecisionMatrixTabState();
}

class _DecisionMatrixTabState extends State<DecisionMatrixTab> {
  final TextEditingController _optionController = TextEditingController();
  final List<String> _options = [
    'Drink Water & Wait 15 mins',
    'Go for a 5-min Walk',
    'Do 10 Pushups / Stretch',
    'Read 2 Pages of a Book',
  ];

  String _selectedDecision = '';
  bool _isSpinning = false;

  void _addOption() {
    if (_optionController.text.trim().isNotEmpty) {
      setState(() {
        _options.add(_optionController.text.trim());
        _optionController.clear();
      });
    }
  }

  void _spinWheel() {
    if (_options.isEmpty) return;
    setState(() {
      _isSpinning = true;
      _selectedDecision = '';
    });

    Timer(const Duration(milliseconds: 1200), () {
      final random = Random();
      setState(() {
        _selectedDecision = _options[random.nextInt(_options.length)];
        _isSpinning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.psychology, color: Colors.purple, size: 28),
                        SizedBox(width: 8),
                        Text(
                          'Decision Fatigue Resolver',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Stuck on what to do next instead of giving in to boredom or cravings? Let the objective micro-picker choose for you.',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Option input
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _optionController,
                            decoration: const InputDecoration(
                              labelText: 'Add Healthy Alternative / Task',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _addOption,
                          icon: const Icon(Icons.add, color: Colors.purple),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _options.map((opt) {
                        return Chip(
                          label: Text(opt),
                          deleteIcon: const Icon(Icons.delete, size: 16),
                          onDeleted: () {
                            setState(() {
                              _options.remove(opt);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _isSpinning ? null : _spinWheel,
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        label: Text(
                          _isSpinning ? 'SPINNING...' : 'PICK FOR ME',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Result
            if (_selectedDecision.isNotEmpty || _isSpinning) ...[
              Card(
                elevation: 3,
                color: Colors.purple.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text(
                        'YOUR NEXT ACTION:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _isSpinning
                          ? const CircularProgressIndicator(color: Colors.purple)
                          : Text(
                              _selectedDecision,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                      const SizedBox(height: 12),
                      if (!_isSpinning)
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Action accepted! Do it right now.'),
                                backgroundColor: Colors.purple,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Commit & Start'),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 4: WILLPOWER STATS & HISTORY LOG
// -----------------------------------------------------------------------------
class WillpowerStatsTab extends StatelessWidget {
  final double totalSaved;
  final int urgesResisted;
  final int streak;
  final List<UrgeLog> logs;

  const WillpowerStatsTab({
    Key? key,
    required this.totalSaved,
    required this.urgesResisted,
    required this.streak,
    required this.logs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Stat Overview Cards
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 2,
                  color: Colors.teal.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.monetization_on, color: Colors.amber, size: 28),
                        const SizedBox(height: 6),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '\$${totalSaved.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const Text(
                          'Total Saved',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  elevation: 2,
                  color: Colors.deepOrange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.stars, color: Colors.white, size: 28),
                        const SizedBox(height: 6),
                        Text(
                          '$streak Days',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const Text(
                          'Current Streak',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  elevation: 2,
                  color: Colors.blueGrey.shade800,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.shield, color: Colors.lightGreenAccent, size: 28),
                        const SizedBox(height: 6),
                        Text(
                          '$urgesResisted',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const Text(
                          'Urges Beaten',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const Text(
            'Recent Willpower Activity Log',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 10),

          if (logs.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: Text('No urge logs recorded yet. Start a cool-down timer!'),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: log.resisted ? Colors.teal.shade100 : Colors.red.shade100,
                      child: Icon(
                        log.resisted ? Icons.check : Icons.close,
                        color: log.resisted ? Colors.teal : Colors.red,
                      ),
                    ),
                    title: Text(
                      log.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${log.category} • ${log.timestamp.hour}:${log.timestamp.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${log.estimatedCost.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: log.resisted ? Colors.teal : Colors.red,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          log.resisted ? 'Saved' : 'Spent',
                          style: TextStyle(
                            fontSize: 11,
                            color: log.resisted ? Colors.teal : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}