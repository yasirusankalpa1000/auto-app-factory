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
          primary: Colors.teal,
          secondary: Colors.amber,
          surface: const Color(0xFFF8F9FA),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class ImpulseItem {
  final String id;
  final String name;
  final double price;
  final double hoursRequired;
  final double costPerUse;
  final DateTime lockedAt;
  final int quarantineHours;
  bool isResisted;
  bool isPurchased;

  ImpulseItem({
    required this.id,
    required this.name,
    required this.price,
    required this.hoursRequired,
    required this.costPerUse,
    required this.lockedAt,
    this.quarantineHours = 48,
    this.isResisted = false,
    this.isPurchased = false,
  });

  int get hoursRemaining {
    final unlockTime = lockedAt.add(Duration(hours: quarantineHours));
    final diff = unlockTime.difference(DateTime.now()).inHours;
    return diff < 0 ? 0 : diff;
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;

  // Global App State
  double _hourlyWage = 22.50; // Default hourly net income
  final List<ImpulseItem> _vaultItems = [
    ImpulseItem(
      id: '1',
      name: 'Wireless RGB Gaming Headset',
      price: 129.99,
      hoursRequired: 5.77,
      costPerUse: 4.33,
      lockedAt: DateTime.now().subtract(const Duration(hours: 26)),
      quarantineHours: 48,
    ),
    ImpulseItem(
      id: '2',
      name: 'Designer Espresso Cup Set',
      price: 64.00,
      hoursRequired: 2.84,
      costPerUse: 12.80,
      lockedAt: DateTime.now().subtract(const Duration(hours: 50)),
      quarantineHours: 48,
    ),
  ];

  final List<ImpulseItem> _historyItems = [];

  double get _totalSavedMoney {
    double total = 0;
    for (var item in _vaultItems) {
      if (item.isResisted) total += item.price;
    }
    for (var item in _historyItems) {
      if (item.isResisted) total += item.price;
    }
    return total;
  }

  double get _totalHoursSaved {
    double total = 0;
    for (var item in _vaultItems) {
      if (item.isResisted) total += item.hoursRequired;
    }
    for (var item in _historyItems) {
      if (item.isResisted) total += item.hoursRequired;
    }
    return total;
  }

  void _addItemToVault(ImpulseItem item) {
    setState(() {
      _vaultItems.add(item);
      _selectedIndex = 1; // Switch to vault tab
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${item.name}" locked in 48h Vault! Stay disciplined.'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _markAsResisted(ImpulseItem item) {
    setState(() {
      item.isResisted = true;
      _vaultItems.remove(item);
      _historyItems.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Victory! You saved \$${item.price.toStringAsFixed(2)}!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _markAsBought(ImpulseItem item) {
    setState(() {
      item.isPurchased = true;
      _vaultItems.remove(item);
      _historyItems.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item marked as purchased.'),
        backgroundColor: Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      AnalyzerTab(
        hourlyWage: _hourlyWage,
        onUpdateWage: (newWage) {
          setState(() => _hourlyWage = newWage);
        },
        onAddToVault: _addItemToVault,
      ),
      VaultTab(
        items: _vaultItems,
        onResist: _markAsResisted,
        onBuy: _markAsBought,
      ),
      DashboardTab(
        totalSaved: _totalSavedMoney,
        hoursSaved: _totalHoursSaved,
        historyItems: _historyItems,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Row(
          children: [
            Icon(Icons.shield, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'ImpulseShield',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _selectedIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate, color: Colors.teal),
            label: 'Analyzer',
          ),
          NavigationDestination(
            icon: Icon(Icons.lock_clock_outlined),
            selectedIcon: Icon(Icons.lock_clock, color: Colors.teal),
            label: 'Cooling Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights, color: Colors.teal),
            label: 'Impact Stats',
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Why ImpulseShield?'),
        content: const SingleChildScrollView(
          child: Text(
            'ImpulseShield turns your financial impulse control into a high-reward game.\n\n'
            '1. Calculate how many actual WORK HOURS an item costs.\n'
            '2. Put high-risk items in a 48-Hour Quarantine Vault.\n'
            '3. Check back daily to unlock items or claim your saved wealth!',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
}

// TAB 1: Impulse Analyzer & Calculator
class AnalyzerTab extends StatefulWidget {
  final double hourlyWage;
  final ValueChanged<double> onUpdateWage;
  final ValueChanged<ImpulseItem> onAddToVault;

  const AnalyzerTab({
    super.key,
    required this.hourlyWage,
    required this.onUpdateWage,
    required this.onAddToVault,
  });

  @override
  State<AnalyzerTab> createState() => _AnalyzerTabState();
}

class _AnalyzerTabState extends State<AnalyzerTab> {
  final _itemNameController = TextEditingController();
  final _itemPriceController = TextEditingController();
  final _expectedUsesController = TextEditingController(text: '30');
  final _wageController = TextEditingController();

  double _calculatedHours = 0.0;
  double _calculatedCostPerUse = 0.0;
  bool _hasAnalyzed = false;

  @override
  void initState() {
    super.initState();
    _wageController.text = widget.hourlyWage.toStringAsFixed(2);
  }

  void _calculateImpulse() {
    final price = double.tryParse(_itemPriceController.text) ?? 0.0;
    final wage = double.tryParse(_wageController.text) ?? 1.0;
    final uses = double.tryParse(_expectedUsesController.text) ?? 1.0;

    if (price <= 0 || wage <= 0) return;

    widget.onUpdateWage(wage);

    setState(() {
      _calculatedHours = price / wage;
      _calculatedCostPerUse = price / (uses <= 0 ? 1 : uses);
      _hasAnalyzed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hourly Rate Config Card
          Card(
            color: Colors.teal.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Step 1: Your Net Hourly Income',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.teal),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _wageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Net Pay Per Hour (\$)Text',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: (_) => _calculateImpulse(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Purchase Analyzer Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Step 2: Prospective Purchase',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _itemNameController,
                    decoration: const InputDecoration(
                      labelText: 'Item Name (e.g., Sneakers, Drone)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.shopping_bag),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _itemPriceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price (\$)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _expectedUsesController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Expected Uses',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.repeat),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    onPressed: _calculateImpulse,
                    icon: const Icon(Icons.search),
                    label: const Text(
                      'ANALYZE REAL VALUE',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Analysis Output
          if (_hasAnalyzed) ...[
            Card(
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.amber),
                        SizedBox(width: 8),
                        Text(
                          'Reality Check Breakdown',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: Column(
                            children: [
                              const Text(
                                'Labor Sacrificed',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              FittedBox(
                                child: Text(
                                  '${_calculatedHours.toStringAsFixed(1)} hrs',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                              const Text(
                                'of your work life',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                        Flexible(
                          child: Column(
                            children: [
                              const Text(
                                'Cost Per Usage',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              FittedBox(
                                child: Text(
                                  '\$${_calculatedCostPerUse.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                              const Text(
                                'per single use',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            final name = _itemNameController.text.isEmpty
                                ? 'Impulse Purchase'
                                : _itemNameController.text;
                            final price =
                                double.tryParse(_itemPriceController.text) ??
                                    0.0;
                            if (price <= 0) return;

                            final newItem = ImpulseItem(
                              id: DateTime.now().toString(),
                              name: name,
                              price: price,
                              hoursRequired: _calculatedHours,
                              costPerUse: _calculatedCostPerUse,
                              lockedAt: DateTime.now(),
                            );
                            widget.onAddToVault(newItem);
                          },
                          icon: const Icon(Icons.lock, color: Colors.teal),
                          label: const Text('Lock in 48h Vault'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// TAB 2: Cooling-Off Vault
class VaultTab extends StatelessWidget {
  final List<ImpulseItem> items;
  final ValueChanged<ImpulseItem> onResist;
  final ValueChanged<ImpulseItem> onBuy;

  const VaultTab({
    super.key,
    required this.items,
    required this.onResist,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 72, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text(
                'Your Vault is Empty!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'When you feel an urge to impulse-buy online, test it in the Analyzer and send it here to cool off.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isUnlocked = item.hoursRemaining <= 0;

        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
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
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.schedule, size: 16),
                      label: Text(
                        isUnlocked
                            ? 'Quarantine Complete'
                            : '${item.hoursRemaining}h remaining',
                        style: TextStyle(
                          fontSize: 12,
                          color: isUnlocked ? Colors.green : Colors.amber.shade900,
                        ),
                      ),
                      backgroundColor:
                          isUnlocked ? Colors.green.shade50 : Colors.amber.shade50,
                      padding: EdgeInsets.zero,
                    ),
                    Chip(
                      avatar: const Icon(Icons.work_outline, size: 16),
                      label: Text(
                        '${item.hoursRequired.toStringAsFixed(1)} Work Hrs',
                        style: const TextStyle(fontSize: 12),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                        ),
                        onPressed: () => onResist(item),
                        icon: const Icon(Icons.check_circle_outline, size: 18),
                        label: const FittedBox(
                          child: Text('I Resisted (Save \$)'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                        ),
                        onPressed: () => onBuy(item),
                        icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                        label: const FittedBox(
                          child: Text('Still Bought'),
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

// TAB 3: Impact Stats & Financial Ledger
class DashboardTab extends StatelessWidget {
  final double totalSaved;
  final double hoursSaved;
  final List<ImpulseItem> historyItems;

  const DashboardTab({
    super.key,
    required this.totalSaved,
    required this.hoursSaved,
    required this.historyItems,
  });

  @style
  Widget build(BuildContext context) {
    final resistedCount = historyItems.where((i) => i.isResisted).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner Total Savings
          Card(
            color: Colors.teal,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    'TOTAL MONEY PRESERVED',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    child: Text(
                      '\$${totalSaved.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Saved ${hoursSaved.toStringAsFixed(1)} hours of your life!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Quick Impact Metrics
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.shield_outlined,
                            color: Colors.teal, size: 28),
                        const SizedBox(height: 8),
                        Text(
                          '$resistedCount',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Impulses Defeated',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.stars, color: Colors.amber, size: 28),
                        const SizedBox(height: 8),
                        Text(
                          resistedCount > 5 ? 'Master' : 'Novice',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Saver Status',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          const Text(
            'Decision Log History',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          if (historyItems.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No history recorded yet. Resisting items in the Vault will log them here.',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: historyItems.length,
              itemBuilder: (context, idx) {
                final item = historyItems[idx];
                return Card(
                  child: ListTile(
                    leading: Icon(
                      item.isResisted ? Icons.savings : Icons.shopping_bag,
                      color: item.isResisted ? Colors.green : Colors.grey,
                    ),
                    title: Text(
                      item.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      item.isResisted
                          ? 'Resisted & Saved \$${item.price.toStringAsFixed(2)}'
                          : 'Purchased for \$${item.price.toStringAsFixed(2)}',
                    ),
                    trailing: Text(
                      '${item.hoursRequired.toStringAsFixed(1)}h',
                      style: const TextStyle(fontWeight: FontWeight.bold),
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