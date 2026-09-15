import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const ImpulseGuardApp());
}

class ImpulseGuardApp extends StatelessWidget {
  const ImpulseGuardApp({super.key});

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'ImpulseGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainScreen(),
    );
  }
}

class ImpulseRecord {
  final String id;
  final String title;
  final double cost;
  final String category;
  final DateTime date;
  final bool defeated;

  ImpulseRecord({
    required this.id,
    required this.title,
    required this.cost,
    required this.category,
    required this.date,
    required this.defeated,
  });
}

class SavingsGoal {
  final String title;
  final double targetAmount;
  final IconData icon;

  SavingsGoal({
    required this.title,
    required this.targetAmount,
    required this.icon,
  });
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedNavIndex = 0;

  // Settings & Stats
  double _hourlyWage = 22.50;
  double _totalSaved = 185.00;
  int _cravingsDefeated = 9;
  int _cravingsYielded = 2;

  // Saved Records History
  final List<ImpulseRecord> _history = [
    ImpulseRecord(
      id: '1',
      title: 'Design Sneakers',
      cost: 85.00,
      category: 'Shopping',
      date: DateTime.now().subtract(const Duration(days: 1)),
      defeated: true,
    ),
    ImpulseRecord(
      id: '2',
      title: 'Late Night Fast Food',
      cost: 18.50,
      category: 'Junk Food',
      date: DateTime.now().subtract(const Duration(days: 2)),
      defeated: true,
    ),
    ImpulseRecord(
      id: '3',
      title: 'Gaming Skin Bundle',
      cost: 25.00,
      category: 'Digital Goods',
      date: DateTime.now().subtract(const Duration(days: 3)),
      defeated: true,
    ),
  ];

  // Wishlist Goals
  final List<SavingsGoal> _goals = [
    SavingsGoal(title: 'Weekend Getaway', targetAmount: 400.0, icon: Icons.star),
    SavingsGoal(title: 'Noise Cancelling Headphones', targetAmount: 250.0, icon: Icons.widgets),
    SavingsGoal(title: 'Emergency Buffer', targetAmount: 1000.0, icon: Icons.savings),
  ];

  // Craving Crusher Active Session State
  bool _inActiveSession = false;
  int _sessionSecondsLeft = 180;
  Timer? _sessionTimer;
  String _activeTitle = "";
  double _activeCost = 0.0;
  String _activeCategory = "Shopping";

  // Interactive Mini Focus Game State
  List<int> _gameNumbers = [];
  int _currentNumberToTap = 1;
  int _gameScore = 0;

  @override
  void dispose() {
    _sessionTimer?.cancel();
    super.dispose();
  }

  void _startCravingCrusher(String title, double cost, String category) {
    setState(() {
      _activeTitle = title;
      _activeCost = cost;
      _activeCategory = category;
      _inActiveSession = true;
      _sessionSecondsLeft = 180;
      _gameScore = 0;
      _resetGameNumbers();
    });

    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sessionSecondsLeft > 1) {
        setState(() {
          _sessionSecondsLeft--;
        });
      } else {
        _finishSession(true);
      }
    });
  }

  void _resetGameNumbers() {
    List<int> nums = List.generate(9, (index) => index + 1);
    nums.shuffle();
    setState(() {
      _gameNumbers = nums;
      _currentNumberToTap = 1;
    });
  }

  void _handleGameTap(int number) {
    if (number == _currentNumberToTap) {
      if (_currentNumberToTap == 9) {
        setState(() {
          _gameScore += 100;
        });
        _resetGameNumbers();
      } else {
        setState(() {
          _currentNumberToTap++;
        });
      }
    }
  }

  void _finishSession(bool defeated) {
    _sessionTimer?.cancel();
    setState(() {
      _inActiveSession = false;
      if (defeated) {
        _totalSaved += _activeCost;
        _cravingsDefeated++;
        _history.insert(
          0,
          ImpulseRecord(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: _activeTitle,
            cost: _activeCost,
            category: _activeCategory,
            date: DateTime.now(),
            defeated: true,
          ),
        );
      } else {
        _cravingsYielded++;
        _history.insert(
          0,
          ImpulseRecord(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: _activeTitle,
            cost: _activeCost,
            category: _activeCategory,
            date: DateTime.now(),
            defeated: false,
          ),
        );
      }
    });

    _showResultDialog(defeated);
  }

  void _showResultDialog(bool defeated) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Row(
          children: [
            Icon(
              defeated ? Icons.check_circle : Icons.info,
              color: defeated ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                defeated ? 'Impulse Defeated!' : 'Session Ended',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                softWrap: true,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              defeated
                  ? 'Awesome willpower! You saved \$${_activeCost.toStringAsFixed(2)} and kept your focus intact.'
                  : 'You decided to proceed. Take note of how you felt during this impulse.',
              style: const TextStyle(color: Colors.white70),
              softWrap: true,
            ),
            const SizedBox(height: 12),
            if (defeated)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.amber),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Total Vault Savings: \$${_totalSaved.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Back to Dashboard', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _openNewImpulseModal() {
    final titleController = TextEditingController();
    final costController = TextEditingController();
    String category = 'Shopping';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (bottomContext, setModalState) {
            double parsedCost = double.tryParse(costController.text) ?? 0.0;
            double hoursWork = _hourlyWage > 0 ? parsedCost / _hourlyWage : 0.0;

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(bottomContext).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Log an Impulse / Craving',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.of(bottomContext).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'What are you tempted to buy or eat?',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: costController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (val) {
                        setModalState(() {});
                      },
                      decoration: const InputDecoration(
                        labelText: 'Cost or Price (\$) ',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Category:', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Shopping', 'Junk Food', 'Digital Goods', 'Other'].map((cat) {
                        final isSelected = category == cat;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: Colors.indigo,
                          backgroundColor: const Color(0xFF0F172A),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setModalState(() {
                                category = cat;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    // Life-Cost Reality Check Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.teal.withOpacity(0.4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.schedule, color: Colors.teal, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'REALITY CHECK: Work Time Cost',
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            parsedCost > 0
                                ? 'This requires approximately ${hoursWork.toStringAsFixed(1)} hours of your hard work (at \$${_hourlyWage.toStringAsFixed(2)}/hr).'
                                : 'Enter a price above to see how many hours of work this costs you.',
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                            softWrap: true,
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
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.shield, color: Colors.white),
                        label: const Text(
                          'Start 3-Min Craving Crusher Session',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          final name = titleController.text.trim();
                          final cost = double.tryParse(costController.text) ?? 0.0;
                          if (name.isNotEmpty && cost > 0) {
                            Navigator.of(bottomContext).pop();
                            _startCravingCrusher(name, cost, category);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.shield, color: Colors.indigoAccent),
            SizedBox(width: 8),
            Text(
              'ImpulseGuard',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white70),
            onPressed: () => _showWageDialog(),
          )
        ],
      ),
      body: SafeArea(
        child: _inActiveSession
            ? _buildActiveSessionView()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_selectedNavIndex == 0) _buildDashboardTab(),
                      if (_selectedNavIndex == 1) _buildVaultTab(),
                      if (_selectedNavIndex == 2) _buildHistoryTab(),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.indigoAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (!_inActiveSession) {
            setState(() {
              _selectedNavIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: 'Shield Hub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Savings Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Impulse Log',
          ),
        ],
      ),
      floatingActionButton: !_inActiveSession
          ? FloatingActionButton.extended(
              onPressed: _openNewImpulseModal,
              backgroundColor: Colors.indigo,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Crush Impulse',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }

  // DASHBOARD TAB
  Widget _buildDashboardTab() {
    double totalAttempts = (_cravingsDefeated + _cravingsYielded).toDouble();
    double winRate = totalAttempts > 0 ? (_cravingsDefeated / totalAttempts) * 100 : 100.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Trigger Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF312E81), Color(0xFF1E1B4B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.indigo.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'IMPULSE SHIELD ACTIVE',
                    style: TextStyle(
                      color: Colors.indigoAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(radius: 4, backgroundColor: Colors.green),
                        SizedBox(width: 6),
                        Text('Ready', style: TextStyle(color: Colors.green, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Feeling an urge to spend or snack?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                softWrap: true,
              ),
              const SizedBox(height: 6),
              const Text(
                'Delay for just 3 minutes. Re-route your focus and save your hard-earned cash.',
                style: TextStyle(color: Colors.white70, fontSize: 13),
                softWrap: true,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.flash_on, color: Colors.white),
                  label: const Text(
                    'I Feel an Impulse Now!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  onPressed: _openNewImpulseModal,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Quick Stats Row
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Money Saved', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '\$${_totalSaved.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Shield Win Rate', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${winRate.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.indigoAccent,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        const Text(
          'Recent Defeated Impulses',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        _history.isEmpty
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'No impulses logged yet. Tap "Crush Impulse" to begin!',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
            : Column(
                children: _history.take(4).map((rec) => _buildImpulseCard(rec)).toList(),
              ),
      ],
    );
  }

  // SAVINGS VAULT TAB
  Widget _buildVaultTab() {
    double totalWorkHoursSaved = _hourlyWage > 0 ? _totalSaved / _hourlyWage : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Micro-Savings Vault',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),
        const Text(
          'Every crushed impulse turns into real protected money.',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 16),

        // Total Saved Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.indigo.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              const Icon(Icons.savings, color: Colors.amber, size: 40),
              const SizedBox(height: 8),
              Text(
                '\$${_totalSaved.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Equivalent to ~${totalWorkHoursSaved.toStringAsFixed(1)} hours of your hard work saved!',
                style: const TextStyle(color: Colors.tealAccent, fontSize: 13),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Dream Goals Funded by Willpower',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 12),

        Column(
          children: _goals.map((goal) {
            double progress = (_totalSaved / goal.targetAmount).clamp(0.0, 1.0);
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(goal.icon, color: Colors.indigoAccent),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          goal.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                        ),
                      ),
                      Text(
                        '\$${_totalSaved.toStringAsFixed(0)} / \$${goal.targetAmount.toStringAsFixed(0)}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFF0F172A),
                    color: progress >= 1.0 ? Colors.green : Colors.indigoAccent,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}% Funded',
                    style: TextStyle(
                      color: progress >= 1.0 ? Colors.green : Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // HISTORY TAB
  Widget _buildHistoryTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Impulse History & Stats',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),
        const Text(
          'Review your battles with impulse spending and cravings.',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 16),

        _history.isEmpty
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'No history logged yet.',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
            : Column(
                children: _history.map((rec) => _buildImpulseCard(rec)).toList(),
              ),
      ],
    );
  }

  // ACTIVE 3-MINUTE CRAVING CRUSHER SCREEN
  Widget _buildActiveSessionView() {
    int minutes = _sessionSecondsLeft ~/ 60;
    int seconds = _sessionSecondsLeft % 60;
    String timerString = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    double progress = 1.0 - (_sessionSecondsLeft / 180.0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Header Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.psychology, color: Colors.indigoAccent, size: 18),
                SizedBox(width: 8),
                Text(
                  'CRAVING DISSOLUTION IN PROGRESS',
                  style: TextStyle(
                    color: Colors.indigoAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text(
            _activeTitle,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          const SizedBox(height: 4),
          Text(
            'Target Savings: \$${_activeCost.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),

          // Timer Visual Circle
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 10,
                  backgroundColor: const Color(0xFF1E293B),
                  color: Colors.indigoAccent,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timerString,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Hold On...',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Interactive Focus Re-Router Mini Game Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text(
                  'BRAIN RE-ROUTER: FOCUS TAPPER',
                  style: TextStyle(
                    color: Colors.tealAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap numbers in order: 1 to 9 (Score: $_gameScore)',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.6,
                  ),
                  itemCount: _gameNumbers.length,
                  itemBuilder: (context, index) {
                    int num = _gameNumbers[index];
                    bool isNext = num == _currentNumberToTap;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isNext ? Colors.indigoAccent : const Color(0xFF0F172A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _handleGameTap(num),
                      child: Text(
                        '$num',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isNext ? Colors.white : Colors.white70,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Session Decision Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => _finishSession(false),
                  child: const Text(
                    'I Gave In',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => _finishSession(true),
                  child: const Text(
                    'Craving Defeated!',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImpulseCard(ImpulseRecord rec) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: rec.defeated ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
            child: Icon(
              rec.defeated ? Icons.check : Icons.close,
              color: rec.defeated ? Colors.green : Colors.redAccent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rec.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                ),
                Text(
                  '${rec.category} • ${rec.date.day}/${rec.date.month}/${rec.date.year}',
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            rec.defeated ? '+\$${rec.cost.toStringAsFixed(2)} Saved' : '\$${rec.cost.toStringAsFixed(2)}',
            style: TextStyle(
              color: rec.defeated ? Colors.green : Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  void _showWageDialog() {
    final wageController = TextEditingController(text: _hourlyWage.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Set Hourly Wage', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This calculation is used to convert impulse prices into exact work time required.',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: wageController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Hourly Wage (\$)',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            onPressed: () {
              double? newWage = double.tryParse(wageController.text);
              if (newWage != null && newWage > 0) {
                setState(() {
                  _hourlyWage = newWage;
                });
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}