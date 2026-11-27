import 'package:flutter/material.dart';

void main() {
  runApp(const ValuMateApp());
}

class ValuMateApp extends StatelessWidget {
  const ValuMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ValuMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const ValuMateHomePage(),
    );
  }
}

class ImpulseItem {
  final String id;
  final String name;
  final double price;
  final DateTime dateAdded;
  final int waitHours;
  bool isSaved;

  ImpulseItem({
    required this.id,
    required this.name,
    required this.price,
    required this.dateAdded,
    required this.waitHours,
    this.isSaved = false,
  });
}

class ValuMateHomePage extends StatefulWidget {
  const ValuMateHomePage({super.key});

  @override
  State<ValuMateHomePage> createState() => _ValuMateHomePageState();
}

class _ValuMateHomePageState extends State<ValuMateHomePage> {
  int _currentIndex = 0;

  // TrueCost State
  double _hourlyWage = 25.0;
  double _itemPrice = 120.0;
  double _hoursPerDay = 8.0;

  // Impulse Vault State
  final List<ImpulseItem> _vaultItems = [
    ImpulseItem(
      id: '1',
      name: 'Wireless Gaming Earbuds',
      price: 89.99,
      dateAdded: DateTime.now().subtract(const Duration(hours: 14)),
      waitHours: 48,
    ),
    ImpulseItem(
      id: '2',
      name: 'Designer Leather Jacket',
      price: 240.00,
      dateAdded: DateTime.now().subtract(const Duration(hours: 36)),
      waitHours: 72,
    ),
  ];
  double _totalMoneySaved = 345.50;

  // Micro-Leaks State
  double _dailyCoffee = 4.50;
  double _weeklyTakeout = 35.00;
  double _monthlySubscriptions = 45.00;

  // Floating Overlay Permissions Simulation
  bool _displayOverApps = true;
  bool _quickNotificationBar = true;
  bool _smartImpulseDetector = true;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildTrueCostTab(),
      _buildImpulseVaultTab(),
      _buildMicroLeaksTab(),
      _buildFloatingOverlayTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.monetization_on, color: Colors.amber),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'ValuMate Companion',
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showAppInfoDialog,
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'True Cost',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: 'Impulse Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Micro-Leaks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Overlay Hub',
          ),
        ],
      ),
    );
  }

  // TAB 1: True Cost & Work-Hour Translator
  Widget _buildTrueCostTab() {
    double hoursNeeded = _hourlyWage > 0 ? _itemPrice / _hourlyWage : 0;
    double daysNeeded = _hoursPerDay > 0 ? hoursNeeded / _hoursPerDay : 0;
    double invested5Yr = _itemPrice * 1.40; // 7% annual compound return estimation

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.withAlpha(20),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.indigo.withAlpha(50)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.indigo),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Work-Hour Price Translator',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover how much of your actual life force and working hours this purchase will cost you.',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sliders & Inputs
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Your Net Hourly Wage:'),
                        Text(
                          '\$${_hourlyWage.toStringAsFixed(2)}/hr',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                        ),
                      ],
                    ),
                    Slider(
                      value: _hourlyWage,
                      min: 5.0,
                      max: 150.0,
                      divisions: 145,
                      activeColor: Colors.indigo,
                      onChanged: (val) => setState(() => _hourlyWage = val),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Item / Purchase Price:'),
                        Text(
                          '\$${_itemPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange),
                        ),
                      ],
                    ),
                    Slider(
                      value: _itemPrice,
                      min: 5.0,
                      max: 2000.0,
                      divisions: 399,
                      activeColor: Colors.deepOrange,
                      onChanged: (val) => setState(() => _itemPrice = val),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Live Impact Dashboard
            Text(
              'Real Life Impact',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade700),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.work, color: Colors.amber, size: 32),
                        const SizedBox(height: 6),
                        FittedBox(
                          child: Text(
                            '${hoursNeeded.toStringAsFixed(1)} Hours',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text('Work Time Spent', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.teal),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.today, color: Colors.teal, size: 32),
                        const SizedBox(height: 6),
                        FittedBox(
                          child: Text(
                            '${daysNeeded.toStringAsFixed(1)} Days',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text('Working Days', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withAlpha(80)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.trending_up, color: Colors.blue, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('5-Year Investment Potential', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(
                          'If invested instead, this dynamic money grows to \$${invested5Yr.toStringAsFixed(2)}.',
                          style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Quick Add to Cooling Vault Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  _addNewVaultItem('New Wishlist Item', _itemPrice);
                },
                icon: const Icon(Icons.lock_clock),
                label: const Text('Add to Impulse Vault (24h Cooling)', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: Impulse Cooling Vault
  Widget _buildImpulseVaultTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Savings Counter Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.indigo, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified, color: Colors.white, size: 44),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Regret Money Saved',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        FittedBox(
                          child: Text(
                            '\$${_totalMoneySaved.toStringAsFixed(2)}',
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
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cooling Lockers (${_vaultItems.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: _showAddDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Item'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (_vaultItems.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                textAlign: TextAlign.center,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle_outline, size: 48, color: Colors.grey),
                    const SizedBox(height: 8),
                    const Text('Your Impulse Vault is Empty!', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Add items before buying to prevent buyer regret.', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _vaultItems.length,
                itemBuilder: (context, index) {
                  final item = _vaultItems[index];
                  final hoursPassed = DateTime.now().difference(item.dateAdded).inHours;
                  final hoursRemaining = item.waitHours - hoursPassed;
                  final isReady = hoursRemaining <= 0;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                isReady ? Icons.lock_open : Icons.lock,
                                size: 16,
                                color: isReady ? Colors.green : Colors.amber,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isReady
                                    ? 'Cooling period finished! Do you still want it?'
                                    : 'Locked: $hoursRemaining hours remaining',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isReady ? Colors.green : Colors.amber.shade800,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _totalMoneySaved += item.price;
                                    _vaultItems.removeAt(index);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Awesome! You saved \$${item.price.toStringAsFixed(2)}!')),
                                  );
                                },
                                icon: const Icon(Icons.savings, size: 16),
                                label: const Text('Saved & Skipped!'),
                              ),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _vaultItems.removeAt(index);
                                  });
                                },
                                icon: const Icon(Icons.shopping_cart, size: 16),
                                label: const Text('Bought It'),
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
      ),
    );
  }

  // TAB 3: Micro-Leaks Matrix
  Widget _buildMicroLeaksTab() {
    double monthlyLeak = (_dailyCoffee * 30) + (_weeklyTakeout * 4.33) + _monthlySubscriptions;
    double yearlyLeak = monthlyLeak * 12;
    double tenYearOpportunityCost = yearlyLeak * 10 * 1.5; // Estimated long-term wealth loss

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(20),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.withAlpha(60)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Silent Expense Leaks', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                        const SizedBox(height: 4),
                        Text(
                          'Micro-habits consume small daily amounts that turn into major annual financial drainers.',
                          style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Daily Coffee / Snacks:'),
                        Text('\$${_dailyCoffee.toStringAsFixed(2)}/day', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                      value: _dailyCoffee,
                      min: 0.0,
                      max: 20.0,
                      divisions: 40,
                      activeColor: Colors.amber,
                      onChanged: (v) => setState(() => _dailyCoffee = v),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Weekly Food Delivery:'),
                        Text('\$${_weeklyTakeout.toStringAsFixed(2)}/wk', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                      value: _weeklyTakeout,
                      min: 0.0,
                      max: 150.0,
                      divisions: 30,
                      activeColor: Colors.deepOrange,
                      onChanged: (v) => setState(() => _weeklyTakeout = v),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Unused Subscriptions:'),
                        Text('\$${_monthlySubscriptions.toStringAsFixed(2)}/mo', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                      value: _monthlySubscriptions,
                      min: 0.0,
                      max: 200.0,
                      divisions: 40,
                      activeColor: Colors.indigo,
                      onChanged: (v) => setState(() => _monthlySubscriptions = v),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Visual Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Micro-Leak Analysis', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Monthly Drain:', style: TextStyle(color: Colors.white)),
                      Text(
                        '\$${monthlyLeak.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Annual Total Loss:', style: TextStyle(color: Colors.white)),
                      Text(
                        '\$${yearlyLeak.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white70, height: 24),
                  Row(
                    children: [
                      const Icon(Icons.savings, color: Colors.tealAccent, size: 28),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('10-Year Opportunity Wealth Loss', style: TextStyle(color: Colors.white70, fontSize: 12)),
                            FittedBox(
                              child: Text(
                                '\$${tenYearOpportunityCost.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 4: Floating Overlay & Companion Permissions Hub
  Widget _buildFloatingOverlayTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.withAlpha(20),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.withAlpha(60)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.layers, color: Colors.teal, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('System Floating Companion', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                        const SizedBox(height: 4),
                        Text(
                          'ValuMate can float above shopping apps (Amazon, AliExpress, eBay) to calculate work-hours live!',
                          style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Display Over Other Apps'),
                    subtitle: const Text('Allows floating price-translator bubble while browsing stores'),
                    value: _displayOverApps,
                    onChanged: (val) => setState(() => _displayOverApps = val),
                    secondary: const Icon(Icons.picture_in_picture, color: Colors.indigo),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Quick Persistent Notification Bar'),
                    subtitle: const Text('One-tap impulse lock directly from system tray'),
                    value: _quickNotificationBar,
                    onChanged: (val) => setState(() => _quickNotificationBar = val),
                    secondary: const Icon(Icons.notifications_active, color: Colors.amber),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Smart Impulse Detector'),
                    subtitle: const Text('Auto-prompts cooling timer on high checkout screens'),
                    value: _smartImpulseDetector,
                    onChanged: (val) => setState(() => _smartImpulseDetector = val),
                    secondary: const Icon(Icons.auto_awesome, color: Colors.teal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Live Interactive Floating Bubble Simulator',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Live Simulator Card
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.indigo.shade900,
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.15,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Simulated Phone Screen', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade600,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(color: Colors.black87, blurRadius: 8, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '\$${_itemPrice.toStringAsFixed(0)} = ${(_itemPrice / _hourlyWage).toStringAsFixed(1)} hrs work',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
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
    );
  }

  void _addNewVaultItem(String defaultName, double defaultPrice) {
    setState(() {
      _vaultItems.add(
        ImpulseItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: defaultName,
          price: defaultPrice,
          dateAdded: DateTime.now(),
          waitHours: 24,
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item added to Impulse Vault! 24h cooling timer started.')),
    );
  }

  void _showAddDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Impulse Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price (\$)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final price = double.tryParse(priceController.text) ?? 0.0;
                if (name.isNotEmpty && price > 0) {
                  _addNewVaultItem(name, price);
                  Navigator.pop(context);
                }
              },
              child: const Text('Lock in Vault'),
            ),
          ],
        );
      },
    );
  }

  void _showAppInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About ValuMate'),
        content: const Text(
          'ValuMate translates every product price into hours of your actual life spent working. '
          'Use the Impulse Vault to eliminate buyer regret and track your micro-expense leaks daily!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got It'),
          ),
        ],
      ),
    );
  }
}