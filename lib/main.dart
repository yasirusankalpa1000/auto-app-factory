import 'package:flutter/material.dart';

void main() {
  runApp(const OmniFloatApp());
}

class OmniFloatApp extends StatelessWidget {
  const OmniFloatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniFloat Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0E17),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;

  // Floating Bubble Position & State
  Offset _bubblePosition = const Offset(20, 180);
  bool _isFloatingEnabled = true;
  bool _isEyeShieldActive = false;
  Color _currentShieldColor = Colors.amber;
  bool _isNotificationSync = true;

  // Impulse Saver State
  double _monthlySalary = 1200.0;
  double _workHoursPerWeek = 40.0;
  final TextEditingController _itemPriceController = TextEditingController(text: "85.00");
  final TextEditingController _itemNameController = TextEditingController(text: "Wireless Earbuds");
  String _evaluationResult = "";

  // Clipboard Stack
  final List<String> _clipboardItems = [
    "Thank you for reaching out! I will get back to you shortly.",
    "My Address: 742 Evergreen Terrace, Sector 4",
    "Account details: Bank of Commerce - ACC 9876543210",
  ];
  final TextEditingController _newClipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _calculateImpulseCost();
  }

  void _calculateImpulseCost() {
    final price = double.tryParse(_itemPriceController.text) ?? 0.0;
    final monthlyHours = (_workHoursPerWeek * 52) / 12;
    final hourlyRate = _monthlySalary / (monthlyHours > 0 ? monthlyHours : 160);
    
    if (hourlyRate <= 0) {
      setState(() {
        _evaluationResult = "Please enter valid wage details.";
      });
      return;
    }

    final hoursNeeded = price / hourlyRate;
    final daysNeeded = hoursNeeded / (_workHoursPerWeek / 5);

    setState(() {
      _evaluationResult = 
          "This item costs \$${price.toStringAsFixed(2)}.\n"
          "You must work ${hoursNeeded.toStringAsFixed(1)} hours (${daysNeeded.toStringAsFixed(1)} workdays) to pay for it.\n\n"
          "${hoursNeeded > 15 ? '⚠️ High Impulse Warning: Is this worth nearly two full days of hard work?' : '✅ Moderate Cost: Fits within your reasonable micro-budget.'}";
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Screen Tint Simulation Overlay
          if (_isEyeShieldActive)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: _currentShieldColor.withOpacity(0.15),
                ),
              ),
            ),

          // Main App Navigation View
          SafeArea(
            child: Column(
              children: [
                _buildHeaderBar(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: [
                      _buildFloatingOverlayStudioTab(size),
                      _buildImpulseSaverTab(),
                      _buildClipboardStackTab(),
                      _buildSystemPermissionsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Draggable Floating Widget Overlay Simulation
          if (_isFloatingEnabled)
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    double newX = _bubblePosition.dx + details.delta.dx;
                    double newY = _bubblePosition.dy + details.delta.dy;
                    // Keep bubble bounded inside mobile screen
                    newX = newX.clamp(10.0, size.width - 70.0);
                    newY = newY.clamp(60.0, size.height - 120.0);
                    _bubblePosition = Offset(newX, newY);
                  });
                },
                child: _buildFloatingWidgetBubble(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF161522),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Overlay Dock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Impulse Saver',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy),
            label: 'Quick Snippets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            label: 'System Shield',
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: const BoxDecoration(
        color: Color(0xFF161522),
        border: Border(bottom: BorderSide(color: Colors.white70)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.widgets, color: Colors.deepPurpleAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "OmniFloat Companion",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _isFloatingEnabled ? "Floating Overlay Active" : "Overlay Disabled",
                  style: TextStyle(
                    fontSize: 12,
                    color: _isFloatingEnabled ? Colors.greenAccent : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isFloatingEnabled,
            activeColor: Colors.deepPurpleAccent,
            onChanged: (val) {
              setState(() => _isFloatingEnabled = val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingWidgetBubble() {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurpleAccent.withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: _showFloatingMenuBottomSheet,
          child: const Center(
            child: Icon(
              Icons.bolt,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  void _showFloatingMenuBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1929),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "OmniFloat Mini Launcher",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildQuickActionButton(
                        icon: Icons.shield,
                        label: "Toggle Screen Tint",
                        color: Colors.amber,
                        onTap: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _isEyeShieldActive = !_isEyeShieldActive;
                          });
                        },
                      ),
                      _buildQuickActionButton(
                        icon: Icons.monetization_on,
                        label: "Evaluate Price",
                        color: Colors.teal,
                        onTap: () {
                          Navigator.pop(ctx);
                          setState(() => _selectedIndex = 1);
                        },
                      ),
                      _buildQuickActionButton(
                        icon: Icons.copy,
                        label: "Paste Snippet",
                        color: Colors.blue,
                        onTap: () {
                          Navigator.pop(ctx);
                          setState(() => _selectedIndex = 2);
                        },
                      ),
                      _buildQuickActionButton(
                        icon: Icons.notifications_active,
                        label: "Notification Sync",
                        color: Colors.purple,
                        onTap: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Floating notifications overlay synchronized!"),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: Floating Overlay Studio
  Widget _buildFloatingOverlayStudioTab(Size size) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCard(
            title: "Dynamic Screen Overlay",
            icon: Icons.layers,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Keep OmniFloat active on top of all apps to trigger quick calculations, paste stored text snippets, and shield your eyes during night browsing.",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Eye Protection Tint Overlay",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Switch(
                      value: _isEyeShieldActive,
                      onChanged: (val) {
                        setState(() => _isEyeShieldActive = val);
                      },
                    ),
                  ],
                ),
                if (_isEyeShieldActive) ...[
                  const SizedBox(height: 12),
                  const Text("Select Shield Tone:", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildColorChip(Colors.amber, "Warm Amber"),
                      _buildColorChip(Colors.blue, "Soft Blue"),
                      _buildColorChip(Colors.red, "Night Red"),
                      _buildColorChip(Colors.green, "Reading Green"),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: "Floating Controls Customization",
            icon: Icons.tune,
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.open_in_new, color: Colors.tealAccent),
                  title: const Text("Display Above Other Apps", style: TextStyle(fontSize: 14)),
                  subtitle: const Text("Allows floating bubble over web browser & store apps", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  trailing: const Icon(Icons.check_circle, color: Colors.greenAccent),
                ),
                const Divider(color: Colors.white70),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.touch_app, color: Colors.amberAccent),
                  title: const Text("Bubble Drag Behavior", style: TextStyle(fontSize: 14)),
                  subtitle: const Text("Free position drag on mobile edge", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  trailing: const Text("Enabled", style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: "Daily Usage Retention Metrics",
            icon: Icons.schedule,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricItem("2h 45m", "Overlay Active Today"),
                _buildMetricItem("14", "Impulse Purchases Saved"),
                _buildMetricItem("38", "Snippets Pasted"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorChip(Color color, String label) {
    final bool isSelected = _currentShieldColor == color;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: color.withOpacity(0.4),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _currentShieldColor = color;
          });
        }
      },
    );
  }

  // TAB 2: Impulse Purchase Saver
  Widget _buildImpulseSaverTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCard(
            title: "Impulse Purchase Work-Hour Evaluator",
            icon: Icons.monetization_on,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Before buying items online, calculate how many hours of your actual life you must trade to pay for them.",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Monthly Income (\$)", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton<double>(
                              value: _monthlySalary,
                              isExpanded: true,
                              underline: const SizedBox(),
                              dropdownColor: const Color(0xFF1F1D2E),
                              items: const [
                                DropdownMenuItem(value: 800.0, child: Text("\$800 / mo")),
                                DropdownMenuItem(value: 1200.0, child: Text("\$1,200 / mo")),
                                DropdownMenuItem(value: 2000.0, child: Text("\$2,000 / mo")),
                                DropdownMenuItem(value: 3500.0, child: Text("\$3,500 / mo")),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _monthlySalary = val;
                                    _calculateImpulseCost();
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Work Hours / Wk", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton<double>(
                              value: _workHoursPerWeek,
                              isExpanded: true,
                              underline: const SizedBox(),
                              dropdownColor: const Color(0xFF1F1D2E),
                              items: const [
                                DropdownMenuItem(value: 20.0, child: Text("20 hrs/wk")),
                                DropdownMenuItem(value: 40.0, child: Text("40 hrs/wk")),
                                DropdownMenuItem(value: 50.0, child: Text("50 hrs/wk")),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _workHoursPerWeek = val;
                                    _calculateImpulseCost();
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _itemNameController,
                  decoration: const InputDecoration(
                    labelText: "Item Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.shopping_bag),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _itemPriceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: "Item Price (\$)",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  onChanged: (_) => _calculateImpulseCost(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _calculateImpulseCost,
                    icon: const Icon(Icons.calculate, color: Colors.white),
                    label: const Text("Evaluate Labor Cost", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.analytics, color: Colors.amberAccent),
                    SizedBox(width: 8),
                    Text(
                      "Real Work-Hour Cost Breakdown",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _evaluationResult,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 3: Quick Snippets & Floating Clipboard Stack
  Widget _buildClipboardStackTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(
              title: "Floating Snippet Stack",
              icon: Icons.content_copy,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _newClipController,
                          decoration: const InputDecoration(
                            hintText: "Add fast response or text snippet...",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                        ),
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          if (_newClipController.text.trim().isNotEmpty) {
                            setState(() {
                              _clipboardItems.add(_newClipController.text.trim());
                              _newClipController.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Saved Floating Snippets (Tap to copy)",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _clipboardItems.isEmpty
                  ? const Center(
                      child: Text("No text snippets stored yet.", style: TextStyle(color: Colors.grey)),
                    )
                  : ListView.builder(
                      itemCount: _clipboardItems.length,
                      itemBuilder: (context, index) {
                        final item = _clipboardItems[index];
                        return Card(
                          color: const Color(0xFF1D1B2C),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: const Icon(Icons.text_snippet, color: Colors.deepPurpleAccent),
                            title: Text(
                              item,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.copy, size: 20, color: Colors.tealAccent),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Copied: \"$item\""),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 20, color: Colors.redAccent),
                                  onPressed: () {
                                    setState(() {
                                      _clipboardItems.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
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

  // TAB 4: System & Overlay Permissions Shield
  Widget _buildSystemPermissionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCard(
            title: "Floating Companion System Shield",
            icon: Icons.security,
            child: Column(
              children: [
                _buildPermissionSwitchTile(
                  title: "Display Over Other Apps",
                  subtitle: "Required to keep floating shortcut bubble visible over browser & social media.",
                  value: _isFloatingEnabled,
                  onChanged: (val) => setState(() => _isFloatingEnabled = val),
                  icon: Icons.picture_in_picture_alt,
                ),
                const Divider(color: Colors.white70),
                _buildPermissionSwitchTile(
                  title: "Smart Floating Notification Access",
                  subtitle: "Display non-intrusive dynamic overlay alerts for fast responses.",
                  value: _isNotificationSync,
                  onChanged: (val) => setState(() => _isNotificationSync = val),
                  icon: Icons.notifications_active,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: "Performance & Battery Shield",
            icon: Icons.flash_on,
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.battery_saver, color: Colors.greenAccent),
                  title: const Text("Low Memory Overlay Rendering"),
                  subtitle: const Text("Optimized flutter layer rendering for low battery drain"),
                  trailing: const Text("Active", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 0.18,
                  backgroundColor: Colors.white70,
                  color: Colors.tealAccent,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Resource Impact: Extremely Low (0.18% CPU)",
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurpleAccent, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  softWrap: true,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  softWrap: true,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: Colors.deepPurpleAccent,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161522),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.deepPurpleAccent, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildMetricItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}