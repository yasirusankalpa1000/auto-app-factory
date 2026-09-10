import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const DeskPulseApp());
}

class DeskPulseApp extends StatelessWidget {
  const DeskPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeskPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainDeskScreen(),
    );
  }
}

class MicroSprintItem {
  final String id;
  final String title;
  final int minutes;
  bool isCompleted;

  MicroSprintItem({
    required this.id,
    required this.title,
    required this.minutes,
    this.isCompleted = false,
  });
}

class ImpulseItem {
  final String title;
  final double cost;
  final double hoursRequired;
  final DateTime timestamp;
  final bool resisted;

  ImpulseItem({
    required this.title,
    required this.cost,
    required this.hoursRequired,
    required this.timestamp,
    required this.resisted,
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
  int _totalSprintSeconds = 25 * 60;
  int _remainingSeconds = 25 * 60;
  bool _isTimerRunning = false;
  Timer? _focusTimer;
  String _activeTaskTitle = "Deep Focus Routine";

  // Daily Stats State
  int _completedSprints = 0;
  int _totalFocusMinutesToday = 0;
  double _userHourlyRate = 25.0;
  double _totalSavedMoney = 0.0;

  // Impulse Guard State
  final TextEditingController _impulseNameController = TextEditingController();
  final TextEditingController _impulseCostController = TextEditingController();
  final TextEditingController _hourlyRateController = TextEditingController(text: "25.0");
  
  Timer? _coolingTimer;
  int _coolingSecondsRemaining = 180;
  bool _isCoolingActive = false;
  String _currentCoolingItem = "";
  double _currentCoolingCost = 0.0;

  final List<ImpulseItem> _impulseLog = [];

  // Micro Tasks
  final List<MicroSprintItem> _taskList = [
    MicroSprintItem(id: '1', title: 'Review priority emails & inbox', minutes: 15),
    MicroSprintItem(id: '2', title: 'Write core project document draft', minutes: 45),
    MicroSprintItem(id: '3', title: 'Code refactoring micro-sprint', minutes: 25),
  ];
  final TextEditingController _newTaskController = TextEditingController();
  int _newTaskMinutes = 25;

  // Theme Customization
  Color _accentThemeColor = Colors.indigo;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusTimer?.cancel();
    _coolingTimer?.cancel();
    _impulseNameController.dispose();
    _impulseCostController.dispose();
    _hourlyRateController.dispose();
    _newTaskController.dispose();
    super.dispose();
  }

  // Timer Handlers
  void _startSprintTimer() {
    if (_focusTimer != null) _focusTimer!.cancel();
    setState(() {
      _isTimerRunning = true;
    });

    _focusTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _pauseSprintTimer();
        setState(() {
          _completedSprints++;
          _totalFocusMinutesToday += (_totalSprintSeconds / 60).round();
        });
        _showNotificationSnackBar("Sprint Completed! Take a quick breath.");
      }
    });
  }

  void _pauseSprintTimer() {
    _focusTimer?.cancel();
    setState(() {
      _isTimerRunning = false;
    });
  }

  void _resetSprintTimer(int minutes) {
    _pauseSprintTimer();
    setState(() {
      _totalSprintSeconds = minutes * 60;
      _remainingSeconds = minutes * 60;
    });
  }

  // Cooling Down Timer Handlers
  void _startCoolingTimer(String name, double cost) {
    _coolingTimer?.cancel();
    setState(() {
      _isCoolingActive = true;
      _coolingSecondsRemaining = 180;
      _currentCoolingItem = name;
      _currentCoolingCost = cost;
    });

    _coolingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_coolingSecondsRemaining > 0) {
        setState(() {
          _coolingSecondsRemaining--;
        });
      } else {
        _coolingTimer?.cancel();
        setState(() {
          _isCoolingActive = false;
        });
        _showNotificationSnackBar("Cooling period completed! Choose if you still need it.");
      }
    });
  }

  void _recordImpulseDecision(bool resisted) {
    _coolingTimer?.cancel();
    final double hoursNeeded = _userHourlyRate > 0 ? (_currentCoolingCost / _userHourlyRate) : 0.0;

    setState(() {
      if (resisted) {
        _totalSavedMoney += _currentCoolingCost;
      }
      _impulseLog.insert(
        0,
        ImpulseItem(
          title: _currentCoolingItem.isEmpty ? "Impulse Urge" : _currentCoolingItem,
          cost: _currentCoolingCost,
          hoursRequired: hoursNeeded,
          timestamp: DateTime.now(),
          resisted: resisted,
        ),
      );
      _isCoolingActive = false;
      _impulseNameController.clear();
      _impulseCostController.clear();
      _currentCoolingItem = "";
      _currentCoolingCost = 0.0;
    });

    _showNotificationSnackBar(
      resisted
          ? "Great job! Saved \$${_currentCoolingCost.toStringAsFixed(2)} for your goals."
          : "Decision logged. Mindful tracking builds financial awareness.",
    );
  }

  void _showNotificationSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey.shade800,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _formatTimerString(int seconds) {
    final int mins = seconds ~/ 60;
    final int secs = seconds % 60;
    final String minsStr = mins < 10 ? '0$mins' : '$mins';
    final String secsStr = secs < 10 ? '0$secs' : '$secs';
    return "$minsStr:$secsStr";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                border: Border(
                  bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.bolt, color: _accentThemeColor, size: 28),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DeskPulse',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Ambient Companion & Friction Guard',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade900.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green, width: 0.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.monetization_on, color: Colors.greenAccent, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Saved: \$${_totalSavedMoney.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tab View Body
            Expanded(
              child: IndexedStack(
                index: _selectedTabIndex,
                children: [
                  _buildDeskDashboardTab(),
                  _buildImpulseGuardTab(),
                  _buildMicroSprintsTab(),
                  _buildStatsAndDeckTab(),
                ],
              ),
            ),

            // Persistent Ambient Ad Banner Placeholder (Monetization Engine)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              color: const Color(0xFF020617),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.stars, color: Colors.amber.shade700, size: 14),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Desk Companion Active • AdMob Banner Slot Enabled',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Navigation
            NavigationBar(
              selectedIndex: _selectedTabIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              backgroundColor: const Color(0xFF0F172A),
              indicatorColor: _accentThemeColor.withOpacity(0.3),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.timer_outlined),
                  selectedIcon: Icon(Icons.timer, color: Colors.white),
                  label: 'Desk Timer',
                ),
                NavigationDestination(
                  icon: Icon(Icons.shield_outlined),
                  selectedIcon: Icon(Icons.shield, color: Colors.white),
                  label: 'Impulse Guard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.format_list_bulleted),
                  selectedIcon: Icon(Icons.checklist, color: Colors.white),
                  label: 'Micro Sprints',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bar_chart_outlined),
                  selectedIcon: Icon(Icons.bar_chart, color: Colors.white),
                  label: 'Desk Stats',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 1: DESK DASHBOARD (AMBIENT FOCUS TIMER)
  // ---------------------------------------------------------------------------
  Widget _buildDeskDashboardTab() {
    final double progress = _totalSprintSeconds > 0
        ? (1.0 - (_remainingSeconds / _totalSprintSeconds))
        : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Current Task Header Badge
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Row(
              children: [
                Icon(Icons.play_circle_outline, color: _accentThemeColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CURRENT SPRINT FOCUS',
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _activeTaskTitle,
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Main Visual Ambient Dial
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 220,
                height: 220,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 12,
                  backgroundColor: Colors.white70,
                  valueColor: AlwaysStoppedAnimation<Color>(_accentThemeColor),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTimerString(_remainingSeconds),
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
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isTimerRunning ? Colors.greenAccent : Colors.amberAccent,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _isTimerRunning ? "Sprinting (Desk Active)" : "Pacing Paused",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Preset Sprint Selector Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              _buildSprintChip(15, '15m Micro'),
              _buildSprintChip(25, '25m Standard'),
              _buildSprintChip(45, '45m Deep Work'),
              _buildSprintChip(60, '60m Marathon'),
            ],
          ),

          const SizedBox(height: 28),

          // Play / Pause / Reset Control Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                onPressed: () => _resetSprintTimer(_totalSprintSeconds ~/ 60),
                icon: const Icon(Icons.refresh),
                iconSize: 24,
                padding: const EdgeInsets.all(14),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _isTimerRunning ? _pauseSprintTimer : _startSprintTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentThemeColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: Icon(_isTimerRunning ? Icons.pause : Icons.play_arrow, size: 28),
                label: Text(
                  _isTimerRunning ? 'PAUSE PULSE' : 'START PULSE',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Desk Ambient Tip Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Keep this screen open on your phone desk stand to maintain ambient focus and track daily productivity flow.',
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 11),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSprintChip(int minutes, String label) {
    final bool isSelected = (_totalSprintSeconds ~/ 60) == minutes;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: _accentThemeColor,
      backgroundColor: const Color(0xFF1E293B),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey.shade300,
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (selected) {
        if (selected) {
          _resetSprintTimer(minutes);
        }
      },
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 2: IMPULSE GUARD (FRICTION & MONEY-TIME GUARD)
  // ---------------------------------------------------------------------------
  Widget _buildImpulseGuardTab() {
    final double cost = double.tryParse(_impulseCostController.text) ?? 0.0;
    final double hourly = double.tryParse(_hourlyRateController.text) ?? 25.0;
    final double calculatedWorkHours = hourly > 0 ? (cost / hourly) : 0.0;
    final int workMinsTotal = (calculatedWorkHours * 60).round();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Impulse Friction & Money-Time Guard',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            'Felt an urge to buy takeout or a non-essential item? Evaluate its true cost in work hours first.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Hourly Wage Input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.work_outline, color: Colors.tealAccent, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Your Hourly Value (\$):',
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 13),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: TextField(
                    controller: _hourlyRateController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      isDense: true,
                    ),
                    onChanged: (val) {
                      setState(() {
                        _userHourlyRate = double.tryParse(val) ?? 25.0;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Impulse Evaluator Input Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _impulseNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'What is the impulse buy/urge?',
                    hintText: 'e.g. Gourmet Coffee & Snack',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _impulseCostController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Cost in Dollars (\$)',
                    hintText: '18.50',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() {}),
                ),
                const SizedBox(height: 16),

                // Live Friction Computation Banner
                if (cost > 0) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.shade900.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.deepOrange.shade400, width: 0.8),
                    ),
                    child: Column,
                  ),
                ],

                const SizedBox(height: 16),

                // Action Button: Start Cooling Timer
                if (!_isCoolingActive)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: (cost > 0 && _impulseNameController.text.isNotEmpty)
                          ? () {
                              _startCoolingTimer(_impulseNameController.text, cost);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade800,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.timer_outlined),
                      label: const Text(
                        'START 3-MIN COOLING LOCK',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Active 3-Min Cooling Tank Lock Widget
          if (_isCoolingActive) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade900,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber, width: 1.5),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.hourglass_bottom, color: Colors.amber),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Cooling Period Active for "$_currentCoolingItem"',
                          style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _formatTimerString(_coolingSecondsRemaining),
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pause and breathe. Is this purchase aligned with your long-term goals?',
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _recordImpulseDecision(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Resisted & Saved!'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _recordImpulseDecision(false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade300,
                            side: const BorderSide(color: Colors.grey),
                          ),
                          child: const Text('Bought / Gave In'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),
          const Text(
            'Recent Impulse Log',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),

          _impulseLog.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'No impulses logged yet today. Use the friction tank above when urges arise!',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _impulseLog.length,
                  itemBuilder: (context, index) {
                    final item = _impulseLog[index];
                    return Card(
                      color: const Color(0xFF1E293B),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          item.resisted ? Icons.check_circle : Icons.cancel,
                          color: item.resisted ? Colors.green : Colors.grey,
                        ),
                        title: Text(
                          item.title,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        subtitle: Text(
                          'Equaled ${item.hoursRequired.toStringAsFixed(1)} hrs of work',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        trailing: Text(
                          '${item.resisted ? "+" : ""}\$${item.cost.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: item.resisted ? Colors.greenAccent : Colors.grey.shade400,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
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

  // Helper widget builder for friction formula card
  Widget get _buildFrictionFormulaWidget {
    final double cost = double.tryParse(_impulseCostController.text) ?? 0.0;
    final double hourly = double.tryParse(_hourlyRateController.text) ?? 25.0;
    final double calculatedWorkHours = hourly > 0 ? (cost / hourly) : 0.0;
    final int workMinsTotal = (calculatedWorkHours * 60).round();

    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'This urge equals $workMinsTotal mins (${calculatedWorkHours.toStringAsFixed(1)} hrs) of focused labor.',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 3: MICRO SPRINTS PLANNER
  // ---------------------------------------------------------------------------
  Widget _buildMicroSprintsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Sprint Queue',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Break daily work into manageable 15-45 min sprints.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Add New Task Widget
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _newTaskController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Sprint Task Title (e.g. Write intro section)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Duration:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: _newTaskMinutes,
                      dropdownColor: const Color(0xFF1E293B),
                      style: const TextStyle(color: Colors.white),
                      items: [15, 25, 45, 60].map((mins) {
                        return DropdownMenuItem<int>(
                          value: mins,
                          child: Text('$mins mins'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _newTaskMinutes = val;
                          });
                        }
                      },
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_newTaskController.text.trim().isNotEmpty) {
                          setState(() {
                            _taskList.add(
                              MicroSprintItem(
                                id: DateTime.now().toString(),
                                title: _newTaskController.text.trim(),
                                minutes: _newTaskMinutes,
                              ),
                            );
                            _newTaskController.clear();
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: _accentThemeColor),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Task'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Task List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _taskList.length,
            itemBuilder: (context, index) {
              final task = _taskList[index];
              return Card(
                color: const Color(0xFF1E293B),
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Checkbox(
                        value: task.isCompleted,
                        activeColor: _accentThemeColor,
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
                                color: task.isCompleted ? Colors.grey : Colors.white,
                                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${task.minutes} minute sprint',
                              style: const TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.play_arrow_rounded, color: Colors.tealAccent),
                        tooltip: 'Load into Timer',
                        onPressed: () {
                          setState(() {
                            _activeTaskTitle = task.title;
                            _selectedTabIndex = 0;
                            _resetSprintTimer(task.minutes);
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                        onPressed: () {
                          setState(() {
                            _taskList.removeAt(index);
                          });
                        },
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

  // ---------------------------------------------------------------------------
  // TAB 4: DESK STATS & THEME DECK
  // ---------------------------------------------------------------------------
  Widget _buildStatsAndDeckTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Desk Analytics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Track your daily ambient focus score and friction stats.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Stat Cards Grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Focus Minutes',
                  '$_totalFocusMinutesToday mins',
                  Icons.timer,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  'Sprints Done',
                  '$_completedSprints',
                  Icons.check_circle_outline,
                  Colors.teal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Money Saved',
                  '\$${_totalSavedMoney.toStringAsFixed(2)}',
                  Icons.monetization_on_outlined,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  'Urges Neutralized',
                  '${_impulseLog.where((element) => element.resisted).length}',
                  Icons.shield_outlined,
                  Colors.amber,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Text(
            'Desk Pulse Theme Accent',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          // Theme Color Pickers
          Wrap(
            spacing: 12,
            children: [
              _buildThemePickerChip(Colors.indigo, 'Deep Indigo'),
              _buildThemePickerChip(Colors.teal, 'Cyber Teal'),
              _buildThemePickerChip(Colors.amber, 'Sunset Amber'),
              _buildThemePickerChip(Colors.deepOrange, 'Focus Pulse'),
            ],
          ),

          const SizedBox(height: 24),

          // AdMob Screen-Time Monetization Notice
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.auto_awesome, color: Colors.amber, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Monetization Potential Deck',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'DeskPulse keeps your device display soft & active on your workstation desk. This prolonged display time delivers high AdMob ad impression revenue.',
                  style: TextStyle(color: Colors.grey.shade300, fontSize: 11),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildThemePickerChip(Color color, String name) {
    final bool isSelected = _accentThemeColor.value == color.value;
    return ChoiceChip(
      label: Text(name),
      selected: isSelected,
      selectedColor: color,
      backgroundColor: const Color(0xFF1E293B),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey.shade300,
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _accentThemeColor = color;
          });
        }
      },
    );
  }
}