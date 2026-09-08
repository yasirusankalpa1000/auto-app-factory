import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const ValuePaceApp());
}

class ValuePaceApp extends StatelessWidget {
  const ValuePaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ValuePace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
          surface: const Color(0xFF1E293B),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class SavedDecision {
  final String id;
  final String title;
  final double amountSaved;
  final double hoursSaved;
  final String category;
  final DateTime date;

  SavedDecision({
    required this.id,
    required this.title,
    required this.amountSaved,
    required this.hoursSaved,
    required this.category,
    required this.date,
  });
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  double _hourlyWage = 25.0; // Default wage per hour

  // Live Desk Station State
  Timer? _ticker;
  int _elapsedSeconds = 0;
  bool _isWorking = false;
  
  // Micro Savings History
  final List<SavedDecision> _savingsList = [
    SavedDecision(
      id: '1',
      title: 'Cooked Home Lunch',
      amountSaved: 16.50,
      hoursSaved: 0.66,
      category: 'Food',
      date: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    SavedDecision(
      id: '2',
      title: 'Skipped Impulse Shoes',
      amountSaved: 85.00,
      hoursSaved: 3.40,
      category: 'Shopping',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    SavedDecision(
      id: '3',
      title: 'Walked Instead of Rideshare',
      amountSaved: 12.00,
      hoursSaved: 0.48,
      category: 'Travel',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    setState(() {
      if (_isWorking) {
        _ticker?.cancel();
        _isWorking = false;
      } else {
        _isWorking = true;
        _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _elapsedSeconds++;
          });
        });
      }
    });
  }

  void _resetTimer() {
    setState(() {
      _ticker?.cancel();
      _isWorking = false;
      _elapsedSeconds = 0;
    });
  }

  void _updateHourlyWage(double newWage) {
    setState(() {
      _hourlyWage = newWage;
    });
  }

  void _addSavedDecision(SavedDecision decision) {
    setState(() {
      _savingsList.insert(0, decision);
    });
  }

  void _deleteDecision(String id) {
    setState(() {
      _savingsList.removeWhere((item) => item.id == id);
    });
  }

  void _openWageDialog() {
    final controller = TextEditingController(text: _hourlyWage.toStringAsFixed(2));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Set Net Hourly Wage'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your actual hourly take-home pay to accurately calculate your life-work time cost.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Net Hourly Wage (\$)',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () {
              final val = double.tryParse(controller.text);
              if (val != null && val > 0) {
                _updateHourlyWage(val);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save Wage', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildDeskStationTab(),
      _buildImpulseGuardTab(),
      _buildMicroSaverTab(),
      _buildDashboardTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.speed, color: Colors.teal),
            const SizedBox(width: 8),
            const Text(
              'ValuePace',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const Spacer(),
            ActionChip(
              avatar: const Icon(Icons.monetization_on, size: 16, color: Colors.amber),
              label: Text(
                '\$${_hourlyWage.toStringAsFixed(0)}/hr',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              backgroundColor: const Color(0xFF1E293B),
              onPressed: _openWageDialog,
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        backgroundColor: const Color(0xFF1E293B),
        indicatorColor: Colors.teal.withOpacity(0.3),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer, color: Colors.tealAccent),
            label: 'Desk Station',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_outlined),
            selectedIcon: Icon(Icons.psychology, color: Colors.tealAccent),
            label: 'Impulse Guard',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_task),
            selectedIcon: Icon(Icons.add_task, color: Colors.tealAccent),
            label: 'Micro Saver',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            selectedIcon: Icon(Icons.bar_chart, color: Colors.tealAccent),
            label: 'Life Impact',
          ),
        ],
      ),
    );
  }

  // 1. DESK STATION TAB (Ambient Desk Companion)
  Widget _buildDeskStationTab() {
    final double earnedSoFar = (_elapsedSeconds / 3600.0) * _hourlyWage;
    final int minutes = (_elapsedSeconds % 3600) ~/ 60;
    final int seconds = _elapsedSeconds % 60;
    final int hours = _elapsedSeconds ~/ 3600;

    final String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return SafeArea(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb, color: Colors.tealAccent, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Keep this ambient station open on your desk while working to track earned focus & time value in real time.',
                      style: TextStyle(color: Colors.teal.shade100, fontSize: 13),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Dynamic Earned Value Card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF1E293B), const Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.teal.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'REAL-TIME EARNED WORK VALUE',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '\$${earnedSoFar.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Active Focus Clock: $formattedTime',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isWorking ? Colors.amber.shade800 : Colors.teal,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _toggleTimer,
                        icon: Icon(_isWorking ? Icons.pause : Icons.play_arrow, color: Colors.white),
                        label: Text(
                          _isWorking ? 'Pause Session' : 'Start Focus',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _resetTimer,
                        icon: const Icon(Icons.refresh, color: Colors.grey),
                        label: const Text('Reset', style: TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Quick Micro Metrics
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAxisAlignment.center,
              children: [
                _buildDeskMetricCard(
                  title: 'Hourly Standard',
                  value: '\$${_hourlyWage.toStringAsFixed(2)}',
                  icon: Icons.monetization_on,
                  color: Colors.blueAccent,
                ),
                _buildDeskMetricCard(
                  title: '1 Minute Worth',
                  value: '\$${(_hourlyWage / 60.0).toStringAsFixed(2)}',
                  icon: Icons.schedule,
                  color: Colors.teal,
                ),
                _buildDeskMetricCard(
                  title: '8-Hr Shift Target',
                  value: '\$${(_hourlyWage * 8).toStringAsFixed(0)}',
                  icon: Icons.work,
                  color: Colors.indigoAccent,
                ),
                _buildDeskMetricCard(
                  title: 'Micro-Break Interval',
                  value: '${(25 - (minutes % 25))} min left',
                  icon: Icons.coffee,
                  color: Colors.amber,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeskMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final double cardWidth = (MediaQuery.of(context).size.width - 52) / 2;
    return Container(
      width: cardWidth > 140 ? cardWidth : 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // 2. IMPULSE GUARD TAB (Purchase Life-Cost Calculator)
  Widget _buildImpulseGuardTab() {
    return _ImpulseGuardView(hourlyWage: _hourlyWage, onSave: _addSavedDecision);
  }

  // 3. MICRO SAVER TAB (Log Saved Micro-Decisions)
  Widget _buildMicroSaverTab() {
    return _MicroSaverView(hourlyWage: _hourlyWage, onSave: _addSavedDecision);
  }

  // 4. LIFE DASHBOARD TAB (Analytics & Saved History)
  Widget _buildDashboardTab() {
    double totalMoneySaved = 0;
    double totalHoursSaved = 0;
    for (var item in _savingsList) {
      totalMoneySaved += item.amountSaved;
      totalHoursSaved += item.hoursSaved;
    }

    return SafeArea(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Life Impact & Reclaimed Time',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            const Text(
              'Every small impulse resisted reclaims actual hours of your life work.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),
            // Overall Stats Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade900.withOpacity(0.6), const Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.teal.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TOTAL SAVED', style: TextStyle(color: Colors.tealAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '\$${totalMoneySaved.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 40, width: 1, color: Colors.white70),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('RECLAIMED WORK', style: TextStyle(color: Colors.tealAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${totalHoursSaved.toStringAsFixed(1)} hrs',
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Micro-Decision Log',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Chip(
                  label: Text(
                    '${_savingsList.length} Logged',
                    style: const TextStyle(fontSize: 11, color: Colors.tealAccent),
                  ),
                  backgroundColor: const Color(0xFF1E293B),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_savingsList.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.shield_outlined, color: Colors.grey, size: 48),
                    SizedBox(height: 12),
                    Text(
                      'No saved micro-decisions yet.',
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Use Impulse Guard or Micro Saver to log your smart choices!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _savingsList.length,
                itemBuilder: (ctx, idx) {
                  final item = _savingsList[idx];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.teal.withOpacity(0.2),
                          child: Icon(
                            item.category == 'Food'
                                ? Icons.fastfood
                                : item.category == 'Shopping'
                                    ? Icons.shopping_bag
                                    : Icons.directions_walk,
                            color: Colors.tealAccent,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${item.category} • ${item.date.day}/${item.date.month}/${item.date.year}',
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '+\$${item.amountSaved.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.tealAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '+${item.hoursSaved.toStringAsFixed(1)} hrs life',
                              style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                          onPressed: () => _deleteDecision(item.id),
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
}

// Stateful Widget for Impulse Evaluator Tab
class _ImpulseGuardView extends StatefulWidget {
  final double hourlyWage;
  final Function(SavedDecision) onSave;

  const _ImpulseGuardView({
    required this.hourlyWage,
    required this.onSave,
  });

  @override
  State<_ImpulseGuardView> createState() => _ImpulseGuardViewState();
}

class _ImpulseGuardViewState extends State<_ImpulseGuardView> {
  final _costController = TextEditingController();
  final _titleController = TextEditingController();
  double _enteredCost = 0.0;
  String _category = 'Shopping';

  @override
  void dispose() {
    _costController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double hoursNeeded = _enteredCost > 0 ? (_enteredCost / widget.hourlyWage) : 0.0;
    
    // Dynamic recommendation logic
    String coolOffTime = 'No cool-off required';
    String advice = 'Small micro-expense.';
    Color severityColor = Colors.teal;

    if (_enteredCost >= 200) {
      coolOffTime = 'Wait 72 Hours (3 Days)';
      advice = 'Major expenditure! Think carefully about how many full work days this costs.';
      severityColor = Colors.redAccent;
    } else if (_enteredCost >= 50) {
      coolOffTime = 'Wait 24 Hours';
      advice = 'Substantial purchase. Sleep on it before buying.';
      severityColor = Colors.amber;
    } else if (_enteredCost >= 15) {
      coolOffTime = 'Wait 2 Hours';
      advice = 'Moderate impulse spend. Re-evaluate after a micro-break.';
      severityColor = Colors.blueAccent;
    }

    return SafeArea(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Impulse Purchase Guard',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            const Text(
              'Before buying, enter the price to see how many hours of real work it takes to earn it.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Item or Purchase Description',
                hintText: 'e.g. Premium Headphones, Gourmet Pizza',
                prefixIcon: Icon(Icons.shopping_cart, color: Colors.teal),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _costController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: 'Price Tag (\$)',
                prefixText: '\$ ',
                prefixIcon: Icon(Icons.attach_money, color: Colors.teal),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                setState(() {
                  _enteredCost = double.tryParse(val) ?? 0.0;
                });
              },
            ),
            const SizedBox(height: 20),
            // Dynamic Evaluation Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: severityColor.withOpacity(0.5), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.hourglass_top, color: severityColor, size: 24),
                      const SizedBox(width: 8),
                      const Text(
                        'LIFE-WORK EQUIVALENT',
                        style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${hoursNeeded.toStringAsFixed(1)} Work Hours',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: severityColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'At \$${widget.hourlyWage.toStringAsFixed(2)}/hr net wage, you must work ${hoursNeeded.toStringAsFixed(1)} hours strictly to pay for this item.',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                    softWrap: true,
                  ),
                  const Divider(height: 24, color: Colors.white70),
                  Row(
                    children: [
                      const Icon(Icons.shield, color: Colors.tealAccent, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Recommended Cool-Off: $coolOffTime',
                          style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    advice,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Action to Skip Purchase & Save
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _enteredCost <= 0
                    ? null
                    : () {
                        final title = _titleController.text.trim().isEmpty
                            ? 'Skipped Purchase'
                            : _titleController.text.trim();
                        final decision = SavedDecision(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: title,
                          amountSaved: _enteredCost,
                          hoursSaved: hoursNeeded,
                          category: _category,
                          date: DateTime.now(),
                        );
                        widget.onSave(decision);
                        _costController.clear();
                        _titleController.clear();
                        setState(() {
                          _enteredCost = 0.0;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Awesome! You reclaimed \$${decision.amountSaved.toStringAsFixed(2)} and ${decision.hoursSaved.toStringAsFixed(1)} work hours!'),
                            backgroundColor: Colors.teal,
                          ),
                        );
                      },
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text(
                  'I Resisted This Impulse (Save Value)',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Stateful Widget for Micro Saver Tab
class _MicroSaverView extends StatefulWidget {
  final double hourlyWage;
  final Function(SavedDecision) onSave;

  const _MicroSaverView({
    required this.hourlyWage,
    required this.onSave,
  });

  @override
  State<_MicroSaverView> createState() => _MicroSaverViewState();
}

class _MicroSaverViewState extends State<_MicroSaverView> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Food';

  final List<String> _categories = ['Food', 'Shopping', 'Travel', 'Leisure', 'Subscriptions'];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    if (title.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid title and saved amount.')),
      );
      return;
    }

    final double hoursSaved = amount / widget.hourlyWage;

    final decision = SavedDecision(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amountSaved: amount,
      hoursSaved: hoursSaved,
      category: _selectedCategory,
      date: DateTime.now(),
    );

    widget.onSave(decision);
    _titleController.clear();
    _amountController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged: Saved \$${amount.toStringAsFixed(2)} (${hoursSaved.toStringAsFixed(1)} hrs reclaimed)'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Log Micro-Savings Habit',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            const Text(
              'Quickly record everyday micro-decisions like bringing lunch or walking instead of taking a cab.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Micro-Action Title',
                hintText: 'e.g. Made Coffee at Home, Cancelled Unused App',
                prefixIcon: Icon(Icons.edit, color: Colors.teal),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Amount Saved (\$) ',
                prefixText: '\$ ',
                prefixIcon: Icon(Icons.savings, color: Colors.teal),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Category',
              style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAxisAlignment.center,
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: Colors.teal,
                  backgroundColor: const Color(0xFF1E293B),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _submit,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Log Micro-Saving Choice',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}