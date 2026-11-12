import 'package:flutter/material.dart';
import 'dart:math' as math;

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
      ),
      home: const MainHomeScreen(),
    );
  }
}

class WishlistItem {
  final String id;
  final String name;
  final double price;
  final String category;
  double urgeRating; // 1 to 10
  final DateTime dateAdded;
  bool isSaved;

  WishlistItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.urgeRating,
    required this.dateAdded,
    this.isSaved = false,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  // Global user metrics
  double _hourlyWage = 22.50; // default \$22.50 / hr
  double _totalSavedMoney = 485.00;
  double _totalHoursSaved = 21.5;

  // Active items in vault
  final List<WishlistItem> _coolingVault = [
    WishlistItem(
      id: '1',
      name: 'Wireless Gaming Headphones',
      price: 149.99,
      category: 'Electronics',
      urgeRating: 8.0,
      dateAdded: DateTime.now().subtract(const Duration(days: 4)),
    ),
    WishlistItem(
      id: '2',
      name: 'Designer Leather Jacket',
      price: 280.00,
      category: 'Fashion',
      urgeRating: 5.5,
      dateAdded: DateTime.now().subtract(const Duration(days: 12)),
    ),
    WishlistItem(
      id: '3',
      name: 'Smart Coffee Mug Heater',
      price: 45.00,
      category: 'Gadgets',
      urgeRating: 3.0,
      dateAdded: DateTime.now().subtract(const Duration(days: 18)),
    ),
  ];

  // System permissions state for floating guardian
  bool _overlayPermissionGranted = true;
  bool _notificationPermissionGranted = true;
  bool _floatingWidgetActive = true;

  void _addVaultItem(WishlistItem item) {
    setState(() {
      _coolingVault.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} sent to 30-Day Cooling Vault!'),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _markAsSaved(WishlistItem item) {
    setState(() {
      item.isSaved = true;
      _totalSavedMoney += item.price;
      _totalHoursSaved += (item.price / _hourlyWage);
      _coolingVault.removeWhere((element) => element.id == item.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Congratulations! You saved \$${item.price.toStringAsFixed(2)}!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      EvaluatorTab(
        hourlyWage: _hourlyWage,
        onUpdateWage: (newWage) {
          setState(() {
            _hourlyWage = newWage;
          });
        },
        onAddToVault: _addVaultItem,
      ),
      BattleArenaTab(
        hourlyWage: _hourlyWage,
        coolingVault: _coolingVault,
      ),
      CoolingVaultTab(
        coolingVault: _coolingVault,
        hourlyWage: _hourlyWage,
        onMarkSaved: _markAsSaved,
        onRemoveItem: (id) {
          setState(() {
            _coolingVault.removeWhere((element) => element.id == id);
          });
        },
      ),
      FloatingStudioTab(
        overlayPermission: _overlayPermissionGranted,
        notificationPermission: _notificationPermissionGranted,
        widgetActive: _floatingWidgetActive,
        onToggleOverlay: (val) => setState(() => _overlayPermissionGranted = val),
        onToggleNotification: (val) => setState(() => _notificationPermissionGranted = val),
        onToggleWidget: (val) => setState(() => _floatingWidgetActive = val),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ValuePulse',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Text(
              'Wage: \$${_hourlyWage.toStringAsFixed(2)}/hr • Saved: \$${_totalSavedMoney.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet, color: Colors.white),
            tooltip: 'Life Savings Metrics',
            onPressed: () {
              _showSavingsSummaryModal(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            tooltip: 'Wage Settings',
            onPressed: () {
              _showWageDialog(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Evaluator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Trade-Off',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: 'Cooling Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Floating Guard',
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
        title: const Text('Set Hourly Wage'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your net hourly earnings after tax. This determines your exact life-time cost for any item.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                prefixText: '\$ ',
                labelText: 'Hourly Wage Rate',
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () {
              final parsed = double.tryParse(controller.text);
              if (parsed != null && parsed > 0) {
                setState(() {
                  _hourlyWage = parsed;
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSavingsSummaryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '🛡️ Life Savings Impact',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _metricTile('Total Money Saved', '\$${_totalSavedMoney.toStringAsFixed(2)}', Colors.green),
                  _metricTile('Life Hours Reclaimed', '${_totalHoursSaved.toStringAsFixed(1)} hrs', Colors.teal),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.trending_up, color: Colors.orange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'If invested at 8% annual return, your saved total will grow to \$${(_totalSavedMoney * math.pow(1.08, 10)).toStringAsFixed(2)} in 10 years!',
                        style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Keep Saving', style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricTile(String title, String value, Color color) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// TAB 1: INSTANT EVALUATOR TAB
// ==========================================================
class EvaluatorTab extends StatefulWidget {
  final double hourlyWage;
  final ValueChanged<double> onUpdateWage;
  final Function(WishlistItem) onAddToVault;

  const EvaluatorTab({
    super.key,
    required this.hourlyWage,
    required this.onUpdateWage,
    required this.onAddToVault,
  });

  @override
  State<EvaluatorTab> createState() => _EvaluatorTabState();
}

class _EvaluatorTabState extends State<EvaluatorTab> {
  final _nameController = TextEditingController(text: 'Sneaker Shoes');
  double _itemPrice = 120.00;
  double _urgeRating = 7.0; // 1 - 10
  String _selectedCategory = 'Fashion';

  final List<String> _categories = [
    'Fashion',
    'Electronics',
    'Gadgets',
    'Dining/FastFood',
    'Subscriptions',
    'Gaming',
    'Home Decor',
  ];

  @override
  Widget build(BuildContext context) {
    final double hoursRequired = widget.hourlyWage > 0 ? (_itemPrice / widget.hourlyWage) : 0;
    final double workDaysRequired = hoursRequired / 8.0; // 8 hr work day
    final double futureCost10Y = _itemPrice * math.pow(1.08, 10);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Info Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb, color: Colors.teal),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Before hitting "Buy Now", evaluate what this item actually costs in human hours!',
                    style: TextStyle(fontSize: 12, color: Colors.teal.shade900),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Input Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Item Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Item Name or Desired Purchase',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.shopping_bag),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          items: _categories.map((cat) {
                            return DropdownMenuItem(value: cat, child: Text(cat));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedCategory = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Item Price:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '\$${_itemPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _itemPrice,
                    min: 5.0,
                    max: 1000.0,
                    divisions: 199,
                    activeColor: Colors.teal,
                    label: '\$${_itemPrice.toStringAsFixed(0)}',
                    onChanged: (val) => setState(() => _itemPrice = val),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Initial Impulse Urge:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Chip(
                        label: Text(
                          '${_urgeRating.toStringAsFixed(1)} / 10',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: _getUrgeColor(_urgeRating),
                      ),
                    ],
                  ),
                  Slider(
                    value: _urgeRating,
                    min: 1.0,
                    max: 10.0,
                    divisions: 18,
                    activeColor: _getUrgeColor(_urgeRating),
                    onChanged: (val) => setState(() => _urgeRating = val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Real-Life Cost Breakdown Card
          Card(
            elevation: 3,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.timer, color: Colors.deepOrange),
                      SizedBox(width: 8),
                      Text(
                        'Life-Time Conversion Matrix',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _conversionRow(
                    icon: Icons.work,
                    label: 'Life Work Required',
                    value: '${hoursRequired.toStringAsFixed(1)} Hours',
                    subtitle: 'Equivalent to ${(workDaysRequired).toStringAsFixed(1)} full 8-hr workdays',
                    color: Colors.deepOrange,
                  ),
                  const SizedBox(height: 12),
                  _conversionRow(
                    icon: Icons.trending_down,
                    label: 'Lost Wealth in 10 Years',
                    value: '\$${futureCost10Y.toStringAsFixed(2)}',
                    subtitle: 'Assuming 8% annual compound growth',
                    color: Colors.purple,
                  ),
                  const SizedBox(height: 12),
                  _conversionRow(
                    icon: Icons.health_and_safety,
                    label: 'Impulse Danger Score',
                    value: _getDangerLabel(hoursRequired, _urgeRating),
                    subtitle: _getDangerAdvice(hoursRequired, _urgeRating),
                    color: _getDangerColor(hoursRequired, _urgeRating),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.shield, color: Colors.white),
                  label: const Text(
                    'Put in 30-Day Vault',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    final item = WishlistItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _nameController.text.trim().isEmpty ? 'Impulse Item' : _nameController.text.trim(),
                      price: _itemPrice,
                      category: _selectedCategory,
                      urgeRating: _urgeRating,
                      dateAdded: DateTime.now(),
                    );
                    widget.onAddToVault(item);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Color _getUrgeColor(double urge) {
    if (urge >= 8.0) return Colors.red;
    if (urge >= 5.0) return Colors.orange;
    return Colors.green;
  }

  String _getDangerLabel(double hours, double urge) {
    if (hours > 10 || urge > 8) return '🚨 HIGH RISK';
    if (hours > 4 || urge > 5) return '⚠️ MODERATE';
    return '✅ LOW RISK';
  }

  Color _getDangerColor(double hours, double urge) {
    if (hours > 10 || urge > 8) return Colors.red;
    if (hours > 4 || urge > 5) return Colors.orange;
    return Colors.green;
  }

  String _getDangerAdvice(double hours, double urge) {
    if (hours > 10 || urge > 8) {
      return 'High work hour sacrifce! Strongly recommended to lock in cooling vault for 30 days.';
    }
    if (hours > 4 || urge > 5) {
      return 'Noticeable cost. Consider comparing with long-term goals in Trade-Off Arena.';
    }
    return 'Low work hour trade-off. Safe to buy if within regular budget.';
  }

  Widget _conversionRow({
    required IconData icon,
    required String label,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          radius: 20,
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==========================================================
// TAB 2: TRADE-OFF BATTLE ARENA
// ==========================================================
class BattleArenaTab extends StatefulWidget {
  final double hourlyWage;
  final List<WishlistItem> coolingVault;

  const BattleArenaTab({
    super.key,
    required this.hourlyWage,
    required this.coolingVault,
  });

  @override
  State<BattleArenaTab> createState() => _BattleArenaTabState();
}

class _BattleArenaTabState extends State<BattleArenaTab> {
  // Option A (Impulse Buy)
  String _itemAName = 'Designer Sunglasses';
  double _itemAPrice = 180.00;
  double _itemAJoyScore = 6.0; // Expected joy in 30 days (1-10)

  // Option B (Dream Goal)
  String _itemBName = 'Weekend Beach Trip Fund';
  double _itemBPrice = 180.00;
  double _itemBJoyScore = 9.5; // Expected joy in 30 days (1-10)

  @override
  Widget build(BuildContext context) {
    final double hoursA = widget.hourlyWage > 0 ? (_itemAPrice / widget.hourlyWage) : 0;
    final double hoursB = widget.hourlyWage > 0 ? (_itemBPrice / widget.hourlyWage) : 0;

    // Joy Efficiency = Joy Score / Work Hours
    final double joyEfficiencyA = hoursA > 0 ? (_itemAJoyScore / hoursA) : 0;
    final double joyEfficiencyB = hoursB > 0 ? (_itemBJoyScore / hoursB) : 0;

    final bool bWins = joyEfficiencyB >= joyEfficiencyA;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.indigo.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.sports_mma, color: Colors.indigo),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Trade-Off Arena: Battle your instant impulse buy against a long-term dream goal to see which delivers true joy per life hour worked!',
                    style: TextStyle(fontSize: 12, color: Colors.indigo.shade900),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Battle Arena Cards
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fighter A
              Expanded(
                child: _buildFighterCard(
                  title: '⚔️ Impulse Option A',
                  name: _itemAName,
                  price: _itemAPrice,
                  joy: _itemAJoyScore,
                  hours: hoursA,
                  efficiency: joyEfficiencyA,
                  cardColor: Colors.red.shade50,
                  accentColor: Colors.red.shade700,
                  onNameChanged: (val) => setState(() => _itemAName = val),
                  onPriceChanged: (val) => setState(() => _itemAPrice = val),
                  onJoyChanged: (val) => setState(() => _itemAJoyScore = val),
                ),
              ),
              const SizedBox(width: 8),
              // Fighter B
              Expanded(
                child: _buildFighterCard(
                  title: '🌟 Dream Goal B',
                  name: _itemBName,
                  price: _itemBPrice,
                  joy: _itemBJoyScore,
                  hours: hoursB,
                  efficiency: joyEfficiencyB,
                  cardColor: Colors.teal.shade50,
                  accentColor: Colors.teal.shade800,
                  onNameChanged: (val) => setState(() => _itemBName = val),
                  onPriceChanged: (val) => setState(() => _itemBPrice = val),
                  onJoyChanged: (val) => setState(() => _itemBJoyScore = val),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Winner Verdict Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bWins ? Colors.teal : Colors.deepOrange,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (bWins ? Colors.teal : Colors.deepOrange).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      bWins ? 'WINNER: ${_itemBName.toUpperCase()}' : 'WINNER: ${_itemAName.toUpperCase()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  bWins
                      ? '"${_itemBName}" yields ${(joyEfficiencyB / (joyEfficiencyA == 0 ? 1 : joyEfficiencyA)).toStringAsFixed(1)}x more happiness per work hour than "${_itemAName}". Skipping Option A secures your goal!'
                      : '"${_itemAName}" provides higher immediate satisfaction value per hour required.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Quick Import from Vault
          if (widget.coolingVault.isNotEmpty) ...[
            const Text(
              'Import Item from Cooling Vault to Compare:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.coolingVault.length,
                itemBuilder: (ctx, idx) {
                  final item = widget.coolingVault[idx];
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      avatar: const Icon(Icons.input, size: 16),
                      label: Text('${item.name} (\$)'),
                      onPressed: () {
                        setState(() {
                          _itemAName = item.name;
                          _itemAPrice = item.price;
                          _itemAJoyScore = item.urgeRating;
                        });
                      },
                    ),
                  );
                },
              ),
            )
          ]
        ],
      ),
    );
  }

  Widget _buildFighterCard({
    required String title,
    required String name,
    required double price,
    required double joy,
    required double hours,
    required double efficiency,
    required Color cardColor,
    required Color accentColor,
    required ValueChanged<String> onNameChanged,
    required ValueChanged<double> onPriceChanged,
    required ValueChanged<double> onJoyChanged,
  }) {
    return Card(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: accentColor),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: name,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: 'Name',
                isDense: true,
                border: OutlineInputBorder(),
              ),
              onChanged: onNameChanged,
            ),
            const SizedBox(height: 10),
            Text(
              'Price: \$${price.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Slider(
              value: price,
              min: 10.0,
              max: 1000.0,
              divisions: 99,
              activeColor: accentColor,
              onChanged: onPriceChanged,
            ),
            Text(
              '30-Day Happiness: ${joy.toStringAsFixed(1)}/10',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Slider(
              value: joy,
              min: 1.0,
              max: 10.0,
              divisions: 18,
              activeColor: accentColor,
              onChanged: onJoyChanged,
            ),
            const Divider(),
            Text(
              'Work Hours: ${hours.toStringAsFixed(1)}h',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              'Joy/Hour: ${efficiency.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: accentColor),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// TAB 3: COOLING VAULT TAB
// ==========================================================
class CoolingVaultTab extends StatelessWidget {
  final List<WishlistItem> coolingVault;
  final double hourlyWage;
  final ValueChanged<WishlistItem> onMarkSaved;
  final ValueChanged<String> onRemoveItem;

  const CoolingVaultTab({
    super.key,
    required this.coolingVault,
    required this.hourlyWage,
    required this.onMarkSaved,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.ac_unit, color: Colors.blue),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '30-Day Cooling Tank: Research shows 70% of impulse urge vanishes within 14 days! Update daily urge scores to watch the urge drop.',
                    style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (coolingVault.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Column(
                  children: [
                    Icon(Icons.shield_outlined, size: 60, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    const Text(
                      'Your Cooling Vault is Empty!',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Send potential purchases here from the Evaluator screen to cool off.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: coolingVault.length,
              itemBuilder: (ctx, index) {
                final item = coolingVault[index];
                final daysPassed = DateTime.now().difference(item.dateAdded).inDays;
                final workHours = hourlyWage > 0 ? (item.price / hourlyWage) : 0;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.teal.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Chip(
                              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                              visualDensity: VisualDensity.compact,
                              avatar: const Icon(Icons.category, size: 14),
                              label: Text(item.category, style: const TextStyle(fontSize: 10)),
                            ),
                            const SizedBox(width: 6),
                            Chip(
                              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                              visualDensity: VisualDensity.compact,
                              avatar: const Icon(Icons.timer, size: 14),
                              label: Text('${workHours.toStringAsFixed(1)} Work Hrs', style: const TextStyle(fontSize: 10)),
                            ),
                            const SizedBox(width: 6),
                            Chip(
                              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                              visualDensity: VisualDensity.compact,
                              avatar: const Icon(Icons.today, size: 14),
                              label: Text('Day $daysPassed / 30', style: const TextStyle(fontSize: 10)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Urge Decay Visualizer
                        Row(
                          children: [
                            const Text(
                              'Current Urge Rating:',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            const Spacer(),
                            Text(
                              '${item.urgeRating.toStringAsFixed(1)} / 10',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: item.urgeRating < 4 ? Colors.green : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: item.urgeRating,
                          min: 0.0,
                          max: 10.0,
                          divisions: 20,
                          activeColor: item.urgeRating < 4 ? Colors.green : Colors.orange,
                          onChanged: (val) {
                            (ctx as Element).markNeedsBuild();
                            item.urgeRating = val;
                          },
                        ),

                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.green,
                                  side: const BorderSide(color: Colors.green),
                                ),
                                icon: const Icon(Icons.check_circle_outline, size: 18),
                                label: const Text('I Resisted! Save Money', style: TextStyle(fontSize: 11)),
                                onPressed: () => onMarkSaved(item),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.grey),
                              tooltip: 'Remove',
                              onPressed: () => onRemoveItem(item.id),
                            )
                          ],
                        )
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
}

// ==========================================================
// TAB 4: FLOATING COMPANION & PERMISSIONS STUDIO
// ==========================================================
class FloatingStudioTab extends StatelessWidget {
  final bool overlayPermission;
  final bool notificationPermission;
  final bool widgetActive;
  final ValueChanged<bool> onToggleOverlay;
  final ValueChanged<bool> onToggleNotification;
  final ValueChanged<bool> onToggleWidget;

  const FloatingStudioTab({
    super.key,
    required this.overlayPermission,
    required this.notificationPermission,
    required this.widgetActive,
    required this.onToggleOverlay,
    required this.onToggleNotification,
    required this.onToggleWidget,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.notifications_active, color: Colors.purple),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Floating Guardian Shield: ValuePulse hovers seamlessly over shopping apps (Amazon, eBay, Chrome) to recalculate checkout prices in real-time!',
                    style: TextStyle(fontSize: 12, color: Colors.purple.shade900),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Permissions Toggles Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'System Permissions & Overlay Control',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Display Above Other Apps Permission', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Allows floating impulse widget over browser and store apps', style: TextStyle(fontSize: 11)),
                    value: overlayPermission,
                    activeColor: Colors.teal,
                    onChanged: onToggleOverlay,
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Smart Shopping Alerts Notifications', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Sends quick impulse cooling reminders during shopping', style: TextStyle(fontSize: 11)),
                    value: notificationPermission,
                    activeColor: Colors.teal,
                    onChanged: onToggleNotification,
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Activate Floating Guardian Widget', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Show floating action shield bubble on screen edge', style: TextStyle(fontSize: 11)),
                    value: widgetActive,
                    activeColor: Colors.teal,
                    onChanged: onToggleWidget,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Interactive Simulator Preview
          const Text(
            'Interactive Live Overlay Preview:',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade900,
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                fit: BoxFit.cover,
                opacity: 0.15,
              ),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Text(
                    '[ Simulated Online Shopping Screen ]\n(Browsing Headphones \$149.99)',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),

                // Simulated Floating Bubble
                if (widgetActive)
                  Positioned(
                    top: 40,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(color: Colors.black87, blurRadius: 6, offset: Offset(0, 3)),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shield, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text(
                            '6.7 Work Hours!',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Simulated Bottom Warning Overlay Banner
                if (widgetActive)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(color: Colors.black87, blurRadius: 8, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.orange,
                            radius: 16,
                            child: Icon(Icons.warning_amber, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'ValuePulse Impulse Alert',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                Text(
                                  'This item requires 6.7 hours of work. Pause before paying!',
                                  style: TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Simulated Vault Lock Triggered!')),
                              );
                            },
                            child: const Text('Lock Vault', style: TextStyle(fontSize: 11, color: Colors.teal)),
                          )
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Test Notification Trigger Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.notifications, color: Colors.teal),
              label: const Text('Simulate Floating Impulse Notification', style: TextStyle(color: Colors.teal)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🔔 Notification: 149.99 equals 6.7 hours of your life! Take a breath.'),
                    backgroundColor: Colors.teal,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}