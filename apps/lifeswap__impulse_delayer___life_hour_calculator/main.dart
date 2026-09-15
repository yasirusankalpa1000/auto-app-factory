import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const LifeSwapApp());
}

class LifeSwapApp extends StatelessWidget {
  const LifeSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeSwap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
          primary: Colors.indigo,
          secondary: Colors.teal,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class SavedImpulse {
  final String id;
  final String title;
  final double cost;
  final double hoursWorked;
  final DateTime date;
  final bool resisted;

  SavedImpulse({
    required this.id,
    required this.title,
    required this.cost,
    required this.hoursWorked,
    required this.date,
    required this.resisted,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  // Shared user profile state
  double _hourlyWage = 25.0;
  final List<SavedImpulse> _history = [
    SavedImpulse(
      id: '1',
      title: 'Designer Sneakers',
      cost: 150.0,
      hoursWorked: 6.0,
      date: DateTime.now().subtract(const Duration(days: 1)),
      resisted: true,
    ),
    SavedImpulse(
      id: '2',
      title: 'Late Night Delivery',
      cost: 35.0,
      hoursWorked: 1.4,
      date: DateTime.now().subtract(const Duration(days: 2)),
      resisted: true,
    ),
    SavedImpulse(
      id: '3',
      title: 'Gaming Accessories',
      cost: 80.0,
      hoursWorked: 3.2,
      date: DateTime.now().subtract(const Duration(days: 4)),
      resisted: false,
    ),
  ];

  void _addSavedImpulse(String title, double cost, bool resisted) {
    final hours = cost / (_hourlyWage > 0 ? _hourlyWage : 1.0);
    setState(() {
      _history.insert(
        0,
        SavedImpulse(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          cost: cost,
          hoursWorked: hours,
          date: DateTime.now(),
          resisted: resisted,
        ),
      );
    });
  }

  void _updateHourlyWage(double wage) {
    setState(() {
      _hourlyWage = wage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ImpulseChamberView(
        hourlyWage: _hourlyWage,
        onUpdateWage: _updateHourlyWage,
        onRecordImpulse: _addSavedImpulse,
      ),
      TradeOffSimulatorView(hourlyWage: _hourlyWage),
      DecisionMatrixView(),
      SavingsVaultView(
        history: _history,
        hourlyWage: _hourlyWage,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.swap_horiz, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'LifeSwap',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Cooling Room',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Trade-Offs',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_outlined),
            selectedIcon: Icon(Icons.psychology),
            label: 'Matrix',
          ),
          NavigationDestination(
            icon: Icon(Icons.savings_outlined),
            selectedIcon: Icon(Icons.savings),
            label: 'Vault Log',
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('About LifeSwap'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'LifeSwap transforms money into your most precious asset: TIME.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Instead of viewing prices in cash, LifeSwap calculates how many real working hours a purchase consumes. Use the Cooling Room to pause impulse buys, test decisions in the Decision Matrix, and watch your saved life-hours stack up in the Vault!',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// TAB 1: IMPULSE COOLING CHAMBER
// ----------------------------------------------------
class ImpulseChamberView extends StatefulWidget {
  final double hourlyWage;
  final Function(double) onUpdateWage;
  final Function(String, double, bool) onRecordImpulse;

  const ImpulseChamberView({
    super.key,
    required this.hourlyWage,
    required this.onUpdateWage,
    required this.onRecordImpulse,
  });

  @override
  State<ImpulseChamberView> createState() => _ImpulseChamberViewState();
}

class _ImpulseChamberViewState extends State<ImpulseChamberView> {
  final _itemController = TextEditingController();
  final _costController = TextEditingController();
  final _wageController = TextEditingController();

  bool _isTimerRunning = false;
  int _secondsRemaining = 180; // 3-minute cooling period
  Timer? _timer;
  int _currentPromptIndex = 0;

  final List<String> _reflectionPrompts = [
    'Will this item increase your daily happiness 30 days from now?',
    'Could you borrow, rent, or find a free alternative instead?',
    'Are you buying this due to stress, boredom, or actual necessity?',
    'What long-term savings or goal could this exact amount support?',
    'If you wait 72 hours, will you still be thinking about this item?',
  ];

  @override
  void initState() {
    super.initState();
    _wageController.text = widget.hourlyWage.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _itemController.dispose();
    _costController.dispose();
    _wageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_costController.text.isEmpty || _itemController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter purchase item and price.')),
      );
      return;
    }

    setState(() {
      _isTimerRunning = true;
      _secondsRemaining = 180;
      _currentPromptIndex = 0;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
          if (_secondsRemaining % 35 == 0) {
            _currentPromptIndex =
                (_currentPromptIndex + 1) % _reflectionPrompts.length;
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

  double get _currentCost => double.tryParse(_costController.text) ?? 0.0;
  double get _currentWage => double.tryParse(_wageController.text) ?? 25.0;

  @override
  Widget build(BuildContext context) {
    final double hoursNeeded =
        _currentWage > 0 ? (_currentCost / _currentWage) : 0.0;
    final int minutesPart = (hoursNeeded * 60).round();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.indigo.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              style: null,
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.shield, color: Colors.indigo, size: 28),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Impulse Cooling-Off Chamber',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Before you tap "Buy", pause and calculate how much of your actual working life this purchase will consume.',
                    style: TextStyle(color: Colors.black87, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Input Section Card
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Purchase Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(
                      labelText: 'What do you want to buy?',
                      hintText: 'e.g. Wireless Headphones',
                      prefixIcon: Icon(Icons.shopping_bag_outlined),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _costController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Price (\$)',
                            hintText: '0.00',
                            prefixIcon: Icon(Icons.attach_money),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _wageController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Hourly Wage (\$)',
                            hintText: '25.00',
                            prefixIcon: Icon(Icons.work_outline),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            final parsed = double.tryParse(val) ?? 25.0;
                            widget.onUpdateWage(parsed);
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Calculations Result Box
          if (_currentCost > 0) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Column(
                children: [
                  const Text(
                    'TRUE COST IN LIFE-HOURS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: Colors.teal,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    child: Text(
                      '${hoursNeeded.toStringAsFixed(1)} Work Hours',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Equivalent to ~$minutesPart minutes of continuous labor',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.teal.shade900, fontSize: 13),
                  ),
                  const Divider(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAxisAlignment.center,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.restaurant, size: 16),
                        label: Text(
                          '~${(_currentCost / 12.0).toStringAsFixed(1)} meals',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Chip(
                        avatar: const Icon(Icons.directions_bus, size: 16),
                        label: Text(
                          '~${(_currentCost / 3.0).toStringAsFixed(1)} transit rides',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Chip(
                        avatar: const Icon(Icons.movie, size: 16),
                        label: Text(
                          '~${(_currentCost / 15.0).toStringAsFixed(1)} movie tickets',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Cooling Timer Section
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Cooling-Off Mindful Break',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isTimerRunning
                        ? 'Timer active! Take a breath and reflect below.'
                        : 'Start a 3-minute countdown to cool off emotional urges before buying.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 16),

                  // Timer display
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isTimerRunning
                          ? Colors.indigo.shade100
                          : Colors.grey.shade200,
                      border: Border.all(
                        color: _isTimerRunning ? Colors.indigo : Colors.grey,
                        width: 4,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _formatTimer(_secondsRemaining),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _isTimerRunning
                              ? Colors.indigo.shade900
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Dynamic prompt card during timer
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.amber),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _reflectionPrompts[_currentPromptIndex],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _isTimerRunning ? Colors.orange : Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            if (_isTimerRunning) {
                              _stopTimer();
                            } else {
                              _startTimer();
                            }
                          },
                          icon: Icon(_isTimerRunning
                              ? Icons.pause
                              : Icons.play_arrow),
                          label: Text(_isTimerRunning
                              ? 'Pause Timer'
                              : 'Start 3-Min Cool'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Outcome Log Buttons
                  if (_currentCost > 0) ...[
                    const Divider(),
                    const Text(
                      'Log Your Decision Outcome:',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green,
                              side: const BorderSide(color: Colors.green),
                            ),
                            onPressed: () {
                              if (_itemController.text.isNotEmpty) {
                                widget.onRecordImpulse(
                                    _itemController.text, _currentCost, true);
                                _itemController.clear();
                                _costController.clear();
                                _stopTimer();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Saved to Vault! Great job resisting!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text(
                              'Resisted! Saved \$',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            onPressed: () {
                              if (_itemController.text.isNotEmpty) {
                                widget.onRecordImpulse(
                                    _itemController.text, _currentCost, false);
                                _itemController.clear();
                                _costController.clear();
                                _stopTimer();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Purchase recorded in Vault.'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.shopping_cart_outlined),
                            label: const Text(
                              'Bought It',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimer(int totalSeconds) {
    final mins = totalSeconds ~/ 60;
    final secs = totalSeconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

// ----------------------------------------------------
// TAB 2: TRADE-OFF SIMULATOR & COMPOUNDING HABIT TOOL
// ----------------------------------------------------
class TradeOffSimulatorView extends StatefulWidget {
  final double hourlyWage;

  const TradeOffSimulatorView({
    super.key,
    required this.hourlyWage,
  });

  @override
  State<TradeOffSimulatorView> createState() => _TradeOffSimulatorViewState();
}

class _TradeOffSimulatorViewState extends State<TradeOffSimulatorView> {
  double _dailyMicroCost = 6.0; // e.g. \$6 daily coffee or snack
  double _years = 5.0;
  double _annualReturnRate = 7.0; // 7% interest simulation

  @override
  Widget build(BuildContext context) {
    final double weeklyCost = _dailyMicroCost * 7;
    final double monthlyCost = _dailyMicroCost * 30.41;
    final double yearlyCost = _dailyMicroCost * 365;

    final double totalDirectSpend = yearlyCost * _years;

    // Compound interest calculation: PMT quarterly/monthly approximate formula
    double compoundFutureValue = 0;
    final int totalMonths = (_years * 12).round();
    final double monthlyRate = (_annualReturnRate / 100) / 12;

    for (int i = 0; i < totalMonths; i++) {
      compoundFutureValue = (compoundFutureValue + monthlyCost) * (1 + monthlyRate);
    }

    final double hoursLostPerYear =
        widget.hourlyWage > 0 ? (yearlyCost / widget.hourlyWage) : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card
          Card(
            color: Colors.teal.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Micro-Habit Trade-Off Simulator',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'See how small daily impulse micro-spends stack up over years when invested instead.',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Interactive Sliders
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Daily Micro-Spend:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${_dailyMicroCost.toStringAsFixed(2)} / day',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _dailyMicroCost,
                    min: 1.0,
                    max: 50.0,
                    divisions: 49,
                    label: '\$${_dailyMicroCost.toStringAsFixed(0)}',
                    onChanged: (val) {
                      setState(() {
                        _dailyMicroCost = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Time Horizon:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${_years.toStringAsFixed(0)} Years',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _years,
                    min: 1.0,
                    max: 30.0,
                    divisions: 29,
                    label: '${_years.toStringAsFixed(0)} yrs',
                    onChanged: (val) {
                      setState(() {
                        _years = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Investment Return Rate:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${_annualReturnRate.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _annualReturnRate,
                    min: 0.0,
                    max: 15.0,
                    divisions: 30,
                    label: '${_annualReturnRate.toStringAsFixed(1)}%',
                    onChanged: (val) {
                      setState(() {
                        _annualReturnRate = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Comparison Stats Cards
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Direct Spent',
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      FittedBox(
                        child: Text(
                          '\$${totalDirectSpend.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'out-of-pocket over ${_years.toStringAsFixed(0)} yrs',
                        style: const TextStyle(fontSize: 11, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'If Invested Value',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      FittedBox(
                        child: Text(
                          '\$${compoundFutureValue.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'with ${_annualReturnRate.toStringAsFixed(1)}% growth',
                        style: const TextStyle(fontSize: 11, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Work Time Equivalency
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Time Equivalent Summary',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryRow(
                      'Monthly Cost:', '\$${monthlyCost.toStringAsFixed(2)}'),
                  _buildSummaryRow(
                      'Yearly Cost:', '\$${yearlyCost.toStringAsFixed(2)}'),
                  _buildSummaryRow('Annual Work Hours Lost:',
                      '${hoursLostPerYear.toStringAsFixed(1)} Hours'),
                  _buildSummaryRow('Work Days Spent / Year:',
                      '${(hoursLostPerYear / 8).toStringAsFixed(1)} Full Days'),
                  const Divider(height: 20),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '💡 Swapping this single micro-spend gives you back ${(hoursLostPerYear / 8).toStringAsFixed(1)} vacation days worth of work every single year!',
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.indigo,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// TAB 3: WEIGHTED DECISION MATRIX
// ----------------------------------------------------
class DecisionMatrixView extends StatefulWidget {
  const DecisionMatrixView({super.key});

  @override
  State<DecisionMatrixView> createState() => _DecisionMatrixViewState();
}

class _DecisionMatrixViewState extends State<DecisionMatrixView> {
  final _decisionItemController = TextEditingController();

  double _necessity = 5.0; // 1 to 10
  double _longTermJoy = 5.0; // 1 to 10
  double _financialImpact = 5.0; // 1 to 10 (higher means worse/more expensive)
  double _alternativeAvailability = 5.0; // 1 to 10

  @override
  void dispose() {
    _decisionItemController.dispose();
    super.dispose();
  }

  double _calculateDecisionScore() {
    // Weighted formula:
    // Necessity: 35%, Long term joy: 35%, Financial lightness: 20% (11 - impact), Alternatives: 10% (11 - alt)
    final score = (_necessity * 3.5) +
        (_longTermJoy * 3.5) +
        ((11 - _financialImpact) * 2.0) +
        ((11 - _alternativeAvailability) * 1.0);
    return score.clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    final double score = _calculateDecisionScore();
    final String verdict = _getVerdict(score);
    final Color verdictColor = _getVerdictColor(score);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card
          Card(
            color: Colors.purple.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Smart Decision Matrix',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Evaluate non-essential purchases rationally with weighted scoring metrics before spending.',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Purchase Input
          TextField(
            controller: _decisionItemController,
            decoration: const InputDecoration(
              labelText: 'Item or Experience under consideration',
              hintText: 'e.g. Upgrade to Smartwatch Series 9',
              prefixIcon: Icon(Icons.help_outline),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Evaluator Sliders Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Evaluate Key Metrics (1 to 10)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 16),

                  _buildSliderTile(
                    'Actual Necessity / Utility',
                    'How urgently do you need this for daily survival or essential work?',
                    _necessity,
                    (v) => setState(() => _necessity = v),
                  ),
                  const Divider(),

                  _buildSliderTile(
                    'Long-Term Joy / Value',
                    'Will you actively value this item 6 months from now?',
                    _longTermJoy,
                    (v) => setState(() => _longTermJoy = v),
                  ),
                  const Divider(),

                  _buildSliderTile(
                    'Financial Stress / High Cost',
                    'How burdensome is this cost relative to your savings budget?',
                    _financialImpact,
                    (v) => setState(() => _financialImpact = v),
                  ),
                  const Divider(),

                  _buildSliderTile(
                    'Free or Cheaper Alternatives',
                    'Are there easily accessible substitutes or existing things you own?',
                    _alternativeAvailability,
                    (v) => setState(() => _alternativeAvailability = v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Score & Verdict Display
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: verdictColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: verdictColor.withOpacity(0.4), width: 2),
            ),
            child: Column(
              children: [
                const Text(
                  'DECISION RECOMMENDATION INDEX',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${score.toStringAsFixed(0)} / 100',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: verdictColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  verdict,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: verdictColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getVerdictExplanation(score),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTile(
      String title, String subtitle, double value, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              value.toStringAsFixed(0),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        Slider(
          value: value,
          min: 1.0,
          max: 10.0,
          divisions: 9,
          label: value.toStringAsFixed(0),
          onChanged: onChanged,
        ),
      ],
    );
  }

  String _getVerdict(double score) {
    if (score >= 75) return 'GREEN LIGHT: Smart Buy';
    if (score >= 50) return 'AMBER: Pause & Wait 48 Hours';
    return 'RED LIGHT: High Impulse Risk - Skip!';
  }

  Color _getVerdictColor(double score) {
    if (score >= 75) return Colors.green.shade700;
    if (score >= 50) return Colors.orange.shade800;
    return Colors.red.shade700;
  }

  String _getVerdictExplanation(double score) {
    if (score >= 75) {
      return 'This item scores high in necessity and long-term utility with minimal financial strain.';
    } else if (score >= 50) {
      return 'This purchase is border-line. Place it in the Cooling Room for 48 hours to confirm true desire.';
    } else {
      return 'Low necessity score and high financial/substitute risk. You will likely regret buying this later.';
    }
  }
}

// ----------------------------------------------------
// TAB 4: SAVINGS VAULT LOG & STATS
// ----------------------------------------------------
class SavingsVaultView extends StatelessWidget {
  final List<SavedImpulse> history;
  final double hourlyWage;

  const SavingsVaultView({
    super.key,
    required this.history,
    required this.hourlyWage,
  });

  @override
  Widget build(BuildContext context) {
    final resistedList = history.where((item) => item.resisted).toList();
    final double totalMoneySaved =
        resistedList.fold(0.0, (sum, item) => sum + item.cost);
    final double totalHoursSaved =
        resistedList.fold(0.0, (sum, item) => sum + item.hoursWorked);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card
          Card(
            color: Colors.green.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Savings & Time Vault',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Track the cumulative cash and working hours you saved by resisting impulse buys.',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Total Stats Display
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.indigo.shade200),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.monetization_on,
                          color: Colors.indigo, size: 28),
                      const SizedBox(height: 6),
                      FittedBox(
                        child: Text(
                          '\$${totalMoneySaved.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Total Cash Saved',
                        style: TextStyle(fontSize: 11, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.teal.shade200),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.access_time_filled,
                          color: Colors.teal, size: 28),
                      const SizedBox(height: 6),
                      FittedBox(
                        child: Text(
                          '${totalHoursSaved.toStringAsFixed(1)} hrs',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Life Hours Saved',
                        style: TextStyle(fontSize: 11, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Achievement Badge Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mastery Badges',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildBadgeChip(
                        '1st Impulse Resisted',
                        resistedList.isNotEmpty,
                        Icons.star,
                      ),
                      _buildBadgeChip(
                        '\$100 Saved Milestone',
                        totalMoneySaved >= 100,
                        Icons.workspace_premium,
                      ),
                      _buildBadgeChip(
                        '10 Life-Hours Reclaimed',
                        totalHoursSaved >= 10,
                        Icons.timer,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // History List Header
          const Text(
            'Recent Decision Log',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          if (history.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'No items logged yet. Test an item in the Cooling Room!',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: item.resisted
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      child: Icon(
                        item.resisted ? Icons.check : Icons.shopping_cart,
                        color: item.resisted ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${item.hoursWorked.toStringAsFixed(1)} life-hours • ${item.date.day}/${item.date.month}/${item.date.year}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Text(
                      '\$${item.cost.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: item.resisted ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBadgeChip(String label, bool unlocked, IconData icon) {
    return Chip(
      avatar: Icon(
        icon,
        size: 18,
        color: unlocked ? Colors.amber.shade800 : Colors.grey,
      ),
      backgroundColor:
          unlocked ? Colors.amber.shade50 : Colors.grey.shade200,
      side: BorderSide(
        color: unlocked ? Colors.amber.shade300 : Colors.grey.shade400,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: unlocked ? FontWeight.bold : FontWeight.normal,
          color: unlocked ? Colors.black87 : Colors.grey.shade600,
        ),
      ),
    );
  }
}