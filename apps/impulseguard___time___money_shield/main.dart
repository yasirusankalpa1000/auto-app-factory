import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const ImpulseGuardApp());
}

class ImpulseGuardApp extends StatelessWidget {
  const ImpulseGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImpulseGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class DecisionLog {
  final String id;
  final String title;
  final double amount;
  final double laborHours;
  final bool resisted;
  final DateTime date;

  DecisionLog({
    required this.id,
    required this.title,
    required this.amount,
    required this.laborHours,
    required this.resisted,
    required this.date,
  });
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  double _hourlyWage = 20.0;

  // Active Item being evaluated
  String _activeItemName = "Sample Purchase";
  double _activeItemPrice = 45.0;

  final List<DecisionLog> _logs = [
    DecisionLog(
      id: '1',
      title: 'Design Sneakers',
      amount: 85.0,
      laborHours: 4.25,
      resisted: true,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    DecisionLog(
      id: '2',
      title: 'Late Night Delivery Food',
      amount: 24.50,
      laborHours: 1.22,
      resisted: true,
      date: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  void _updateActiveEvaluation(String name, double price) {
    setState(() {
      _activeItemName = name.isEmpty ? "Impulse Purchase" : name;
      _activeItemPrice = price <= 0 ? 10.0 : price;
    });
  }

  void _addDecisionLog(bool resisted) {
    final double hours = _hourlyWage > 0 ? _activeItemPrice / _hourlyWage : 0;
    final newLog = DecisionLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _activeItemName,
      amount: _activeItemPrice,
      laborHours: hours,
      resisted: resisted,
      date: DateTime.now(),
    );

    setState(() {
      _logs.insert(0, newLog);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      TimeValueShieldPage(
        hourlyWage: _hourlyWage,
        onWageChanged: (newWage) {
          setState(() {
            _hourlyWage = newWage;
          });
        },
        onStartCooling: (name, price) {
          _updateActiveEvaluation(name, price);
          setState(() {
            _currentIndex = 1; // Switch to Cooling Off Chamber
          });
        },
      ),
      CoolingChamberPage(
        itemName: _activeItemName,
        itemPrice: _activeItemPrice,
        hourlyWage: _hourlyWage,
        onLogDecision: (resisted) {
          _addDecisionLog(resisted);
          setState(() {
            _currentIndex = 2; // Switch to Ledger
          });
        },
      ),
      SavingsLedgerPage(
        logs: _logs,
        hourlyWage: _hourlyWage,
        onClearLogs: () {
          setState(() {
            _logs.clear();
          });
        },
      ),
      const MicroDecisionMatrixPage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate),
            selectedIcon: Icon(Icons.calculate),
            label: 'Converter',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer),
            selectedIcon: Icon(Icons.timer_sharp),
            label: 'Cooling Room',
          ),
          NavigationDestination(
            icon: Icon(Icons.savings),
            selectedIcon: Icon(Icons.savings),
            label: 'Ledger',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology),
            selectedIcon: Icon(Icons.psychology),
            label: 'Decision Helper',
          ),
        ],
      ),
    );
  }
}

// TAB 1: TIME VALUE CONVERTER
class TimeValueShieldPage extends StatefulWidget {
  final double hourlyWage;
  final ValueChanged<double> onWageChanged;
  final Function(String name, double price) onStartCooling;

  const TimeValueShieldPage({
    super.key,
    required this.hourlyWage,
    required this.onWageChanged,
    required this.onStartCooling,
  });

  @override
  State<TimeValueShieldPage> createState() => _TimeValueShieldPageState();
}

class _TimeValueShieldPageState extends State<TimeValueShieldPage> {
  late TextEditingController _wageController;
  final TextEditingController _itemController = TextEditingController(text: 'Wireless Earbuds');
  final TextEditingController _priceController = TextEditingController(text: '50.00');

  @override
  void initState() {
    super.initState();
    _wageController = TextEditingController(text: widget.hourlyWage.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _wageController.dispose();
    _itemController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double wage = double.tryParse(_wageController.text) ?? widget.hourlyWage;
    final double price = double.tryParse(_priceController.text) ?? 0.0;
    final double hoursNeeded = wage > 0 ? price / wage : 0.0;

    // Investment potential (10 years at 7% compound annual return)
    final double investmentValue = price * pow(1.07, 10);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Time-Value Shield', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('How ImpulseGuard Works'),
                  content: const Text(
                    'Every dollar spent represents a fraction of your irreplaceable life and work labor.\n\n'
                    'By converting costs directly into your actual working hours and initiating a mandatory 3-minute cooling period, ImpulseGuard rewires your brain to bypass impulse buys.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Got It'),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hourly Wage Card
              Card(
                elevation: 2,
                color: Colors.indigo.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.indigo, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Hourly Labor Value',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.indigo),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${wage.toStringAsFixed(2)} / hour net wage',
                              style: const TextStyle(color: Colors.black87, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.indigo),
                        onPressed: () {
                          _showWageDialog(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Impulse Item Inputs
              const Text(
                'Evaluate Impulse Purchase',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _itemController,
                decoration: const InputDecoration(
                  labelText: 'What are you tempted to buy?',
                  prefixIcon: Icon(Icons.shopping_bag),
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Price (\$) = USD',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 20),

              // Live Real Cost Breakdown
              Card(
                color: Colors.indigo.shade900,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'REAL LIFE TIME COST',
                        style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 10),
                      FittedBox(
                        child: Text(
                          '${hoursNeeded.toStringAsFixed(1)} Work Hours',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'To buy this \$${price.toStringAsFixed(2)} item, you must work ${hoursNeeded.toStringAsFixed(1)} hours of your life.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      const Divider(color: Colors.white70, height: 24),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          Chip(
                            avatar: const Icon(Icons.trending_up, size: 16, color: Colors.green),
                            label: Text(
                              'Invested Value in 10 yrs: \$${investmentValue.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.shield, size: 24),
                label: const Text(
                  'Enter 3-Min Cooling Chamber',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  final String name = _itemController.text.trim();
                  final double p = double.tryParse(_priceController.text) ?? 0.0;
                  widget.onStartCooling(name, p);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Update Hourly Wage'),
          content: TextField(
            controller: _wageController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Net Hourly Wage (\$)',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final double w = double.tryParse(_wageController.text) ?? widget.hourlyWage;
                widget.onWageChanged(w);
                Navigator.pop(ctx);
              },
              child: const Text('Save'),
            )
          ],
        );
      },
    );
  }
}

// TAB 2: COOLING CHAMBER (Interactive 3-min focus room)
class CoolingChamberPage extends StatefulWidget {
  final String itemName;
  final double itemPrice;
  final double hourlyWage;
  final Function(bool resisted) onLogDecision;

  const CoolingChamberPage({
    super.key,
    required this.itemName,
    required this.itemPrice,
    required this.hourlyWage,
    required this.onLogDecision,
  });

  @override
  State<CoolingChamberPage> createState() => _CoolingChamberPageState();
}

class _CoolingChamberPageState extends State<CoolingChamberPage> {
  Timer? _timer;
  int _secondsRemaining = 180; // 3 Minutes default
  bool _isTimerActive = false;
  int _breatheCount = 0;

  // Reflection Checkbox States
  bool _q1Checked = false;
  bool _q2Checked = false;
  bool _q3Checked = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 180;
      _isTimerActive = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isTimerActive = false;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final int mins = seconds ~/ 60;
    final int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final double hoursCost = widget.hourlyWage > 0 ? widget.itemPrice / widget.hourlyWage : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cooling-Off Chamber', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Target Item Header Card
              Card(
                color: Colors.blueGrey.shade900,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'EVALUATING IMPULSE',
                        style: TextStyle(color: Colors.teal.shade200, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.itemName.isEmpty ? "Unspecified Impulse Item" : widget.itemName,
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${widget.itemPrice.toStringAsFixed(2)} = ${hoursCost.toStringAsFixed(1)} Work Hours',
                        style: const TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Countdown Timer Circle
              Center(
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.indigo.shade50,
                    border: Border.all(color: Colors.indigo, width: 6),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.hourglass_bottom, color: Colors.indigo, size: 28),
                      const SizedBox(height: 4),
                      Text(
                        _formatTime(_secondsRemaining),
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                      Text(
                        _isTimerActive ? 'Cooling Down...' : 'Cooling Complete!',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _isTimerActive ? Colors.indigo : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Interactive Mindful Breathing Button
              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      IconButton(
                        iconSize: 36,
                        icon: const Icon(Icons.self_improvement, color: Colors.indigo),
                        onPressed: () {
                          setState(() {
                            _breatheCount++;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Mindful Impulse Tap',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Tap repeatedly when feeling urgency: $_breatheCount breaths taken',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Friction Reflection Checklist',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),

              CheckboxListTile(
                value: _q1Checked,
                title: const Text('Will I still care or use this 30 days from now?', style: TextStyle(fontSize: 13)),
                onChanged: (val) => setState(() => _q1Checked = val ?? false),
              ),
              CheckboxListTile(
                value: _q2Checked,
                title: Text('Am I willing to work ${hoursCost.toStringAsFixed(1)} extra hours specifically for this?', style: const TextStyle(fontSize: 13)),
                onChanged: (val) => setState(() => _q2Checked = val ?? false),
              ),
              CheckboxListTile(
                value: _q3Checked,
                title: const Text('Can I wait 24 hours before making the final decision?', style: TextStyle(fontSize: 13)),
                onChanged: (val) => setState(() => _q3Checked = val ?? false),
              ),

              const SizedBox(height: 20),

              // Final Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.check_circle),
                      label: const FittedBox(
                        child: Text('I Resisted! Save Money', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      onPressed: () {
                        widget.onLogDecision(true);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.cancel),
                      label: const FittedBox(
                        child: Text('Bought It Anyway', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      onPressed: () {
                        widget.onLogDecision(false);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// TAB 3: RESISTANCE LEDGER & STATS
class SavingsLedgerPage extends StatelessWidget {
  final List<DecisionLog> logs;
  final double hourlyWage;
  final VoidCallback onClearLogs;

  const SavingsLedgerPage({
    super.key,
    required this.logs,
    required this.hourlyWage,
    required this.onClearLogs,
  });

  @override
  Widget build(BuildContext context) {
    final List<DecisionLog> resistedLogs = logs.where((l) => l.resisted).toList();
    final double totalMoneySaved = resistedLogs.fold(0.0, (sum, item) => sum + item.amount);
    final double totalHoursSaved = resistedLogs.fold(0.0, (sum, item) => sum + item.laborHours);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resistance Ledger', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: logs.isEmpty ? null : onClearLogs,
          )
        ],
      ),
      body: SafeArea(
        child: logs.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.shield_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No Decision Logs Yet',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Evaluate an impulse buy in the Converter tab to start saving money and work hours!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Summary Banner
                    Card(
                      color: Colors.teal.shade800,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'TOTAL MONEY RECLAIMED',
                                    style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  FittedBox(
                                    child: Text(
                                      '\$${totalMoneySaved.toStringAsFixed(2)}',
                                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(width: 1, height: 40, color: Colors.white70),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'LIFE HOURS SAVED',
                                    style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  FittedBox(
                                    child: Text(
                                      '${totalHoursSaved.toStringAsFixed(1)} hrs',
                                      style: const TextStyle(color: Colors.amber, fontSize: 28, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Decision History',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final log = logs[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: log.resisted ? Colors.green.shade100 : Colors.red.shade100,
                              child: Icon(
                                log.resisted ? Icons.check : Icons.close,
                                color: log.resisted ? Colors.green : Colors.red,
                              ),
                            ),
                            title: Text(
                              log.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              '${log.date.day}/${log.date.month}/${log.date.year} • ${log.laborHours.toStringAsFixed(1)} hrs labor',
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${log.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: log.resisted ? Colors.green : Colors.red,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  log.resisted ? 'Resisted' : 'Spent',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: log.resisted ? Colors.green : Colors.red,
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
              ),
      ),
    );
  }
}

// TAB 4: MICRO-DECISION EVALUATOR MATRIX
class MicroDecisionMatrixPage extends StatefulWidget {
  const MicroDecisionMatrixPage({super.key});

  @override
  State<MicroDecisionMatrixPage> createState() => _MicroDecisionMatrixPageState();
}

class _MicroDecisionMatrixPageState extends State<MicroDecisionMatrixPage> {
  final TextEditingController _optionAController = TextEditingController(text: 'Cook Dinner at Home');
  final TextEditingController _optionBController = TextEditingController(text: 'Order Takeout Fast Food');

  double _urgencyScoreA = 3;
  double _costScoreA = 1;

  double _urgencyScoreB = 5;
  double _costScoreB = 4;

  String? _recommendation;

  void _calculateBestOption() {
    // Calculated score = Urgency + Cost Friction
    final double totalCostA = _costScoreA * 2.0;
    final double totalCostB = _costScoreB * 2.0;

    final double finalScoreA = (5 - totalCostA) + (5 - _urgencyScoreA);
    final double finalScoreB = (5 - totalCostB) + (5 - _urgencyScoreB);

    setState(() {
      if (finalScoreA >= finalScoreB) {
        _recommendation = 'Recommended: Option A ("${_optionAController.text}") offers higher long-term value and lower financial friction.';
      } else {
        _recommendation = 'Recommended: Option B ("${_optionBController.text}") carries higher micro-cost, proceed with caution!';
      }
    });
  }

  @override
  void dispose() {
    _optionAController.dispose();
    _optionBController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Micro-Decision Matrix', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Stuck on a micro-decision right now?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Compare two options side-by-side to eliminate brain fatigue and prevent impulsive shortcuts.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              const SizedBox(height: 16),

              // Option A Card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('OPTION A', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _optionAController,
                        decoration: const InputDecoration(
                          labelText: 'Action / Option Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('Financial/Energy Cost: ${_costScoreA.toInt()}/5', style: const TextStyle(fontSize: 12)),
                      Slider(
                        value: _costScoreA,
                        min: 1,
                        max: 5,
                        divisions: 4,
                        onChanged: (val) => setState(() => _costScoreA = val),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Option B Card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('OPTION B', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _optionBController,
                        decoration: const InputDecoration(
                          labelText: 'Alternative Option Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('Financial/Energy Cost: ${_costScoreB.toInt()}/5', style: const TextStyle(fontSize: 12)),
                      Slider(
                        value: _costScoreB,
                        min: 1,
                        max: 5,
                        divisions: 4,
                        activeColor: Colors.deepOrange,
                        onChanged: (val) => setState(() => _costScoreB = val),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.analytics),
                label: const Text('Evaluate Rational Choice', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: _calculateBestOption,
              ),

              if (_recommendation != null) ...[
                const SizedBox(height: 16),
                Card(
                  color: Colors.amber.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.black87),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _recommendation!,
                            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}