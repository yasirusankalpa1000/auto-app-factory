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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class ImpulseItem {
  final String id;
  final String title;
  final double amount;
  final String category;
  final String trigger;
  final DateTime createdAt;
  final int durationHours;
  bool isSaved;
  bool isBought;

  ImpulseItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.trigger,
    required this.createdAt,
    required this.durationHours,
    this.isSaved = false,
    this.isBought = false,
  });

  DateTime get unlockTime => createdAt.add(Duration(hours: durationHours));
  
  bool get isLocked => DateTime.now().isBefore(unlockTime) && !isSaved && !isBought;

  double get remainingProgress {
    final totalMs = Duration(hours: durationHours).inMilliseconds;
    if (totalMs <= 0) return 1.0;
    final elapsedMs = DateTime.now().difference(createdAt).inMilliseconds;
    final progress = elapsedMs / totalMs;
    return progress.clamp(0.0, 1.0);
  }

  String get timeRemainingString {
    final remaining = unlockTime.difference(DateTime.now());
    if (remaining.isNegative) return "Ready to Decide";
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    if (hours > 0) {
      return "${hours}h ${minutes}m left";
    }
    return "${minutes}m remaining";
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;
  double _hourlyWage = 20.0; // Default hourly wage assumption
  
  final List<ImpulseItem> _impulses = [
    ImpulseItem(
      id: '1',
      title: 'Wireless Gaming Earbuds',
      amount: 49.99,
      category: 'Tech',
      trigger: 'Late Night Ad',
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      durationHours: 3,
    ),
    ImpulseItem(
      id: '2',
      title: 'Gourmet Pizza Delivery',
      amount: 24.50,
      category: 'Food',
      trigger: 'Stress & Tired',
      createdAt: DateTime.now().subtract(const Duration(minutes: 110)),
      durationHours: 2,
    ),
    ImpulseItem(
      id: '3',
      title: 'Designer Sneaker Sale',
      amount: 115.00,
      category: 'Fashion',
      trigger: 'Boredom',
      createdAt: DateTime.now().subtract(const Duration(hours: 26)),
      durationHours: 24,
      isSaved: true,
    ),
  ];

  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    // Refresh UI every 30 seconds for timer updates
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  double get _totalMoneySaved {
    return _impulses
        .where((item) => item.isSaved)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  int get _totalItemsSaved {
    return _impulses.where((item) => item.isSaved).length;
  }

  void _addImpulse(ImpulseItem item) {
    setState(() {
      _impulses.insert(0, item);
      _selectedIndex = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Locked '${item.title}' in the Vault! Stay strong!"),
        backgroundColor: Colors.indigo,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _markSaved(String id) {
    setState(() {
      final index = _impulses.indexWhere((element) => element.id == id);
      if (index != -1) {
        _impulses[index].isSaved = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Awesome! You resisted the impulse and saved cash!"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _markBought(String id) {
    setState(() {
      final index = _impulses.indexWhere((element) => element.id == id);
      if (index != -1) {
        _impulses[index].isBought = true;
      }
    });
  }

  void _deleteItem(String id) {
    setState(() {
      _impulses.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildVaultPage(),
      _buildAddImpulsePage(),
      _buildOpportunityCostPage(),
      _buildStatsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: Row(
          children: const [
            Icon(Icons.shield_outlined, color: Colors.amber),
            SizedBox(width: 8),
            Text(
              "ImpulseVault",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.self_improvement),
            tooltip: 'Urge Buster',
            onPressed: () => _showUrgeBusterDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer, color: Colors.indigo),
            label: 'Cooling Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle, color: Colors.indigo),
            label: 'Lock Urge',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate, color: Colors.indigo),
            label: 'Trade-Off',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics, color: Colors.indigo),
            label: 'Savings',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: VAULT LIST ---
  Widget _buildVaultPage() {
    final activeItems = _impulses.where((i) => !i.isSaved && !i.isBought).toList();
    final resolvedItems = _impulses.where((i) => i.isSaved || i.isBought).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.indigo, Colors.indigoAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.2),
                  blurRadius: 8,
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
                        "Total Cash Saved",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "\$${_totalMoneySaved.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "$_totalItemsSaved impulse purchases resisted!",
                        style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showUrgeBusterDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.bolt, size: 18),
                  label: const Text(
                    "Urge Buster",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section Header: Active Cool-downs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Active Cooling Vaults",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${activeItems.length} Pending",
                  style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (activeItems.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: const [
                  Icon(Icons.check_circle_outline, color: Colors.green, size: 48),
                  SizedBox(height: 8),
                  Text(
                    "Vault is Clear!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "No pending urge purchases. Tap '+' to lock your next micro-impulse.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
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
                return _buildImpulseCard(item);
              },
            ),

          const SizedBox(height: 24),

          // Section Header: History / Resolved
          if (resolvedItems.isNotEmpty) ...[
            const Text(
              "Recent Vault History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: resolvedItems.length,
              itemBuilder: (context, index) {
                final item = resolvedItems[index];
                return _buildResolvedCard(item);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImpulseCard(ImpulseItem item) {
    final double laborHours = item.amount / (_hourlyWage <= 0 ? 20 : _hourlyWage);
    final bool canDecide = !item.isLocked;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: canDecide ? Colors.amber.shade400 : Colors.grey.shade200, width: canDecide ? 1.5 : 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
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
              CircleAvatar(
                backgroundColor: _getCategoryColor(item.category).withOpacity(0.15),
                child: Icon(_getCategoryIcon(item.category), color: _getCategoryColor(item.category)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _buildChip(item.category, Colors.blueGrey),
                        _buildChip("Trigger: ${item.trigger}", Colors.deepOrange),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "\$${item.amount.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.indigo),
                  ),
                  Text(
                    "~${laborHours.toStringAsFixed(1)} hrs work",
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Timer Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        canDecide ? Icons.lock_open : Icons.lock_clock,
                        size: 14,
                        color: canDecide ? Colors.green : Colors.amber.shade800,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.timeRemainingString,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: canDecide ? Colors.green : Colors.amber.shade900,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${(item.remainingProgress * 100).toInt()}% cooled",
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: item.remainingProgress,
                  backgroundColor: Colors.grey.shade200,
                  color: canDecide ? Colors.green : Colors.indigo,
                  minHeight: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _markBought(item.id),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  icon: const Icon(Icons.shopping_cart_checkout, size: 16),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text("Bought It", style: TextStyle(fontSize: 12)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _markSaved(item.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.savings, size: 16),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text("Resisted & Saved!", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResolvedCard(ImpulseItem item) {
    final bool saved = item.isSaved;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            saved ? Icons.check_circle : Icons.remove_circle_outline,
            color: saved ? Colors.green : Colors.grey,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    decoration: saved ? TextDecoration.none : TextDecoration.lineThrough,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  saved ? "Saved \$${item.amount.toStringAsFixed(2)}" : "Bought for \$${item.amount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 12,
                    color: saved ? Colors.green.shade700 : Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
            onPressed: () => _deleteItem(item.id),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }

  // --- TAB 2: ADD IMPULSE FORM ---
  Widget _buildAddImpulsePage() {
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    String selectedCategory = 'Tech';
    String selectedTrigger = 'Impulse Urge';
    int coolingHours = 2;

    final categories = ['Tech', 'Food', 'Fashion', 'Gaming', 'Home', 'Beauty', 'Other'];
    final triggers = ['Impulse Urge', 'Late Night Ad', 'Stress & Tired', 'Boredom', 'Social Media', 'Sale Discount'];

    return StatefulBuilder(
      builder: (context, setFormState) {
        final double parsedPrice = double.tryParse(priceController.text) ?? 0.0;
        final double laborHours = parsedPrice / (_hourlyWage <= 0 ? 20 : _hourlyWage);

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Lock a Purchase Urge",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 4),
              const Text(
                "Delay the purchase decision to break the impulse buy habit.",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Title input
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "What do you want to buy?",
                  hintText: "e.g., Wireless Earbuds, Sneaker Sale",
                  prefixIcon: Icon(Icons.shopping_bag_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Price input
              TextField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => setFormState(() {}),
                decoration: const InputDecoration(
                  labelText: "Price (\$)",
                  hintText: "0.00",
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Hourly labor preview box
              if (parsedPrice > 0) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.work_outline, color: Colors.amber),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "This item equals approx. ${laborHours.toStringAsFixed(1)} hours of your hard work!",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Category dropdown
              const Text("Category", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((cat) {
                  final isSelected = selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: Colors.indigo.shade100,
                    onSelected: (val) {
                      if (val) setFormState(() => selectedCategory = cat);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Emotional Trigger
              const Text("Emotional Trigger / Context", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: triggers.map((trig) {
                  final isSelected = selectedTrigger == trig;
                  return ChoiceChip(
                    label: Text(trig),
                    selected: isSelected,
                    selectedColor: Colors.orange.shade100,
                    onSelected: (val) {
                      if (val) setFormState(() => selectedTrigger = trig);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Cooling Duration Slider
              Text(
                "Cooling-Off Period: $coolingHours Hours",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Slider(
                value: coolingHours.toDouble(),
                min: 1,
                max: 48,
                divisions: 47,
                label: "$coolingHours hrs",
                activeColor: Colors.indigo,
                onChanged: (val) {
                  setFormState(() => coolingHours = val.toInt());
                },
              ),
              const SizedBox(height: 16),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final price = double.tryParse(priceController.text.trim()) ?? 0.0;

                    if (title.isEmpty || price <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter a valid title and price!")),
                      );
                      return;
                    }

                    final newImpulse = ImpulseItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: title,
                      amount: price,
                      category: selectedCategory,
                      trigger: selectedTrigger,
                      createdAt: DateTime.now(),
                      durationHours: coolingHours,
                    );

                    _addImpulse(newImpulse);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.lock_clock),
                  label: const Text(
                    "Lock in Cooling Vault",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- TAB 3: OPPORTUNITY COST TRADE-OFF CALCULATOR ---
  Widget _buildOpportunityCostPage() {
    final amountController = TextEditingController(text: "50.00");

    return StatefulBuilder(
      builder: (context, setCalcState) {
        final amount = double.tryParse(amountController.text) ?? 0.0;
        final wage = _hourlyWage <= 0 ? 20.0 : _hourlyWage;

        final hoursWork = amount / wage;
        final coffeeEquiv = (amount / 4.50).floor();
        final streamingMonths = (amount / 15.0).toStringAsFixed(1);
        final groceryDays = (amount / 25.0).toStringAsFixed(1);

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Trade-Off Calculator",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 4),
              const Text(
                "See what your money is really worth before you spend it.",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Hourly wage config input
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigo.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_outlined, color: Colors.indigo),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Your Hourly Earnings: \$${wage.toStringAsFixed(2)}/hr",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showWageDialog(context, (newWage) {
                        setState(() => _hourlyWage = newWage);
                        setCalcState(() {});
                      }),
                      child: const Text("Edit Rate"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Amount field
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => setCalcState(() {}),
                decoration: const InputDecoration(
                  labelText: "Impulse Purchase Price (\$)",
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                "What \$" + "" " Is Equal To:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Grid of trade offs
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _buildTradeCard(
                    Icons.access_time,
                    "${hoursWork.toStringAsFixed(1)} Hours",
                    "of real labor required",
                    Colors.blue,
                  ),
                  _buildTradeCard(
                    Icons.local_cafe,
                    "$coffeeEquiv Cups",
                    "of artisanal coffee",
                    Colors.brown,
                  ),
                  _buildTradeCard(
                    Icons.tv,
                    "$streamingMonths Mos",
                    "of video streaming",
                    Colors.purple,
                  ),
                  _buildTradeCard(
                    Icons.shopping_cart,
                    "$groceryDays Days",
                    "of basic groceries",
                    Colors.green,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTradeCard(IconData icon, String value, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  // --- TAB 4: STATS & BADGES ---
  Widget _buildStatsPage() {
    final double totalSaved = _totalMoneySaved;
    final int itemsResisted = _totalItemsSaved;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Savings & Impact Dashboard",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 4),
          const Text(
            "Your mindfulness progress and resisted temptation statistics.",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // High level stat cards
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Money Retained", style: TextStyle(fontSize: 12, color: Colors.green)),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "\$${totalSaved.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.indigo.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Urges Overcome", style: TextStyle(fontSize: 12, color: Colors.indigo)),
                      const SizedBox(height: 4),
                      Text(
                        "$itemsResisted",
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Text("Badges & Milestones", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          _buildBadgeTile(
            "First Friction Victory",
            "Resisted your first impulse buy.",
            Icons.stars,
            itemsResisted >= 1,
          ),
          _buildBadgeTile(
            "Fifty Dollar Saver",
            "Saved over \$50 in impulse purchases.",
            Icons.savings,
            totalSaved >= 50,
          ),
          _buildBadgeTile(
            "Master of Delay",
            "Resisted 3 or more total temptations.",
            Icons.psychology,
            itemsResisted >= 3,
          ),
          _buildBadgeTile(
            "Century Guard",
            "Saved over \$100 using ImpulseVault.",
            Icons.workspace_premium,
            totalSaved >= 100,
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeTile(String title, String desc, IconData icon, bool unlocked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: unlocked ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: unlocked ? Colors.amber.shade300 : Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: unlocked ? Colors.amber.shade100 : Colors.grey.shade300,
            child: Icon(icon, color: unlocked ? Colors.amber.shade900 : Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: unlocked ? Colors.black : Colors.grey,
                  ),
                ),
                Text(
                  desc,
                  style: TextStyle(fontSize: 11, color: unlocked ? Colors.grey.shade700 : Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: unlocked ? Colors.green.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              unlocked ? "UNLOCKED" : "LOCKED",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: unlocked ? Colors.green.shade800 : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- DIALOGS & URGE BUSTER TOOL ---
  void _showUrgeBusterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const UrgeBusterDialog();
      },
    );
  }

  void _showWageDialog(BuildContext context, Function(double) onSave) {
    final wageController = TextEditingController(text: _hourlyWage.toStringAsFixed(2));
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Set Hourly Wage"),
          content: TextField(
            controller: wageController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: "Hourly Wage (\$)",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final wage = double.tryParse(wageController.text) ?? 20.0;
                onSave(wage);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Tech':
        return Icons.devices;
      case 'Food':
        return Icons.fastfood;
      case 'Fashion':
        return Icons.checkroom;
      case 'Gaming':
        return Icons.sports_esports;
      case 'Home':
        return Icons.home;
      case 'Beauty':
        return Icons.face;
      default:
        return Icons.shopping_bag;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Tech':
        return Colors.blue;
      case 'Food':
        return Colors.orange;
      case 'Fashion':
        return Colors.purple;
      case 'Gaming':
        return Colors.red;
      case 'Home':
        return Colors.teal;
      case 'Beauty':
        return Colors.pink;
      default:
        return Colors.indigo;
    }
  }
}

// Interactive 60-Second Breathing Urge Buster Mini Tool
class UrgeBusterDialog extends StatefulWidget {
  const UrgeBusterDialog({super.key});

  @override
  State<UrgeBusterDialog> createState() => _UrgeBusterDialogState();
}

class _UrgeBusterDialogState extends State<UrgeBusterDialog> with SingleTickerProviderStateMixin {
  int _secondsLeft = 30;
  Timer? _timer;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft > 0) {
        if (mounted) setState(() => _secondsLeft--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: const [
          Icon(Icons.bolt, color: Colors.amber),
          SizedBox(width: 8),
          Text("60s Urge Buster"),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Take slow deep breaths. Impulse urges naturally peak and drop within 60 seconds.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                final scale = 1.0 + (_animController.value * 0.25);
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.indigo.withOpacity(0.1 + (_animController.value * 0.2)),
                      border: Border.all(color: Colors.indigo, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        "$_secondsLeft s",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              _secondsLeft > 0 ? "Breathe In... Breathe Out..." : "Great job! Mindful calm restored.",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo, fontSize: 13),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(_secondsLeft == 0 ? "Close & Return" : "Skip"),
        ),
      ],
    );
  }
}