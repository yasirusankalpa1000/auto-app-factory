import 'package:flutter/material.dart';

void main() {
  runApp(const ImpulseVaultApp());
}

class ImpulseItem {
  final String id;
  final String name;
  final double price;
  final double hourlyWage;
  final DateTime lockedAt;
  final int coolingHours;
  bool isSaved;
  bool isPurchased;

  ImpulseItem({
    required this.id,
    required this.name,
    required this.price,
    required this.hourlyWage,
    required this.lockedAt,
    this.coolingHours = 24,
    this.isSaved = false,
    this.isPurchased = false,
  });

  double get workHoursNeeded => hourlyWage > 0 ? price / hourlyWage : 0;
  
  int get hoursRemaining {
    final expiry = lockedAt.add(Duration(hours: coolingHours));
    final diff = expiry.difference(DateTime.now()).inHours;
    return diff > 0 ? diff : 0;
  }
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
          seedColor: Colors.indigo,
          primary: Colors.indigo,
          secondary: Colors.amber,
          surface: const Color(0xFFF8F9FA),
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F4F8),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  double _userHourlyWage = 25.0;

  final List<ImpulseItem> _items = [
    ImpulseItem(
      id: '1',
      name: 'Wireless Gaming Headphones',
      price: 149.99,
      hourlyWage: 25.0,
      lockedAt: DateTime.now().subtract(const Duration(hours: 10)),
      coolingHours: 24,
    ),
    ImpulseItem(
      id: '2',
      name: 'Designer Espresso Cup Set',
      price: 45.00,
      hourlyWage: 25.0,
      lockedAt: DateTime.now().subtract(const Duration(hours: 30)),
      coolingHours: 24,
      isSaved: true,
    ),
  ];

  double get totalSavedMoney {
    return _items
        .where((item) => item.isSaved)
        .fold(0.0, (sum, item) => sum + item.price);
  }

  void _addItem(String name, double price, int coolingHours) {
    setState(() {
      _items.insert(
        0,
        ImpulseItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          price: price,
          hourlyWage: _userHourlyWage,
          lockedAt: DateTime.now(),
          coolingHours: coolingHours,
        ),
      );
    });
  }

  void _markAsSaved(String id) {
    setState(() {
      final index = _items.indexWhere((item) => item.id == id);
      if (index != -1) {
        _items[index].isSaved = true;
      }
    });
  }

  void _markAsPurchased(String id) {
    setState(() {
      final index = _items.indexWhere((item) => item.id == id);
      if (index != -1) {
        _items[index].isPurchased = true;
      }
    });
  }

  void _deleteItem(String id) {
    setState(() {
      _items.removeWhere((item) => item.id == id);
    });
  }

  void _showAddItemBottomSheet() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    int selectedCoolingHours = 24;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 24,
                left: 20,
                right: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Lock an Impulse Want',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Item Name',
                        hintText: 'e.g. Smart Watch, Sneakers',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.shopping_bag),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Price (\$)',
                        hintText: 'e.g. 99.99',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.monetization_on),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Cooling-Off Period',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [12, 24, 48, 72].map((hours) {
                        final isSelected = selectedCoolingHours == hours;
                        return ChoiceChip(
                          label: Text('$hours Hours'),
                          selected: isSelected,
                          selectedColor: Colors.indigo.shade100,
                          onSelected: (selected) {
                            if (selected) {
                              setModalState(() {
                                selectedCoolingHours = hours;
                              });
                            }
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
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          final name = nameController.text.trim();
                          final price = double.tryParse(priceController.text) ?? 0.0;
                          if (name.isNotEmpty && price > 0) {
                            _addItem(name, price, selectedCoolingHours);
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.lock_clock),
                        label: const Text(
                          'Lock In Vault',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  void _showWageDialog() {
    final wageController = TextEditingController(text: _userHourlyWage.toStringAsFixed(2));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set Your Hourly Wage'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This calculates how many hours of your life work each item costs.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: wageController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Hourly Wage (\$)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.work),
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
            onPressed: () {
              final val = double.tryParse(wageController.text);
              if (val != null && val > 0) {
                setState(() {
                  _userHourlyWage = val;
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.shield, color: Colors.indigo),
            SizedBox(width: 8),
            Text(
              'ImpulseVault',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet, color: Colors.indigo),
            tooltip: 'Set Hourly Wage',
            onPressed: _showWageDialog,
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          LockerTab(
            items: _items,
            hourlyWage: _userHourlyWage,
            totalSaved: totalSavedMoney,
            onMarkSaved: _markAsSaved,
            onMarkPurchased: _markAsPurchased,
            onDelete: _deleteItem,
            onAddItemTap: _showAddItemBottomSheet,
          ),
          const DecisionMatrixTab(),
          FreedomCalculatorTab(hourlyWage: _userHourlyWage),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.lock_clock),
            label: 'Vault Locker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Impulse Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Life Cost',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _showAddItemBottomSheet,
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Lock Want'),
            )
          : null,
    );
  }
}

// TAB 1: LOCKER TAB
class LockerTab extends StatelessWidget {
  final List<ImpulseItem> items;
  final double hourlyWage;
  final double totalSaved;
  final Function(String) onMarkSaved;
  final Function(String) onMarkPurchased;
  final Function(String) onDelete;
  final VoidCallback onAddItemTap;

  const LockerTab({
    super.key,
    required this.items,
    required this.hourlyWage,
    required this.totalSaved,
    required this.onMarkSaved,
    required this.onMarkPurchased,
    required this.onDelete,
    required this.onAddItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Stats Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.indigo.shade800],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black87,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Impulse Money Saved',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '\$${totalSaved.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.work, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '\$${hourlyWage.toStringAsFixed(0)}/hr',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.bolt, color: Colors.amber, size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Cooling period stops micro-impulse buys before they happen.',
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Cooling Locker',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Chip(
                  backgroundColor: Colors.indigo.shade50,
                  label: Text(
                    '${items.length} Items',
                    style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (items.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.lock_open, size: 48, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text(
                      'Your Locker is Empty!',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Felt a sudden urge to buy something online? Put it in the vault first.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: onAddItemTap,
                      icon: const Icon(Icons.add),
                      label: const Text('Add First Item'),
                    )
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isReadyToDecide = item.hoursRemaining == 0;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: item.isSaved
                            ? Colors.green.shade200
                            : (item.isPurchased ? Colors.grey.shade300 : Colors.indigo.shade100),
                        width: 1.5,
                      ),
                    ),
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
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        decoration: item.isSaved || item.isPurchased
                                            ? TextDecoration.lineThrough
                                            : null,
                                        color: item.isSaved || item.isPurchased
                                            ? Colors.grey
                                            : Colors.black87,
                                      ),
                                      softWrap: true,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${item.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.indigo,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.grey, size: 20),
                                onPressed: () => onDelete(item.id),
                              )
                            ],
                          ),
                          const Divider(height: 20),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Chip(
                                avatar: const Icon(Icons.schedule, size: 14, color: Colors.indigo),
                                label: Text(
                                  'Costs ${item.workHoursNeeded.toStringAsFixed(1)} Work Hours',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                                backgroundColor: Colors.indigo.shade50,
                              ),
                              if (!item.isSaved && !item.isPurchased)
                                Chip(
                                  avatar: Icon(
                                    isReadyToDecide ? Icons.check_circle : Icons.timer,
                                    size: 14,
                                    color: isReadyToDecide ? Colors.green : Colors.amber.shade900,
                                  ),
                                  label: Text(
                                    isReadyToDecide
                                        ? 'Cooling Complete!'
                                        : '${item.hoursRemaining}h Remaining',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isReadyToDecide ? Colors.green : Colors.amber.shade900,
                                    ),
                                  ),
                                  backgroundColor: isReadyToDecide
                                      ? Colors.green.shade50
                                      : Colors.amber.shade50,
                                ),
                              if (item.isSaved)
                                const Chip(
                                  avatar: Icon(Icons.savings, size: 14, color: Colors.green),
                                  label: Text(
                                    'Saved & Skipped',
                                    style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: Color(0xFFE8F5E9),
                                ),
                              if (item.isPurchased)
                                const Chip(
                                  avatar: Icon(Icons.shopping_cart, size: 14, color: Colors.grey),
                                  label: Text(
                                    'Purchased',
                                    style: TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                  backgroundColor: Color(0xFFF5F5F5),
                                ),
                            ],
                          ),
                          if (!item.isSaved && !item.isPurchased) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.green,
                                      side: const BorderSide(color: Colors.green),
                                    ),
                                    onPressed: () => onMarkSaved(item.id),
                                    icon: const Icon(Icons.savings, size: 16),
                                    label: const FittedBox(
                                      child: Text('Skip & Save'),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade200,
                                      foregroundColor: Colors.black87,
                                      elevation: 0,
                                    ),
                                    onPressed: () => onMarkPurchased(item.id),
                                    icon: const Icon(Icons.check, size: 16),
                                    label: const FittedBox(
                                      child: Text('Bought It'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]
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

// TAB 2: DECISION MATRIX QUIZ
class DecisionMatrixTab extends StatefulWidget {
  const DecisionMatrixTab({super.key});

  @override
  State<DecisionMatrixTab> createState() => _DecisionMatrixTabState();
}

class _DecisionMatrixTabState extends State<DecisionMatrixTab> {
  int _q1UseDaily = 0; // 0: No, 1: Yes
  int _q2HaveSimilar = 0; // 0: Yes, 1: No
  int _q3AffordTwice = 0; // 0: No, 1: Yes
  int _q4StillWantIn30Days = 0; // 0: No, 1: Yes

  int get score {
    return _q1UseDaily + _q2HaveSimilar + _q3AffordTwice + _q4StillWantIn30Days;
  }

  String get recommendation {
    if (score <= 1) return 'High Impulse Risk! Do NOT Buy.';
    if (score == 2 || score == 3) return 'Moderate Need. Wait 48 Hours.';
    return 'Mindful Purchase. Safe to buy!';
  }

  Color get recommendationColor {
    if (score <= 1) return Colors.red;
    if (score == 2 || score == 3) return Colors.amber.shade900;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Smart Impulse Quiz',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const Text(
              'Answer 4 quick questions before tapping "Buy" anywhere online.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _buildQuizCard(
              title: '1. Will you use this item at least 3 times a week?',
              val: _q1UseDaily,
              onChanged: (v) => setState(() => _q1UseDaily = v),
            ),
            _buildQuizCard(
              title: '2. Do you currently own NO similar items?',
              val: _q2HaveSimilar,
              onChanged: (v) => setState(() => _q2HaveSimilar = v),
            ),
            _buildQuizCard(
              title: '3. Can you easily buy this TWICE without touching savings?',
              val: _q3AffordTwice,
              onChanged: (v) => setState(() => _q3AffordTwice = v),
            ),
            _buildQuizCard(
              title: '4. If you wait 30 days, will it still matter to you?',
              val: _q4StillWantIn30Days,
              onChanged: (v) => setState(() => _q4StillWantIn30Days = v),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: recommendationColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: recommendationColor, width: 2),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        score >= 3 ? Icons.thumb_up : Icons.thumb_down,
                        color: recommendationColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Score: $score / 4',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: recommendationColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recommendation,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: recommendationColor,
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

  Widget _buildQuizCard({
    required String title,
    required int val,
    required Function(int) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            softWrap: true,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('Yes')),
                  selected: val == 1,
                  selectedColor: Colors.indigo.shade100,
                  onSelected: (_) => onChanged(1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('No')),
                  selected: val == 0,
                  selectedColor: Colors.indigo.shade100,
                  onSelected: (_) => onChanged(0),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// TAB 3: FREEDOM & REAL-LIFE VALUE CALCULATOR
class FreedomCalculatorTab extends StatefulWidget {
  final double hourlyWage;

  const FreedomCalculatorTab({super.key, required this.hourlyWage});

  @override
  State<FreedomCalculatorTab> createState() => _FreedomCalculatorTabState();
}

class _FreedomCalculatorTabState extends State<FreedomCalculatorTab> {
  double _priceInput = 120.0;

  @override
  Widget build(BuildContext context) {
    final double hoursNeeded = widget.hourlyWage > 0 ? _priceInput / widget.hourlyWage : 0;
    final double coffees = _priceInput / 4.50;
    final double netflixMonths = _priceInput / 15.49;
    final double workDays = hoursNeeded / 8.0;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Life-Cost Calculator',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const Text(
              'Translate any price tag into hours of real life work & equivalents.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Target Item Price',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${_priceInput.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _priceInput,
                    min: 10,
                    max: 1000,
                    divisions: 99,
                    activeColor: Colors.indigo,
                    label: '\$${_priceInput.round()}',
                    onChanged: (val) {
                      setState(() {
                        _priceInput = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'What This Money Is Really Worth:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildEquivalencyTile(
              icon: Icons.access_time_filled,
              color: Colors.indigo,
              title: '${hoursNeeded.toStringAsFixed(1)} Hours of Work',
              subtitle: 'Based on your \$${widget.hourlyWage.toStringAsFixed(0)}/hr wage standard',
            ),
            _buildEquivalencyTile(
              icon: Icons.calendar_today,
              color: Colors.teal,
              title: '${workDays.toStringAsFixed(1)} Full Work Days',
              subtitle: 'Straight 8-hour shift labor to pay for this single item',
            ),
            _buildEquivalencyTile(
              icon: Icons.local_cafe,
              color: Colors.brown,
              title: '${coffees.toStringAsFixed(0)} Cappuccinos',
              subtitle: 'Equal to ${coffees.toStringAsFixed(0)} morning coffee breaks',
            ),
            _buildEquivalencyTile(
              icon: Icons.tv,
              color: Colors.redAccent,
              title: '${netflixMonths.toStringAsFixed(1)} Months of Streaming',
              subtitle: 'Equivalent subscription entertainment months',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquivalencyTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  softWrap: true,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  softWrap: true,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}