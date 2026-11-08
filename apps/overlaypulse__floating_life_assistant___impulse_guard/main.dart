import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const OverlayPulseApp());
}

class OverlayPulseApp extends StatelessWidget {
  const OverlayPulseApp({super.key});

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'OverlayPulse',
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
        cardTheme: CardTheme(
          color: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class BubbleWidgetData {
  String id;
  String title;
  String content;
  IconData icon;
  Color color;
  Offset position;
  bool isMinimized;

  BubbleWidgetData({
    required this.id,
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
    required this.position,
    this.isMinimized = false,
  });
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Hourly wage for impulse calculation
  double _hourlyWage = 25.00;
  final TextEditingController _wageController = TextEditingController(text: "25.00");
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();

  // Calculated results
  String _calculatedItem = "";
  double _calculatedPrice = 0.0;
  double _calculatedHours = 0.0;
  String _calculatedRegretLevel = "";

  // Floating Overlay Bubbles
  final List<BubbleWidgetData> _bubbles = [
    BubbleWidgetData(
      id: "1",
      title: "Impulse Guard",
      content: "Sneakers: \$120 = 4.8 Work Hours",
      icon: Icons.monetization_on,
      color: Colors.teal,
      position: const Offset(20, 80),
    ),
    BubbleWidgetData(
      id: "2",
      title: "Quick Snippet",
      content: "Buy groceries at 6 PM & call Alex",
      icon: Icons.lightbulb,
      color: Colors.amber,
      position: const Offset(40, 260),
    ),
    BubbleWidgetData(
      id: "3",
      title: "Micro Decision",
      content: "Spin: Cook Dinner at Home!",
      icon: Icons.touch_app,
      color: Colors.purple,
      position: const Offset(30, 440),
    ),
  ];

  // Micro decision spinner options
  final List<String> _decisionOptions = [
    "Buy Now",
    "Wait 24 Hours",
    "Cook at Home",
    "Skip Purchase",
    "Do 10 Pushups",
    "Take 5m Break"
  ];
  String _spottedDecision = "Tap Spin to Decide!";

  // Permission Toggles
  bool _overlayPermission = true;
  bool _notificationPermission = true;
  bool _smartPulseActive = true;
  int _dailyPoints = 140;
  int _streakDays = 5;

  void _calculateImpulse() {
    FocusScope.of(context).unfocus();
    final double wage = double.tryParse(_wageController.text) ?? 25.0;
    final double price = double.tryParse(_itemPriceController.text) ?? 0.0;
    final String name = _itemNameController.text.trim().isEmpty
        ? "Selected Item"
        : _itemNameController.text.trim();

    if (price <= 0) return;

    final double hours = price / (wage <= 0 ? 1 : wage);
    String regret = "LOW RISK";
    if (hours > 20) {
      regret = "CRITICAL REGRET RISK";
    } else if (hours > 8) {
      regret = "HIGH IMPULSE RISK";
    } else if (hours > 3) {
      regret = "MODERATE RISK";
    }

    setState(() {
      _hourlyWage = wage;
      _calculatedItem = name;
      _calculatedPrice = price;
      _calculatedHours = hours;
      _calculatedRegretLevel = regret;
      _dailyPoints += 15;
    });

    // Add to floating canvas automatically
    _addBubble(
      name,
      "\$$price = ${hours.toStringAsFixed(1)} hrs work ($regret)",
      Icons.shopping_bag,
      Colors.teal,
    );
  }

  void _addBubble(String title, String content, IconData icon, Color color) {
    setState(() {
      _bubbles.add(
        BubbleWidgetData(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          content: content,
          icon: icon,
          color: color,
          position: Offset(30.0 + (_bubbles.length * 10), 100.0 + (_bubbles.length * 15)),
        ),
      );
    });
  }

  void _spinDecision() {
    final random = Random();
    final selected = _decisionOptions[random.nextInt(_decisionOptions.length)];
    setState(() {
      _spottedDecision = selected;
      _dailyPoints += 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bolt, color: Colors.tealAccent, size: 24),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'OverlayPulse',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.stars, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '$_dailyPoints pts',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildFloatingCanvasTab(),
            _buildImpulseGuardTab(),
            _buildSnippetsTab(),
            _buildPermissionsHubTab(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Canvas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Life-Cost',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Snippets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            label: 'Pulse Guard',
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating Canvas with Dynamic Floating Bubbles
  Widget _buildFloatingCanvasTab() {
    return Container(
      color: const Color(0xFF0F172A),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(Icons.touch_app, color: Colors.tealAccent, size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Interactive Floating Overlay",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Drag bubbles freely around the screen simulator.",
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.tealAccent),
                      onPressed: () {
                        _addBubble(
                          "Quick Note",
                          "Tap to customize snippet text!",
                          Icons.lightbulb,
                          Colors.blue,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                // Simulated phone background grid design
                Positioned.fill(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF182234),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.teal.withOpacity(0.3)),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.dashboard_customize,
                              size: 48, color: Colors.white.withOpacity(0.08)),
                          const SizedBox(height: 8),
                          Text(
                            "SCREEN OVERLAY SIMULATOR",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.15),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Render Interactive Draggable Bubbles
                ..._bubbles.map((bubble) {
                  return Positioned(
                    left: bubble.position.dx,
                    top: bubble.position.dy,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          bubble.position = Offset(
                            (bubble.position.dx + details.delta.dx).clamp(10.0, 260.0),
                            (bubble.position.dy + details.delta.dy).clamp(10.0, 420.0),
                          );
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: bubble.isMinimized ? 54 : 220,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: bubble.color.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(bubble.isMinimized ? 27 : 16),
                          boxShadow: [
                            BoxShadow(
                              color: bubble.color.withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: bubble.isMinimized
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    bubble.isMinimized = false;
                                  });
                                },
                                child: Center(
                                  child: Icon(bubble.icon, color: Colors.white, size: 26),
                                ),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(bubble.icon, color: Colors.white, size: 18),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          bubble.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            bubble.isMinimized = true;
                                          });
                                        },
                                        child: const Icon(Icons.close,
                                            color: Colors.white70, size: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    bubble.content,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                    softWrap: true,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: Impulse Purchase Life-Cost Calculator
  Widget _buildImpulseGuardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: const Color(0xFF1E293B),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.monetization_on, color: Colors.tealAccent, size: 24),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Impulse Purchase Life-Cost Converter",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Calculate how many hours of your life you must sacrifice to buy something before making an impulse decision.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    softWrap: true,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _wageController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                      labelText: "Your Hourly Income (\$/hr)",
                      labelStyle: TextStyle(color: Colors.tealAccent, fontSize: 12),
                      prefixIcon: Icon(Icons.account_balance_wallet, color: Colors.tealAccent),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _itemNameController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                      labelText: "Item Name (e.g. Designer Jacket)",
                      labelStyle: TextStyle(color: Colors.tealAccent, fontSize: 12),
                      prefixIcon: Icon(Icons.shopping_bag, color: Colors.tealAccent),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _itemPriceController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                      labelText: "Item Price (\$)",
                      labelStyle: TextStyle(color: Colors.tealAccent, fontSize: 12),
                      prefixIcon: Icon(Icons.attach_money, color: Colors.tealAccent),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _calculateImpulse,
                      icon: const Icon(Icons.calculate, color: Colors.white),
                      label: const Text(
                        "CONVERT TO WORK HOURS",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_calculatedPrice > 0) ...[
            const SizedBox(height: 16),
            Card(
              color: const Color(0xFF0F2942),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.tealAccent, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _calculatedItem.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "${_calculatedHours.toStringAsFixed(1)} HOURS",
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      "of direct work required to earn \$${_calculatedPrice.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.warning_amber, color: Colors.redAccent, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            _calculatedRegretLevel,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          // Micro Decision Wheel Section
          Card(
            color: const Color(0xFF1E293B),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.touch_app, color: Colors.purpleAccent, size: 24),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Instant Micro Decision Spinner",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Stuck in decision fatigue? Spin for instant direction on everyday micro-actions.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    softWrap: true,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.purpleAccent.withOpacity(0.4)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _spottedDecision,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purpleAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                            ),
                            onPressed: _spinDecision,
                            icon: const Icon(Icons.refresh, color: Colors.white),
                            label: const Text(
                              "SPIN DECISION",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 3: Active Snippets & Quick Floating Note Manager
  Widget _buildSnippetsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "Active Floating Snippets",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: () {
                  _addBubble(
                    "New Snippet",
                    "Tap to edit snippet content",
                    Icons.lightbulb,
                    Colors.orange,
                  );
                },
                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                label: const Text(
                  "Add Snippet",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _bubbles.length,
            itemBuilder: (context, index) {
              final bubble = _bubbles[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                color: const Color(0xFF1E293B),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: bubble.color.withOpacity(0.2),
                    child: Icon(bubble.icon, color: bubble.color, size: 20),
                  ),
                  title: Text(
                    bubble.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    bubble.content,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          bubble.isMinimized ? Icons.visibility_off : Icons.visibility,
                          color: Colors.tealAccent,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            bubble.isMinimized = !bubble.isMinimized;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                        onPressed: () {
                          setState(() {
                            _bubbles.removeAt(index);
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
    );
  }

  // TAB 4: Permissions & Floating Controller Hub
  Widget _buildPermissionsHubTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gamified Retention Card
          Card(
            color: const Color(0xFF1E293B),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.flash_on, color: Colors.orangeAccent, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Streak: $_streakDays Days Active",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Keep floating overlays active daily to earn decision streak points!",
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "System Permissions Guard",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            color: const Color(0xFF1E293B),
            child: Column(
              children: [
                SwitchListTile(
                  activeColor: Colors.tealAccent,
                  title: const Text(
                    "Display Over Other Apps",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    "Required to render floating decision bubbles on device screen.",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  value: _overlayPermission,
                  onChanged: (val) {
                    setState(() => _overlayPermission = val);
                  },
                ),
                const Divider(height: 1, color: Colors.white70),
                SwitchListTile(
                  activeColor: Colors.tealAccent,
                  title: const Text(
                    "Smart Floating Notifications",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    "Receive contextual urge alerts and micro-decision triggers.",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  value: _notificationPermission,
                  onChanged: (val) {
                    setState(() => _notificationPermission = val);
                  },
                ),
                const Divider(height: 1, color: Colors.white70),
                SwitchListTile(
                  activeColor: Colors.tealAccent,
                  title: const Text(
                    "Background Pulse Service",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    "Monitors impulse cooling timers in real-time.",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  value: _smartPulseActive,
                  onChanged: (val) {
                    setState(() => _smartPulseActive = val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFF1E293B),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.info, color: Colors.tealAccent, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "How OverlayPulse Solves Everyday Problems",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "1. Prevents financial regret by translating item costs directly into hours of life spent working.\n"
                    "2. Keeps notes and snippets floating on screen while switching between mobile apps.\n"
                    "3. Solves daily decision paralysis with instant micro-decision tools.",
                    style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.5),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}