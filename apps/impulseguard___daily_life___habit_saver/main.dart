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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  double _totalSavedMoney = 185.50;
  double _totalHoursSaved = 9.2;
  int _totalFocusMinutes = 145;
  int _streakDays = 6;

  final List<String> _savedLog = [
    'Saved \$45.00 on impulse online order',
    'Skipped \$12.50 fast food meal',
    'Saved \$128.00 luxury shoes purchase',
  ];

  void _addSavedAmount(double amount, String description) {
    setState(() {
      _totalSavedMoney += amount;
      _totalHoursSaved += amount / 20.0; // Assuming \$20/hr base rate
      _savedLog.insert(0, 'Saved \$${amount.toStringAsFixed(2)} on $description');
    });
  }

  void _addFocusMinutes(int mins) {
    setState(() {
      _totalFocusMinutes += mins;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ImpulseGuardTab(onSaveImpulse: _addSavedAmount),
      RoutineFlowTab(onRoutineComplete: _addFocusMinutes),
      const DecisionStudioTab(),
      VaultStatsTab(
        totalSavedMoney: _totalSavedMoney,
        totalHoursSaved: _totalHoursSaved,
        totalFocusMinutes: _totalFocusMinutes,
        streakDays: _streakDays,
        savedLog: _savedLog,
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
        backgroundColor: const Color(0xFF1E293B),
        indicatorColor: Colors.indigo,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield),
            label: 'Impulse Friction',
          ),
          NavigationDestination(
            icon: Icon(Icons.schedule_outlined),
            selectedIcon: Icon(Icons.schedule),
            label: 'Routine Flow',
          ),
          NavigationDestination(
            icon: Icon(Icons.lightbulb_outline),
            selectedIcon: Icon(Icons.lightbulb),
            label: 'Decision Helper',
          ),
          NavigationDestination(
            icon: Icon(Icons.savings_outlined),
            selectedIcon: Icon(Icons.savings),
            label: 'Vault & Stats',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 1: IMPULSE GUARD (FRICTION & WORK-HOUR CALCULATOR)
// -----------------------------------------------------------------------------
class ImpulseGuardTab extends StatefulWidget {
  final Function(double, String) onSaveImpulse;

  const ImpulseGuardTab({super.key, required: _onSaveImpulse})
      : onSaveImpulse = _onSaveImpulse;

  @override
  State<ImpulseGuardTab> createState() => _ImpulseGuardTabState();
}

class _ImpulseGuardTabState extends State<ImpulseGuardTab> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _wageController =
      TextEditingController(text: '20');

  double _workHoursNeeded = 0;
  double _oneYearInvestment = 0;
  bool _calculated = false;

  // Cool-off friction timer
  Timer? _coolOffTimer;
  int _secondsRemaining = 60;
  bool _isTimerRunning = false;
  bool _timerCompleted = false;

  void _calculateFriction() {
    final price = double.tryParse(_priceController.text) ?? 0;
    final wage = double.tryParse(_wageController.text) ?? 20;

    if (price > 0 && wage > 0) {
      setState(() {
        _workHoursNeeded = price / wage;
        _oneYearInvestment = price * 1.07; // 7% annual potential growth
        _calculated = true;
        _secondsRemaining = 60;
        _timerCompleted = false;
      });
    }
  }

  void _startCoolOffTimer() {
    _coolOffTimer?.cancel();
    setState(() {
      _isTimerRunning = true;
    });

    _coolOffTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 1) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          _secondsRemaining = 0;
          _isTimerRunning = false;
          _timerCompleted = true;
        });
      }
    });
  }

  void _recordSavedImpulse() {
    final price = double.tryParse(_priceController.text) ?? 0;
    final item = _itemController.text.isEmpty ? 'Impulse purchase' : _itemController.text;
    if (price > 0) {
      widget.onSaveImpulse(price, item);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Great job! \$${price.toStringAsFixed(2)} added to your saved vault!'),
          backgroundColor: Colors.teal,
        ),
      );
      _resetForm();
    }
  }

  void _resetForm() {
    _coolOffTimer?.cancel();
    setState(() {
      _itemController.clear();
      _priceController.clear();
      _calculated = false;
      _isTimerRunning = false;
      _timerCompleted = false;
      _secondsRemaining = 60;
    });
  }

  @override
  void dispose() {
    _coolOffTimer?.cancel();
    _itemController.dispose();
    _priceController.dispose();
    _wageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.shield, color: Colors.indigoAccent, size: 28),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Impulse Friction Coach',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Convert target purchases into true life-work hours before spending.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _itemController,
                      decoration: const InputDecoration(
                        labelText: 'What do you want to buy?',
                        prefixIcon: Icon(Icons.shopping_bag_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Item Price (\$) =',
                              prefixIcon: Icon(Icons.attach_money),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _wageController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Hourly Wage (\$) =',
                              prefixIcon: Icon(Icons.work_outline),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _calculateFriction,
                        icon: const Icon(Icons.calculate),
                        label: const Text('Calculate True Cost'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_calculated) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigoAccent.withAlpha(100)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'REAL LIFE COST BREAKDOWN',
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${_workHoursNeeded.toStringAsFixed(1)} hrs',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.tealAccent,
                              ),
                            ),
                            const Text(
                              'Work Required',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        Container(width: 1, height: 40, color: Colors.grey),
                        Column(
                          children: [
                            Text(
                              '\$${_oneYearInvestment.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigoAccent,
                              ),
                            ),
                            const Text(
                              '1-Year Value Saved',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Force a 60-Second Impulse Cooling Friction Sprint:',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: CircularProgressIndicator(
                            value: _secondsRemaining / 60.0,
                            strokeWidth: 8,
                            color: Colors.tealAccent,
                            backgroundColor: Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          '${_secondsRemaining}s',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (!_isTimerRunning && !_timerCompleted)
                      ElevatedButton.icon(
                        onPressed: _startCoolOffTimer,
                        icon: const Icon(Icons.timer),
                        label: const Text('Start Cool-Off Friction Sprint'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    if (_isTimerRunning)
                      const Text(
                        'Take 3 deep breaths... Ask yourself: "Will I care about this item in 30 days?"',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.amberAccent,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    if (_timerCompleted) ...[
                      const Text(
                        'Cooldown complete! Did you overcome the impulse?',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _recordSavedImpulse,
                            icon: const Icon(Icons.check_circle),
                            label: const Text('I Resisted! Save \$'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          OutlinedButton(
                            onPressed: _resetForm,
                            child: const Text('Reset', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ],
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
// TAB 2: ROUTINE FLOW (ACTIVE GUIDED FOCUS EXECUTION)
// -----------------------------------------------------------------------------
class RoutineFlowTab extends StatefulWidget {
  final Function(int) onRoutineComplete;

  const RoutineFlowTab({super.key, required this.onRoutineComplete});

  @override
  State<RoutineFlowTab> createState() => _RoutineFlowTabState();
}

class _RoutineFlowTabState extends State<RoutineFlowTab> {
  int _selectedRoutine = 0;
  int _currentStepIndex = 0;
  int _stepSecondsLeft = 180;
  bool _isTimerActive = false;
  Timer? _stepTimer;

  final List<Map<String, dynamic>> _routines = [
    {
      'title': 'Morning Power Sprint',
      'duration': '15 mins',
      'icon': Icons.wb_sunny,
      'steps': [
        {'name': 'Hydrate & Stretch', 'seconds': 180},
        {'name': 'Write Top 3 Daily Goals', 'seconds': 300},
        {'name': 'Review Calendar & Inbox', 'seconds': 420},
      ]
    },
    {
      'title': 'Deep Work Sprint',
      'duration': '25 mins',
      'icon': Icons.bolt,
      'steps': [
        {'name': 'Clear Desk & Mute Phone', 'seconds': 120},
        {'name': 'Single-Task Deep Focus', 'seconds': 1200},
        {'name': 'Quick Sprint Review', 'seconds': 180},
      ]
    },
    {
      'title': 'Night Wind Down',
      'duration': '10 mins',
      'icon': Icons.nights_stay,
      'steps': [
        {'name': 'Screen Off & Dim Lights', 'seconds': 120},
        {'name': 'Log Daily Victories', 'seconds': 240},
        {'name': 'Deep Breathing & Reset', 'seconds': 240},
      ]
    },
  ];

  void _startStepTimer() {
    _stepTimer?.cancel();
    setState(() {
      _isTimerActive = true;
    });

    _stepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_stepSecondsLeft > 1) {
        setState(() {
          _stepSecondsLeft--;
        });
      } else {
        _nextStep();
      }
    });
  }

  void _pauseTimer() {
    _stepTimer?.cancel();
    setState(() {
      _isTimerActive = false;
    });
  }

  void _nextStep() {
    _stepTimer?.cancel();
    final steps = _routines[_selectedRoutine]['steps'] as List;
    if (_currentStepIndex < steps.length - 1) {
      setState(() {
        _currentStepIndex++;
        _stepSecondsLeft = steps[_currentStepIndex]['seconds'] as int;
        _isTimerActive = false;
      });
    } else {
      // Completed Routine
      widget.onRoutineComplete(15);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Routine Completed! Focus time added to Vault.'),
          backgroundColor: Colors.teal,
        ),
      );
      _resetRoutine();
    }
  }

  void _resetRoutine() {
    _stepTimer?.cancel();
    final steps = _routines[_selectedRoutine]['steps'] as List;
    setState(() {
      _currentStepIndex = 0;
      _stepSecondsLeft = steps[0]['seconds'] as int;
      _isTimerActive = false;
    });
  }

  void _selectRoutine(int index) {
    _stepTimer?.cancel();
    final steps = _routines[index]['steps'] as List;
    setState(() {
      _selectedRoutine = index;
      _currentStepIndex = 0;
      _stepSecondsLeft = steps[0]['seconds'] as int;
      _isTimerActive = false;
    });
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeRoutine = _routines[_selectedRoutine];
    final steps = activeRoutine['steps'] as List;
    final currentStep = steps[_currentStepIndex];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.schedule, color: Colors.tealAccent, size: 28),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Guided Routine Flow',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Stay locked into your active daily habits with guided screen timers.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            // Routine Selectors
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_routines.length, (index) {
                  final isSelected = index == _selectedRoutine;
                  final r = _routines[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text('${r['title']} (${r['duration']})'),
                      selected: isSelected,
                      selectedColor: Colors.indigo,
                      onSelected: (_) => _selectRoutine(index),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            // Active Step Timer Display
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.teal.withAlpha(100)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'STEP ${_currentStepIndex + 1} OF ${steps.length}',
                      style: const TextStyle(
                        color: Colors.tealAccent,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentStep['name'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _formatTime(_stepSecondsLeft),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigoAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isTimerActive ? _pauseTimer : _startStepTimer,
                          icon: Icon(_isTimerActive ? Icons.pause : Icons.play_arrow),
                          label: Text(_isTimerActive ? 'Pause' : 'Start Step'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: _nextStep,
                          icon: const Icon(Icons.skip_next, color: Colors.white),
                          label: const Text('Next Step',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Routine Checklist',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: steps.length,
              itemBuilder: (context, index) {
                final isDone = index < _currentStepIndex;
                final isCurrent = index == _currentStepIndex;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? Colors.indigo.withAlpha(80)
                        : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCurrent ? Colors.indigoAccent : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isDone
                            ? Icons.check_circle
                            : (isCurrent
                                ? Icons.play_circle_fill
                                : Icons.radio_button_unchecked),
                        color: isDone
                            ? Colors.green
                            : (isCurrent ? Colors.indigoAccent : Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          steps[index]['name'] as String,
                          style: TextStyle(
                            color: isDone ? Colors.grey : Colors.white,
                            decoration: isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                      Text(
                        '${(steps[index]['seconds'] as int) ~/ 60} min',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 3: MICRO DECISION HELPER
// -----------------------------------------------------------------------------
class DecisionStudioTab extends StatefulWidget {
  const DecisionStudioTab({super.key});

  @override
  State<DecisionStudioTab> createState() => _DecisionStudioTabState();
}

class _DecisionStudioTabState extends State<DecisionStudioTab> {
  final List<String> _breakIdeas = [
    'Take a 10-minute walk outside without phone',
    'Drink 500ml of cold water and stretch arms',
    'Do 15 quick pushups or air squats',
    'Read 5 pages of a non-fiction book',
    'Listen to 1 calming instrumental song',
  ];

  final List<String> _quickMealIdeas = [
    'High-Protein Scrambled Eggs & Toast',
    'Quick Veggie Rice Bowl with Soy Sauce',
    'Oatmeal with Peanut Butter & Banana',
    'Tuna Salad Wrap with Greens',
    'Greek Yogurt with Nuts & Honey',
  ];

  String _selectedDecision = 'Tap below to solve a micro-decision fatigue!';

  void _pickRandom(List<String> options) {
    final index = DateTime.now().millisecondsSinceEpoch % options.length;
    setState(() {
      _selectedDecision = options[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.lightbulb, color: Colors.amberAccent, size: 28),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Micro-Decision Solver',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Eliminate paralysis by analysis for daily routine micro-decisions.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.amber, width: 0.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(Icons.casino, size: 40, color: Colors.amberAccent),
                    const SizedBox(height: 12),
                    Text(
                      _selectedDecision,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Instant Decision Roulettes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _pickRandom(_breakIdeas),
                icon: const Icon(Icons.directions_walk),
                label: const Text('Pick My 15-Min Break Activity'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _pickRandom(_quickMealIdeas),
                icon: const Icon(Icons.restaurant),
                label: const Text('Pick A Fast Healthy Meal Idea'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '3-Rule Buying Checklist',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigoAccent,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('1. Can I wait 48 hours before buying?',
                      style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 4),
                  Text('2. Do I own something that serves the exact same purpose?',
                      style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 4),
                  Text('3. Will this item matter in 30 days?',
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 4: SAVINGS VAULT & DASHBOARD
// -----------------------------------------------------------------------------
class VaultStatsTab extends StatelessWidget {
  final double totalSavedMoney;
  final double totalHoursSaved;
  final int totalFocusMinutes;
  final int streakDays;
  final List<String> savedLog;

  const VaultStatsTab({
    super.key,
    required this.totalSavedMoney,
    required this.totalHoursSaved,
    required this.totalFocusMinutes,
    required this.streakDays,
    required this.savedLog,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.savings, color: Colors.greenAccent, size: 28),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Saved Vault & Impact',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Track your saved money, preserved work hours, and focus streak.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            // Grid of key metric cards
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _buildStatCard(
                  title: 'Total Money Saved',
                  value: '\$${totalSavedMoney.toStringAsFixed(2)}',
                  icon: Icons.monetization_on,
                  color: Colors.greenAccent,
                ),
                _buildStatCard(
                  title: 'Life Work-Hours',
                  value: '${totalHoursSaved.toStringAsFixed(1)} hrs',
                  icon: Icons.work_history,
                  color: Colors.tealAccent,
                ),
                _buildStatCard(
                  title: 'Guided Focus Mins',
                  value: '$totalFocusMinutes mins',
                  icon: Icons.timer,
                  color: Colors.indigoAccent,
                ),
                _buildStatCard(
                  title: 'Habit Streak',
                  value: '$streakDays Days',
                  icon: Icons.local_fire_department,
                  color: Colors.orangeAccent,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Impulse Savings History',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            if (savedLog.isEmpty)
              const Text('No saved impulses logged yet.',
                  style: TextStyle(color: Colors.grey))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: savedLog.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color(0xFF1E293B),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.check_circle, color: Colors.greenAccent),
                      title: Text(
                        savedLog[index],
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}