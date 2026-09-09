import 'package:flutter/material.dart';

void main() {
  runApp(const ValueShiftApp());
}

class ValueShiftApp extends StatelessWidget {
  const ValueShiftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ValueShift',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFA5D6A7),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class ImpulseVaultItem {
  final String id;
  final String title;
  final double price;
  final DateTime addedDate;
  final int coolingHours;
  bool isSaved;
  bool isPurchased;

  ImpulseVaultItem({
    required this.id,
    required this.title,
    required this.price,
    required this.addedDate,
    this.coolingHours = 48,
    this.isSaved = false,
    this.isPurchased = false,
  });
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  double _hourlyWage = 18.50; // Default hourly wage in \$
  double _totalMoneySaved = 245.00;
  double _totalHoursSaved = 13.2;

  final List<ImpulseVaultItem> _vaultItems = [
    ImpulseVaultItem(
      id: '1',
      title: 'Wireless Gaming Earbuds',
      price: 65.00,
      addedDate: DateTime.now().subtract(const Duration(hours: 30)),
      coolingHours: 48,
    ),
    ImpulseVaultItem(
      id: '2',
      title: 'Designer Espresso Mug Set',
      price: 34.99,
      addedDate: DateTime.now().subtract(const Duration(hours: 50)),
      coolingHours: 48,
      isSaved: true,
    ),
  ];

  void _updateWage(double newWage) {
    setState(() {
      _hourlyWage = newWage;
    });
  }

  void _addVaultItem(String title, double price, int hours) {
    setState(() {
      _vaultItems.add(
        ImpulseVaultItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          price: price,
          addedDate: DateTime.now(),
          coolingHours: hours,
        ),
      );
    });
  }

  void _markAsSaved(ImpulseVaultItem item) {
    setState(() {
      item.isSaved = true;
      _totalMoneySaved += item.price;
      _totalHoursSaved += (item.price / (_hourlyWage > 0 ? _hourlyWage : 1));
    });
  }

  void _markAsPurchased(ImpulseVaultItem item) {
    setState(() {
      item.isPurchased = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      LifeCostCalculatorScreen(
        hourlyWage: _hourlyWage,
        onWageChanged: _updateWage,
        onAddToVault: _addVaultItem,
      ),
      MicroDilemmaScreen(hourlyWage: _hourlyWage),
      CoolingVaultScreen(
        vaultItems: _vaultItems,
        hourlyWage: _hourlyWage,
        onMarkSaved: _markAsSaved,
        onMarkPurchased: _markAsPurchased,
      ),
      DashboardScreen(
        hourlyWage: _hourlyWage,
        totalSaved: _totalMoneySaved,
        totalHoursSaved: _totalHoursSaved,
        vaultCount: _vaultItems.where((i) => !i.isSaved && !i.isPurchased).length,
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Life Cost',
          ),
          NavigationDestination(
            icon: Icon(Icons.compare_arrows),
            label: 'Dilemma Hub',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer),
            label: 'Cooling Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.stars),
            label: 'Impact Stats',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 1: LIFE COST & IMPULSE CONVERTER
// -----------------------------------------------------------------------------
class LifeCostCalculatorScreen extends StatefulWidget {
  final double hourlyWage;
  final ValueChanged<double> onWageChanged;
  final Function(String title, double price, int hours) onAddToVault;

  const LifeCostCalculatorScreen({
    super.key,
    required this.hourlyWage,
    required this.onWageChanged,
    required this.onAddToVault,
  });

  @override
  State<LifeCostCalculatorScreen> createState() => _LifeCostCalculatorScreenState();
}

class _LifeCostCalculatorScreenState extends State<LifeCostCalculatorScreen> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  double _itemPrice = 49.99;
  String _itemName = 'Smart Fitness Band';

  @override
  void initState() {
    super.initState();
    _itemController.text = _itemName;
    _priceController.text = _itemPrice.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _itemController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _calculate() {
    setState(() {
      _itemName = _itemController.text.trim().isEmpty ? 'Selected Item' : _itemController.text.trim();
      _itemPrice = double.tryParse(_priceController.text) ?? 0.0;
    });
  }

  void _showWageDialog() {
    final TextEditingController wageController =
        TextEditingController(text: widget.hourlyWage.toStringAsFixed(2));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set Net Hourly Wage'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter your hourly income after taxes to convert prices into actual work effort.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: wageController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Hourly Wage (\$)',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
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
                widget.onWageChanged(val);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double safeWage = widget.hourlyWage > 0 ? widget.hourlyWage : 15.0;
    final double workHoursNeeded = _itemPrice / safeWage;
    final double workDaysNeeded = workHoursNeeded / 8.0;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Life Cost Calculator'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Set Wage',
              onPressed: _showWageDialog,
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hourly Wage Header Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.teal),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Hourly Rate Baseline',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            '\$${widget.hourlyWage.toStringAsFixed(2)} / hour',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: _showWageDialog,
                      child: const Text('Edit'),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Inputs Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Item You Want To Buy',
                        style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _itemController,
                        decoration: const InputDecoration(
                          labelText: 'Item or Experience Name',
                          hintText: 'e.g., New Sneakers, Fast Food Deal',
                          prefixIcon: Icon(Icons.shopping_bag),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => _calculate(),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Price (\$)'),
                          prefixText: '\$ ',
                          prefixIcon: Icon(Icons.attach_money),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => _calculate(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Visual Breakdown Results
              Card(
                color: Colors.indigo.shade900,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'REAL COST OF "${_itemName.toUpperCase()}"',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: TextAlign.center,
                          children: [
                            Text(
                              workHoursNeeded.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 48,
                                FontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'HOURS OF WORK',
                              style: TextStyle(
                                fontSize: 18,
                                FontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Equivalent to ${workDaysNeeded.toStringAsFixed(1)} standard 8-hour workdays',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const Divider(color: Colors.white70, height: 32),
                      
                      // Trade-off chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildTradeOffChip(
                            Icons.restaurant,
                            '~${(_itemPrice / 12.0).toStringAsFixed(0)} Home Meals',
                          ),
                          _buildTradeOffChip(
                            Icons.local_cafe,
                            '~${(_itemPrice / 4.50).toStringAsFixed(0)} Coffees Saved',
                          ),
                          _buildTradeOffChip(
                            Icons.directions_car,
                            '~${(_itemPrice / 3.80).toStringAsFixed(0)} Gas Gallons',
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Action Bar
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.lock_clock),
                  label: const Text(
                    'Put in 48-Hour Cooling Vault',
                    style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (_itemPrice > 0) {
                      widget.onAddToVault(_itemName, _itemPrice, 48);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added "$_itemName" to 48-Hour Cooling Vault!'),
                          backgroundColor: Colors.teal,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTradeOffChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.amber, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 2: MICRO-DILEMMA COMPARISON MATRIX
// -----------------------------------------------------------------------------
class MicroDilemmaScreen extends StatefulWidget {
  final double hourlyWage;

  const MicroDilemmaScreen({super.key, required this.hourlyWage});

  @override
  State<MicroDilemmaScreen> createState() => _MicroDilemmaScreenState();
}

class _MicroDilemmaScreenState extends State<MicroDilemmaScreen> {
  // Option A State
  final TextEditingController _optANameController = TextEditingController(text: 'Uber / Cab Ride');
  double _optACost = 24.00;
  double _optATimeMins = 20;
  double _optAEnergyScore = 8; // 1-10 rating

  // Option B State
  final TextEditingController _optBNameController = TextEditingController(text: 'Public Bus');
  double _optBCost = 2.50;
  double _optBTimeMins = 50;
  double _optBEnergyScore = 4; // 1-10 rating

  @override
  void dispose() {
    _optANameController.dispose();
    _optBNameController.dispose();
    super.dispose();
  }

  double _calculateScore(double cost, double timeMins, double energy) {
    // Score based on wage-converted monetary cost + time spent + energy value
    final double wage = widget.hourlyWage > 0 ? widget.hourlyWage : 15.0;
    final double moneyHours = cost / wage;
    final double timeHours = timeMins / 60.0;
    final double totalEffortHours = moneyHours + timeHours - (energy * 0.15);
    return totalEffortHours;
  }

  @override
  Widget build(BuildContext context) {
    final double scoreA = _calculateScore(_optACost, _optATimeMins, _optAEnergyScore);
    final double scoreB = _calculateScore(_optBCost, _optBTimeMins, _optBEnergyScore);

    final String winner = scoreA < scoreB
        ? (_optANameController.text.isEmpty ? 'Option A' : _optANameController.text)
        : (_optBNameController.text.isEmpty ? 'Option B' : _optBNameController.text);

    final double hourlyDifference = (scoreA - scoreB).abs();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Micro-Dilemma Matrix'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Compare Daily Alternatives',
                style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Weigh immediate costs, commute time, and friction to find the smarter micro-choice.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // Option A Card
              _buildOptionCard(
                title: 'OPTION A',
                color: Colors.teal.shade700,
                nameController: _optANameController,
                cost: _optACost,
                timeMins: _optATimeMins,
                energy: _optAEnergyScore,
                onCostChanged: (val) => setState(() => _optACost = val),
                onTimeChanged: (val) => setState(() => _optATimeMins = val),
                onEnergyChanged: (val) => setState(() => _optAEnergyScore = val),
              ),

              const SizedBox(height: 16),

              // Option B Card
              _buildOptionCard(
                title: 'OPTION B',
                color: Colors.blueGrey.shade700,
                nameController: _optBNameController,
                cost: _optBCost,
                timeMins: _optBTimeMins,
                energy: _optBEnergyScore,
                onCostChanged: (val) => setState(() => _optBCost = val),
                onTimeChanged: (val) => setState(() => _optBTimeMins = val),
                onEnergyChanged: (val) => setState(() => _optBEnergyScore = val),
              ),

              const SizedBox(height: 20),

              // Smart Recommendation Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber.shade600, width: 1.5),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.psychology, color: Colors.black87),
                        SizedBox(width: 8),
                        Text(
                          'SMART RECOMMENDATION',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Choose: "$winner"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        FontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'This option reclaims ~${hourlyDifference.toStringAsFixed(1)} net effective life-hours when factoring your wage rate and personal comfort.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required Color color,
    required TextEditingController nameController,
    required double cost,
    required double timeMins,
    required double energy,
    required ValueChanged<double> onCostChanged,
    required ValueChanged<double> onTimeChanged,
    required ValueChanged<double> onEnergyChanged,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Option Name',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Direct Cost: \$${cost.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Slider(
                        value: cost.clamp(0.0, 150.0),
                        min: 0,
                        max: 150,
                        divisions: 30,
                        activeColor: color,
                        onChanged: onCostChanged,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Duration: ${timeMins.round()} mins', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Slider(
                        value: timeMins.clamp(0.0, 120.0),
                        min: 0,
                        max: 120,
                        divisions: 24,
                        activeColor: color,
                        onChanged: onTimeChanged,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('Comfort / Energy Level: ${energy.round()}/10', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Slider(
                    value: energy,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    activeColor: color,
                    onChanged: onEnergyChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 3: 48-HOUR IMPULSE COOLING-OFF VAULT
// -----------------------------------------------------------------------------
class CoolingVaultScreen extends StatelessWidget {
  final List<ImpulseVaultItem> vaultItems;
  final double hourlyWage;
  final Function(ImpulseVaultItem) onMarkSaved;
  final Function(ImpulseVaultItem) onMarkPurchased;

  const CoolingVaultScreen({
    super.key,
    required this.vaultItems,
    required this.hourlyWage,
    required this.onMarkSaved,
    required this.onMarkPurchased,
  });

  @override
  Widget build(BuildContext context) {
    final activeItems = vaultItems.where((i) => !i.isSaved && !i.isPurchased).toList();
    final resolvedItems = vaultItems.where((i) => i.isSaved || i.isPurchased).toList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Impulse Cooling Vault'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '48-Hour Pause Vault',
                style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Delay non-essential urges. Most impulse desires drop by 80% after 48 hours.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              if (activeItems.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.teal.shade200),
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.check_circle_outline, size: 48, color: Colors.teal),
                      SizedBox(height: 12),
                      Text(
                        'Your Vault is Clear!',
                        style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'No pending impulse urges currently in cooling off.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
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
                    final elapsedHours = DateTime.now().difference(item.addedDate).inHours;
                    final remainingHours = (item.coolingHours - elapsedHours).clamp(0, item.coolingHours);
                    final isCooled = remainingHours <= 0;
                    final safeWage = hourlyWage > 0 ? hourlyWage : 15.0;
                    final hoursCost = item.price / safeWage;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
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
                                      fontSize: 16,
                                      FontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '\$${item.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    FontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Requires ${hoursCost.toStringAsFixed(1)} work hours',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 12),

                            // Timer Status
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isCooled ? Colors.green.shade50 : Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isCooled ? Icons.lock_open : Icons.lock_clock,
                                    size: 18,
                                    color: isCooled ? Colors.green : Colors.orange.shade800,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      isCooled
                                          ? 'Cooling Complete! Do you still want this?'
                                          : 'Cooling: $remainingHours hours remaining',
                                      style: TextStyle(
                                        fontSize: 12,
                                        FontWeight: FontWeight.w600,
                                        color: isCooled ? Colors.green.shade900 : Colors.orange.shade900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Decision Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.green.shade700,
                                      side: BorderSide(color: Colors.green.shade700),
                                    ),
                                    icon: const Icon(Icons.savings, size: 18),
                                    label: const Text('Saved Money!'),
                                    onPressed: () => onMarkSaved(item),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextButton.icon(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.grey.shade700,
                                    ),
                                    icon: const Icon(Icons.shopping_cart, size: 18),
                                    label: const Text('Bought It'),
                                    onPressed: () => onMarkPurchased(item),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),

              const SizedBox(height: 20),

              // Vault History
              if (resolvedItems.isNotEmpty) ...[
                const Text(
                  'Recent Vault History',
                  style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: resolvedItems.length,
                  itemBuilder: (context, index) {
                    final item = resolvedItems[index];
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        item.isSaved ? Icons.check_circle : Icons.shopping_bag,
                        color: item.isSaved ? Colors.green : Colors.grey,
                      ),
                      title: Text(item.title),
                      subtitle: Text(item.isSaved ? 'Resisted & Saved' : 'Purchased after reflection'),
                      trailing: Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: item.isSaved ? Colors.green : Colors.black,
                        ),
                      ),
                    );
                  },
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 4: IMPACT STATS & DECISION DASHBOARD
// -----------------------------------------------------------------------------
class DashboardScreen extends StatelessWidget {
  final double hourlyWage;
  final double totalSaved;
  final double totalHoursSaved;
  final int vaultCount;

  const DashboardScreen({
    super.key,
    required this.hourlyWage,
    required this.totalSaved,
    required this.totalHoursSaved,
    required this.vaultCount,
  });

  @style
  @override
  Widget build(BuildContext context) {
    // Dynamic level calculation based on savings
    final int level = (totalSaved / 50.0).floor() + 1;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Impact Stats'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Mastery Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade700, Colors.teal.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.military_tech, size: 36, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Mindful Decider - Level $level',
                      style: const TextStyle(
                        fontSize: 18,
                        FontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Impulse Control Streak: 5 Days',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Lifetime Reclaimed Resources',
                style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.savings,
                      iconColor: Colors.green,
                      title: 'Money Retained',
                      value: '\$${totalSaved.toStringAsFixed(2)}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.schedule,
                      iconColor: Colors.amber.shade800,
                      title: 'Work Hours Reclaimed',
                      value: '${totalHoursSaved.toStringAsFixed(1)} hrs',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.lock_clock,
                      iconColor: Colors.teal,
                      title: 'Active Vault Pauses',
                      value: '$vaultCount Items',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.verified_user,
                      iconColor: Colors.indigo,
                      title: 'Net Wage Rate',
                      value: '\$${hourlyWage.toStringAsFixed(2)}/hr',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Motivational Banner
              Card(
                color: Colors.teal.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: const [
                      Icon(Icons.stars, color: Colors.teal, size: 32),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You have successfully reclaimed over half a day of work effort by reflecting on everyday micro-decisions!',
                          style: TextStyle(fontSize: 13, color: Colors.teal),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
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
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              FontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}