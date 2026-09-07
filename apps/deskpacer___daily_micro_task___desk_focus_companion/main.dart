import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const DeskPacerApp());
}

class DeskPacerApp extends StatelessWidget {
  const DeskPacerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeskPacer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF12181B),
      ),
      home: const MainDeskScreen(),
    );
  }
}

class MicroTask {
  final String id;
  final String title;
  final int durationMinutes; // e.g. 2, 5, 10, 15, 30
  final String category;
  bool isCompleted;

  MicroTask({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.category,
    this.isCompleted = false,
  });
}

class MainDeskScreen extends StatefulWidget {
  const MainDeskScreen({super.key});

  @override
  State<MainDeskScreen> createState() => _MainDeskScreenState();
}

class _MainDeskScreenState extends State<MainDeskScreen> {
  int _selectedTabIndex = 0;

  // Focus Timer State
  static const int _defaultFocusSeconds = 25 * 60;
  int _remainingSeconds = _defaultFocusSeconds;
  bool _isTimerRunning = false;
  Timer? _timer;
  String _activePhase = "Deep Focus"; // "Deep Focus" or "Micro Break"

  // Wellness Tracker State
  int _waterGlasses = 4;
  int _eyeRestCount = 3;
  int _stretchCount = 2;
  int _totalFocusMinutesToday = 85;

  // Gap Finder State
  int _selectedGapMinutes = 5;

  // Task List
  final List<MicroTask> _tasks = [
    MicroTask(id: '1', title: 'Clear inbox unread count', durationMinutes: 5, category: 'Admin'),
    MicroTask(id: '2', title: 'Organize desktop downloads folder', durationMinutes: 5, category: 'Tech'),
    MicroTask(id: '3', title: 'Review pull request feedback', durationMinutes: 10, category: 'Work'),
    MicroTask(id: '4', title: 'Send quick client status update email', durationMinutes: 2, category: 'Communication'),
    MicroTask(id: '5', title: 'Plan tomorrow\'s top 3 priority tasks', durationMinutes: 10, category: 'Planning'),
    MicroTask(id: '6', title: 'Do 2-minute posture stretch', durationMinutes: 2, category: 'Health'),
    MicroTask(id: '7', title: 'Read 1 saved article', durationMinutes: 15, category: 'Learning'),
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isTimerRunning) {
      _timer?.cancel();
      setState(() {
        _isTimerRunning = false;
      });
    } else {
      setState(() {
        _isTimerRunning = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
            if (_remainingSeconds % 60 == 0 && _activePhase == "Deep Focus") {
              _totalFocusMinutesToday++;
            }
          });
        } else {
          _timer?.cancel();
          setState(() {
            _isTimerRunning = false;
            if (_activePhase == "Deep Focus") {
              _activePhase = "Micro Break";
              _remainingSeconds = 5 * 60;
            } else {
              _activePhase = "Deep Focus";
              _remainingSeconds = _defaultFocusSeconds;
            }
          });
        }
      });
    }
  }

  void _resetTimer(int minutes) {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _remainingSeconds = minutes * 60;
      _activePhase = minutes <= 10 ? "Micro Break" : "Deep Focus";
    });
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _addNewTask(String title, int duration, String category) {
    setState(() {
      _tasks.add(MicroTask(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        durationMinutes: duration,
        category: category,
      ));
    });
  }

  void _toggleTaskCompletion(String id) {
    setState(() {
      final index = _tasks.indexWhere((task) => task.id == id);
      if (index != -1) {
        _tasks[index].isCompleted = !_tasks[index].isCompleted;
      }
    });
  }

  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    int duration = 5;
    String category = 'Work';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulWidget(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E262B),
              title: const Text('Add Micro-Task', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Task Description',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Duration:', style: TextStyle(color: Colors.white70)),
                        const SizedBox(width: 12),
                        DropdownButton<int>(
                          value: duration,
                          dropdownColor: const Color(0xFF2A343B),
                          style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
                          items: [2, 5, 10, 15, 30].map((int val) {
                            return DropdownMenuItem<int>(
                              value: val,
                              child: Text('$val mins'),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            if (newVal != null) {
                              setDialogState(() => duration = newVal);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Category:', style: TextStyle(color: Colors.white70)),
                        const SizedBox(width: 12),
                        DropdownButton<String>(
                          value: category,
                          dropdownColor: const Color(0xFF2A343B),
                          style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
                          items: ['Work', 'Admin', 'Tech', 'Communication', 'Health', 'Planning'].map((String val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            if (newVal != null) {
                              setDialogState(() => category = newVal);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () {
                    if (titleController.text.trim().isNotEmpty) {
                      _addNewTask(titleController.text.trim(), duration, category);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Task', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E262B),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.tune, color: Colors.tealAccent),
            SizedBox(width: 8),
            Text(
              'DeskPacer',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.tealAccent.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${_totalFocusMinutesToday}m Focused',
                  style: const TextStyle(color: Colors.tealAccent, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedTabIndex,
          children: [
            _buildDeskCompanionTab(),
            _buildGapFinderTab(),
            _buildTaskManagerTab(),
            _buildDeskStatsTab(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1E262B),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Desk Companion',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Gap Finder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Micro-Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Desk Stats',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: DESK COMPANION SCREEN ---
  Widget _buildDeskCompanionTab() {
    double progress = 1.0;
    int maxSec = _activePhase == "Deep Focus" ? _defaultFocusSeconds : 5 * 60;
    if (maxSec > 0) {
      progress = (_remainingSeconds / maxSec).clamp(0.0, 1.0);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner Status
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E262B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isTimerRunning ? Colors.greenAccent : Colors.amber,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _isTimerRunning ? 'ACTIVE DESK PACER • KEEP APP OPEN' : 'DESK PACER READY • DOCKED MODE',
                  style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Central Visual Pacer Ring Timer
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 230,
                  height: 230,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.white70,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _activePhase == "Deep Focus" ? Colors.tealAccent : Colors.orangeAccent,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _activePhase.toUpperCase(),
                      style: TextStyle(
                        color: _activePhase == "Deep Focus" ? Colors.tealAccent : Colors.orangeAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _formatTime(_remainingSeconds),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Pacer Rhythm',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Timer Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _toggleTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isTimerRunning ? Colors.redAccent : Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                icon: Icon(_isTimerRunning ? Icons.pause : Icons.play_arrow, color: Colors.white),
                label: Text(
                  _isTimerRunning ? 'PAUSE' : 'START PACER',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () => _resetTimer(25),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.tealAccent),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Reset', style: TextStyle(color: Colors.tealAccent)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Presets Row
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPresetChip('25m Focus', 25),
              _buildPresetChip('50m Focus', 50),
              _buildPresetChip('5m Break', 5),
              _buildPresetChip('15m Break', 15),
            ],
          ),
          const SizedBox(height: 24),

          // Desk Micro Health Quick Check
          const Text(
            'Desk Wellness Pacing',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildWellnessCard(
                  icon: Icons.water_drop,
                  color: Colors.blueAccent,
                  title: 'Hydration',
                  subtitle: '$_waterGlasses cups today',
                  onTap: () {
                    setState(() {
                      _waterGlasses++;
                    });
                  },
                  btnText: '+1 Cup',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildWellnessCard(
                  icon: Icons.remove_red_eye,
                  color: Colors.greenAccent,
                  title: '20-20-20 Eye Rest',
                  subtitle: '$_eyeRestCount sessions',
                  onTap: () {
                    setState(() {
                      _eyeRestCount++;
                    });
                  },
                  btnText: 'Log Rest',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String label, int minutes) {
    return ActionChip(
      backgroundColor: const Color(0xFF1E262B),
      label: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      onPressed: () => _resetTimer(minutes),
    );
  }

  Widget _buildWellnessCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required String btnText,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E262B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 28,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color.withOpacity(0.2),
                elevation: 0,
                padding: EdgeInsets.zero,
              ),
              onPressed: onTap,
              child: Text(btnText, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: GAP FINDER ENGINE ---
  Widget _buildGapFinderTab() {
    List<MicroTask> matchingTasks = _tasks.where((t) => t.durationMinutes <= _selectedGapMinutes && !t.isCompleted).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Time Gap Finder',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Have a quick gap before your next meeting? Select your free time:',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Duration Gap Selector Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [2, 5, 10, 15].map((mins) {
              bool isSelected = _selectedGapMinutes == mins;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedGapMinutes = mins;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.teal : const Color(0xFF1E262B),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSelected ? Colors.tealAccent : Colors.white70),
                  ),
                  child: Text(
                    '${mins}m Gap',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Recommended Micro-tasks Container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E262B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Showing micro-tasks solvable in $\\le$ $_selectedGapMinutes minutes:',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (matchingTasks.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.tealAccent, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'No pending tasks fit in a $_selectedGapMinutes-minute gap!',
                      style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text('Add new tasks or choose a larger gap time.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: matchingTasks.length,
              itemBuilder: (context, index) {
                final task = matchingTasks[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E262B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white70),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.withOpacity(0.2),
                      child: Text(
                        '${task.durationMinutes}m',
                        style: const TextStyle(color: Colors.tealAccent, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      task.title,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      'Category: ${task.category}',
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_circle_fill, color: Colors.tealAccent, size: 28),
                      onPressed: () {
                        _resetTimer(task.durationMinutes);
                        _toggleTimer();
                        setState(() {
                          _selectedTabIndex = 0; // Switch to companion view
                        });
                      },
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // --- TAB 3: MICRO-TASK MANAGER ---
  Widget _buildTaskManagerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Micro-Task Pool',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _showAddTaskDialog,
                icon: const Icon(Icons.add, color: Colors.white, size: 18),
                label: const Text('Add Task', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              final task = _tasks[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E262B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Checkbox(
                    value: task.isCompleted,
                    activeColor: Colors.teal,
                    onChanged: (_) => _toggleTaskCompletion(task.id),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      color: task.isCompleted ? Colors.grey : Colors.white,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${task.durationMinutes} min',
                          style: const TextStyle(color: Colors.tealAccent, fontSize: 10),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        task.category,
                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey, size: 20),
                    onPressed: () => _deleteTask(task.id),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- TAB 4: DESK STATS & MOMENTUM ---
  Widget _buildDeskStatsTab() {
    int completedCount = _tasks.where((t) => t.isCompleted).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Desk Analytics',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Overview Stats Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _buildStatMetricCard('Focus Time', '${_totalFocusMinutesToday}m', Icons.timer, Colors.tealAccent),
              _buildStatMetricCard('Tasks Solved', '$completedCount / ${_tasks.length}', Icons.check_circle, Colors.amber),
              _buildStatMetricCard('Water Logs', '$_waterGlasses cups', Icons.water_drop, Colors.blueAccent),
              _buildStatMetricCard('Eye Rest Breaks', '$_eyeRestCount done', Icons.remove_red_eye, Colors.greenAccent),
            ],
          ),
          const SizedBox(height: 20),

          // Momentum Score Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E262B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.stars, color: Colors.amber),
                    SizedBox(width: 8),
                    Text(
                      'Daily Productivity Momentum',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: (_totalFocusMinutesToday / 120).clamp(0.0, 1.0),
                  backgroundColor: Colors.white70,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.tealAccent),
                  minHeight: 8,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Target: 120 mins focus',
                      style: TextStyle(color: Colors.grey[400], fontSize: 11),
                    ),
                    Text(
                      '${((_totalFocusMinutesToday / 120) * 100).clamp(0, 100).toInt()}% Achieved',
                      style: const TextStyle(color: Colors.tealAccent, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E262B),
        borderRadius: BorderRadius.circular(12),
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
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}