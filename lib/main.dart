import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const FloatPulseApp());
}

class FloatPulseApp extends StatelessWidget {
  const FloatPulseApp({super.key});

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'FloatPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0F1A),
      ),
      home: const MainUtilityScreen(),
    );
  }
}

class MainUtilityScreen extends StatefulWidget {
  const MainUtilityScreen({super.key});

  @override
  State<MainUtilityScreen> createState() => _MainUtilityScreenState();
}

class _MainUtilityScreenState extends State<MainUtilityScreen> {
  int _selectedIndex = 0;
  
  // Gamified engagement system to increase app screen-time
  int _engagementPoints = 120;
  late Timer _rewardTimer;
  
  // Overlay state simulation
  bool _isOverlayEnabled = true;
  bool _isFloatingWidgetExpanded = false;
  Offset _floatingPosition = const Offset(20, 120);
  
  // Notification Simulator
  String? _activeNotification;

  // Impulse Shield Controller
  final TextEditingController _itemCostController = TextEditingController();
  final TextEditingController _hourlyWageController = TextEditingController();
  double _calculatedWorkHours = 0.0;
  String _impulseDecision = '';

  // Quick Utilities State
  final TextEditingController _billAmountController = TextEditingController();
  double _tipPercentage = 15.0;
  int _peopleCount = 2;

  // Text Transformer
  final TextEditingController _textTransformController = TextEditingController();

  // Sticky Notes
  final List<String> _stickyNotes = [
    "📌 Pay electricity bill before 5 PM",
    "💡 Idea: Check floating notification settings",
    "🛒 Don't buy coffee today - Save \$5"
  ];
  final TextEditingController _noteInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Reward user every 10 seconds they keep app open or floating active
    _rewardTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          _engagementPoints += 5;
          if (_engagementPoints % 25 == 0) {
            _showSimulatedNotification("🎯 Bonus! Earned +5 Pulse Points for keeping utility active.");
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _rewardTimer.cancel();
    _itemCostController.dispose();
    _hourlyWageController.dispose();
    _billAmountController.dispose();
    _textTransformController.dispose();
    _noteInputController.dispose();
    super.dispose();
  }

  void _showSimulatedNotification(String message) {
    setState(() {
      _activeNotification = message;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _activeNotification == message) {
        setState(() {
          _activeNotification = null;
        });
      }
    });
  }

  void _calculateImpulse() {
    final double cost = double.tryParse(_itemCostController.text) ?? 0.0;
    final double wage = double.tryParse(_hourlyWageController.text) ?? 1.0;

    if (cost > 0 && wage > 0) {
      setState(() {
        _calculatedWorkHours = cost / wage;
        if (_calculatedWorkHours > 10) {
          _impulseDecision = "⚠️ Hard Pass! This requires ${_calculatedWorkHours.toStringAsFixed(1)} hours of pure work!";
        } else if (_calculatedWorkHours > 3) {
          _impulseDecision = "🤔 Sleep on it for 24 hours. Costs ${_calculatedWorkHours.toStringAsFixed(1)} work hours.";
        } else {
          _impulseDecision = "✅ Reasonable purchase! Equals ${_calculatedWorkHours.toStringAsFixed(1)} hours of wage.";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main App Scrollable Body
            Column(
              children: [
                _buildHeaderBar(),
                if (_activeNotification != null) _buildSimulatedNotificationBanner(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: [
                      _buildDashboardTab(),
                      _buildImpulseGuardTab(),
                      _buildQuickToolsTab(),
                      _buildFloatingOverlaySettingsTab(),
                    ],
                  ),
                ),
              ],
            ),

            // Interactive Floating HUD Drawer Simulator (Draw over apps preview)
            if (_isOverlayEnabled) _buildDraggableFloatingHUD(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF161626),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'HUD'),
          BottomNavigationBarItem(icon: Icon(Icons.shield), label: 'Impulse'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Tools'),
          BottomNavigationBarItem(icon: Icon(Icons.layers), label: 'Overlay'),
        ],
      ),
    );
  }

  Widget _buildHeaderBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF161626),
        border: Border(bottom: BorderSide(color: Colors.white70)),
      ),
      child: Row(
        children: [
          const Icon(Icons.flash_on, color: Colors.tealAccent, size: 28),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'FloatPulse',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.deepPurpleAccent),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  '$_engagementPoints Pts',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulatedNotificationBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal.shade900.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.tealAccent),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: Colors.tealAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _activeNotification ?? '',
              style: const TextStyle(color: Colors.white, fontSize: 13),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  // DASHBOARD TAB
  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active Floating Overlay Status Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade900, const Color(0xFF161626)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.phonelink_setup, color: Colors.tealAccent),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        "Ambient Dynamic Floating Widget",
                        style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Switch(
                      value: _isOverlayEnabled,
                      activeColor: Colors.tealAccent,
                      onChanged: (val) {
                        setState(() {
                          _isOverlayEnabled = val;
                        });
                        _showSimulatedNotification(val ? "Floating HUD active over apps" : "Floating HUD minimized");
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Keep FloatPulse floating on your screen while using other apps to split bills, strip text, or check spending fast.",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Quick Action Cards Matrix
          const Text(
            "Micro-Utilities Hub",
            style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildMetricCard(
                title: "Impulse Guard",
                subtitle: "Calculated ${_calculatedWorkHours.toStringAsFixed(1)} hrs work",
                icon: Icons.shield,
                color: Colors.indigo,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              _buildMetricCard(
                title: "Sticky Notes",
                subtitle: "${_stickyNotes.length} pinned items",
                icon: Icons.note_alt,
                color: Colors.amber.shade800,
                onTap: () => setState(() => _selectedIndex = 2),
              ),
              _buildMetricCard(
                title: "Bill Splitter",
                subtitle: "Quick Tip Calculator",
                icon: Icons.monetization_on,
                color: Colors.teal,
                onTap: () => setState(() => _selectedIndex = 2),
              ),
              _buildMetricCard(
                title: "Text Cleaner",
                subtitle: "Instant Formatter",
                icon: Icons.cleaning_services,
                color: Colors.deepOrange,
                onTap: () => setState(() => _selectedIndex = 2),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Pinned Notes Quick List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Active Sticky Notes",
                style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold, color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.tealAccent),
                onPressed: () => _showAddNoteDialog(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _stickyNotes.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D1D32),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white70),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _stickyNotes[index],
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
                      onPressed: () {
                        setState(() {
                          _stickyNotes.removeAt(index);
                        });
                      },
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

  // IMPULSE GUARD TAB
  Widget _buildImpulseGuardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF161626),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigoAccent),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.shield, color: Colors.indigoAccent, size: 28),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Impulse Buying Shield",
                        style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Before buying something you don't strictly need, calculate how many hours of your life you must work to earn it.",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _itemCostController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Item Price (\$)",
              labelStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.attach_money, color: Colors.tealAccent),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _hourlyWageController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Your Hourly Wage / Income (\$)",
              labelStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.schedule, color: Colors.amber),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigoAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.calculate, color: Colors.white),
              label: const Text("Calculate True Labor Cost", style: TextStyle(color: Colors.white, fontSize: 15)),
              onPressed: _calculateImpulse,
            ),
          ),
          if (_impulseDecision.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.tealAccent),
              ),
              child: Column(
                children: [
                  Text(
                    "Work Required: ${_calculatedWorkHours.toStringAsFixed(1)} Hours",
                    style: const TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.tealAccent),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _impulseDecision,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // QUICK TOOLS TAB
  Widget _buildQuickToolsTab() {
    double bill = double.tryParse(_billAmountController.text) ?? 0.0;
    double tipAmount = bill * (_tipPercentage / 100);
    double totalBill = bill + tipAmount;
    double perPerson = _peopleCount > 0 ? totalBill / _peopleCount : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bill Splitter
          const Text(
            "Quick Bill & Tip Splitter",
            style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF161626),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _billAmountController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) => setState(() {}),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Total Bill Amount (\$)",
                    prefixIcon: Icon(Icons.receipt, color: Colors.tealAccent),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text("Tip: ${_tipPercentage.toInt()}%", style: const TextStyle(color: Colors.white)),
                    Expanded(
                      child: Slider(
                        value: _tipPercentage,
                        min: 0,
                        max: 40,
                        divisions: 8,
                        activeColor: Colors.tealAccent,
                        onChanged: (val) => setState(() => _tipPercentage = val),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Split among:", style: TextStyle(color: Colors.white)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                          onPressed: () {
                            if (_peopleCount > 1) setState(() => _peopleCount--);
                          },
                        ),
                        Text("$_peopleCount people", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.tealAccent),
                          onPressed: () => setState(() => _peopleCount++),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(color: Colors.white70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Each Person Pays:", style: TextStyle(color: Colors.white, fontSize: 16)),
                    Text(
                      "\$${perPerson.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 20, FontWeight: FontWeight.bold, color: Colors.tealAccent),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Instant Text Cleaner / Formatter
          const Text(
            "Text Transformer & Cleaner",
            style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF161626),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.deepOrangeAccent.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _textTransformController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Paste raw text here to format instantly...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAxisAlignment.center,
                  children: [
                    ActionChip(
                      label: const Text("UPPERCASE"),
                      onPressed: () {
                        setState(() {
                          _textTransformController.text = _textTransformController.text.toUpperCase();
                        });
                      },
                    ),
                    ActionChip(
                      label: const Text("lowercase"),
                      onPressed: () {
                        setState(() {
                          _textTransformController.text = _textTransformController.text.toLowerCase();
                        });
                      },
                    ),
                    ActionChip(
                      label: const Text("Remove Spaces"),
                      onPressed: () {
                        setState(() {
                          _textTransformController.text = _textTransformController.text.replaceAll(' ', '');
                        });
                      },
                    ),
                    ActionChip(
                      label: const Text("Bullet Points"),
                      onPressed: () {
                        setState(() {
                          final lines = _textTransformController.text.split('\n');
                          _textTransformController.text = lines.map((l) => "• $l").join('\n');
                        });
                      },
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

  // OVERLAY SETTINGS TAB
  Widget _buildFloatingOverlaySettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF161626),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.tealAccent),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.layers, color: Colors.tealAccent, size: 28),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "System Display Permission",
                        style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "FloatPulse uses screen overlay permissions to remain accessible as a interactive floating ball while you switch to social media, browser, or shopping apps.",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: const Text("Simulate Granting Permission", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    _showSimulatedNotification("Display over apps permission active!");
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Floating HUD Position & Settings",
            style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          ListTile(
            tileColor: const Color(0xFF161626),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text("Reset Floating Badge Position", style: TextStyle(color: Colors.white)),
            subtitle: const Text("Center floating pill back to top left", style: TextStyle(color: Colors.grey)),
            trailing: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.tealAccent),
              onPressed: () {
                setState(() {
                  _floatingPosition = const Offset(20, 120);
                });
                _showSimulatedNotification("Floating widget position reset!");
              },
            ),
          ),
        ],
      ),
    );
  }

  // SIMULATED DRAGGABLE FLOATING HUD OVERLAY
  Widget _buildDraggableFloatingHUD() {
    return Positioned(
      left: _floatingPosition.dx,
      top: _floatingPosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _floatingPosition += details.delta;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF23233D).withOpacity(0.95),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.tealAccent.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
            border: Border.all(color: Colors.tealAccent, width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.drag_handle, color: Colors.grey, size: 16),
                  const SizedBox(width: 4),
                  const Icon(Icons.flash_on, color: Colors.tealAccent, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    "PULSE ${_engagementPoints}p",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.only(left: 6),
                    icon: Icon(
                      _isFloatingWidgetExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.tealAccent,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFloatingWidgetExpanded = !_isFloatingWidgetExpanded;
                      });
                    },
                  ),
                ],
              ),
              if (_isFloatingWidgetExpanded) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.note_add, color: Colors.amber, size: 20),
                      onPressed: _showAddNoteDialog,
                    ),
                    IconButton(
                      icon: const Icon(Icons.calculate, color: Colors.indigoAccent, size: 20),
                      onPressed: () => setState(() => _selectedIndex = 1),
                    ),
                    IconButton(
                      icon: const Icon(Icons.cleaning_services, color: Colors.deepOrangeAccent, size: 20),
                      onPressed: () => setState(() => _selectedIndex = 2),
                    ),
                  ],
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF161626),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 14, FontWeight: FontWeight.bold, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF161626),
          title: const Text("New Sticky Overlay Note", style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: _noteInputController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Enter quick memo...",
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent),
              onPressed: () {
                if (_noteInputController.text.isNotEmpty) {
                  setState(() {
                    _stickyNotes.add("📌 ${_noteInputController.text}");
                    _noteInputController.clear();
                  });
                  Navigator.pop(context);
                  _showSimulatedNotification("Sticky note pinned to floating HUD!");
                }
              },
              child: const Text("Pin Note", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}