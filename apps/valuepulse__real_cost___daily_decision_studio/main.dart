import 'package:flutter/material.dart';

void main() {
  runApp(const ValuePulseApp());
}

class ValuePulseApp extends StatelessWidget {
  const ValuePulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ValuePulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7F6),
        cardTheme: const CardTheme(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class AssetUseItem {
  final String id;
  final String name;
  final double cost;
  int usageCount;
  final String category;

  AssetUseItem({
    required this.id,
    required this.name,
    required this.cost,
    required this.usageCount,
    required this.category,
  });

  double get costPerUse => usageCount == 0 ? cost : cost / usageCount;
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Global state for user hourly wage
  double _hourlyWage = 20.00;

  // Sample data for Daily Usage Tracker (Drives Daily Retention)
  final List<AssetUseItem> _trackedAssets = [
    AssetUseItem(
      id: '1',
      name: 'Noise Cancelling Headphones',
      cost: 180.00,
      usageCount: 42,
      category: 'Gadgets',
    ),
    AssetUseItem(
      id: '2',
      name: 'Leather Work Shoes',
      cost: 120.00,
      usageCount: 18,
      category: 'Apparel',
    ),
    AssetUseItem(
      id: '3',
      name: 'Espresso Coffee Machine',
      cost: 250.00,
      usageCount: 95,
      category: 'Appliances',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildUsageTrackerTab(),
      _buildWorkTimeCalculatorTab(),
      _buildUnitPriceTab(),
      _buildShrinkflationTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          children: const [
            Icon(Icons.analytics, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'ValuePulse',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            tooltip: 'Wage Settings',
            onPressed: _showWageSettingsDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.touch_app),
            label: 'Per-Use Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Work Cost',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Unit Compare',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_down),
            label: 'Shrinkflation',
          ),
        ],
      ),
    );
  }

  // ==================== TAB 1: DAILY PER-USE LOG (RETENTION DRIVER) ====================
  Widget _buildUsageTrackerTab() {
    double totalSpent = _trackedAssets.fold(0, (sum, item) => sum + item.cost);
    int totalUses = _trackedAssets.fold(0, (sum, item) => sum + item.usageCount);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'Daily ROI & Asset Utility Dashboard',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '\$${totalSpent.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Total Invested',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Container(height: 30, width: 1, color: Colors.white70),
                    Expanded(
                      child: Column(
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '$totalUses Uses',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Logged Uses',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'My Purchase Value Log',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  softWrap: true,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showAddAssetDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Item', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap "Log Use Today" daily to lower your per-use cost and maximize value!',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 12),
          if (_trackedAssets.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No items tracked yet. Add one to start logging!'),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _trackedAssets.length,
              itemBuilder: (context, index) {
                final item = _trackedAssets[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
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
                                  fontSize: 15,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.teal.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item.category,
                                style: TextStyle(
                                  color: Colors.teal.shade800,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  _trackedAssets.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 12,
                          runSpacing: 6,
                          children: [
                            Text(
                              'Original Price: \$${item.cost.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              'Times Used: ${item.usageCount}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Current Real Cost / Use',
                                  style: TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '\$${item.costPerUse.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: item.costPerUse < 5.00 ? Colors.green : Colors.teal.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  item.usageCount++;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal.shade700,
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.plus_one, size: 16),
                              label: const Text('Log Use Today', style: TextStyle(fontSize: 12)),
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
    );
  }

  // ==================== TAB 2: WORK-HOUR COST CONVERTER ====================
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  double _calculatedWorkHours = 0.0;
  String _lastCheckedItem = '';
  double _lastCheckedPrice = 0.0;

  Widget _buildWorkTimeCalculatorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.teal.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Colors.teal),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your Wage Setting: \$${_hourlyWage.toStringAsFixed(2)} / hour. (Tap gear icon in top bar to edit)',
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Work-Hour Life Cost Reality Check',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Convert purchase prices into actual labor hours required to pay for them.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _itemNameController,
            decoration: const InputDecoration(
              labelText: 'Item / Expense Name (e.g., Sneakers, Restaurant Meal)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _itemPriceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Price (\$) = ',
              prefixText: '\$ ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                final price = double.tryParse(_itemPriceController.text) ?? 0.0;
                if (price > 0 && _hourlyWage > 0) {
                  setState(() {
                    _calculatedWorkHours = price / _hourlyWage;
                    _lastCheckedItem = _itemNameController.text.trim();
                    _lastCheckedPrice = price;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.calculate),
              label: const Text('Calculate Life Hours Cost'),
            ),
          ),
          const SizedBox(height: 20),
          if (_calculatedWorkHours > 0) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Column(
                children: [
                  Text(
                    _lastCheckedItem.isEmpty ? 'This Item Costs:' : '"$_lastCheckedItem" Costs:',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${_calculatedWorkHours.toStringAsFixed(1)} Hours of Work',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '(${(_calculatedWorkHours * 60).toStringAsFixed(0)} total working minutes)',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAxisAlignment.center,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.schedule, size: 16),
                        label: Text(
                          _calculatedWorkHours >= 8
                              ? '${(_calculatedWorkHours / 8).toStringAsFixed(1)} Work Days'
                              : '${(_calculatedWorkHours).toStringAsFixed(1)} Work Hours',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                      Chip(
                        avatar: const Icon(Icons.monetization_on, size: 16),
                        label: Text(
                          'Price Tag: \$${_lastCheckedPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _calculatedWorkHours > 16
                        ? '⚠️ Reality Check: You need over 2 full working days to pay for this purchase.'
                        : '💡 Tip: Ask yourself if this item brings as much value as ${_calculatedWorkHours.toStringAsFixed(1)} hours of effort!',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: _calculatedWorkHours > 16 ? Colors.red.shade700 : Colors.teal.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==================== TAB 3: UNIT PRICE COMPARISON MATRIX ====================
  final TextEditingController _p1PriceController = TextEditingController();
  final TextEditingController _p1QtyController = TextEditingController();
  final TextEditingController _p2PriceController = TextEditingController();
  final TextEditingController _p2QtyController = TextEditingController();

  String _unitCompareResult = '';
  double _p1UnitPrice = 0;
  double _p2UnitPrice = 0;

  Widget _buildUnitPriceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Store Unit Price Comparator',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Never be tricked by bulk sizes or packaging games. Find the true cheaper option.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Option A
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Option A (e.g. Small)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _p1PriceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Price (\$) = ',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _p1QtyController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Weight/Units',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Option B
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Option B (e.g. Bulk)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _p2PriceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Price (\$) = ',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _p2QtyController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Weight/Units',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                final p1Price = double.tryParse(_p1PriceController.text) ?? 0;
                final p1Qty = double.tryParse(_p1QtyController.text) ?? 0;
                final p2Price = double.tryParse(_p2PriceController.text) ?? 0;
                final p2Qty = double.tryParse(_p2QtyController.text) ?? 0;

                if (p1Price > 0 && p1Qty > 0 && p2Price > 0 && p2Qty > 0) {
                  final u1 = p1Price / p1Qty;
                  final u2 = p2Price / p2Qty;

                  setState(() {
                    _p1UnitPrice = u1;
                    _p2UnitPrice = u2;
                    if (u1 < u2) {
                      final savings = ((u2 - u1) / u2) * 100;
                      _unitCompareResult = 'Option A is CHEAPER by ${savings.toStringAsFixed(1)}% per unit!';
                    } else if (u2 < u1) {
                      final savings = ((u1 - u2) / u1) * 100;
                      _unitCompareResult = 'Option B is CHEAPER by ${savings.toStringAsFixed(1)}% per unit!';
                    } else {
                      _unitCompareResult = 'Both options cost EXACTLY the same per unit!';
                    }
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.scale),
              label: const Text('Compare Unit Value'),
            ),
          ),
          const SizedBox(height: 16),
          if (_unitCompareResult.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Column(
                children: [
                  Text(
                    _unitCompareResult,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text('Option A Rate', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          Text(
                            '\$${_p1UnitPrice.toStringAsFixed(4)} / unit',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                      Container(height: 25, width: 1, color: Colors.grey.shade300),
                      Column(
                        children: [
                          const Text('Option B Rate', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          Text(
                            '\$${_p2UnitPrice.toStringAsFixed(4)} / unit',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==================== TAB 4: SHRINKFLATION RADAR ====================
  final TextEditingController _oldPriceController = TextEditingController();
  final TextEditingController _oldSizeController = TextEditingController();
  final TextEditingController _newPriceController = TextEditingController();
  final TextEditingController _newSizeController = TextEditingController();

  double _shrinkInflationPercentage = 0.0;
  bool _hasShrinkCalculated = false;

  Widget _buildShrinkflationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hidden Shrinkflation Detector',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Did the package size shrink while price stayed the same? Detect true hidden price hikes.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Previous Package', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _oldPriceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Old Price (\$) = ',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _oldSizeController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Old Size (g/ml)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('New Package', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _newPriceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'New Price (\$) = ',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _newSizeController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'New Size (g/ml)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                final oldP = double.tryParse(_oldPriceController.text) ?? 0;
                final oldS = double.tryParse(_oldSizeController.text) ?? 0;
                final newP = double.tryParse(_newPriceController.text) ?? 0;
                final newS = double.tryParse(_newSizeController.text) ?? 0;

                if (oldP > 0 && oldS > 0 && newP > 0 && newS > 0) {
                  final oldUnitPrice = oldP / oldS;
                  final newUnitPrice = newP / newS;
                  final pctChange = ((newUnitPrice - oldUnitPrice) / oldUnitPrice) * 100;

                  setState(() {
                    _shrinkInflationPercentage = pctChange;
                    _hasShrinkCalculated = true;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.radar),
              label: const Text('Detect Hidden Inflation'),
            ),
          ),
          const SizedBox(height: 16),
          if (_hasShrinkCalculated) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _shrinkInflationPercentage > 0 ? Colors.red.shade300 : Colors.green.shade300,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    _shrinkInflationPercentage > 0
                        ? '🚨 Hidden Price Increase Detected!'
                        : '🎉 Value Maintained or Improved!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: _shrinkInflationPercentage > 0 ? Colors.red.shade800 : Colors.green.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${_shrinkInflationPercentage > 0 ? "+" : ""}${_shrinkInflationPercentage.toStringAsFixed(1)}% Real Inflation',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _shrinkInflationPercentage > 0 ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _shrinkInflationPercentage > 0
                        ? 'Even if the shelf price looks similar, shrinking the package size results in paying ${_shrinkInflationPercentage.toStringAsFixed(1)}% more per unit!'
                        : 'This package change gives you equal or better value per unit.',
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==================== DIALOGS & SETTINGS ====================
  void _showWageSettingsDialog() {
    final TextEditingController wageController = TextEditingController(text: _hourlyWage.toStringAsFixed(2));
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Hourly Earnings'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Set your hourly net wage to calculate life-work costs across the app.'),
                const SizedBox(height: 12),
                TextField(
                  controller: wageController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Hourly Wage (\$ / hour)',
                    border: OutlineInputBorder(),
                  ),
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
                final wage = double.tryParse(wageController.text) ?? _hourlyWage;
                if (wage > 0) {
                  setState(() {
                    _hourlyWage = wage;
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAddAssetDialog() {
    final nameController = TextEditingController();
    final costController = TextEditingController();
    String category = 'Gadgets';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Purchase to Value Log'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Item Name (e.g., Jacket, Microwave)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: costController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Total Cost (\$) = ',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: category,
                      items: ['Gadgets', 'Apparel', 'Appliances', 'Subscriptions', 'Other']
                          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => category = val);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
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
                    final name = nameController.text.trim();
                    final cost = double.tryParse(costController.text) ?? 0;
                    if (name.isNotEmpty && cost > 0) {
                      setState(() {
                        _trackedAssets.add(
                          AssetUseItem(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            name: name,
                            cost: cost,
                            usageCount: 1,
                            category: category,
                          ),
                        );
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add Item'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}