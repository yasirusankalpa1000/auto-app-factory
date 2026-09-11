import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const ImpulseGuardApp());
}

class ImpulseGuardApp extends StatelessWidget {
  const ImpulseGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImpulseGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class CoolingItem {
  final String id;
  final String name;
  final double price;
  final String category;
  final int coolingHours;
  final DateTime startTime;
  bool isSaved;
  bool isBought;

  CoolingItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.coolingHours,
    required this.startTime,
    this.isSaved = false,
    this.isBought = false,
  });
}

class SavedLeak {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;

  SavedLeak({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  Timer? _timer;

  double _hourlyWage = 22.50;
  int _noSpendStreak = 4;

  final List<CoolingItem> _coolingVault = [
    CoolingItem(
      id: '1',
      name: 'Wireless Noise Canceling Headphones',
      price: 189.99,
      category: 'Tech',
      coolingHours: 24,
      startTime: DateTime.now().subtract(const Duration(hours: 18, minutes: 20)),
    ),
    CoolingItem(
      id: '2',
      name: 'Designer Sneakers Sale',
      price: 120.00,
      category: 'Fashion',
      coolingHours: 12,
      startTime: DateTime.now().subtract(const Duration(hours: 11, minutes: 45)),
    ),
    CoolingItem(
      id: '3',
      name: 'Smart Espresso Maker',
      price: 299.00,
      category: 'Home',
      coolingHours: 48,
      startTime: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  final List<SavedLeak> _savedList = [
    SavedLeak(
      id: 's1',
      title: 'Skipped Gourmet Fast Food',
      amount: 18.50,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Food',
    ),
    SavedLeak(
      id: 's2',
      title: 'Passed on Video Game Pre-order',
      amount: 69.99,
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: 'Entertainment',
    ),
    SavedLeak(
      id: 's3',
      title: 'Resisted Flash Sale Jacket',
      amount: 85.00,
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: 'Fashion',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  double get totalSavedAmount {
    double sum = 0.0;
    for (var item in _savedList) {
      sum += item.amount;
    }
    for (var item in _coolingVault) {
      if (item.isSaved) {
        sum += item.price;
      }
    }
    return sum;
  }

  void _addCoolingItem(String name, double price, String category, int hours) {
    setState(() {
      _coolingVault.insert(
        0,
        CoolingItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          price: price,
          category: category,
          coolingHours: hours,
          startTime: DateTime.now(),
        ),
      );
    });
  }

  void _markAsSaved(CoolingItem item) {
    setState(() {
      item.isSaved = true;
      _savedList.insert(
        0,
        SavedLeak(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: item.name,
          amount: item.price,
          date: DateTime.now(),
          category: item.category,
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Great job! Saved \$${item.price.toStringAsFixed(2)}!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _markAsBought(CoolingItem item) {
    setState(() {
      item.isBought = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item marked as purchased.'),
        backgroundColor: Colors.grey,
      ),
    );
  }

  void _addSavedLeak(String title, double amount, String category) {
    setState(() {
      _savedList.insert(
        0,
        SavedLeak(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          amount: amount,
          date: DateTime.now(),
          category: category,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildCoolingVaultTab(),
      _buildFrictionQuizTab(),
      _buildLaborConverterTab(),
      _buildMicroSavingsTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.shield, color: Colors.deepPurple),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'ImpulseGuard',
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${_noSpendStreak}d Streak',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
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
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.lock_clock),
            label: 'Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Regret Test',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Labor Wage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Savings',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: COOLING VAULT ---
  Widget _buildCoolingVaultTab() {
    final activeItems =
        _coolingVault.where((i) => !i.isSaved && !i.isBought).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Summary Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.deepPurple,
                      child: const Icon(Icons.hourglass_top,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active Cooling Items',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${activeItems.length} Purchases Paused',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Coolingoff Queue',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddImpulseDialog(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Impulse'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (activeItems.isEmpty)
              Card(
                margin: const EdgeInsets.only(top: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.check_circle_outline,
                            size: 48, color: Colors.green),
                        SizedBox(height: 12),
                        Text(
                          'No active impulse purchases!',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'When you feel tempted to buy something, tap "Add Impulse" to place it in cooling.',
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
                itemCount: activeItems.length,
                itemBuilder: (context, index) {
                  final item = activeItems[index];
                  return _buildCoolingCard(item);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoolingCard(CoolingItem item) {
    final endTime = item.startTime.add(Duration(hours: item.coolingHours));
    final now = DateTime.now();
    final diff = endTime.difference(now);
    final isExpired = diff.isNegative;

    final totalSeconds = item.coolingHours * 3600;
    final elapsedSeconds = now.difference(item.startTime).inSeconds;
    final progress =
        (elapsedSeconds / totalSeconds).clamp(0.0, 1.0).toDouble();

    final laborHoursNeeded = (item.price / _hourlyWage).toStringAsFixed(1);

    String timerText;
    if (isExpired) {
      timerText = 'Cooling Complete!';
    } else {
      final h = diff.inHours;
      final m = diff.inMinutes % 60;
      final s = diff.inSeconds % 60;
      timerText = '${h}h ${m}m ${s}s left';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.category,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple.shade900,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Requires $laborHoursNeeded Work Hrs',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Progress bar and Countdown
            Row(
              children: [
                Icon(
                  isExpired ? Icons.check_circle : Icons.timer,
                  size: 16,
                  color: isExpired ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 6),
                Text(
                  timerText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isExpired ? Colors.green : Colors.orange.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isExpired ? Colors.green : Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _markAsSaved(item),
                    icon: const Icon(Icons.savings,
                        size: 16, color: Colors.green),
                    label: const Text('I Saved It!'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isExpired ? () => _markAsBought(item) : null,
                    icon: const Icon(Icons.shopping_cart, size: 16),
                    label: const Text('Buy Still'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddImpulseDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    String category = 'Tech';
    int coolingHours = 24;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SizedBox(
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
                      'Cool Off a New Impulse',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Pause before buying. Give your mind time to evaluate.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Item Name',
                        border: OutlineInputBorder(),
                        hintText: 'e.g., Wireless Gaming Mouse',
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: priceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Price (\$)',
                        border: OutlineInputBorder(),
                        hintText: 'e.g., 79.99',
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: category,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(),
                            ),
                            items: ['Tech', 'Fashion', 'Home', 'Food', 'Other']
                                .map((c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setModalState(() => category = val);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: coolingHours,
                            decoration: const InputDecoration(
                              labelText: 'Cooling Time',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                  value: 1, child: Text('1 Hour (Demo)')),
                              DropdownMenuItem(
                                  value: 12, child: Text('12 Hours')),
                              DropdownMenuItem(
                                  value: 24, child: Text('24 Hours')),
                              DropdownMenuItem(
                                  value: 48, child: Text('48 Hours')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setModalState(() => coolingHours = val);
                              }
                            },
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
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          final name = nameController.text.trim();
                          final price =
                              double.tryParse(priceController.text) ?? 0.0;
                          if (name.isNotEmpty && price > 0) {
                            _addCoolingItem(name, price, category, coolingHours);
                            Navigator.pop(ctx);
                          }
                        },
                        child: const Text('Start Cooling Timer'),
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

  // --- TAB 2: REGRET RISK QUIZ ---
  Widget _buildFrictionQuizTab() {
    return const FrictionQuizWidget();
  }

  // --- TAB 3: LABOR WAGE CONVERTER ---
  Widget _buildLaborConverterTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Wage & Labor Converter',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Convert dollar costs directly into your effort and grueling hours of hard work.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Wage Input Card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Your Hourly Net Wage',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${_hourlyWage.toStringAsFixed(2)}/hr',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: _hourlyWage,
                      min: 5.0,
                      max: 150.0,
                      divisions: 145,
                      activeColor: Colors.deepPurple,
                      label: '\$${_hourlyWage.toStringAsFixed(2)}',
                      onChanged: (val) {
                        setState(() {
                          _hourlyWage = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Item Simulator Card
            _LaborCalculatorCard(hourlyWage: _hourlyWage),
          ],
        ),
      ),
    );
  }

  // --- TAB 4: MICRO SAVINGS & STREAKS ---
  Widget _buildMicroSavingsTab() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String category = 'Food';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Savings Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Colors.indigo],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Micro-Savings Victory',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  FittedBox(
                    child: Text(
                      '\$${totalSavedAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bolt, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${_savedList.length} Temptations Defeated',
                          style: const TextStyle(
                            color: Colors.white,
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
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Log Quick Skipped Expense',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (ctx) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                            left: 20,
                            right: 20,
                            bottom: MediaQuery.of(context).viewInsets.bottom +
                                20,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Log Skipped Purchase',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: titleController,
                                  decoration: const InputDecoration(
                                    labelText: 'What did you skip buying?',
                                    border: OutlineInputBorder(),
                                    hintText: 'e.g., \$5 Specialty Coffee',
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: amountController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Amount Saved (\$)',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      final title = titleController.text.trim();
                                      final amt = double.tryParse(
                                              amountController.text) ??
                                          0.0;
                                      if (title.isNotEmpty && amt > 0) {
                                        _addSavedLeak(title, amt, category);
                                        Navigator.pop(ctx);
                                      }
                                    },
                                    child: const Text('Save Win!'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Quick Log'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            const Text(
              'Saved Purchases History',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _savedList.length,
              itemBuilder: (context, index) {
                final item = _savedList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.greenAccent,
                      child: Icon(Icons.check, color: Colors.green),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                    subtitle: Text(
                      'Saved on ${item.date.month}/${item.date.day}/${item.date.year}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Text(
                      '+\$${item.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
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
}

// --- INTERACTIVE WIDGET: FRICTION / REGRET QUIZ ---
class FrictionQuizWidget extends StatefulWidget {
  const FrictionQuizWidget({super.key});

  @override
  State<FrictionQuizWidget> createState() => _FrictionQuizWidgetState();
}

class _FrictionQuizWidgetState extends State<FrictionQuizWidget> {
  double _q1Value = 3; // Is it a want or need?
  bool _q2Value = false; // Is it on sale right now?
  bool _q3Value = false; // Will you use it in 30 days?
  double _q4Value = 2; // How long have you wanted it?
  bool _q5Value = true; // Does buying this delay long-term financial goals?

  int calculateRegretScore() {
    int score = 0;
    score += (_q1Value * 15).toInt(); // High want = high risk
    if (_q2Value) score += 20; // Sale psychological trap
    if (!_q3Value) score += 25; // Low utility high regret
    if (_q4Value < 3) score += 20; // Impulse freshness
    if (_q5Value) score += 20; // Goal disruption

    return score.clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    final score = calculateRegretScore();

    Color scoreColor = Colors.green;
    String scoreText = 'LOW REGRET RISK';
    String advice =
        'This purchase appears well-considered and aligned with real value.';

    if (score > 40 && score <= 70) {
      scoreColor = Colors.orange;
      scoreText = 'MODERATE REGRET RISK';
      advice =
          'Pause and place this in your Cooling Vault for 24 hours before deciding.';
    } else if (score > 70) {
      scoreColor = Colors.red;
      scoreText = 'HIGH IMPULSE DANGER!';
      advice =
          'WARNING: High probability of purchase regret. Avoid buying this right now.';
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Regret Risk Calculator',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Answer 5 quick friction questions before clicking "Buy Now".',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Dynamic Score Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: scoreColor.withOpacity(0.12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            scoreText,
                            style: TextStyle(
                              color: scoreColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          '$score%',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: scoreColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: score / 100.0,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      advice,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Question 1
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '1. Is this purchase an absolute survival NEED or a WANT?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: _q1Value,
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _q1Value == 1 ? 'Absolute Need' : 'Pure Impulse Want',
                      onChanged: (v) => setState(() => _q1Value = v),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Need', style: TextStyle(fontSize: 11)),
                        Text('Want', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Question 2
            Card(
              child: SwitchListTile(
                title: const Text(
                  '2. Are you buying this mainly because it is currently "On Sale" or discounted?',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                value: _q2Value,
                onChanged: (v) => setState(() => _q2Value = v),
              ),
            ),
            const SizedBox(height: 10),

            // Question 3
            Card(
              child: SwitchListTile(
                title: const Text(
                  '3. Are you 100% sure you will use this at least 10 times in the next month?',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                value: _q3Value,
                onChanged: (v) => setState(() => _q3Value = v),
              ),
            ),
            const SizedBox(height: 10),

            // Question 4
            Card(
              child: SwitchListTile(
                title: const Text(
                  '4. Does buying this delay or reduce your savings for major long-term goals?',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                value: _q5Value,
                onChanged: (v) => setState(() => _q5Value = v),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET: LABOR CALCULATOR & COMPOUND VISUALIZER ---
class _LaborCalculatorCard extends StatefulWidget {
  final double hourlyWage;

  const _LaborCalculatorCard({required this.hourlyWage});

  @override
  State<_LaborCalculatorCard> createState() => _LaborCalculatorCardState();
}

class _LaborCalculatorCardState extends State<_LaborCalculatorCard> {
  final TextEditingController _costController =
      TextEditingController(text: '120');

  @override
  Widget build(BuildContext context) {
    final cost = double.tryParse(_costController.text) ?? 0.0;
    final hoursNeeded = widget.hourlyWage > 0 ? (cost / widget.hourlyWage) : 0.0;
    final workDays = hoursNeeded / 8.0;

    // Opportunity Cost Calculation (Compound 7% over 5 years)
    final floatInvestment = cost * 1.4025; // ~7% annual for 5 yrs

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Item Cost Labor Equivalence',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _costController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Item Cost (\$)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              onChanged: (val) => setState(() {}),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.work_history,
                          color: Colors.deepPurple),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Labor Required: ${hoursNeeded.toStringAsFixed(1)} Hours',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'That is approx ${workDays.toStringAsFixed(1)} full 8-hour workday(s) dedicated solely to paying for this purchase.',
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.trending_up, color: Colors.green),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '5-Year Compound Value',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          'If invested instead: \$${floatInvestment.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
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
      ),
    );
  }
}