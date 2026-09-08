import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const PaceCraftApp());
}

class PaceCraftApp extends StatelessWidget {
  const PaceCraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaceCraft',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class RoutineStep {
  final String title;
  final int durationSeconds;
  final IconData icon;

  RoutineStep({
    required this.title,
    required this.durationSeconds,
    required this.icon,
  });
}

class Routine {
  final String id;
  final String title;
  final String category;
  final IconData icon;
  final Color themeColor;
  final List<RoutineStep> steps;

  Routine({
    required this.id,
    required this.title,
    required this.category,
    required this.icon,
    required this.themeColor,
    required this.steps,
  });

  int get totalDurationSeconds {
    return steps.fold(0, (sum, step) => sum + step.durationSeconds);
  }

  int get totalDurationMinutes {
    return (totalDurationSeconds / 60).ceil();
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedTabIndex = 0;

  // App Data & Stats
  int _totalPacedMinutes = 38;
  int _distractionsCaughtCount = 7;
  int _routinesCompletedCount = 4;
  final List<String> _impulseVault = [
    'Check sneakers sale online',
    'Look up quick recipe for dinner',
    'Reply to team chat on slack',
  ];

  late List<Routine> _routines;

  // Active Timer State
  Routine? _activeRoutine;
  int _currentStepIndex = 0;
  int _stepRemainingSeconds = 0;
  bool _isRunning = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _routines = [
      Routine(
        id: 'r1',
        title: 'Morning Energizer',
        category: 'Morning Flow',
        icon: Icons.wb_sunny,
        themeColor: Colors.amber,
        steps: [
          RoutineStep(title: 'Hydrate & Stretch', durationSeconds: 120, icon: Icons.local_water),
          RoutineStep(title: 'Bed & Room Reset', durationSeconds: 180, icon: Icons.bed),
          RoutineStep(title: 'Dynamic Breathing', durationSeconds: 120, icon: Icons.air),
          RoutineStep(title: 'Top 3 Daily Intentions', durationSeconds: 180, icon: Icons.checklist),
        ],
      ),
      Routine(
        id: 'r2',
        title: 'Deep Study / Work Sprint',
        category: 'Focus Stream',
        icon: Icons.bolt,
        themeColor: Colors.indigo,
        steps: [
          RoutineStep(title: 'Desk Clear & Water Prep', durationSeconds: 120, icon: Icons.cleaning_services),
          RoutineStep(title: 'Primary Sprint Session', durationSeconds: 900, icon: Icons.timer),
          RoutineStep(title: 'Micro Posture Reset', durationSeconds: 60, icon: Icons.accessibility_new),
          RoutineStep(title: 'Secondary Focus Push', durationSeconds: 600, icon: Icons.psychology),
        ],
      ),
      Routine(
        id: 'r3',
        title: 'Quick Desk & Room Tidy',
        category: 'Micro Action',
        icon: Icons.cleaning_services,
        themeColor: Colors.teal,
        steps: [
          RoutineStep(title: 'Trash & Cups Sweep', durationSeconds: 180, icon: Icons.delete),
          RoutineStep(title: 'Cable & Tech Docking', durationSeconds: 180, icon: Icons.build),
          RoutineStep(title: 'Surface Wipe & Stack', durationSeconds: 240, icon: Icons.dashboard),
        ],
      ),
      Routine(
        id: 'r4',
        title: 'Night Screen Detox',
        category: 'Evening Reset',
        icon: Icons.bedtime,
        themeColor: Colors.purple,
        steps: [
          RoutineStep(title: 'Dock Phone Away from Bed', durationSeconds: 60, icon: Icons.phonelink_off),
          RoutineStep(title: 'Outfit & Bag Prep for Tomorrow', durationSeconds: 300, icon: Icons.work),
          RoutineStep(title: 'Mind Dump & Reflection', durationSeconds: 240, icon: Icons.edit_note),
        ],
      ),
    ];

    // Default active routine loaded
    _selectRoutine(_routines[0], autoStart: false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _selectRoutine(Routine routine, {bool autoStart = false}) {
    _timer?.cancel();
    setState(() {
      _activeRoutine = routine;
      _currentStepIndex = 0;
      _stepRemainingSeconds = routine.steps[0].durationSeconds;
      _isRunning = false;
    });
    if (autoStart) {
      _startTimer();
    }
  }

  void _startTimer() {
    if (_activeRoutine == null) return;
    _timer?.cancel();
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_stepRemainingSeconds > 1) {
          _stepRemainingSeconds--;
        } else {
          // Advance to next step
          if (_currentStepIndex < _activeRoutine!.steps.length - 1) {
            _currentStepIndex++;
            _stepRemainingSeconds = _activeRoutine!.steps[_currentStepIndex].durationSeconds;
          } else {
            // Routine completed
            _timer?.cancel();
            _isRunning = false;
            _routinesCompletedCount++;
            _totalPacedMinutes += _activeRoutine!.totalDurationMinutes;
            _showCompletionModal();
          }
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _skipStep() {
    if (_activeRoutine == null) return;
    if (_currentStepIndex < _activeRoutine!.steps.length - 1) {
      setState(() {
        _currentStepIndex++;
        _stepRemainingSeconds = _activeRoutine!.steps[_currentStepIndex].durationSeconds;
      });
    }
  }

  void _previousStep() {
    if (_activeRoutine == null) return;
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
        _stepRemainingSeconds = _activeRoutine!.steps[_currentStepIndex].durationSeconds;
      });
    }
  }

  void _addImpulseThought(String thought) {
    if (thought.trim().isEmpty) return;
    setState(() {
      _impulseVault.insert(0, thought.trim());
      _distractionsCaughtCount++;
    });
  }

  void _showCompletionModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.stars, color: Colors.amber, size: 28),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Flow Completed!',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Awesome work! You paced through "${_activeRoutine?.title}" without getting sidetracked.',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.around,
                children: [
                  Column(
                    children: [
                      Text(
                        '${_activeRoutine?.totalDurationMinutes ?? 0}m',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigoAccent),
                      ),
                      const Text('Paced Time', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '+\$4.50',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                      ),
                      const Text('Time Value Saved', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Great!', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _openAddImpulseSheet() {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.shield_outlined, color: Colors.amber),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Dump Impulse Thought',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Got tempted to check an app or buy something? Dump it here to stay in flow and review later.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'e.g., Check flight prices, order shoes...',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  _addImpulseThought(controller.text);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Park & Return to Flow',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCreateRoutineSheet() {
    final titleController = TextEditingController();
    final catController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
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
              const Text(
                'Create Custom Flow Routine',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Routine Title',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: catController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Category (e.g., Workout, Cooking, Study)',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (titleController.text.trim().isNotEmpty) {
                      final newR = Routine(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text.trim(),
                        category: catController.text.trim().isEmpty ? 'Custom' : catController.text.trim(),
                        icon: Icons.tune,
                        themeColor: Colors.teal,
                        steps: [
                          RoutineStep(title: 'Phase 1 Focus', durationSeconds: 300, icon: Icons.play_arrow),
                          RoutineStep(title: 'Phase 2 Execution', durationSeconds: 600, icon: Icons.bolt),
                          RoutineStep(title: 'Wrap Up', durationSeconds: 180, icon: Icons.check),
                        ],
                      );
                      setState(() {
                        _routines.add(newR);
                      });
                      _selectRoutine(newR, autoStart: false);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save & Select Routine', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.speed, color: Colors.indigoAccent),
            SizedBox(width: 8),
            Text(
              'PaceCraft',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.indigoAccent),
            onPressed: _openCreateRoutineSheet,
            tooltip: 'Add Custom Flow',
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedTabIndex,
          children: [
            _buildRoutinesTab(),
            _buildActivePacerTab(),
            _buildAnalyticsAndVaultTab(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.indigoAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Routines',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Live Pacer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'Vault & Stats',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: ROUTINES LIBRARY ---
  Widget _buildRoutinesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Banner / Hero card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade900, Colors.indigo.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Chip(
                      label: Text('ACTIVE COMPANION', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                      backgroundColor: Colors.indigo,
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Paced Daily Streams',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Launch a routine and leave PaceCraft running on your screen. Keep momentum without doom-scrolling.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Available Routines',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                '${_routines.length} Flows',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _routines.length,
            itemBuilder: (context, index) {
              final routine = _routines[index];
              final isSelected = _activeRoutine?.id == routine.id;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? routine.themeColor : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: routine.themeColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(routine.icon, color: routine.themeColor, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              routine.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 8,
                              children: [
                                Text(
                                  '${routine.totalDurationMinutes} mins',
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                                const Text('•', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                Text(
                                  '${routine.steps.length} micro-steps',
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected ? routine.themeColor : Colors.white70,
                          foregroundColor: isSelected ? Colors.black : Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          _selectRoutine(routine, autoStart: true);
                          setState(() {
                            _selectedTabIndex = 1; // Switch to Live Pacer tab
                          });
                        },
                        child: Text(isSelected ? 'Pacing' : 'Start'),
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

  // --- TAB 2: LIVE DESK PACER (HIGH SCREEN TIME ENGAGEMENT) ---
  Widget _buildActivePacerTab() {
    if (_activeRoutine == null) {
      return const Center(child: Text('Select a routine to start pacing', style: TextStyle(color: Colors.grey)));
    }

    final currentRoutine = _activeRoutine!;
    final currentStep = currentRoutine.steps[_currentStepIndex];
    final progress = 1.0 - (_stepRemainingSeconds / currentStep.durationSeconds);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // Routine Active Header Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: currentRoutine.themeColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(currentRoutine.icon, size: 16, color: currentRoutine.themeColor),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          currentRoutine.title,
                          style: TextStyle(color: currentRoutine.themeColor, fontWeight: FontWeight.bold, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                'Step ${_currentStepIndex + 1} of ${currentRoutine.steps.length}',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Main Desk Circular Timer Widget
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: currentRoutine.themeColor.withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 190,
                      height: 190,
                      child: CircularProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        strokeWidth: 12,
                        backgroundColor: Colors.white70,
                        color: currentRoutine.themeColor,
                      ),
                    ),
                    Column(
                      children: [
                        Icon(currentStep.icon, color: currentRoutine.themeColor, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          _formatTime(_stepRemainingSeconds),
                          style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'REMAINING',
                          style: TextStyle(fontSize: 10, letterSpacing: 1.5, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Active Step Name
                Text(
                  currentStep.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                // Timer Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 32,
                      icon: const Icon(Icons.skip_previous, color: Colors.white70),
                      onPressed: _currentStepIndex > 0 ? _previousStep : null,
                    ),
                    const SizedBox(width: 16),
                    FloatingActionButton.large(
                      backgroundColor: currentRoutine.themeColor,
                      foregroundColor: Colors.black,
                      onPressed: _isRunning ? _pauseTimer : _startTimer,
                      child: Icon(_isRunning ? Icons.pause : Icons.play_arrow, size: 40),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      iconSize: 32,
                      icon: const Icon(Icons.skip_next, color: Colors.white70),
                      onPressed: _currentStepIndex < currentRoutine.steps.length - 1 ? _skipStep : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Distraction / Impulse Catch Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.amber, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _openAddImpulseSheet,
              icon: const Icon(Icons.shield, color: Colors.amber),
              label: const Text(
                'Catch Distracting Impulse',
                style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Steps Overview Timeline
          Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Routine Flow Timeline',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: currentRoutine.steps.length,
            itemBuilder: (context, idx) {
              final step = currentRoutine.steps[idx];
              final isCurrent = idx == _currentStepIndex;
              final isDone = idx < _currentStepIndex;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isCurrent ? currentRoutine.themeColor.withOpacity(0.15) : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isCurrent ? currentRoutine.themeColor : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isDone
                          ? Icons.check_circle
                          : isCurrent
                              ? Icons.play_circle_filled
                              : Icons.radio_button_unchecked,
                      color: isDone
                          ? Colors.green
                          : isCurrent
                              ? currentRoutine.themeColor
                              : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        step.title,
                        style: TextStyle(
                          color: isDone
                              ? Colors.grey
                              : isCurrent
                                  ? Colors.white
                                  : Colors.white70,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                          decoration: isDone ? TextDecoration.lineThrough : null,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _formatTime(step.durationSeconds),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
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

  // --- TAB 3: ANALYTICS & IMPULSE VAULT ---
  Widget _buildAnalyticsAndVaultTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Focus Analytics & Saved Time',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),

          // Stat Cards Grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Paced Today',
                  value: '$_totalPacedMinutes mins',
                  icon: Icons.timer,
                  color: Colors.indigoAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: 'Flow Streaks',
                  value: '$_routinesCompletedCount flows',
                  icon: Icons.flame,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Distractions Diverted',
                  value: '$_distractionsCaughtCount caught',
                  icon: Icons.shield,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: 'Est. Money Saved',
                  value: '\$${(_distractionsCaughtCount * 3.50).toStringAsFixed(2)}',
                  icon: Icons.monetization_on,
                  color: Colors.tealAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Impulse Vault Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.lock_clock, color: Colors.amber),
                  SizedBox(width: 8),
                  Text(
                    'Parked Impulse Vault',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              Text(
                '${_impulseVault.length} Saved',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Thoughts intercepted while pacing. Review them now that your micro-routine is complete.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 12),

          if (_impulseVault.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: const [
                  Icon(Icons.sentiment_satisfied, color: Colors.grey, size: 36),
                  SizedBox(height: 8),
                  Text('Vault is clean! No distracting impulses parked.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _impulseVault.length,
              itemBuilder: (context, index) {
                final item = _impulseVault[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.bookmark_border, color: Colors.amber),
                    title: Text(
                      item,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () {
                        setState(() {
                          _impulseVault.removeAt(index);
                        });
                      },
                      tooltip: 'Mark Done / Dismiss',
                    ),
                  ),
                );
              },
            ),
        ],
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}