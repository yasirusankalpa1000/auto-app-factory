import 'dart:async';
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
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
          primary: Colors.teal,
          secondary: Colors.amber,
          surface: const Color(0xFF1E293B),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // Global State
  double hourlyWage = 25.0;
  double totalSavedMoney = 485.0;
  double totalHoursSaved = 19.4;
  int defeatedImpulsesCount = 14;

  bool isFloatingOverlayActive = true;
  bool isNotificationShieldActive = true;
  bool isAutoInterceptActive = true;

  final List<Map<String, dynamic>> impulseHistory = [
    {
      'title': 'Wireless Earbuds',
      'price': 79.99,
      'hours': 3.2,
      'date': 'Yesterday',
      'saved': true,
    },
    {
      'title': 'Designer Sneakers',
      'price': 149.50,
      'hours': 6.0,
      'date': '3 days ago',
      'saved': true,
    },
    {
      'title': 'Late Night Fast Food',
      'price': 24.00,
      'hours': 1.0,
      'date': '5 days ago',
      'saved': true,
    },
  ];

  void _addSavedImpulse(String title, double price, double hours) {
    setState(() {
      totalSavedMoney += price;
      totalHoursSaved += hours;
      defeatedImpulsesCount += 1;
      impulseHistory.insert(0, {
        'title': title,
        'price': price,
        'hours': hours,
        'date': 'Just Now',
        'saved': true,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ShieldHubTab(
        hourlyWage: hourlyWage,
        onWageChanged: (newWage) {
          setState(() {
            hourlyWage = newWage;
          });
        },
        onImpulseDefeated: _addSavedImpulse,
        onStartCoolDown: () {
          setState(() {
            _selectedIndex = 1;
          });
        },
      ),
      CoolDownZoneTab(
        hourlyWage: hourlyWage,
        onCompleteCoolDown: (title, price, hours) {
          _addSavedImpulse(title, price, hours);
        },
      ),
      OverlayNotificationTab(
        isFloatingActive: isFloatingOverlayActive,
        isNotificationActive: isNotificationShieldActive,
        isAutoIntercept: isAutoInterceptActive,
        onToggleFloating: (val) => setState(() => isFloatingOverlayActive = val),
        onToggleNotification: (val) => setState(() => isNotificationShieldActive = val),
        onToggleIntercept: (val) => setState(() => isAutoInterceptActive = val),
      ),
      VaultStatsTab(
        totalSaved: totalSavedMoney,
        hoursSaved: totalHoursSaved,
        count: defeatedImpulsesCount,
        history: impulseHistory,
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.shield),
            label: 'Shield',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer),
            label: 'Cool-Down',
          ),
          NavigationDestination(
            icon: Icon(Icons.widgets),
            label: 'Floating Bar',
          ),
          NavigationDestination(
            icon: Icon(Icons.savings),
            label: 'Vault',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TAB 1: SHIELD HUB (CALCULATOR & INTERCEPT)
// ==========================================
class ShieldHubTab extends StatefulWidget {
  final double hourlyWage;
  final ValueChanged<double> onWageChanged;
  final Function(String, double, double) onImpulseDefeated;
  final VoidCallback onStartCoolDown;

  const ShieldHubTab({
    super.key,
    required this.hourlyWage,
    required this.onWageChanged,
    required this.onImpulseDefeated,
    required this.onStartCoolDown,
  });

  @override
  State<ShieldHubTab> createState() => _ShieldHubTabState();
}

class _ShieldHubTabState extends State<ShieldHubTab> {
  final TextEditingController _itemController = TextEditingController(text: 'Smart Watch');
  final TextEditingController _priceController = TextEditingController(text: '120');

  double calculatedHours = 4.8;
  double fiveYearLoss = 168.30;

  @override
  void initState() {
    super.initState();
    _recalculate();
  }

  void _recalculate() {
    double price = double.tryParse(_priceController.text) ?? 0.0;
    setState(() {
      calculatedHours = widget.hourlyWage > 0 ? (price / widget.hourlyWage) : 0.0;
      // 5 years at 7% annual compounding interest simulator formula
      fiveYearLoss = price * 1.4025;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
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
                        'ImpulseGuard',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Instant Spending Interceptor',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.teal),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.security, size: 16, color: Colors.teal),
                      SizedBox(width: 4),
                      Text(
                        'SHIELD ACTIVE',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Hourly Wage Setup Box
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.amber, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Hourly Take-Home Wage',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            '\$${widget.hourlyWage.toStringAsFixed(2)} / hour',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.teal),
                      onPressed: () => _showWageDialog(context),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Evaluate Micro-Purchase',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Input Fields
            TextField(
              controller: _itemController,
              decoration: const InputDecoration(
                labelText: 'Item Name / Desired Purchase',
                prefixIcon: Icon(Icons.shopping_cart),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Price (\$ USD)',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _recalculate(),
            ),
            const SizedBox(height: 20),

            // Real Life Impact Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade900, const Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.shade700),
              ),
              child: Column(
                children: [
                  const Text(
                    'REAL COST IN LIFE HOURS',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${calculatedHours.toStringAsFixed(1)} Hours',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'You must work ${calculatedHours.toStringAsFixed(1)} hours of your life solely to pay for this.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                    softWrap: true,
                  ),
                  const Divider(height: 24, color: Colors.white70),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: Column(
                          children: [
                            const Text('5-Year Opportunity Loss', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            const SizedBox(height: 2),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '\$${fiveYearLoss.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.redAccent),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(height: 30, width: 1, color: Colors.white70),
                      Flexible(
                        child: Column(
                          children: [
                            const Text('Impulse Severity', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            const SizedBox(height: 2),
                            Text(
                              calculatedHours > 5.0 ? 'HIGH RISK' : 'MODERATE',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: calculatedHours > 5.0 ? Colors.redAccent : Colors.amber,
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
            const SizedBox(height: 20),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.timer_outlined),
                label: const Text(
                  'START 60s COOL-DOWN SHIELD',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  widget.onStartCoolDown();
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.check_circle, size: 18),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('I Defeated It!'),
                    ),
                    onPressed: () {
                      double price = double.tryParse(_priceController.text) ?? 0.0;
                      widget.onImpulseDefeated(
                        _itemController.text.isEmpty ? 'Impulse Defeated' : _itemController.text,
                        price,
                        calculatedHours,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Saved \$${price.toStringAsFixed(2)}! Added to Vault.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey,
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.close, size: 18),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('I Bought It'),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logged purchase. Try cooling down next time!'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showWageDialog(BuildContext context) {
    final wageInput = TextEditingController(text: widget.hourlyWage.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set Take-Home Hourly Wage'),
        content: TextField(
          controller: wageInput,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Hourly Rate (\$)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              double val = double.tryParse(wageInput.text) ?? widget.hourlyWage;
              if (val > 0) {
                widget.onWageChanged(val);
                _recalculate();
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TAB 2: COOL-DOWN & DOPAMINE RESET GAME
// ==========================================
class CoolDownZoneTab extends StatefulWidget {
  final double hourlyWage;
  final Function(String, double, double) onCompleteCoolDown;

  const CoolDownZoneTab({
    super.key,
    required this.hourlyWage,
    required this.onCompleteCoolDown,
  });

  @override
  State<CoolDownZoneTab> createState() => _CoolDownZoneTabState();
}

class _CoolDownZoneTabState extends State<CoolDownZoneTab> {
  int _secondsRemaining = 60;
  Timer? _timer;
  bool _isRunning = false;
  int _dopamineTaps = 0;
  final int _targetTaps = 10;

  final List<String> _reflectionQuestions = [
    "Will this item matter to you in 30 days?",
    "Are you buying this out of stress, boredom, or actual need?",
    "What else could you invest this money into right now?",
    "Can you wait 24 hours before pressing buy?",
  ];

  int _questionIndex = 0;

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 60;
      _isRunning = true;
      _dopamineTaps = 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
          if (_secondsRemaining % 15 == 0) {
            _questionIndex = (_questionIndex + 1) % _reflectionQuestions.length;
          }
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isRunning = false;
        });
      }
    });
  }

  void _handleShieldTap() {
    if (_isRunning && _dopamineTaps < _targetTaps) {
      setState(() {
        _dopamineTaps++;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: const [
                Icon(Icons.psychology, color: Colors.amber, size: 28),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Dopamine Cool-Down Zone',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Break the instant dopamine loop by taking a mandatory 60-second mindfulness buffer.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Timer Circle Display
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1E293B),
                border: Border.all(
                  color: _isRunning ? Colors.teal : Colors.grey.shade700,
                  width: 4,
                ),
                boxShadow: [
                  if (_isRunning)
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '$_secondsRemaining',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: _secondsRemaining <= 10 ? Colors.redAccent : Colors.tealAccent,
                    ),
                  ),
                  const Text(
                    'SECONDS',
                    style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Reflection Question Card
            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lightbulb, color: Colors.amber, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'MIND RESET QUESTION',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _reflectionQuestions[_questionIndex],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Interactive Dopamine Reset Tap Game
            Card(
              color: Colors.teal.shade900.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.teal),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'STRESS TAPPER MINI-GAME',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap the shield below $_targetTaps times to dissipate impulse urges.',
                      style: const TextStyle(fontSize: 11, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: _handleShieldTap,
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: _dopamineTaps >= _targetTaps ? Colors.green : Colors.teal,
                        child: Icon(
                          _dopamineTaps >= _targetTaps ? Icons.check : Icons.touch_app,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Taps: $_dopamineTaps / $_targetTaps',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Control Buttons
            if (!_isRunning)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('START 60s COOL-DOWN TIMER'),
                  onPressed: _startTimer,
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                  ),
                  icon: const Icon(Icons.close),
                  label: const Text('CANCEL COOL-DOWN'),
                  onPressed: () {
                    _timer?.cancel();
                    setState(() {
                      _isRunning = false;
                    });
                  },
                ),
              ),

            const SizedBox(height: 12),
            if (_secondsRemaining == 0 || _dopamineTaps >= _targetTaps)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.star),
                  label: const Text('IMPULSE DEFEATED! CLAIM SAVINGS'),
                  onPressed: () {
                    widget.onCompleteCoolDown('Cool-Down Victory', 45.0, 1.8);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Awesome job! \$45.00 saved and added to your Vault.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// TAB 3: FLOATING OVERLAY & NOTIFICATION HUB
// ==========================================
class OverlayNotificationTab extends StatelessWidget {
  final bool isFloatingActive;
  final bool isNotificationActive;
  final bool isAutoIntercept;
  final ValueChanged<bool> onToggleFloating;
  final ValueChanged<bool> onToggleNotification;
  final ValueChanged<bool> onToggleIntercept;

  const OverlayNotificationTab({
    super.key,
    required this.isFloatingActive,
    required this.isNotificationActive,
    required this.isAutoIntercept,
    required this.onToggleFloating,
    required this.onToggleNotification,
    required this.onToggleIntercept,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.widgets, color: Colors.teal, size: 28),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Active Overlay & Floating Bar',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'ImpulseGuard works dynamically over other apps when you open Amazon, eBay, or shopping browsers.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Live Simulator Card
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: isFloatingActive ? Colors.teal : Colors.grey.shade800),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FLOATING OVERLAY BUBBLE PREVIEW',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    // Floating Bubble Mock UI
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.tealAccent.withOpacity(0.6)),
                        boxShadow: const [
                          BoxShadow(color: Colors.black87, blurRadius: 10, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.teal,
                            child: Icon(Icons.shield, size: 14, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              isFloatingActive ? 'ImpulseGuard Active | Wage: \$25/hr' : 'Overlay Disabled',
                              style: const TextStyle(fontSize: 12, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.flash_on, size: 16, color: Colors.amber),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Simulates system "Display Over Other Apps" permission. Tap the floating bubble while shopping anywhere on your phone to open instant evaluation.',
                      style: TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Permission Controls
            const Text(
              'System Shield Controls',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            SwitchListTile(
              value: isFloatingActive,
              onChanged: onToggleFloating,
              activeColor: Colors.teal,
              title: const Text('Floating Widget Bubble (Display Over Apps)'),
              subtitle: const Text('Displays quick impulse cost badge over active shopping apps.'),
            ),
            const Divider(color: Colors.white70),

            SwitchListTile(
              value: isNotificationActive,
              onChanged: onToggleNotification,
              activeColor: Colors.teal,
              title: const Text('Persistent Notification Bar Shield'),
              subtitle: const Text('Keep quick action buttons in top notification shade for fast entry.'),
            ),
            const Divider(color: Colors.white70),

            SwitchListTile(
              value: isAutoIntercept,
              onChanged: onToggleIntercept,
              activeColor: Colors.teal,
              title: const Text('Smart Shopping App Auto-Detector'),
              subtitle: const Text('Automatically alerts when e-commerce applications are opened.'),
            ),
            const SizedBox(height: 16),

            // Notification Shade Mock
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.notifications, size: 16, color: Colors.teal),
                      SizedBox(width: 6),
                      Text(
                        'NOTIFICATION SHADE BAR PREVIEW',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '🛡️ ImpulseGuard - Shopping Mode Guarded',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tap to evaluate your current online cart before checking out.',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// TAB 4: SAVINGS VAULT & LIFETIME STATS
// ==========================================
class VaultStatsTab extends StatelessWidget {
  final double totalSaved;
  final double hoursSaved;
  final int count;
  final List<Map<String, dynamic>> history;

  const VaultStatsTab({
    super.key,
    required this.totalSaved,
    required this.hoursSaved,
    required this.count,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.savings, color: Colors.green, size: 28),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Impulse Savings Vault',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Track total wealth protected and life hours reclaimed from avoided impulse buys.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Highlight Banner Cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade900.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.green.shade700),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TOTAL SAVED', style: TextStyle(fontSize: 11, color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '\$${totalSaved.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
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
                      color: Colors.teal.shade900.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.teal.shade700),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('HOURS RECLAIMED', style: TextStyle(fontSize: 11, color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${hoursSaved.toStringAsFixed(1)} hrs',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Defeated count badge
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Defeated Impulse Urges', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$count VICTORIES',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Victory History Log',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // History List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  color: const Color(0xFF1E293B),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.shield_outlined, color: Colors.white, size: 20),
                    ),
                    title: Text(
                      item['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      'Reclaimed ${item['hours'].toStringAsFixed(1)} life hours • ${item['date']}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    trailing: Text(
                      '+\$${item['price'].toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 15),
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
}