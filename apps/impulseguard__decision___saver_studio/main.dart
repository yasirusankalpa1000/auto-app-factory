import 'dart:async';
import 'package:flutter/material.dart';

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
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      home: const MainHomeScreen(),
    );
  }
}

class DefusedItem {
  final String id;
  final String title;
  final double price;
  final double hoursSaved;
  final String category;
  final DateTime date;

  DefusedItem({
    required this.id,
    required this.title,
    required this.price,
    required this.hoursSaved,
    required this.category,
    required this.date,
  });
}

class SavingsGoal {
  final String id;
  final String title;
  final double targetAmount;
  final String iconName;

  SavingsGoal({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.iconName,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  double _hourlyWage = 25.0;

  final List<DefusedItem> _defusedItems = [
    DefusedItem(
      id: '1',
      title: 'Late Night Fast Food Delivery',
      price: 34.50,
      hoursSaved: 1.38,
      category: 'Food & Drink',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    DefusedItem(
      id: '2',
      title: 'Trending Gadget Case',
      price: 49.99,
      hoursSaved: 2.00,
      category: 'Shopping',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  final List<SavingsGoal> _goals = [
    SavingsGoal(id: 'g1', title: 'Weekend Vacation', targetAmount: 600.0, iconName: 'flight'),
    SavingsGoal(id: 'g2', title: 'Emergency Fund', targetAmount: 1000.0, iconName: 'shield'),
    SavingsGoal(id: 'g3', title: 'New Laptop', targetAmount: 1200.0, iconName: 'laptop'),
  ];

  double get _totalSaved {
    double total = 0.0;
    for (var item in _defusedItems) {
      total += item.price;
    }
    return total;
  }

  double get _totalHoursSaved {
    double total = 0.0;
    for (var item in _defusedItems) {
      total += item.hoursSaved;
    }
    return total;
  }

  void _addDefusedItem(String name, double price, String category) {
    double hours = _hourlyWage > 0 ? price / _hourlyWage : 0;
    setState(() {
      _defusedItems.insert(
        0,
        DefusedItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: name,
          price: price,
          hoursSaved: hours,
          category: category,
          date: DateTime.now(),
        ),
      );
    });
  }

  void _addGoal(String title, double target) {
    setState(() {
      _goals.add(
        SavingsGoal(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          targetAmount: target,
          iconName: 'star',
        ),
      );
    });
  }

  void _updateWage(double wage) {
    setState(() {
      _hourlyWage = wage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DefuseStudioPage(
        hourlyWage: _hourlyWage,
        onWageChanged: _updateWage,
        onUrgeDefused: _addDefusedItem,
      ),
      SavingsVaultPage(
        defusedItems: _defusedItems,
        totalSaved: _totalSaved,
        totalHoursSaved: _totalHoursSaved,
      ),
      GoalsPage(
        goals: _goals,
        totalSaved: _totalSaved,
        onAddGoal: _addGoal,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: 'Defuse Urge',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Savings Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Dream Goals',
          ),
        ],
      ),
    );
  }
}

class DefuseStudioPage extends StatefulWidget {
  final double hourlyWage;
  final ValueChanged<double> onWageChanged;
  final Function(String, double, String) onUrgeDefused;

  const DefuseStudioPage({
    super.key,
    required this.hourlyWage,
    required this.onWageChanged,
    required this.onUrgeDefused,
  });

  @override
  State<DefuseStudioPage> createState() => _DefuseStudioPageState();
}

class _DefuseStudioPageState extends State<DefuseStudioPage> {
  final _itemController = TextEditingController();
  final _priceController = TextEditingController();
  String _selectedCategory = 'Shopping';

  double _needVsWantScore = 3.0; // 1 to 5
  double _joyDurationScore = 2.0; // 1 to 5

  final List<String> _categories = [
    'Shopping',
    'Food & Drink',
    'Gaming & Tech',
    'Subscriptions',
    'Entertainment',
    'Other'
  ];

  double get _enteredPrice {
    return double.tryParse(_priceController.text) ?? 0.0;
  }

  double get _hoursRequired {
    if (widget.hourlyWage <= 0) return 0.0;
    return _enteredPrice / widget.hourlyWage;
  }

  void _startCooldownSession() {
    if (_itemController.text.trim().isEmpty || _enteredPrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid item name and price')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CooldownSessionScreen(
          itemName: _itemController.text.trim(),
          price: _enteredPrice,
          hoursRequired: _hoursRequired,
          category: _selectedCategory,
          needVsWant: _needVsWantScore,
          joyDuration: _joyDurationScore,
          onDefusedSuccess: () {
            widget.onUrgeDefused(
              _itemController.text.trim(),
              _enteredPrice,
              _selectedCategory,
            );
            _itemController.clear();
            _priceController.clear();
          },
        ),
      ),
    );
  }

  void _showWageDialog() {
    final wageController = TextEditingController(text: widget.hourlyWage.toStringAsFixed(2));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Hourly Wage'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Your net hourly earning helps calculate the true work effort spent on impulse buys.'),
            const SizedBox(height: 12),
            TextField(
              controller: wageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Net Wage per Hour (\$)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              double? val = double.tryParse(wageController.text);
              if (val != null && val > 0) {
                widget.onWageChanged(val);
              }
              Navigator.pop(context);
            },
            child: const Text('Save Wage'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.indigo, Colors.indigoAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text(
                        'Impulse Urge Studio',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.tune, color: Colors.white),
                      onPressed: _showWageDialog,
                      tooltip: 'Adjust Wage',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Current Hourly Wage: \$${widget.hourlyWage.toStringAsFixed(2)} / hr',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Defuse impulse urges in real-time before tap-to-pay!',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Input Section
          const Text(
            'What are you tempted to buy right now?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _itemController,
            decoration: const InputDecoration(
              labelText: 'Item / Purchase Name',
              hintText: 'e.g., Designer Sneakers, Food App Deal',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.shopping_bag),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (v) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Price (\$)',
                    hintText: '0.00',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.monetization_on),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCategory = val);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Real Labor Calculator Output
          if (_enteredPrice > 0) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                border: Border.all(color: Colors.amber.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'REAL-LIFE LABOR COST IMPACT',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    child: Text(
                      '${_hoursRequired.toStringAsFixed(1)} Work Hours',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'You must work approx ${_hoursRequired.toStringAsFixed(1)} hours at \$${widget.hourlyWage.toStringAsFixed(2)}/hr just to pay for this item.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Decision Matrix Sliders
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Micro-Decision Reality Check',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text('Is this a Need or a Want? (${_needVsWantScore.toInt()}/5)'),
                  Slider(
                    value: _needVsWantScore,
                    min: 1.0,
                    max: 5.0,
                    divisions: 4,
                    label: _needVsWantScore == 1 ? 'Pure Want' : (_needVsWantScore == 5 ? 'Vital Need' : 'Moderate'),
                    onChanged: (val) => setState(() => _needVsWantScore = val),
                  ),
                  const SizedBox(height: 8),
                  Text('How long will joy from this item last? (${_joyDurationScore.toInt()}/5)'),
                  Slider(
                    value: _joyDurationScore,
                    min: 1.0,
                    max: 5.0,
                    divisions: 4,
                    label: _joyDurationScore == 1 ? '1 Hour' : (_joyDurationScore == 5 ? 'Years' : 'Days'),
                    onChanged: (val) => setState(() => _joyDurationScore = val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Cooldown Action Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _startCooldownSession,
              icon: const Icon(Icons.timer),
              label: const Text(
                'START 2-MIN COOLDOWN SESSION',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CooldownSessionScreen extends StatefulWidget {
  final String itemName;
  final double price;
  final double hoursRequired;
  final String category;
  final double needVsWant;
  final double joyDuration;
  final VoidCallback onDefusedSuccess;

  const CooldownSessionScreen({
    super.key,
    required this.itemName,
    required this.price,
    required this.hoursRequired,
    required this.category,
    required this.needVsWant,
    required this.joyDuration,
    required this.onDefusedSuccess,
  });

  @override
  State<CooldownSessionScreen> createState() => _CooldownSessionScreenState();
}

class _CooldownSessionScreenState extends State<CooldownSessionScreen> {
  int _secondsRemaining = 120; // 2 minutes urge defuse timer
  Timer? _timer;
  int _popCount = 0; // Interactive urge bubble popping game
  bool _canDecision = false;

  final List<String> _mindfulQuestions = [
    "Will you remember buying this in 30 days?",
    "Can you borrow or substitute this with something you own?",
    "Does this purchase bring you closer to your main financial goals?",
    "Is stress or boredom driving this urge right now?",
    "What if you put this amount directly into your dream savings instead?",
  ];

  int _questionIdx = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
          if (_secondsRemaining % 24 == 0) {
            _questionIdx = (_questionIdx + 1) % _mindfulQuestions.length;
          }
        });
      } else {
        _timer?.cancel();
        setState(() {
          _canDecision = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    int m = _secondsRemaining ~/ 60;
    int s = _secondsRemaining % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Urge Cooling-Off Studio'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Timer Display Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: _secondsRemaining > 0 ? Colors.indigo.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _secondsRemaining > 0 ? Colors.indigo.shade200 : Colors.green,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      _secondsRemaining > 0 ? 'NEURAL IMPULSE COOLING DOWN' : 'URGE COOLING COMPLETE!',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _secondsRemaining > 0 ? Colors.indigo : Colors.green.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      child: Text(
                        _formattedTime,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: _secondsRemaining > 0 ? Colors.indigo.shade900 : Colors.green.shade900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (120 - _secondsRemaining) / 120.0,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.indigo,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Item Details Summary
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.indigo,
                        child: Icon(Icons.shopping_bag, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.itemName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '\$${widget.price.toStringAsFixed(2)} • (${widget.hoursRequired.toStringAsFixed(1)} work hrs)',
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Interactive Mindful Question Card
              Card(
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.psychology, color: Colors.orange),
                          SizedBox(width: 6),
                          Text(
                            'Mindful Urge Reframing',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _mindfulQuestions[_questionIdx],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Distraction Bubble Tapper
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Distraction Mini-Game: Tap Urge Bubbles ($popCount popped)',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAxisAlignment.center,
                      alignment: WrapAlignment.center,
                      children: List.generate(6, (idx) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _popCount++;
                            });
                          },
                          child: CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.indigo.withOpacity(0.2 + ((idx + _popCount) % 5) * 0.15),
                            child: const Icon(Icons.bubble_chart, color: Colors.indigo),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Final Decision Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        widget.onDefusedSuccess();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Awesome! Saved \$${widget.price.toStringAsFixed(2)} into your Vault!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      icon: const Icon(Icons.check_circle),
                      label: const FittedBox(
                        child: Text('DEFUSED! SAVE MONEY', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.shopping_bag, color: Colors.red),
                      label: const FittedBox(
                        child: Text('Still Buying', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
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

class SavingsVaultPage extends StatelessWidget {
  final List<DefusedItem> defusedItems;
  final double totalSaved;
  final double totalHoursSaved;

  const SavingsVaultPage({
    super.key,
    required this.defusedItems,
    required this.totalSaved,
    required this.totalHoursSaved,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Defused Savings Vault',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // Summary Cards
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Money Saved', style: TextStyle(fontSize: 12, color: Colors.green)),
                    const SizedBox(height: 4),
                    FittedBox(
                      child: Text(
                        '\$${totalSaved.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green.shade900),
                      ),
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
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigo.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Work Hours Saved', style: TextStyle(fontSize: 12, color: Colors.indigo)),
                    const SizedBox(height: 4),
                    FittedBox(
                      child: Text(
                        '${totalHoursSaved.toStringAsFixed(1)} hrs',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        const Text(
          'Defused Urge Log',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        if (defusedItems.isEmpty) ...[
          Container(
            padding: const EdgeInsets.all(32),
            textAlign: TextAlign.center,
            child: const Column(
              children: [
                Icon(Icons.shield_outlined, size: 48, color: Colors.grey),
                SizedBox(height: 12),
                Text('No defused urges yet. When you overcome an impulse, it shows up here!'),
              ],
            ),
          )
        ] else ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: defusedItems.length,
            itemBuilder: (context, index) {
              final item = defusedItems[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                  title: Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text('${item.category} • ${item.date.day}/${item.date.month}/${item.date.year}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '+\$${item.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        '${item.hoursSaved.toStringAsFixed(1)} hrs saved',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ]
      ],
    );
  }
}

class GoalsPage extends StatefulWidget {
  final List<SavingsGoal> goals;
  final double totalSaved;
  final Function(String, double) onAddGoal;

  const GoalsPage({
    super.key,
    required this.goals,
    required this.totalSaved,
    required this.onAddGoal,
  });

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  void _showAddGoalDialog() {
    final titleController = TextEditingController();
    final targetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Dream Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Goal Title',
                hintText: 'e.g., New Smartphone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Target Amount (\$)',
                hintText: '500',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              double? target = double.tryParse(targetController.text);
              if (titleController.text.isNotEmpty && target != null && target > 0) {
                widget.onAddGoal(titleController.text.trim(), target);
                Navigator.pop(context);
              }
            },
            child: const Text('Add Goal'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Flexible(
              child: Text(
                'Dream Goals Unlocked',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                softWrap: true,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _showAddGoalDialog,
              icon: const Icon(Icons.add),
              label: const Text('New Goal'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Your total impulse savings (\$${widget.totalSaved.toStringAsFixed(2)}) automatically fund these dream goals!',
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 16),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.goals.length,
          itemBuilder: (context, index) {
            final goal = widget.goals[index];
            double progress = (widget.totalSaved / goal.targetAmount).clamp(0.0, 1.0);
            double percentage = progress * 100;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            goal.title,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${percentage.toStringAsFixed(0)}%',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                      backgroundColor: Colors.grey.shade200,
                      color: progress >= 1.0 ? Colors.green : Colors.indigo,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Funded: \$${widget.totalSaved.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          'Target: \$${goal.targetAmount.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}