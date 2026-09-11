import 'package:flutter/material.dart';

void main() {
  runApp(const ValueVaultApp());
}

class TrackedItem {
  String id;
  String name;
  double cost;
  int uses;
  int targetUses;
  String category;

  TrackedItem({
    required this.id,
    required this.name,
    required this.cost,
    required this.uses,
    required this.targetUses,
    required this.category,
  });

  double get costPerUse => uses > 0 ? cost / uses : cost;
  double get progress => (uses / targetUses).clamp(0.0, 1.0);
}

class ImpulseLog {
  String id;
  String title;
  double price;
  double hoursNeeded;
  bool resisted;
  DateTime date;

  ImpulseLog({
    required this.id,
    required this.title,
    required this.price,
    required this.hoursNeeded,
    required this.resisted,
    required this.date,
  });
}

class ValueVaultApp extends StatelessWidget {
  const ValueVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ValueVault',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  double hourlyWage = 25.0;

  final List<TrackedItem> _items = [
    TrackedItem(id: '1', name: 'Work Laptop', cost: 1200.0, uses: 240, targetUses: 500, category: 'Tech'),
    TrackedItem(id: '2', name: 'Running Shoes', cost: 130.0, uses: 52, targetUses: 100, category: 'Apparel'),
    TrackedItem(id: '3', name: 'Espresso Machine', cost: 350.0, uses: 175, targetUses: 300, category: 'Home'),
    TrackedItem(id: '4', name: 'Noise Headphones', cost: 220.0, uses: 88, targetUses: 200, category: 'Tech'),
    TrackedItem(id: '5', name: 'Adjustable Dumbbells', cost: 180.0, uses: 36, targetUses: 120, category: 'Fitness'),
  ];

  final List<ImpulseLog> _impulseLogs = [
    ImpulseLog(id: '1', title: 'Designer Sunglasses', price: 160.0, hoursNeeded: 6.4, resisted: true, date: DateTime.now().subtract(const Duration(days: 1))),
    ImpulseLog(id: '2', title: 'Smart Coffee Mug', price: 85.0, hoursNeeded: 3.4, resisted: true, date: DateTime.now().subtract(const Duration(days: 3))),
  ];

  double get totalAvoidedSpend {
    return _impulseLogs.where((log) => log.resisted).fold(0.0, (sum, item) => sum + item.price);
  }

  void _incrementUse(TrackedItem item) {
    setState(() {
      item.uses += 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged use for ${item.name}! Cost per use is now \$${item.costPerUse.toStringAsFixed(2)}'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _addNewItem(String name, double cost, int targetUses, String category) {
    setState(() {
      _items.add(TrackedItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        cost: cost,
        uses: 1,
        targetUses: targetUses,
        category: category,
      ));
    });
  }

  void _addImpulseLog(String title, double price, bool resisted) {
    final hours = hourlyWage > 0 ? price / hourlyWage : 0.0;
    setState(() {
      _impulseLogs.insert(
        0,
        ImpulseLog(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          price: price,
          hoursNeeded: hours,
          resisted: resisted,
          date: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildDashboardTab(),
      _buildImpulseTamerTab(),
      _buildItemVaultTab(),
      _buildSmartCalculatorsTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ValueVault', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.teal,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () => _showWageSettingsDialog(),
          )
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Impulse Tamer'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Item Vault'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Calculators'),
        ],
      ),
    );
  }

  // DASHBOARD TAB
  Widget _buildDashboardTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Summary Cards
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.teal,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text('Total Impulse Money Saved', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 6),
                    Text(
                      '\$${totalAvoidedSpend.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildHeaderStat('Active Items', '${_items.length}'),
                        _buildHeaderStat('Hourly Rate', '\$${hourlyWage.toStringAsFixed(0)}/hr'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text('Quick Log Today\'s Use', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 6),
            const Text('Tap "+1 Use" whenever you use an item to lower its Cost-Per-Use!', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.teal.shade50,
                          child: Icon(_getCategoryIcon(item.category), color: Colors.teal),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text(
                                '\$${item.costPerUse.toStringAsFixed(2)} / use (${item.uses} total uses)',
                                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 6),
                              LinearProgressIndicator(
                                value: item.progress,
                                backgroundColor: Colors.grey.shade200,
                                color: Colors.teal,
                                minHeight: 6,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => _incrementUse(item),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('+1 Use'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
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

  Widget _buildHeaderStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  // IMPULSE TAMER TAB
  Widget _buildImpulseTamerTab() {
    final titleController = TextEditingController();
    final priceController = TextEditingController();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.amber, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('The 24-Hour Cooling Rule', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text('Thinking of buying something non-essential? Convert price into work hours and wait 24h before deciding.', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Test an Impulse Buy', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Item Name (e.g. Wireless Speaker)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Price (\$) = e.g. 75.00',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final price = double.tryParse(priceController.text) ?? 0.0;
                              final name = titleController.text.trim();
                              if (name.isNotEmpty && price > 0) {
                                _addImpulseLog(name, price, true);
                                titleController.clear();
                                priceController.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Great job resisting! Added \$${price.toStringAsFixed(2)} to saved pot.')),
                                );
                              }
                            },
                            icon: const Icon(Icons.check_circle, color: Colors.white),
                            label: const Text('I Resisted!'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              final price = double.tryParse(priceController.text) ?? 0.0;
                              final name = titleController.text.trim();
                              if (name.isNotEmpty && price > 0) {
                                _addImpulseLog(name, price, false);
                                titleController.clear();
                                priceController.clear();
                              }
                            },
                            icon: const Icon(Icons.shopping_cart),
                            label: const Text('I Bought It'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text('Impulse Decision History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _impulseLogs.length,
              itemBuilder: (context, index) {
                final log = _impulseLogs[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: log.resisted ? Colors.green.shade100 : Colors.red.shade100,
                      child: Icon(
                        log.resisted ? Icons.thumb_up : Icons.shopping_bag,
                        color: log.resisted ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(log.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Costs ${log.hoursNeeded.toStringAsFixed(1)} hrs of work (Wage: \$${hourlyWage.toStringAsFixed(0)}/hr)'),
                    trailing: Text(
                      '${log.resisted ? "+" : ""}\$${log.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: log.resisted ? Colors.green : Colors.red,
                        fontSize: 15,
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

  // ITEM VAULT TAB
  Widget _buildItemVaultTab() {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tracked Belongings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () => _showAddItemDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Item'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
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
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.teal.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item.category,
                                style: const TextStyle(color: Colors.teal, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildVaultDetail('Initial Cost', '\$${item.cost.toStringAsFixed(2)}'),
                            _buildVaultDetail('Uses', '${item.uses} / ${item.targetUses}'),
                            _buildVaultDetail('Cost / Use', '\$${item.costPerUse.toStringAsFixed(2)}'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: item.progress,
                          backgroundColor: Colors.grey.shade200,
                          color: item.progress >= 1.0 ? Colors.green : Colors.teal,
                          minHeight: 8,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.progress >= 1.0 ? 'Goal Reached! Excellent value!' : 'Target: ${item.targetUses} uses',
                              style: TextStyle(fontSize: 11, color: item.progress >= 1.0 ? Colors.green : Colors.grey),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                              onPressed: () {
                                setState(() {
                                  _items.removeAt(index);
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaultDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // CALCULATORS TAB
  Widget _buildSmartCalculatorsTab() {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              labelColor: Colors.teal,
              indicatorColor: Colors.teal,
              tabs: [
                Tab(text: 'Bulk Price Comparer'),
                Tab(text: 'Subscription ROI'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildUnitComparerTool(),
                  _buildSubscriptionRoiTool(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitComparerTool() {
    final priceAController = TextEditingController(text: '8.50');
    final qtyAController = TextEditingController(text: '500');
    final priceBController = TextEditingController(text: '14.00');
    final qtyBController = TextEditingController(text: '900');

    double unitCostA = 0.0;
    double unitCostB = 0.0;
    String resultMessage = '';

    return StatefulBuilder(
      builder: (context, setCalcState) {
        void calculateComparison() {
          final pA = double.tryParse(priceAController.text) ?? 0.0;
          final qA = double.tryParse(qtyAController.text) ?? 1.0;
          final pB = double.tryParse(priceBController.text) ?? 0.0;
          final qB = double.tryParse(qtyBController.text) ?? 1.0;

          unitCostA = qA > 0 ? (pA / qA) : 0.0;
          unitCostB = qB > 0 ? (pB / qB) : 0.0;

          if (unitCostA < unitCostB) {
            final diff = (((unitCostB - unitCostA) / unitCostB) * 100).toStringAsFixed(1);
            resultMessage = 'Option A is $diff% CHEAPER per unit!';
          } else if (unitCostB < unitCostA) {
            final diff = (((unitCostA - unitCostB) / unitCostA) * 100).toStringAsFixed(1);
            resultMessage = 'Option B is $diff% CHEAPER per unit!';
          } else {
            resultMessage = 'Both options offer identical unit value.';
          }
        }

        calculateComparison();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Smart Grocery & Bulk Value Comparer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 6),
              const Text('Compare two different package sizes to find the real deal.', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            const Text('Option A', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                            const SizedBox(height: 8),
                            TextField(
                              controller: priceAController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setCalcState(() => calculateComparison()),
                              decoration: const InputDecoration(labelText: 'Price (\$)'),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: qtyAController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setCalcState(() => calculateComparison()),
                              decoration: const InputDecoration(labelText: 'Quantity (g/ml/pcs)'),
                            ),
                            const SizedBox(height: 12),
                            Text('\$${unitCostA.toStringAsFixed(4)} / unit', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            const Text('Option B', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                            const SizedBox(height: 8),
                            TextField(
                              controller: priceBController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setCalcState(() => calculateComparison()),
                              decoration: const InputDecoration(labelText: 'Price (\$)'),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: qtyBController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setCalcState(() => calculateComparison()),
                              decoration: const InputDecoration(labelText: 'Quantity (g/ml/pcs)'),
                            ),
                            const SizedBox(height: 12),
                            Text('\$${unitCostB.toStringAsFixed(4)} / unit', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.teal.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      resultMessage,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.teal),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubscriptionRoiTool() {
    final subCostController = TextEditingController(text: '15.99');
    final monthlyUsesController = TextEditingController(text: '4');

    return StatefulBuilder(
      builder: (context, setSubState) {
        final cost = double.tryParse(subCostController.text) ?? 0.0;
        final uses = int.tryParse(monthlyUsesController.text) ?? 1;
        final costPerWatch = uses > 0 ? (cost / uses) : cost;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Subscription ROI Evaluator', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 6),
              const Text('Determine if streaming or gym subscriptions are worth keeping.', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: subCostController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setSubState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'Monthly Subscription Cost (\$) = e.g. 15.99',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: monthlyUsesController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setSubState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'Times Used Per Month = e.g. 4',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Card(
                color: costPerWatch > 5.0 ? Colors.orange.shade50 : Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Cost Per Session: \$${costPerWatch.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: costPerWatch > 5.0 ? Colors.orange.shade900 : Colors.green.shade900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        costPerWatch > 5.0
                            ? 'High Cost Per Session! Consider pausing or cancelling this subscription.'
                            : 'Great Value! You are using this subscription enough to justify the monthly cost.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // DIALOGS
  void _showWageSettingsDialog() {
    final wageController = TextEditingController(text: hourlyWage.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hourly Wage Setting'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your net hourly wage to convert impulse prices into working hours.'),
            const SizedBox(height: 12),
            TextField(
              controller: wageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Hourly Wage (\$)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final newWage = double.tryParse(wageController.text) ?? 25.0;
              setState(() => hourlyWage = newWage);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog() {
    final nameController = TextEditingController();
    final costController = TextEditingController();
    final targetController = TextEditingController(text: '100');
    String selectedCategory = 'Tech';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Tracked Belonging'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Item Name (e.g. Winter Jacket)'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: costController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Purchase Cost (\$)'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: targetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Target Uses Goal'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: ['Tech', 'Apparel', 'Home', 'Fitness', 'Other']
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setDialogState(() => selectedCategory = val);
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final cost = double.tryParse(costController.text) ?? 0.0;
                final target = int.tryParse(targetController.text) ?? 100;
                if (name.isNotEmpty && cost > 0) {
                  _addNewItem(name, cost, target, selectedCategory);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
              child: const Text('Track Item'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Tech':
        return Icons.devices;
      case 'Apparel':
        return Icons.checkroom;
      case 'Home':
        return Icons.home;
      case 'Fitness':
        return Icons.fitness_center;
      default:
        return Icons.inventory_2;
    }
  }
}