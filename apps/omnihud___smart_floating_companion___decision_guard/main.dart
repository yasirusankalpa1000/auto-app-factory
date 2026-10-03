import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const OmniHUDApp());
}

class OmniHUDApp extends StatelessWidget {
  const OmniHUDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniHUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFAFAFAF),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;

  // Floating Overlay State
  bool _isOverlayEnabled = true;
  bool _isNotificationActive = true;
  double _bubbleX = 260.0;
  double _bubbleY = 320.0;
  bool _isQuickMenuOpen = false;

  // App Stats
  double _totalSaved = 185.50;
  int _decisionsCount = 34;
  int _focusScore = 820;

  // Impulse Evaluator Inputs
  double _itemPrice = 45.0;
  double _necessityRating = 4.0; // 1 to 10
  double _hourlyWage = 18.0;
  String _evalVerdict = "";
  Color _verdictColor = Colors.grey;

  // Decision Spinner Inputs
  final TextEditingController _opt1Controller =
      TextEditingController(text: "Order Food Delivery");
  final TextEditingController _opt2Controller =
      TextEditingController(text: "Cook Home Meal");
  String _spottedChoice = "";
  bool _isSpinning = false;

  // History Log
  final List<Map<String, String>> _historyLog = [
    {
      'title': 'Online Sneakers (\$75)',
      'action': 'Skipped Purchase',
      'impact': '+\$75 Saved',
      'time': '2 hrs ago'
    },
    {
      'title': 'Lunch Decision',
      'action': 'Cook Home Meal',
      'impact': 'Choice Resolved',
      'time': '5 hrs ago'
    },
    {
      'title': 'Coffee Subscription',
      'action': 'Approved Purchase',
      'impact': 'Smart Buy',
      'time': 'Yesterday'
    },
  ];

  @override
  void initState() {
    super.initState();
    _calculateImpulseVerdict();
  }

  @override
  void dispose() {
    _opt1Controller.dispose();
    _opt2Controller.dispose();
    super.dispose();
  }

  void _calculateImpulseVerdict() {
    double hoursNeeded = _hourlyWage > 0 ? (_itemPrice / _hourlyWage) : 0;
    double score = (_necessityRating * 10) - (hoursNeeded * 2.5);

    setState(() {
      if (score >= 55) {
        _evalVerdict =
            "SMART BUY: High utility. You need to work ${hoursNeeded.toStringAsFixed(1)} hours for this.";
        _verdictColor = Colors.green;
      } else if (score >= 30) {
        _evalVerdict =
            "WAIT 24 HOURS: Borderline impulse. Sleep on this purchase before paying \$${_itemPrice.toStringAsFixed(2)}.";
        _verdictColor = Colors.amber;
      } else {
        _evalVerdict =
            "IMPULSE ALERT: High regret risk! Costs ${hoursNeeded.toStringAsFixed(1)} hours of labor. Better skip it.";
        _verdictColor = Colors.red;
      }
    });
  }

  void _spinChoice() async {
    if (_opt1Controller.text.trim().isEmpty ||
        _opt2Controller.text.trim().isEmpty) {
      return;
    }
    setState(() {
      _isSpinning = true;
      _spottedChoice = "";
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    final random = Random();
    final chosen = random.nextBool()
        ? _opt1Controller.text.trim()
        : _opt2Controller.text.trim();

    setState(() {
      _isSpinning = false;
      _spottedChoice = chosen;
      _decisionsCount++;
      _historyLog.insert(0, {
        'title': '${_opt1Controller.text} vs ${_opt2Controller.text}',
        'action': chosen,
        'impact': 'Choice Resolved',
        'time': 'Just now'
      });
    });
  }

  void _skipPurchaseAndSave() {
    setState(() {
      _totalSaved += _itemPrice;
      _decisionsCount++;
      _focusScore += 25;
      _historyLog.insert(0, {
        'title': 'Item (\$${_itemPrice.toStringAsFixed(2)})',
        'action': 'Skipped Purchase',
        'impact': '+\$${_itemPrice.toStringAsFixed(2)} Saved',
        'time': 'Just now'
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Awesome! You added \$${_itemPrice.toStringAsFixed(2)} to your savings vault.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Main Body Navigator
          SafeArea(
            child: Column(
              children: [
                // Simulated Sticky System Status Bar Preview
                if (_isNotificationActive) _buildFloatingNotificationBar(),

                // App Header
                _buildHeader(),

                // Active Tab Content Screen
                Expanded(
                  child: IndexedStack(
                    index: _currentTabIndex,
                    children: [
                      _buildDashboardTab(),
                      _buildImpulseEvaluatorTab(),
                      _buildTieBreakerTab(),
                      _buildSettingsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Interactive Overlay Bubble Simulator (Draggable over whole screen)
          if (_isOverlayEnabled)
            Positioned(
              left: _bubbleX.clamp(10.0, screenSize.width - 70.0),
              top: _bubbleY.clamp(40.0, screenSize.height - 120.0),
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubbleX += details.delta.dx;
                    _bubbleY += details.delta.dy;
                  });
                },
                onTap: () {
                  setState(() {
                    _isQuickMenuOpen = !_isQuickMenuOpen;
                  });
                },
                child: _buildFloatingBubbleUI(),
              ),
            ),

          // Dynamic Quick Action Popup overlay from Bubble
          if (_isOverlayEnabled && _isQuickMenuOpen)
            Positioned(
              left: (_bubbleX - 110.0).clamp(10.0, screenSize.width - 230.0),
              top: (_bubbleY - 140.0).clamp(50.0, screenSize.height - 200.0),
              child: _buildQuickActionPopup(),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
            _isQuickMenuOpen = false;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'HUD View',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Impulse Guard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.casino),
            label: 'Tie-Breaker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Controls',
          ),
        ],
      ),
    );
  }

  // --- TOP HEADER ---
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.layers, color: Colors.indigo, size: 24),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'OmniHUD',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Live Smart Screen Guard',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on,
                    color: Colors.green, size: 16),
                const SizedBox(width: 4),
                Text(
                  '\$${_totalSaved.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- FLOATING NOTIFICATION BANNER PREVIEW ---
  Widget _buildFloatingNotificationBar() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.indigo.shade900,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.bolt, color: Colors.amber, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'OmniHUD Floating Guard is active in background',
              style: const TextStyle(color: Colors.white, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isNotificationActive = false;
              });
            },
            child: const Icon(Icons.close, color: Colors.white70, size: 18),
          ),
        ],
      ),
    );
  }

  // --- TAB 1: DASHBOARD ---
  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat Overview Cards
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Saved Vault',
                  value: '\$${_totalSaved.toStringAsFixed(0)}',
                  subtitle: 'Avoided Impulses',
                  icon: Icons.monetization_on,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: 'Choices Solved',
                  value: '$_decisionsCount',
                  subtitle: 'No Fatigue',
                  icon: Icons.check_circle,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(width: 0, height: 12),
          _buildMetricCard(
            title: 'Focus Level Score',
            value: '$_focusScore PTS',
            subtitle: 'Micro-Habit Efficiency',
            icon: Icons.auto_awesome,
            color: Colors.amber,
          ),

          const SizedBox(height: 20),

          // Floating Bubble Control Status Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.touch_app, color: Colors.indigo, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Floating Screen Companion',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Drag the floating widget anywhere on screen. Tap it while browsing apps or shopping!',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'Recent Daily Decisions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // History ListView
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _historyLog.length,
            itemBuilder: (context, index) {
              final item = _historyLog[index];
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 8),
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.withOpacity(0.15)),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.withOpacity(0.1),
                    child: const Icon(Icons.history,
                        color: Colors.indigo, size: 20),
                  ),
                  title: Text(
                    item['title'] ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${item['action']} • ${item['time']}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Container(
                    padding:
                        const EdgeInsets.horizontal(8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item['impact'] ?? '',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
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

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(fontSize: 11, color: color),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: IMPULSE EVALUATOR ---
  Widget _buildImpulseEvaluatorTab() {
    double hoursWorked = _hourlyWage > 0 ? (_itemPrice / _hourlyWage) : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.shopping_bag, color: Colors.indigo),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '10-Second Impulse Buyer Guard',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Before adding to cart, evaluate if this item is worth your labor hours.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Price Slider Input
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Item Price:'),
                    Text(
                      '\$${_itemPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                Slider(
                  value: _itemPrice,
                  min: 5.0,
                  max: 300.0,
                  divisions: 59,
                  activeColor: Colors.indigo,
                  label: '\$${_itemPrice.toStringAsFixed(0)}',
                  onChanged: (val) {
                    setState(() {
                      _itemPrice = val;
                      _calculateImpulseVerdict();
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Necessity Rating Slider
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Necessity / Joy Rating (1-10):'),
                    Text(
                      '${_necessityRating.toInt()} / 10',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                Slider(
                  value: _necessityRating,
                  min: 1.0,
                  max: 10.0,
                  divisions: 9,
                  activeColor: Colors.indigo,
                  label: '${_necessityRating.toInt()}',
                  onChanged: (val) {
                    setState(() {
                      _necessityRating = val;
                      _calculateImpulseVerdict();
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Hourly Wage Input
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Your Estimated Hourly Earnings:'),
                    Text(
                      '\$${_hourlyWage.toStringAsFixed(0)}/hr',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                Slider(
                  value: _hourlyWage,
                  min: 8.0,
                  max: 100.0,
                  divisions: 23,
                  activeColor: Colors.indigo,
                  label: '\$${_hourlyWage.toStringAsFixed(0)}',
                  onChanged: (val) {
                    setState(() {
                      _hourlyWage = val;
                      _calculateImpulseVerdict();
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Verdict Display Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _verdictColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _verdictColor, width: 1.5),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      _verdictColor == Colors.green
                          ? Icons.check_circle
                          : (_verdictColor == Colors.amber
                              ? Icons.info
                              : Icons.cancel),
                      color: _verdictColor,
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _evalVerdict,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _verdictColor,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Labor cost: ${hoursWorked.toStringAsFixed(1)} Work Hours',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _verdictColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _skipPurchaseAndSave,
                      child: const Text('Skip & Save \$'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 3: TIE-BREAKER ---
  Widget _buildTieBreakerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.casino, color: Colors.indigo),
              SizedBox(width: 8),
              Text(
                'Rapid Choice Tie-Breaker',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Stop overthinking micro-decisions. Input two choices and let OmniHUD decide.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          TextField(
            controller: _opt1Controller,
            decoration: const InputDecoration(
              labelText: 'Option 1',
              prefixIcon: Icon(Icons.looks_one),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _opt2Controller,
            decoration: const InputDecoration(
              labelText: 'Option 2',
              prefixIcon: Icon(Icons.looks_two),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _isSpinning ? null : _spinChoice,
              icon: _isSpinning
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.refresh),
              label: Text(
                _isSpinning ? 'SPINNING...' : 'BREAK TIE NOW',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 24),

          if (_spottedChoice.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Column(
                children: [
                  const Text(
                    'DECISION VERDICT',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _spottedChoice,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Commit to this choice now and move on with your day!',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // --- TAB 4: SETTINGS & OVERLAY CONTROLS ---
  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Overlay Controls',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Configure how OmniHUD sits above your daily phone experience.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary:
                      const Icon(Icons.layers, color: Colors.indigo),
                  title: const Text('Floating HUD Widget'),
                  subtitle: const Text(
                      'Shows interactive quick bubble overlay on screen'),
                  value: _isOverlayEnabled,
                  onChanged: (val) {
                    setState(() {
                      _isOverlayEnabled = val;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications,
                      color: Colors.indigo),
                  title: const Text('Sticky Status Notification Bar'),
                  subtitle: const Text(
                      'Live background decision bar preview'),
                  value: _isNotificationActive,
                  onChanged: (val) {
                    setState(() {
                      _isNotificationActive = val;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Permission status indicators
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Permission Status',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 10),
                _buildPermissionRow('Display over other apps', true),
                const SizedBox(height: 8),
                _buildPermissionRow('Notification Access', true),
                const SizedBox(height: 8),
                _buildPermissionRow('Usage Access (Context)', true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRow(String title, bool granted) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 13)),
        Wrap(
          crossAxisAlignment: WrapCrossAxisAlignment.center,
          children: [
            Icon(
              granted ? Icons.check_circle : Icons.cancel,
              color: granted ? Colors.green : Colors.red,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              granted ? 'Granted' : 'Missing',
              style: TextStyle(
                fontSize: 12,
                color: granted ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- FLOATING OVERLAY BUBBLE UI ---
  Widget _buildFloatingBubbleUI() {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: Colors.indigo,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Center(
        child: Icon(
          Icons.bolt,
          color: Colors.amber,
          size: 32,
        ),
      ),
    );
  }

  // --- FLOATING QUICK ACTION POPUP ---
  Widget _buildQuickActionPopup() {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.indigo.shade900,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'OmniHUD Quick Tools',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isQuickMenuOpen = false;
                  });
                },
                child: const Icon(Icons.close, color: Colors.white70, size: 16),
              ),
            ],
          ),
          const Divider(color: Colors.white70, height: 16),
          _buildQuickActionButton(
            label: 'Quick Impulse Check',
            icon: Icons.shopping_bag,
            onTap: () {
              setState(() {
                _currentTabIndex = 1;
                _isQuickMenuOpen = false;
              });
            },
          ),
          const SizedBox(height: 6),
          _buildQuickActionButton(
            label: 'Random Tie-Breaker',
            icon: Icons.casino,
            onTap: () {
              setState(() {
                _currentTabIndex = 2;
                _isQuickMenuOpen = false;
              });
            },
          ),
          const SizedBox(height: 6),
          _buildQuickActionButton(
            label: 'Log Quick Decision',
            icon: Icons.check_circle,
            onTap: () {
              setState(() {
                _decisionsCount++;
                _isQuickMenuOpen = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged 1 decision resolved!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.amber, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}