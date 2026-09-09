import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const ChronoBankApp());
}

class MicroAction {
  final String id;
  final String title;
  final String category; // 'Mind', 'Body', 'Focus', 'Admin'
  final int durationMinutes;
  final String energyLevel; // 'Low', 'Medium', 'High'

  MicroAction({
    required this.id,
    required this.title,
    required this.category,
    required this.durationMinutes,
    required this.energyLevel,
  });
}

class CompletedLog {
  final String title;
  final int minutes;
  final String category;
  final DateTime timestamp;

  CompletedLog({
    required this.title,
    required this.minutes,
    required this.category,
    required this.timestamp,
  });
}

class ChronoBankApp extends StatelessWidget {
  const ChronoBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChronoBank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF10121D),
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
  int _selectedTabIndex = 0;

  // App Master Data
  int _bankedMinutesToday = 45;
  int _streakDays = 5;

  // Active Timer State
  MicroAction? _activeAction;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  bool _isTimerRunning = false;
  Timer? _timer;

  // Ambient Pacer Visual State
  String _selectedAmbientTheme = 'Zen Focus';
  final List<String> _ambientThemes = ['Zen Focus', 'Deep Cyber', 'Forest Rain', 'Solar Flow'];

  // Smart Generator Inputs
  String _selectedEnergy = 'Medium';
  int _selectedTimePocket = 10;

  // Database of Micro Actions
  final List<MicroAction> _actionLibrary = [
    MicroAction(id: '1', title: '5-Min Desk Stretch & Neck Reset', category: 'Body', durationMinutes: 5, energyLevel: 'Low'),
    MicroAction(id: '2', title: '5-Min Eye Resting & Box Breathing', category: 'Mind', durationMinutes: 5, energyLevel: 'Low'),
    MicroAction(id: '3', title: '10-Min Zero Inbox Email Blitz', category: 'Admin', durationMinutes: 10, energyLevel: 'Medium'),
    MicroAction(id: '4', title: '10-Min Hydration & Water Refill Routine', category: 'Body', durationMinutes: 10, energyLevel: 'Low'),
    MicroAction(id: '5', title: '15-Min High Focus Reading Sprint', category: 'Focus', durationMinutes: 15, energyLevel: 'High'),
    MicroAction(id: '6', title: '15-Min Workspace Clearance & Desk Detox', category: 'Admin', durationMinutes: 15, energyLevel: 'Medium'),
    MicroAction(id: '7', title: '30-Min Deep Skill Study Session', category: 'Focus', durationMinutes: 30, energyLevel: 'High'),
    MicroAction(id: '8', title: '30-Min Rapid Walk & Workout Sprint', category: 'Body', durationMinutes: 30, energyLevel: 'High'),
  ];

  final List<CompletedLog> _completionLogs = [
    CompletedLog(title: '15-Min High Focus Reading Sprint', minutes: 15, category: 'Focus', timestamp: DateTime.now().subtract(const Duration(hours: 2))),
    CompletedLog(title: '10-Min Zero Inbox Email Blitz', minutes: 10, category: 'Admin', timestamp: DateTime.now().subtract(const Duration(hours: 4))),
    CompletedLog(title: '5-Min Desk Stretch & Neck Reset', minutes: 5, category: 'Body', timestamp: DateTime.now().subtract(const Duration(hours: 6))),
    CompletedLog(title: '15-Min Workspace Clearance', minutes: 15, category: 'Admin', timestamp: DateTime.now().subtract(const Duration(hours: 7))),
  ];

  @override
  void initState() {
    super.initState();
    _activeAction = _actionLibrary[0];
    _totalSeconds = _activeAction!.durationMinutes * 60;
    _remainingSeconds = _totalSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _setActiveAction(MicroAction action) {
    _timer?.cancel();
    setState(() {
      _activeAction = action;
      _isTimerRunning = false;
      _totalSeconds = action.durationMinutes * 60;
      _remainingSeconds = _totalSeconds;
      _selectedTabIndex = 0; // Jump to live pacer
    });
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
          });
        } else {
          _timer?.cancel();
          _completeCurrentTask();
        }
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _remainingSeconds = _totalSeconds;
    });
  }

  void _completeCurrentTask() {
    _timer?.cancel();
    if (_activeAction == null) return;

    final completedMins = _activeAction!.durationMinutes;
    setState(() {
      _isTimerRunning = false;
      _bankedMinutesToday += completedMins;
      _completionLogs.insert(
        0,
        CompletedLog(
          title: _activeAction!.title,
          minutes: completedMins,
          category: _activeAction!.category,
          timestamp: DateTime.now(),
        ),
      );
      _remainingSeconds = _totalSeconds;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.indigo,
        content: Text(
          'Awesome! Banked +$completedMins minutes to your daily ledger!',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _addNewCustomAction(String title, String category, int duration, String energy) {
    final newAction = MicroAction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      category: category,
      durationMinutes: duration,
      energyLevel: energy,
    );
    setState(() {
      _actionLibrary.add(newAction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(),
            Expanded(
              child: IndexedStack(
                index: _selectedTabIndex,
                children: [
                  _buildLivePacerTab(),
                  _buildSmartPocketGeneratorTab(),
                  _buildRoutineLibraryTab(),
                  _buildTimeAuditAnalyticsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) => setState(() => _selectedTabIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF181B2C),
        selectedItemColor: Colors.indigoAccent,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Live Flow'),
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: 'Fill Pocket'),
          BottomNavigationBarItem(icon: Icon(Icons.widgets), label: 'Routines'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Audit Log'),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF181B2C),
        border: Border(bottom: BorderSide(color: Colors.white70)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.access_time_filled, color: Colors.indigoAccent),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'ChronoBank',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    'Micro-Time Budgeter',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$_streakDays Days',
                      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.teal.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.tealAccent, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${_bankedMinutesToday}m Banked',
                      style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- TAB 1: LIVE PACER & DESKTOP COMPANION ---
  Widget _buildLivePacerTab() {
    final double progress = _totalSeconds > 0 ? (_remainingSeconds / _totalSeconds) : 0;
    final int displayMins = _remainingSeconds ~/ 60;
    final int displaySecs = _remainingSeconds % 60;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Theme selector chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _ambientThemes.map((theme) {
                  final isSel = theme == _selectedAmbientTheme;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(theme),
                      selected: isSel,
                      selectedColor: Colors.indigo,
                      labelStyle: TextStyle(color: isSel ? Colors.white : Colors.grey, fontSize: 12),
                      onSelected: (val) {
                        if (val) setState(() => _selectedAmbientTheme = theme);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Active Task Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2238),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.indigoAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _activeAction?.category.toUpperCase() ?? 'GENERAL',
                          style: const TextStyle(color: Colors.indigoAccent, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '⚡ ${_activeAction?.energyLevel ?? 'Medium'} Energy',
                          style: const TextStyle(color: Colors.orangeAccent, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _activeAction?.title ?? 'No Action Selected',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Circular Visual Pacer
            Stack(
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
                      _isTimerRunning ? Colors.indigoAccent : Colors.tealAccent,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${displayMins.toString().padLeft(2, '0')}:${displaySecs.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isTimerRunning ? Icons.graphic_eq : Icons.pause_circle_outline,
                          color: Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isTimerRunning ? 'Pacing Active' : 'Paused',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  iconSize: 28,
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _toggleTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isTimerRunning ? Colors.amber.shade800 : Colors.indigo,
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Row(
                    children: [
                      Icon(_isTimerRunning ? Icons.pause : Icons.play_arrow, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        _isTimerRunning ? 'Pause Flow' : 'Start Flow',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                IconButton.filledTonal(
                  iconSize: 28,
                  onPressed: _completeCurrentTask,
                  icon: const Icon(Icons.check),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Quick Switch Actions Strip
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Quick Switch Micro-Action:',
                style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _actionLibrary.take(4).map((act) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      backgroundColor: const Color(0xFF1E2238),
                      label: Text('${act.durationMinutes}m - ${act.title}'),
                      labelStyle: const TextStyle(color: Colors.white70, fontSize: 11),
                      onPressed: () => _setActiveAction(act),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 2: SMART POCKET GENERATOR ---
  Widget _buildSmartPocketGeneratorTab() {
    final filtered = _actionLibrary.where((act) {
      return act.durationMinutes <= _selectedTimePocket;
    }).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fill My Idle Time Pocket',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            const Text(
              'Select your available time & current energy to instantly generate optimal micro-routines.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 24),

            // Step 1: Time Pocket Selector
            const Text(
              '1. Available Time Pocket',
              style: TextStyle(color: Colors.indigoAccent, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Row(
              children: [5, 10, 15, 30].map((mins) {
                final isSelected = _selectedTimePocket == mins;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () => setState(() => _selectedTimePocket = mins),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.indigo : const Color(0xFF1E2238),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.indigoAccent : Colors.transparent,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${mins}m',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.grey,
                              ),
                            ),
                            const Text('Pocket', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Step 2: Energy Selector
            const Text(
              '2. Current Energy Level',
              style: TextStyle(color: Colors.indigoAccent, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Row(
              children: ['Low', 'Medium', 'High'].map((energy) {
                final isSelected = _selectedEnergy == energy;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () => setState(() => _selectedEnergy = energy),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.deepPurple : const Color(0xFF1E2238),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.purpleAccent : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bolt,
                              size: 16,
                              color: isSelected ? Colors.amber : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              energy,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recommended Micro-Actions:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  '${filtered.length} Found',
                  style: const TextStyle(fontSize: 12, color: Colors.tealAccent),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (filtered.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2238),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'No exact actions fit this filter. Try selecting a larger time pocket!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              Column(
                children: filtered.map((action) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2238),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.indigo.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${action.durationMinutes}m',
                            style: const TextStyle(
                              color: Colors.indigoAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                action.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    action.category,
                                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '•  ⚡ ${action.energyLevel}',
                                    style: const TextStyle(color: Colors.amber, fontSize: 11),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _setActiveAction(action),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Start', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  // --- TAB 3: ROUTINE LIBRARY & CREATOR ---
  Widget _buildRoutineLibraryTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Micro-Routine Stacks',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'Manage your daily habit building library',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddActionBottomSheet(context),
                  icon: const Icon(Icons.add, size: 18, color: Colors.white),
                  label: const Text('New', style: TextStyle(color: Colors.white, fontSize: 12)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                ),
              ],
            ),
            const SizedBox(height: 20),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _actionLibrary.length,
              itemBuilder: (context, index) {
                final action = _actionLibrary[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2238),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        action.category == 'Body'
                            ? Icons.fitness_center
                            : action.category == 'Mind'
                                ? Icons.psychology
                                : action.category == 'Focus'
                                    ? Icons.lightbulb
                                    : Icons.inventory_2,
                        color: Colors.indigoAccent,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              action.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${action.durationMinutes} mins  |  Category: ${action.category}  |  Energy: ${action.energyLevel}',
                              style: const TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.play_circle_fill, color: Colors.tealAccent, size: 28),
                        onPressed: () => _setActiveAction(action),
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

  // --- TAB 4: TIME AUDIT & ANALYTICS ---
  Widget _buildTimeAuditAnalyticsTab() {
    int mindMins = 0;
    int bodyMins = 0;
    int focusMins = 0;
    int adminMins = 0;

    for (var log in _completionLogs) {
      if (log.category == 'Mind') mindMins += log.minutes;
      if (log.category == 'Body') bodyMins += log.minutes;
      if (log.category == 'Focus') focusMins += log.minutes;
      if (log.category == 'Admin') adminMins += log.minutes;
    }

    final totalLogged = mindMins + bodyMins + focusMins + adminMins;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Time Audit Ledger',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            const Text(
              'Track how you invested your daily micro-time pockets',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 20),

            // Daily Summary Cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2238),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Deposited', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 6),
                        Text(
                          '${_bankedMinutesToday}m',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2238),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Blocks Done', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 6),
                        Text(
                          '${_completionLogs.length}',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigoAccent),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Category Distribution
            const Text(
              'Category Breakdown Today',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),

            _buildCategoryProgressRow('Focus Sprints', focusMins, totalLogged, Colors.indigoAccent),
            _buildCategoryProgressRow('Body & Wellness', bodyMins, totalLogged, Colors.tealAccent),
            _buildCategoryProgressRow('Admin & Tasks', adminMins, totalLogged, Colors.amberAccent),
            _buildCategoryProgressRow('Mind & Recovery', mindMins, totalLogged, Colors.purpleAccent),

            const SizedBox(height: 24),

            const Text(
              'Audit Activity History',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _completionLogs.length,
              itemBuilder: (context, index) {
                final log = _completionLogs[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2238),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.tealAccent, size: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          log.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text(
                        '+${log.minutes} mins',
                        style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 12),
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

  Widget _buildCategoryProgressRow(String label, int mins, int total, Color color) {
    final double ratio = total > 0 ? (mins / total) : 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text('${mins}m (${(ratio * 100).toInt()}%)', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: Colors.white70,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddActionBottomSheet(BuildContext context) {
    final titleController = TextEditingController();
    String selectedCategory = 'Focus';
    String selectedEnergy = 'Medium';
    int selectedDuration = 10;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF181B2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create Custom Micro-Action',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Action Title',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedCategory,
                            dropdownColor: const Color(0xFF1E2238),
                            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Category'),
                            items: ['Focus', 'Body', 'Mind', 'Admin'].map((cat) {
                              return DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(color: Colors.white)));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => selectedCategory = val);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: selectedDuration,
                            dropdownColor: const Color(0xFF1E2238),
                            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Minutes'),
                            items: [5, 10, 15, 30].map((dur) {
                              return DropdownMenuItem(value: dur, child: Text('${dur}m', style: const TextStyle(color: Colors.white)));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => selectedDuration = val);
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          if (titleController.text.trim().isNotEmpty) {
                            _addNewCustomAction(
                              titleController.text.trim(),
                              selectedCategory,
                              selectedDuration,
                              selectedEnergy,
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Save Micro-Action', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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