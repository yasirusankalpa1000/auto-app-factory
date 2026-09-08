import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const ImpulseShieldApp());
}

class ImpulseShieldApp extends StatelessWidget {
  const ImpulseShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImpulseShield',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const MainHomeScreen(),
    );
  }
}

class ImpulseItem {
  final String id;
  final String title;
  final double price;
  final String category;
  String status; // 'cooling', 'resisted', 'yielded'
  int secondsRemaining;
  final int totalSeconds;

  ImpulseItem({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    this.status = 'cooling',
    this.secondsRemaining = 180,
    this.totalSeconds = 180,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  double _hourlyWage = 20.0;
  double _totalSavedMoney = 0.0;
  int _focusMinutes = 0;

  final List<ImpulseItem> _impulses = [];
  Timer? _globalTimer;

  // Decision Wheel Data
  final List<String> _decisionOptions = [
    'Take a 10-min Walk',
    'Drink 200ml Water',
    'Clear Desk & Organize',
    'Do 10 Deep Breaths',
    'Read 5 Pages of Book',
    '2-Minute Stretch'
  ];
  String? _selectedDecision;
  bool _isSelectingDecision = false;

  // Active Focus Timer
  Timer? _focusTimer;
  int _focusSecondsLeft = 0;
  bool _isFocusActive = false;
  int _selectedFocusDurationMinutes = 15;

  @override
  void initState() {
    super.initState();
    _startGlobalTicker();
  }

  @override
  void dispose() {
    _globalTimer?.cancel();
    _focusTimer?.cancel();
    super.dispose();
  }

  void _startGlobalTicker() {
    _globalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      bool needsUpdate = false;
      for (var impulse in _impulses) {
        if (impulse.status == 'cooling' && impulse.secondsRemaining > 0) {
          impulse.secondsRemaining--;
          needsUpdate = true;
        }
      }
      if (needsUpdate && mounted) {
        setState(() {});
      }
    });
  }

  void _addImpulse(String title, double price, String category, int minutes) {
    setState(() {
      _impulses.insert(
        0,
        ImpulseItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          price: price,
          category: category,
          secondsRemaining: minutes * 60,
          totalSeconds: minutes * 60,
        ),
      );
    });
  }

  void _markImpulseStatus(String id, String status) {
    setState(() {
      final index = _impulses.indexWhere((item) => item.id == id);
      if (index != -1) {
        _impulses[index].status = status;
        if (status == 'resisted') {
          _totalSavedMoney += _impulses[index].price;
        }
      }
    });
  }

  void _pickRandomDecision() {
    if (_decisionOptions.isEmpty) return;
    setState(() {
      _isSelectingDecision = true;
      _selectedDecision = null;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        final random = Random();
        setState(() {
          _selectedDecision = _decisionOptions[random.nextInt(_decisionOptions.length)];
          _isSelectingDecision = false;
        });
      }
    });
  }

  void _toggleFocusTimer() {
    if (_isFocusActive) {
      _focusTimer?.cancel();
      setState(() {
        _isFocusActive = false;
      });
    } else {
      if (_focusSecondsLeft <= 0) {
        _focusSecondsLeft = _selectedFocusDurationMinutes * 60;
      }
      setState(() {
        _isFocusActive = true;
      });
      _focusTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_focusSecondsLeft > 0) {
          setState(() {
            _focusSecondsLeft--;
          });
        } else {
          _focusTimer?.cancel();
          setState(() {
            _isFocusActive = false;
            _focusMinutes += _selectedFocusDurationMinutes;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Great job! Focus session completed!')),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildImpulseVaultPage(),
      _buildDecisionMatrixPage(),
      _buildFocusSprintPage(),
      _buildDashboardPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.shield, color: Colors.teal),
            SizedBox(width: 8),
            Text(
              'ImpulseShield',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Cooldown',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.casino),
            label: 'Decide',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Focus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Impact',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: IMPULSE TAMER VAULT ---
  Widget _buildImpulseVaultPage() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSavingsSummaryCard(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Active Craving Cooldowns',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddImpulseDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Urge'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_impulses.isEmpty)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.check_circle_outline, size: 48, color: Colors.teal),
                        SizedBox(height: 8),
                        Text(
                          'No active urges detected!',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Whenever you feel an impulse to spend or break a rule, tap "Add Urge" to start a mindful cooldown.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _impulses.length,
                itemBuilder: (context, index) {
                  final item = _impulses[index];
                  final double workHoursNeeded =
                      _hourlyWage > 0 ? (item.price / _hourlyWage) : 0;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Chip(
                                label: Text(item.category),
                                backgroundColor: Colors.teal.withOpacity(0.1),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.work, size: 18, color: Colors.amber),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Costs ~${workHoursNeeded.toStringAsFixed(1)} hours of your labor (\$${_hourlyWage.toStringAsFixed(2)}/hr)',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (item.status == 'cooling') ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Cooldown Remaining: ${_formatTime(item.secondsRemaining)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                                LinearProgressIndicator(
                                  value: item.secondsRemaining / item.totalSeconds,
                                  minHeight: 6,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () => _openBreathingModal(context),
                                  icon: const Icon(Icons.self_improvement, size: 18),
                                  label: const Text('Mindful Breathe'),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _markImpulseStatus(item.id, 'resisted'),
                                  icon: const Icon(Icons.check, size: 18),
                                  label: const Text('I Resisted!'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _markImpulseStatus(item.id, 'yielded'),
                                  child: const Text('I Yielded', style: TextStyle(color: Colors.grey)),
                                ),
                              ],
                            ),
                          ] else ...[
                            Row(
                              children: [
                                Icon(
                                  item.status == 'resisted'
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: item.status == 'resisted'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  item.status == 'resisted'
                                      ? 'Resisted! Saved \$${item.price.toStringAsFixed(2)}'
                                      : 'Yielded',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: item.status == 'resisted'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade700, Colors.teal.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Saved Money',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '\$${_totalSavedMoney.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Saved equivalent to ~${_hourlyWage > 0 ? (_totalSavedMoney / _hourlyWage).toStringAsFixed(1) : '0'} hours of free time!',
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: ANTI-FATIGUE DECISION MATRIX ---
  Widget _buildDecisionMatrixPage() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Micro-Decision Assistant',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Eliminate micro-decision fatigue. Let the tool pick your next break or quick routine task!',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Center(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(Icons.psychology, size: 56, color: Colors.teal),
                      const SizedBox(height: 16),
                      if (_isSelectingDecision) ...[
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        const Text('Selecting optimal micro-action...'),
                      ] else if (_selectedDecision != null) ...[
                        const Text(
                          'YOUR DECISION:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedDecision!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                        ),
                      ] else ...[
                        const Text(
                          'Ready to decide?',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _pickRandomDecision,
                        icon: const Icon(Icons.casino),
                        label: const Text('Pick My Action'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Custom Decision Options',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.teal),
                  onPressed: _showAddDecisionDialog,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _decisionOptions.map((option) {
                return Chip(
                  label: Text(option),
                  onDeleted: () {
                    setState(() {
                      _decisionOptions.remove(option);
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 3: FOCUS SPRINT ENGINE ---
  Widget _buildFocusSprintPage() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Micro-Focus Block',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Commit to short micro-bursts of uninterrupted focus.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Center(
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        _formatTime(_focusSecondsLeft),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (!_isFocusActive) ...[
                        const Text(
                          'Select Duration (Minutes):',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          children: [5, 10, 15, 25].map((mins) {
                            return ChoiceChip(
                              label: Text('$minsm'),
                              selected: _selectedFocusDurationMinutes == mins,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedFocusDurationMinutes = mins;
                                    _focusSecondsLeft = mins * 60;
                                  });
                                }
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                      ElevatedButton.icon(
                        onPressed: _toggleFocusTimer,
                        icon: Icon(_isFocusActive ? Icons.pause : Icons.play_arrow),
                        label: Text(_isFocusActive ? 'Pause Focus' : 'Start Focus'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.stars, color: Colors.amber, size: 36),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Today\'s Focused Time',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$_focusMinutes Minutes Logged',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),
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

  // --- TAB 4: IMPACT DASHBOARD ---
  Widget _buildDashboardPage() {
    final int resistedCount =
        _impulses.where((i) => i.status == 'resisted').length;
    final int totalCount = _impulses.length;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Mindfulness Impact',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    'Money Saved',
                    '\$${_totalSavedMoney.toStringAsFixed(2)}',
                    Icons.monetization_on,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricTile(
                    'Focus Minutes',
                    '$_focusMinutes mins',
                    Icons.timer,
                    Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    'Resisted Urges',
                    '$resistedCount / $totalCount',
                    Icons.shield,
                    Colors.indigo,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricTile(
                    'Hourly Wage Rate',
                    '\$${_hourlyWage.toStringAsFixed(2)}/h',
                    Icons.work,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daily Mindful Wisdom',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '"Between stimulus and response there is a space. In that space is our power to choose our response. In our response lies our growth and our freedom."',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
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

  Widget _buildMetricTile(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // --- MODALS & DIALOGS ---

  void _showAddImpulseDialog() {
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    String category = 'Impulse Buy';
    int durationMinutes = 3;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text('Add Urge / Impulse'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'What do you want to spend/do?',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Cost in \$ (if applicable)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: category,
                      items: ['Impulse Buy', 'Junk Food', 'Distraction', 'Other']
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setModalState(() => category = val);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Cooldown Time:'),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: durationMinutes,
                          items: [1, 3, 5, 10, 15]
                              .map((m) => DropdownMenuItem(
                                    value: m,
                                    child: Text('$m mins'),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setModalState(() => durationMinutes = val);
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
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final price = double.tryParse(priceController.text) ?? 0.0;
                    if (title.isNotEmpty) {
                      _addImpulse(title, price, category, durationMinutes);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text('Start Cooldown', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddDecisionDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Decision Option'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Option description',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  setState(() {
                    _decisionOptions.add(text);
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Add Option', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showSettingsDialog() {
    final wageController =
        TextEditingController(text: _hourlyWage.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: wageController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Estimated Hourly Wage (\$)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final wage = double.tryParse(wageController.text);
                if (wage != null && wage >= 0) {
                  setState(() {
                    _hourlyWage = wage;
                  });
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _openBreathingModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const MindfulBreathingSheet();
      },
    );
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class MindfulBreathingSheet extends StatefulWidget {
  const MindfulBreathingSheet({super.key});

  @override
  State<MindfulBreathingSheet> createState() => _MindfulBreathingSheetState();
}

class _MindfulBreathingSheetState extends State<MindfulBreathingSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Mindful Resets',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Inhale as the circle expands, exhale as it shrinks.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: 100 + (_animation.value * 60),
                height: 100 + (_animation.value * 60),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.teal.withOpacity(0.3 + (_animation.value * 0.4)),
                ),
                child: Center(
                  child: Text(
                    _animation.value > 0.5 ? 'Inhale' : 'Exhale',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done Mindfulness'),
          ),
        ],
      ),
    );
  }
}