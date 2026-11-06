import 'package:flutter/material.dart';

void main() {
  runApp(const ImpulseGuardApp());
}

class ImpulseGuardApp extends StatelessWidget {
  const ImpulseGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImpulseGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF12151E),
        cardColor: const Color(0xFF1E2230),
        useMaterial3: true,
      ),
      home: const MainHomeScreen(),
    );
  }
}

class SkippedItem {
  final String name;
  final double price;
  final DateTime date;

  SkippedItem({required this.name, required this.price, required this.date});
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentTabIndex = 0;

  // Global Financial Data State
  double _hourlyWage = 22.50;
  double _itemPrice = 120.00;
  String _itemName = "Smart Watch";

  // Impulse Vault
  final List<SkippedItem> _savedItems = [
    SkippedItem(
      name: "Designer Shoes",
      price: 180.0,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    SkippedItem(
      name: "Late Night Fast Food",
      price: 35.0,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // System Floating Overlay State Simulation
  bool _isFloatingOverlayActive = true;
  bool _showMiniFloatingWindow = false;

  // Decision Matrix State
  int _q1NeedVsWant = 1; // 0: Need, 1: Want
  int _q2Frequency = 1; // 0: Daily, 1: Weekly, 2: Rarely
  bool _q3CanBuyTwice = false;
  bool _q4Wait24Hours = false;

  double get _totalMoneySaved =>
      _savedItems.fold(0.0, (sum, item) => sum + item.price);

  double get _hoursRequired =>
      _hourlyWage > 0 ? (_itemPrice / _hourlyWage) : 0;

  double get _daysOfWork => _hoursRequired / 8.0;

  double get _futureValue5Yr => _itemPrice * 1.40; // ~7% annual return compound

  int get _impulseScore {
    int score = 100;
    if (_q1NeedVsWant == 1) score -= 30;
    if (_q2Frequency == 2) score -= 25;
    if (!_q3CanBuyTwice) score -= 25;
    if (!_q4Wait24Hours) score -= 20;
    return score.clamp(0, 100);
  }

  void _addSavedItem(String name, double price) {
    setState(() {
      _savedItems.insert(
        0,
        SkippedItem(name: name, price: price, date: DateTime.now()),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.teal,
        content: Text("🎉 Saved \$${price.toStringAsFixed(2)} into your Impulse Vault!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: IndexedStack(
              index: _currentTabIndex,
              children: [
                _buildLifeCostCalculatorTab(),
                _buildDecisionEngineTab(),
                _buildImpulseVaultTab(),
                _buildFloatingSettingsTab(),
              ],
            ),
          ),

          // Simulated Floating Overlay Assistant Bubble on Screen
          if (_isFloatingOverlayActive)
            Positioned(
              right: 16,
              bottom: 90,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showMiniFloatingWindow = !_showMiniFloatingWindow;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.widgets,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),

          // Mini Floating Window Pop-Up Simulation
          if (_showMiniFloatingWindow)
            Positioned(
              right: 20,
              bottom: 150,
              child: Container(
                width: 280,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2230),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.teal, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black87,
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            "Floating LifeCost Assistant",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showMiniFloatingWindow = false;
                            });
                          },
                          child: const Icon(Icons.close, color: Colors.grey, size: 18),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white70, height: 16),
                    Text(
                      "Current: $_itemName (\$${_itemPrice.toStringAsFixed(0)})",
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.schedule, color: Colors.teal, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Costs ${_hoursRequired.toStringAsFixed(1)} Work Hours",
                              style: const TextStyle(
                                color: Colors.tealAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          _addSavedItem(_itemName, _itemPrice);
                          setState(() {
                            _showMiniFloatingWindow = false;
                          });
                        },
                        child: const Text(
                          "Skip & Save Money!",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1E2230),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: "Life Cost",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stars),
            label: "Decision Engine",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: "Vault",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Floating HUD",
          ),
        ],
      ),
    );
  }

  // --- TAB 1: LIFE COST CALCULATOR ---
  Widget _buildLifeCostCalculatorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Widget
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "LifeCost Converter",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Convert price tags into actual hours of labor",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.teal),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.check, color: Colors.teal, size: 14),
                    SizedBox(width: 4),
                    Text(
                      "Live Sync",
                      style: TextStyle(color: Colors.teal, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // User Income & Target Item Card
          Card(
            color: const Color(0xFF1E2230),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "1. Item Details & Income Setup",
                    style: TextStyle(
                      color: Colors.tealAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Item Name",
                      prefixIcon: Icon(Icons.edit, color: Colors.teal),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _itemName = val.isEmpty ? "Target Purchase" : val;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hourly Wage: \$${_hourlyWage.toStringAsFixed(2)}/hr",
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                            ),
                            Slider(
                              value: _hourlyWage,
                              min: 5.0,
                              max: 150.0,
                              divisions: 145,
                              activeColor: Colors.teal,
                              onChanged: (val) {
                                setState(() {
                                  _hourlyWage = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Item Price: \$${_itemPrice.toStringAsFixed(0)}",
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                            ),
                            Slider(
                              value: _itemPrice,
                              min: 10.0,
                              max: 2000.0,
                              divisions: 199,
                              activeColor: Colors.amber,
                              onChanged: (val) {
                                setState(() {
                                  _itemPrice = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Real Life Impact Summary Cards
          const Text(
            "2. True Cost in Life Energy",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildImpactMetricCard(
                title: "Work Labor Needed",
                value: "${_hoursRequired.toStringAsFixed(1)} Hours",
                subtitle: "Equals ${_daysOfWork.toStringAsFixed(1)} full work days",
                icon: Icons.schedule,
                accentColor: Colors.amber,
              ),
              _buildImpactMetricCard(
                title: "Opportunity Cost (5Y)",
                value: "\$${_futureValue5Yr.toStringAsFixed(0)}",
                subtitle: "Lost potential investment growth",
                icon: Icons.monetization_on,
                accentColor: Colors.redAccent,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Quick Action Bar
          Card(
            color: Colors.teal.withOpacity(0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.teal),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info, color: Colors.tealAccent),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Is buying '$_itemName' worth ${_hoursRequired.toStringAsFixed(1)} hours of your hard life?",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => _addSavedItem(_itemName, _itemPrice),
                          icon: const Icon(Icons.check, color: Colors.white),
                          label: const Text(
                            "I'll Pass & Save!",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      width: (MediaQuery.of(context).size.width / 2) - 22,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2230),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(
              value,
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // --- TAB 2: DECISION ENGINE ---
  Widget _buildDecisionEngineTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Impulse Decision Matrix",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            "Answer 4 quick micro-questions before tapping 'Buy'",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Dynamic Regret Gauge Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _impulseScore > 60
                    ? [Colors.teal.shade800, const Color(0xFF1E2230)]
                    : [Colors.red.shade900, const Color(0xFF1E2230)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _impulseScore > 60 ? Colors.teal : Colors.redAccent,
              ),
            ),
            child: Column(
              children: [
                const Text(
                  "PURCHASE WISDOM SCORE",
                  style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1.2),
                ),
                const SizedBox(height: 8),
                Text(
                  "$_impulseScore / 100",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: _impulseScore > 60 ? Colors.tealAccent : Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _impulseScore > 60
                      ? "✅ Safe Purchase: Low Regret Risk"
                      : "⚠️ High Impulse Warning: Reconsider!",
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Question 1
          _buildQuestionCard(
            title: "1. Is this a Need or a Want?",
            child: Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text("Absolute Need"),
                    selected: _q1NeedVsWant == 0,
                    onSelected: (val) => setState(() => _q1NeedVsWant = 0),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text("Desire / Want"),
                    selected: _q1NeedVsWant == 1,
                    onSelected: (val) => setState(() => _q1NeedVsWant = 1),
                  ),
                ),
              ],
            ),
          ),

          // Question 2
          _buildQuestionCard(
            title: "2. How often will you use this?",
            child: Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text("Daily"),
                  selected: _q2Frequency == 0,
                  onSelected: (val) => setState(() => _q2Frequency = 0),
                ),
                ChoiceChip(
                  label: const Text("Weekly"),
                  selected: _q2Frequency == 1,
                  onSelected: (val) => setState(() => _q2Frequency = 1),
                ),
                ChoiceChip(
                  label: const Text("Rarely"),
                  selected: _q2Frequency == 2,
                  onSelected: (val) => setState(() => _q2Frequency = 2),
                ),
              ],
            ),
          ),

          // Question 3
          _buildQuestionCard(
            title: "3. Can you buy this TWICE comfortably?",
            child: SwitchListTile(
              title: const Text("Yes, I have plenty of buffer.", style: TextStyle(fontSize: 13, color: Colors.white70)),
              value: _q3CanBuyTwice,
              activeColor: Colors.teal,
              onChanged: (val) => setState(() => _q3CanBuyTwice = val),
            ),
          ),

          // Question 4
          _buildQuestionCard(
            title: "4. Have you waited 24 hours?",
            child: SwitchListTile(
              title: const Text("Yes, cool-down period passed.", style: TextStyle(fontSize: 13, color: Colors.white70)),
              value: _q4Wait24Hours,
              activeColor: Colors.teal,
              onChanged: (val) => setState(() => _q4Wait24Hours = val),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard({required String title, required Widget child}) {
    return Card(
      color: const Color(0xFF1E2230),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  // --- TAB 3: IMPULSE VAULT ---
  Widget _buildImpulseVaultTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Impulse Saver Vault",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Track money kept in your pocket",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.tealAccent),
                onPressed: () => _showAddCustomSavedDialog(),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Total Saved Hero Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F5A47), Color(0xFF1E2230)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.monetization_on, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "TOTAL SAVINGS PROTECTED",
                        style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1.1),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        child: Text(
                          "\$${_totalMoneySaved.toStringAsFixed(2)}",
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

          const Text(
            "Saved Purchases Log",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 12),

          if (_savedItems.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  "No saved purchases yet! Skip an impulse buy to build your vault.",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _savedItems.length,
              itemBuilder: (context, index) {
                final item = _savedItems[index];
                return Card(
                  color: const Color(0xFF1E2230),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.check, color: Colors.white, size: 18),
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      "${item.date.day}/${item.date.month}/${item.date.year}",
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    trailing: Text(
                      "+\$${item.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.tealAccent,
                        fontWeight: FontWeight.bold,
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

  void _showAddCustomSavedDialog() {
    String customName = "";
    double customPrice = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E2230),
          title: const Text("Record Skipped Purchase", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: "Item Name",
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => customName = val,
              ),
              const SizedBox(height: 12),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Price (\$) ",
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => customPrice = double.tryParse(val) ?? 0.0,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                if (customName.isNotEmpty && customPrice > 0) {
                  _addSavedItem(customName, customPrice);
                  Navigator.pop(context);
                }
              },
              child: const Text("Save to Vault", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // --- TAB 4: FLOATING HUD & SETTINGS ---
  Widget _buildFloatingSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Floating Assistant HUD",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            "Simulate floating overlay tools and floating quick-calculators",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          Card(
            color: const Color(0xFF1E2230),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text(
                      "Display Floating Bubble Assistant",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: const Text(
                      "Keep quick cost calculator accessible everywhere",
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    value: _isFloatingOverlayActive,
                    activeColor: Colors.teal,
                    onChanged: (val) {
                      setState(() {
                        _isFloatingOverlayActive = val;
                      });
                    },
                  ),
                  const Divider(color: Colors.white70),
                  ListTile(
                    leading: const Icon(Icons.widgets, color: Colors.tealAccent),
                    title: const Text("Test Floating Alert Drawer", style: TextStyle(color: Colors.white, fontSize: 13)),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      onPressed: () {
                        setState(() {
                          _showMiniFloatingWindow = !_showMiniFloatingWindow;
                        });
                      },
                      child: const Text("Trigger HUD", style: TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            "Floating Assistant Features",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 12),

          _buildFeatureInfoTile(
            icon: Icons.schedule,
            title: "Real-Time Labor Conversion",
            desc: "Instantly converts prices into real hours you must work.",
          ),
          _buildFeatureInfoTile(
            icon: Icons.stars,
            title: "Quick Regret Score",
            desc: "Evaluates standard impulse decision matrices on the fly.",
          ),
          _buildFeatureInfoTile(
            icon: Icons.monetization_on,
            title: "One-Tap Vault Protection",
            desc: "Logs avoided impulse purchases straight into your savings vault.",
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureInfoTile({required IconData icon, required String title, required String desc}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2230),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}