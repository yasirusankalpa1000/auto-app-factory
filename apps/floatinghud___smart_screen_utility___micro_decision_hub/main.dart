import 'package:flutter/material.dart';

void main() {
  runApp(const FloatingHUDApp());
}

class FloatingHUDApp extends StatelessWidget {
  const FloatingHUDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatingHUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainHUDOverlayScreen(),
    );
  }
}

class MainHUDOverlayScreen extends StatefulWidget {
  const MainHUDOverlayScreen({super.key});

  @override
  State<MainHUDOverlayScreen> createState() => _MainHUDOverlayScreenState();
}

class _MainHUDOverlayScreenState extends State<MainHUDOverlayScreen> {
  int _selectedTab = 0;
  
  // App Stats & System Overlay States
  bool _overlayPermissionGranted = true;
  bool _notificationPermissionGranted = true;
  bool _hudActive = true;
  
  // Wage Calc State
  double _hourlyWage = 25.0;
  double _itemPrice = 149.99;
  
  // Floating Snippets / Notes State
  final List<String> _quickSnippets = [
    'Wi-Fi Pass: Guest2025#Pass',
    'Delivery Note: Leave at front porch',
    'Tax ID: 884-209-1100',
  ];
  final TextEditingController _snippetController = TextEditingController();

  // Screen Tint
  double _screenFilterOpacity = 0.15;
  Color _screenTint = Colors.amber;

  // Decision Engine State
  final List<String> _dilemmaOptions = ['Order Salad', 'Cook Pasta', 'Eat Fruits'];
  String _decisionResult = 'Tap spin to choose!';
  final TextEditingController _dilemmaInput = TextEditingController();

  // Bubble Drag Offset for Simulated Canvas
  Offset _bubbleOffset = const Offset(20, 120);

  @override
  void dispose() {
    _snippetController.dispose();
    _dilemmaInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.layers, color: Colors.indigoAccent),
            SizedBox(width: 8),
            Text(
              'FloatingHUD Studio',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            icon: Icon(
              _hudActive ? Icons.bolt : Icons.power_settings_new,
              color: _hudActive ? Colors.green : Colors.grey,
            ),
            tooltip: 'Toggle HUD Floating Service',
            onPressed: () {
              setState(() {
                _hudActive = !_hudActive;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_hudActive
                      ? 'Floating HUD Overlay Enabled!'
                      : 'HUD Service Suspended'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status Permission Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFF1E293B),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildPermissionChip(
                      label: 'Draw Over Apps',
                      active: _overlayPermissionGranted,
                      onTap: () {
                        setState(() {
                          _overlayPermissionGranted = !_overlayPermissionGranted;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildPermissionChip(
                      label: 'Floating Notifications',
                      active: _notificationPermissionGranted,
                      onTap: () {
                        setState(() {
                          _notificationPermissionGranted =
                              !_notificationPermissionGranted;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      avatar: CircleAvatar(
                        backgroundColor: _hudActive ? Colors.green : Colors.red,
                        radius: 5,
                      ),
                      label: Text(
                        _hudActive ? 'HUD ACTIVE' : 'HUD OFF',
                        style: const TextStyle(fontSize: 11, color: Colors.white),
                      ),
                      backgroundColor: Colors.black87,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedTab,
                children: [
                  _buildOverlayPreviewTab(),
                  _buildWageCostCalculatorTab(),
                  _buildMicroDecisionTab(),
                  _buildQuickTrayTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: (idx) {
          setState(() {
            _selectedTab = idx;
          });
        },
        backgroundColor: const Color(0xFF1E293B),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.widgets),
            label: 'Floating Overlay',
          ),
          NavigationDestination(
            icon: Icon(Icons.monetization_on),
            label: 'Wage Cost Evaluator',
          ),
          NavigationDestination(
            icon: Icon(Icons.casino),
            label: 'Micro Dilemma',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_copy),
            label: 'Quick Tray',
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionChip({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: active ? Colors.indigo.withAlpha(80) : Colors.red.withAlpha(80),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active ? Colors.indigoAccent : Colors.redAccent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              active ? Icons.check_circle : Icons.warning_amber,
              size: 14,
              color: active ? Colors.greenAccent : Colors.redAccent,
            ),
            const SizedBox(width: 4),
            Text(
              '$label: ${active ? "ENABLED" : "TAP TO ALLOW"}',
              style: const TextStyle(fontSize: 11, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: Floating Overlay Interactive Canvas Mockup
  Widget _buildOverlayPreviewTab() {
    double hoursNeeded = _itemPrice / (_hourlyWage > 0 ? _hourlyWage : 1);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interactive HUD Live Overlay Canvas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Simulates how FloatingHUD hovers over your shopping, social, or reading apps to offer instant calculations & shortcuts.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Phone Canvas Simulator Frame
            Container(
              height: 380,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.indigoAccent.withAlpha(100), width: 2),
              ),
              child: Stack(
                children: [
                  // Simulated Background App (Shopping App Simulation)
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Simulated Shopping App',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Icon(Icons.shopping_cart,
                                  color: Colors.grey.shade600, size: 18),
                            ],
                          ),
                          const Divider(color: Colors.white70),
                          const SizedBox(height: 10),
                          Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade900,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(Icons.headphones,
                                  size: 50, color: Colors.tealAccent),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Wireless Noise Cancelling Headphones',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Listed Price: \$${_itemPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              minimumSize: const Size(double.infinity, 40),
                            ),
                            child: const Text('BUY NOW (Impulse Button)'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Active Screen Tint Simulation
                  if (_hudActive)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            color: _screenTint.withAlpha(
                              (_screenFilterOpacity * 255).round(),
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),

                  // Draggable HUD Bubble Overlay Widget
                  if (_hudActive)
                    Positioned(
                      left: _bubbleOffset.dx,
                      top: _bubbleOffset.dy,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            double newX = _bubbleOffset.dx + details.delta.dx;
                            double newY = _bubbleOffset.dy + details.delta.dy;
                            // Keep bubble within visible limits
                            if (newX < 10) newX = 10;
                            if (newX > 260) newX = 260;
                            if (newY < 10) newY = 10;
                            if (newY > 300) newY = 300;
                            _bubbleOffset = Offset(newX, newY);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.indigoAccent.withAlpha(150),
                                blurRadius: 12,
                                spreadRadius: 2,
                              )
                            ],
                            border: Border.all(color: Colors.indigoAccent, width: 2),
                          ),
                          child: const Icon(
                            Icons.bolt,
                            color: Colors.amber,
                            size: 28,
                          ),
                        ),
                      ),
                    ),

                  // Expandable HUD Helper Quick Card attached to Bubble
                  if (_hudActive)
                    Positioned(
                      left: 10,
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B).withAlpha(240),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.indigoAccent),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.schedule, color: Colors.amber, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Labor Cost: ${hoursNeeded.toStringAsFixed(1)} Work Hours required for this item!',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Live Control Panel for Floating Features
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Floating HUD Overlay Controls',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigoAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Screen Tint Filter:',
                            style: TextStyle(fontSize: 12)),
                        const Spacer(),
                        Wrap(
                          spacing: 6,
                          children: [
                            _buildColorTintPicker(Colors.amber),
                            _buildColorTintPicker(Colors.blue),
                            _buildColorTintPicker(Colors.green),
                            _buildColorTintPicker(Colors.red),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Tint Intensity:',
                            style: TextStyle(fontSize: 12)),
                        Expanded(
                          child: Slider(
                            value: _screenFilterOpacity,
                            min: 0.0,
                            max: 0.5,
                            activeColor: _screenTint,
                            onChanged: (val) {
                              setState(() {
                                _screenFilterOpacity = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildColorTintPicker(Color color) {
    bool selected = _screenTint == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          _screenTint = color;
        });
      },
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }

  // TAB 2: Wage Cost & Anti-Impulse Purchase Evaluator
  Widget _buildWageCostCalculatorTab() {
    double hourlyWageVal = _hourlyWage <= 0 ? 1 : _hourlyWage;
    double hoursRequired = _itemPrice / hourlyWageVal;
    double workDaysRequired = hoursRequired / 8.0; // 8 hr work day

    // Regret risk level calculation
    String riskLevel = 'Low Risk';
    Color riskColor = Colors.green;
    if (hoursRequired > 20) {
      riskLevel = 'EXTREME IMPULSE RISK! (High Work Cost)';
      riskColor = Colors.redAccent;
    } else if (hoursRequired > 8) {
      riskLevel = 'MODERATE REGRET RISK (Over 1 Day of Labor)';
      riskColor = Colors.orangeAccent;
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Wage-Time Purchase Cost Evaluator',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Translates store dollar prices into actual hours of your lifetime labor required.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Input Fields
            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Your Hourly Wage (\$/hr)',
                        prefixIcon: Icon(Icons.monetization_on, color: Colors.indigoAccent),
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(text: _hourlyWage.toString()),
                      onChanged: (val) {
                        double? parsed = double.tryParse(val);
                        if (parsed != null) {
                          setState(() {
                            _hourlyWage = parsed;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Product Price (\$) To Evaluate',
                        prefixIcon: Icon(Icons.shopping_bag, color: Colors.tealAccent),
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(text: _itemPrice.toString()),
                      onChanged: (val) {
                        double? parsed = double.tryParse(val);
                        if (parsed != null) {
                          setState(() {
                            _itemPrice = parsed;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Live Analysis Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: riskColor, width: 2),
              ),
              child: Column(
                children: [
                  const Text(
                    'Lifetime Labor Cost Analysis',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${hoursRequired.toStringAsFixed(1)} Hours',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  Text(
                    'Equal to ~${workDaysRequired.toStringAsFixed(1)} Work Days (8h shifts)',
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: riskColor.withAlpha(40),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      riskLevel,
                      style: TextStyle(
                        color: riskColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.indigoAccent),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Tip: Whenever shopping in external browsers or apps, FloatingHUD automatically recalculates your labor cost in the floating bubble.',
                        style: const TextStyle(fontSize: 11, color: Colors.white70),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // TAB 3: Instant Micro Decision Resolver
  Widget _buildMicroDecisionTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Micro Decision Engine',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Eliminate daily option paralysis (What to eat, which task to pick, buy or wait?).',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Decision Spinner Result Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.indigo, Colors.deepPurple],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.stars, size: 40, color: Colors.amber),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _decisionResult,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _dilemmaOptions.isEmpty
                        ? null
                        : () {
                            setState(() {
                              _dilemmaOptions.shuffle();
                              _decisionResult =
                                  'Decision: ${_dilemmaOptions.first}';
                            });
                          },
                    icon: const Icon(Icons.refresh),
                    label: const Text('SPIN / PICK FOR ME'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Add Dilemma Options
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dilemmaInput,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Add Option (e.g. Cook Rice)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  backgroundColor: Colors.indigoAccent,
                  onPressed: () {
                    if (_dilemmaInput.text.trim().isNotEmpty) {
                      setState(() {
                        _dilemmaOptions.add(_dilemmaInput.text.trim());
                        _dilemmaInput.clear();
                      });
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Current Option List
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _dilemmaOptions.map((opt) {
                return Chip(
                  label: Text(opt, style: const TextStyle(color: Colors.white)),
                  backgroundColor: const Color(0xFF1E293B),
                  deleteIcon: const Icon(Icons.close, size: 16, color: Colors.grey),
                  onDeleted: () {
                    setState(() {
                      _dilemmaOptions.remove(opt);
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 4: Quick Floating Tray & Clipboard Manager
  Widget _buildQuickTrayTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Floating Sticky Tray & Clipboard',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Keep important codes, addresses, and temp text floating over other apps for quick copy-pasting.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // New Snippet Field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _snippetController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Enter text to pin on HUD overlay...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.push_pin),
                  backgroundColor: Colors.teal,
                  onPressed: () {
                    if (_snippetController.text.trim().isNotEmpty) {
                      setState(() {
                        _quickSnippets.add(_snippetController.text.trim());
                        _snippetController.clear();
                      });
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Snippet List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _quickSnippets.length,
              itemBuilder: (context, index) {
                final item = _quickSnippets[index];
                return Card(
                  color: const Color(0xFF1E293B),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.notes, color: Colors.amber),
                    title: Text(
                      item,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18, color: Colors.indigoAccent),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Copied to Clipboard: "$item"'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 18, color: Colors.redAccent),
                          onPressed: () {
                            setState(() {
                              _quickSnippets.removeAt(index);
                            });
                          },
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
}