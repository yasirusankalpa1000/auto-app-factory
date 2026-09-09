import 'package:flutter/material.dart';
import 'dart:async';

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
        scaffoldBackgroundColor: const Color(0xFFAFAFA),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class VaultItem {
  final String id;
  final String name;
  final double price;
  final double hoursRequired;
  final DateTime unlockTime;
  bool isSaved;

  VaultItem({
    required this.id,
    required this.name,
    required this.price,
    required this.hoursRequired,
    required this.unlockTime,
    this.isSaved = false,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  // Global user financial context
  double _hourlyWage = 25.00;
  double _totalMoneySaved = 345.00;
  int _streakDays = 8;

  // Vault state
  final List<VaultItem> _vaultItems = [
    VaultItem(
      id: '1',
      name: 'Wireless Earbuds Upgrade',
      price: 129.99,
      hoursRequired: 5.2,
      unlockTime: DateTime.now().add(const Duration(hours: 18)),
    ),
    VaultItem(
      id: '2',
      name: 'Designer Sneakers',
      price: 185.00,
      hoursRequired: 7.4,
      unlockTime: DateTime.now().add(const Duration(hours: 42)),
    ),
    VaultItem(
      id: '3',
      name: 'Gaming Mechanical Keyboard',
      price: 95.00,
      hoursRequired: 3.8,
      unlockTime: DateTime.now().subtract(const Duration(hours: 2)),
      isSaved: true,
    ),
  ];

  void _addVaultItem(String name, double price, int hoursLock) {
    final double hoursWorked = price / (_hourlyWage > 0 ? _hourlyWage : 1);
    setState(() {
      _vaultItems.add(
        VaultItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          price: price,
          hoursRequired: hoursWorked,
          unlockTime: DateTime.now().add(Duration(hours: hoursLock)),
        ),
      );
    });
  }

  void _markSaved(VaultItem item) {
    setState(() {
      item.isSaved = true;
      _totalMoneySaved += item.price;
      _streakDays += 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Awesome! You saved \$${item.price.toStringAsFixed(2)} and ${item.hoursRequired.toStringAsFixed(1)} hours of your life!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      WorkCalculatorView(
        hourlyWage: _hourlyWage,
        onWageChanged: (newWage) => setState(() => _hourlyWage = newWage),
        onAddToVault: _addVaultItem,
      ),
      VaultView(
        vaultItems: _vaultItems,
        onMarkSaved: _markSaved,
      ),
      const DecisionMatrixView(),
      StatsAndStreakView(
        savedAmount: _totalMoneySaved,
        streakDays: _streakDays,
        hourlyWage: _hourlyWage,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.shield, color: Colors.indigo),
            const SizedBox(width: 8),
            const Text(
              'ImpulseGuard',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '$_streakDays Day Streak',
                  style: TextStyle(
                    color: Colors.amber.shade900,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Cost Tool',
          ),
          NavigationDestination(
            icon: Icon(Icons.lock_clock_outlined),
            selectedIcon: Icon(Icons.lock_clock),
            label: 'Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_outlined),
            selectedIcon: Icon(Icons.psychology),
            label: 'Friction',
          ),
          NavigationDestination(
            icon: Icon(Icons.trending_up),
            selectedIcon: Icon(Icons.trending_up),
            label: 'Impact',
          ),
        ],
      ),
    );
  }
}

// VIEW 1: WORK COST CALCULATOR & QUICK LOCK
class WorkCalculatorView extends StatefulWidget {
  final double hourlyWage;
  final ValueChanged<double> onWageChanged;
  final Function(String name, double price, int hoursLock) onAddToVault;

  const WorkCalculatorView({
    super.key,
    required this.hourlyWage,
    required this.onWageChanged,
    required this.onAddToVault,
  });

  @override
  State<WorkCalculatorView> createState() => _WorkCalculatorViewState();
}

class _WorkCalculatorViewState extends State<WorkCalculatorView> {
  late TextEditingController _wageController;
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  double _calculatedPrice = 0.0;
  int _selectedLockHours = 24;

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

  void _recalculate() {
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final wage = double.tryParse(_wageController.text) ?? 1.0;
    widget.onWageChanged(wage);
    setState(() {
      _calculatedPrice = price;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wage = double.tryParse(_wageController.text) ?? 25.0;
    final hoursWorked = wage > 0 ? _calculatedPrice / wage : 0.0;
    final daysWorked = hoursWorked / 8.0;
    // 5-year opportunity cost if invested at 7% annual return
    final futureValue = _calculatedPrice * 1.4025;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hourly Wage Config Card
          Card(
            elevation: 0,
            color: Colors.indigo.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Hourly Net Income',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.indigo),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.indigo),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _wageController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            labelText: 'Net Hourly Wage (\$)',
                          ),
                          onChanged: (_) => _recalculate(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Item Price Input Section
          const Text(
            'What are you tempted to buy right now?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _itemController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Item Name (e.g., Designer Jacket, Takeout Meal)',
              prefixIcon: Icon(Icons.shopping_bag_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Price (\$)',
              prefixIcon: Icon(Icons.attach_money),
            ),
            onChanged: (_) => _recalculate(),
          ),
          const SizedBox(height: 20),

          // Live Friction Breakdown
          if (_calculatedPrice > 0) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade700, Colors.purple.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'LIFE COST ANALYSIS',
                    style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1.2, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  FittedBox(
                    child: Text(
                      '${hoursWorked.toStringAsFixed(1)} Hours',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'of your life spent working (${daysWorked.toStringAsFixed(1)} workdays)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  const Divider(color: Colors.white70, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Item Cost', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text(
                            '\$${_calculatedPrice.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('5-Yr Invested Value', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text(
                            '\$${futureValue.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Lock in Vault Action Card
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.lock, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          'Apply Impulse Cooldown',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Lock this purchase in your vault before deciding. 84% of user impulses fade within 24 hours!',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAxisAlignment.center,
                      children: [24, 48, 72].map((hours) {
                        final isSelected = _selectedLockHours == hours;
                        return ChoiceChip(
                          label: Text('$hours Hours Lock'),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedLockHours = hours);
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.shield),
                        label: const Text('Lock in Impulse Vault'),
                        onPressed: () {
                          final name = _itemController.text.trim().isEmpty ? 'Impulse Item' : _itemController.text.trim();
                          widget.onAddToVault(name, _calculatedPrice, _selectedLockHours);
                          _itemController.clear();
                          _priceController.clear();
                          setState(() {
                            _calculatedPrice = 0.0;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Item successfully locked in Vault! Take a breath.'),
                              backgroundColor: Colors.indigo,
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ] else ...[
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: const [
                  Icon(Icons.lightbulb_outline, size: 40, color: Colors.indigo),
                  SizedBox(height: 12),
                  Text(
                    'Enter a purchase price above',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'ImpulseGuard will instantly frame the item in terms of hours worked and lost potential investments.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            )
          ]
        ],
      ),
    );
  }
}

// VIEW 2: VAULT & ACTIVE COOLDOWN TIMERS
class VaultView extends StatefulWidget {
  final List<VaultItem> vaultItems;
  final Function(VaultItem) onMarkSaved;

  const VaultView({
    super.key,
    required this.vaultItems,
    required this.onMarkSaved,
  });

  @override
  State<VaultView> createState() => _VaultViewState();
}

class _VaultViewState extends State<VaultView> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Refresh countdowns every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) return 'Unlocked';
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final activeItems = widget.vaultItems.where((i) => !i.isSaved).toList();
    final savedItems = widget.vaultItems.where((i) => i.isSaved).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Impulse Cooldown Vault',
            style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Items here are under mandatory reflection timers.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          if (activeItems.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  Icon(Icons.check_circle_outline, color: Colors.green, size: 44),
                  SizedBox(height: 8),
                  Text(
                    'No Active Impulse Traps!',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Great job! You have no locked purchases cooling down.',
                    style: TextStyle(color: Colors.black87, fontSize: 12),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activeItems.length,
              itemBuilder: (context, index) {
                final item = activeItems[index];
                final remaining = item.unlockTime.difference(DateTime.now());
                final isUnlocked = remaining.isNegative;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              'Requires ${item.hoursRequired.toStringAsFixed(1)} hours of labor',
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Timer Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isUnlocked ? Colors.green.shade50 : Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isUnlocked ? Icons.lock_open : Icons.lock_clock,
                                    size: 18,
                                    color: isUnlocked ? Colors.green : Colors.orange.shade800,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    isUnlocked ? 'Cooldown Complete!' : 'Lock Remaining:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: isUnlocked ? Colors.green : Colors.orange.shade800,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                isUnlocked ? 'Ready' : _formatDuration(remaining),
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isUnlocked ? Colors.green : Colors.orange.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.green,
                                  side: const BorderSide(color: Colors.green),
                                ),
                                icon: const Icon(Icons.savings, size: 18),
                                label: const Text('Saved It!'),
                                onPressed: () => widget.onMarkSaved(item),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (isUnlocked)
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade300,
                                    foregroundColor: Colors.black,
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Purchased after cooldown. Refreshed reflection logged.')),
                                    );
                                  },
                                  child: const Text('Bought It'),
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),

          const SizedBox(height: 16),
          if (savedItems.isNotEmpty) ...[
            const Text(
              'Saved Purchases Vault Log',
              style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: savedItems.length,
              itemBuilder: (context, index) {
                final item = savedItems[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                  title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Saved \$${item.price.toStringAsFixed(2)} (${item.hoursRequired.toStringAsFixed(1)} hrs saved)'),
                  trailing: const Chip(
                    label: Text('Deterred', style: TextStyle(fontSize: 10, color: Colors.green)),
                    backgroundColor: Color(0xFFE8F5E9),
                  ),
                );
              },
            )
          ]
        ],
      ),
    );
  }
}

// VIEW 3: PSYCHOLOGICAL FRICTION & DECISION MATRIX
class DecisionMatrixView extends StatefulWidget {
  const DecisionMatrixView({super.key});

  @override
  State<DecisionMatrixView> createState() => _DecisionMatrixViewState();
}

class _DecisionMatrixViewState extends State<DecisionMatrixView> {
  int _currentStep = 0;
  int _score = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Will this purchase bring you active joy or utility after 30 days?',
      'options': [
        {'text': 'Yes, absolutely essential daily use', 'points': 0},
        {'text': 'Maybe, but likely forgotten in a drawer', 'points': 2},
        {'text': 'Honestly, probably not', 'points': 3},
      ]
    },
    {
      'question': 'Are you buying this because you are stressed, bored, or emotional right now?',
      'options': [
        {'text': 'No, clear logical need', 'points': 0},
        {'text': 'Slightly bored/looking for a reward', 'points': 2},
        {'text': 'Yes, completely emotional response', 'points': 3},
      ]
    },
    {
      'question': 'Could you rent, borrow, or buy a used version for 50% less?',
      'options': [
        {'text': 'No, exclusive / brand new essential', 'points': 0},
        {'text': 'Yes, alternative options exist', 'points': 2},
      ]
    },
    {
      'question': 'How many hours did you have to work to afford this single item?',
      'options': [
        {'text': 'Under 1 hour', 'points': 0},
        {'text': '1 to 5 hours', 'points': 1},
        {'text': 'More than 5 hours of work!', 'points': 3},
      ]
    },
  ];

  void _answerQuestion(int points) {
    setState(() {
      _score += points;
      _currentStep++;
    });
  }

  void _resetQuiz() {
    setState(() {
      _currentStep = 0;
      _score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isComplete = _currentStep >= _questions.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.psychology, color: Colors.purple, size: 28),
              SizedBox(width: 8),
              Text(
                'Impulse Friction Matrix',
                style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Answer 4 micro-questions to calculate your Buyers Regret Risk Score.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          if (!isComplete) ...[
            LinearProgressIndicator(
              value: (_currentStep + 1) / _questions.length,
              backgroundColor: Colors.grey.shade200,
              color: Colors.purple,
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'QUESTION ${_currentStep + 1} OF ${_questions.length}',
                      style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _questions[_currentStep]['question'] as String,
                      style: const TextStyle(fontSize: 16, FontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ...(_questions[_currentStep]['options'] as List<Map<String, dynamic>>).map((opt) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                            alignment: Alignment.centerLeft,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => _answerQuestion(opt['points'] as int),
                          child: Text(
                            opt['text'] as String,
                            style: const TextStyle(color: Colors.black87, fontSize: 14),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            )
          ] else ...[
            // Quiz Result Card
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: _score >= 6 ? Colors.red.shade50 : Colors.green.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _score >= 6 ? Colors.red.shade300 : Colors.green.shade300),
              ),
              child: Column(
                children: [
                  Icon(
                    _score >= 6 ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                    size: 52,
                    color: _score >= 6 ? Colors.red : Colors.green,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _score >= 6 ? 'HIGH REGRET RISK SCORE (${_score}/11)' : 'LOW REGRET RISK (${_score}/11)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: _score >= 6 ? Colors.red.shade900 : Colors.green.shade900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _score >= 6
                        ? 'Warning: This purchase shows heavy signs of emotional impulse. We strongly advise locking this item in the Vault for 48 hours!'
                        : 'This purchase appears well-considered and aligned with your daily routine. Proceed thoughtfully!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Test Another Purchase'),
                    onPressed: _resetQuiz,
                  )
                ],
              ),
            )
          ]
        ],
      ),
    );
  }
}

// VIEW 4: IMPACT DASHBOARD & LONG-TERM METRICS
class StatsAndStreakView extends StatelessWidget {
  final double savedAmount;
  final int streakDays;
  final double hourlyWage;

  const StatsAndStreakView({
    super.key,
    required this.savedAmount,
    required this.streakDays,
    required this.hourlyWage,
  });

  @override
  Widget build(BuildContext context) {
    final hoursSaved = hourlyWage > 0 ? savedAmount / hourlyWage : 0.0;
    // 1 year compound savings estimate at 8%
    final yearlyCompound = savedAmount * 12 * 1.08;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Anti-Impulse Compound Impact',
            style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'The total life hours and wealth saved by delaying decisions.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Main Stats Row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.account_balance_wallet, color: Colors.green),
                      const SizedBox(height: 8),
                      FittedBox(
                        child: Text(
                          '\$${savedAmount.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.green),
                        ),
                      ),
                      const Text('Total Money Saved', style: TextStyle(fontSize: 11, color: Colors.black87)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.hourglass_bottom, color: Colors.indigo),
                      const SizedBox(height: 8),
                      FittedBox(
                        child: Text(
                          '${hoursSaved.toStringAsFixed(1)} hrs',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.indigo),
                        ),
                      ),
                      const Text('Life Hours Reclaimed', style: TextStyle(fontSize: 11, color: Colors.black87)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Future Wealth Projection Card
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.show_chart, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(
                        '1-Year Compound Projection',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'If you continue saving \$${savedAmount.toStringAsFixed(0)}/mo by avoiding daily micro-impulses:',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '\$${yearlyCompound.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Colors.teal),
                  ),
                  const Text(
                    'Potential invested portfolio value in 12 months (8% return).',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Behavioral Tips
          const Text(
            'Daily Mindfulness Rules',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          _buildTipTile(
            Icons.rule,
            'The 72-Hour Rule',
            'For non-essential purchases over \$50, force a 72-hour vault lock. 80% of items feel irrelevant afterward.',
          ),
          _buildTipTile(
            Icons.timer_outlined,
            'Hourly Wage Framing',
            'Never evaluate price in dollars. Evaluate price in hours spent sitting at your workplace desk.',
          ),
        ],
      ),
    );
  }

  Widget _buildTipTile(IconData icon, String title, String subtitle) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade100,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ),
    );
  }
}