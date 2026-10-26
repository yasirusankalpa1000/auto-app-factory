import 'package:flutter/material.dart';

void main() {
  runApp(const MicroPulseApp());
}

class MicroPulseApp extends StatelessWidget {
  const MicroPulseApp({Key? key}) : super(key:Key? key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MicroPulse HUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
          surface: const Color(0xFF1E293B),
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  // Global State for Impulse Vault
  double _hourlyWage = 20.0;
  double _totalSavedMoney = 145.0;
  int _avoidedImpulsesCount = 4;
  final List<Map<String, dynamic>> _savedVaultItems = [
    {'title': 'Designer Sneakers', 'cost': 85.0, 'hours': 4.25, 'date': 'Yesterday'},
    {'title': 'Late Night Food Delivery', 'cost': 35.0, 'hours': 1.75, 'date': '3 days ago'},
    {'title': 'Unused Gaming Subscription', 'cost': 25.0, 'hours': 1.25, 'date': 'Last week'},
  ];

  // Simulated Overlay Banner state
  bool _showFloatingBanner = false;
  String _bannerMessage = "Floating HUD Overlay Active - MicroPulse Ready";

  void _triggerFloatingBanner(String message) {
    setState(() {
      _bannerMessage = message;
      _showFloatingBanner = true;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showFloatingBanner = false;
        });
      }
    });
  }

  void _addSavedImpulse(String title, double cost) {
    setState(() {
      double hoursSaved = cost / (_hourlyWage > 0 ? _hourlyWage : 1);
      _savedVaultItems.insert(0, {
        'title': title,
        'cost': cost,
        'hours': hoursSaved,
        'date': 'Just now',
      });
      _totalSavedMoney += cost;
      _avoidedImpulsesCount += 1;
    });
    _triggerFloatingBanner('Saved \$${cost.toStringAsFixed(2)}! Avoided wasting ${(cost / _hourlyWage).toStringAsFixed(1)} hrs of work.');
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      FloatingHudStudioPage(
        onTriggerBanner: _triggerFloatingBanner,
        hourlyWage: _hourlyWage,
      ),
      ImpulseCalculatorPage(
        hourlyWage: _hourlyWage,
        totalSavedMoney: _totalSavedMoney,
        avoidedCount: _avoidedImpulsesCount,
        vaultItems: _savedVaultItems,
        onWageChanged: (newWage) {
          setState(() {
            _hourlyWage = newWage;
          });
        },
        onSaveImpulse: _addSavedImpulse,
      ),
      MicroDecisionWizardPage(
        onDecisionComplete: (result) {
          _triggerFloatingBanner('Decision Resolved: $result');
        },
      ),
      FloatingOverlaySettingsPage(
        onSimulateAlert: (msg) {
          _triggerFloatingBanner(msg);
        },
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Active Page Body
            Positioned.fill(
              child: IndexedStack(
                index: _currentIndex,
                children: pages,
              ),
            ),

            // Top Dynamic Floating Notification Overlay Banner
            if (_showFloatingBanner)
              Positioned(
                top: 12,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.teal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade800,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.tealAccent, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_active, color: Colors.tealAccent),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _bannerMessage,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70, size: 18),
                          onPressed: () {
                            setState(() {
                              _showFloatingBanner = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF334155), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF0F172A),
          selectedItemColor: Colors.tealAccent,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              label: 'Floating HUD',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on),
              label: 'Life Cost',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.alt_route),
              label: 'Decisions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Overlay Studio',
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// TAB 1: FLOATING HUD STUDIO
// ==========================================
class FloatingHudStudioPage extends StatefulWidget {
  final Function(String) onTriggerBanner;
  final double hourlyWage;

  const FloatingHudStudioPage({
    Key? key,
    required this.onTriggerBanner,
    required this.hourlyWage,
  }) : super(key: key);

  @override
  State<FloatingHudStudioPage> createState() => _FloatingHudStudioPageState();
}

class _FloatingHudStudioPageState extends State<FloatingHudStudioPage> {
  // Draggable HUD coordinates
  double _hudX = 25.0;
  double _hudY = 120.0;
  bool _isExpanded = false;
  String _hudStatus = "Monitoring Impulse Radar";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Floating HUD Simulator',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        softWrap: true,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Interactive screen-overlay helper demo',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                        softWrap: true,
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
                      Icon(Icons.stars, color: Colors.tealAccent, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Active',
                        style: TextStyle(color: Colors.tealAccent, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Canvas Box with Draggable HUD widget inside
            Container(
              height: 380,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF334155), width: 1.5),
              ),
              child: Stack(
                children: [
                  // Simulated Phone Display Canvas Background
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.touch_app, size: 48, color: Colors.grey.shade700),
                          const SizedBox(height: 12),
                          Text(
                            'Drag the Floating HUD Bubble anywhere on this canvas',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap bubble to open quick-action overlay',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.tealAccent.withOpacity(0.7), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Draggable HUD Bubble Widget
                  Positioned(
                    left: _hudX,
                    top: _hudY,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          _hudX += details.delta.dx;
                          _hudY += details.delta.dy;
                          // Constrain inside bounds
                          if (_hudX < 10) _hudX = 10;
                          if (_hudX > 250) _hudX = 250;
                          if (_hudY < 10) _hudY = 10;
                          if (_hudY > 280) _hudY = 280;
                        });
                      },
                      onTap: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isExpanded ? const Color(0xFF0F172A) : Colors.teal.shade700,
                          borderRadius: BorderRadius.circular(_isExpanded ? 16 : 30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.tealAccent.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ],
                          border: Border.all(color: Colors.tealAccent, width: 1.5),
                        ),
                        child: _isExpanded
                            ? SizedBox(
                                width: 180,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'MicroPulse HUD',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                        ),
                                        Icon(Icons.close, color: Colors.grey.shade400, size: 16),
                                      ],
                                    ),
                                    const Divider(color: Colors.grey, height: 12),
                                    Text(
                                      'Status: $_hudStatus',
                                      style: const TextStyle(color: Colors.tealAccent, fontSize: 11),
                                      softWrap: true,
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.teal,
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          onPressed: () {
                                            widget.onTriggerBanner('Micro-Check: Do you really need this spend?');
                                          },
                                          child: const Text('Quick Check', style: TextStyle(fontSize: 10, color: Colors.white)),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.indigo,
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          onPressed: () {
                                            widget.onTriggerBanner('Focus Shield Enabled. 15min timer active.');
                                          },
                                          child: const Text('Shield Mode', style: TextStyle(fontSize: 10, color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.bolt, color: Colors.white, size: 20),
                                  SizedBox(width: 6),
                                  Text(
                                    'HUD Active',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Floating Controls Bar
            const Text(
              'HUD Operational Modes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildModeChip('Impulse Shield', Icons.security, true, () {
                  setState(() {
                    _hudStatus = "Impulse Shield Active";
                  });
                  widget.onTriggerBanner('Mode Switched: Impulse Shield Active');
                }),
                _buildModeChip('Focus Guard', Icons.center_focus_strong, false, () {
                  setState(() {
                    _hudStatus = "Focus Guard Active";
                  });
                  widget.onTriggerBanner('Mode Switched: Focus Guard Active');
                }),
                _buildModeChip('Budget Monitor', Icons.attach_money, false, () {
                  setState(() {
                    _hudStatus = "Budget Monitor Active";
                  });
                  widget.onTriggerBanner('Mode Switched: Budget Monitor Active');
                }),
              ],
            ),
            const SizedBox(height: 20),

            // Direct Action Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lightbulb, color: Colors.amber),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Why Use Floating Overlay?',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                          softWrap: true,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Keep MicroPulse floating on your screen while shopping online to instantly catch unnecessary purchases.',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                          softWrap: true,
                        ),
                      ],
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

  Widget _buildModeChip(String label, IconData icon, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isActive ? Colors.tealAccent : const Color(0xFF334155)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isActive ? Colors.tealAccent : Colors.grey),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// TAB 2: IMPULSE & LIFE COST CONVERTER
// ==========================================
class ImpulseCalculatorPage extends StatefulWidget {
  final double hourlyWage;
  final double totalSavedMoney;
  final int avoidedCount;
  final List<Map<String, dynamic>> vaultItems;
  final Function(double) onWageChanged;
  final Function(String, double) onSaveImpulse;

  const ImpulseCalculatorPage({
    Key? key,
    required this.hourlyWage,
    required this.totalSavedMoney,
    required this.avoidedCount,
    required this.vaultItems,
    required this.onWageChanged,
    required this.onSaveImpulse,
  }) : super(key: key);

  @override
  State<ImpulseCalculatorPage> createState() => _ImpulseCalculatorPageState();
}

class _ImpulseCalculatorPageState extends State<ImpulseCalculatorPage> {
  final TextEditingController _itemController = TextEditingController(text: 'New Shoes');
  final TextEditingController _priceController = TextEditingController(text: '60');
  final TextEditingController _wageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _wageController.text = widget.hourlyWage.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _itemController.dispose();
    _priceController.dispose();
    _wageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double price = double.tryParse(_priceController.text) ?? 0.0;
    double wage = double.tryParse(_wageController.text) ?? 20.0;
    double hoursNeeded = wage > 0 ? (price / wage) : 0;
    double daysOfFreedomLost = hoursNeeded / 8.0; // 8 hr work day

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Life-Cost Impulse Engine',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              softWrap: true,
            ),
            const SizedBox(height: 4),
            const Text(
              'Convert item prices into hours of your actual life worked.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              softWrap: true,
            ),
            const SizedBox(height: 16),

            // Saved Metrics Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.teal.withOpacity(0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Money Saved', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 4),
                        FittedBox(
                          child: Text(
                            '\$${widget.totalSavedMoney.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.tealAccent, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.amber.withOpacity(0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Impulses Avoided', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 4),
                        FittedBox(
                          child: Text(
                            '${widget.avoidedCount} Items',
                            style: const TextStyle(color: Colors.amberAccent, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Interactive Input Form
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Evaluate Potential Purchase', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                  const SizedBox(height: 12),

                  // Item Name & Hourly Wage Row
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _itemController,
                          decoration: const InputDecoration(
                            labelText: 'Item Name',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: _wageController,
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            double? w = double.tryParse(val);
                            if (w != null && w > 0) widget.onWageChanged(w);
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                            labelText: 'Wage/Hr (\$)',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Price Input
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    onChanged: (val) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Item Cost (\$)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money, size: 18),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Computed Real-Life Cost Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'REAL COST IN HUMAN LABOR',
                          style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${hoursNeeded.toStringAsFixed(1)} ',
                              style: const TextStyle(color: Colors.redAccent, fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              'Hours of Work',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Equals ~${daysOfFreedomLost.toStringAsFixed(2)} work days spent working strictly for this item.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            if (price > 0 && _itemController.text.isNotEmpty) {
                              widget.onSaveImpulse(_itemController.text, price);
                            }
                          },
                          icon: const Icon(Icons.check, color: Colors.white, size: 18),
                          label: const Text('I Resisted! Save to Vault', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Vault List
            const Text(
              'Impulse Savings Vault',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.vaultItems.length,
              itemBuilder: (context, index) {
                final item = widget.vaultItems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: const Color(0xFF1E293B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFF334155)),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.star, color: Colors.tealAccent, size: 18),
                    ),
                    title: Text(
                      item['title'].toString(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      softWrap: true,
                    ),
                    subtitle: Text(
                      'Saved ${(item['hours'] as double).toStringAsFixed(1)} hrs of life (${item['date']})',
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                      softWrap: true,
                    ),
                    trailing: Text(
                      '+\$${(item['cost'] as double).toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 14),
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

// ==========================================
// TAB 3: MICRO-DECISION WIZARD
// ==========================================
class MicroDecisionWizardPage extends StatefulWidget {
  final Function(String) onDecisionComplete;

  const MicroDecisionWizardPage({Key? key, required this.onDecisionComplete}) : super(key: key);

  @override
  State<MicroDecisionWizardPage> createState() => _MicroDecisionWizardPageState();
}

class _MicroDecisionWizardPageState extends State<MicroDecisionWizardPage> {
  int _step = 0;
  String _selectedCategory = '';
  String _urgency = '';
  String _impact = '';
  String _recommendation = '';

  void _resetWizard() {
    setState(() {
      _step = 0;
      _selectedCategory = '';
      _urgency = '';
      _impact = '';
      _recommendation = '';
    });
  }

  void _computeRecommendation() {
    String rec = '';
    if (_urgency == 'High' && _impact == 'High') {
      rec = 'DO IT NOW: High impact & urgent. Block out 20 mins of focus immediately.';
    } else if (_urgency == 'Low' && _impact == 'High') {
      rec = 'SCHEDULE IT: High value long term. Put a reminder for tonight or weekend.';
    } else if (_urgency == 'High' && _impact == 'Low') {
      rec = 'DELEGATE OR LIMIT: Minor task. Set a 5-minute fast timer or pass it on.';
    } else {
      rec = 'DROP IT: Low urgency & low impact. You are overthinking a minor detail.';
    }

    setState(() {
      _recommendation = rec;
      _step = 3;
    });
    widget.onDecisionComplete(_recommendation);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
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
                        'Micro-Decision Wizard',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        softWrap: true,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Resolve daily micro-dilemmas in under 30 seconds',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.tealAccent),
                  onPressed: _resetWizard,
                  tooltip: 'Reset Wizard',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Step Indicator
            Row(
              children: [
                _buildStepBadge(1, 'Category', _step >= 0),
                Expanded(child: Container(height: 2, color: _step >= 1 ? Colors.teal : Colors.grey.shade800)),
                _buildStepBadge(2, 'Urgency', _step >= 1),
                Expanded(child: Container(height: 2, color: _step >= 2 ? Colors.teal : Colors.grey.shade800)),
                _buildStepBadge(3, 'Impact', _step >= 2),
              ],
            ),
            const SizedBox(height: 24),

            // Step 0: Category Selection
            if (_step == 0) ...[
              const Text('What kind of micro-decision is on your mind?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
              const SizedBox(height: 12),
              _buildCategoryOption('Unplanned Purchase', Icons.shopping_bag, 'Evaluating spending on an item right now'),
              _buildCategoryOption('Task Procrastination', Icons.schedule, 'Unsure whether to start a difficult task'),
              _buildCategoryOption('Digital Distraction', Icons.phone_android, 'Tempted to scroll social media or video feeds'),
              _buildCategoryOption('Social / Request Response', Icons.people, 'Deciding whether to say yes or no to someone'),
            ],

            // Step 1: Urgency Selection
            if (_step == 1) ...[
              Text('Category: $_selectedCategory', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('How urgent is this decision or task?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
              const SizedBox(height: 12),
              _buildSelectionButton('High Urgency', 'Must be addressed in the next 1 hour', () {
                setState(() {
                  _urgency = 'High';
                  _step = 2;
                });
              }),
              const SizedBox(height: 10),
              _buildSelectionButton('Low Urgency', 'Can safely wait until tomorrow without immediate consequence', () {
                setState(() {
                  _urgency = 'Low';
                  _step = 2;
                });
              }),
            ],

            // Step 2: Impact Selection
            if (_step == 2) ...[
              Text('Urgency: $_urgency', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('What is the long-term impact on your goals or life?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
              const SizedBox(height: 12),
              _buildSelectionButton('High Impact', 'Significantly affects my health, finances, or progress', () {
                _impact = 'High';
                _computeRecommendation();
              }),
              const SizedBox(height: 10),
              _buildSelectionButton('Low Impact', 'Minor routine event with almost zero long-term footprint', () {
                _impact = 'Low';
                _computeRecommendation();
              }),
            ],

            // Step 3: Recommendation Result
            if (_step == 3) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.tealAccent, width: 1.5),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.stars, color: Colors.tealAccent, size: 40),
                    const SizedBox(height: 12),
                    const Text('WIZARD RECOMMENDATION', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      _recommendation,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      onPressed: _resetWizard,
                      child: const Text('Resolve Another Decision', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStepBadge(int number, String label, bool active) {
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: active ? Colors.teal : const Color(0xFF334155),
          child: Text(
            '$number',
            style: TextStyle(color: active ? Colors.white : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: active ? Colors.white : Colors.grey, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildCategoryOption(String title, IconData icon, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedCategory = title;
            _step = 1;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.tealAccent, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14), softWrap: true),
                    Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 11), softWrap: true),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionButton(String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14), softWrap: true),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12), softWrap: true),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// TAB 4: FLOATING OVERLAY & SYSTEM STUDIO
// ==========================================
class FloatingOverlaySettingsPage extends StatefulWidget {
  final Function(String) onSimulateAlert;

  const FloatingOverlaySettingsPage({Key? key, required this.onSimulateAlert}) : super(key: key);

  @override
  State<FloatingOverlaySettingsPage> createState() => _FloatingOverlaySettingsPageState();
}

class _FloatingOverlaySettingsPageState extends State<FloatingOverlaySettingsPage> {
  bool _permissionOverlayGranted = true;
  bool _permissionNotificationGranted = true;
  bool _autoDetectShoppingApps = true;
  bool _soundVibrationAlert = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overlay & Notification Studio',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              softWrap: true,
            ),
            const SizedBox(height: 4),
            const Text(
              'Manage device permissions and dynamic overlay behavior',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              softWrap: true,
            ),
            const SizedBox(height: 16),

            // System Permission Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Device Permissions', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15)),
                  const SizedBox(height: 12),

                  SwitchListTile(
                    value: _permissionOverlayGranted,
                    activeColor: Colors.tealAccent,
                    title: const Text('Display Above Other Apps', style: TextStyle(fontSize: 13, color: Colors.white)),
                    subtitle: const Text('Required for floating quick-action HUD bubble', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    onChanged: (val) {
                      setState(() {
                        _permissionOverlayGranted = val;
                      });
                      widget.onSimulateAlert(val ? 'Overlay permission granted' : 'Overlay permission disabled');
                    },
                  ),
                  const Divider(color: Color(0xFF334155)),
                  SwitchListTile(
                    value: _permissionNotificationGranted,
                    activeColor: Colors.tealAccent,
                    title: const Text('Floating Banner Notifications', style: TextStyle(fontSize: 13, color: Colors.white)),
                    subtitle: const Text('Show top impulse warning alerts in real time', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    onChanged: (val) {
                      setState(() {
                        _permissionNotificationGranted = val;
                      });
                      widget.onSimulateAlert(val ? 'Notification permission active' : 'Notification permission disabled');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Dynamic Context Rules
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Smart Automation Rules', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15)),
                  const SizedBox(height: 12),

                  SwitchListTile(
                    value: _autoDetectShoppingApps,
                    activeColor: Colors.tealAccent,
                    title: const Text('Auto-Pop HUD on Shopping Apps', style: TextStyle(fontSize: 13, color: Colors.white)),
                    subtitle: const Text('Triggers floating overlay when opening browser/store', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    onChanged: (val) {
                      setState(() {
                        _autoDetectShoppingApps = val;
                      });
                    },
                  ),
                  const Divider(color: Color(0xFF334155)),
                  SwitchListTile(
                    value: _soundVibrationAlert,
                    activeColor: Colors.tealAccent,
                    title: const Text('Haptic Impulse Warning', style: TextStyle(fontSize: 13, color: Colors.white)),
                    subtitle: const Text('Vibrate phone when impulse spending is detected', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    onChanged: (val) {
                      setState(() {
                        _soundVibrationAlert = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Test Floating Banner Triggers
            const Text('Test Overlay Notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade800),
                  onPressed: () {
                    widget.onSimulateAlert('🛒 Shopping Site Detected! Remember your \$20/hr work value.');
                  },
                  icon: const Icon(Icons.shopping_cart, size: 16, color: Colors.white),
                  label: const Text('Simulate Shopping Alert', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade800),
                  onPressed: () {
                    widget.onSimulateAlert('⏰ 15-Minute Screen Time Pulse: Take a deep breath.');
                  },
                  icon: const Icon(Icons.timer_outlined, size: 16, color: Colors.white),
                  label: const Text('Simulate Screen Pulse', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}