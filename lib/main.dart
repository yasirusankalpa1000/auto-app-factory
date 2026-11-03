import 'package:flutter/material.dart';

void main() {
  runApp(const ImpulseShieldApp());
}

class ImpulseShieldApp extends StatelessWidget {
  const ImpulseShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImpulseShield HUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
          surface: const Color(0xFF1E293B),
          primary: Colors.cyan,
          secondary: Colors.amber,
        ),
      ),
      home: const MainDashboardScreen(),
    );
  }
}

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ImpulseConverterScreen(),
    SubscriptionLeakScreen(),
    DecisionMatrixScreen(),
    FloatingHudSimulatorScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0F172A),
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Impulse Shield',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Leak Hunter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology_outlined),
            activeIcon: Icon(Icons.psychology),
            label: 'Decision Radar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers_outlined),
            activeIcon: Icon(Icons.layers),
            label: 'Floating HUD',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SCREEN 1: IMPULSE CONVERTER (Converts prices into Work-Hours & Life-Time)
// ---------------------------------------------------------------------------
class ImpulseConverterScreen extends StatefulWidget {
  const ImpulseConverterScreen({super.key});

  @override
  State<ImpulseConverterScreen> createState() => _ImpulseConverterScreenState();
}

class _ImpulseConverterScreenState extends State<ImpulseConverterScreen> {
  final TextEditingController _itemController = TextEditingController(text: 'Wireless Headphones');
  final TextEditingController _priceController = TextEditingController(text: '120');
  final TextEditingController _hourlyPayController = TextEditingController(text: '15');
  final TextEditingController _weeklyHoursController = TextEditingController(text: '40');

  double _workHoursNeeded = 0;
  double _daysOfLifeSpent = 0;
  bool _showCooldownTimer = false;
  int _cooldownSeconds = 60;

  @override
  void initState() {
    super.initState();
    _calculateImpact();
  }

  void _calculateImpact() {
    final double price = double.tryParse(_priceController.text) ?? 0;
    final double hourlyPay = double.tryParse(_hourlyPayController.text) ?? 1;
    final double weeklyHours = double.tryParse(_weeklyHoursController.text) ?? 40;

    if (hourlyPay > 0) {
      final hours = price / hourlyPay;
      final days = hours / (weeklyHours / 5.0);
      setState(() {
        _workHoursNeeded = hours;
        _daysOfLifeSpent = days;
      });
    }
  }

  void _startCoolDown() {
    setState(() {
      _showCooldownTimer = true;
      _cooldownSeconds = 60;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impulse Buy Reality Converter'),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.cyan.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.cyan.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: Colors.cyan, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Before tapping "Buy Now", calculate how much of your actual life you are trading for this item.',
                        style: TextStyle(color: Colors.grey[200], fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Inputs
              Card(
                color: const Color(0xFF1E293B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _itemController,
                        decoration: const InputDecoration(
                          labelText: 'Item Name',
                          prefixIcon: Icon(Icons.shopping_cart),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => _calculateImpact(),
                              decoration: const InputDecoration(
                                labelText: 'Price (\$) ',
                                prefixIcon: Icon(Icons.attach_money),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _hourlyPayController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => _calculateImpact(),
                              decoration: const InputDecoration(
                                labelText: 'Hourly Wage (\$) ',
                                prefixIcon: Icon(Icons.work),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Results Visualiser
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.cyan.withOpacity(0.4)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'REAL LIFE COST EQUIVALENT',
                      style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    FittedBox(
                      child: Text(
                        '${_workHoursNeeded.toStringAsFixed(1)} WORK HOURS',
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Equivalent to approx. ${_daysOfLifeSpent.toStringAsFixed(1)} full work shifts',
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        Chip(
                          avatar: const Icon(Icons.coffee, size: 16, color: Colors.amber),
                          label: Text('${(_workHoursNeeded * 3).toInt()} Coffees Lost', style: const TextStyle(fontSize: 11)),
                          backgroundColor: Colors.black87,
                        ),
                        Chip(
                          avatar: const Icon(Icons.directions_bus, size: 16, color: Colors.green),
                          label: Text('${(_workHoursNeeded * 5).toInt()} Commutes', style: const TextStyle(fontSize: 11)),
                          backgroundColor: Colors.black87,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Impulse Cooling Chamber Widget
              if (!_showCooldownTimer)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _startCoolDown,
                    icon: const Icon(Icons.timer, color: Colors.black),
                    label: const Text(
                      'ENTER 60-SEC COOLING CHAMBER',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Impulse Cooling Lock Active',
                        style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ask yourself: Will I remember buying "${_itemController.text}" in 30 days?',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.hourglass_bottom, color: Colors.amber),
                          const SizedBox(width: 8),
                          Text(
                            'Hold on for $_cooldownSeconds sec...',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => setState(() => _showCooldownTimer = false),
                        child: const Text('I Still Need It (Cancel Lock)', style: TextStyle(color: Colors.grey)),
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
}

// ---------------------------------------------------------------------------
// SCREEN 2: SUBSCRIPTION & SILENT MONEY LEAK HUNTER
// ---------------------------------------------------------------------------
class SubscriptionLeakScreen extends StatefulWidget {
  const SubscriptionLeakScreen({super.key});

  @override
  State<SubscriptionLeakScreen> createState() => _SubscriptionLeakScreenState();
}

class SubscriptionItem {
  String name;
  double monthlyCost;
  bool isActive;

  SubscriptionItem({required this.name, required this.monthlyCost, this.isActive = true});
}

class _SubscriptionLeakScreenState extends State<SubscriptionLeakScreen> {
  final List<SubscriptionItem> _subscriptions = [
    SubscriptionItem(name: 'Streaming Video Service', monthlyCost: 15.99),
    SubscriptionItem(name: 'Cloud Storage Upgrade', monthlyCost: 2.99),
    SubscriptionItem(name: 'Unused Gym Membership', monthlyCost: 39.99),
    SubscriptionItem(name: 'Music Premium', monthlyCost: 9.99),
    SubscriptionItem(name: 'Daily Gourmet Coffee App', monthlyCost: 45.00),
  ];

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _costCtrl = TextEditingController();

  double get _totalMonthlyLeak {
    return _subscriptions.where((item) => item.isActive).fold(0, (sum, item) => sum + item.monthlyCost);
  }

  void _addSubscription() {
    final name = _nameCtrl.text.trim();
    final cost = double.tryParse(_costCtrl.text) ?? 0;
    if (name.isNotEmpty && cost > 0) {
      setState(() {
        _subscriptions.add(SubscriptionItem(name: name, monthlyCost: cost));
        _nameCtrl.clear();
        _costCtrl.clear();
      });
      Navigator.pop(context);
    }
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Add Silent Micro-Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Subscription Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _costCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monthly Cost (\$) ', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(onPressed: _addSubscription, child: const Text('Add')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final annualLeak = _totalMonthlyLeak * 12;
    final fiveYearLeak = _totalMonthlyLeak * 60 * 1.07; // 7% missed investment opportunity

    return Scaffold(
      appBar: AppBar(
        title: const Text('Silent Money Leak Hunter'),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(onPressed: _showAddDialog, icon: const Icon(Icons.add)),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text('ACCUMULATED SILENT DRAIN', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 8),
                    FittedBox(
                      child: Text(
                        '\$${_totalMonthlyLeak.toStringAsFixed(2)} / month',
                        style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(color: Colors.white70, height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('1-Year Waste', style: TextStyle(color: Colors.grey, fontSize: 11)),
                            const SizedBox(height: 4),
                            Text('\$${annualLeak.toStringAsFixed(0)}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('5-Yr Missed Compound', style: TextStyle(color: Colors.grey, fontSize: 11)),
                            const SizedBox(height: 4),
                            Text('\$${fiveYearLeak.toStringAsFixed(0)}', style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Active Micro-Subscriptions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('${_subscriptions.length} tracked', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 10),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _subscriptions.length,
                itemBuilder: (context, index) {
                  final item = _subscriptions[index];
                  return Card(
                    color: const Color(0xFF1E293B),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: item.isActive ? Colors.red.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                        child: Icon(
                          item.isActive ? Icons.trending_down : Icons.check_circle_outline,
                          color: item.isActive ? Colors.redAccent : Colors.grey,
                        ),
                      ),
                      title: Text(
                        item.name,
                        style: TextStyle(
                          decoration: item.isActive ? TextDecoration.none : TextDecoration.lineThrough,
                          color: item.isActive ? Colors.white : Colors.grey,
                        ),
                      ),
                      subtitle: Text('\$${item.monthlyCost.toStringAsFixed(2)} / mo  (\$${(item.monthlyCost * 12).toStringAsFixed(0)}/yr)'),
                      trailing: Switch(
                        value: item.isActive,
                        activeColor: Colors.redAccent,
                        onChanged: (val) {
                          setState(() {
                            item.isActive = val;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SCREEN 3: MICRO-DECISION MATRIX & REGRET PREDICTOR
// ---------------------------------------------------------------------------
class DecisionMatrixScreen extends StatefulWidget {
  const DecisionMatrixScreen({super.key});

  @override
  State<DecisionMatrixScreen> createState() => _DecisionMatrixScreenState();
}

class _DecisionMatrixScreenState extends State<DecisionMatrixScreen> {
  double _pleasureScore = 5;
  double _utilityScore = 5;
  double _affordabilityScore = 5;
  double _longTermValueScore = 5;

  double get _recommendationScore {
    // Weighted formula for micro decision index
    return (_pleasureScore * 1.5 + _utilityScore * 3.0 + _affordabilityScore * 2.5 + _longTermValueScore * 3.0) / 10.0;
  }

  String get _verdictText {
    final score = _recommendationScore;
    if (score >= 7.5) return 'GREEN LIGHT: High Value Decision!';
    if (score >= 5.0) return 'YELLOW LIGHT: Think Twice Before Proceeding.';
    return 'RED LIGHT: High Regret Risk! Abort Purchase/Choice.';
  }

  Color get _verdictColor {
    final score = _recommendationScore;
    if (score >= 7.5) return Colors.green;
    if (score >= 5.0) return Colors.amber;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Micro-Decision Radar'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _verdictColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _verdictColor),
                ),
                child: Column(
                  children: [
                    Text(
                      _verdictText,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _verdictColor, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: _recommendationScore / 10.0,
                      backgroundColor: Colors.black87,
                      color: _verdictColor,
                      minHeight: 10,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Score: ${(_recommendationScore * 10).toStringAsFixed(0)} / 100',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text('Evaluate Key Decision Criteria:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 16),

              _buildSliderTile('Immediate Pleasure / Craving', _pleasureScore, (v) => setState(() => _pleasureScore = v), Colors.pinkAccent),
              _buildSliderTile('Practical Everyday Utility', _utilityScore, (v) => setState(() => _utilityScore = v), Colors.cyan),
              _buildSliderTile('Current Financial Comfort', _affordabilityScore, (v) => setState(() => _affordabilityScore = v), Colors.green),
              _buildSliderTile('Long-Term 1-Year Value', _longTermValueScore, (v) => setState(() => _longTermValueScore = v), Colors.amber),

              const SizedBox(height: 20),
              Card(
                color: const Color(0xFF1E293B),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.psychology, color: Colors.cyan),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Psychological Tip: If Long-Term Value is lower than 4, your future self will likely regret this micro-decision.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderTile(String title, double value, ValueChanged<double> onChanged, Color color) {
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
                Text('${value.toInt()} / 10', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: value,
              min: 1,
              max: 10,
              divisions: 9,
              activeColor: color,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SCREEN 4: FLOATING HUD OVERLAY SIMULATOR (SYSTEM WIDGET PREVIEW)
// ---------------------------------------------------------------------------
class FloatingHudSimulatorScreen extends StatefulWidget {
  const FloatingHudSimulatorScreen({super.key});

  @override
  State<FloatingHudSimulatorScreen> createState() => _FloatingHudSimulatorScreenState();
}

class _FloatingHudSimulatorScreenState extends State<FloatingHudSimulatorScreen> {
  bool _hudEnabled = true;
  Offset _hudPosition = const Offset(20, 150);
  int _todayImpulseShielded = 3;
  double _savedToday = 64.50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floating Live HUD Simulator'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // System Permission Toggle Card
                  Card(
                    color: const Color(0xFF1E293B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.layers, color: Colors.cyan),
                                  SizedBox(width: 8),
                                  Text('Display Above Apps Overlay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                ],
                              ),
                              Switch(
                                value: _hudEnabled,
                                activeColor: Colors.cyan,
                                onChanged: (v) => setState(() => _hudEnabled = v),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Simulates a system-level floating head widget that hovers over shopping apps (Amazon, eBay, AliExpress) to intercept micro-purchases.',
                            style: TextStyle(color: Colors.grey[400], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text('HUD Live Statistics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.cyan.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.cyan.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Impulses Shielded', style: TextStyle(color: Colors.grey, fontSize: 11)),
                              const SizedBox(height: 8),
                              Text('$_todayImpulseShielded Times', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.cyan)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.amber.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Money Preserved', style: TextStyle(color: Colors.grey, fontSize: 11)),
                              const SizedBox(height: 8),
                              Text('\$${_savedToday.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Floating Notification Trigger Simulation
                  Card(
                    color: const Color(0xFF1E293B),
                    child: ListTile(
                      leading: const Icon(Icons.notifications_active, color: Colors.amber),
                      title: const Text('Trigger Floating Quick Pulse'),
                      subtitle: const Text('Simulates a push heads-up notification prompt'),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFF1E293B),
                              content: Row(
                                children: [
                                  const Icon(Icons.security, color: Colors.cyan),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Impulse Shield Active: You saved \$${_savedToday.toStringAsFixed(0)} this week!',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        },
                        child: const Text('Test HUD', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 100), // Spacing for floating widget demonstration
                ],
              ),
            ),

            // SIMULATED FLOATING OVERLAY WIDGET (DRAGGABLE)
            if (_hudEnabled)
              Positioned(
                left: _hudPosition.dx,
                top: _hudPosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _hudPosition += details.delta;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withOpacity(0.95),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.cyan, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.cyan,
                          child: Icon(Icons.shield, size: 16, color: Colors.black),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'SHIELD ACTIVE',
                              style: TextStyle(color: Colors.cyan, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Saved: \$${_savedToday.toStringAsFixed(0)}',
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _savedToday += 15.0;
                              _todayImpulseShielded += 1;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '+ Shield',
                              style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}