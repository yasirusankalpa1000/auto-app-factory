import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const EnergyPulseApp());
}

class EnergyPulseApp extends StatelessWidget {
  const EnergyPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EnergyPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.amberAccent,
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class TaskItem {
  final String id;
  final String title;
  final String category; // 'High Focus', 'Creative', 'Light Admin', 'Micro Reset'
  final int durationMinutes;
  bool isCompleted;

  TaskItem({
    required this.id,
    required this.title,
    required this.category,
    required this.durationMinutes,
    this.isCompleted = false,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentTabIndex = 0;
  double _userEnergyLevel = 75.0; // 0 to 100%
  int _completedFocusMinutes = 45;
  int _streakDays = 6;

  // Sample initial daily tasks
  final List<TaskItem> _tasks = [
    TaskItem(
      id: '1',
      title: 'Draft Project Strategy & Architecture',
      category: 'High Focus',
      durationMinutes: 45,
    ),
    TaskItem(
      id: '2',
      title: 'Brainstorm Marketing Taglines',
      category: 'Creative',
      durationMinutes: 25,
    ),
    TaskItem(
      id: '3',
      title: 'Clear Unread Emails & Inbox Zero',
      category: 'Light Admin',
      durationMinutes: 15,
    ),
    TaskItem(
      id: '4',
      title: 'Desk Stretch & Hydration Break',
      category: 'Micro Reset',
      durationMinutes: 5,
    ),
    TaskItem(
      id: '5',
      title: 'Review Financial Statement (\$& Budget)',
      category: 'High Focus',
      durationMinutes: 30,
    ),
  ];

  // Focus Timer state
  Timer? _focusTimer;
  int _timerSecondsRemaining = 25 * 60;
  bool _isTimerRunning = false;
  String _activeTimerMode = 'Focus'; // 'Focus', 'Micro Break', 'Breathwork'
  String _activeAmbientSound = 'None';

  // Breathwork animation cycle
  String _breathworkPhase = 'Inhale';
  Timer? _breathworkTimer;
  int _breathCounter = 4;

  @override
  void dispose() {
    _focusTimer?.cancel();
    _breathworkTimer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isTimerRunning) {
      _focusTimer?.cancel();
      setState(() {
        _isTimerRunning = false;
      });
    } else {
      setState(() {
        _isTimerRunning = true;
      });
      _focusTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timerSecondsRemaining > 0) {
          setState(() {
            _timerSecondsRemaining--;
          });
        } else {
          _focusTimer?.cancel();
          setState(() {
            _isTimerRunning = false;
            if (_activeTimerMode == 'Focus') {
              _completedFocusMinutes += 25;
            }
          });
          _showCompletionDialog();
        }
      });
    }
  }

  void _resetTimer(int minutes, String mode) {
    _focusTimer?.cancel();
    setState(() {
      _activeTimerMode = mode;
      _timerSecondsRemaining = minutes * 60;
      _isTimerRunning = false;
    });

    if (mode == 'Breathwork') {
      _startBreathworkCycle();
    } else {
      _breathworkTimer?.cancel();
    }
  }

  void _startBreathworkCycle() {
    _breathworkTimer?.cancel();
    _breathCounter = 4;
    _breathworkPhase = 'Inhale (4s)';
    _breathworkTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _activeTimerMode != 'Breathwork') {
        timer.cancel();
        return;
      }
      setState(() {
        _breathCounter--;
        if (_breathCounter <= 0) {
          if (_breathworkPhase.startsWith('Inhale')) {
            _breathworkPhase = 'Hold (7s)';
            _breathCounter = 7;
          } else if (_breathworkPhase.startsWith('Hold')) {
            _breathworkPhase = 'Exhale (8s)';
            _breathCounter = 8;
          } else {
            _breathworkPhase = 'Inhale (4s)';
            _breathCounter = 4;
          }
        }
      });
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Session Completed!'),
        content: Text(
          _activeTimerMode == 'Focus'
              ? 'Awesome flow state session! EnergyPulse added 25 mins to your daily total.'
              : 'Recharge complete! Check your energy meter before resuming work.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Great!'),
          ),
        ],
      ),
    );
  }

  void _addNewTask(String title, String category, int duration) {
    setState(() {
      _tasks.add(
        TaskItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          category: category,
          durationMinutes: duration,
        ),
      );
    });
  }

  String _getEnergyCategoryRecommendation() {
    if (_userEnergyLevel >= 70) return 'High Focus';
    if (_userEnergyLevel >= 45) return 'Creative';
    if (_userEnergyLevel >= 25) return 'Light Admin';
    return 'Micro Reset';
  }

  Color _getEnergyColor(double energy) {
    if (energy >= 70) return Colors.tealAccent;
    if (energy >= 45) return Colors.amberAccent;
    if (energy >= 25) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentTabIndex,
          children: [
            _buildDashboardTab(),
            _buildFocusRoomTab(),
            _buildTaskManagerTab(),
            _buildAnalyticsTab(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) => setState(() => _currentTabIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on),
            label: 'Energy Hub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Focus Desk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Insights',
          ),
        ],
      ),
    );
  }

  // TAB 1: DASHBOARD & CIRCADIAN ENERGY MATCHING
  Widget _buildDashboardTab() {
    final recommendedCategory = _getEnergyCategoryRecommendation();
    final recommendedTasks =
        _tasks.where((t) => t.category == recommendedCategory).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Circadian Rhythm Sync',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text(
                      'EnergyPulse',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.tealAccent),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department,
                        color: Colors.amberAccent, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '$_streakDays Day Streak',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Real-time Energy Slider Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: _getEnergyColor(_userEnergyLevel).withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Current Energy Battery',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${_userEnergyLevel.round()}%',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _getEnergyColor(_userEnergyLevel),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Slider(
                  value: _userEnergyLevel,
                  min: 0,
                  max: 100,
                  activeColor: _getEnergyColor(_userEnergyLevel),
                  inactiveColor: Colors.grey.shade800,
                  onChanged: (val) {
                    setState(() {
                      _userEnergyLevel = val;
                    });
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('😴 Exhausted',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text('⚡ Flow Peak',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Smart Energy Match Suggestion
          Text(
            'Smart Task Recommendation',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Based on your $_userEnergyLevel% energy, focus on "$recommendedCategory" tasks now:',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 12),

          if (recommendedTasks.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'No pending tasks match this energy state. Try logging a new task or enjoy a short micro-rest!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recommendedTasks.length,
              itemBuilder: (context, index) {
                final task = recommendedTasks[index];
                return _buildTaskTile(task);
              },
            ),
          const SizedBox(height: 24),

          // Quick Action Launchers
          const Text(
            'Daily Micro Routines',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildQuickActionButton(
                icon: Icons.self_improvement,
                label: '4-7-8 Breathing',
                color: Colors.tealAccent,
                onTap: () {
                  setState(() => _currentTabIndex = 1);
                  _resetTimer(3, 'Breathwork');
                },
              ),
              _buildQuickActionButton(
                icon: Icons.timer,
                label: '25m Focus Sprint',
                color: Colors.amberAccent,
                onTap: () {
                  setState(() => _currentTabIndex = 1);
                  _resetTimer(25, 'Focus');
                },
              ),
              _buildQuickActionButton(
                icon: Icons.add,
                label: 'Add New Task',
                color: Colors.blueAccent,
                onTap: () => _showAddTaskSheet(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TAB 2: DESK FOCUS ROOM (HIGH SCREEN RETENTION FEATURE)
  Widget _buildFocusRoomTab() {
    final minutesStr =
        (_timerSecondsRemaining ~/ 60).toString().padLeft(2, '0');
    final secondsStr =
        (_timerSecondsRemaining % 60).toString().padLeft(2, '0');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('25m Focus'),
                selected: _activeTimerMode == 'Focus',
                onSelected: (_) => _resetTimer(25, 'Focus'),
                selectedColor: Colors.teal,
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('5m Micro Break'),
                selected: _activeTimerMode == 'Micro Break',
                onSelected: (_) => _resetTimer(5, 'Micro Break'),
                selectedColor: Colors.amber.shade700,
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('3m Breathwork'),
                selected: _activeTimerMode == 'Breathwork',
                onSelected: (_) => _resetTimer(3, 'Breathwork'),
                selectedColor: Colors.purple.shade700,
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Interactive Circular Dial / Breath visualizer
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1E293B),
              border: Border.all(
                color: _activeTimerMode == 'Breathwork'
                    ? Colors.purpleAccent
                    : Colors.tealAccent,
                width: 6,
              ),
              boxShadow: [
                BoxShadow(
                  color: (_activeTimerMode == 'Breathwork'
                          ? Colors.purpleAccent
                          : Colors.tealAccent)
                      .withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_activeTimerMode == 'Breathwork') ...[
                    Text(
                      _breathworkPhase,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.purpleAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_breathCounter',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ] else ...[
                    Text(
                      '$minutesStr:$secondsStr',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _isTimerRunning ? 'Flow State Active' : 'Paused',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Start/Pause Button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton.large(
                onPressed: _toggleTimer,
                backgroundColor:
                    _isTimerRunning ? Colors.orangeAccent : Colors.tealAccent,
                child: Icon(
                  _isTimerRunning ? Icons.pause : Icons.play_arrow,
                  size: 36,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.refresh, size: 28),
                onPressed: () => _resetTimer(
                  _activeTimerMode == 'Focus'
                      ? 25
                      : (_activeTimerMode == 'Micro Break' ? 5 : 3),
                  _activeTimerMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Ambient Background Sound Selector (Keeps users on screen!)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.widgets, color: Colors.tealAccent, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Desk Ambient Audio Companion',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['None', 'Rain', 'Forest', 'Cafe', 'Deep Focus']
                        .map((sound) {
                      final isSelected = _activeAmbientSound == sound;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(sound),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _activeAmbientSound = selected ? sound : 'None';
                            });
                          },
                          selectedColor: Colors.teal.shade800,
                          backgroundColor: const Color(0xFF0F172A),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 3: TASK MATRIX MANAGER
  Widget _buildTaskManagerTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Task Matrix',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddTaskSheet(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              final task = _tasks[index];
              return _buildTaskTile(task);
            },
          ),
        ),
      ],
    );
  }

  // TAB 4: ANALYTICS & ENERGY GAMIFICATION
  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Performance & Insights',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Overview Cards
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Focus Time',
                  '$_completedFocusMinutes mins',
                  Icons.timer,
                  Colors.tealAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Completed',
                  '${_tasks.where((t) => t.isCompleted).length} Tasks',
                  Icons.check_circle,
                  Colors.amberAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Circadian Flow Distribution Graph Simulation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Circadian Energy Peak Map',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBar('8 AM', 0.8, Colors.tealAccent),
                    _buildBar('11 AM', 0.95, Colors.tealAccent),
                    _buildBar('2 PM', 0.4, Colors.orangeAccent),
                    _buildBar('5 PM', 0.7, Colors.tealAccent),
                    _buildBar('8 PM', 0.3, Colors.redAccent),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Micro Badges
          const Text(
            'Achievements',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              Chip(
                avatar: const Icon(Icons.star, color: Colors.amberAccent),
                label: const Text('Streak Master (6 Days)'),
                backgroundColor: const Color(0xFF1E293B),
              ),
              Chip(
                avatar: const Icon(Icons.flash_on, color: Colors.tealAccent),
                label: const Text('Flow State Pioneer'),
                backgroundColor: const Color(0xFF1E293B),
              ),
              Chip(
                avatar:
                    const Icon(Icons.self_improvement, color: Colors.purpleAccent),
                label: const Text('Zen Breathing Level 1'),
                backgroundColor: const Color(0xFF1E293B),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildTaskTile(TaskItem task) {
    Color badgeColor;
    switch (task.category) {
      case 'High Focus':
        badgeColor = Colors.tealAccent;
        break;
      case 'Creative':
        badgeColor = Colors.amberAccent;
        break;
      case 'Light Admin':
        badgeColor = Colors.blueAccent;
        break;
      default:
        badgeColor = Colors.purpleAccent;
    }

    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile,
      // Wrapped inside SizedBox/Container for explicit tap actions
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Checkbox(
              value: task.isCompleted,
              activeColor: Colors.tealAccent,
              checkColor: Colors.black,
              onChanged: (val) {
                setState(() {
                  task.isCompleted = val ?? false;
                });
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: task.isCompleted ? Colors.grey : Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: badgeColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          task.category,
                          style: TextStyle(fontSize: 11, color: badgeColor),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '⏱️ ${task.durationMinutes}m',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey, size: 20),
              onPressed: () {
                setState(() {
                  _tasks.removeWhere((t) => t.id == task.id);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double heightRatio, Color color) {
    return Column(
      children: [
        Container(
          height: 100 * heightRatio,
          width: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  void _showAddTaskSheet(BuildContext context) {
    final titleController = TextEditingController();
    String selectedCategory = 'High Focus';
    int duration = 25;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Log New Micro-Task',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Task Description',
                        border: OutlineInputBorder(),
                        hintText: 'e.g. Review financial statement (\$)...',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Cognitive Load Category:'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        'High Focus',
                        'Creative',
                        'Light Admin',
                        'Micro Reset'
                      ].map((cat) {
                        return ChoiceChip(
                          label: Text(cat),
                          selected: selectedCategory == cat,
                          onSelected: (selected) {
                            if (selected) {
                              setSheetState(() => selectedCategory = cat);
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Text('Estimated Duration: $duration minutes'),
                    Slider(
                      value: duration.toDouble(),
                      min: 5,
                      max: 60,
                      divisions: 11,
                      activeColor: Colors.tealAccent,
                      onChanged: (val) {
                        setSheetState(() => duration = val.round());
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          if (titleController.text.isNotEmpty) {
                            _addNewTask(
                              titleController.text,
                              selectedCategory,
                              duration,
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Add Task',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}