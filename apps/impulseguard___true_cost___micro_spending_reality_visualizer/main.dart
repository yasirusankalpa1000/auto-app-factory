import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const ImpulseGuardApp());
}

class ImpulseGuardApp extends StatelessWidget {
  const ImpulseGuardApp({super.key});

  @override
  Widget build(BuildContext me) {
    return MaterialApp(
      title: 'ImpulseGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF12181B),
      ),
      home: const MainScreen(),
    );
  }
}

class ImpulseItem {
  final String id;
  final String title;
  final double cost;
  final double hoursWorked;
  final DateTime createdAt;
  final int coolingHours;
  bool isSkipped;
  bool isPurchased;

  ImpulseItem({
    required this.id,
    required this.title,
    required this.cost,
    required this.hoursWorked,
    required this.createdAt,
    required this.coolingHours,
    this.isSkipped = false,
    this.isPurchased = false,
  });

  Duration get remainingTime {
    final expiry = createdAt.add(Duration(hours: coolingHours));
    final now = DateTime.now();
    if (now.isAfter(expiry)) return Duration.zero;
    return expiry.difference(now);
  }

  bool get isCooling => !isSkipped && !isPurchased && remainingTime > Duration.zero;
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  double _hourlyWage = 25.0;
  
  final List<ImpulseItem> _items = [];
  Timer? _tickerTimer;

  // Form controllers
  final TextEditingController _wageController = TextEditingController(text: '25.0');
  final TextEditingController _itemTitleController = TextEditingController();
  final TextEditingController _itemCostController = TextEditingController();
  int _selectedCoolingHours = 24;

  // Simulator Sliders
  double _dailyCoffee = 5.0;
  double _weeklyDining = 45.0;
  double _monthlySubscriptions = 30.0;

  // Diffuser State
  late AnimationController _diffuserController;
  int _diffuserSeconds = 60;
  Timer? _diffuserTimer;
  bool _isDiffusing = false;

  @override
  void initState() {
    super.initState();
    // Pre-populate with sample items for realistic demo experience
    _items.addAll([
      ImpulseItem(
        id: '1',
        title: 'Wireless Gaming Earbuds',
        cost: 85.0,
        hoursWorked: 3.4,
        createdAt: DateTime.now().subtract(const Duration(hours: 18)),
        coolingHours: 24,
      ),
      ImpulseItem(
        id: '2',
        title: 'Designer Sneaker Sale',
        cost: 160.0,
        hoursWorked: 6.4,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        coolingHours: 48,
      ),
      ImpulseItem(
        id: '3',
        title: 'Gourmet Coffee Pod Machine',
        cost: 120.0,
        hoursWorked: 4.8,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        coolingHours: 24,
        isSkipped: true,
      ),
    ]);

    _tickerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });

    _diffuserController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    _diffuserTimer?.cancel();
    _diffuserController.dispose();
    _wageController.dispose();
    _itemTitleController.dispose();
    _itemCostController.dispose();
    super.dispose();
  }

  double get totalSavedMoney {
    return _items.where((i) => i.isSkipped).fold(0.0, (sum, item) => sum + item.cost);
  }

  double get totalSavedHours {
    return _items.where((i) => i.isSkipped).fold(0.0, (sum, item) => sum + item.hoursWorked);
  }

  void _addImpulseItem(bool startVault) {
    final title = _itemTitleController.text.trim();
    final cost = double.tryParse(_itemCostController.text.trim()) ?? 0.0;

    if (title.isEmpty || cost <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid title and cost.')),
      );
      return;
    }

    final hoursWorked = _hourlyWage > 0 ? (cost / _hourlyWage) : 0.0;

    final newItem = ImpulseItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      cost: cost,
      hoursWorked: hoursWorked,
      createdAt: DateTime.now(),
      coolingHours: _selectedCoolingHours,
      isSkipped: !startVault, // If true startVault -> put in vault, else skip immediately
    );

    setState(() {
      _items.insert(0, newItem);
      _itemTitleController.clear();
      _itemCostController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          startVault
              ? '"$title" added to Cooling Vault!'
              : 'Awesome! You saved \$${cost.toStringAsFixed(2)} instantly!',
        ),
      ),
    );
  }

  void _showWageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E282D),
        title: const Text('Update Hourly Wage', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Your hourly wage calculates true life-time cost for every item.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _wageController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Hourly Wage (\$) ',
                prefixText: '\$ ',
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
              final newWage = double.tryParse(_wageController.text.trim()) ?? 25.0;
              setState(() {
                _hourlyWage = max(1.0, newWage);
              });
              Navigator.pop(context);
            },
            child: const Text('Save Wage'),
          ),
        ],
      ),
    );
  }

  void _startDiffuser() {
    setState(() {
      _isDiffusing = true;
      _diffuserSeconds = 60;
    });
    _diffuserController.repeat(reverse: true);
    _diffuserTimer?.cancel();
    _diffuserTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_diffuserSeconds > 1) {
        setState(() {
          _diffuserSeconds--;
        });
      } else {
        _stopDiffuser();
      }
    });
  }

  void _stopDiffuser() {
    _diffuserTimer?.cancel();
    _diffuserController.stop();
    setState(() {
      _isDiffusing = false;
      _diffuserSeconds = 60;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF182226),
        elevation: 2,
        title: Row(
          children: [
            const Icon(Icons.security, color: Colors.tealAccent),
            const SizedBox(width: 10),
            const Text(
              'ImpulseGuard',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ActionChip(
              avatar: const Icon(Icons.monetization_on, color: Colors.amber, size: 18),
              label: Text(
                '\$${_hourlyWage.toStringAsFixed(0)}/hr',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color(0xFF26343B),
              onPressed: _showWageDialog,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildCalculatorTab(),
            _buildVaultTab(),
            _buildSimulatorTab(),
            _buildDiffuserTab(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF182226),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Reality Check',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Cooling Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Life Trade-off',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            label: 'Urge Diffuser',
          ),
        ],
      ),
    );
  }

  // TAB 1: REALITY CHECK & CALCULATOR
  Widget _buildCalculatorTab() {
    final previewCost = double.tryParse(_itemCostController.text) ?? 0.0;
    final previewHours = _hourlyWage > 0 ? (previewCost / _hourlyWage) : 0.0;
    final futureValue10Yrs = previewCost * pow(1 + 0.07, 10); // 7% compound growth

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat summary header card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A3A), Color(0xFF122528)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text('Total Money Saved', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 4),
                      FittedBox(
                        child: Text(
                          '\$${totalSavedMoney.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.tealAccent,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 35, width: 1, color: Colors.teal.withOpacity(0.3)),
                Expanded(
                  child: Column(
                    children: [
                      const Text('Life-Hours Reclaimed', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 4),
                      FittedBox(
                        child: Text(
                          '${totalSavedHours.toStringAsFixed(1)} hrs',
                          style: const TextStyle(
                            color: Colors.amberAccent,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Test Your Impulse Urge',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'Convert money into real hours of labor before deciding to buy.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Form Input
          TextField(
            controller: _itemTitleController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Item or Temptation Name',
              hintText: 'e.g. Mechanical Keyboard, Espresso',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.shopping_bag_outlined, color: Colors.tealAccent),
            ),
          ),
          const SizedBox(height: 14),

          TextField(
            controller: _itemCostController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white),
            onChanged: (val) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Price Tag (\$) ',
              prefixText: '\$ ',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money, color: Colors.tealAccent),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Cooling Vault Duration',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [1, 12, 24, 48].map((hours) {
              final selected = _selectedCoolingHours == hours;
              return ChoiceChip(
                label: Text('$hours Hours'),
                selected: selected,
                selectedColor: Colors.teal,
                backgroundColor: const Color(0xFF26343B),
                labelStyle: TextStyle(
                  color: selected ? Colors.white : Colors.grey,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (val) {
                  if (val) setState(() => _selectedCoolingHours = hours);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Dynamic Reality Feedback Card
          if (previewCost > 0) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E282D),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Reality Impact Calculation',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white70, height: 20),
                  Text(
                    '• Costs ${previewHours.toStringAsFixed(1)} hours of continuous work at your wage.',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '• Invested at 7% return, this \$${previewCost.toStringAsFixed(0)} becomes \$${futureValue10Yrs.toStringAsFixed(2)} in 10 years.',
                    style: const TextStyle(color: Colors.tealAccent, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '• Equal to ~${(previewCost / 4.5).toStringAsFixed(0)} home-cooked organic lunches.',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.lock_clock, color: Colors.white),
                  label: const Text(
                    'Put in Vault',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => _addImpulseItem(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.amberAccent),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.check_circle, color: Colors.amberAccent),
                  label: const Text(
                    'Resisted Already!',
                    style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => _addImpulseItem(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TAB 2: COOLING VAULT & ACTIVE TIMERS
  Widget _buildVaultTab() {
    final activeCooling = _items.where((i) => i.isCooling).toList();
    final archivedItems = _items.where((i) => !i.isCooling).toList();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Active Cooling Vault',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Decisions locked in cooling period. Wait out the timer to destroy impulse chemical triggers.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          if (activeCooling.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E282D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Icon(Icons.shield_outlined, color: Colors.teal, size: 48),
                  SizedBox(height: 12),
                  Text(
                    'Vault is empty!',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Add impulse temptations from the Reality Check tab.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activeCooling.length,
              itemBuilder: (context, index) {
                final item = activeCooling[index];
                final rem = item.remainingTime;
                final hours = rem.inHours;
                final mins = rem.inMinutes.remainder(60);
                final secs = rem.inSeconds.remainder(60);

                final totalSecs = item.coolingHours * 3600;
                final elapsedSecs = totalSecs - rem.inSeconds;
                final progress = max(0.0, min(1.0, elapsedSecs / totalSecs));

                return Card(
                  color: const Color(0xFF1E282D),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.teal, width: 0.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '\$${item.cost.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amberAccent,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Equivalent Work: ${item.hoursWorked.toStringAsFixed(1)} hours',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 12),

                        // Countdown UI
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16, color: Colors.tealAccent),
                            const SizedBox(width: 6),
                            Text(
                              'Unlocks in: ${hours}h ${mins}m ${secs}s',
                              style: const TextStyle(
                                color: Colors.tealAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.black87,
                          color: Colors.teal,
                          minHeight: 6,
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  visualDensity: VisualDensity.compact,
                                ),
                                icon: const Icon(Icons.check, size: 16, color: Colors.white),
                                label: const Text(
                                  'I Resisted & Saved!',
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                                onPressed: () {
                                  setState(() {
                                    item.isSkipped = true;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                side: const BorderSide(color: Colors.redAccent),
                              ),
                              onPressed: () {
                                setState(() {
                                  item.isPurchased = true;
                                });
                              },
                              child: const Text(
                                'I Bought It',
                                style: TextStyle(color: Colors.redAccent, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

          const SizedBox(height: 24),
          const Text(
            'Past Decision History',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          if (archivedItems.isEmpty)
            const Text('No past records yet.', style: TextStyle(color: Colors.grey, fontSize: 12))
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: archivedItems.length,
              itemBuilder: (context, index) {
                final item = archivedItems[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: item.isSkipped ? Colors.teal.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                    child: Icon(
                      item.isSkipped ? Icons.savings : Icons.shopping_cart,
                      color: item.isSkipped ? Colors.tealAccent : Colors.redAccent,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    item.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  subtitle: Text(
                    item.isSkipped ? 'Saved \$${item.cost.toStringAsFixed(2)}' : 'Spent \$${item.cost.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: item.isSkipped ? Colors.tealAccent : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  trailing: Text(
                    '${item.hoursWorked.toStringAsFixed(1)} labor hrs',
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // TAB 3: LIFE TRADE-OFF SIMULATOR
  Widget _buildSimulatorTab() {
    final annualCoffee = _dailyCoffee * 365;
    final annualDining = _weeklyDining * 52;
    final annualSubs = _monthlySubscriptions * 12;
    final totalAnnualWaste = annualCoffee + annualDining + annualSubs;
    final totalHoursWasted = _hourlyWage > 0 ? (totalAnnualWaste / _hourlyWage) : 0.0;
    final fiveYearInvestment = totalAnnualWaste * 5.75; // Approx 5 yrs with compound interest

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Habit Trade-Off Simulator',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Adjust your small routine expenses to see real annual life trade-offs.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Projection Header Box
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2B1E3A), Color(0xFF19182B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.purpleAccent.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                const Text(
                  '1-YEAR CUMULATIVE DRAIN',
                  style: TextStyle(color: Colors.purpleAccent, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  child: Text(
                    '\$${totalAnnualWaste.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Requires ${totalHoursWasted.toStringAsFixed(0)} hours of labor (~${(totalHoursWasted / 40).toStringAsFixed(1)} full work weeks!)',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const Divider(color: Colors.white70, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('5-Year Invested', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 2),
                        Text(
                          '\$${fiveYearInvestment.toStringAsFixed(0)}',
                          style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Potential Reward', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 2),
                        const Text(
                          'International Flight ✈️',
                          style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Sliders
          _buildSliderTile(
            title: 'Daily Coffee & Small Snacks',
            value: _dailyCoffee,
            max: 20.0,
            unit: '/day',
            annualCost: annualCoffee,
            onChanged: (v) => setState(() => _dailyCoffee = v),
          ),
          const SizedBox(height: 16),

          _buildSliderTile(
            title: 'Weekly Takeout & Restaurant Dining',
            value: _weeklyDining,
            max: 200.0,
            unit: '/week',
            annualCost: annualDining,
            onChanged: (v) => setState(() => _weeklyDining = v),
          ),
          const SizedBox(height: 16),

          _buildSliderTile(
            title: 'Unused Monthly Subscriptions',
            value: _monthlySubscriptions,
            max: 150.0,
            unit: '/month',
            annualCost: annualSubs,
            onChanged: (v) => setState(() => _monthlySubscriptions = v),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTile({
    required String title,
    required double value,
    required double max,
    required String unit,
    required double annualCost,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E282D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '\$${value.toStringAsFixed(0)}$unit',
                style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Slider(
            value: value,
            min: 0.0,
            max: max,
            divisions: max.toInt(),
            activeColor: Colors.teal,
            inactiveColor: Colors.grey.shade800,
            onChanged: onChanged,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Annual drain: \$${annualCost.toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 4: URGE DIFFUSER (MINDFUL PAUSE RETENTION CHAMBER)
  Widget _buildDiffuserTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Urge Diffuser Chamber',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const Text(
            'Dopamine spikes fade after 60 seconds of focused breath. Use this chamber before hitting "Buy Now".',
            style: TextStyle(fontSize: 13, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          // Breathing Pulse Circle Container
          AnimatedBuilder(
            animation: _diffuserController,
            builder: (context, child) {
              final scale = _isDiffusing ? 1.0 + (_diffuserController.value * 0.25) : 1.0;
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.tealAccent.withOpacity(0.8),
                        Colors.teal.withOpacity(0.2),
                        Colors.transparent,
                      ],
                      stops: const [0.2, 0.7, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(_isDiffusing ? 0.4 : 0.1),
                        blurRadius: 30,
                        spreadRadius: 10,
                      )
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$_diffuserSeconds',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _isDiffusing ? 'Breathe Deeply...' : 'Ready',
                          style: const TextStyle(color: Colors.tealAccent, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 36),

          if (!_isDiffusing)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              icon: const Icon(Icons.play_arrow, color: Colors.white),
              label: const Text(
                'Start 60-Sec Cool Down',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: _startDiffuser,
            )
          else
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.redAccent),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.stop, color: Colors.redAccent),
              label: const Text('Cancel Reset', style: TextStyle(color: Colors.redAccent)),
              onPressed: _stopDiffuser,
            ),

          const SizedBox(height: 30),

          // Grounding Questions Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E282D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ask Yourself Right Now:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amberAccent, fontSize: 14),
                ),
                SizedBox(height: 10),
                Text('1. Will this item matter to me in 30 days?', style: TextStyle(color: Colors.white70, fontSize: 13)),
                SizedBox(height: 6),
                Text('2. Am I purchasing this because I am stressed, tired, or bored?', style: TextStyle(color: Colors.white70, fontSize: 13)),
                SizedBox(height: 6),
                Text('3. What goal am I delaying by spending this money?', style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}