import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const PivotPulseApp());
}

class PivotPulseApp extends StatelessWidget {
  const PivotPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PivotPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.amber,
          surface: Color(0xFF1E293B),
          background: Color(0xFF0F172A),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1E293B),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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

  final List<Widget> _pages = const [
    DecisionSolverView(),
    ImpulseGuardView(),
    TimeLeakAuditView(),
    FocusPulseView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.casino),
            label: 'Decide',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: 'Impulse Guard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Leak Audit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt),
            label: 'Focus Pulse',
          ),
        ],
      ),
    );
  }
}

// ==================== TAB 1: DECISION SOLVER ====================
class DecisionSolverView extends StatefulWidget {
  const DecisionSolverView({super.key});

  @override
  State<DecisionSolverView> createState() => _DecisionSolverViewState();
}

class _DecisionSolverViewState extends State<DecisionSolverView> {
  final TextEditingController _optionController = TextEditingController();
  final List<String> _options = [
    'Healthy Home Meal',
    'Order Fast Food',
    '15-Min Quick Walk',
    '30-Min Deep Work',
    'Power Nap',
  ];

  String? _selectedOption;
  bool _isSpinning = false;
  int _highlightedIndex = -1;

  void _addOption() {
    final text = _optionController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _options.add(text);
        _optionController.clear();
      });
    }
  }

  void _removeOption(int index) {
    setState(() {
      _options.removeAt(index);
      if (_options.isEmpty) {
        _selectedOption = null;
      }
    });
  }

  void _spinToDecide() async {
    if (_options.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least 2 options to decide!')),
      );
      return;
    }

    setState(() {
      _isSpinning = true;
      _selectedOption = null;
    });

    final random = Random();
    int spins = 15 + random.nextInt(10);
    int delayMs = 50;

    for (int i = 0; i < spins; i++) {
      await Future.delayed(Duration(milliseconds: delayMs));
      if (!mounted) return;
      setState(() {
        _highlightedIndex = i % _options.length;
      });
      delayMs += 15;
    }

    final finalIndex = random.nextInt(_options.length);
    setState(() {
      _highlightedIndex = finalIndex;
      _selectedOption = _options[finalIndex];
      _isSpinning = false;
    });
  }

  void _loadPreset(String category) {
    setState(() {
      if (category == 'Lunch') {
        _options.clear();
        _options.addAll(['Fresh Salad Bowl', 'Chicken Wrap', 'Rice & Curry', 'Pasta Delight', 'Soup & Sandwich']);
      } else if (category == 'Break') {
        _options.clear();
        _options.addAll(['Hydrate & Stretch', '10-Min Meditation', 'Read 5 Pages', 'Quick Desk Clean', 'Breathe Outside']);
      } else if (category == 'Evening') {
        _options.clear();
        _options.addAll(['Gym Workout', 'Watch Documentary', 'Call a Friend', 'Side Project', 'Read a Book']);
      }
      _selectedOption = null;
      _highlightedIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: const [
              Icon(Icons.casino, color: Colors.tealAccent, size: 28),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Micro-Decision Solver',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Eliminate daily decision paralysis. Pick options or use quick presets!',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          
          // Presets
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              const Text('Presets:', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
              ActionChip(
                label: const Text('Lunch Ideas'),
                onPressed: () => _loadPreset('Lunch'),
                backgroundColor: const Color(0xFF334155),
              ),
              ActionChip(
                label: const Text('Quick Breaks'),
                onPressed: () => _loadPreset('Break'),
                backgroundColor: const Color(0xFF334155),
              ),
              ActionChip(
                label: const Text('Evening Routine'),
                onPressed: () => _loadPreset('Evening'),
                backgroundColor: const Color(0xFF334155),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Input field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _optionController,
                  decoration: const InputDecoration(
                    labelText: 'Add Option (e.g. Cook Curry)',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  onSubmitted: (_) => _addOption(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _addOption,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Option list
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Current Options Matrix:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                  const SizedBox(height: 8),
                  if (_options.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No options added yet. Type above to begin!', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                    ),
                  ...List.generate(_options.length, (index) {
                    final isHighlighted = index == _highlightedIndex;
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: isHighlighted ? Colors.tealAccent.withOpacity(0.2) : const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isHighlighted ? Colors.tealAccent : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          radius: 12,
                          backgroundColor: isHighlighted ? Colors.tealAccent : Colors.grey.shade700,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isHighlighted ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          _options[index],
                          style: TextStyle(
                            color: isHighlighted ? Colors.tealAccent : Colors.white,
                            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, size: 18, color: Colors.grey),
                          onPressed: () => _removeOption(index),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Spin Button
          ElevatedButton.icon(
            onPressed: _isSpinning ? null : _spinToDecide,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: _isSpinning
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                : const Icon(Icons.stars),
            label: Text(
              _isSpinning ? 'SOLVING DECISION...' : 'RESOLVE PARALYSIS NOW',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),

          // Result Card
          if (_selectedOption != null)
            Card(
              color: Colors.teal.shade900.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.tealAccent, width: 1.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text('DECISION MADE BY ENGINE', style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    const SizedBox(height: 8),
                    Text(
                      _selectedOption!,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    const Text('No second guessing! Execute this step with zero friction.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ==================== TAB 2: IMPULSE GUARD ====================
class ImpulseGuardView extends StatefulWidget {
  const ImpulseGuardView({super.key});

  @override
  State<ImpulseGuardView> createState() => _ImpulseGuardViewState();
}

class _ImpulseGuardViewState extends State<ImpulseGuardView> {
  double _itemPrice = 85.0;
  double _hourlyWage = 25.0;
  double _hoursPerWeek = 40.0;

  @override
  Widget build(BuildContext context) {
    double grossHoursNeeded = _itemPrice / (_hourlyWage <= 0 ? 1 : _hourlyWage);
    // Assuming 25% tax/deductions for real take-home equity calculation
    double takeHomeWage = _hourlyWage * 0.75;
    double realSweatHours = _itemPrice / (takeHomeWage <= 0 ? 1 : takeHomeWage);
    double investment5Years = _itemPrice * pow((1 + 0.08), 5); // 8% annual growth assumption

    int coolingOffHours = 0;
    if (_itemPrice > 500) {
      coolingOffHours = 72;
    } else if (_itemPrice > 150) {
      coolingOffHours = 48;
    } else if (_itemPrice > 50) {
      coolingOffHours = 24;
    } else {
      coolingOffHours = 2;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: const [
              Icon(Icons.shield, color: Colors.amber, size: 28),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Impulse Buy Sweat Guard',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Calculate how much real life hours you must exchange for non-essential buys.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Price Slider Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Purchase Price:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        '\$${_itemPrice.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                      ),
                    ],
                  ),
                  Slider(
                    value: _itemPrice,
                    min: 5,
                    max: 1000,
                    divisions: 199,
                    activeColor: Colors.tealAccent,
                    onChanged: (val) {
                      setState(() {
                        _itemPrice = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Hourly Wage Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Your Hourly Wage:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        '\$${_hourlyWage.toStringAsFixed(0)} / hr',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
                      ),
                    ],
                  ),
                  Slider(
                    value: _hourlyWage,
                    min: 5,
                    max: 200,
                    divisions: 195,
                    activeColor: Colors.amber,
                    onChanged: (val) {
                      setState(() {
                        _hourlyWage = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Life Sweat Metrics Dashboard
          Card(
            color: const Color(0xFF0F172A),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.amber, width: 1.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('LIFE SWEAT EQUITY COST', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '${realSweatHours.toStringAsFixed(1)} hrs',
                              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.redAccent),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            const Text('Real Sweat Hours', style: TextStyle(fontSize: 11, color: Colors.white70), textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                      Container(height: 40, width: 1, color: Colors.grey.shade800),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '${coolingOffHours}h',
                              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.amber),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            const Text('Mandatory Wait', style: TextStyle(fontSize: 11, color: Colors.white70), textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white70),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.trending_up, color: Colors.tealAccent, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'If invested at 8% compound growth instead, this money would become \$${investment5Years.toStringAsFixed(0)} in 5 years.',
                          style: const TextStyle(fontSize: 12, color: Colors.tealAccent),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Impulse Decision Rules Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Text('Guard Rule Advice:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    coolingOffHours >= 48
                        ? 'High Impulse Impact! Put this item on a $coolingOffHours-hour wishlist. If you still feel it enhances your core life purpose after $coolingOffHours hours, make the purchase.'
                        : 'Moderate Impulse Buy. Pause for $coolingOffHours hours. Ask: "Does this replace something I already own?"',
                    style: const TextStyle(fontSize: 13, color: Colors.white70, height: 1.4),
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

// ==================== TAB 3: TIME LEAK AUDIT ====================
class TimeLeakAuditView extends StatefulWidget {
  const TimeLeakAuditView({super.key});

  @override
  State<TimeLeakAuditView> createState() => _TimeLeakAuditViewState();
}

class _TimeLeakAuditViewState extends State<TimeLeakAuditView> {
  double _screenDoomscrollMins = 45.0;
  double _indecisionMins = 25.0;
  double _microSpendDaily = 6.0; // e.g. daily \$6 convenience food/latte

  @override
  Widget build(BuildContext context) {
    double totalDailyWastedMins = _screenDoomscrollMins + _indecisionMins;
    double totalHoursWastedYear = (totalDailyWastedMins * 365) / 60;
    double daysWastedYear = totalHoursWastedYear / 24;

    double moneyLeakedYear = _microSpendDaily * 365;
    double moneyLeaked5Years = moneyLeakedYear * 5;

    int booksCouldRead = (totalHoursWastedYear / 5).floor(); // assuming 5 hours per book
    int workoutsCouldDo = (totalHoursWastedYear / 0.75).floor(); // 45 min workout

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: const [
              Icon(Icons.calculate, color: Colors.tealAccent, size: 28),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Time & Micro-Money Leak Audit',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Visualize how small daily leaks compound into huge lost opportunities every year.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Sliders Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Slider 1: Doomscrolling
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Daily Doomscroll / Friction:', style: TextStyle(fontSize: 13)),
                      Text('${_screenDoomscrollMins.toInt()} mins/day', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                    ],
                  ),
                  Slider(
                    value: _screenDoomscrollMins,
                    min: 0,
                    max: 180,
                    divisions: 36,
                    activeColor: Colors.tealAccent,
                    onChanged: (v) => setState(() => _screenDoomscrollMins = v),
                  ),
                  const SizedBox(height: 8),

                  // Slider 2: Decision Paralysis
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Daily Decision Paralysis:', style: TextStyle(fontSize: 13)),
                      Text('${_indecisionMins.toInt()} mins/day', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                    ],
                  ),
                  Slider(
                    value: _indecisionMins,
                    min: 0,
                    max: 120,
                    divisions: 24,
                    activeColor: Colors.amber,
                    onChanged: (v) => setState(() => _indecisionMins = v),
                  ),
                  const SizedBox(height: 8),

                  // Slider 3: Convenience Micro-Spend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Daily Impulse/Micro-Spend:', style: TextStyle(fontSize: 13)),
                      Text('\$${_microSpendDaily.toStringAsFixed(1)} /day', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                    ],
                  ),
                  Slider(
                    value: _microSpendDaily,
                    min: 0,
                    max: 30,
                    divisions: 30,
                    activeColor: Colors.redAccent,
                    onChanged: (v) => setState(() => _microSpendDaily = v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Annual Compounding Summary Card
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.tealAccent, width: 1.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('ANNUAL COMPOUND LEAK IMPACT', style: TextStyle(color: Colors.tealAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '${daysWastedYear.toStringAsFixed(1)}',
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.redAccent),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            const Text('Full Days Lost/Yr', style: TextStyle(fontSize: 11, color: Colors.white70), textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                      Container(height: 40, width: 1, color: Colors.grey.shade800),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '\$${moneyLeakedYear.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.amber),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            const Text('Money Leaked/Yr', style: TextStyle(fontSize: 11, color: Colors.white70), textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('5-Year Compound Spend Leak:', style: TextStyle(fontSize: 12, color: Colors.white70)),
                        Text(
                          '\$${moneyLeaked5Years.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // What You Could Have Achieved Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.stars, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Text('Reclaimed Potential Per Year:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.tealAccent, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Read ~$booksCouldRead full books or master a high-value skill.',
                          style: const TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.tealAccent, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Complete ~$workoutsCouldDo energetic 45-minute fitness workouts.',
                          style: const TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                      ),
                    ],
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

// ==================== TAB 4: FOCUS PULSE ====================
class FocusPulseView extends StatefulWidget {
  const FocusPulseView({super.key});

  @override
  State<FocusPulseView> createState() => _FocusPulseViewState();
}

class _FocusPulseViewState extends State<FocusPulseView> {
  int _targetSeconds = 15 * 60; // default 15 minutes
  int _remainingSeconds = 15 * 60;
  Timer? _timer;
  bool _isRunning = false;

  final List<Map<String, dynamic>> _microHabits = [
    {'title': 'Drink 1 Glass of Water', 'done': false},
    {'title': 'Clear Desk & Screen Clutter', 'done': false},
    {'title': 'Take 5 Deep Breaths', 'done': false},
    {'title': 'Log Today\'s Micro-Decision', 'done': false},
  ];

  void _setPresetMinutes(int mins) {
    _stopTimer();
    setState(() {
      _targetSeconds = mins * 60;
      _remainingSeconds = mins * 60;
    });
  }

  void _startTimer() {
    if (_timer != null) _timer!.cancel();
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _stopTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Focus Sprint Completed! High Five!')),
        );
      }
    });
  }

  void _stopTimer() {
    if (_timer != null) _timer!.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _remainingSeconds = _targetSeconds;
    });
  }

  String _formatTimeString(int totalSecs) {
    int m = totalSecs ~/ 60;
    int s = totalSecs % 60;
    String mStr = m < 10 ? '0$m' : '$m';
    String sStr = s < 10 ? '0$s' : '$s';
    return '$mStr:$sStr';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = _targetSeconds > 0 ? (_remainingSeconds / _targetSeconds) : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: const [
              Icon(Icons.bolt, color: Colors.amber, size: 28),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Focus Pulse & Micro-Sprints',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Beat procrastination with friction-free micro-sprints and quick routines.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Preset Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              const Text('Sprint Preset:', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
              ActionChip(
                label: const Text('5 Min Burst'),
                onPressed: () => _setPresetMinutes(5),
                backgroundColor: _targetSeconds == 300 ? Colors.teal : const Color(0xFF334155),
              ),
              ActionChip(
                label: const Text('15 Min Momentum'),
                onPressed: () => _setPresetMinutes(15),
                backgroundColor: _targetSeconds == 900 ? Colors.teal : const Color(0xFF334155),
              ),
              ActionChip(
                label: const Text('25 Min Deep Work'),
                onPressed: () => _setPresetMinutes(25),
                backgroundColor: _targetSeconds == 1500 ? Colors.teal : const Color(0xFF334155),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Timer Dial Container
          Card(
            color: const Color(0xFF1E293B),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 10,
                          backgroundColor: Colors.grey.shade800,
                          color: Colors.tealAccent,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            _formatTimeString(_remainingSeconds),
                            style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isRunning ? 'PULSING FOCUS' : 'READY TO SPRINT',
                            style: const TextStyle(fontSize: 10, color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Timer Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _isRunning ? _stopTimer : _startTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isRunning ? Colors.amber : Colors.tealAccent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                        label: Text(_isRunning ? 'PAUSE' : 'START SPRINT', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: _resetTimer,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('RESET'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Daily Micro-Habits Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Daily Friction Reduction Checklist:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                  const SizedBox(height: 12),
                  ...List.generate(_microHabits.length, (index) {
                    final item = _microHabits[index];
                    return CheckboxListTile(
                      value: item['done'],
                      title: Text(
                        item['title'],
                        style: TextStyle(
                          decoration: item['done'] ? TextDecoration.lineThrough : TextDecoration.none,
                          color: item['done'] ? Colors.grey : Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      activeColor: Colors.tealAccent,
                      checkColor: Colors.black,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) {
                        setState(() {
                          _microHabits[index]['done'] = val ?? false;
                        });
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}