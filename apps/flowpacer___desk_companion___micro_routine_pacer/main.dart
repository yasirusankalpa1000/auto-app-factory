import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const FlowPacerApp());
}

class FlowPacerApp extends StatelessWidget {
  const FlowPacerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlowPacer',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF12141D),
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.amber,
          surface: Color(0xFF1E2230),
        ),
        cardTheme: const CardTheme(
          color: Color(0xFF1E2230),
          elevation: 2,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class RoutineStep {
  final String name;
  final int durationSeconds;

  RoutineStep({required this.name, required this.durationSeconds});
}

class Routine {
  final String id;
  final String title;
  final String category;
  final IconData icon;
  final List<RoutineStep> steps;

  Routine({
    required this.id,
    required this.title,
    required this.category,
    required this.icon,
    required this.steps,
  });

  int get totalDurationSeconds =>
      steps.fold(0, (sum, step) => sum + step.durationSeconds);
}

class SessionRecord {
  final String routineTitle;
  final DateTime completedAt;
  final int totalMinutes;
  final int distractionsCount;
  final int focusScore;

  SessionRecord({
    required this.routineTitle,
    required this.completedAt,
    required this.totalMinutes,
    required this.distractionsCount,
    required this.focusScore,
  });
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // App Data & State
  late List<Routine> _routines;
  Routine? _activeRoutine;
  int _currentStepIndex = 0;
  int _remainingSecondsInStep = 0;
  Timer? _timer;
  bool _isRunning = false;
  int _distractionCount = 0;
  int _totalFocusSecondsToday = 1800; // Starter preset mock: 30 mins
  final List<SessionRecord> _history = [];

  @override
  void initState() {
    super.initState();
    _routines = [
      Routine(
        id: '1',
        title: 'Deep Focus Sprint',
        category: 'Work & Study',
        icon: Icons.psychology,
        steps: [
          RoutineStep(name: 'Set Goal & Clear Desk', durationSeconds: 120),
          RoutineStep(name: 'Deep Task Execution', durationSeconds: 1500),
          RoutineStep(name: 'Quick Review & Notes', durationSeconds: 180),
        ],
      ),
      Routine(
        id: '2',
        title: 'Morning Speed Prep',
        category: 'Daily Routine',
        icon: Icons.bolt,
        steps: [
          RoutineStep(name: 'Hydrate & Stretch', durationSeconds: 180),
          RoutineStep(name: 'Planner Check', durationSeconds: 300),
          RoutineStep(name: 'Quick Room Reset', durationSeconds: 420),
        ],
      ),
      Routine(
        id: '3',
        title: 'Kitchen Micro-Pacer',
        category: 'Home Utility',
        icon: Icons.timer,
        steps: [
          RoutineStep(name: 'Prep Ingredients', durationSeconds: 300),
          RoutineStep(name: 'Active Cooking Sprint', durationSeconds: 900),
          RoutineStep(name: 'Wipe Counter & Dish Reset', durationSeconds: 300),
        ],
      ),
    ];
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startRoutine(Routine routine) {
    _timer?.cancel();
    setState(() {
      _activeRoutine = routine;
      _currentStepIndex = 0;
      _remainingSecondsInStep = routine.steps[0].durationSeconds;
      _isRunning = true;
      _distractionCount = 0;
      _currentIndex = 1; // Switch to Dock View
    });
    _runTimer();
  }

  void _runTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isRunning) return;

      setState(() {
        if (_remainingSecondsInStep > 0) {
          _remainingSecondsInStep--;
        } else {
          // Advance to next step
          if (_activeRoutine != null &&
              _currentStepIndex < _activeRoutine!.steps.length - 1) {
            _currentStepIndex++;
            _remainingSecondsInStep =
                _activeRoutine!.steps[_currentStepIndex].durationSeconds;
          } else {
            // Completed Routine
            _completeActiveRoutine();
          }
        }
      });
    });
  }

  void _completeActiveRoutine() {
    _timer?.cancel();
    if (_activeRoutine == null) return;

    int totalSecs = _activeRoutine!.totalDurationSeconds;
    int mins = (totalSecs / 60).round();
    int score = (100 - (_distractionCount * 12)).clamp(20, 100);

    SessionRecord record = SessionRecord(
      routineTitle: _activeRoutine!.title,
      completedAt: DateTime.now(),
      totalMinutes: mins,
      distractionsCount: _distractionCount,
      focusScore: score,
    );

    setState(() {
      _history.insert(0, record);
      _totalFocusSecondsToday += totalSecs;
      _isRunning = false;
      _activeRoutine = null;
    });

    _showCompletionDialog(record);
  }

  void _togglePauseResume() {
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _skipStep() {
    if (_activeRoutine == null) return;
    setState(() {
      if (_currentStepIndex < _activeRoutine!.steps.length - 1) {
        _currentStepIndex++;
        _remainingSecondsInStep =
            _activeRoutine!.steps[_currentStepIndex].durationSeconds;
      } else {
        _completeActiveRoutine();
      }
    });
  }

  void _addEmergencyMinute() {
    setState(() {
      _remainingSecondsInStep += 60;
    });
  }

  void _logDistraction() {
    setState(() {
      _distractionCount++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Distraction recorded. Re-center your focus!'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.amber,
      ),
    );
  }

  void _showCompletionDialog(SessionRecord record) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2230),
        title: const Text(
          '🎉 Routine Completed!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              record.routineTitle,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatBadge(
                    'Time Spent', '${record.totalMinutes}m', Colors.blue),
                _buildStatBadge('Focus Score', '${record.focusScore}%',
                    Colors.tealAccent),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Distractions logged: ${record.distractionsCount}',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 2; // Jump to Insights
              });
            },
            child: const Text('View Insights',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(fontSize: 11, color: Colors.white70)),
        ],
      ),
    );
  }

  void _addNewCustomRoutine(Routine routine) {
    setState(() {
      _routines.add(routine);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            RoutinesTab(
              routines: _routines,
              onStartRoutine: _startRoutine,
              onCreateRoutine: _addNewCustomRoutine,
            ),
            DeskDockTab(
              activeRoutine: _activeRoutine,
              currentStepIndex: _currentStepIndex,
              remainingSeconds: _remainingSecondsInStep,
              isRunning: _isRunning,
              distractions: _distractionCount,
              onTogglePause: _togglePauseResume,
              onSkipStep: _skipStep,
              onAddMinute: _addEmergencyMinute,
              onLogDistraction: _logDistraction,
              onCancel: () {
                _timer?.cancel();
                setState(() {
                  _activeRoutine = null;
                  _isRunning = false;
                });
              },
            ),
            InsightsTab(
              totalFocusSeconds: _totalFocusSecondsToday,
              history: _history,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF181B26),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Routines',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Desk Dock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Insights',
          ),
        ],
      ),
    );
  }
}

// ================= TAB 1: ROUTINES CATALOG =================
class RoutinesTab extends StatelessWidget {
  final List<Routine> routines;
  final Function(Routine) onStartRoutine;
  final Function(Routine) onCreateRoutine;

  const RoutinesTab({
    super.key,
    required this.routines,
    required this.onStartRoutine,
    required this.onCreateRoutine,
  });

  void _openCreateDialog(BuildContext context) {
    final titleController = TextEditingController();
    final step1Controller = TextEditingController();
    final step1MinController = TextEditingController(text: '5');
    final step2Controller = TextEditingController();
    final step2MinController = TextEditingController(text: '15');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E2230),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Create Custom Flow Routine',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Routine Title (e.g., Quick Reading Sprint)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Step 1:',
                    style: TextStyle(
                        color: Colors.white70, FontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: step1Controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Step name (e.g. Set context)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: step1MinController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Mins',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Step 2:',
                    style: TextStyle(
                        color: Colors.white70, FontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: step2Controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Step name (e.g. Active Execution)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: step2MinController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Mins',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      String title = titleController.text.trim();
                      if (title.isEmpty) title = 'My Custom Routine';

                      String s1Name = step1Controller.text.trim();
                      if (s1Name.isEmpty) s1Name = 'Phase 1';
                      int s1Mins = int.tryParse(step1MinController.text) ?? 5;

                      String s2Name = step2Controller.text.trim();
                      if (s2Name.isEmpty) s2Name = 'Phase 2';
                      int s2Mins = int.tryParse(step2MinController.text) ?? 15;

                      Routine custom = Routine(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: title,
                        category: 'Custom User Routine',
                        icon: Icons.auto_awesome,
                        steps: [
                          RoutineStep(
                              name: s1Name, durationSeconds: s1Mins * 60),
                          RoutineStep(
                              name: s2Name, durationSeconds: s2Mins * 60),
                        ],
                      );

                      onCreateRoutine(custom);
                      Navigator.pop(context);
                    },
                    child: const Text('Save & Add Routine',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FlowPacer',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Micro-Routine Pacer & Focus Companion',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _openCreateDialog(context),
                icon: const Icon(Icons.add_circle,
                    color: Colors.tealAccent, size: 32),
                tooltip: 'Create Routine',
              )
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.teal.withAlpha(60),
                  Colors.indigo.withAlpha(60)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.tealAccent.withAlpha(80)),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: Colors.amber, size: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Keep App Open as Desk Dock',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Set your device on your desk while pacing tasks to maintain deep visual momentum!',
                        style: TextStyle(fontSize: 11, color: Colors.white70),
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
            'Select Routine to Pace',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: routines.length,
            itemBuilder: (context, index) {
              final routine = routines[index];
              int totalMins = (routine.totalDurationSeconds / 60).round();
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.teal.withAlpha(50),
                            child: Icon(routine.icon, color: Colors.tealAccent),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  routine.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${routine.category} • ${routine.steps.length} Steps • ${totalMins} mins',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.tealAccent,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                            onPressed: () => onStartRoutine(routine),
                            icon: const Icon(Icons.play_arrow, size: 18),
                            label: const Text('Start',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(color: Colors.white70),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: routine.steps.map((step) {
                          int mins = (step.durationSeconds / 60).round();
                          return Chip(
                            backgroundColor: const Color(0xFF12141D),
                            padding: const EdgeInsets.all(0),
                            labelStyle: const TextStyle(
                                fontSize: 11, color: Colors.white70),
                            label: Text('${step.name} (${mins}m)'),
                          );
                        }).toList(),
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
}

// ================= TAB 2: ACTIVE DESK DOCK VIEW =================
class DeskDockTab extends StatelessWidget {
  final Routine? activeRoutine;
  final int currentStepIndex;
  final int remainingSeconds;
  final bool isRunning;
  final int distractions;
  final VoidCallback onTogglePause;
  final VoidCallback onSkipStep;
  final VoidCallback onAddMinute;
  final VoidCallback onLogDistraction;
  final VoidCallback onCancel;

  const DeskDockTab({
    super.key,
    required this.activeRoutine,
    required this.currentStepIndex,
    required this.remainingSeconds,
    required this.isRunning,
    required this.distractions,
    required this.onTogglePause,
    required this.onSkipStep,
    required this.onAddMinute,
    required this.onLogDistraction,
    required this.onCancel,
  });

  String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    if (activeRoutine == null) {
      return Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.screen_lock_portrait,
                    size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No Active Focus Session',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Select a micro-routine from the Routines tab and mount your phone on your desk to begin active visual pacing.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentStep = activeRoutine!.steps[currentStepIndex];
    final totalStepSecs = currentStep.durationSeconds;
    final progress = totalStepSecs > 0
        ? (1.0 - (remainingSeconds / totalStepSecs)).clamp(0.0, 1.0)
        : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'DESK DOCK • ${activeRoutine!.title.toUpperCase()}',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.tealAccent,
                      letterSpacing: 1.2),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: onCancel,
                icon: const Icon(Icons.close, color: Colors.white70),
                tooltip: 'Exit Session',
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Big Circular Focus Visualizer Widget
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isRunning
                      ? Colors.tealAccent.withAlpha(30)
                      : Colors.amber.withAlpha(20),
                  blurRadius: 30,
                  spreadRadius: 5,
                )
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.white70,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        isRunning ? Colors.tealAccent : Colors.amber),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(remainingSeconds),
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isRunning ? 'IN FLOW' : 'PAUSED',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isRunning ? Colors.tealAccent : Colors.amber,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Current Step Information Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2230),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'STEP ${currentStepIndex + 1} OF ${activeRoutine!.steps.length}',
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.tealAccent,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Next: ${currentStepIndex < activeRoutine!.steps.length - 1 ? activeRoutine!.steps[currentStepIndex + 1].name : "Finish"}',
                      style:
                          const TextStyle(fontSize: 11, color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  currentStep.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Action Controls Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton.filled(
                style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2230)),
                onPressed: onAddMinute,
                icon: const Icon(Icons.add_alarm, color: Colors.tealAccent),
                tooltip: '+1 Minute',
              ),
              IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: isRunning ? Colors.amber : Colors.tealAccent,
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: onTogglePause,
                icon: Icon(
                  isRunning ? Icons.pause : Icons.play_arrow,
                  color: Colors.black,
                  size: 32,
                ),
                tooltip: isRunning ? 'Pause' : 'Resume',
              ),
              IconButton.filled(
                style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2230)),
                onPressed: onSkipStep,
                icon: const Icon(Icons.skip_next, color: Colors.tealAccent),
                tooltip: 'Skip Step',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Distraction Counter & Re-Center Utility
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.redAccent.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.redAccent.withAlpha(50)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Distractions Logged: $distractions',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Tap whenever phone urges or interruptions happen.',
                        style: TextStyle(fontSize: 10, color: Colors.white70),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                  ),
                  onPressed: onLogDistraction,
                  child: const Text('Log Distraction',
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ================= TAB 3: INSIGHTS & HISTORY =================
class InsightsTab extends StatelessWidget {
  final int totalFocusSeconds;
  final List<SessionRecord> history;

  const InsightsTab({
    super.key,
    required this.totalFocusSeconds,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    int totalMins = (totalFocusSeconds / 60).round();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Flow Insights',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.tealAccent,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Track your daily screen-time efficiency and focus health',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 20),

          // Overview Score Cards
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2230),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.tealAccent.withAlpha(50)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.timer, color: Colors.tealAccent),
                      const SizedBox(height: 8),
                      Text(
                        '${totalMins}m',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const Text('Paced Today',
                          style: TextStyle(fontSize: 11, color: Colors.white70)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2230),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withAlpha(50)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.fireplace, color: Colors.amber),
                      const SizedBox(height: 8),
                      Text(
                        '${history.length + 1} Sprints',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const Text('Streak Session',
                          style: TextStyle(fontSize: 11, color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Text(
            'Session Activity History',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          const SizedBox(height: 12),

          if (history.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2230),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'No completed sessions logged yet. Complete a micro-routine sprint to generate performance metrics!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.check, color: Colors.white),
                    ),
                    title: Text(
                      item.routineTitle,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                    subtitle: Text(
                      '${item.totalMinutes} mins • ${item.distractionsCount} distractions',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                    trailing: Text(
                      '${item.focusScore}%',
                      style: const TextStyle(
                        color: Colors.tealAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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