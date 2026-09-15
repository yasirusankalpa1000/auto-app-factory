import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const ChronoWorthApp());
}

class ChronoWorthApp extends StatelessWidget {
  const ChronoWorthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChronoWorth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          primary: Colors.indigo,
          secondary: Colors.teal,
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
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

  // Shared Application State
  double _hourlyWage = 25.0;
  double _totalSavedMoney = 145.0;
  double _totalHoursPreserved = 18.5;
  int _impulsesDefeated = 7;

  final List<Map<String, dynamic>> _savedHistory = [
    {
      'title': 'Takeout Coffee & Pastry',
      'cost': 12.50,
      'hours': 0.5,
      'date': 'Today',
      'category': 'Food & Drink'
    },
    {
      'title': 'Impulse Gaming Skin',
      'cost': 25.00,
      'hours': 1.0,
      'date': 'Yesterday',
      'category': 'Digital'
    },
    {
      'title': 'Unplanned Fast Delivery',
      'cost': 35.00,
      'hours': 1.4,
      'date': '3 days ago',
      'category': 'Shopping'
    },
  ];

  void _addSavedItem(String title, double cost, String category) {
    setState(() {
      double hoursEquivalent = _hourlyWage > 0 ? cost / _hourlyWage : 0;
      _totalSavedMoney += cost;
      _totalHoursPreserved += hoursEquivalent;
      _impulsesDefeated += 1;
      _savedHistory.insert(0, {
        'title': title.isEmpty ? 'Avoided Impulse' : title,
        'cost': cost,
        'hours': hoursEquivalent,
        'date': 'Just now',
        'category': category,
      });
    });
  }

  void _updateWage(double newWage) {
    setState(() {
      _hourlyWage = newWage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      LifeSwapTab(
        hourlyWage: _hourlyWage,
        onUpdateWage: _updateWage,
        onLogSavedItem: _addSavedItem,
      ),
      CooldownVaultTab(
        hourlyWage: _hourlyWage,
        onCooldownComplete: _addSavedItem,
      ),
      const FocusDeskTab(),
      GrowthLedgerTab(
        totalSavedMoney: _totalSavedMoney,
        totalHoursPreserved: _totalHoursPreserved,
        impulsesDefeated: _impulsesDefeated,
        savedHistory: _savedHistory,
      ),
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
            selectedIcon: Icon(Icons.calculate, color: Colors.indigo),
            label: 'Life Swap',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer, color: Colors.indigo),
            label: 'Cooldown',
          ),
          NavigationDestination(
            icon: Icon(Icons.center_focus_strong),
            selectedIcon: Icon(Icons.center_focus_strong, color: Colors.indigo),
            label: 'Focus Desk',
          ),
          NavigationDestination(
            icon: Icon(Icons.trending_up),
            selectedIcon: Icon(Icons.trending_up, color: Colors.indigo),
            label: 'Growth Ledger',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TAB 1: LIFE SWAP CONVERTER
// ==========================================
class LifeSwapTab extends StatefulWidget {
  final double hourlyWage;
  final ValueChanged<double> onUpdateWage;
  final Function(String, double, String) onLogSavedItem;

  const LifeSwapTab({
    super.key,
    required this.hourlyWage,
    required this.onUpdateWage,
    required this.onLogSavedItem,
  });

  @override
  State<LifeSwapTab> createState() => _LifeSwapTabState();
}

class _LifeSwapTabState extends State<LifeSwapTab> {
  final TextEditingController _itemTitleController = TextEditingController();
  final TextEditingController _costController = TextEditingController(text: "28.00");
  final TextEditingController _wageController = TextEditingController();

  String _selectedCategory = 'Shopping';
  final List<String> _categories = ['Shopping', 'Food & Drink', 'Digital', 'Entertainment', 'Subscription'];

  @override
  void initState() {
    super.initState();
    _wageController.text = widget.hourlyWage.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _itemTitleController.dispose();
    _costController.dispose();
    _wageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double cost = double.tryParse(_costController.text) ?? 0.0;
    double wage = double.tryParse(_wageController.text) ?? widget.hourlyWage;
    double hoursWorked = wage > 0 ? cost / wage : 0.0;
    
    // 5 Year compound value at 7% annual return
    double compound5Yr = cost * pow(1.07, 5);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ChronoWorth : Life Swap'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Banner
              Card(
                color: Colors.indigo.shade50,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.indigo.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb, color: Colors.indigo, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Convert any impulse cost into actual hours of labor you must work to pay for it.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.indigo.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Hourly Wage Config Box
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.teal),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Your Hourly Earning Rate:",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        child: TextField(
                          controller: _wageController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            prefixText: '\$',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          ),
                          onChanged: (val) {
                            double parsed = double.tryParse(val) ?? 0.0;
                            if (parsed > 0) {
                              widget.onUpdateWage(parsed);
                            }
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Impulse Item Inputs
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Evaluate An Impulse Item",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _itemTitleController,
                        decoration: const InputDecoration(
                          labelText: 'What are you planning to buy?',
                          hintText: 'e.g., Designer Shoes, Takeout Meal',
                          prefixIcon: Icon(Icons.shopping_bag),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _costController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Price',
                                prefixText: '\$',
                                prefixIcon: Icon(Icons.attach_money),
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (_) => setState(() {}),
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Live Calculation Output Cards
              Card(
                color: Colors.indigo,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        "REAL COST IN LIFE HOURS",
                        style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.1),
                      ),
                      const SizedBox(height: 8),
                      FittedBox(
                        child: Text(
                          "${hoursWorked.toStringAsFixed(1)} Hours",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "of hard work at \$${wage.toStringAsFixed(2)}/hr",
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const Divider(color: Colors.white70, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text("5-Yr Opportunity Cost", style: TextStyle(color: Colors.white70, fontSize: 11)),
                              const SizedBox(height: 4),
                              Text(
                                "\$${compound5Yr.toStringAsFixed(2)}",
                                style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(height: 30, width: 1, color: Colors.white70),
                          Column(
                            children: [
                              const Text("Workday Equivalent", style: TextStyle(color: Colors.white70, fontSize: 11)),
                              const SizedBox(height: 4),
                              Text(
                                "${(hoursWorked / 8.0).toStringAsFixed(2)} Days",
                                style: const TextStyle(color: Colors.tealAccent, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: cost <= 0
                          ? null
                          : () {
                              widget.onLogSavedItem(
                                _itemTitleController.text,
                                cost,
                                _selectedCategory,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Defeated Impulse! \$${cost.toStringAsFixed(2)} added to saved ledger."),
                                  backgroundColor: Colors.teal,
                                ),
                              );
                              _itemTitleController.clear();
                            },
                      icon: const Icon(Icons.shield),
                      label: const Text("Resist & Save", style: TextStyle(fontWeight: FontWeight.bold)),
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

// ==========================================
// TAB 2: IMPULSE COOLDOWN VAULT
// ==========================================
class CooldownVaultTab extends StatefulWidget {
  final double hourlyWage;
  final Function(String, double, String) onCooldownComplete;

  const CooldownVaultTab({
    super.key,
    required this.hourlyWage,
    required this.onCooldownComplete,
  });

  @override
  State<CooldownVaultTab> createState() => _CooldownVaultTabState();
}

class _CooldownVaultTabState extends State<CooldownVaultTab> {
  final TextEditingController _itemController = TextEditingController(text: "Online Shopping Cart");
  final TextEditingController _priceController = TextEditingController(text: "45.00");
  final TextEditingController _reflectionController = TextEditingController();

  int _selectedSeconds = 180; // Default 3 mins
  int _secondsRemaining = 180;
  Timer? _timer;
  bool _isRunning = false;
  bool _isFinished = false;

  final List<String> _mindfulQuestions = [
    "Will this matter in 30 days?",
    "Am I bored, stressed, or actually in need of this?",
    "How many hours of work did this require?",
    "Can I wait 24 hours before pressing buy?"
  ];
  int _currentQuestionIndex = 0;

  void _startTimer() {
    if (_timer != null) _timer!.cancel();
    setState(() {
      _isRunning = true;
      _isFinished = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
          if (_secondsRemaining % 20 == 0) {
            _currentQuestionIndex = (_currentQuestionIndex + 1) % _mindfulQuestions.length;
          }
        });
      } else {
        _timer!.cancel();
        setState(() {
          _isRunning = false;
          _isFinished = true;
        });
      }
    });
  }

  void _resetTimer() {
    if (_timer != null) _timer!.cancel();
    setState(() {
      _isRunning = false;
      _isFinished = false;
      _secondsRemaining = _selectedSeconds;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _itemController.dispose();
    _priceController.dispose();
    _reflectionController.dispose();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    int mins = totalSeconds ~/ 60;
    int secs = totalSeconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    double cost = double.tryParse(_priceController.text) ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Impulse Cooldown Vault'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Information Box
              Card(
                color: Colors.amber.shade50,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.amber.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.shield, color: Colors.amber, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Scientific cooling period: Pausing 3-5 minutes breaks dopamine impulse loops and cuts unwanted buying by 70%.",
                          style: TextStyle(fontSize: 12, color: Colors.amber.shade900, fontWeight: FontWeight.w500),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Config Section
              if (!_isRunning && !_isFinished) ...[
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Lock Item in Cooldown", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _itemController,
                          decoration: const InputDecoration(
                            labelText: 'Target Impulse Item',
                            prefixIcon: Icon(Icons.lock_clock),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _priceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Estimated Cost',
                            prefixText: '\$',
                            prefixIcon: Icon(Icons.attach_money),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text("Select Cooldown Timer:", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          crossAxisAlignment: WrapCrossAxisAlignment.center,
                          children: [1, 3, 5, 10].map((mins) {
                            int secs = mins * 60;
                            bool isSelected = _selectedSeconds == secs;
                            return ChoiceChip(
                              label: Text("$mins min"),
                              selected: isSelected,
                              selectedColor: Colors.indigo,
                              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedSeconds = secs;
                                    _secondsRemaining = secs;
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
                const SizedBox(height: 16),
              ],

              // Timer Dial Box
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                  child: Column(
                    children: [
                      Text(
                        _isFinished
                            ? "COOLDOWN COMPLETE"
                            : _isRunning
                                ? "COOLING DOWN IMPULSE..."
                                : "READY TO COOL DOWN",
                        style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),

                      // Circle Timer Display
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: CircularProgressIndicator(
                              value: _selectedSeconds > 0 ? _secondsRemaining / _selectedSeconds : 0,
                              strokeWidth: 10,
                              backgroundColor: Colors.grey.shade200,
                              color: _isFinished ? Colors.green : Colors.indigo,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatTime(_secondsRemaining),
                                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.indigo),
                              ),
                              if (cost > 0)
                                Text(
                                  "\$${cost.toStringAsFixed(2)} Locked",
                                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
                                ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Mindful Reflection Prompt
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            const Text("Mindfulness Prompt:", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.teal)),
                            const SizedBox(height: 4),
                            Text(
                              _mindfulQuestions[_currentQuestionIndex],
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.teal.shade900),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Control Buttons
              if (!_isRunning && !_isFinished)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _startTimer,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Start Cooling Timer", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),

              if (_isRunning)
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.stop),
                  label: const Text("Cancel Cooldown"),
                ),

              if (_isFinished) ...[
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    widget.onCooldownComplete(
                      _itemController.text,
                      cost,
                      'Cooldown Defeated',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Success! You successfully avoided an impulse purchase.")),
                    );
                    _resetTimer();
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text("I Decided NOT to Buy (Save \$)", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _resetTimer,
                  child: const Text("I bought it anyway (Reset)", style: TextStyle(color: Colors.grey)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// TAB 3: FOCUS DESK COMPANION
// ==========================================
class FocusDeskTab extends StatefulWidget {
  const FocusDeskTab({super.key});

  @override
  State<FocusDeskTab> createState() => _FocusDeskTabState();
}

class _FocusDeskTabState extends State<FocusDeskTab> {
  int _sprintSeconds = 25 * 60; // 25 min Pomodoro
  int _secondsRemaining = 25 * 60;
  Timer? _timer;
  bool _isRunning = false;
  int _completedSprints = 2;

  final TextEditingController _taskController = TextEditingController();
  final List<Map<String, dynamic>> _microTasks = [
    {'title': 'Draft product feature specs', 'done': true},
    {'title': 'Clear urgent inbox messages', 'done': false},
  ];

  void _toggleSprint() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() => _secondsRemaining--);
        } else {
          _timer?.cancel();
          setState(() {
            _isRunning = false;
            _completedSprints++;
            _secondsRemaining = _sprintSeconds;
          });
        }
      });
    }
  }

  void _resetSprint() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _secondsRemaining = _sprintSeconds;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _taskController.dispose();
    super.dispose();
  }

  String _formatTime(int totalSecs) {
    int m = totalSecs ~/ 60;
    int s = totalSecs % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desk Focus Companion'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Active Sprint Display Card
              Card(
                color: Colors.indigo.shade900,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Chip(
                            avatar: Icon(Icons.star, color: Colors.amber, size: 16),
                            label: Text("Focus Mode", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          Text(
                            "Completed Today: $_completedSprints",
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _formatTime(_secondsRemaining),
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Keep this screen on your desk during work sprints",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton.large(
                            heroTag: 'play_focus_fab',
                            backgroundColor: Colors.tealAccent,
                            foregroundColor: Colors.indigo.shade900,
                            onPressed: _toggleSprint,
                            child: Icon(_isRunning ? Icons.pause : Icons.play_arrow, size: 36),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            onPressed: _resetSprint,
                            icon: const Icon(Icons.refresh, color: Colors.white70),
                            tooltip: 'Reset Timer',
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Sprint Micro Task Checklist
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Sprint Micro-Tasks",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _taskController,
                              decoration: const InputDecoration(
                                hintText: 'Add 1 micro task for this sprint...',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            style: IconButton.styleFrom(backgroundColor: Colors.indigo),
                            onPressed: () {
                              if (_taskController.text.trim().isNotEmpty) {
                                setState(() {
                                  _microTasks.add({'title': _taskController.text.trim(), 'done': false});
                                  _taskController.clear();
                                });
                              }
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _microTasks.length,
                        itemBuilder: (context, index) {
                          final item = _microTasks[index];
                          return CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              item['title'],
                              style: TextStyle(
                                decoration: item['done'] ? TextDecoration.lineThrough : null,
                                color: item['done'] ? Colors.grey : Colors.black87,
                              ),
                            ),
                            value: item['done'],
                            onChanged: (val) {
                              setState(() {
                                item['done'] = val ?? false;
                              });
                            },
                            secondary: IconButton(
                              icon: const Icon(Icons.delete, size: 20, color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  _microTasks.removeAt(index);
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
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// TAB 4: GROWTH LEDGER & STATS
// ==========================================
class GrowthLedgerTab extends StatelessWidget {
  final double totalSavedMoney;
  final double totalHoursPreserved;
  final int impulsesDefeated;
  final List<Map<String, dynamic>> savedHistory;

  const GrowthLedgerTab({
    super.key,
    required this.totalSavedMoney,
    required this.totalHoursPreserved,
    required this.impulsesDefeated,
    required this.savedHistory,
  });

  @override
  Widget build(BuildContext context) {
    // 1yr, 5yr, 10yr compound interest projections (7% return)
    double compound1Yr = totalSavedMoney * pow(1.07, 1);
    double compound5Yr = totalSavedMoney * pow(1.07, 5);
    double compound10Yr = totalSavedMoney * pow(1.07, 10);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Growth & Willpower Ledger'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Overview Cards Grid
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.teal.shade50,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.teal.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text("Total Money Saved", style: TextStyle(fontSize: 11, color: Colors.teal)),
                            const SizedBox(height: 6),
                            FittedBox(
                              child: Text(
                                "\$${totalSavedMoney.toStringAsFixed(2)}",
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Card(
                      color: Colors.indigo.shade50,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.indigo.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text("Hours Preserved", style: TextStyle(fontSize: 11, color: Colors.indigo)),
                            const SizedBox(height: 6),
                            FittedBox(
                              child: Text(
                                "${totalHoursPreserved.toStringAsFixed(1)} hrs",
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Compound Projection Visualizer Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.trending_up, color: Colors.indigo),
                          SizedBox(width: 8),
                          Text(
                            "If Invested Saved Funds (7% Growth)",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildProjectionTile("1 Year", "\$${compound1Yr.toStringAsFixed(0)}"),
                          _buildProjectionTile("5 Years", "\$${compound5Yr.toStringAsFixed(0)}"),
                          _buildProjectionTile("10 Years", "\$${compound10Yr.toStringAsFixed(0)}"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Defeated Impulses List Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Defeated Impulses Log", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
                  Chip(
                    backgroundColor: Colors.indigo.shade50,
                    label: Text("$impulsesDefeated Resisted", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.indigo)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Saved History ListView
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: savedHistory.length,
                itemBuilder: (context, index) {
                  final item = savedHistory[index];
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.shade100,
                        child: const Icon(Icons.check, color: Colors.teal),
                      ),
                      title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text("${item['category']} • ${item['date']}"),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "+\$${(item['cost'] as double).toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 14),
                          ),
                          Text(
                            "${(item['hours'] as double).toStringAsFixed(1)} hrs saved",
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
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

  Widget _buildProjectionTile(String period, String value) {
    return Column(
      children: [
        Text(period, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
      ],
    );
  }
}