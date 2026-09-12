import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MicroRhythmApp());
}

class MicroRhythmApp extends StatelessWidget {
  const MicroRhythmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MicroRhythm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF12141E),
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.amberAccent,
          surface: Color(0xFF1E2230),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class ImpulseItem {
  final String title;
  final double estimatedCost;
  final DateTime timestamp;
  final bool resisted;

  ImpulseItem({
    required this.title,
    required this.estimatedCost,
    required this.timestamp,
    required this.resisted,
  });
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Global shared state
  double _totalMoneySaved = 45.50;
  int _willpowerScore = 85;
  int _focusSessionsCompleted = 6;
  final List<ImpulseItem> _impulseLogs = [
    ImpulseItem(
      title: 'Late Night Fast Food',
      estimatedCost: 14.50,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      resisted: true,
    ),
    ImpulseItem(
      title: 'Impulse Tech Gadget',
      estimatedCost: 31.00,
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      resisted: true,
    ),
  ];

  void _addSavedImpulse(String title, double cost, bool resisted) {
    setState(() {
      _impulseLogs.insert(
        0,
        ImpulseItem(
          title: title,
          estimatedCost: cost,
          timestamp: DateTime.now(),
          resisted: resisted,
        ),
      );
      if (resisted) {
        _totalMoneySaved += cost;
        _willpowerScore = min(100, _willpowerScore + 5);
      } else {
        _willpowerScore = max(0, _willpowerScore - 5);
      }
    });
  }

  void _incrementFocus() {
    setState(() {
      _focusSessionsCompleted++;
      _willpowerScore = min(100, _willpowerScore + 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ImpulseGuardTab(
        onLogImpulse: _addSavedImpulse,
        totalSaved: _totalMoneySaved,
      ),
      MicroFocusTab(
        onSessionComplete: _incrementFocus,
      ),
      const MicroDecisionTab(),
      DashboardTab(
        totalSaved: _totalMoneySaved,
        willpowerScore: _willpowerScore,
        focusSessions: _focusSessionsCompleted,
        impulseLogs: _impulseLogs,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF181C28),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: 'Impulse Guard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            label: 'Desk Focus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.casino),
            label: 'Decide',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Rhythm Log',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TAB 1: IMPULSE GUARD (Craving & Spend Cooling)
// ==========================================
class ImpulseGuardTab extends StatefulWidget {
  final Function(String, double, bool) onLogImpulse;
  final double totalSaved;

  const ImpulseGuardTab({
    super.key,
    required this.onLogImpulse,
    required this.totalSaved,
  });

  @override
  State<ImpulseGuardTab> createState() => _ImpulseGuardTabState();
}

class _ImpulseGuardTabState extends State<ImpulseGuardTab> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  int _selectedMinutes = 5;
  Timer? _timer;
  int _secondsRemaining = 0;
  bool _isTimerRunning = false;
  String _activeItem = '';
  double _activeCost = 0.0;

  void _startCoolingTimer() {
    final itemStr = _itemController.text.trim();
    final costStr = _costController.text.trim();

    if (itemStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter what you feel like buying/doing')),
      );
      return;
    }

    final double cost = double.tryParse(costStr) ?? 0.0;

    setState(() {
      _activeItem = itemStr;
      _activeCost = cost;
      _secondsRemaining = _selectedMinutes * 60;
      _isTimerRunning = true;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        _completeTimer(resisted: true);
      }
    });
  }

  void _completeTimer({required bool resisted}) {
    _timer?.cancel();
    widget.onLogImpulse(_activeItem, _activeCost, resisted);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2230),
        title: Text(
          resisted ? '🎉 Craving Defeated!' : 'Momentary Lapse',
          style: TextStyle(
            color: resisted ? Colors.tealAccent : Colors.orangeAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          resisted
              ? 'Awesome job! You waited it out and saved \$${_activeCost.toStringAsFixed(2)} for your future self.'
              : 'It happens! Reflect on what triggered the impulse and try again next time.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isTimerRunning = false;
                _itemController.clear();
                _costController.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
              foregroundColor: Colors.black,
            ),
            child: const Text('Continue'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _itemController.dispose();
    _costController.dispose();
    super.dispose();
  }

  String _formatTimer(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E2A38), Color(0xFF14222E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.shield, color: Colors.tealAccent, size: 28),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Impulse Delay Engine',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Science proves 80% of daily micro-cravings (snacking, online buys, doomscrolling) fade if you delay gratification for just 5-15 minutes.',
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.tealAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Total Saved So Far: \$${widget.totalSaved.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.tealAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),

          if (!_isTimerRunning) ...[
            const Text(
              'What impulse are you facing right now?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _itemController,
              decoration: const InputDecoration(
                labelText: 'e.g. Ordering Boba / Buying Shoes / Gaming Gear',
                hintText: 'Describe the craving...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.shopping_bag_outlined),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _costController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Estimated Cost (\$) (Optional)',
                hintText: 'e.g. 15.00',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Select Cooling Delay Duration:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [5, 10, 15, 20].map((mins) {
                final isSelected = _selectedMinutes == mins;
                return ChoiceChip(
                  label: Text('$mins Minutes'),
                  selected: isSelected,
                  selectedColor: Colors.tealAccent,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedMinutes = mins);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _startCoolingTimer,
                icon: const Icon(Icons.timer_outlined),
                label: const Text(
                  'START COOLING TIMER',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ] else ...[
            // ACTIVE TIMER SCREEN
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2230),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.tealAccent, width: 2),
              ),
              child: Column(
                children: [
                  const Text(
                    'COOLING IN PROGRESS',
                    style: TextStyle(
                      color: Colors.tealAccent,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _activeItem,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_activeCost > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Potential Savings: \$${_activeCost.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                  ],
                  const SizedBox(height: 30),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 170,
                        height: 170,
                        child: CircularProgressIndicator(
                          value: _secondsRemaining / (_selectedMinutes * 60),
                          strokeWidth: 10,
                          backgroundColor: Colors.white70,
                          color: Colors.tealAccent,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatTimer(_secondsRemaining),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'breathe slowly',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _completeTimer(resisted: false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orangeAccent,
                            side: const BorderSide(color: Colors.orangeAccent),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('I Gave In'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _completeTimer(resisted: true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.tealAccent,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Craving Passed!',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ==========================================
// TAB 2: DESK FOCUS & EYE REST (20-20-20 Rule)
// ==========================================
class MicroFocusTab extends StatefulWidget {
  final VoidCallback onSessionComplete;

  const MicroFocusTab({super.key, required this.onSessionComplete});

  @override
  State<MicroFocusTab> createState() => _MicroFocusTabState();
}

class _MicroFocusTabState extends State<MicroFocusTab> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  Timer? _workTimer;
  int _secondsLeft = 20 * 60; // 20 min work interval
  bool _isRunning = false;
  bool _isEyeRestMode = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    _workTimer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isRunning) {
      _workTimer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _workTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsLeft > 0) {
          setState(() => _secondsLeft--);
        } else {
          _workTimer?.cancel();
          if (!_isEyeRestMode) {
            // Switch to 20-second eye rest mode
            widget.onSessionComplete();
            setState(() {
              _isEyeRestMode = true;
              _secondsLeft = 20;
            });
            _startEyeRestTimer();
          } else {
            // Back to work session
            setState(() {
              _isEyeRestMode = false;
              _secondsLeft = 20 * 60;
              _isRunning = false;
            });
          }
        }
      });
    }
  }

  void _startEyeRestTimer() {
    _workTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _workTimer?.cancel();
        setState(() {
          _isEyeRestMode = false;
          _secondsLeft = 20 * 60;
          _isRunning = false;
        });
      }
    });
  }

  void _resetTimer() {
    _workTimer?.cancel();
    setState(() {
      _isRunning = false;
      _isEyeRestMode = false;
      _secondsLeft = 20 * 60;
    });
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEyeRestMode ? '👁️ EYE REST (20 FT)' : '💻 WORK FOCUS PACE',
                    style: TextStyle(
                      color: _isEyeRestMode ? Colors.amberAccent : Colors.tealAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '20-20-20 Eye & Posture Rhythm',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
              IconButton(
                onPressed: _resetTimer,
                icon: const Icon(Icons.refresh),
                tooltip: 'Reset Timer',
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Animated Visual Breathing Ring Container (Desk Display)
          AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              final scale = _isRunning ? (1.0 + (_animController.value * 0.12)) : 1.0;
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: _isEyeRestMode
                          ? [Colors.amberAccent.withOpacity(0.4), const Color(0xFF1E2230)]
                          : [Colors.tealAccent.withOpacity(0.3), const Color(0xFF1E2230)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _isEyeRestMode
                            ? Colors.amberAccent.withOpacity(0.2)
                            : Colors.tealAccent.withOpacity(0.2),
                        blurRadius: 30,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatTime(_secondsLeft),
                          style: const TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _isEyeRestMode ? 'Look 20 feet away!' : (_isRunning ? 'In the zone' : 'Ready'),
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 36),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 160,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _toggleTimer,
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(_isRunning ? 'PAUSE' : 'START FOCUS'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isEyeRestMode ? Colors.amberAccent : Colors.tealAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Micro Posture & Eye Tip Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2230),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white70),
            ),
            child: Row(
              children: [
                const Icon(Icons.accessibility_new, color: Colors.tealAccent, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Desk Posture Reset:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Keep your screen at eye level. Every 20 mins, blink 5 times and roll your shoulders back.',
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// TAB 3: MICRO-DECISION ENGINE (Friction Killer)
// ==========================================
class MicroDecisionTab extends StatefulWidget {
  const MicroDecisionTab({super.key});

  @override
  State<MicroDecisionTab> createState() => _MicroDecisionTabState();
}

class _MicroDecisionTabState extends State<MicroDecisionTab> {
  final List<String> _presets = [
    'What to Eat?',
    'Quick 5-Min Break Activity',
    'Next Priority Task',
    'Impulse Shopping Rule',
  ];

  int _selectedCategoryIndex = 0;

  final Map<int, List<String>> _optionsMap = {
    0: ['Healthy Salad', 'Home Cooked Rice', 'Protein Smoothie', 'Light Soup', 'Fruit & Nuts'],
    1: ['20 Pushups', 'Walk Outside', 'Drink 2 Glasses Water', 'Deep Breathing', 'Listen to 1 Song'],
    2: ['Clear Unread Emails', 'Deep Work on Main Goal', 'Organize Desk', 'Call Teammate', 'Plan Tomorrow'],
    3: ['Wait 24 Hours', 'Put Money in Savings', 'Search for Used Item', 'Ask: Need or Want?', 'Skip Completely'],
  };

  final TextEditingController _customInputController = TextEditingController();
  String _selectedResult = '';
  bool _isSpinning = false;

  void _spinDecision() {
    final currentOptions = _optionsMap[_selectedCategoryIndex] ?? [];
    if (currentOptions.isEmpty) return;

    setState(() {
      _isSpinning = true;
      _selectedResult = 'Selecting...';
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      final random = Random();
      final randomIndex = random.nextInt(currentOptions.length);
      setState(() {
        _selectedResult = currentOptions[randomIndex];
        _isSpinning = false;
      });
    });
  }

  void _addCustomOption() {
    final text = _customInputController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _optionsMap[_selectedCategoryIndex]?.add(text);
        _customInputController.clear();
      });
    }
  }

  @override
  void dispose() {
    _customInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentList = _optionsMap[_selectedCategoryIndex] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Decision Solver',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Eliminate micro-friction and decision fatigue instantly.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Preset selector horizontal wrap
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_presets.length, (index) {
              final isSel = _selectedCategoryIndex == index;
              return ChoiceChip(
                label: Text(_presets[index]),
                selected: isSel,
                selectedColor: Colors.amberAccent,
                labelStyle: TextStyle(
                  color: isSel ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      _selectedCategoryIndex = index;
                      _selectedResult = '';
                    });
                  }
                },
              );
            }),
          ),
          const SizedBox(height: 24),

          // Result Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2230),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amberAccent.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                const Text(
                  'YOUR DECISION:',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _selectedResult.isEmpty ? 'Tap Spin below!' : _selectedResult,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _isSpinning ? Colors.grey : Colors.amberAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _isSpinning ? null : _spinDecision,
                  icon: const Icon(Icons.casino),
                  label: const Text('SPIN / RANDOMIZE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Current Options List & Add Custom Option
          const Text(
            'Current Choices Pool:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: currentList.map((opt) {
              return Chip(
                backgroundColor: const Color(0xFF181C28),
                label: Text(opt, style: const TextStyle(fontSize: 12)),
                onDeleted: currentList.length > 2
                    ? () {
                        setState(() {
                          currentList.remove(opt);
                        });
                      }
                    : null,
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customInputController,
                  decoration: const InputDecoration(
                    hintText: 'Add custom choice...',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _addCustomOption,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
                child: const Icon(Icons.add),
              )
            ],
          )
        ],
      ),
    );
  }
}

// ==========================================
// TAB 4: RHYTHM LOG & WILLPOWER DASHBOARD
// ==========================================
class DashboardTab extends StatelessWidget {
  final double totalSaved;
  final int willpowerScore;
  final int focusSessions;
  final List<ImpulseItem> impulseLogs;

  const DashboardTab({
    super.key,
    required this.totalSaved,
    required this.willpowerScore,
    required this.focusSessions,
    required this.impulseLogs,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Rhythm & Savings Log',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Track saved cash and mental energy throughout the day.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Grid of stats
          Row(
            children: [
              Expanded(
                child: _buildStatTile(
                  title: 'Money Saved',
                  value: '\$${totalSaved.toStringAsFixed(2)}',
                  icon: Icons.savings,
                  color: Colors.tealAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatTile(
                  title: 'Willpower Score',
                  value: '$willpowerScore%',
                  icon: Icons.psychology,
                  color: Colors.amberAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatTile(
                  title: 'Focus Sessions',
                  value: '$focusSessions done',
                  icon: Icons.timer,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatTile(
                  title: 'Craving Wins',
                  value: '${impulseLogs.where((e) => e.resisted).length} resisted',
                  icon: Icons.check_circle,
                  color: Colors.greenAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),

          const Text(
            'Recent Impulse Log:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),

          if (impulseLogs.isEmpty)
            const Text(
              'No logs yet today. Use the Impulse Guard tab when cravings strike!',
              style: TextStyle(color: Colors.grey),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: impulseLogs.length,
              itemBuilder: (context, index) {
                final log = impulseLogs[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2230),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: log.resisted ? Colors.tealAccent.withOpacity(0.3) : Colors.orangeAccent.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        log.resisted ? Icons.shield : Icons.history,
                        color: log.resisted ? Colors.tealAccent : Colors.orangeAccent,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              log.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              log.resisted
                                  ? 'Resisted impulse delay'
                                  : 'Gave in after cooling attempt',
                              style: TextStyle(color: Colors.grey[400], fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      if (log.estimatedCost > 0)
                        Text(
                          '${log.resisted ? "+" : ""}\$${log.estimatedCost.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: log.resisted ? Colors.tealAccent : Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStatTile({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2230),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}