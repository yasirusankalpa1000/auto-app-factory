import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MicroFlowApp());
}

class MicroFlowApp extends StatelessWidget {
  const MicroFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MicroFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF12141D),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
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

  // Shared application state
  double _totalSavedMoney = 0.0;
  int _completedFocusSessions = 0;
  int _totalFocusMinutes = 0;

  void _addSavedMoney(double amount) {
    setState(() {
      _totalSavedMoney += amount;
    });
  }

  void _addFocusSession(int minutes) {
    setState(() {
      _completedFocusSessions += 1;
      _totalFocusMinutes += minutes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      FocusTimerView(onSessionComplete: _addFocusSession),
      ImpulseCalculatorView(onMoneySaved: _addSavedMoney),
      const DecisionWheelView(),
      MicroStatsView(
        totalSavedMoney: _totalSavedMoney,
        completedSessions: _completedFocusSessions,
        totalFocusMinutes: _totalFocusMinutes,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A1D2A),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Focus Flow',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Impulse Friction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.casino),
            label: 'Decide',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Daily Pulse',
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 1: FOCUS FLOW TIMER (High Dwell Time Ambient Screen)
// ============================================================================
class FocusTimerView extends StatefulWidget {
  final Function(int minutes) onSessionComplete;

  const FocusTimerView({super.key, required this.onSessionComplete});

  @override
  State<FocusTimerView> createState() => _FocusTimerViewState();
}

class _FocusTimerViewState extends State<FocusTimerView> {
  int _selectedDurationMinutes = 25;
  int _remainingSeconds = 25 * 60;
  bool _isRunning = false;
  Timer? _timer;
  String _currentGoal = '';
  final TextEditingController _goalController = TextEditingController();

  @override
  void dispose() {
    _timer?.cancel();
    _goalController.dispose();
    super.dispose();
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
        _timer?.cancel();
        setState(() {
          _isRunning = false;
        });
        widget.onSessionComplete(_selectedDurationMinutes);
        _showCompletionDialog();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _selectedDurationMinutes * 60;
    });
  }

  void _setDuration(int minutes) {
    _timer?.cancel();
    setState(() {
      _selectedDurationMinutes = minutes;
      _remainingSeconds = minutes * 60;
      _isRunning = false;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1D2A),
        title: const Text('Focus Session Completed! 🎉', style: TextStyle(color: Colors.tealAccent)),
        content: Text(
          'Great job staying focused for $_selectedDurationMinutes minutes! Take a 5-minute break.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.tealAccent)),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (_selectedDurationMinutes * 60 - _remainingSeconds) /
        (_selectedDurationMinutes * 60 == 0 ? 1 : _selectedDurationMinutes * 60);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Focus Rhythm Studio',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.bolt, color: Colors.tealAccent, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Deep Work',
                      style: TextStyle(color: Colors.tealAccent, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Keep this screen open while working to track ambient progress.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          const SizedBox(height: 24),
          // Timer Wheel Display
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: CircularProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    color: Colors.tealAccent,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(_remainingSeconds),
                      style: const TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isRunning ? 'STAY FOCUSED' : 'PAUSED',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _isRunning ? Colors.tealAccent : Colors.amberAccent,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Duration Selection Wrap
          const Text('Select Focus Duration', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [10, 15, 25, 45, 60].map((mins) {
              final isSelected = _selectedDurationMinutes == mins;
              return ChoiceChip(
                label: Text('${mins}m'),
                selected: isSelected,
                selectedColor: Colors.teal,
                backgroundColor: const Color(0xFF1A1D2A),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                onSelected: (selected) {
                  if (selected) _setDuration(mins);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          // Micro Goal Input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1D2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.tealAccent, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _goalController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Current Single Task Goal...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onChanged: (val) {
                      setState(() {
                        _currentGoal = val;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Play / Pause / Reset Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filled(
                iconSize: 32,
                style: IconButton.styleFrom(
                  backgroundColor: _isRunning ? Colors.amber : Colors.tealAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.all(16),
                ),
                icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                onPressed: _isRunning ? _pauseTimer : _startTimer,
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.grey),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text('Reset'),
                onPressed: _resetTimer,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 2: IMPULSE FRICTION & COOL-DOWN CALCULATOR
// ============================================================================
class ImpulseCalculatorView extends StatefulWidget {
  final Function(double) onMoneySaved;

  const ImpulseCalculatorView({super.key, required this.onMoneySaved});

  @override
  State<ImpulseCalculatorView> createState() => _ImpulseCalculatorViewState();
}

class _ImpulseCalculatorViewState extends State<ImpulseCalculatorView> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _wageController = TextEditingController();

  double _calculatedWorkHours = 0.0;
  double _calculatedPrice = 0.0;
  String _itemName = '';
  bool _showFriction = false;

  // Cool-down timer
  int _coolDownSeconds = 30;
  bool _isCoolingDown = false;
  Timer? _coolDownTimer;

  @override
  void dispose() {
    _itemController.dispose();
    _priceController.dispose();
    _wageController.dispose();
    _coolDownTimer?.cancel();
    super.dispose();
  }

  void _calculateFriction() {
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final wage = double.tryParse(_wageController.text) ?? 15.0; // default \$15/hr

    if (price <= 0) return;

    setState(() {
      _calculatedPrice = price;
      _calculatedWorkHours = price / (wage > 0 ? wage : 1.0);
      _itemName = _itemController.text.isEmpty ? 'Impulse Item' : _itemController.text;
      _showFriction = true;
      _startCoolDown();
    });
  }

  void _startCoolDown() {
    _coolDownTimer?.cancel();
    setState(() {
      _coolDownSeconds = 30;
      _isCoolingDown = true;
    });

    _coolDownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_coolDownSeconds > 0) {
        setState(() {
          _coolDownSeconds--;
        });
      } else {
        _coolDownTimer?.cancel();
        setState(() {
          _isCoolingDown = false;
        });
      }
    });
  }

  void _markSaved() {
    widget.onMoneySaved(_calculatedPrice);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.teal,
        content: Text('Awesome! You saved \$${_calculatedPrice.toStringAsFixed(2)}!'),
      ),
    );
    _resetForm();
  }

  void _resetForm() {
    _coolDownTimer?.cancel();
    setState(() {
      _showFriction = false;
      _isCoolingDown = false;
      _itemController.clear();
      _priceController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Impulse Friction Calculator',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Convert purchases into work hours before buying to curb impulse spending.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Inputs Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1D2A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _itemController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'What do you want to buy?',
                    labelStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.shopping_cart, color: Colors.tealAccent),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Price (\$)',
                          labelStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.attach_money, color: Colors.amberAccent),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _wageController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Hourly Pay (\$)',
                          labelStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.schedule, color: Colors.lightBlueAccent),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calculate Life Cost', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: _calculateFriction,
                  ),
                ),
              ],
            ),
          ),

          if (_showFriction) ...[
            const SizedBox(height: 20),
            // Friction Result View
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF231B2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.deepOrange.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber, color: Colors.deepOrangeAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Reality Check for "$_itemName"',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white70, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Required Work Time:', style: TextStyle(color: Colors.grey)),
                      Flexible(
                        child: Text(
                          '${_calculatedWorkHours.toStringAsFixed(1)} Hours',
                          style: const TextStyle(
                            color: Colors.amberAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('1-Year Invested Potential:', style: TextStyle(color: Colors.grey)),
                      Flexible(
                        child: Text(
                          '\$${(_calculatedPrice * 1.08).toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.tealAccent,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Cool-Down Mandatory Timer
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _isCoolingDown
                              ? 'Mandatory Cooling Pause: $_coolDownSecondss'
                              : 'Cooling Pause Completed!',
                          style: TextStyle(
                            color: _isCoolingDown ? Colors.amberAccent : Colors.tealAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Take a moment to ask: "Do I truly need this right now?"',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Action choices
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey.withOpacity(0.2),
                          ),
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('I Decided Not to Buy'),
                          onPressed: _isCoolingDown ? null : _markSaved,
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        style: TextButton.styleFrom(foregroundColor: Colors.grey),
                        onPressed: _resetForm,
                        child: const Text('Bought It'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 3: DAILY DECISION ELIMINATOR (Micro Decision Wheel)
// ============================================================================
class DecisionWheelView extends StatefulWidget {
  const DecisionWheelView({super.key});

  @override
  State<DecisionWheelView> createState() => _DecisionWheelViewState();
}

class _DecisionWheelViewState extends State<DecisionWheelView> {
  final TextEditingController _choiceController = TextEditingController();
  List<String> _options = ['Cook Healthy Meal', 'Order Takeout', 'Quick Salad', 'Meal Prep'];
  String? _selectedResult;
  bool _isSpinning = false;

  @override
  void dispose() {
    _choiceController.dispose();
    super.dispose();
  }

  void _addOption() {
    final text = _choiceController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _options.add(text);
        _choiceController.clear();
      });
    }
  }

  void _removeOption(int index) {
    if (_options.length > 2) {
      setState(() {
        _options.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keep at least 2 options to decide!')),
      );
    }
  }

  void _spinDecision() {
    if (_options.isEmpty || _isSpinning) return;

    setState(() {
      _isSpinning = true;
      _selectedResult = null;
    });

    int counter = 0;
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      counter++;
      setState(() {
        _selectedResult = _options[counter % _options.length];
      });

      if (counter > 20) {
        timer.cancel();
        setState(() {
          _isSpinning = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Decision Eliminator',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Stop suffering from choice paralysis. Add options and let chance decide.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Add option input row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _choiceController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Add an option (e.g. Work out 20m)',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onSubmitted: (_) => _addOption(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: Colors.teal),
                icon: const Icon(Icons.add),
                onPressed: _addOption,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Decision Spin Stage Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1D2A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Icon(Icons.casino, size: 48, color: Colors.tealAccent),
                const SizedBox(height: 12),
                Text(
                  _selectedResult ?? 'Ready to Decide?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _isSpinning
                        ? Colors.amberAccent
                        : (_selectedResult != null ? Colors.tealAccent : Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _isSpinning ? null : _spinDecision,
                    child: Text(_isSpinning ? 'Choosing...' : 'Make Decision'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text('Current Options List:', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),

          // Options List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _options.length,
            itemBuilder: (context, index) {
              return Card(
                color: const Color(0xFF1F2333),
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.teal.withOpacity(0.3),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(fontSize: 11, color: Colors.tealAccent),
                    ),
                  ),
                  title: Text(
                    _options[index],
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 18),
                    onPressed: () => _removeOption(index),
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

// ============================================================================
// TAB 4: MICRO-ENERGY LOG & DAILY PULSE STATS
// ============================================================================
class MicroStatsView extends StatefulWidget {
  final double totalSavedMoney;
  final int completedSessions;
  final int totalFocusMinutes;

  const MicroStatsView({
    super.key,
    required this.totalSavedMoney,
    required this.completedSessions,
    required this.totalFocusMinutes,
  });

  @override
  State<MicroStatsView> createState() => _MicroStatsViewState();
}

class _MicroStatsViewState extends State<MicroStatsView> {
  int _currentEnergyRating = 3;
  final List<String> _energyLogs = [];

  void _logEnergy(int rating) {
    final now = DateTime.now();
    final timeStr = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    setState(() {
      _currentEnergyRating = rating;
      _energyLogs.insert(0, '[$timeStr] Energy Level: $rating/5 Stars');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Energy level logged!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Pulse & Micro Metrics',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Track energy levels and review focus savings throughout the day.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Overview Grid Cards
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Saved Impulse',
                  value: '\$${widget.totalSavedMoney.toStringAsFixed(2)}',
                  icon: Icons.monetization_on,
                  color: Colors.tealAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: 'Focus Time',
                  value: '${widget.totalFocusMinutes}m',
                  icon: Icons.timer,
                  color: Colors.amberAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Energy Rating Logger Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1D2A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.bolt, color: Colors.amber, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Log Current Energy Level',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(5, (index) {
                    final rating = index + 1;
                    final isSelected = rating <= _currentEnergyRating;
                    return IconButton(
                      icon: Icon(
                        isSelected ? Icons.star : Icons.star_border,
                        color: isSelected ? Colors.amber : Colors.grey,
                        size: 28,
                      ),
                      onPressed: () => _logEnergy(rating),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text('Energy History Today:', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),

          _energyLogs.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1D2A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'No energy checks logged yet today.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _energyLogs.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: const Color(0xFF1F2333),
                      margin: const EdgeInsets.only(bottom: 6),
                      child: ListTile(
                        dense: true,
                        leading: const Icon(Icons.history, color: Colors.tealAccent, size: 18),
                        title: Text(
                          _energyLogs[index],
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}