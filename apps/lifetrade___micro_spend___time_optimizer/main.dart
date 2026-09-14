import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const LifeTradeApp());
}

class LifeTradeApp extends StatelessWidget {
  const LifeTradeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeTrade',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
      ),
      home: const MainTabScreen(),
    );
  }
}

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;

  // Shared state values
  double _hourlyWage = 25.0;
  final List<Map<String, dynamic>> _savedWins = [
    {
      'title': 'Skipped Delivery Fee',
      'amount': 8.50,
      'timeSaved': '20 mins',
      'date': 'Today'
    },
    {
      'title': 'Made Coffee at Home',
      'amount': 5.25,
      'timeSaved': '15 mins',
      'date': 'Yesterday'
    },
  ];

  void _addWin(String title, double amount) {
    setState(() {
      _savedWins.insert(0, {
        'title': title,
        'amount': amount,
        'timeSaved': '15 mins',
        'date': 'Just now',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      TradeoffSimulatorScreen(
        hourlyWage: _hourlyWage,
        onWageChanged: (newWage) {
          setState(() {
            _hourlyWage = newWage;
          });
        },
        onSaveImpulseSaved: _addWin,
      ),
      ImpulseDefuserScreen(onDefused: _addWin),
      MicroLeakAuditScreen(hourlyWage: _hourlyWage),
      MicroWinsLogScreen(wins: _savedWins, hourlyWage: _hourlyWage),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Tradeoff',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer),
            label: 'Impulse Defuser',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart),
            label: 'Micro-Leaks',
          ),
          NavigationDestination(
            icon: Icon(Icons.star),
            label: 'Saved Wins',
          ),
        ],
      ),
    );
  }
}

// ------------------- TAB 1: TRADEOFF SIMULATOR -------------------
class TradeoffSimulatorScreen extends StatefulWidget {
  final double hourlyWage;
  final ValueChanged<double> onWageChanged;
  final Function(String, double) onSaveImpulseSaved;

  const TradeoffSimulatorScreen({
    super.key,
    required this.hourlyWage,
    required this.onWageChanged,
    required this.onSaveImpulseSaved,
  });

  @override
  State<TradeoffSimulatorScreen> createState() =>
      _TradeoffSimulatorScreenState();
}

class _TradeoffSimulatorScreenState extends State<TradeoffSimulatorScreen> {
  final TextEditingController _itemController =
      TextEditingController(text: 'Takeout Dinner');
  final TextEditingController _priceController =
      TextEditingController(text: '35.00');

  double _itemPrice = 35.00;

  @override
  void dispose() {
    _itemController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _recalculate() {
    setState(() {
      _itemPrice = double.tryParse(_priceController.text) ?? 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double hoursNeeded =
        widget.hourlyWage > 0 ? _itemPrice / widget.hourlyWage : 0.0;
    // 10 year potential compounding at 7% return (annualized growth factor ~1.967)
    final double tenYearCost = _itemPrice * 1.967;

    return Scaffold(
      appBar: AppBar(
        title: const Text('LifeTrade Simulator'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.teal.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Your Hourly Take-Home Pay:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '\$${widget.hourlyWage.toStringAsFixed(2)}/hr',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: widget.hourlyWage.clamp(5.0, 200.0),
                        min: 5.0,
                        max: 200.0,
                        divisions: 39,
                        activeColor: Colors.teal,
                        label: '\$${widget.hourlyWage.toStringAsFixed(0)}',
                        onChanged: (val) {
                          widget.onWageChanged(val);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Evaluate Micro-Purchase',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _itemController,
                decoration: const InputDecoration(
                  labelText: 'Item Name or Micro-Habit',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Price (\$) Screened',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monetization_on),
                ),
                onChanged: (_) => _recalculate(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Real-Life Tradeoff Impact',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    _buildMetricRow(
                      icon: Icons.schedule,
                      color: Colors.amber.shade800,
                      title: 'Life Working Hours Required',
                      value: '${hoursNeeded.toStringAsFixed(1)} Hours',
                      subtitle: 'Work time needed just to afford this',
                    ),
                    const Divider(height: 24),
                    _buildMetricRow(
                      icon: Icons.trending_up,
                      color: Colors.indigo,
                      title: '10-Year Opportunity Cost',
                      value: '\$${tenYearCost.toStringAsFixed(2)}',
                      subtitle: 'If invested at 7% interest instead',
                    ),
                    const Divider(height: 24),
                    _buildMetricRow(
                      icon: Icons.battery_charging_full,
                      color: Colors.teal,
                      title: 'Energy Tradeoff Equivalent',
                      value:
                          '~${(hoursNeeded * 1.2).toStringAsFixed(1)} Focus Energy Points',
                      subtitle: 'Based on average daily mental strain',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.check_circle),
                  label: const Text(
                    'I Resisted! Save to My Wins',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    final title = _itemController.text.isEmpty
                        ? 'Micro Item'
                        : _itemController.text;
                    widget.onSaveImpulseSaved(title, _itemPrice);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Awesome! Saved \$${_itemPrice.toStringAsFixed(2)} to your wins!'),
                        backgroundColor: Colors.teal,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricRow({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
                softWrap: true,
              ),
            ],
          ),
        )
      ],
    );
  }
}

// ------------------- TAB 2: IMPULSE DEFUSER COOLDOWN ZONE -------------------
class ImpulseDefuserScreen extends StatefulWidget {
  final Function(String, double) onDefused;

  const ImpulseDefuserScreen({super.key, required this.onDefused});

  @override
  State<ImpulseDefuserScreen> createState() => _ImpulseDefuserScreenState();
}

class _ImpulseDefuserScreenState extends State<ImpulseDefuserScreen> {
  static const int _totalSeconds = 60;
  int _secondsRemaining = _totalSeconds;
  Timer? _timer;
  bool _isActive = false;
  double _savedAmount = 15.00;

  final List<String> _prompts = [
    'Take a deep breath. Why do you want this right now?',
    'Will this item matter to you in 30 days?',
    'Visualize what happens if you close this tab and walk away.',
    'Are you buying this out of boredom, stress, or genuine utility?',
    'Great job pausing! Impulses peak and fade in 60 seconds.',
    'You are in full control of your attention and money!',
  ];

  int _promptIndex = 0;

  void _startTimer() {
    if (_isActive) return;
    setState(() {
      _isActive = true;
      _secondsRemaining = _totalSeconds;
      _promptIndex = 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
          if (_secondsRemaining % 10 == 0 && _promptIndex < _prompts.length - 1) {
            _promptIndex++;
          }
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isActive = false;
        });
      }
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isActive = false;
      _secondsRemaining = _totalSeconds;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (_totalSeconds - _secondsRemaining) / _totalSeconds;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Impulse Defuser Cooldown'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                color: Colors.indigo.shade50,
                child: const Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      Icon(Icons.psychology, color: Colors.indigo),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Feeling an urge to buy or indulge? Start the 60-second cooldown timer before making a decision.',
                          style: TextStyle(fontSize: 13),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      backgroundColor: Colors.indigo.shade100,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.indigo),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_secondsRemaining',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      const Text(
                        'SECONDS',
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  key: ValueKey<int>(_promptIndex),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.indigo.shade200),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black87,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Text(
                    _prompts[_promptIndex],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_isActive && _secondsRemaining == _totalSeconds)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start 60s Cooldown'),
                      onPressed: _startTimer,
                    ),
                  if (_isActive)
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      onPressed: _resetTimer,
                    ),
                ],
              ),
              const SizedBox(height: 30),
              if (_secondsRemaining == 0) ...[
                Card(
                  color: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Cooldown Complete! Did you successfully defeat the impulse?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.check),
                              label: const Text('Yes! Saved Money'),
                              onPressed: () {
                                widget.onDefused(
                                    'Defused Impulse Purchase', _savedAmount);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Awesome victory logged!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                _resetTimer();
                              },
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
      ),
    );
  }
}

// ------------------- TAB 3: MICRO-LEAK AUDIT -------------------
class MicroLeakAuditScreen extends StatefulWidget {
  final double hourlyWage;

  const MicroLeakAuditScreen({super.key, required this.hourlyWage});

  @override
  State<MicroLeakAuditScreen> createState() => _MicroLeakAuditScreenState();
}

class _MicroLeakAuditScreenState extends State<MicroLeakAuditScreen> {
  final List<Map<String, dynamic>> _leaks = [
    {
      'title': 'Daily Specialty Coffee',
      'costPerOccurence': 5.50,
      'timesPerWeek': 5,
      'enabled': true,
    },
    {
      'title': 'Food Delivery Fees',
      'costPerOccurence': 7.00,
      'timesPerWeek': 3,
      'enabled': true,
    },
    {
      'title': 'Unused Streaming / Apps',
      'costPerOccurence': 14.99,
      'timesPerWeek': 0.25, // ~\$15/mo
      'enabled': true,
    },
    {
      'title': 'Impulse Snack/Convenience',
      'costPerOccurence': 4.00,
      'timesPerWeek': 4,
      'enabled': false,
    },
  ];

  void _addNewLeak(String title, double cost, double perWeek) {
    setState(() {
      _leaks.add({
        'title': title,
        'costPerOccurence': cost,
        'timesPerWeek': perWeek,
        'enabled': true,
      });
    });
  }

  void _showAddLeakDialog() {
    final nameCtrl = TextEditingController();
    final costCtrl = TextEditingController();
    final freqCtrl = TextEditingController(text: '3');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Custom Micro-Leak'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Name (e.g. Rideshare)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: costCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cost Per Time (\$) ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: freqCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Times Per Week',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final cost = double.tryParse(costCtrl.text) ?? 0.0;
              final freq = double.tryParse(freqCtrl.text) ?? 1.0;
              if (nameCtrl.text.isNotEmpty && cost > 0) {
                _addNewLeak(nameCtrl.text, cost, freq);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalMonthlyCost = 0;
    for (var item in _leaks) {
      if (item['enabled'] == true) {
        final double weekly =
            (item['costPerOccurence'] as double) * (item['timesPerWeek'] as double);
        totalMonthlyCost += weekly * 4.33; // average weeks in month
      }
    }

    final double yearlyCost = totalMonthlyCost * 12;
    final double hoursWorkedMonthly = widget.hourlyWage > 0
        ? totalMonthlyCost / widget.hourlyWage
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Micro-Leak Audit'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.blueGrey.shade900,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Total Monthly Micro-Drains',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '\$${totalMonthlyCost.toStringAsFixed(2)} / mo',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                const Text(
                                  'Yearly Total',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 11),
                                ),
                                Text(
                                  '\$${yearlyCost.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                const Text(
                                  'Work Time Cost',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 11),
                                ),
                                Text(
                                  '${hoursWorkedMonthly.toStringAsFixed(1)} hrs/mo',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Active Micro-Leaks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.teal),
                    onPressed: _showAddLeakDialog,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _leaks.length,
                itemBuilder: (context, index) {
                  final leak = _leaks[index];
                  final double monthlyVal =
                      (leak['costPerOccurence'] as double) *
                          (leak['timesPerWeek'] as double) *
                          4.33;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: CheckboxListTile(
                      activeColor: Colors.teal,
                      title: Text(
                        leak['title'],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '\$${(leak['costPerOccurence'] as double).toStringAsFixed(2)} × ${leak['timesPerWeek']} times/wk = \$${monthlyVal.toStringAsFixed(2)}/mo',
                        style: const TextStyle(fontSize: 12),
                      ),
                      value: leak['enabled'],
                      onChanged: (bool? val) {
                        setState(() {
                          leak['enabled'] = val ?? false;
                        });
                      },
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

// ------------------- TAB 4: SAVED WINS LOG -------------------
class MicroWinsLogScreen extends StatelessWidget {
  final List<Map<String, dynamic>> wins;
  final double hourlyWage;

  const MicroWinsLogScreen({
    super.key,
    required this.wins,
    required this.hourlyWage,
  });

  @override
  Widget build(BuildContext context) {
    double totalSaved = 0.0;
    for (var win in wins) {
      totalSaved += (win['amount'] as double? ?? 0.0);
    }

    final double totalHoursSaved =
        hourlyWage > 0 ? totalSaved / hourlyWage : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Wins & Victories'),
        backgroundColor: Colors.amber.shade800,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.amber,
                        child: Icon(Icons.star, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Money Defended',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black87),
                            ),
                            Text(
                              '\$${totalSaved.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade900,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Reclaimed ~${totalHoursSaved.toStringAsFixed(1)} hours of work life!',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.teal),
                              softWrap: true,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Recent Victories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              wins.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text(
                          'No wins logged yet! Evaluate or defuse micro-purchases to log victories here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: wins.length,
                      itemBuilder: (context, index) {
                        final item = wins[index];
                        final double amt = item['amount'] as double? ?? 0.0;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.teal,
                              child: Icon(Icons.shield, color: Colors.white),
                            ),
                            title: Text(
                              item['title'] ?? 'Micro Item',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('Date: ${item['date']}'),
                            trailing: Text(
                              '+\$${amt.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
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