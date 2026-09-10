import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const FlowDeskApp());
}

class FlowDeskApp extends StatelessWidget {
  const FlowDeskApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlowDesk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF12181F),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MicroRoutine {
  String id;
  String title;
  int durationMinutes;
  String category;
  bool isCompleted;
  IconData icon;

  MicroRoutine({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.category,
    this.isCompleted = false,
    required this.icon,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  // Active Timer State
  Timer? _timer;
  int _secondsRemaining = 25 * 60;
  int _totalSeconds = 25 * 60;
  bool _isRunning = false;
  String _activeTaskName = "Deep Focus Block";
  int _deskThemeIndex = 0; // 0: Teal, 1: Indigo, 2: Amber, 3: Dark Minimal

  // Analytics Tracking
  int _totalFocusedMinutesToday = 45;
  int _breaksCompletedToday = 3;
  int _tasksFinishedToday = 4;

  // Initial Micro Routines
  List<MicroRoutine> _routines = [
    MicroRoutine(
      id: "1",
      title: "Deep Work Sprint",
      durationMinutes: 25,
      category: "Focus",
      icon: Icons.timer,
    ),
    MicroRoutine(
      id: "2",
      title: "Hydration & Posture Reset",
      durationMinutes: 5,
      category: "Health",
      icon: Icons.water_drop,
    ),
    MicroRoutine(
      id: "3",
      title: "Inbox Triage & Clean",
      durationMinutes: 15,
      category: "Work",
      icon: Icons.mark_email_unread,
    ),
    MicroRoutine(
      id: "4",
      title: "Quick Walk & Eyes Rest",
      durationMinutes: 10,
      category: "Rest",
      icon: Icons.directions_walk,
    ),
  ];

  // Micro Decision Deck
  final List<Map<String, String>> _decisionIdeas = [
    {"title": "Drink 250ml Water", "desc": "Rehydrate your brain for optimal speed.", "time": "2 mins"},
    {"title": "20-20-20 Eye Relief", "desc": "Look 20 feet away for 20 seconds to rest eyes.", "time": "1 min"},
    {"title": "Desktop Quick Declutter", "desc": "Clean 5 files on screen or trash on desk.", "time": "3 mins"},
    {"title": "Deep Breathing Circuit", "desc": "Inhale 4s, hold 4s, exhale 6s x 5 reps.", "time": "2 mins"},
    {"title": "Light Body Stretch", "desc": "Stretch shoulders, neck, and wrist joints.", "time": "4 mins"},
    {"title": "Quick Task Prioritization", "desc": "Write down the single #1 priority next.", "time": "3 mins"},
  ];

  Map<String, String>? _selectedDecision;

  @override
  void initState() {
    super.initState();
    _selectedDecision = _decisionIdeas[0];
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
    } else {
      setState(() {
        _isRunning = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() {
            _secondsRemaining--;
          });
        } else {
          _timer?.cancel();
          setState(() {
            _isRunning = false;
            _totalFocusedMinutesToday += (_totalSeconds ~/ 60);
            _tasksFinishedToday++;
            _secondsRemaining = _totalSeconds;
          });
          _showCompletionDialog();
        }
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _secondsRemaining = _totalSeconds;
    });
  }

  void _setTimerDuration(int minutes, String taskName) {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _totalSeconds = minutes * 60;
      _secondsRemaining = minutes * 60;
      _activeTaskName = taskName;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2834),
        title: const Text("Block Completed! 🎉", style: TextStyle(color: Colors.white)),
        content: Text(
          "Great job finishing '$_activeTaskName'! Take a 5-minute break or trigger a micro-decision prompt.",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Awesome", style: TextStyle(color: Colors.tealAccent)),
          ),
        ],
      ),
    );
  }

  void _pickRandomDecision() {
    final random = Random();
    setState(() {
      _selectedDecision = _decisionIdeas[random.nextInt(_decisionIdeas.length)];
    });
  }

  void _addNewRoutine(String title, int duration, String category) {
    setState(() {
      _routines.add(
        MicroRoutine(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          durationMinutes: duration,
          category: category,
          icon: category == "Health"
              ? Icons.fitness_center
              : category == "Rest"
                  ? Icons.nature
                  : Icons.work,
        ),
      );
    });
  }

  Color _getThemePrimaryColor() {
    switch (_deskThemeIndex) {
      case 0:
        return Colors.teal;
      case 1:
        return Colors.indigo;
      case 2:
        return Colors.amber;
      case 3:
        return Colors.blueGrey;
      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = _getThemePrimaryColor();

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildDeskFlowTab(primaryColor),
            _buildRoutinePacerTab(primaryColor),
            _buildDeciderTab(primaryColor),
            _buildAnalyticsTab(primaryColor),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        backgroundColor: const Color(0xFF18202A),
        indicatorColor: primaryColor.withOpacity(0.3),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.desktop_windows, color: Colors.white70),
            selectedIcon: Icon(Icons.desktop_windows, color: Colors.tealAccent),
            label: 'Desk Flow',
          ),
          NavigationDestination(
            icon: Icon(Icons.alt_route, color: Colors.white70),
            selectedIcon: Icon(Icons.alt_route, color: Colors.tealAccent),
            label: 'Pacer',
          ),
          NavigationDestination(
            icon: Icon(Icons.casino, color: Colors.white70),
            selectedIcon: Icon(Icons.casino, color: Colors.tealAccent),
            label: 'Decider',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart, color: Colors.white70),
            selectedIcon: Icon(Icons.bar_chart, color: Colors.tealAccent),
            label: 'Stats',
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 1: DESK FLOW (Continuous Ambient Desk Display)
  // ---------------------------------------------------------------------------
  Widget _buildDeskFlowTab(Color themeColor) {
    double progress = _totalSeconds > 0 ? (1.0 - (_secondsRemaining / _totalSeconds)) : 0.0;
    int mins = _secondsRemaining ~/ 60;
    int secs = _secondsRemaining % 60;
    String timeStr = "${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "FlowDesk Ambient",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      softWrap: true,
                    ),
                    Text(
                      "Desk Display Mode - Keeps you focused",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.palette, color: Colors.white70),
                tooltip: "Change Theme",
                onPressed: () {
                  setState(() {
                    _deskThemeIndex = (_deskThemeIndex + 1) % 4;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Active Task Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: themeColor.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt, color: themeColor, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    _activeTaskName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: themeColor == Colors.amber ? Colors.amber : Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Main Pulsing Circular Timer Visual
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
                    valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      timeStr,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isRunning ? "FOCUSING" : "PAUSED",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _isRunning ? themeColor : Colors.grey,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: "btn_reset",
                onPressed: _resetTimer,
                backgroundColor: const Color(0xFF2A3442),
                child: const Icon(Icons.refresh, color: Colors.white),
              ),
              const SizedBox(width: 20),
              FloatingActionButton.large(
                heroTag: "btn_play",
                onPressed: _toggleTimer,
                backgroundColor: themeColor,
                child: Icon(
                  _isRunning ? Icons.pause : Icons.play_arrow,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 20),
              FloatingActionButton(
                heroTag: "btn_skip",
                onPressed: () {
                  _setTimerDuration(5, "Micro Rest Break");
                },
                backgroundColor: const Color(0xFF2A3442),
                child: const Icon(Icons.coffee, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Quick Preset Selectors
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Quick Focus Presets",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white70),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              _buildPresetChip("15m Sprint", 15, "15m Power Focus", themeColor),
              _buildPresetChip("25m Pomodoro", 25, "Deep Focus Block", themeColor),
              _buildPresetChip("45m Deep Work", 45, "Heavy Task Sprint", themeColor),
              _buildPresetChip("5m Chill", 5, "Micro Rest Break", themeColor),
            ],
          ),
          const SizedBox(height: 24),

          // Ambient Focus Companion Widget
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2834),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.graphic_eq, color: themeColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Ambient Rhythm Mode Active",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        softWrap: true,
                      ),
                      Text(
                        "Keep phone docked on your desk for passive focus mode.",
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String label, int mins, String taskName, Color themeColor) {
    bool isSelected = _totalSeconds == mins * 60;
    return ActionChip(
      label: Text(label),
      labelStyle: TextStyle(
        color: isSelected ? Colors.black : Colors.white,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: isSelected ? themeColor : const Color(0xFF1E2834),
      onPressed: () => _setTimerDuration(mins, taskName),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 2: ROUTINE PACER (Daily Micro Blocks)
  // ---------------------------------------------------------------------------
  Widget _buildRoutinePacerTab(Color themeColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Daily Routine Pacer",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      softWrap: true,
                    ),
                    Text(
                      "Paced micro-tasks eliminate daily overwhelm",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle, color: themeColor, size: 30),
                onPressed: () => _showAddRoutineDialog(themeColor),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _routines.length,
            itemBuilder: (context, index) {
              final item = _routines[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2834),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: item.isCompleted ? Colors.green.withOpacity(0.5) : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          item.isCompleted = !item.isCompleted;
                          if (item.isCompleted) _tasksFinishedToday++;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: item.isCompleted ? Colors.green : Colors.white70,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item.isCompleted ? Icons.check : item.icon,
                          color: item.isCompleted ? Colors.black : Colors.white70,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: item.isCompleted ? Colors.grey : Colors.white,
                              decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                            softWrap: true,
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            crossAxisAlignment: WrapCrossAxisAlignment.center,
                            children: [
                              Text(
                                "${item.durationMinutes} mins",
                                style: TextStyle(fontSize: 12, color: themeColor, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.category,
                                  style: const TextStyle(fontSize: 10, color: Colors.white70),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.play_arrow_rounded, color: Colors.tealAccent),
                      onPressed: () {
                        _setTimerDuration(item.durationMinutes, item.title);
                        setState(() {
                          _currentIndex = 0; // Switch to Desk Display
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                      onPressed: () {
                        setState(() {
                          _routines.removeAt(index);
                        });
                      },
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

  void _showAddRoutineDialog(Color themeColor) {
    final titleController = TextEditingController();
    final durationController = TextEditingController(text: "15");
    String selectedCategory = "Focus";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E2834),
              title: const Text("Add Micro Routine", style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Routine Name",
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: durationController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Duration (minutes)",
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      dropdownColor: const Color(0xFF1E2834),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Category",
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                      ),
                      items: ["Focus", "Health", "Work", "Rest"]
                          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => selectedCategory = val);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      int mins = int.tryParse(durationController.text) ?? 15;
                      _addNewRoutine(titleController.text, mins, selectedCategory);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Add Block", style: TextStyle(color: Colors.black)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 3: DECIDER (Micro-Decision Generator for Procrastination & Breaks)
  // ---------------------------------------------------------------------------
  Widget _buildDeciderTab(Color themeColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Procrastination Decider",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  softWrap: true,
                ),
                Text(
                  "Stuck or tired? Spin for a 2-minute energizing micro-action",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  softWrap: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Decider Display Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF263342), themeColor.withOpacity(0.3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: themeColor.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.auto_awesome, color: themeColor, size: 36),
                ),
                const SizedBox(height: 16),
                Text(
                  _selectedDecision?["title"] ?? "Tap Spin to Decide",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  softWrap: true,
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedDecision?["desc"] ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                  softWrap: true,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Est. Time: ${_selectedDecision?["time"] ?? "2 mins"}",
                    style: TextStyle(fontSize: 12, color: themeColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Spin Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _pickRandomDecision,
              icon: const Icon(Icons.shuffle, color: Colors.black),
              label: const Text(
                "SPIN MICRO-DECISION",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Pre-Set Micro Ideas List
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Quick Break Catalog",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white70),
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _decisionIdeas.length,
            itemBuilder: (context, idx) {
              final item = _decisionIdeas[idx];
              return Card(
                color: const Color(0xFF1E2834),
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(item["title"]!, style: const TextStyle(color: Colors.white, fontSize: 14)),
                  subtitle: Text(item["desc"]!, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  trailing: Text(item["time"]!, style: TextStyle(color: themeColor, fontSize: 11)),
                  onTap: () {
                    setState(() {
                      _selectedDecision = item;
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 4: STATS & FOCUS TIME TRACKER
  // ---------------------------------------------------------------------------
  Widget _buildAnalyticsTab(Color themeColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Flow Analytics",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            softWrap: true,
          ),
          const Text(
            "Track everyday focus output and desk retention",
            style: TextStyle(fontSize: 12, color: Colors.grey),
            softWrap: true,
          ),
          const SizedBox(height: 20),

          // Stat Grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  "Focused Today",
                  "$_totalFocusedMinutesToday min",
                  Icons.timer,
                  themeColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  "Tasks Done",
                  "$_tasksFinishedToday tasks",
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  "Breaks Taken",
                  "$_breaksCompletedToday breaks",
                  Icons.coffee,
                  Colors.amber,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  "Desk Flow Score",
                  "88%",
                  Icons.stars,
                  Colors.indigoAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Dynamic Weekly Visual Chart Simulation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2834),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Weekly Focus Trend (Minutes)",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBar("Mon", 30, themeColor),
                    _buildBar("Tue", 55, themeColor),
                    _buildBar("Wed", 40, themeColor),
                    _buildBar("Thu", 70, themeColor),
                    _buildBar("Fri", 90, themeColor),
                    _buildBar("Sat", 25, themeColor),
                    _buildBar("Sun", _totalFocusedMinutesToday, themeColor, isToday: true),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Ad Mob / Screen-Time Retention Encouragement Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: themeColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.shield, color: themeColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Desk Mode Active",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        softWrap: true,
                      ),
                      Text(
                        "Keep FlowDesk mounted on your phone stand while studying or working to maintain long flow states.",
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2834),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            softWrap: true,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
            softWrap: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String day, int val, Color color, {bool isToday = false}) {
    double heightRatio = (val / 100.0).clamp(0.15, 1.0);
    return Column(
      children: [
        Container(
          width: 18,
          height: 90 * heightRatio,
          decoration: BoxDecoration(
            color: isToday ? color : color.withOpacity(0.4),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            fontSize: 10,
            color: isToday ? Colors.white : Colors.grey,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}