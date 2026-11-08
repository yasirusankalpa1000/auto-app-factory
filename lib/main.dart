import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const OmniBubbleApp());
}

class OmniBubbleApp extends StatelessWidget {
  const OmniBubbleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniBubble',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121420),
        primaryColor: Colors.deepPurple,
        colorScheme: const ColorScheme.dark(
          primary: Colors.purpleAccent,
          secondary: Colors.tealAccent,
          surface: Color(0xFF1B1E2E),
        ),
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

class _MainHomeScreenState extends State<MainHomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentTab = 0;
  bool _showFloatingBubble = true;
  Offset _bubblePosition = const Offset(20, 150);
  int _dailyEngagementScore = 140;

  // Decision Wheel State
  final List<String> _wheelOptions = [
    'Order Pizza',
    'Cook at Home',
    'Healthy Salad',
    'Eat Tacos',
    'Sushi Night'
  ];
  final TextEditingController _newOptionController = TextEditingController();
  late AnimationController _spinController;
  late Animation<double> _spinAnimation;
  double _currentWheelAngle = 0;
  String _wheelResult = 'Tap Spin to Decide!';

  // Affordability Radar State
  double _monthlyIncome = 1500;
  double _dailyAllowance = 50;
  double _itemCost = 45;
  String _affordabilityResult = 'Safe to Buy!';

  // Message Cleaner State
  final TextEditingController _rawTextController = TextEditingController();
  String _cleanedText = '';

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _spinAnimation = CurvedAnimation(
      parent: _spinController,
      curve: Curves.decelerate,
    );

    _spinController.addListener(() {
      setState(() {
        _currentWheelAngle = _spinAnimation.value * 2 * math.pi * 5;
      });
    });

    _spinController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final selectedIndex =
            math.Random().nextInt(_wheelOptions.length);
        setState(() {
          _wheelResult = 'Selected: ${_wheelOptions[selectedIndex]}';
          _dailyEngagementScore += 15;
        });
      }
    });
  }

  @override
  void dispose() {
    _spinController.dispose();
    _newOptionController.dispose();
    _rawTextController.dispose();
    super.dispose();
  }

  void _spinWheel() {
    if (_wheelOptions.isEmpty) return;
    setState(() {
      _wheelResult = 'Spinning...';
    });
    _spinController.forward(from: 0.0);
  }

  void _cleanInputText() {
    String text = _rawTextController.text;
    if (text.isEmpty) return;

    // Format text into bullet points and trim spaces
    List<String> lines = text.split('\n');
    List<String> cleaned = lines
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .map((l) => l.startsWith('•') ? l : '• $l')
        .toList();

    setState(() {
      _cleanedText = cleaned.join('\n');
      _dailyEngagementScore += 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: IndexedStack(
                    index: _currentTab,
                    children: [
                      _buildDecisionWheelTab(),
                      _buildAffordabilityRadarTab(),
                      _buildMessagePolisherTab(),
                      _buildSettingsHubTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Interactive Simulated Floating Bubble Overlay
          if (_showFloatingBubble)
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    double newX = _bubblePosition.dx + details.delta.dx;
                    double newY = _bubblePosition.dy + details.delta.dy;
                    // Keep bubble within bounds
                    newX = newX.clamp(10.0, screenSize.width - 70.0);
                    newY = newY.clamp(50.0, screenSize.height - 120.0);
                    _bubblePosition = Offset(newX, newY);
                  });
                },
                onTap: () {
                  _showQuickBubbleModal(context);
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Colors.purpleAccent, Colors.tealAccent],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purpleAccent.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.bubble_chart,
                      color: Colors.black,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (index) {
          setState(() {
            _currentTab = index;
          });
        },
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1B1E2E),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shuffle),
            label: 'Decision',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Radar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: 'Polisher',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Overlay',
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1B1E2E),
        border: Border(
          bottom: BorderSide(color: Colors.white70, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purpleAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.bubble_chart, color: Colors.purpleAccent),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OmniBubble Companion',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Active Overlay Assistant',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.tealAccent,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber, width: 0.8),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(
                  '$_dailyEngagementScore pts',
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
    );
  }

  // --- TAB 1: DECISION WHEEL STUDIO ---
  Widget _buildDecisionWheelTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Everyday Micro-Decision Wheel',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Can\'t decide what to eat, buy, or do next? Let the bubble decide.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),

            // Spinning Wheel Display
            SizedBox(
              height: 220,
              width: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: _currentWheelAngle,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.tealAccent, width: 4),
                        gradient: const SweepGradient(
                          colors: [
                            Colors.deepPurple,
                            Colors.teal,
                            Colors.indigo,
                            Colors.blue,
                            Colors.deepPurple,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.casino,
                          size: 80,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 10,
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: 40,
                      color: Colors.amber,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _spinWheel,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.purpleAccent,
                      elevation: 6,
                    ),
                    child: const Text(
                      'SPIN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1E2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white70),
              ),
              child: Text(
                _wheelResult,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.tealAccent,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),
            // Custom Option Add Form
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newOptionController,
                    decoration: const InputDecoration(
                      hintText: 'Add custom choice...',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_newOptionController.text.trim().isNotEmpty) {
                      setState(() {
                        _wheelOptions.add(_newOptionController.text.trim());
                        _newOptionController.clear();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    foregroundColor: Colors.black,
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAxisAlignment.center,
              children: _wheelOptions.map((opt) {
                return Chip(
                  label: Text(
                    opt,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: const Color(0xFF1B1E2E),
                  deleteIcon: const Icon(Icons.close, size: 14),
                  onDeleted: () {
                    setState(() {
                      _wheelOptions.remove(opt);
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

  // --- TAB 2: AFFORDABILITY RADAR ---
  Widget _buildAffordabilityRadarTab() {
    double safeRemainingAfterPurchase = _dailyAllowance - _itemCost;
    bool isSafe = safeRemainingAfterPurchase >= 0;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Instant Affordability Radar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Should you buy this right now? Calculate daily financial impact instantly.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Item Cost Slider
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1E2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Target Purchase Cost:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '\\\$${_itemCost.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purpleAccent,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _itemCost,
                    min: 5,
                    max: 200,
                    divisions: 39,
                    activeColor: Colors.purpleAccent,
                    onChanged: (val) {
                      setState(() {
                        _itemCost = val;
                      });
                    },
                  ),
                  const Divider(color: Colors.white70),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Daily Safe Allowance:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '\\\$${_dailyAllowance.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.tealAccent,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _dailyAllowance,
                    min: 10,
                    max: 300,
                    divisions: 29,
                    activeColor: Colors.tealAccent,
                    onChanged: (val) {
                      setState(() {
                        _dailyAllowance = val;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Visual Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isSafe
                    ? Colors.green.withOpacity(0.15)
                    : Colors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSafe ? Colors.green : Colors.red,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    isSafe ? Icons.check_circle : Icons.warning_amber,
                    color: isSafe ? Colors.green : Colors.red,
                    size: 44,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isSafe
                        ? 'SAFE TO BUY TODAY!'
                        : 'BUDGET OVERRUN RISK!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSafe ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isSafe
                        ? 'Remaining daily cushion: \\\$${safeRemainingAfterPurchase.toStringAsFixed(2)}'
                        : 'Exceeds today\'s safe budget by \\\$${(safeRemainingAfterPurchase.abs()).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 3: MESSAGE POLISHER ---
  Widget _buildMessagePolisherTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Message & Note Polisher',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Paste messy chat notes, shopping lists, or thoughts to instant clean format.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _rawTextController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Paste raw messy text here...\nExample:\nMilk\nBread\nEggs',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _cleanInputText,
                icon: const Icon(Icons.cleaning_services),
                label: const Text('Format & Polish Text'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_cleanedText.isNotEmpty) ...[
              const Text(
                'Polished Ready-To-Send Text:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.tealAccent,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1E2E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white70),
                ),
                child: SelectableText(
                  _cleanedText,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Text copied to clipboard preview!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Copy Clean Text'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --- TAB 4: FLOATING OVERLAY SETTINGS ---
  Widget _buildSettingsHubTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Floating Bubble & Permissions Studio',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Configure app overlay companion heads and interactive quick shortcuts.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Toggle Bubble Switch
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1E2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white70),
              ),
              child: SwitchListTile(
                title: const Text(
                  'Enable Floating Bubble Overlay',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Allows bubble head to float over your app workspace.',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
                value: _showFloatingBubble,
                activeColor: Colors.tealAccent,
                onChanged: (val) {
                  setState(() {
                    _showFloatingBubble = val;
                  });
                },
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'System Feature & Permission Status',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.purpleAccent,
              ),
            ),
            const SizedBox(height: 10),

            _buildPermissionTile(
              icon: Icons.layers,
              title: 'Display Over Other Apps Simulation',
              status: 'Active',
              isGranted: true,
            ),
            const SizedBox(height: 8),
            _buildPermissionTile(
              icon: Icons.notifications,
              title: 'Smart Instant Micro Notifications',
              status: 'Granted',
              isGranted: true,
            ),
            const SizedBox(height: 8),
            _buildPermissionTile(
              icon: Icons.touch_app,
              title: 'Haptic Touch Gesture Feedback',
              status: 'Ready',
              isGranted: true,
            ),

            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.indigo],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.stars, color: Colors.amber, size: 36),
                  const SizedBox(height: 8),
                  const Text(
                    'Daily Companion Streak: 5 Days',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Use micro-tools daily to earn efficiency score points!',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionTile({
    required IconData icon,
    required String title,
    required String status,
    required bool isGranted,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1E2E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.tealAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 13, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isGranted
                  ? Colors.green.withOpacity(0.2)
                  : Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isGranted ? Colors.green : Colors.amber,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickBubbleModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B1E2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'OmniBubble Quick Assistant',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.tealAccent,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickActionButton(
                    icon: Icons.shuffle,
                    label: 'Quick Spin',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _currentTab = 0;
                      });
                      _spinWheel();
                    },
                  ),
                  _buildQuickActionButton(
                    icon: Icons.monetization_on,
                    label: 'Afford Check',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _currentTab = 1;
                      });
                    },
                  ),
                  _buildQuickActionButton(
                    icon: Icons.cleaning_services,
                    label: 'Clean Text',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _currentTab = 2;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.purpleAccent.withOpacity(0.2),
            child: Icon(icon, color: Colors.purpleAccent),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}