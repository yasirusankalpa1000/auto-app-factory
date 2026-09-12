import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const DowntimeApp());
}

class DowntimeApp extends StatelessWidget {
  const DowntimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Downtime',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
          primary: Colors.indigo,
          secondary: Colors.teal,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        cardTheme: CardTheme(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  // Global App Stats
  int _totalDowntimeMinutesSaved = 38;
  double _totalMoneySaved = 145.50;
  int _completedRoutines = 12;
  int _dailyStreak = 4;

  void _addSavedStats(int minutes, double money) {
    setState(() {
      _totalDowntimeMinutesSaved += minutes;
      _totalMoneySaved += money;
      _completedRoutines += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      MicroGapTab(onCompleteRoutine: (mins) => _addSavedStats(mins, 0)),
      UrgeSurferTab(onSaveImpulseMoney: (cash) => _addSavedStats(3, cash)),
      QuickToolsTab(onToolCompleted: (mins) => _addSavedStats(mins, 0)),
      ImpactStatsTab(
        minutesSaved: _totalDowntimeMinutesSaved,
        moneySaved: _totalMoneySaved,
        routinesCompleted: _completedRoutines,
        streak: _dailyStreak,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Micro-Gap',
          ),
          NavigationDestination(
            icon: Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield),
            label: 'Urge Surfer',
          ),
          NavigationDestination(
            icon: Icon(Icons.widgets_outlined),
            selectedIcon: Icon(Icons.widgets),
            label: 'Tools',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'Impact',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TAB 1: MICRO-GAP ROUTINE ACTIVATOR
// ==========================================

class MicroGapTab extends StatefulWidget {
  final Function(int minutes) onCompleteRoutine;
  const MicroGapTab({super.key, required this.onCompleteRoutine});

  @override
  State<MicroGapTab> createState() => _MicroGapTabState();
}

class _MicroGapTabState extends State<MicroGapTab> {
  int _selectedDuration = 3; // minutes
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _routines = [
    {
      'title': 'Desk Posture & Spine Unlock',
      'category': 'Physical',
      'duration': 3,
      'icon': Icons.accessibility_new,
      'color': Colors.indigo,
      'steps': [
        'Roll shoulders backward 10 times slowly',
        'Seated torso twist (hold 15s each side)',
        'Chin tucks to align cervical spine',
        'Standing forward fold stretch'
      ],
    },
    {
      'title': 'Digital Declutter Sprint',
      'category': 'Productivity',
      'duration': 2,
      'icon': Icons.cleaning_services,
      'color': Colors.teal,
      'steps': [
        'Delete 5 unneeded camera photos',
        'Unsubscribe from 2 promotional emails',
        'Close extra unused browser tabs',
        'Clear phone downloads folder'
      ],
    },
    {
      'title': '3-Minute Brain Sharpener',
      'category': 'Mind',
      'duration': 3,
      'icon': Icons.psychology,
      'color': Colors.purple,
      'steps': [
        'Name 5 red objects in your current room',
        'Count backward from 100 by 7s',
        'Recall what you ate for lunch 2 days ago',
        'Take 3 deep box breaths (4s in, 4s hold, 4s out)'
      ],
    },
    {
      'title': 'Quick Hydration & Hydrate Reset',
      'category': 'Health',
      'duration': 1,
      'icon': Icons.local_water,
      'color': Colors.blue,
      'steps': [
        'Pour a full glass of fresh water',
        'Drink slowly in 5 mindful sips',
        'Splash cold water on face or wrist',
        'Take 1 deep cleansing exhale'
      ],
    },
    {
      'title': 'Pocket Workspace Micro-Tidy',
      'category': 'Environment',
      'duration': 5,
      'icon': Icons.dry_cleaning,
      'color': Colors.amber,
      'steps': [
        'Wipe down your smartphone screen',
        'Throw away surrounding paper receipts',
        'Organize cables on your surface',
        'Align keyboard and desk items'
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredRoutines = _routines.where((r) {
      final matchesDuration = r['duration'] <= _selectedDuration;
      final matchesCategory = _selectedCategory == 'All' || r['category'] == _selectedCategory;
      return matchesDuration && matchesCategory;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Got a Micro-Gap?',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Turn idle waiting minutes into quick wins.',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              const CircleAvatar(
                backgroundColor: Colors.indigo,
                child: Icon(Icons.bolt, color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 20),

          // Duration Selector
          const Text(
            'How much time do you have?',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [1, 2, 3, 5, 10].map((mins) {
                final isSelected = _selectedDuration == mins;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text('$mins min'),
                    selected: isSelected,
                    selectedColor: Colors.indigo,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedDuration = mins);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Category Selector
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['All', 'Physical', 'Productivity', 'Mind', 'Health', 'Environment'].map((cat) {
              final isSelected = _selectedCategory == cat;
              return FilterChip(
                label: Text(cat, style: const TextStyle(fontSize: 12)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _selectedCategory = cat);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Routine Cards List
          if (filteredRoutines.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: const [
                  Icon(Icons.hourglass_empty, color: Colors.grey, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'No activities found under this duration filter.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredRoutines.length,
              itemBuilder: (context, index) {
                final item = filteredRoutines[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: (item['color'] as Color).withOpacity(0.15),
                              child: Icon(item['icon'] as IconData, color: item['color'] as Color),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${item['category']} • ${item['duration']} Min Session',
                                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            _startRoutineModal(context, item);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: item['color'] as Color,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 40),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.play_arrow, size: 18),
                          label: const Text('Start Micro Activity'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  void _startRoutineModal(BuildContext context, Map<String, dynamic> routine) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return RoutineExecutionView(
          routine: routine,
          onFinish: () {
            widget.onCompleteRoutine(routine['duration'] as int);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Awesome! You reclaimed ${routine['duration']} idle minutes!'),
                backgroundColor: Colors.green,
              ),
            );
          },
        );
      },
    );
  }
}

class RoutineExecutionView extends StatefulWidget {
  final Map<String, dynamic> routine;
  final VoidCallback onFinish;

  const RoutineExecutionView({super.key, required this.routine, required this.onFinish});

  @override
  State<RoutineExecutionView> createState() => _RoutineExecutionViewState();
}

class _RoutineExecutionViewState extends State<RoutineExecutionView> {
  late int _remainingSeconds;
  Timer? _timer;
  late List<bool> _completedSteps;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = (widget.routine['duration'] as int) * 60;
    _completedSteps = List<bool>.filled((widget.routine['steps'] as List).length, false);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final steps = widget.routine['steps'] as List<String>;
    final mins = _remainingSeconds ~/ 60;
    final secs = _remainingSeconds % 60;
    final timeStr = '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.routine['title'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      timeStr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Complete these micro-tasks:',
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              ...List.generate(steps.length, (idx) {
                return CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    steps[idx],
                    style: TextStyle(
                      decoration: _completedSteps[idx] ? TextDecoration.lineThrough : null,
                      color: _completedSteps[idx] ? Colors.grey : Colors.black,
                    ),
                  ),
                  value: _completedSteps[idx],
                  activeColor: widget.routine['color'] as Color,
                  onChanged: (val) {
                    setState(() {
                      _completedSteps[idx] = val ?? false;
                    });
                  },
                );
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: widget.onFinish,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.routine['color'] as Color,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Complete & Claim Time', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// TAB 2: URGE SURFER & TRUE COST CALCULATOR
// ==========================================

class UrgeSurferTab extends StatefulWidget {
  final Function(double money) onSaveImpulseMoney;
  const UrgeSurferTab({super.key, required this.onSaveImpulseMoney});

  @override
  State<UrgeSurferTab> createState() => _UrgeSurferTabState();
}

class _UrgeSurferTabState extends State<UrgeSurferTab> {
  final TextEditingController _itemController = TextEditingController(text: 'Designer Sneakers');
  final TextEditingController _priceController = TextEditingController(text: '85.00');
  final TextEditingController _wageController = TextEditingController(text: '15.00');

  bool _isSurfing = false;
  int _surfSecondsLeft = 180; // 3 minute surge surfing delay
  Timer? _surfTimer;

  double get _hoursOfLabor {
    final price = double.tryParse(_priceController.text) ?? 0;
    final wage = double.tryParse(_wageController.text) ?? 1;
    if (wage <= 0) return 0;
    return price / wage;
  }

  void _startUrgeSurfing() {
    setState(() {
      _isSurfing = true;
      _surfSecondsLeft = 180;
    });

    _surfTimer?.cancel();
    _surfTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_surfSecondsLeft > 0) {
        setState(() => _surfSecondsLeft--);
      } else {
        _surfTimer?.cancel();
      }
    });
  }

  void _stopSurfing(bool savedMoney) {
    _surfTimer?.cancel();
    final price = double.tryParse(_priceController.text) ?? 0;

    setState(() {
      _isSurfing = false;
    });

    if (savedMoney && price > 0) {
      widget.onSaveImpulseMoney(price);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved \$${price.toStringAsFixed(2)}! Added to your lifetime savings.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _surfTimer?.cancel();
    _itemController.dispose();
    _priceController.dispose();
    _wageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final priceVal = double.tryParse(_priceController.text) ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              CircleAvatar(
                backgroundColor: Colors.deepOrange,
                child: Icon(Icons.shield, color: Colors.white),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Urge Surfer & Value Shield',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                    Text(
                      'Delay impulse buys and convert price into raw human life hours.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (!_isSurfing) ...[
            // Input Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'What micro-impulse are you tempted to buy?',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _itemController,
                      decoration: const InputDecoration(
                        labelText: 'Item Name / Impulse',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.shopping_bag_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              labelText: 'Price (\$)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.attach_money),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _wageController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              labelText: 'Hourly Wage (\$)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.work_outline),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Reality Visualizer Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.indigo.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'TRUE LABOR COST',
                    style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_hoursOfLabor.toStringAsFixed(1)} Hours',
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'You must trade ${_hoursOfLabor.toStringAsFixed(1)} hours of your hard life effort for "${_itemController.text}". Is it worth it?',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _startUrgeSurfing,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.air),
              label: const Text(
                'Surf The Urge (3-Min Delay Protocol)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ] else ...[
            // Active Urge Surfing View
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.teal),
              ),
              child: Column(
                children: [
                  const Icon(Icons.self_improvement, size: 60, color: Colors.teal),
                  const SizedBox(height: 12),
                  const Text(
                    'Riding the Impulse Wave...',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Impulse desires naturally peak and fade within 3 minutes. Focus on your breathing.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black87, fontSize: 13),
                    softWrap: true,
                  ),
                  const SizedBox(height: 24),

                  // Timer Display
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 130,
                        height: 130,
                        child: CircularProgressIndicator(
                          value: _surfSecondsLeft / 180,
                          strokeWidth: 8,
                          backgroundColor: Colors.teal.shade100,
                          color: Colors.teal,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_surfSecondsLeft ~/ 60}:${(_surfSecondsLeft % 60).toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                          const Text('Remaining', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _stopSurfing(false),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 44),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          child: const Text('I Bought It', style: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _stopSurfing(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 44),
                          ),
                          child: Text('Resisted \$${priceVal.toStringAsFixed(0)}!'),
                        ),
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

// ==========================================
// TAB 3: QUICK MICRO-TOOLS
// ==========================================

class QuickToolsTab extends StatelessWidget {
  final Function(int minutes) onToolCompleted;
  const QuickToolsTab({super.key, required this.onToolCompleted});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              CircleAvatar(
                backgroundColor: Colors.purple,
                child: Icon(Icons.widgets, color: Colors.white),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Micro Downtime Helpers',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                    Text(
                      'Instant interactive tools for 60-second breaks.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Tool 1: 20-20-20 Eye Rest Tool
          _buildToolCard(
            context,
            title: '20-20-20 Eye Relief',
            subtitle: 'Look at an object 20 feet away for 20 seconds to prevent screen fatigue.',
            icon: Icons.visibility,
            color: Colors.blue,
            onTap: () {
              _showEyeRestModal(context);
            },
          ),
          const SizedBox(height: 12),

          // Tool 2: 1-Minute Rapid Gratitude Flash
          _buildToolCard(
            context,
            title: '60-Sec Micro Gratitude',
            subtitle: 'Quickly lock in 3 simple things working well right now.',
            icon: Icons.favorite,
            color: Colors.pink,
            onTap: () {
              _showGratitudeModal(context);
            },
          ),
          const SizedBox(height: 12),

          // Tool 3: Mind Focus Tapper Mini Game
          _buildToolCard(
            context,
            title: 'Mental Clarity Tapper',
            subtitle: 'Tap moving target spots to quickly reset brain sluggishness.',
            icon: Icons.touch_app,
            color: Colors.amber,
            onTap: () {
              _showTapGameModal(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      softWrap: true,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showEyeRestModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return const EyeRestWidget();
      },
    );
  }

  void _showGratitudeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return const GratitudeWidget();
      },
    );
  }

  void _showTapGameModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return const TapGameWidget();
      },
    );
  }
}

// Modal Widget: Eye Rest
class EyeRestWidget extends StatefulWidget {
  const EyeRestWidget({super.key});

  @override
  State<EyeRestWidget> createState() => _EyeRestWidgetState();
}

class _EyeRestWidgetState extends State<EyeRestWidget> {
  int _secondsLeft = 20;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.visibility, color: Colors.blue, size: 50),
            const SizedBox(height: 12),
            const Text('Focus Far Away', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'Look out a window or focus on a distant wall/object at least 20 feet away.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
              softWrap: true,
            ),
            const SizedBox(height: 20),
            Text('$_secondsLeft s', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 44),
              ),
              child: const Text('Done Refreshing Eyes'),
            ),
          ],
        ),
      ),
    );
  }
}

// Modal Widget: Micro Gratitude
class GratitudeWidget extends StatefulWidget {
  const GratitudeWidget({super.key});

  @override
  State<GratitudeWidget> createState() => _GratitudeWidgetState();
}

class _GratitudeWidgetState extends State<GratitudeWidget> {
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('60-Second Micro Gratitude', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Name 3 small things you are glad exist right now.', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 16),
              TextField(
                controller: _controllers[0],
                decoration: const InputDecoration(labelText: '1. Something small (e.g. Warm coffee)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _controllers[1],
                decoration: const InputDecoration(labelText: '2. A person or pet', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _controllers[2],
                decoration: const InputDecoration(labelText: '3. A comfortable amenity', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mindset reframed! Great job.'), backgroundColor: Colors.pink),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 44),
                ),
                child: const Text('Save Micro Gratitude'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Modal Widget: Clarity Tap Mini-Game
class TapGameWidget extends StatefulWidget {
  const TapGameWidget({super.key});

  @override
  State<TapGameWidget> createState() => _TapGameWidgetState();
}

class _TapGameWidgetState extends State<TapGameWidget> {
  int _score = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Quick Clarity Tap', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Chip(label: Text('Score: $_score', style: const TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Tap the targets below to break brain fatigue!', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: List.generate(6, (index) {
                return InkWell(
                  onTap: () {
                    setState(() => _score += 10);
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: index % 2 == 0 ? Colors.amber : Colors.teal,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bolt, color: Colors.white, size: 30),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 44),
              ),
              child: const Text('Done Tapping', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// TAB 4: IMPACT STATS TRACKER
// ==========================================

class ImpactStatsTab extends StatelessWidget {
  final int minutesSaved;
  final double moneySaved;
  final int routinesCompleted;
  final int streak;

  const ImpactStatsTab({
    super.key,
    required this.minutesSaved,
    required this.moneySaved,
    required this.routinesCompleted,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              CircleAvatar(
                backgroundColor: Colors.teal,
                child: Icon(Icons.insights, color: Colors.white),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Lifetime Impact',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                    Text(
                      'See what micro-gap discipline adds up to.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Main Stats Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatBox(
                'Downtime Saved',
                '$minutesSaved Mins',
                Icons.hourglass_top,
                Colors.indigo,
              ),
              _buildStatBox(
                'Money Saved',
                '\$${moneySaved.toStringAsFixed(2)}',
                Icons.monetization_on,
                Colors.green,
              ),
              _buildStatBox(
                'Routines Done',
                '$routinesCompleted Tasks',
                Icons.check_circle,
                Colors.teal,
              ),
              _buildStatBox(
                'Active Streak',
                '$streak Days',
                Icons.local_fire_department,
                Colors.deepOrange,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Community Encouragement Card
          Card(
            color: Colors.indigo.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: const [
                  Icon(Icons.star, color: Colors.indigo, size: 36),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Micro-Habit Champion!',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.indigo),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'By reclaiming small pockets of waiting time, you gain up to 10 full days of active life back per year!',
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                          softWrap: true,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
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
                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                  softWrap: true,
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ],
      ),
    );
  }
}