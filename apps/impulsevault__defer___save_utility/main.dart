import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const ImpulseVaultApp());
}

class ImpulseVaultApp extends StatelessWidget {
  const ImpulseVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImpulseVault',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFAFAFA),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class ImpulseItem {
  final String id;
  final String title;
  final double price;
  final String category;
  int intensity; // 1 to 10
  final DateTime createdAt;
  final int coolingHours;
  bool isDefeated;
  bool isPurchased;

  ImpulseItem({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.intensity,
    required this.createdAt,
    required this.coolingHours,
    this.isDefeated = false,
    this.isPurchased = false,
  });

  DateTime get unlockTime => createdAt.add(Duration(hours: coolingHours));
  
  bool get isCoolingExpired => DateTime.now().isAfter(unlockTime);

  Duration get remainingTime {
    final now = DateTime.now();
    if (now.isAfter(unlockTime)) return Duration.zero;
    return unlockTime.difference(now);
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedTabIndex = 0;
  double _userHourlyWage = 25.00;
  Timer? _tickerTimer;

  final List<ImpulseItem> _impulses = [
    ImpulseItem(
      id: '1',
      title: 'Wireless Gaming Headset',
      price: 149.99,
      category: 'Electronics',
      intensity: 8,
      createdAt: DateTime.now().subtract(const Duration(hours: 14)),
      coolingHours: 24,
    ),
    ImpulseItem(
      id: '2',
      title: 'Gourmet Artisan Coffee Machine',
      price: 89.50,
      category: 'Home & Kitchen',
      intensity: 6,
      createdAt: DateTime.now().subtract(const Duration(hours: 30)),
      coolingHours: 48,
    ),
    ImpulseItem(
      id: '3',
      title: 'Designer Sneakers',
      price: 210.00,
      category: 'Fashion',
      intensity: 9,
      createdAt: DateTime.now().subtract(const Duration(hours: 50)),
      coolingHours: 48,
      isDefeated: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tickerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    super.dispose();
  }

  double get _totalSavedMoney {
    return _impulses
        .where((item) => item.isDefeated)
        .fold(0.0, (sum, item) => sum + item.price);
  }

  double get _totalHoursSaved {
    if (_userHourlyWage <= 0) return 0.0;
    return _totalSavedMoney / _userHourlyWage;
  }

  void _addNewImpulse(String title, double price, String category, int intensity, int hours) {
    setState(() {
      _impulses.insert(
        0,
        ImpulseItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          price: price,
          category: category,
          intensity: intensity,
          createdAt: DateTime.now(),
          coolingHours: hours,
        ),
      );
    });
  }

  void _markAsDefeated(ImpulseItem item) {
    setState(() {
      item.isDefeated = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Victory! You defeated the urge to buy "${item.title}"! Saved \$${item.price.toStringAsFixed(2)}!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _markAsPurchased(ImpulseItem item) {
    setState(() {
      item.isPurchased = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item marked as purchased: "${item.title}". Learn for next time!'),
        backgroundColor: Colors.grey,
      ),
    );
  }

  void _showAddImpulseDialog() {
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    String selectedCategory = 'Tech & Gadgets';
    int intensity = 7;
    int coolingHours = 24;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Lock Away An Impulse',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Put your craving on pause and calculate its real cost.',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'What do you want to buy?',
                        prefixIcon: Icon(Icons.shopping_bag),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Price (\$)',
                        prefixIcon: Icon(Icons.monetization_on),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Icons.category),
                        border: OutlineInputBorder(),
                      ),
                      items: ['Tech & Gadgets', 'Fashion', 'Dining & Food', 'Home & Kitchen', 'Entertainment', 'Other']
                          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setModalState(() => selectedCategory = val);
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Urge Intensity Level: $intensity / 10',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Slider(
                      value: intensity.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      activeColor: Colors.deepPurple,
                      label: intensity.toString(),
                      onChanged: (val) {
                        setModalState(() => intensity = val.toInt());
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Cooling-Off Period:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAxisAlignment.center,
                      children: [12, 24, 48, 72].map((h) {
                        final isSelected = coolingHours == h;
                        return ChoiceChip(
                          label: Text('${h}h Pause'),
                          selected: isSelected,
                          selectedColor: Colors.deepPurple,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (selected) {
                            if (selected) setModalState(() => coolingHours = h);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.lock_clock),
                        label: const Text(
                          'START COOLING-OFF TIMER',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          final title = titleController.text.trim();
                          final price = double.tryParse(priceController.text) ?? 0.0;
                          if (title.isNotEmpty && price > 0) {
                            _addNewImpulse(title, price, selectedCategory, intensity, coolingHours);
                            Navigator.pop(context);
                          }
                        },
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

  void _showHourlyWageSettings() {
    final wageController = TextEditingController(text: _userHourlyWage.toStringAsFixed(2));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hourly Wage Reality Check'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Set your hourly net pay rate to calculate how many actual work hours each impulse purchase costs you.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: wageController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Hourly Wage (\$)',
                prefixIcon: Icon(Icons.attach_money),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
            onPressed: () {
              final w = double.tryParse(wageController.text) ?? _userHourlyWage;
              if (w > 0) {
                setState(() => _userHourlyWage = w);
              }
              Navigator.pop(context);
            },
            child: const Text('Save Rate'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.shield_outlined, color: Colors.amber),
            SizedBox(width: 8),
            Text(
              'ImpulseVault',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet, color: Colors.white),
            tooltip: 'Set Hourly Wage',
            onPressed: _showHourlyWageSettings,
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedTabIndex,
          children: [
            _buildActiveQueueTab(),
            _buildUrgeBreakerTab(),
            _buildSavingsVaultTab(),
            _buildWageCalculatorTab(),
          ],
        ),
      ),
      floatingActionButton: _selectedTabIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _showAddImpulseDialog,
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Pause Purchase', style: TextStyle(fontWeight: FontWeight.bold)),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedTabIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Active Urges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt),
            label: 'Urge Breaker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Vault & Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Value Check',
          ),
        ],
      ),
    );
  }

  Widget _buildActiveQueueTab() {
    final activeItems = _impulses.where((i) => !i.isDefeated && !i.isPurchased).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.deepPurple, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PAUSE & CONTEMPLATE',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${activeItems.length} Purchases on Pause',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hourly wage benchmark: \$${_userHourlyWage.toStringAsFixed(2)}/hr',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: _showHourlyWageSettings,
                  child: const Text('Edit Wage', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cooling-Off Queue',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Chip(
                backgroundColor: Colors.deepPurple.withOpacity(0.1),
                label: Text(
                  '${activeItems.length} Active',
                  style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (activeItems.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: const [
                  Icon(Icons.check_circle_outline, size: 60, color: Colors.green),
                  SizedBox(height: 12),
                  Text(
                    'No Impulses Locked!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'You are in full control of your spending right now. Tap the button below when you feel a buying urge!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activeItems.length,
              itemBuilder: (context, index) {
                final item = activeItems[index];
                final workHoursNeeded = _userHourlyWage > 0 ? (item.price / _userHourlyWage) : 0.0;
                final duration = item.remainingTime;
                final isExpired = item.isCoolingExpired;

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isExpired ? Colors.orange.shade300 : Colors.grey.shade200,
                      width: isExpired ? 1.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.shopping_bag_outlined, color: Colors.deepPurple),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        item.category,
                                        style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Urge Level: ${item.intensity}/10',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: item.intensity >= 8 ? Colors.red : Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              Text(
                                '≈ ${workHoursNeeded.toStringAsFixed(1)} hrs work',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Countdown Bar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isExpired ? Colors.orange.shade50 : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isExpired ? Icons.alarm_on : Icons.timer_outlined,
                              size: 18,
                              color: isExpired ? Colors.orange.shade800 : Colors.blue.shade800,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                isExpired
                                    ? 'Cooling period finished! Re-evaluate now.'
                                    : 'Time remaining: ${duration.inHours}h ${duration.inMinutes.remainder(60)}m ${duration.inSeconds.remainder(60)}s',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isExpired ? Colors.orange.shade900 : Colors.blue.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.green.shade700,
                                side: BorderSide(color: Colors.green.shade400),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.check_circle, size: 18),
                              label: const FittedBox(
                                child: Text('I Beat the Urge!', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              onPressed: () => _markAsDefeated(item),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey.shade700,
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.shopping_cart_checkout, size: 18),
                              label: const FittedBox(
                                child: Text('Still Bought It', style: TextStyle(fontWeight: FontWeight.normal)),
                              ),
                              onPressed: () => _markAsPurchased(item),
                            ),
                          ),
                        ],
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

  Widget _buildUrgeBreakerTab() {
    return const UrgeBreakerGameWidget();
  }

  Widget _buildSavingsVaultTab() {
    final defeatedItems = _impulses.where((i) => i.isDefeated).toList();
    final totalDefeatedCount = defeatedItems.length;

    // Investment potential formula: 5 years at 7% compound interest
    final fiveYearGrowth = _totalSavedMoney * 1.40255;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Savings & Freedom Vault',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
          const SizedBox(height: 4),
          const Text(
            'Track the financial power of your patience.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          // Stats Overview Grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Saved',
                  '\$${_totalSavedMoney.toStringAsFixed(2)}',
                  Icons.savings,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Hours Reclaimed',
                  '${_totalHoursSaved.toStringAsFixed(1)} hrs',
                  Icons.access_time_filled,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Urges Defeated',
                  '$totalDefeatedCount items',
                  Icons.verified,
                  Colors.purple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Hourly Rate',
                  '\$${_userHourlyWage.toStringAsFixed(2)}/h',
                  Icons.monetization_on,
                  Colors.amber.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 5-Year Investment Potential Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade700, Colors.teal.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.trending_up, color: Colors.amber),
                    SizedBox(width: 8),
                    Text(
                      '5-Year Compound Value',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'If you invest your \$${_totalSavedMoney.toStringAsFixed(2)} total savings at a standard 7% annual return, in 5 years it becomes:',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Text(
                  '\$${fiveYearGrowth.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'That is \$${(fiveYearGrowth - _totalSavedMoney).toStringAsFixed(2)} earned purely through patience!',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Defeated Impulse History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (defeatedItems.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('No saved items yet. Defeat an urge to start building your vault!'),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: defeatedItems.length,
              itemBuilder: (context, idx) {
                final item = defeatedItems[idx];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.star, color: Colors.white, size: 20),
                    ),
                    title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Category: ${item.category}'),
                    trailing: Text(
                      '+\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildWageCalculatorTab() {
    return const HourlyWageCalculatorWidget();
  }
}

class UrgeBreakerGameWidget extends StatefulWidget {
  const UrgeBreakerGameWidget({super.key});

  @override
  State<UrgeBreakerGameWidget> createState() => _UrgeBreakerGameWidgetState();
}

class _UrgeBreakerGameWidgetState extends State<UrgeBreakerGameWidget> {
  int _score = 0;
  int _secondsLeft = 60;
  bool _isPlaying = false;
  Timer? _gameTimer;

  final List<String> _cravings = [
    'Fast Food',
    'New Shoes',
    'Extra Coffee',
    'Tech Toy',
    'In-Game Skins',
    'Random Gadget',
    'Designer Wear',
    'Subscription',
  ];

  int _activeCravingIndex = 0;

  void _startGame() {
    setState(() {
      _score = 0;
      _secondsLeft = 60;
      _isPlaying = true;
      _activeCravingIndex = 0;
    });

    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 1) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _stopGame();
      }
    });
  }

  void _stopGame() {
    _gameTimer?.cancel();
    setState(() {
      _isPlaying = false;
    });
  }

  void _popCraving() {
    if (!_isPlaying) return;
    setState(() {
      _score += 10;
      _activeCravingIndex = (_activeCravingIndex + 1) % _cravings.length;
    });
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: Colors.deepPurple, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '60-Second Urge Breaker',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Dismantle sudden cravings by focusing your mind for 60 seconds.',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGameStat('Time Left', '$_secondsLeft s', Colors.blue),
              _buildGameStat('Urges Popped', '$_score pts', Colors.deepPurple),
            ],
          ),
          const SizedBox(height: 30),
          if (!_isPlaying)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  const Icon(Icons.self_improvement, size: 70, color: Colors.deepPurple),
                  const SizedBox(height: 12),
                  Text(
                    _score > 0 ? 'Urge Session Complete!' : 'Feeling an Intense Impulse?',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _score > 0
                        ? 'Great job! You redirected your brain focus for 60 seconds. High intensity urge levels drop by up to 60% after this micro-exercise!'
                        : 'Tap the button below and pop impulse bubbles for 60 seconds to reset your dopamine levels before spending.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.play_arrow),
                    label: Text(
                      _score > 0 ? 'PLAY AGAIN' : 'START 60s FOCUS SPRINT',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _startGame,
                  ),
                ],
              ),
            )
          else
            Column(
              children: [
                const Text(
                  'TAP THE CRAVING TO POP IT!',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _popCraving,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [Colors.purpleAccent, Colors.deepPurple],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.flash_on, color: Colors.amber, size: 40),
                            const SizedBox(height: 8),
                            FittedBox(
                              child: Text(
                                _cravings[_activeCravingIndex],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'TAP TO DESTROY',
                              style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildGameStat(String label, String val, Color color) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            val,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}

class HourlyWageCalculatorWidget extends StatefulWidget {
  const HourlyWageCalculatorWidget({super.key});

  @override
  State<HourlyWageCalculatorWidget> createState() => _HourlyWageCalculatorWidgetState();
}

class _HourlyWageCalculatorWidgetState extends State<HourlyWageCalculatorWidget> {
  double _monthlyIncome = 4000.0;
  double _weeklyWorkHours = 40.0;
  double _itemCost = 120.0;

  double get netHourlyWage {
    final monthlyHours = (_weeklyWorkHours * 52) / 12;
    if (monthlyHours <= 0) return 0;
    return _monthlyIncome / monthlyHours;
  }

  double get hoursToEarnItem {
    if (netHourlyWage <= 0) return 0;
    return _itemCost / netHourlyWage;
  }

  double get daysToEarnItem {
    final dailyWage = netHourlyWage * (_weeklyWorkHours / 5);
    if (dailyWage <= 0) return 0;
    return _itemCost / dailyWage;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reality Price Checker',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
          const SizedBox(height: 4),
          const Text(
            'Convert dollar tags into actual hours of your life energy spent.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Monthly Net Income (\$)'),
                const SizedBox(height: 6),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  controller: TextEditingController(text: _monthlyIncome.toStringAsFixed(0)),
                  onChanged: (val) {
                    final parsed = double.tryParse(val);
                    if (parsed != null) setState(() => _monthlyIncome = parsed);
                  },
                ),
                const SizedBox(height: 14),
                const Text('Weekly Work Hours'),
                const SizedBox(height: 6),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.schedule),
                  ),
                  controller: TextEditingController(text: _weeklyWorkHours.toStringAsFixed(0)),
                  onChanged: (val) {
                    final parsed = double.tryParse(val);
                    if (parsed != null) setState(() => _weeklyWorkHours = parsed);
                  },
                ),
                const SizedBox(height: 14),
                const Text('Prospective Item Cost (\$)'),
                const SizedBox(height: 6),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.shopping_bag),
                  ),
                  controller: TextEditingController(text: _itemCost.toStringAsFixed(0)),
                  onChanged: (val) {
                    final parsed = double.tryParse(val);
                    if (parsed != null) setState(() => _itemCost = parsed);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Calculation Results
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Calculated Hourly Wage:', style: TextStyle(color: Colors.white70)),
                    Text(
                      '\$${netHourlyWage.toStringAsFixed(2)}/hr',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const Divider(color: Colors.white70, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Work Required for Item:', style: TextStyle(color: Colors.white70)),
                    Text(
                      '${hoursToEarnItem.toStringAsFixed(1)} Work Hours',
                      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Full Work Days Cost:', style: TextStyle(color: Colors.white70)),
                    Text(
                      '${daysToEarnItem.toStringAsFixed(1)} Days',
                      style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.amber.shade900),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Ask yourself: Is this purchase worth ${hoursToEarnItem.toStringAsFixed(1)} full hours of your focused work energy?',
                    style: TextStyle(fontSize: 12, color: Colors.amber.shade900, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}