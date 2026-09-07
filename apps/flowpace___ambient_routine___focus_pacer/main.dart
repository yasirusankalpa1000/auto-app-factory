import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const FlowPaceApp());
}

class RoutineModel {
  final String id;
  final String title;
  final String category;
  final int totalMinutes;
  final List<String> steps;
  final Color themeColor;
  final IconData icon;

  RoutineModel({
    required this.id,
    required this.title,
    required this.category,
    required this.totalMinutes,
    required this.steps,
    required this.themeColor,
    required this.icon,
  });
}

class FlowPaceApp extends StatelessWidget {
  const FlowPaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlowPace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF12151E),
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.indigoAccent,
          surface: Color(0xFF1E2230),
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

  // App Global State
  final List<RoutineModel> _routines = [
    RoutineModel(
      id: '1',
      title: 'Morning Power Speedrun',
      category: 'Morning',
      totalMinutes: 15,
      steps: ['Hydrate & Air Out Room', 'Make Bed & Tidy', 'Light Stretch', 'Plan Top 3 Priorities'],
      themeColor: Colors.amber,
      icon: Icons.wb_sunny,
    ),
    RoutineModel(
      id: '2',
      title: 'Deep Work Sprint',
      category: 'Focus',
      totalMinutes: 25,
      steps: ['Clear Workspace', 'Silence Notifications', 'Single-Task Focus Burst', 'Quick Notes Review'],
      themeColor: Colors.teal,
      icon: Icons.bolt,
    ),
    RoutineModel(
      id: '3',
      title: 'Desk & Room Declutter',
      category: 'Productivity',
      totalMinutes: 10,
      steps: ['Collect Trash & Dishes', 'Organize Cables & Tech', 'Wipe Main Surface', 'Return Items to Shelves'],
      themeColor: Colors.indigo,
      icon: Icons.cleaning_services,
    ),
    RoutineModel(
      id: '4',
      title: 'Night Reset Routine',
      category: 'Evening',
      totalMinutes: 20,
      steps: ['Prepare Tomorrow Clothes', 'Journal / Mind Dump', 'Dim Lights & Screens', 'Deep Breathing Warmdown'],
      themeColor: Colors.deepOrange,
      icon: Icons.nights_stay,
    ),
  ];

  int _todayMinutes = 45;
  int _completedSessions = 3;
  int _flowPoints = 280;
  RoutineModel? _activeRoutine;

  void _startRoutine(RoutineModel routine) {
    setState(() {
      _activeRoutine = routine;
      _currentIndex = 1; // Switch to Active Flow tab
    });
  }

  void _onRoutineCompleted(int minutesEarned) {
    setState(() {
      _todayMinutes += minutesEarned;
      _completedSessions += 1;
      _flowPoints += minutesEarned * 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      RoutinesTab(
        routines: _routines,
        onSelectRoutine: _startRoutine,
        onAddNewRoutine: (newRoutine) {
          setState(() {
            _routines.add(newRoutine);
          });
        },
      ),
      ActivePacerTab(
        routine: _activeRoutine ?? _routines[0],
        onComplete: _onRoutineCompleted,
      ),
      DecisionWheelTab(
        onStartPickedTask: (taskTitle) {
          final tempRoutine = RoutineModel(
            id: DateTime.now().toString(),
            title: taskTitle,
            category: 'Quick Decision',
            totalMinutes: 10,
            steps: ['Setup & Focus', 'Main Execution', 'Quick Wrap Up'],
            themeColor: Colors.cyan,
            icon: Icons.auto_awesome,
          );
          _startRoutine(tempRoutine);
        },
      ),
      StatsAndRewardsTab(
        todayMinutes: _todayMinutes,
        sessionsCount: _completedSessions,
        flowPoints: _flowPoints,
        onRewardClaimed: (pts) {
          setState(() {
            _flowPoints += pts;
          });
        },
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        backgroundColor: const Color(0xFF1E2230),
        indicatorColor: Colors.tealAccent.withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.apps, color: Colors.grey),
            selectedIcon: Icon(Icons.apps, color: Colors.tealAccent),
            label: 'Routines',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer, color: Colors.grey),
            selectedIcon: Icon(Icons.timer, color: Colors.tealAccent),
            label: 'Pacer',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome, color: Colors.grey),
            selectedIcon: Icon(Icons.auto_awesome, color: Colors.tealAccent),
            label: 'Decision',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics, color: Colors.grey),
            selectedIcon: Icon(Icons.analytics, color: Colors.tealAccent),
            label: 'Rewards',
          ),
        ],
      ),
    );
  }
}

// ==================== TAB 1: ROUTINES LIBRARY ====================
class RoutinesTab extends StatelessWidget {
  final List<RoutineModel> routines;
  final Function(RoutineModel) onSelectRoutine;
  final Function(RoutineModel) onAddNewRoutine;

  const RoutinesTab({
    super.key,
    required this.routines,
    required this.onSelectRoutine,
    required this.onAddNewRoutine,
  });

  void _showAddRoutineModal(BuildContext context) {
    final titleController = TextEditingController();
    final minsController = TextEditingController(text: '15');
    final step1Controller = TextEditingController();
    final step2Controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E2230),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Create Micro-Routine',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(ctx),
                  )
                ],
              ),
              const SizedBox(height: 15),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Routine Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: minsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Total Minutes',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: step1Controller,
                decoration: const InputDecoration(
                  labelText: 'Step 1 Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: step2Controller,
                decoration: const InputDecoration(
                  labelText: 'Step 2 Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      final mins = int.tryParse(minsController.text) ?? 10;
                      final s1 = step1Controller.text.isEmpty ? 'Get Started' : step1Controller.text;
                      final s2 = step2Controller.text.isEmpty ? 'Finish Up' : step2Controller.text;

                      final newR = RoutineModel(
                        id: DateTime.now().toString(),
                        title: titleController.text,
                        category: 'Custom',
                        totalMinutes: mins,
                        steps: [s1, s2],
                        themeColor: Colors.teal,
                        icon: Icons.star,
                      );
                      onAddNewRoutine(newR);
                      Navigator.pop(ctx);
                    }
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Save & Add Routine', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    Text(
                      'FlowPace Pacer',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'Micro-routine visual timelining',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed: () => _showAddRoutineModal(context),
                icon: const Icon(Icons.add, color: Colors.tealAccent),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Daily Highlight Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2C3E50), Color(0xFF000000)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, size: 40, color: Colors.tealAccent),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: const [
                      Text(
                        'Beat Time-Blindness',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Dock your phone on stand & follow visual flow intervals.',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Preset Micro-Routines',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: routines.length,
            itemBuilder: (context, index) {
              final routine = routines[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2230),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: routine.themeColor.withOpacity(0.3)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: routine.themeColor.withOpacity(0.2),
                    child: Icon(routine.icon, color: routine.themeColor),
                  ),
                  title: Text(
                    routine.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Chip(
                          visualDensity: VisualDensity.compact,
                          backgroundColor: Colors.black87,
                          label: Text(
                            '${routine.totalMinutes} mins',
                            style: TextStyle(fontSize: 11, color: routine.themeColor),
                          ),
                        ),
                        Chip(
                          visualDensity: VisualDensity.compact,
                          backgroundColor: Colors.black87,
                          label: Text(
                            '${routine.steps.length} Steps',
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: routine.themeColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => onSelectRoutine(routine),
                    child: const Text('Start', style: TextStyle(fontWeight: FontWeight.bold)),
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

// ==================== TAB 2: ACTIVE PACER & TIMER ====================
class ActivePacerTab extends StatefulWidget {
  final RoutineModel routine;
  final Function(int minutes) onComplete;

  const ActivePacerTab({
    super.key,
    required this.routine,
    required this.onComplete,
  });

  @override
  State<ActivePacerTab> createState() => _ActivePacerTabState();
}

class _ActivePacerTabState extends State<ActivePacerTab> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _timer;
  int _currentStepIndex = 0;
  late int _stepSecondsLeft;
  bool _isRunning = false;
  bool _isAmbientSoundVisual = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _initStepTimer();
  }

  @override
  void didUpdateWidget(covariant ActivePacerTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.routine.id != widget.routine.id) {
      _resetTimer();
    }
  }

  void _initStepTimer() {
    final totalSteps = widget.routine.steps.length;
    final totalSeconds = widget.routine.totalMinutes * 60;
    final secondsPerStep = (totalSeconds / totalSteps).round();
    setState(() {
      _stepSecondsLeft = secondsPerStep;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _currentStepIndex = 0;
      _isRunning = false;
    });
    _initStepTimer();
  }

  void _toggleStartPause() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
    } else {
      setState(() {
        _isRunning = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_stepSecondsLeft > 0) {
          setState(() {
            _stepSecondsLeft--;
          });
        } else {
          _advanceStep();
        }
      });
    }
  }

  void _advanceStep() {
    if (_currentStepIndex < widget.routine.steps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
      _initStepTimer();
    } else {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
      widget.onComplete(widget.routine.totalMinutes);
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2230),
        title: const Row(
          children: [
            Icon(Icons.stars, color: Colors.amber),
            SizedBox(width: 8),
            Text('Routine Complete!', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Text(
          'Awesome job completing "${widget.routine.title}"! You earned +${widget.routine.totalMinutes * 10} Flow Points.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _resetTimer();
            },
            child: const Text('Great!', style: TextStyle(color: Colors.tealAccent)),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.routine.themeColor;
    final currentStepName = widget.routine.steps[_currentStepIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAlignment.center,
        children: [
          // Routine Title Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: themeColor.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.routine.icon, color: themeColor, size: 18),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    widget.routine.title,
                    style: TextStyle(fontWeight: FontWeight.bold, color: themeColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Pulsing Ambient Ring Display
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final scale = _isRunning ? 1.0 + (_pulseController.value * 0.05) : 1.0;
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 230,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1E2230),
                    border: Border.all(
                      color: _isRunning ? themeColor : Colors.grey.shade700,
                      width: 6,
                    ),
                    boxShadow: _isRunning
                        ? [
                            BoxShadow(
                              color: themeColor.withOpacity(0.3),
                              blurRadius: 25,
                              spreadRadius: 5,
                            )
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Step ${_currentStepIndex + 1} of ${widget.routine.steps.length}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _formatTime(_stepSecondsLeft),
                          style: const TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            currentStepName,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: themeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 30),

          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                iconSize: 28,
                onPressed: _resetTimer,
                icon: const Icon(Icons.refresh, color: Colors.white70),
              ),
              const SizedBox(width: 20),
              FloatingActionButton.large(
                backgroundColor: themeColor,
                foregroundColor: Colors.black,
                onPressed: _toggleStartPause,
                child: Icon(
                  _isRunning ? Icons.pause : Icons.play_arrow,
                  size: 40,
                ),
              ),
              const SizedBox(width: 20),
              IconButton.filledTonal(
                iconSize: 28,
                onPressed: _advanceStep,
                icon: const Icon(Icons.skip_next, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Ambient Visual Sound Simulation Switch
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2230),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.volume_up, color: Colors.tealAccent, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Visual Focus Wave Effect',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
                Switch(
                  value: _isAmbientSoundVisual,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() {
                      _isAmbientSoundVisual = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Step Timeline List
          Column(
            crossAxisAlignment: CrossAlignment.start,
            children: [
              const Text(
                'Step Timeline',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              ...List.generate(widget.routine.steps.length, (index) {
                final isDone = index < _currentStepIndex;
                final isCurrent = index == _currentStepIndex;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCurrent ? themeColor.withOpacity(0.15) : const Color(0xFF1E2230),
                    borderRadius: BorderRadius.circular(10),
                    border: isCurrent ? Border.all(color: themeColor) : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isDone
                            ? Icons.check_circle
                            : (isCurrent ? Icons.play_circle_fill : Icons.radio_button_unchecked),
                        color: isDone ? Colors.green : (isCurrent ? themeColor : Colors.grey),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.routine.steps[index],
                          style: TextStyle(
                            color: isDone ? Colors.grey : Colors.white,
                            decoration: isDone ? TextDecoration.lineThrough : null,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== TAB 3: MICRO-DECISION WHEEL ====================
class DecisionWheelTab extends StatefulWidget {
  final Function(String taskTitle) onStartPickedTask;

  const DecisionWheelTab({
    super.key,
    required this.onStartPickedTask,
  });

  @override
  State<DecisionWheelTab> createState() => _DecisionWheelTabState();
}

class _DecisionWheelTabState extends State<DecisionWheelTab> {
  final List<String> _tasks = [
    'Clean Office Desk',
    'Fold Laundry Sprint',
    'Reply Urgent Emails',
    '10-Min Stretch',
    'Drink Water & Walk',
  ];

  final TextEditingController _customTaskController = TextEditingController();
  String? _pickedTask;
  bool _isSpinning = false;

  void _spinWheel() {
    if (_tasks.isEmpty || _isSpinning) return;
    setState(() {
      _isSpinning = true;
      _pickedTask = null;
    });

    Timer(const Duration(seconds: 2), () {
      final randIndex = math.Random().nextInt(_tasks.length);
      setState(() {
        _pickedTask = _tasks[randIndex];
        _isSpinning = false;
      });
    });
  }

  void _addTask() {
    if (_customTaskController.text.trim().isNotEmpty) {
      setState(() {
        _tasks.add(_customTaskController.text.trim());
        _customTaskController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          const Text(
            'Micro-Decision Wheel',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'Overcome procrastination by letting FlowPace pick your next 10-minute sprint.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Decision Display Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2230),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.indigoAccent.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                const Icon(Icons.auto_awesome, size: 48, color: Colors.indigoAccent),
                const SizedBox(height: 12),
                if (_isSpinning) ...[
                  const CircularProgressIndicator(color: Colors.indigoAccent),
                  const SizedBox(height: 12),
                  const Text('Selecting optimal micro-task...', style: TextStyle(color: Colors.grey)),
                ] else if (_pickedTask != null) ...[
                  const Text(
                    'Your Assigned Sprint:',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _pickedTask!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () => widget.onStartPickedTask(_pickedTask!),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start 10m Flow Now', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ] else ...[
                  const Text(
                    'Ready to break procrastination?',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                    onPressed: _spinWheel,
                    icon: const Icon(Icons.casino),
                    label: const Text('Spin & Pick Task', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ]
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Task Candidates Input
          const Text(
            'Candidate Tasks',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customTaskController,
                  decoration: const InputDecoration(
                    hintText: 'Add micro task candidate...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                onPressed: _addTask,
                icon: const Icon(Icons.add, color: Colors.tealAccent),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tasks.map((t) {
              return Chip(
                backgroundColor: const Color(0xFF1E2230),
                label: Text(t, style: const TextStyle(color: Colors.white, fontSize: 12)),
                onDeleted: _tasks.length > 2
                    ? () {
                        setState(() {
                          _tasks.remove(t);
                        });
                      }
                    : null,
                deleteIconColor: Colors.grey,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ==================== TAB 4: STATS & REWARDS ====================
class StatsAndRewardsTab extends StatelessWidget {
  final int todayMinutes;
  final int sessionsCount;
  final int flowPoints;
  final Function(int points) onRewardClaimed;

  const StatsAndRewardsTab({
    super.key,
    required this.todayMinutes,
    required this.sessionsCount,
    required this.flowPoints,
    required this.onRewardClaimed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          const Text(
            'Flow Analytics & Rewards',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'Track active focus metrics and level up daily flow.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Stats Overview Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Today Focused',
                  '$todayMinutes Mins',
                  Icons.timer,
                  Colors.tealAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Sessions Done',
                  '$sessionsCount',
                  Icons.check_circle,
                  Colors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Points Display
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3F51B5), Color(0xFF1A237E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    const Text('Total Flow Points', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(
                      '$flowPoints PTS',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                const Icon(Icons.stars, size: 44, color: Colors.amber),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Daily Streak Section
          const Text(
            'Daily Retention Badges',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2230),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBadge('Mon', true),
                _buildBadge('Tue', true),
                _buildBadge('Wed', true),
                _buildBadge('Thu', false),
                _buildBadge('Fri', false),
                _buildBadge('Sat', false),
                _buildBadge('Sun', false),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Monetization Bonus Booster Simulation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2230),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.amber.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Daily Reward Booster',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Watch quick focus tip sponsor card to unlock +50 Flow Bonus Points (Valued at \$0.50 reward status).',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.amber,
                      side: const BorderSide(color: Colors.amber),
                    ),
                    onPressed: () {
                      onRewardClaimed(50);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Bonus +50 Flow Points Claimed!')),
                      );
                    },
                    icon: const Icon(Icons.play_circle_fill),
                    label: const Text('Claim +50 Bonus Points'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2230),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildBadge(String day, bool active) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: active ? Colors.tealAccent : Colors.grey.shade800,
          child: Icon(
            active ? Icons.check : Icons.local_fire_department,
            size: 16,
            color: active ? Colors.black : Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        Text(day, style: TextStyle(fontSize: 11, color: active ? Colors.white : Colors.grey)),
      ],
    );
  }
}