import 'dart:async';
import 'package:flutter/material.dart';

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
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF12181F),
        cardTheme: CardTheme(
          color: const Color(0xFF1E2631),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class ImpulseItem {
  final String id;
  final String title;
  final double price;
  final String category;
  final DateTime createdAt;
  final int coolOffHours;
  bool isResisted;
  bool isBought;

  ImpulseItem({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.createdAt,
    this.coolOffHours = 24,
    this.isResisted = false,
    this.isBought = false,
  });

  double hoursToEarn(double hourlyWage) {
    if (hourlyWage <= 0) return 0;
    return price / hourlyWage;
  }

  int remainingSeconds() {
    final unlockTime = createdAt.add(Duration(hours: coolOffHours));
    final diff = unlockTime.difference(DateTime.now()).inSeconds;
    return diff > 0 ? diff : 0;
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  double _userHourlyWage = 25.00;
  int _willpowerPoints = 140;
  int _currentStreak = 4;

  final List<ImpulseItem> _vaultItems = [
    ImpulseItem(
      id: '1',
      title: 'Wireless Earbuds Upgrade',
      price: 89.99,
      category: 'Tech',
      createdAt: DateTime.now().subtract(const Duration(hours: 14)),
      coolOffHours: 24,
    ),
    ImpulseItem(
      id: '2',
      title: 'Designer Hoodie',
      price: 65.00,
      category: 'Fashion',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      coolOffHours: 48,
    ),
    ImpulseItem(
      id: '3',
      title: 'Gourmet Artisanal Coffee Set',
      price: 24.50,
      category: 'Food',
      createdAt: DateTime.now().subtract(const Duration(hours: 22)),
      coolOffHours: 24,
    ),
  ];

  Timer? _tickerTimer;

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

  double get _totalSaved {
    double sum = 0;
    for (var item in _vaultItems) {
      if (item.isResisted) {
        sum += item.price;
      }
    }
    return sum + 179.50; // Initial mock saved history
  }

  void _addNewVaultItem(
      String title, double price, String category, int hours) {
    setState(() {
      _vaultItems.insert(
        0,
        ImpulseItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          price: price,
          category: category,
          createdAt: DateTime.now(),
          coolOffHours: hours,
        ),
      );
      _willpowerPoints += 10;
    });
  }

  void _markResisted(ImpulseItem item) {
    setState(() {
      item.isResisted = true;
      _willpowerPoints += 50;
      _currentStreak += 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Awesome! You saved \$${item.price.toStringAsFixed(2)} and gained 50 Willpower XP!',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _markBought(ImpulseItem item) {
    setState(() {
      item.isBought = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      VaultTab(
        items: _vaultItems,
        hourlyWage: _userHourlyWage,
        onResist: _markResisted,
        onBought: _markBought,
        onAddItemTap: () => _showAddItemBottomSheet(context),
      ),
      WageConverterTab(
        hourlyWage: _userHourlyWage,
        onWageChanged: (newWage) {
          setState(() {
            _userHourlyWage = newWage;
          });
        },
      ),
      CravingDelayTimerTab(
        onTimerComplete: () {
          setState(() {
            _willpowerPoints += 25;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Craving conquered! +25 Willpower XP added.'),
              backgroundColor: Colors.teal,
            ),
          );
        },
      ),
      DashboardTab(
        totalSaved: _totalSaved,
        streakDays: _currentStreak,
        willpowerPoints: _willpowerPoints,
        hourlyWage: _userHourlyWage,
        vaultItems: _vaultItems,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.shield, color: Colors.teal),
            const SizedBox(width: 8),
            const Text(
              'ImpulseVault',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF18202A),
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber.shade900.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber, width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '\$_willpowerPoints XP',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        backgroundColor: const Color(0xFF18202A),
        indicatorColor: Colors.teal.shade800,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.lock_clock_outlined),
            selectedIcon: Icon(Icons.lock_clock, color: Colors.tealAccent),
            label: 'Cooling Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate, color: Colors.tealAccent),
            label: 'Time Cost',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer, color: Colors.tealAccent),
            label: 'Craving Timer',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights, color: Colors.tealAccent),
            label: 'Stats',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => _showAddItemBottomSheet(context),
              backgroundColor: Colors.teal,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Lock An Impulse',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }

  void _showAddItemBottomSheet(BuildContext context) {
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    String selectedCategory = 'Tech';
    int coolOffHours = 24;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A222D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade600,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Cool Off An Impulse Purchase',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Lock this item in your vault for a cooling-off period before deciding to buy.',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Item Name (e.g. Trendy Shoes)',
                        prefixIcon: Icon(Icons.shopping_bag, color: Colors.teal),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Price (\$ USD)',
                        prefixIcon: Icon(Icons.attach_money, color: Colors.teal),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Category',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['Tech', 'Fashion', 'Food', 'Gaming', 'Home', 'Other']
                          .map((cat) => ChoiceChip(
                                label: Text(cat),
                                selected: selectedCategory == cat,
                                onSelected: (sel) {
                                  if (sel) {
                                    setModalState(() {
                                      selectedCategory = cat;
                                    });
                                  }
                                },
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Cooling Period:',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        DropdownButton<int>(
                          value: coolOffHours,
                          dropdownColor: const Color(0xFF24303E),
                          items: const [
                            DropdownMenuItem(value: 12, child: Text('12 Hours')),
                            DropdownMenuItem(value: 24, child: Text('24 Hours')),
                            DropdownMenuItem(value: 48, child: Text('48 Hours')),
                            DropdownMenuItem(value: 72, child: Text('72 Hours')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                coolOffHours = val;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          final title = titleController.text.trim();
                          final price = double.tryParse(priceController.text) ?? 0;
                          if (title.isNotEmpty && price > 0) {
                            _addNewVaultItem(title, price, selectedCategory, coolOffHours);
                            Navigator.pop(ctx);
                          }
                        },
                        icon: const Icon(Icons.lock, color: Colors.white),
                        label: const Text(
                          'Lock In Vault & Start Timer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

class VaultTab extends StatelessWidget {
  final List<ImpulseItem> items;
  final double hourlyWage;
  final Function(ImpulseItem) onResist;
  final Function(ImpulseItem) onBought;
  final VoidCallback onAddItemTap;

  const VaultTab({
    super.key,
    required this.items,
    required this.hourlyWage,
    required this.onResist,
    required this.onBought,
    required this.onAddItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeItems = items.where((i) => !i.isResisted && !i.isBought).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade900, const Color(0xFF1E2631)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.shade700, width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield, size: 40, color: Colors.tealAccent),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cooling Off Vault',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Wait for the timer to expire before spending. Most urges fade after 24 hours!',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade300),
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
                Text(
                  'Active Locked Items (${activeItems.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextButton.icon(
                  onPressed: onAddItemTap,
                  icon: const Icon(Icons.add, size: 18, color: Colors.tealAccent),
                  label: const Text(
                    'Add New',
                    style: TextStyle(color: Colors.tealAccent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (activeItems.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2631),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(Icons.check_circle_outline, size: 48, color: Colors.teal.shade300),
                    const SizedBox(height: 12),
                    const Text(
                      'No Active Impulse Urges!',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Great job! Whenever you feel an urge to buy something unplanned, tap below to lock it here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      onPressed: onAddItemTap,
                      child: const Text('Lock an Impulse Item', style: TextStyle(color: Colors.white)),
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
                  final remSecs = item.remainingSeconds();
                  final hoursEarn = item.hoursToEarn(hourlyWage);
                  final isUnlocked = remSecs <= 0;

                  final hoursLeft = remSecs ~/ 3600;
                  final minsLeft = (remSecs % 3600) ~/ 60;
                  final secsLeft = remSecs % 60;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade900.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item.category,
                                  style: const TextStyle(fontSize: 11, color: Colors.tealAccent),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.tealAccent,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade900.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Costs ${hoursEarn.toStringAsFixed(1)} hours of work',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.orangeAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF141A22),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isUnlocked ? Icons.lock_open : Icons.timer,
                                  color: isUnlocked ? Colors.green : Colors.amber,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    isUnlocked
                                        ? 'Cooling period finished! Do you still really need this?'
                                        : 'Cooling Off Timer: ${hoursLeft.toString().padLeft(2, '0')}:${minsLeft.toString().padLeft(2, '0')}:${secsLeft.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isUnlocked ? Colors.greenAccent : Colors.amber,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () => onResist(item),
                                  icon: const Icon(Icons.check, color: Colors.white, size: 18),
                                  label: const FittedBox(
                                    child: Text(
                                      'Resisted & Saved!',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.grey,
                                  side: BorderSide(color: Colors.grey.shade700),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () => onBought(item),
                                child: const Text('Bought It'),
                              ),
                            ],
                          ),
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
}

class WageConverterTab extends StatefulWidget {
  final double hourlyWage;
  final ValueChanged<double> onWageChanged;

  const WageConverterTab({
    super.key,
    required this.hourlyWage,
    required this.onWageChanged,
  });

  @override
  State<WageConverterTab> createState() => _WageConverterTabState();
}

class _WageConverterTabState extends State<WageConverterTab> {
  final _itemPriceController = TextEditingController(text: '120.00');
  final _wageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _wageController.text = widget.hourlyWage.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(_itemPriceController.text) ?? 0.0;
    final wage = double.tryParse(_wageController.text) ?? 1.0;

    final hoursWorked = wage > 0 ? price / wage : 0.0;
    final workDays = hoursWorked / 8.0;

    // Investment potential (assuming 7% annual growth over 5 years)
    final floatPrice = price;
    final fiveYrVal = floatPrice * 1.4025;
    final tenYrVal = floatPrice * 1.967;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Time-Cost & Wealth Calculator',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            const Text(
              'Translate money into real hours of your work and see future opportunity cost.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _wageController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (val) {
                        final w = double.tryParse(val);
                        if (w != null && w > 0) {
                          widget.onWageChanged(w);
                        }
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                        labelText: 'Your Hourly Wage (\$/hr)',
                        prefixIcon: Icon(Icons.monetization_on, color: Colors.teal),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _itemPriceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        labelText: 'Impulse Item Price (\$)',
                        prefixIcon: Icon(Icons.shopping_cart, color: Colors.teal),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2631),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  const Text(
                    'To buy this item, you must work:',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    child: Text(
                      '${hoursWorked.toStringAsFixed(1)} Work Hours',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Equivalent to ~${workDays.toStringAsFixed(1)} full 8-hour workday(s)',
                    style: TextStyle(fontSize: 12, color: Colors.amber.shade200),
                  ),
                  const Divider(height: 24, color: Colors.grey),
                  const Text(
                    'If you skip buying and invest the money instead:',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildGrowthStat('5 Years', '\$${fiveYrVal.toStringAsFixed(2)}'),
                      Container(width: 1, height: 36, color: Colors.grey.shade700),
                      _buildGrowthStat('10 Years', '\$${tenYrVal.toStringAsFixed(2)}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Mindful Rule of Thumb',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ask yourself: "Would I sit at my desk and work for ${hoursWorked.toStringAsFixed(1)} hours straight just to get this single physical item?" If the answer is no, lock it in the cooling vault!',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
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

  Widget _buildGrowthStat(String title, String val) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          val,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.greenAccent,
          ),
        ),
      ],
    );
  }
}

class CravingDelayTimerTab extends StatefulWidget {
  final VoidCallback onTimerComplete;

  const CravingDelayTimerTab({super.key, required this.onTimerComplete});

  @override
  State<CravingDelayTimerTab> createState() => _CravingDelayTimerTabState();
}

class _CravingDelayTimerTabState extends State<CravingDelayTimerTab> {
  static const int _initialSeconds = 300; // 5 minute urge delay session
  int _secondsRemaining = _initialSeconds;
  Timer? _timer;
  bool _isRunning = false;

  void _startTimer() {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _stopTimer();
        widget.onTimerComplete();
        _resetTimer();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _secondsRemaining = _initialSeconds;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mins = _secondsRemaining ~/ 60;
    final secs = _secondsRemaining % 60;
    final progress = 1.0 - (_secondsRemaining / _initialSeconds);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              '5-Minute Craving Delay Mode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            const Text(
              'Scientific studies show neuro-cravings peak and subside within 5 minutes. Focus here until the timer ends!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: const Color(0xFF1E2631),
                    color: Colors.tealAccent,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Breathe & Pause',
                      style: TextStyle(fontSize: 12, color: Colors.tealAccent),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRunning ? Colors.amber.shade800 : Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isRunning ? _stopTimer : _startTimer,
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow, color: Colors.white),
                  label: Text(
                    _isRunning ? 'Pause' : 'Start Delay Timer',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    side: BorderSide(color: Colors.grey.shade700),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh, color: Colors.grey),
                  label: const Text('Reset', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Craving Distraction Exercise:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Drink a cold glass of water.\n'
                      '• Walk away from your computer or phone screen.\n'
                      '• Name 5 blue objects around your room.',
                      style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),
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
}

class DashboardTab extends StatelessWidget {
  final double totalSaved;
  final int streakDays;
  final int willpowerPoints;
  final double hourlyWage;
  final List<ImpulseItem> vaultItems;

  const DashboardTab({
    super.key,
    required this.totalSaved,
    required this.streakDays,
    required this.willpowerPoints,
    required this.hourlyWage,
    required this.vaultItems,
  });

  @override
  Widget build(BuildContext context) {
    final hoursSaved = hourlyWage > 0 ? totalSaved / hourlyWage : 0.0;
    final resistedCount = vaultItems.where((i) => i.isResisted).length + 6;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Willpower & Savings Stats',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            const Text(
              'Your impulse resilience and lifetime win progress.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Total Saved',
                    '\$${totalSaved.toStringAsFixed(2)}',
                    Icons.account_balance_wallet,
                    Colors.tealAccent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Life Hours Retained',
                    '${hoursSaved.toStringAsFixed(1)} hrs',
                    Icons.access_time,
                    Colors.amberAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Willpower Streak',
                    '$streakDays Days',
                    Icons.local_fire_department,
                    Colors.orangeAccent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Urges Resisted',
                    '$resistedCount Items',
                    Icons.check_circle,
                    Colors.greenAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Unlocked Achievements',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            _buildAchievementTile(
              'First Lockdown',
              'Locked your first impulse item in the cooling vault.',
              Icons.lock,
              true,
            ),
            _buildAchievementTile(
              '24-Hour Master',
              'Successfully resisted an item after a full 24h cool-off.',
              Icons.star,
              true,
            ),
            _buildAchievementTile(
              'Century Saver',
              'Saved over \$100.00 in impulse purchases!',
              Icons.monetization_on,
              totalSaved >= 100,
            ),
            _buildAchievementTile(
              'Zen Master',
              'Completed 5 Craving Delay sessions.',
              Icons.self_improvement,
              willpowerPoints >= 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2631),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          FittedBox(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementTile(String title, String desc, IconData icon, bool isUnlocked) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isUnlocked ? Colors.teal.shade800 : const Color(0xFF141A22),
          child: Icon(
            icon,
            color: isUnlocked ? Colors.tealAccent : Colors.grey,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isUnlocked ? Colors.white : Colors.grey,
          ),
        ),
        subtitle: Text(
          desc,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        trailing: Icon(
          isUnlocked ? Icons.check_circle : Icons.lock,
          color: isUnlocked ? Colors.tealAccent : Colors.grey.shade700,
          size: 18,
        ),
      ),
    );
  }
}