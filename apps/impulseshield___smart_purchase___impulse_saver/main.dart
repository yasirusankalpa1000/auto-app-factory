import 'package:flutter/material.dart';

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
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class EvaluatedItem {
  final String id;
  final String name;
  final double price;
  final double hoursRequired;
  final int riskScore; // 1 to 5 (1 safe, 5 high impulse)
  final DateTime addedDate;
  final int cooldownHours;
  String status; // 'cooldown', 'saved', 'bought'

  EvaluatedItem({
    required this.id,
    required this.name,
    required this.price,
    required this.hoursRequired,
    required this.riskScore,
    required this.addedDate,
    required this.cooldownHours,
    this.status = 'cooldown',
  });
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  double _hourlyWage = 25.0; // Default hourly wage

  // Mock list of evaluation items
  final List<EvaluatedItem> _items = [
    EvaluatedItem(
      id: '1',
      name: 'Wireless Gaming Headphones',
      price: 149.99,
      hoursRequired: 6.0,
      riskScore: 4,
      addedDate: DateTime.now().subtract(const Duration(hours: 12)),
      cooldownHours: 24,
      status: 'cooldown',
    ),
    EvaluatedItem(
      id: '2',
      name: 'Designer Sneakers Sale',
      price: 210.00,
      hoursRequired: 8.4,
      riskScore: 5,
      addedDate: DateTime.now().subtract(const Duration(hours: 30)),
      cooldownHours: 48,
      status: 'saved',
    ),
    EvaluatedItem(
      id: '3',
      name: 'Smart Coffee Mug Heater',
      price: 35.00,
      hoursRequired: 1.4,
      riskScore: 2,
      addedDate: DateTime.now().subtract(const Duration(days: 3)),
      cooldownHours: 24,
      status: 'saved',
    ),
  ];

  double get totalSaved {
    return _items
        .where((item) => item.status == 'saved')
        .fold(0.0, (sum, item) => sum + item.price);
  }

  double get hoursSaved {
    if (_hourlyWage <= 0) return 0;
    return totalSaved / _hourlyWage;
  }

  int get userLevel {
    if (totalSaved < 100) return 1;
    if (totalSaved < 300) return 2;
    if (totalSaved < 700) return 3;
    if (totalSaved < 1500) return 4;
    return 5;
  }

  String get levelTitle {
    switch (userLevel) {
      case 1:
        return 'Impulse Novice';
      case 2:
        return 'Smart Saver';
      case 3:
        return 'Disciplined Buyer';
      case 4:
        return 'Financial Guardian';
      default:
        return 'Master ImpulseShield';
    }
  }

  void _updateWage(double newWage) {
    setState(() {
      _hourlyWage = newWage;
    });
  }

  void _addItem(EvaluatedItem item) {
    setState(() {
      _items.insert(0, item);
      _currentIndex = 1; // Switch to Cooldown Room
    });
  }

  void _changeItemStatus(String id, String status) {
    setState(() {
      final index = _items.indexWhere((element) => element.id == id);
      if (index != -1) {
        _items[index].status = status;
      }
    });
  }

  void _showWageDialog() {
    final controller = TextEditingController(text: _hourlyWage.toStringAsFixed(2));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set Hourly Income'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your net hourly earnings to translate item costs into real working hours.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Hourly Wage (\$) ',
                border: OutlineInputBorder(),
                prefixText: '\$ ',
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
              final val = double.tryParse(controller.text);
              if (val != null && val > 0) {
                _updateWage(val);
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      EvaluateScreen(hourlyWage: _hourlyWage, onAddItem: _addItem),
      CooldownScreen(
        items: _items.where((i) => i.status == 'cooldown').toList(),
        hourlyWage: _hourlyWage,
        onStatusChange: _changeItemStatus,
      ),
      CompareScreen(hourlyWage: _hourlyWage),
      VaultScreen(
        items: _items,
        totalSaved: totalSaved,
        hoursSaved: hoursSaved,
        userLevel: userLevel,
        levelTitle: levelTitle,
        hourlyWage: _hourlyWage,
        onOpenWageDialog: _showWageDialog,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.shield, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'ImpulseShield',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            tooltip: 'Update Hourly Wage',
            onPressed: _showWageDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        items: const [
          BottomNavigationBarTypeItem(
            icon: Icon(Icons.add_shopping_cart),
            label: 'Evaluate',
          ),
          BottomNavigationBarTypeItem(
            icon: Icon(Icons.timer),
            label: 'Cooldown',
          ),
          BottomNavigationBarTypeItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Compare',
          ),
          BottomNavigationBarTypeItem(
            icon: Icon(Icons.savings),
            label: 'Vault',
          ),
        ],
      ),
    );
  }
}

// Custom BottomNavigationBar item helper wrapper
class BottomNavigationBarTypeItem extends BottomNavigationBarItem {
  const BottomNavigationBarTypeItem({required Widget icon, required String label})
      : super(icon: icon, label: label);
}

// -------------------------------------------------------------
// TAB 1: EVALUATE SCREEN
// -------------------------------------------------------------
class EvaluateScreen extends StatefulWidget {
  final double hourlyWage;
  final Function(EvaluatedItem) onAddItem;

  const EvaluateScreen({
    super.key,
    required this.hourlyWage,
    required this.onAddItem,
  });

  @override
  State<EvaluateScreen> createState() => _EvaluateScreenState();
}

class _EvaluateScreenState extends State<EvaluateScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  // Quiz criteria values
  bool _isEssential = false;
  bool _willUseMonthly = true;
  bool _boughtEmotionally = false;
  bool _canAffordDouble = true;
  bool _wantedOverWeek = false;

  int _selectedCooldownHours = 24;

  int get _calculatedRiskScore {
    int score = 1;
    if (!_isEssential) score += 1;
    if (!_willUseMonthly) score += 1;
    if (_boughtEmotionally) score += 1;
    if (!_canAffordDouble) score += 1;
    if (!_wantedOverWeek) score += 1;
    return score.clamp(1, 5);
  }

  Color get _riskColor {
    switch (_calculatedRiskScore) {
      case 1:
      case 2:
        return Colors.green;
      case 3:
        return Colors.orange;
      case 4:
      case 5:
      default:
        return Colors.red;
    }
  }

  String get _riskLabel {
    switch (_calculatedRiskScore) {
      case 1:
      case 2:
        return 'LOW IMPULSE RISK';
      case 3:
        return 'MODERATE IMPULSE RISK';
      case 4:
      case 5:
      default:
        return 'HIGH IMPULSE DANGER!';
    }
  }

  void _submitEvaluation() {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim());

    if (name.isEmpty || price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid item name and price.')),
      );
      return;
    }

    final hours = widget.hourlyWage > 0 ? (price / widget.hourlyWage) : 0.0;

    final item = EvaluatedItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      price: price,
      hoursRequired: hours,
      riskScore: _calculatedRiskScore,
      addedDate: DateTime.now(),
      cooldownHours: _selectedCooldownHours,
      status: 'cooldown',
    );

    widget.onAddItem(item);
    _nameController.clear();
    _priceController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"$name" locked into Cooldown Room for $_selectedCooldownHours hrs!'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _openUrgeBusterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => const UrgeBusterModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPrice = double.tryParse(_priceController.text) ?? 0.0;
    final hoursCost = widget.hourlyWage > 0 ? (currentPrice / widget.hourlyWage) : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner for Urge Buster
          Card(
            color: Colors.teal.shade50,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.teal.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const Icon(Icons.psychology, color: Colors.teal, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Feeling an overwhelming urge?',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          'Take a 60-second breathing cool-off before deciding.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _openUrgeBusterModal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: const Text('Bust Urge', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Inputs
          const Text(
            'Evaluate Impulse Purchase',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          const SizedBox(height: 12),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Item Name / Desired Product',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.shopping_bag_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Price (\$) ',
                      border: OutlineInputBorder(),
                      prefixText: '\$ ',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Hourly wage calculation output banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.work_outline, color: Colors.amber),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black87, fontSize: 13),
                              children: [
                                const TextSpan(text: 'This item will cost you '),
                                TextSpan(
                                  text: '${hoursCost.toStringAsFixed(1)} hours ',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                                ),
                                TextSpan(
                                  text: 'of your life at \$${widget.hourlyWage.toStringAsFixed(2)}/hr.',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Psychological Assessment Questionnaire
          const Text(
            'Quick Reality Check Quiz',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Is this an absolute survival/work need?'),
                  subtitle: const Text('Food, health, essential work tools'),
                  value: _isEssential,
                  activeColor: Colors.teal,
                  onChanged: (val) => setState(() => _isEssential = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Will you use this at least weekly in 3 months?'),
                  value: _willUseMonthly,
                  activeColor: Colors.teal,
                  onChanged: (val) => setState(() => _willUseMonthly = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Are you buying due to stress, boredom, or excitement?'),
                  subtitle: const Text('Emotional buying triggers standard regrets'),
                  value: _boughtEmotionally,
                  activeColor: Colors.teal,
                  onChanged: (val) => setState(() => _boughtEmotionally = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Could you afford buying 2 of these right now in cash?'),
                  value: _canAffordDouble,
                  activeColor: Colors.teal,
                  onChanged: (val) => setState(() => _canAffordDouble = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Have you wanted this item for more than 7 days?'),
                  value: _wantedOverWeek,
                  activeColor: Colors.teal,
                  onChanged: (val) => setState(() => _wantedOverWeek = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Cooldown Duration Selector & Risk Summary
          Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Impulse Risk Meter:'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _riskColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _riskLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Select Forced Cooldown Period:'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAxisAlignment.center,
                    children: [24, 48, 72].map((hours) {
                      final selected = _selectedCooldownHours == hours;
                      return ChoiceChip(
                        label: Text('$hours Hours Lock'),
                        selected: selected,
                        selectedColor: Colors.teal,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedCooldownHours = hours);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _submitEvaluation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.lock_clock, color: Colors.white),
              label: const Text(
                'Lock in Cooldown Room',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// TAB 2: COOLDOWN ROOM
// -------------------------------------------------------------
class CooldownScreen extends StatelessWidget {
  final List<EvaluatedItem> items;
  final double hourlyWage;
  final Function(String, String) onStatusChange;

  const CooldownScreen({
    super.key,
    required this.items,
    required this.hourlyWage,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.check_circle_outline, size: 70, color: Colors.teal),
              SizedBox(height: 16),
              Text(
                'Cooldown Room is Empty!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'No purchases are currently on delay lock. Evaluate a new purchase impulse to test your discipline.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (ctx, idx) {
        final item = items[idx];
        final now = DateTime.now();
        final unlockTime = item.addedDate.add(Duration(hours: item.cooldownHours));
        final isUnlocked = now.isAfter(unlockTime);
        final remaining = unlockTime.difference(now);

        final remainingHours = remaining.inHours;
        final remainingMins = remaining.inMinutes.remainder(60);

        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.schedule, size: 16, color: Colors.blueGrey),
                      label: Text(
                        isUnlocked
                            ? 'Cooldown Complete!'
                            : 'Lock: ${remainingHours}h ${remainingMins}m left',
                        style: TextStyle(
                          fontSize: 12,
                          color: isUnlocked ? Colors.green.shade800 : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: isUnlocked ? Colors.green.shade50 : Colors.grey.shade200,
                    ),
                    Chip(
                      avatar: const Icon(Icons.work_outline, size: 16, color: Colors.amber),
                      label: Text(
                        '${item.hoursRequired.toStringAsFixed(1)} Work Hrs',
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: Colors.amber.shade50,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'After taking time to step back, do you still want to buy this item?',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          onStatusChange(item.id, 'saved');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Awesome! Saved \$${item.price.toStringAsFixed(2)}!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        icon: const Icon(Icons.savings, color: Colors.white, size: 18),
                        label: const Text(
                          'I Resisted! (Save)',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          onStatusChange(item.id, 'bought');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Item marked as purchased.')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          side: const BorderSide(color: Colors.red),
                        ),
                        icon: const Icon(Icons.shopping_cart, color: Colors.red, size: 18),
                        label: const Text(
                          'Bought It',
                          style: TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// -------------------------------------------------------------
// TAB 3: COMPARE & DECIDE
// -------------------------------------------------------------
class CompareScreen extends StatefulWidget {
  final double hourlyWage;

  const CompareScreen({super.key, required this.hourlyWage});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  final _nameA = TextEditingController(text: 'Option A: New Headphones');
  final _priceA = TextEditingController(text: '120');

  final _nameB = TextEditingController(text: 'Option B: Smartwatch');
  final _priceB = TextEditingController(text: '250');

  double _ratingA = 3;
  double _ratingB = 4;

  @override
  Widget build(BuildContext context) {
    final pA = double.tryParse(_priceA.text) ?? 0.0;
    final pB = double.tryParse(_priceB.text) ?? 0.0;

    final hrsA = widget.hourlyWage > 0 ? (pA / widget.hourlyWage) : 0.0;
    final hrsB = widget.hourlyWage > 0 ? (pB / widget.hourlyWage) : 0.0;

    // Utility Value Score = (Rating * 20) / Price
    final valueScoreA = pA > 0 ? ((_ratingA * 20) / pA) * 100 : 0.0;
    final valueScoreB = pB > 0 ? ((_ratingB * 20) / pB) * 100 : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Impulse Purchase Showdown',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          const SizedBox(height: 4),
          const Text(
            'Torn between two items? Compare their true value score before spending.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item A
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ITEM A',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameA,
                          decoration: const InputDecoration(
                            labelText: 'Item Name',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _priceA,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            labelText: 'Price (\$) ',
                            border: OutlineInputBorder(),
                            prefixText: '\$ ',
                            isDense: true,
                          ),
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Long-term Need (${_ratingA.toInt()}/5):',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                        Slider(
                          value: _ratingA,
                          min: 1,
                          max: 5,
                          divisions: 4,
                          activeColor: Colors.teal,
                          onChanged: (val) => setState(() => _ratingA = val),
                        ),
                        const Divider(),
                        Text(
                          'Hours Cost: ${hrsA.toStringAsFixed(1)} h',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Value Score: ${valueScoreA.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: valueScoreA >= valueScoreB ? Colors.green : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Item B
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ITEM B',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameB,
                          decoration: const InputDecoration(
                            labelText: 'Item Name',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _priceB,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            labelText: 'Price (\$) ',
                            border: OutlineInputBorder(),
                            prefixText: '\$ ',
                            isDense: true,
                          ),
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Long-term Need (${_ratingB.toInt()}/5):',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                        Slider(
                          value: _ratingB,
                          min: 1,
                          max: 5,
                          divisions: 4,
                          activeColor: Colors.teal,
                          onChanged: (val) => setState(() => _ratingB = val),
                        ),
                        const Divider(),
                        Text(
                          'Hours Cost: ${hrsB.toStringAsFixed(1)} h',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Value Score: ${valueScoreB.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: valueScoreB >= valueScoreA ? Colors.green : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Verdict Card
          Card(
            color: Colors.teal.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.stars, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(
                        'Shield Recommendation',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.teal),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    valueScoreA == valueScoreB
                        ? 'Both items carry similar relative value. Consider placing both into the Cooldown Room for 24 hours.'
                        : valueScoreA > valueScoreB
                            ? '"${_nameA.text.isNotEmpty ? _nameA.text : "Item A"}" offers significantly better utility per dollar spent.'
                            : '"${_nameB.text.isNotEmpty ? _nameB.text : "Item B"}" offers significantly better utility per dollar spent.',
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// TAB 4: SAVINGS VAULT & LEVEL PROGRESS
// -------------------------------------------------------------
class VaultScreen extends StatelessWidget {
  final List<EvaluatedItem> items;
  final double totalSaved;
  final double hoursSaved;
  final int userLevel;
  final String levelTitle;
  final double hourlyWage;
  final VoidCallback onOpenWageDialog;

  const VaultScreen({
    super.key,
    required this.items,
    required this.totalSaved,
    required this.hoursSaved,
    required this.userLevel,
    required this.levelTitle,
    required this.hourlyWage,
    required this.onOpenWageDialog,
  });

  @override
  Widget build(BuildContext context) {
    final savedItems = items.where((i) => i.status == 'saved').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Level Card
          Card(
            elevation: 3,
            color: Colors.teal,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LEVEL $userLevel',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            levelTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const Icon(Icons.emoji_events, color: Colors.amber, size: 40),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Total Money Saved', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text(
                            '\$${totalSaved.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(height: 30, width: 1, color: Colors.white70),
                      Column(
                        children: [
                          const Text('Working Hours Saved', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text(
                            '${hoursSaved.toStringAsFixed(1)} hrs',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Hourly wage status bar
          Card(
            elevation: 1,
            child: ListTile(
              leading: const Icon(Icons.monetization_on, color: Colors.teal),
              title: Text('Net Wage: \$${hourlyWage.toStringAsFixed(2)} / hr'),
              subtitle: const Text('Tap to calibrate your true working hour value'),
              trailing: const Icon(Icons.edit, size: 18),
              onTap: onOpenWageDialog,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Resisted Purchases History',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          if (savedItems.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    children: const [
                      Icon(Icons.savings_outlined, color: Colors.grey, size: 40),
                      SizedBox(height: 8),
                      Text(
                        'No resisted items yet.',
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
              itemCount: savedItems.length,
              itemBuilder: (ctx, idx) {
                final item = savedItems[idx];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.check, color: Colors.white, size: 20),
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      'Saved ${item.hoursRequired.toStringAsFixed(1)} hours of life',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Text(
                      '+\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 15,
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
}

// -------------------------------------------------------------
// URGE BUSTER MINDFULNESS MODAL
// -------------------------------------------------------------
class UrgeBusterModal extends StatefulWidget {
  const UrgeBusterModal({super.key});

  @override
  State<UrgeBusterModal> createState() => _UrgeBusterModalState();
}

class _UrgeBusterModalState extends State<UrgeBusterModal>
    with SingleTickerProviderStateMixin {
  int _secondsLeft = 30;
  bool _isRunning = false;

  void _startTimer() {
    setState(() => _isRunning = true);
    _tick();
  }

  void _tick() async {
    while (_secondsLeft > 0 && _isRunning && mounted) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && _isRunning) {
        setState(() {
          _secondsLeft--;
        });
      }
    }
  }

  @override
  void dispose() {
    _isRunning = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Icon(Icons.self_improvement, color: Colors.teal, size: 50),
          const SizedBox(height: 8),
          const Text(
            '60-Second Urge Pause',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Impulse purchasing urges peak in waves. Take deep breaths for 30 seconds and ask yourself if this purchase brings long-term value.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Circle Timer Display
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.teal.shade50,
            child: Text(
              '$_secondsLeft s',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),

          const SizedBox(height: 20),

          if (!_isRunning)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startTimer,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text('Start Breath Pause', style: TextStyle(color: Colors.white)),
              ),
            )
          else if (_secondsLeft == 0)
            Column(
              children: [
                const Text(
                  'Great job! The initial impulse wave has passed.',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text('Return to Evaluator', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
        ],
      ),
    );
  }
}