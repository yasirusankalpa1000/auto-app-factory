import 'dart:math';
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
        scaffoldBackgroundColor: const Color(0xFFA6F5F0),
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
  final DateTime dateAdded;
  final int coolingDays;
  String status; // 'cooling', 'saved', 'bought'
  final double lifeHours;

  ImpulseItem({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.dateAdded,
    required this.coolingDays,
    this.status = 'cooling',
    required this.lifeHours,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  double _hourlyWage = 22.50;

  // Sample initial data for instant user engagement
  final List<ImpulseItem> _items = [
    ImpulseItem(
      id: '1',
      title: 'Noise Canceling Headphones',
      price: 199.99,
      category: 'Electronics',
      dateAdded: DateTime.now().subtract(const Duration(days: 2)),
      coolingDays: 7,
      status: 'cooling',
      lifeHours: 8.88,
    ),
    ImpulseItem(
      id: '2',
      title: 'Designer Sneakers',
      price: 145.00,
      category: 'Apparel',
      dateAdded: DateTime.now().subtract(const Duration(days: 5)),
      coolingDays: 5,
      status: 'saved',
      lifeHours: 6.44,
    ),
    ImpulseItem(
      id: '3',
      title: 'Smart Coffee Mug',
      price: 129.00,
      category: 'Gadgets',
      dateAdded: DateTime.now().subtract(const Duration(days: 1)),
      coolingDays: 3,
      status: 'cooling',
      lifeHours: 5.73,
    ),
  ];

  void _updateHourlyWage(double newWage) {
    setState(() {
      _hourlyWage = newWage;
    });
  }

  void _addItem(ImpulseItem item) {
    setState(() {
      _items.insert(0, item);
    });
  }

  void _markItemStatus(String id, String newStatus) {
    setState(() {
      final index = _items.indexWhere((element) => element.id == id);
      if (index != -1) {
        _items[index].status = newStatus;
      }
    });
  }

  void _deleteItem(String id) {
    setState(() {
      _items.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      LifeConverterTab(
        hourlyWage: _hourlyWage,
        onWageChanged: _updateHourlyWage,
        onAddToVault: _addItem,
      ),
      CoolingVaultTab(
        items: _items,
        hourlyWage: _hourlyWage,
        onStatusChange: _markItemStatus,
        onDelete: _deleteItem,
        onAddItem: _addItem,
      ),
      CompoundSimulatorTab(hourlyWage: _hourlyWage),
      StatsImpactTab(items: _items, hourlyWage: _hourlyWage),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
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
            icon: const Icon(Icons.account_balance_wallet),
            tooltip: 'Set Wage Rate',
            onPressed: () => _showWageDialog(context),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Life Cost',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Cooling Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Compound Simulator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Impact Stats',
          ),
        ],
      ),
    );
  }

  void _showWageDialog(BuildContext context) {
    final controller = TextEditingController(text: _hourlyWage.toStringAsFixed(2));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set Net Hourly Wage'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calculate your actual take-home wage per hour (after taxes and commuting costs) for accurate life-hour calculations.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              if (val != null && val > 0) {
                _updateHourlyWage(val);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// TAB 1: LIFE HOUR CONVERTER
class LifeConverterTab extends StatefulWidget {
  final double hourlyWage;
  final Function(double) onWageChanged;
  final Function(ImpulseItem) onAddToVault;

  const LifeConverterTab({
    super.key,
    required this.hourlyWage,
    required this.onWageChanged,
    required this.onAddToVault,
  });

  @override
  State<LifeConverterTab> createState() => _LifeConverterTabState();
}

class _LifeConverterTabState extends State<LifeConverterTab> {
  final _priceController = TextEditingController();
  final _nameController = TextEditingController();
  String _selectedCategory = 'General';
  int _coolingDays = 7;

  final List<String> _categories = [
    'General',
    'Electronics',
    'Apparel',
    'Dining/Snacks',
    'Gaming',
    'Gadgets',
    'Subscriptions',
  ];

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final lifeHours = widget.hourlyWage > 0 ? price / widget.hourlyWage : 0.0;
    final workDays = lifeHours / 8.0;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.teal.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.access_time, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Net Hourly Rate: \$${widget.hourlyWage.toStringAsFixed(2)}/hr',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const Text(
                            'Tap wage icon top-right to adjust.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price-To-Life Converter',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Item / Purchase Name',
                        hintText: 'e.g., Designer Jacket',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.shopping_bag),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (val) => setState(() {}),
                      decoration: const InputDecoration(
                        labelText: 'Item Price',
                        prefixText: '\$ ',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Category:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _categories.map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: Colors.teal.shade100,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedCategory = cat);
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Live Result Card
            Card(
              elevation: 4,
              color: price > 0 ? Colors.amber.shade50 : Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: price > 0 ? Colors.amber.shade700 : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'REAL LIFE EFFORT COST',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      child: Text(
                        '${lifeHours.toStringAsFixed(1)} LIFE HOURS',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Equivalent to approx ${workDays.toStringAsFixed(1)} full 8-hr work days!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text(
                      'Cooling-Off Period:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Slider(
                          value: _coolingDays.toDouble(),
                          min: 1,
                          max: 30,
                          divisions: 29,
                          activeColor: Colors.teal,
                          label: '$_coolingDays days',
                          onChanged: (val) {
                            setState(() => _coolingDays = val.toInt());
                          },
                        ),
                        Text(
                          '$_coolingDays Days',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: price <= 0
                          ? null
                          : () {
                              final name = _nameController.text.trim().isEmpty
                                  ? 'Impulse Purchase'
                                  : _nameController.text.trim();
                              final newItem = ImpulseItem(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                title: name,
                                price: price,
                                category: _selectedCategory,
                                dateAdded: DateTime.now(),
                                coolingDays: _coolingDays,
                                status: 'cooling',
                                lifeHours: lifeHours,
                              );
                              widget.onAddToVault(newItem);
                              _priceController.clear();
                              _nameController.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Added to Cooling Vault! Take time to evaluate.'),
                                  backgroundColor: Colors.teal,
                                ),
                              );
                            },
                      icon: const Icon(Icons.shield),
                      label: const Text(
                        'Lock In Cooling Vault',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Quick Presets
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Reality Check Presets',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _presetChip('Daily Latte (\$6.50)', 6.50),
                        _presetChip('Takeout Dinner (\$35)', 35.00),
                        _presetChip('Sneakers (\$140)', 140.00),
                        _presetChip('New Phone (\$999)', 999.00),
                        _presetChip('Streaming Sub (\$\$15)', 15.00),
                      ],
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

  Widget _presetChip(String label, double priceVal) {
    return ActionChip(
      avatar: const Icon(Icons.flash_on, size: 16, color: Colors.amber),
      label: Text(label),
      onPressed: () {
        setState(() {
          _priceController.text = priceVal.toStringAsFixed(2);
        });
      },
    );
  }
}

// TAB 2: COOLING VAULT
class CoolingVaultTab extends StatelessWidget {
  final List<ImpulseItem> items;
  final double hourlyWage;
  final Function(String, String) onStatusChange;
  final Function(String) onDelete;
  final Function(ImpulseItem) onAddItem;

  const CoolingVaultTab({
    super.key,
    required this.items,
    required this.hourlyWage,
    required this.onStatusChange,
    required this.onDelete,
    required this.onAddItem,
  });

  int _getDaysRemaining(ImpulseItem item) {
    final expiry = item.dateAdded.add(Duration(days: item.coolingDays));
    final diff = expiry.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  @override
  Widget build(BuildContext context) {
    final activeItems = items.where((i) => i.status == 'cooling').toList();
    final historyItems = items.where((i) => i.status != 'cooling').toList();

    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const Material(
              color: Colors.white,
              child: TabBar(
                labelColor: Colors.teal,
                indicatorColor: Colors.teal,
                tabs: [
                  Tab(icon: Icon(Icons.hourglass_top), text: 'Active Cooling'),
                  Tab(icon: Icon(Icons.history), text: 'Decisions History'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildList(context, activeItems, isHistory: false),
                  _buildList(context, historyItems, isHistory: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<ImpulseItem> list, {required bool isHistory}) {
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isHistory ? Icons.history_toggle_off : Icons.verified_user_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                isHistory
                    ? 'No decision history yet.'
                    : 'Your Cooling Vault is clear!\nNo pending impulse threats.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        final daysLeft = _getDaysRemaining(item);

        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(item.category).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.category,
                        style: TextStyle(
                          color: _getCategoryColor(item.category),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
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
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${item.lifeHours.toStringAsFixed(1)} Life-Hrs',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (!isHistory) ...[
                  Row(
                    children: [
                      Icon(
                        daysLeft == 0 ? Icons.check_circle_outline : Icons.timer,
                        size: 18,
                        color: daysLeft == 0 ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          daysLeft == 0
                              ? 'Cooling period completed! Make your final choice.'
                              : '$daysLeft day(s) remaining in mandatory pause',
                          style: TextStyle(
                            fontSize: 13,
                            color: daysLeft == 0 ? Colors.green.shade700 : Colors.orange.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => onStatusChange(item.id, 'saved'),
                        icon: const Icon(Icons.savings, size: 18),
                        label: const Text('Resisted & Saved!'),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        onPressed: () => onStatusChange(item.id, 'bought'),
                        icon: const Icon(Icons.shopping_cart, size: 18),
                        label: const Text('Bought It'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.grey),
                        onPressed: () => onDelete(item.id),
                      ),
                    ],
                  ),
                ] else ...[
                  Row(
                    children: [
                      Icon(
                        item.status == 'saved' ? Icons.check_circle : Icons.shopping_bag,
                        color: item.status == 'saved' ? Colors.green : Colors.red,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.status == 'saved'
                            ? 'RESISTED: Saved \$${item.price.toStringAsFixed(2)} (${item.lifeHours.toStringAsFixed(1)} hrs life)'
                            : 'PURCHASED: Cost ${item.lifeHours.toStringAsFixed(1)} life-hours',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: item.status == 'saved' ? Colors.green.shade800 : Colors.red.shade800,
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
    );
  }

  Color _getCategoryColor(String cat) {
    switch (cat) {
      case 'Electronics':
        return Colors.blue;
      case 'Apparel':
        return Colors.purple;
      case 'Dining/Snacks':
        return Colors.orange;
      case 'Gaming':
        return Colors.indigo;
      case 'Gadgets':
        return Colors.teal;
      default:
        return Colors.blueGrey;
    }
  }
}

// TAB 3: COMPOUND SAVINGS SIMULATOR
class CompoundSimulatorTab extends StatefulWidget {
  final double hourlyWage;

  const CompoundSimulatorTab({super.key, required this.hourlyWage});

  @override
  State<CompoundSimulatorTab> createState() => _CompoundSimulatorTabState();
}

class _CompoundSimulatorTabState extends State<CompoundSimulatorTab> {
  double _dailySavings = 10.0;
  double _years = 10.0;
  double _annualReturn = 8.0;

  double _calculateTotalSavings(double daily, double yrs) {
    return daily * 365.25 * yrs;
  }

  double _calculateCompoundValue(double daily, double yrs, double ratePct) {
    final months = yrs * 12;
    final monthlyRate = ratePct / 100 / 12;
    final monthlyDeposit = daily * (365.25 / 12);

    if (monthlyRate == 0) return monthlyDeposit * months;

    // Compound formula for periodic deposits: PMT * (((1 + r)^n - 1) / r)
    final fv = monthlyDeposit * ((pow(1 + monthlyRate, months) - 1) / monthlyRate);
    return fv;
  }

  @override
  Widget build(BuildContext context) {
    final rawSaved = _calculateTotalSavings(_dailySavings, _years);
    final totalCompounded = _calculateCompoundValue(_dailySavings, _years, _annualReturn);
    final interestEarned = totalCompounded - rawSaved;
    final lifeHoursSavedPerYear = (_dailySavings * 365.25) / (widget.hourlyWage > 0 ? widget.hourlyWage : 1);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              color: Colors.teal.shade900,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'MICRO-SAVINGS COMPOUND ENGINE',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FittedBox(
                      child: Text(
                        '\$${totalCompounded.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Potential Net Worth in ${_years.toInt()} Years',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white70),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statItem('Direct Saved', '\$${rawSaved.toStringAsFixed(0)}'),
                        _statItem('Compound Gain', '+\$${interestEarned.toStringAsFixed(0)}'),
                        _statItem('Life Hrs Saved/Yr', '${lifeHoursSavedPerYear.toStringAsFixed(0)}h'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Micro-Amount Resisted: \$${_dailySavings.toStringAsFixed(1)}/day',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const Text(
                      'Small daily wins like skipping a \$10 impulse snack or drink.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Slider(
                      value: _dailySavings,
                      min: 1.0,
                      max: 50.0,
                      divisions: 49,
                      activeColor: Colors.teal,
                      onChanged: (val) => setState(() => _dailySavings = val),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Time Horizon: ${_years.toInt()} Years',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Slider(
                      value: _years,
                      min: 1.0,
                      max: 30.0,
                      divisions: 29,
                      activeColor: Colors.teal,
                      onChanged: (val) => setState(() => _years = val),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Estimated Annual Investment Return: ${_annualReturn.toStringAsFixed(1)}%',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Slider(
                      value: _annualReturn,
                      min: 1.0,
                      max: 15.0,
                      divisions: 28,
                      activeColor: Colors.teal,
                      onChanged: (val) => setState(() => _annualReturn = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: const [
                    Icon(Icons.lightbulb, color: Colors.blue),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Perspective Shift: Redirecting just \$10 a day from impulsive buys into an index fund can build a \$50,000+ nest egg over a decade!',
                        style: TextStyle(fontSize: 13, color: Colors.black87),
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

  Widget _statItem(String label, String val) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}

// TAB 4: STATS & IMPACT DASHBOARD
class StatsImpactTab extends StatelessWidget {
  final List<ImpulseItem> items;
  final double hourlyWage;

  const StatsImpactTab({
    super.key,
    required this.items,
    required this.hourlyWage,
  });

  @override
  Widget build(BuildContext context) {
    final savedItems = items.where((i) => i.status == 'saved').toList();
    final boughtItems = items.where((i) => i.status == 'bought').toList();

    final totalSavedMoney = savedItems.fold<double>(0.0, (sum, i) => sum + i.price);
    final totalSavedHours = hourlyWage > 0 ? totalSavedMoney / hourlyWage : 0.0;

    final totalSpentMoney = boughtItems.fold<double>(0.0, (sum, i) => sum + i.price);

    final totalEvaluated = items.length;
    final saveRate = totalEvaluated > 0 ? (savedItems.length / totalEvaluated * 100) : 0.0;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.teal,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'TOTAL RECLAIMED FREEDOM',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      child: Text(
                        '${totalSavedHours.toStringAsFixed(1)} HOURS',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Saved \$${totalSavedMoney.toStringAsFixed(2)} from impulse buys!',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _metricCard(
                    'Resisted Count',
                    '${savedItems.length} items',
                    Icons.verified_user,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _metricCard(
                    'Willpower Rate',
                    '${saveRate.toStringAsFixed(0)}%',
                    Icons.bolt,
                    Colors.amber.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _metricCard(
                    'Money Saved',
                    '\$${totalSavedMoney.toStringAsFixed(2)}',
                    Icons.savings,
                    Colors.teal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _metricCard(
                    'Money Spent',
                    '\$${totalSpentMoney.toStringAsFixed(2)}',
                    Icons.shopping_cart,
                    Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Impulse Defense Guidelines',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _ruleItem('1. The 24-Hour Rule', 'Wait at least 24 hours for every \$50 of item cost before buying.'),
                    _ruleItem('2. Wage Equivalent', 'Ask yourself: "Would I work X hours straight to get this item?"'),
                    _ruleItem('3. Maintenance Cost', 'Consider non-monetary costs: maintenance, storage space, and attention.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricCard(String title, String val, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              val,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ruleItem(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 2),
          Text(desc, style: const TextStyle(fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }
}