import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const DeskPulseApp());
}

class DeskPulseApp extends StatelessWidget {
  const DeskPulseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeskPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F6F8),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Focus Timer Variables
  int _secondsRemaining = 1500; // 25 minutes default
  int _initialSeconds = 1500;
  bool _isTimerRunning = false;
  Timer? _timer;

  // Sound generator visual toggles
  bool _rainActive = false;
  bool _cafeActive = false;
  bool _forestActive = false;
  bool _wavesActive = false;

  // Ergonomic checklist state
  final List<bool> _stretchesDone = [false, false, false, false];
  int _eyeTimerSeconds = 20;
  bool _isEyeTimerRunning = false;
  Timer? _eyeTimer;

  // Work-to-Price Calculator state
  final TextEditingController _wageController = TextEditingController(text: "25");
  final TextEditingController _priceController = TextEditingController(text: "85");
  final TextEditingController _itemController = TextEditingController(text: "Wireless Headphones");
  String _calculatedWorkCost = "";
  int _impulseSeconds = 900; // 15 minutes impulse delay timer
  bool _isImpulseRunning = false;
  Timer? _impulseTimer;

  // Stats
  int _totalFocusMinutes = 50;
  int _breaksCompleted = 3;
  int _streakDays = 4;

  @override
  void dispose() {
    _timer?.cancel();
    _eyeTimer?.cancel();
    _impulseTimer?.cancel();
    _wageController.dispose();
    _priceController.dispose();
    _itemController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_timer != null) _timer!.cancel();
    setState(() => _isTimerRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer!.cancel();
        setState(() {
          _isTimerRunning = false;
          _totalFocusMinutes += (_initialSeconds ~/ 60);
          _secondsRemaining = _initialSeconds;
        });
      }
    });
  }

  void _pauseTimer() {
    if (_timer != null) _timer!.cancel();
    setState(() => _isTimerRunning = false);
  }

  void _resetTimer(int seconds) {
    if (_timer != null) _timer!.cancel();
    setState(() {
      _initialSeconds = seconds;
      _secondsRemaining = seconds;
      _isTimerRunning = false;
    });
  }

  void _startEyeTimer() {
    if (_eyeTimer != null) _eyeTimer!.cancel();
    setState(() {
      _eyeTimerSeconds = 20;
      _isEyeTimerRunning = true;
    });
    _eyeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_eyeTimerSeconds > 0) {
        setState(() => _eyeTimerSeconds--);
      } else {
        _eyeTimer!.cancel();
        setState(() {
          _isEyeTimerRunning = false;
          _breaksCompleted++;
        });
      }
    });
  }

  void _calculateWorkCost() {
    final double wage = double.tryParse(_wageController.text) ?? 0;
    final double price = double.tryParse(_priceController.text) ?? 0;
    final String item = _itemController.text.trim().isEmpty ? "this item" : _itemController.text.trim();

    if (wage <= 0 || price <= 0) {
      setState(() {
        _calculatedWorkCost = "Please enter valid hourly wage and item cost.";
      });
      return;
    }

    final double totalHours = price / wage;
    final int hours = totalHours.floor();
    final int minutes = ((totalHours - hours) * 60).round();

    setState(() {
      if (hours > 0) {
        _calculatedWorkCost = "Buying \"$item\" costs $hours hr $minutes min of pure focused work!";
      } else {
        _calculatedWorkCost = "Buying \"$item\" costs $minutes min of focused work!";
      }
    });
  }

  void _startImpulseTimer() {
    if (_impulseTimer != null) _impulseTimer!.cancel();
    setState(() {
      _impulseSeconds = 900;
      _isImpulseRunning = true;
    });
    _impulseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_impulseSeconds > 0) {
        setState(() => _impulseSeconds--);
      } else {
        _impulseTimer!.cancel();
        setState(() => _isImpulseRunning = false);
      }
    });
  }

  String _formatSeconds(int sec) {
    final int m = sec ~/ 60;
    final int s = sec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildFocusStudioTab(),
      _buildErgonomicsTab(),
      _buildImpulseCalculatorTab(),
      _buildStatsTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: Row(
          children: const [
            Icon(Icons.timer_outlined, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'DeskPulse Studio',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.teal.shade800,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '$_streakDays Day Streak',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_filled),
            label: 'Focus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new),
            label: 'Ergonomics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Value Guard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Activity Log',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: FOCUS & AMBIENT STUDIO ---
  Widget _buildFocusStudioTab() {
    final double progress = _initialSeconds > 0 ? (_secondsRemaining / _initialSeconds) : 0;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main Timer Display Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 10,
                            backgroundColor: Colors.teal.shade50,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _isTimerRunning ? Colors.teal : Colors.orange,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatSeconds(_secondsRemaining),
                              style: const TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isTimerRunning ? 'STAY IN FLOW' : 'READY TO FOCUS',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: _isTimerRunning ? Colors.teal : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isTimerRunning ? _pauseTimer : _startTimer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isTimerRunning ? Colors.orange : Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          icon: Icon(_isTimerRunning ? Icons.pause : Icons.play_arrow),
                          label: Text(
                            _isTimerRunning ? 'PAUSE' : 'START FLOW',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton.filledTonal(
                          onPressed: () => _resetTimer(_initialSeconds),
                          icon: const Icon(Icons.refresh),
                          tooltip: 'Reset Timer',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Mode Presets
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildPresetChip('25m Focus', 1500),
                        _buildPresetChip('50m Deep', 3000),
                        _buildPresetChip('5m Rest', 300),
                        _buildPresetChip('15m Break', 900),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Ambient Sound Simulator
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.volume_up, color: Colors.teal),
                        SizedBox(width: 8),
                        Text(
                          'Ambient Desk Atmosphere',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Toggle background white-noise profiles to stay tuned in:',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    _buildSoundToggleTile(
                      title: 'Soft Rain & Window Drops',
                      icon: Icons.water_drop,
                      isActive: _rainActive,
                      onChanged: (val) => setState(() => _rainActive = val),
                    ),
                    _buildSoundToggleTile(
                      title: 'Quiet Coffee Shop Hums',
                      icon: Icons.local_cafe,
                      isActive: _cafeActive,
                      onChanged: (val) => setState(() => _cafeActive = val),
                    ),
                    _buildSoundToggleTile(
                      title: 'Pine Forest & Wind',
                      icon: Icons.park,
                      isActive: _forestActive,
                      onChanged: (val) => setState(() => _forestActive = val),
                    ),
                    _buildSoundToggleTile(
                      title: 'Ocean Deep Focus Waves',
                      icon: Icons.waves,
                      isActive: _wavesActive,
                      onChanged: (val) => setState(() => _wavesActive = val),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip(String label, int seconds) {
    final bool isSelected = _initialSeconds == seconds;
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      selectedColor: Colors.teal.shade100,
      checkmarkColor: Colors.teal,
      labelStyle: TextStyle(
        color: isSelected ? Colors.teal.shade900 : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (_) => _resetTimer(seconds),
    );
  }

  Widget _buildSoundToggleTile({
    required String title,
    required IconData icon,
    required bool isActive,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.teal.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isActive ? Colors.teal.shade300 : Colors.transparent),
      ),
      child: Row(
        children: [
          Icon(icon, color: isActive ? Colors.teal : Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.teal.shade900 : Colors.black87,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Switch(
            value: isActive,
            activeColor: Colors.teal,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // --- TAB 2: ERGONOMICS & EYE REST ---
  Widget _buildErgonomicsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 20-20-20 Eye Rest Tool
            Card(
              elevation: 2,
              color: Colors.teal.shade800,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.remove_red_eye, color: Colors.amber, size: 28),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '20-20-20 Eye Relief Trainer',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Every 20 minutes, look at an object 20 feet away for 20 seconds to prevent digital eye strain.',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade900,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${_eyeTimerSeconds}s',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _isEyeTimerRunning ? null : _startEyeTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      icon: const Icon(Icons.timer),
                      label: Text(
                        _isEyeTimerRunning ? 'LOOK 20 FT AWAY NOW' : 'START 20s EYE REST',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Desk Stretches Checklist
            const Text(
              'Quick Desk Micro-Stretches',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _buildStretchCard(
              index: 0,
              title: 'Neck Roll & Tilt',
              instruction: 'Slowly tilt head to left shoulder for 10s, then right for 10s.',
              icon: Icons.self_improvement,
            ),
            _buildStretchCard(
              index: 1,
              title: 'Shoulder Blade Squeeze',
              instruction: 'Pull shoulders back and squeeze blades together for 15s.',
              icon: Icons.fitness_center,
            ),
            _buildStretchCard(
              index: 2,
              title: 'Seated Spinal Twist',
              instruction: 'Place right hand on left knee and gently twist torso. Repeat side.',
              icon: Icons.airline_seat_recline_extra,
            ),
            _buildStretchCard(
              index: 3,
              title: 'Wrist & Finger Extension',
              instruction: 'Extend arm, gently pull fingers backward with other hand.',
              icon: Icons.pan_tool,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStretchCard({
    required int index,
    required String title,
    required String instruction,
    required IconData icon,
  }) {
    final bool isDone = _stretchesDone[index];
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isDone ? Colors.green.shade100 : Colors.teal.shade50,
              child: Icon(icon, color: isDone ? Colors.green : Colors.teal),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                    softWrap: true,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    instruction,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            Checkbox(
              value: isDone,
              activeColor: Colors.green,
              onChanged: (val) {
                setState(() {
                  _stretchesDone[index] = val ?? false;
                });
              },
            )
          ],
        ),
      ),
    );
  }

  // --- TAB 3: IMPULSE CONTROL & VALUE CALCULATOR ---
  Widget _buildImpulseCalculatorTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.monetization_on, color: Colors.teal, size: 28),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Work-Hour Purchase Visualizer',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Curb online shopping impulses! See exactly how many hours of focus work an item costs you.',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    // Inputs
                    TextField(
                      controller: _wageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Your Hourly Earnings (\$) ',
                        prefixText: '\$ ',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _itemController,
                      decoration: const InputDecoration(
                        labelText: 'Desired Item Name',
                        hintText: 'e.g. Wireless Mouse, Jacket',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Item Price (\$) ',
                        prefixText: '\$ ',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _calculateWorkCost,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.calculate),
                        label: const Text(
                          'CALCULATE WORK COST',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    if (_calculatedWorkCost.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber.shade400),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lightbulb, color: Colors.amber),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _calculatedWorkCost,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Impulse Delay Cool-Down Timer
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.shield, color: Colors.indigo),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '15-Min Impulse Cool-Down Timer',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Psychology shows waiting 15 minutes eliminates 80% of accidental impulse online purchases.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _formatSeconds(_impulseSeconds),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _isImpulseRunning ? null : _startImpulseTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text(_isImpulseRunning ? 'COOL DOWN IN PROGRESS...' : 'START 15-MIN DELAY'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 4: DAILY STATS & ACHIEVEMENTS ---
  Widget _buildStatsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Today\'s Desk Performance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Stat Summary Grid
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Focus Time',
                    value: '$_totalFocusMinutes mins',
                    icon: Icons.timer,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: 'Rest Breaks',
                    value: '$_breaksCompleted done',
                    icon: Icons.remove_red_eye,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Current Streak',
                    value: '$_streakDays Days',
                    icon: Icons.stars,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: 'Stretches Done',
                    value: '${_stretchesDone.where((e) => e).length}/4',
                    icon: Icons.accessibility_new,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'Desk Mastery Badges',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildBadgeCard(
                  title: 'Flow Starter',
                  desc: 'Completed first 25m session',
                  isUnlocked: _totalFocusMinutes >= 25,
                  icon: Icons.bolt,
                ),
                _buildBadgeCard(
                  title: 'Eye Protector',
                  desc: 'Took 3 eye relief breaks',
                  isUnlocked: _breaksCompleted >= 3,
                  icon: Icons.visibility,
                ),
                _buildBadgeCard(
                  title: 'Ergo Champion',
                  desc: 'Completed all 4 daily stretches',
                  isUnlocked: _stretchesDone.where((e) => e).length == 4,
                  icon: Icons.workspace_premium,
                ),
                _buildBadgeCard(
                  title: 'Impulse Shield',
                  desc: 'Calculated work-hour cost',
                  isUnlocked: _calculatedWorkCost.isNotEmpty,
                  icon: Icons.verified_user,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeCard({
    required String title,
    required String desc,
    required bool isUnlocked,
    required IconData icon,
  }) {
    return Container(
      width: (MediaQuery.of(context).size.width - 44) / 2,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.white : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnlocked ? Colors.teal.shade300 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: isUnlocked ? Colors.teal : Colors.grey,
                size: 24,
              ),
              const Spacer(),
              Icon(
                isUnlocked ? Icons.check_circle : Icons.lock,
                color: isUnlocked ? Colors.green : Colors.grey,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isUnlocked ? Colors.black87 : Colors.grey.shade700,
            ),
            softWrap: true,
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: TextStyle(
              fontSize: 11,
              color: isUnlocked ? Colors.grey.shade700 : Colors.grey.shade600,
            ),
            softWrap: true,
          ),
        ],
      ),
    );
  }
}