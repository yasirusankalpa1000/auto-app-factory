import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const OverlayAssistantApp());
}

class OverlayAssistantApp extends StatelessWidget {
  const OverlayAssistantApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overlay HUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121218),
      ),
      home: const MainHUDPage(),
    );
  }
}

class MainHUDPage extends StatefulWidget {
  const MainHUDPage({Key? key}) : super(key: key);

  @override
  State<MainHUDPage> createState() => _MainHUDPageState();
}

class _MainHUDPageState extends State<MainHUDPage> with SingleTickerProviderStateMixin {
  int _currentTabIndex = 0;

  // Floating Bubble Position
  double _bubbleX = 20.0;
  double _bubbleY = 120.0;
  bool _isOverlayExpanded = false;
  bool _isSystemOverlayEnabled = true;
  bool _showFloatingNotificationBar = true;

  // Unit Price Comparator State
  final TextEditingController _itemAWeightController = TextEditingController(text: '400');
  final TextEditingController _itemAPriceController = TextEditingController(text: '5.80');
  final TextEditingController _itemBWeightController = TextEditingController(text: '650');
  final TextEditingController _itemBPriceController = TextEditingController(text: '8.90');
  String _unitType = 'g'; // g, ml, units

  // Decision Wheel State
  final List<String> _decisionOptions = ['Pizza Night', 'Cook at Home', 'Sushi Express', 'Burger Spot', 'Healthy Salad'];
  final TextEditingController _newOptionController = TextEditingController();
  String? _selectedDecision;
  bool _isSpinning = false;
  late AnimationController _spinController;

  // Floating Sticky Notes / Clipboard Vault
  final List<Map<String, String>> _notesList = [
    {'title': 'Grocery Code', 'content': 'DISCOUNT-20-OFF', 'tag': 'Promo'},
    {'title': 'Parking Slot', 'content': 'Level 3 - Zone B (B-104)', 'tag': 'Quick Info'},
    {'title': 'Wi-Fi Password', 'content': 'GuestConnect2025!', 'tag': 'Key'},
  ];
  final TextEditingController _noteTitleController = TextEditingController();
  final TextEditingController _noteContentController = TextEditingController();

  // Bill Splitter State
  double _totalBill = 48.50;
  int _peopleCount = 3;
  double _tipPercentage = 15.0;
  double _taxPercentage = 8.0;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    _itemAWeightController.dispose();
    _itemAPriceController.dispose();
    _itemBWeightController.dispose();
    _itemBPriceController.dispose();
    _newOptionController.dispose();
    _noteTitleController.dispose();
    _noteContentController.dispose();
    super.dispose();
  }

  void _spinWheel() {
    if (_decisionOptions.isEmpty || _isSpinning) return;
    setState(() {
      _isSpinning = true;
      _selectedDecision = null;
    });

    _spinController.forward(from: 0.0).then((_) {
      final random = Random();
      final winner = _decisionOptions[random.nextInt(_decisionOptions.length)];
      setState(() {
        _selectedDecision = winner;
        _isSpinning = false;
      });
    });
  }

  void _addNote() {
    if (_noteTitleController.text.trim().isEmpty || _noteContentController.text.trim().isEmpty) return;
    setState(() {
      _notesList.insert(0, {
        'title': _noteTitleController.text.trim(),
        'content': _noteContentController.text.trim(),
        'tag': 'Custom',
      });
      _noteTitleController.clear();
      _noteContentController.clear();
    });
  }

  void _deleteNote(int index) {
    setState(() {
      _notesList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Dashboard Body View
            Column(
              children: [
                _buildHeaderNotificationBar(),
                Expanded(
                  child: _buildMainContentBody(),
                ),
                _buildBottomNavigationBar(),
              ],
            ),

            // Interactive Dragable Floating Overlay Bubble
            if (_isSystemOverlayEnabled)
              Positioned(
                left: _bubbleX,
                top: _bubbleY,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _bubbleX += details.delta.dx;
                      _bubbleY += details.delta.dy;
                      // Keep bubble within visible screen boundaries
                      _bubbleX = _bubbleX.clamp(10.0, screenSize.width - 70.0);
                      _bubbleY = _bubbleY.clamp(40.0, screenSize.height - 130.0);
                    });
                  },
                  onTap: () {
                    setState(() {
                      _isOverlayExpanded = !_isOverlayExpanded;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.deepPurple, Colors.indigo],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.5),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                      border: Border.all(color: Colors.white70, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.widgets,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),

            // Expanded Floating Quick HUD Popup Container
            if (_isSystemOverlayEnabled && _isOverlayExpanded)
              Positioned(
                left: (_bubbleX > screenSize.width / 2) ? null : 20.0,
                right: (_bubbleX > screenSize.width / 2) ? 20.0 : null,
                top: (_bubbleY + 70 > screenSize.height - 300) ? screenSize.height - 380 : _bubbleY + 70,
                child: Container(
                  width: 280,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E28),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.deepPurpleAccent, width: 1.5),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.bolt, color: Colors.amber, size: 20),
                              SizedBox(width: 6),
                              Text(
                                'Floating Quick HUD',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isOverlayExpanded = false;
                              });
                            },
                            child: const Icon(Icons.close, color: Colors.grey, size: 18),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white70, height: 16),
                      const Text(
                        'Pinned Quick Note:',
                        style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.pin, color: Colors.amber, size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                _notesList.isNotEmpty ? '${_notesList[0]['title']}: ${_notesList[0]['content']}' : 'No active notes pinned',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildMiniHUDButton(
                            icon: Icons.compare_arrows,
                            label: 'Compare',
                            onTap: () {
                              setState(() {
                                _currentTabIndex = 1;
                                _isOverlayExpanded = false;
                              });
                            },
                          ),
                          _buildMiniHUDButton(
                            icon: Icons.casino,
                            label: 'Decision',
                            onTap: () {
                              setState(() {
                                _currentTabIndex = 2;
                                _isOverlayExpanded = false;
                              });
                            },
                          ),
                          _buildMiniHUDButton(
                            icon: Icons.receipt_long,
                            label: 'Split Bill',
                            onTap: () {
                              setState(() {
                                _currentTabIndex = 4;
                                _isOverlayExpanded = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniHUDButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.tealAccent, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderNotificationBar() {
    if (!_showFloatingNotificationBar) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF1B1B26),
        border: Border(bottom: BorderSide(color: Colors.white70, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.teal,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_active, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Active Utility Overlay Running in Background',
              style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _showFloatingNotificationBar = false;
              });
            },
            child: const Icon(Icons.close, color: Colors.grey, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContentBody() {
    switch (_currentTabIndex) {
      case 0:
        return _buildOverlayDashboardTab();
      case 1:
        return _buildPriceComparatorTab();
      case 2:
        return _buildDecisionWheelTab();
      case 3:
        return _buildClipboardNotesTab();
      case 4:
        return _buildBillSplitterTab();
      default:
        return _buildOverlayDashboardTab();
    }
  }

  Widget _buildOverlayDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Overlay HUD System',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Daily Micro-Utility & Quick Assist Platform',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.greenAccent),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.greenAccent, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Ready',
                      style: TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Permissions & Floating Control Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF262636), Color(0xFF1E1E2A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.layers, color: Colors.deepPurpleAccent, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Floating Assistant Bubble',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enable floating screen overlay bubble to access price comparison, quick scratchpad, and decisions on top of any active screen.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: Colors.deepPurpleAccent,
                  title: const Text(
                    'Display Floating Bubble',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Allows draggable bubble on screen',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  value: _isSystemOverlayEnabled,
                  onChanged: (val) {
                    setState(() {
                      _isSystemOverlayEnabled = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Quick Practical Utilities',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Grid of Quick Tools
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.25,
            children: [
              _buildDashboardToolCard(
                title: 'Value Comparison',
                desc: 'Compare supermarket size vs price per unit',
                icon: Icons.compare_arrows,
                badgeColor: Colors.tealAccent,
                onTap: () => setState(() => _currentTabIndex = 1),
              ),
              _buildDashboardToolCard(
                title: 'Micro Decision Wheel',
                desc: 'Solve meal & choice indecision instantly',
                icon: Icons.casino,
                badgeColor: Colors.amberAccent,
                onTap: () => setState(() => _currentTabIndex = 2),
              ),
              _buildDashboardToolCard(
                title: 'Clipboard Vault',
                desc: 'Floating scratchpad & sticky notes',
                icon: Icons.content_paste,
                badgeColor: Colors.purpleAccent,
                onTap: () => setState(() => _currentTabIndex = 3),
              ),
              _buildDashboardToolCard(
                title: 'Bill & Share Splitter',
                desc: 'Calculates tax, tips, and individual share',
                icon: Icons.calculate,
                badgeColor: Colors.blueAccent,
                onTap: () => setState(() => _currentTabIndex = 4),
              ),
            ],
          ),

          const SizedBox(height: 20),
          _buildUsageTipBanner(),
        ],
      ),
    );
  }

  Widget _buildDashboardToolCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white70),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: badgeColor, size: 24),
                const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 12),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageTipBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.4)),
      ),
      child: const Row(
        children: [
          Icon(Icons.lightbulb, color: Colors.amber, size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tip: Move the floating bubble to your preferred corner. Tap it anytime while shopping or browsing to trigger instant price comparison!',
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 1: Supermarket Unit Price & Value Comparator Engine
  Widget _buildPriceComparatorTab() {
    double weightA = double.tryParse(_itemAWeightController.text) ?? 1.0;
    double priceA = double.tryParse(_itemAPriceController.text) ?? 0.0;
    double weightB = double.tryParse(_itemBWeightController.text) ?? 1.0;
    double priceB = double.tryParse(_itemBPriceController.text) ?? 0.0;

    double unitCostA = (weightA > 0) ? (priceA / weightA) * 100 : 0.0; // Cost per 100 units
    double unitCostB = (weightB > 0) ? (priceB / weightB) * 100 : 0.0; // Cost per 100 units

    bool isABetter = unitCostA > 0 && (unitCostA < unitCostB || unitCostB == 0);
    bool isBBetter = unitCostB > 0 && (unitCostB < unitCostA || unitCostA == 0);

    double percentDiff = 0.0;
    double dollarSaved = 0.0;
    if (unitCostA > 0 && unitCostB > 0) {
      if (isABetter) {
        percentDiff = ((unitCostB - unitCostA) / unitCostB) * 100;
        dollarSaved = priceB - (priceA * (weightB / (weightA > 0 ? weightA : 1)));
      } else if (isBBetter) {
        percentDiff = ((unitCostA - unitCostB) / unitCostA) * 100;
        dollarSaved = priceA - (priceB * (weightA / (weightB > 0 ? weightB : 1)));
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Unit Price Comparator',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Find out which deal is actually cheaper per unit value (100g/ml/items)',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Unit Switcher
          Row(
            children: [
              const Text('Unit Metric:', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(width: 12),
              Wrap(
                spacing: 8,
                children: ['g', 'ml', 'pcs'].map((type) {
                  final isSelected = _unitType == type;
                  return ChoiceChip(
                    label: Text(type, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontSize: 12)),
                    selected: isSelected,
                    selectedColor: Colors.tealAccent,
                    backgroundColor: const Color(0xFF222230),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _unitType = type;
                        });
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Side by Side Input Comparison
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildItemCard(
                  title: 'Option A',
                  isWinner: isABetter,
                  weightController: _itemAWeightController,
                  priceController: _itemAPriceController,
                  unitCost: unitCostA,
                  unitType: _unitType,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildItemCard(
                  title: 'Option B',
                  isWinner: isBBetter,
                  weightController: _itemBWeightController,
                  priceController: _itemBPriceController,
                  unitCost: unitCostB,
                  unitType: _unitType,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Deal Verdict Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isABetter || isBBetter
                    ? [Colors.teal.withOpacity(0.3), Colors.deepPurple.withOpacity(0.3)]
                    : [const Color(0xFF222230), const Color(0xFF1B1B26)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isABetter || isBBetter ? Colors.tealAccent : Colors.white70,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isABetter || isBBetter ? Icons.stars : Icons.info,
                      color: isABetter || isBBetter ? Colors.amber : Colors.grey,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isABetter
                          ? 'OPTION A IS THE BETTER VALUE!'
                          : (isBBetter ? 'OPTION B IS THE BETTER VALUE!' : 'ENTER DETAILS TO COMPARE'),
                      style: TextStyle(
                        color: isABetter || isBBetter ? Colors.amber : Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                if (isABetter || isBBetter) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Saves approx ${percentDiff.toStringAsFixed(1)}% per unit weight/quantity.',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard({
    required String title,
    required bool isWinner,
    required TextEditingController weightController,
    required TextEditingController priceController,
    required double unitCost,
    required String unitType,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isWinner ? Colors.tealAccent : Colors.white70, width: isWinner ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(color: color.computeLuminance() > 0.5 ? Colors.white : Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              if (isWinner)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.tealAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'BEST DEAL',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 9),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            onChanged: (v) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Qty / Weight ($unitType)',
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 11),
              border: const OutlineInputBorder(),
              isDense: true,
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            onChanged: (v) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Price (\$) ',
              labelStyle: TextStyle(color: Colors.grey, fontSize: 11),
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.all(10),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Text('Cost per 100' , style: TextStyle(color: Colors.grey, fontSize: 10)),
                const SizedBox(height: 2),
                Text(
                  '\$${unitCost.toStringAsFixed(2)} / 100$unitType',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: Interactive Micro-Decision Matrix & Spinner
  Widget _buildDecisionWheelTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Decision Chooser',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Eliminate daily decision fatigue - What to eat? Where to go? What to do first?',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 20),

          // Interactive Wheel / Chooser Box
          Center(
            child: Container(
              width: 240,
              height: 240,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Color(0xFF2C2C3E), Color(0xFF161622)],
                ),
                border: Border.all(color: Colors.deepPurpleAccent, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isSpinning)
                    const RotationTransition(
                      turns: AlwaysStoppedAnimation(0.5),
                      child: Icon(Icons.casino, color: Colors.amberAccent, size: 50),
                    )
                  else
                    Icon(
                      _selectedDecision != null ? Icons.verified : Icons.touch_app,
                      color: _selectedDecision != null ? Colors.greenAccent : Colors.tealAccent,
                      size: 42,
                    ),
                  const SizedBox(height: 10),
                  Text(
                    _isSpinning
                        ? 'Picking best choice...'
                        : (_selectedDecision ?? 'Tap Spin to Decide!'),
                    style: TextStyle(
                      color: _selectedDecision != null ? Colors.amberAccent : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Center(
            child: ElevatedButton.icon(
              onPressed: _isSpinning ? null : _spinWheel,
              icon: const Icon(Icons.refresh, color: Colors.black),
              label: const Text('SPIN / PICK RANDOM CHOICE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Decision Options List Management
          const Text(
            'Current Choice Options Pool:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _newOptionController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(
                    hintText: 'Add option (e.g. Sushi, Gym, Movie)',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  if (_newOptionController.text.trim().isNotEmpty) {
                    setState(() {
                      _decisionOptions.add(_newOptionController.text.trim());
                      _newOptionController.clear();
                    });
                  }
                },
                icon: const Icon(Icons.add, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _decisionOptions.map((opt) {
              return Chip(
                label: Text(opt, style: const TextStyle(color: Colors.white, fontSize: 12)),
                backgroundColor: const Color(0xFF222232),
                deleteIcon: const Icon(Icons.close, size: 14, color: Colors.grey),
                onDeleted: () {
                  setState(() {
                    _decisionOptions.remove(opt);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // TAB 3: Clipboard Vault & Sticky Notes
  Widget _buildClipboardNotesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Clipboard & Floating Scratchpad',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Keep quick codes, tracking numbers, and snippets easily accessible on screen',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Add New Note Inputs
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('New Floating Snippet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 10),
                TextField(
                  controller: _noteTitleController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(
                    labelText: 'Title / Label',
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 11),
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _noteContentController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(
                    labelText: 'Content / Code / Text Snippet',
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 11),
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addNote,
                    icon: const Icon(Icons.push_pin, color: Colors.white, size: 16),
                    label: const Text('PIN TO SCRATCHPAD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Active Pinned Snippets',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _notesList.length,
            itemBuilder: (context, index) {
              final item = _notesList[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF222230),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white70),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.pin_drop, color: Colors.amber, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] ?? '',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['content'] ?? '',
                            style: const TextStyle(color: Colors.tealAccent, fontSize: 12, fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.grey, size: 18),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Copied "${item['content']}" to clipboard!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
                      onPressed: () => _deleteNote(index),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // TAB 4: Instant Group Bill & Tip Splitter
  Widget _buildBillSplitterTab() {
    double tipAmount = _totalBill * (_tipPercentage / 100.0);
    double taxAmount = _totalBill * (_taxPercentage / 100.0);
    double grandTotal = _totalBill + tipAmount + taxAmount;
    double sharePerPerson = (_peopleCount > 0) ? grandTotal / _peopleCount : grandTotal;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Instant Bill & Tip Splitter',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Split group expenses, meals, and receipts on the spot with tax & tips',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 20),

          // Grand Total Output Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.teal, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                const Text('EACH PERSON PAYS', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                  '\$${sharePerPerson.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Divider(color: Colors.white.withOpacity(0.3)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryMiniText('Total Bill', '\$${_totalBill.toStringAsFixed(2)}'),
                    _buildSummaryMiniText('Tip (${_tipPercentage.toInt()}%)', '\$${tipAmount.toStringAsFixed(2)}'),
                    _buildSummaryMiniText('Grand Total', '\$${grandTotal.toStringAsFixed(2)}'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Inputs & Sliders
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Bill Base Amount (\$)', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    prefixStyle: TextStyle(color: Colors.tealAccent, fontSize: 15),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (val) {
                    setState(() {
                      _totalBill = double.tryParse(val) ?? 0.0;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // People Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Number of People:', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (_peopleCount > 1) setState(() => _peopleCount--);
                          },
                          icon: const Icon(Icons.remove, color: Colors.white, size: 16),
                          style: IconButton.styleFrom(backgroundColor: Colors.white70),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('$_peopleCount', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        IconButton(
                          onPressed: () => setState(() => _peopleCount++),
                          icon: const Icon(Icons.add, color: Colors.white, size: 16),
                          style: IconButton.styleFrom(backgroundColor: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tip Percentage Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tip Percentage:', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                    Text('${_tipPercentage.toInt()}%', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                Slider(
                  value: _tipPercentage,
                  min: 0,
                  max: 30,
                  divisions: 30,
                  activeColor: Colors.tealAccent,
                  inactiveColor: Colors.white70,
                  onChanged: (v) => setState(() => _tipPercentage = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryMiniText(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF161622),
        border: Border(top: BorderSide(color: Colors.white70, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF161622),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_customize),
            label: 'Overlay Hub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Compare',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.casino),
            label: 'Decision',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: 'Scratchpad',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Bill Split',
          ),
        ],
      ),
    );
  }
}