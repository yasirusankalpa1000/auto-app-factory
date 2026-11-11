import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const ImpulseShieldApp());
}

class ImpulseShieldApp extends StatelessWidget {
  const ImpulseShieldApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImpulseShield HUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.amberAccent,
          surface: Color(0xFF1E293B),
          background: Color(0xFF0F172A),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E293B),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

class _MainHomeScreenState extends State<MainHomeScreen> with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;
  
  // User Finance Profile
  double _hourlyWage = 18.50;
  double _totalSavedMoney = 245.00;
  double _totalSavedHours = 13.24;
  int _savedItemsCount = 7;

  // Floating HUD State
  bool _isFloatingHudActive = true;
  Offset _hudPosition = const Offset(20, 120);
  bool _isHudExpanded = false;

  // Shopping Inputs
  final TextEditingController _itemNameController = TextEditingController(text: 'Wireless Headphones');
  final TextEditingController _itemPriceController = TextEditingController(text: '79.99');
  String _selectedCategory = 'Electronics';

  // Sanity Check Questions state
  bool _qNeedVsWant = false;
  bool _qCanWait48h = true;
  bool _qReplacesExisting = false;

  // Bill Splitter state inside HUD
  double _billAmount = 45.0;
  int _splitPeople = 2;
  double _tipPercentage = 15.0;

  // Quick Floating Note Scratchpad
  final TextEditingController _quickNoteController = TextEditingController(
    text: 'Promo code: SAVE20 | Compare Daraz vs Amazon price first',
  );

  // Decision Wheel state
  final List<String> _decisionOptions = ['Buy Later (48h)', 'Resist & Save', 'Buy Used/Refurbished', 'Find Alternative'];
  String _selectedDecisionResult = 'Spin to Decide!';
  bool _isSpinning = false;

  final List<Map<String, dynamic>> _savedHistory = [
    {'name': 'Designer Jacket', 'price': 120.00, 'hours': 6.48, 'date': 'Yesterday'},
    {'name': 'Gaming Mouse', 'price': 45.00, 'hours': 2.43, 'date': '3 days ago'},
    {'name': 'Unnecessary Coffee Subscription', 'price': 80.00, 'hours': 4.32, 'date': 'Last week'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeaderStatsBanner(),
                Expanded(
                  child: _buildBodyContent(),
                ),
                _buildBottomNavigationBar(),
              ],
            ),
            if (_isFloatingHudActive) _buildFloatingWidgetOverlay(),
          ],
        ),
      ),
    );
  }

  // --- TOP HEADER STATS BANNER ---
  Widget _buildHeaderStatsBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        border: Border(bottom: BorderSide(color: Colors.tealAccent.withOpacity(0.2))),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.shield, color: Colors.tealAccent, size: 26),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'ImpulseShield HUD',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        'Live Shopping Assistant',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  ChoiceChip(
                    label: Text(
                      _isFloatingHudActive ? 'HUD Floating: ON' : 'HUD Floating: OFF',
                      style: TextStyle(
                        fontSize: 11,
                        color: _isFloatingHudActive ? Colors.black : Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: _isFloatingHudActive,
                    selectedColor: Colors.tealAccent,
                    backgroundColor: Colors.black87,
                    onSelected: (val) {
                      setState(() {
                        _isFloatingHudActive = val;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildMiniStatBadge(
                  title: 'Money Saved',
                  value: '\$${_totalSavedMoney.toStringAsFixed(2)}',
                  icon: Icons.account_balance_wallet,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMiniStatBadge(
                  title: 'Labor Hours Saved',
                  value: '${_totalSavedHours.toStringAsFixed(1)} hrs',
                  icon: Icons.schedule,
                  color: Colors.amberAccent,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMiniStatBadge(
                  title: 'Hourly Wage',
                  value: '\$${_hourlyWage.toStringAsFixed(2)}/h',
                  icon: Icons.work,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStatBadge({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- BODY TAB CONTENT SWITCHER ---
  Widget _buildBodyContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildWorkCostShieldTab();
      case 1:
        return _buildHudToolsTab();
      case 2:
        return _buildDecisionWheelTab();
      case 3:
        return _buildVaultAnalyticsTab();
      default:
        return _buildWorkCostShieldTab();
    }
  }

  // --- TAB 1: WORK COST CALCULATOR & IMPULSE SHIELD ---
  Widget _buildWorkCostShieldTab() {
    final double price = double.tryParse(_itemPriceController.text) ?? 0.0;
    final double workHoursNeeded = _hourlyWage > 0 ? (price / _hourlyWage) : 0.0;
    final double workDaysNeeded = workHoursNeeded / 8.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🛒 Impulse Sanity Checker',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.tealAccent),
          ),
          const SizedBox(height: 4),
          const Text(
            'Convert real store prices into exact hours of hard work before you buy.',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _itemNameController,
                    decoration: const InputDecoration(
                      labelText: 'Item Name / Desired Purchase',
                      prefixIcon: Icon(Icons.shopping_bag),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _itemPriceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (v) => setState(() {}),
                          decoration: const InputDecoration(
                            labelText: 'Price (\$)',
                            prefixIcon: Icon(Icons.attach_money),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          items: ['Electronics', 'Fashion', 'Gaming', 'Food & Dining', 'Gadgets', 'Other']
                              .map((cat) => DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(fontSize: 13))))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedCategory = val);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // REAL COST VISUALIZER CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade900, Colors.teal.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.tealAccent.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                const Text(
                  'REAL LABOR COST CONVERSION',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.tealAccent),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${workHoursNeeded.toStringAsFixed(1)} Hrs',
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.amberAccent),
                        ),
                        const SizedBox(height: 4),
                        const Text('Hours of Work', style: TextStyle(fontSize: 11, color: Colors.white70)),
                      ],
                    ),
                    Container(height: 40, width: 1, color: Colors.white70),
                    Column(
                      children: [
                        Text(
                          '${workDaysNeeded.toStringAsFixed(1)} Days',
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),
                        ),
                        const SizedBox(height: 4),
                        const Text('Full Work Days', style: TextStyle(fontSize: 11, color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Buying "${_itemNameController.text}" requires working continuous ${workHoursNeeded.toStringAsFixed(1)} hours at your current wage of \$${_hourlyWage.toStringAsFixed(2)}/hr.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11, color: Colors.white70, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 3-SECOND SANITY DIAGNOSTIC
          const Text(
            '🧠 3-Second Impulse Diagnostic',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Is this a genuine need (vs want)?', style: TextStyle(fontSize: 13)),
                  subtitle: const Text('Essential for daily function/health', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  value: _qNeedVsWant,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) => setState(() => _qNeedVsWant = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Can you wait 48 hours before buying?', style: TextStyle(fontSize: 13)),
                  subtitle: const Text('Tests if excitement wears off', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  value: _qCanWait48h,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) => setState(() => _qCanWait48h = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Does this replace something you own?', style: TextStyle(fontSize: 13)),
                  subtitle: const Text('Avoid duplicate impulse hoarding', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  value: _qReplacesExisting,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) => setState(() => _qReplacesExisting = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // ACTION BUTTONS
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.shade700,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.shield, size: 20),
                  label: const Text('RESIST & SAVE MONEY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  onPressed: () {
                    if (price <= 0) return;
                    setState(() {
                      _totalSavedMoney += price;
                      _totalSavedHours += workHoursNeeded;
                      _savedItemsCount += 1;
                      _savedHistory.insert(0, {
                        'name': _itemNameController.text.isEmpty ? 'Impulse Purchase' : _itemNameController.text,
                        'price': price,
                        'hours': workHoursNeeded,
                        'date': 'Just now',
                      });
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('🎉 Victory! You saved \$${price.toStringAsFixed(2)} (${workHoursNeeded.toStringAsFixed(1)} hours of labor)!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.shopping_cart_checkout, size: 18),
                label: const Text('Bought It', style: TextStyle(fontSize: 12)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Logged purchase. Keep monitoring your labor hours!'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- TAB 2: FLOATING HUD TOOLS CONFIGURATOR & SCRATCHPAD ---
  Widget _buildHudToolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⚡ Floating HUD Micro-Tools',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.tealAccent),
          ),
          const SizedBox(height: 4),
          const Text(
            'Quick micro-utilities accessible right over your mobile screen while shopping or multitasking.',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '📝 Quick Clipboard & Micro Scratchpad',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.amberAccent),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18, color: Colors.tealAccent),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Scratchpad text copied!')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _quickNoteController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Paste promo codes, temporary numbers, or item specs here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🍽️ Micro Bill & Tip Splitter HUD',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Bill Total (\$) ',
                            prefixIcon: Icon(Icons.receipt),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            setState(() {
                              _billAmount = double.tryParse(val) ?? 0.0;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('People: $_splitPeople', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, size: 20),
                                onPressed: () {
                                  if (_splitPeople > 1) setState(() => _splitPeople--);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, size: 20),
                                onPressed: () {
                                  setState(() => _splitPeople++);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tip: ${_tipPercentage.toInt()}%', style: const TextStyle(fontSize: 12)),
                      Expanded(
                        child: Slider(
                          value: _tipPercentage,
                          min: 0,
                          max: 30,
                          divisions: 6,
                          activeColor: Colors.tealAccent,
                          label: '${_tipPercentage.toInt()}%',
                          onChanged: (val) => setState(() => _tipPercentage = val),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Builder(builder: (context) {
                    final double totalWithTip = _billAmount * (1 + (_tipPercentage / 100));
                    final double perPerson = _splitPeople > 0 ? (totalWithTip / _splitPeople) : 0.0;
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text('Total Bill + Tip', style: TextStyle(fontSize: 10, color: Colors.grey)),
                              Text('\$${totalWithTip.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('Each Person Pays', style: TextStyle(fontSize: 10, color: Colors.grey)),
                              Text('\$${perPerson.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.touch_app, color: Colors.amberAccent),
              title: const Text('Floating Overlay Interaction Tip', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              subtitle: const Text('Drag the floating shield icon anywhere on screen while browsing shopping apps like Amazon or Daraz for instant sanity check HUD access!', style: TextStyle(fontSize: 11)),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 3: MICRO DECISION MATRIX WHEEL ---
  Widget _buildDecisionWheelTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '🎯 Micro-Decision Engine',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.tealAccent),
          ),
          const SizedBox(height: 4),
          const Text(
            'Stuck in decision fatigue? Let the smart micro-decision solver break your impulse delay.',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 24),
          // DECISION DISPLAY CONTAINER
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isSpinning
                    ? [Colors.purple.shade900, Colors.teal.shade900]
                    : [Colors.teal.shade900, Colors.indigo.shade900],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.amberAccent, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.tealAccent.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            width: 220,
            height: 220,
            child: Center(
              child: Text(
                _selectedDecisionResult,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _isSpinning ? 14 : 18,
                  fontWeight: FontWeight.bold,
                  color: _isSpinning ? Colors.amberAccent : Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amberAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            icon: const Icon(Icons.casino, size: 24),
            label: const Text('SPIN DECISION WHEEL', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            onPressed: _isSpinning
                ? null
                : () {
                    setState(() {
                      _isSpinning = true;
                      _selectedDecisionResult = 'Evaluating choices...';
                    });
                    Future.delayed(const Duration(seconds: 1), () {
                      final random = Random();
                      final picked = _decisionOptions[random.nextInt(_decisionOptions.length)];
                      setState(() {
                        _selectedDecisionResult = picked;
                        _isSpinning = false;
                      });
                    });
                  },
          ),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Current Decision Options:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white70)),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _decisionOptions.map((opt) {
              return Chip(
                label: Text(opt, style: const TextStyle(fontSize: 11)),
                backgroundColor: const Color(0xFF1E293B),
                side: const BorderSide(color: Colors.white70),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: VAULT & SMART ANALYTICS ---
  Widget _buildVaultAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '💎 Wealth & Labor Saved Vault',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.tealAccent),
          ),
          const SizedBox(height: 4),
          const Text(
            'Your total accumulated wealth and freed life-hours protected from impulse buying.',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          // BADGE LEVEL PROGRESS CARD
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Mastery Level: LEVEL 3', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amberAccent)),
                      Text('Impulse Destroyer 🛡️', style: TextStyle(fontSize: 12, color: Colors.tealAccent)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.65,
                    backgroundColor: Colors.black87,
                    color: Colors.tealAccent,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 6),
                  const Text('Save \$55.00 more to unlock Level 4 "Financial Guardian"', style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('📜 History of Saved Purchases', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _savedHistory.length,
            itemBuilder: (context, index) {
              final item = _savedHistory[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                  ),
                  title: Text(item['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('Resisted ${item['date']} • Saved ${(item['hours'] as double).toStringAsFixed(1)} labor hours', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  trailing: Text(
                    '+\$${(item['price'] as double).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent, fontSize: 14),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- FLOATING HUD WIDGET SIMULATION OVERLAY ---
  Widget _buildFloatingWidgetOverlay() {
    return Positioned(
      left: _hudPosition.dx,
      top: _hudPosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _hudPosition += details.delta;
          });
        },
        child: Material(
          elevation: 12,
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _isHudExpanded ? 260 : 64,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withOpacity(0.95),
              borderRadius: BorderRadius.circular(_isHudExpanded ? 16 : 32),
              border: Border.all(color: Colors.tealAccent, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.tealAccent.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: _isHudExpanded ? _buildExpandedHudContent() : _buildCollapsedHudIcon(),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedHudIcon() {
    return InkWell(
      onTap: () => setState(() => _isHudExpanded = true),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.shield, color: Colors.tealAccent, size: 30),
          SizedBox(height: 2),
          Text('HUD', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
        ],
      ),
    );
  }

  Widget _buildExpandedHudContent() {
    final double price = double.tryParse(_itemPriceController.text) ?? 0.0;
    final double hours = _hourlyWage > 0 ? price / _hourlyWage : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.flash_on, size: 16, color: Colors.amberAccent),
                SizedBox(width: 4),
                Text('Shield HUD', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
              ],
            ),
            InkWell(
              onTap: () => setState(() => _isHudExpanded = false),
              child: const Icon(Icons.close, size: 18, color: Colors.white70),
            ),
          ],
        ),
        const Divider(color: Colors.white70, height: 12),
        Text('Quick Price: \$${price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 11, color: Colors.white)),
        Text('Cost: ${hours.toStringAsFixed(1)} labor hrs', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _totalSavedMoney += price;
                    _totalSavedHours += hours;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saved from HUD!'), backgroundColor: Colors.green),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(color: Colors.greenAccent.shade700, borderRadius: BorderRadius.circular(6)),
                  child: const Center(
                    child: Text('Resist', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedDecisionResult = _decisionOptions[Random().nextInt(_decisionOptions.length)];
                    _selectedTabIndex = 2; // Jump to wheel
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(color: Colors.amberAccent, borderRadius: BorderRadius.circular(6)),
                  child: const Center(
                    child: Text('Spin Wheel', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- BOTTOM NAVIGATION BAR ---
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedTabIndex,
      onTap: (index) => setState(() => _selectedTabIndex = index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF1E293B),
      selectedItemColor: Colors.tealAccent,
      unselectedItemColor: Colors.white70,
      selectedFontSize: 11,
      unselectedFontSize: 10,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Work Cost',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.widgets),
          label: 'HUD Tools',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.casino),
          label: 'Decision',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: 'Vault',
        ),
      ],
    );
  }
}