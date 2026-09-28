import 'package:flutter/material.dart';

void main() {
  runApp(const PocketDockApp());
}

class PocketDockApp extends StatelessWidget {
  const PocketDockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PocketDock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainDockScreen(),
    );
  }
}

class MainDockScreen extends StatefulWidget {
  const MainDockScreen({super.key});

  @override
  State<MainDockScreen> createState() => _MainDockScreenState();
}

class _MainDockScreenState extends State<MainDockScreen> {
  int _currentTab = 0;

  // Floating Overlay State Simulation
  bool _overlayPermissionGranted = true;
  bool _notificationServiceActive = true;
  bool _floatingDockVisible = true;
  Offset _bubblePosition = const Offset(280, 250);
  bool _isExpandedDock = false;

  // Screen Privacy Guard State
  bool _privacyShadeEnabled = false;
  double _shadeOpacity = 0.85;
  double _shadeHeight = 160.0;
  double _shadePositionY = 220.0;
  Color _shadeColor = Colors.black;

  // ClipStack State
  final List<Map<String, String>> _clipboardItems = [
    {
      'title': 'Delivery Address',
      'text': 'No 45, Flower Road, Colombo 07, Sri Lanka',
      'category': 'Address'
    },
    {
      'title': 'Promo Code',
      'text': 'SAVE20NOW-MEGA-OFFER',
      'category': 'Code'
    },
    {
      'title': 'Meeting Notes Snippet',
      'text': 'Send final quarterly design mockups before 5:00 PM today.',
      'category': 'Notes'
    },
  ];
  final TextEditingController _clipInputController = TextEditingController();

  // Floating Quick Tools State - Shopping Splitter
  final TextEditingController _priceController = TextEditingController(text: '120.00');
  final TextEditingController _discountController = TextEditingController(text: '15');
  final TextEditingController _taxController = TextEditingController(text: '8');
  final TextEditingController _peopleController = TextEditingController(text: '3');
  String _calculatedSplitResult = '';

  // Decision Spinner State
  final List<String> _decisionOptions = ['Pizza', 'Sushi', 'Burgers', 'Home Cooked'];
  final TextEditingController _decisionInputController = TextEditingController();
  String _spinWinner = 'Tap Spin to Decide!';

  // Soundscape Masker State
  bool _isPlayingSound = false;
  String _activeSoundTrack = 'Rain & Thunder';
  double _soundVolume = 0.7;

  @override
  void initState() {
    super.initState();
    _calculateSplit();
  }

  void _calculateSplit() {
    double price = double.tryParse(_priceController.text) ?? 0.0;
    double discount = double.tryParse(_discountController.text) ?? 0.0;
    double tax = double.tryParse(_taxController.text) ?? 0.0;
    int people = int.tryParse(_peopleController.text) ?? 1;
    if (people < 1) people = 1;

    double discountedPrice = price - (price * (discount / 100.0));
    double finalTotal = discountedPrice + (discountedPrice * (tax / 100.0));
    double perPerson = finalTotal / people;

    setState(() {
      _calculatedSplitResult =
          'Total: \$${finalTotal.toStringAsFixed(2)} | Per Person: \$${perPerson.toStringAsFixed(2)}';
    });
  }

  void _addClipboardSnippet() {
    if (_clipInputController.text.trim().isNotEmpty) {
      setState(() {
        _clipboardItems.insert(0, {
          'title': 'Quick Clip #${_clipboardItems.length + 1}',
          'text': _clipInputController.text.trim(),
          'category': 'Custom',
        });
        _clipInputController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Snippet added to floating dock shelf!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _spinDecision() {
    if (_decisionOptions.isEmpty) return;
    final randomIndex = (DateTime.now().millisecondsSinceEpoch) % _decisionOptions.length;
    setState(() {
      _spinWinner = '🎯 Winner: ${_decisionOptions[randomIndex]}';
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      _buildFloatingLauncherTab(),
                      _buildPrivacyGuardTab(),
                      _buildClipStackTab(),
                      _buildQuickToolsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Privacy Peeking Shield Screen Overlay Simulation
          if (_privacyShadeEnabled) _buildPrivacyShadeOverlay(),

          // Interactive Draggable Floating Bubble Overlay Simulation
          if (_floatingDockVisible) _buildInteractiveFloatingBubble(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFF334155), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentTab,
          onTap: (index) => setState(() => _currentTab = index),
          backgroundColor: const Color(0xFF0F172A),
          selectedItemColor: Colors.tealAccent,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              label: 'Floating Dock',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.security),
              label: 'Peeking Shield',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.copy),
              label: 'ClipStack',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tune),
              label: 'Quick Tools',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(
          bottom: BorderSide(color: Color(0xFF334155), width: 1),
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
                  color: Colors.teal.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.layers, color: Colors.tealAccent, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'PocketDock',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Floating Screen Utility & Companion',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _floatingDockVisible ? Icons.visibility : Icons.visibility_off,
                  color: _floatingDockVisible ? Colors.tealAccent : Colors.grey,
                ),
                tooltip: 'Toggle Floating Dock Overlay',
                onPressed: () {
                  setState(() {
                    _floatingDockVisible = !_floatingDockVisible;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating Launcher & System Permissions
  Widget _buildFloatingLauncherTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade900, Colors.indigo.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Floating Assistant Status',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _floatingDockVisible ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _floatingDockVisible ? Colors.green : Colors.red),
                        ),
                        child: Text(
                          _floatingDockVisible ? 'ACTIVE OVERLAY' : 'DISABLED',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _floatingDockVisible ? Colors.greenAccent : Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Drag the floating pocket bubble anywhere on your device. Tap it to immediately access your clipboards, quick calculators, privacy screens, and ambient tools from any app.',
                    style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.black,
                        ),
                        icon: const Icon(Icons.touch_app, size: 18),
                        label: Text(_isExpandedDock ? 'Collapse Floating Dock' : 'Expand Floating Dock'),
                        onPressed: () {
                          setState(() {
                            _isExpandedDock = !_isExpandedDock;
                          });
                        },
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.tealAccent),
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Reset Bubble Pos'),
                        onPressed: () {
                          setState(() {
                            _bubblePosition = const Offset(280, 250);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Overlay System Permissions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),

            _buildPermissionTile(
              icon: Icons.layers,
              title: 'Display Above Other Apps',
              subtitle: 'Allows floating widget dock overlay over Facebook, WhatsApp & Chrome.',
              value: _overlayPermissionGranted,
              onChanged: (val) {
                setState(() {
                  _overlayPermissionGranted = val;
                  if (!val) _floatingDockVisible = false;
                });
              },
            ),
            _buildPermissionTile(
              icon: Icons.notifications_active,
              title: 'Floating Heads & Quick Notification',
              subtitle: 'Keeps quick action shortcut controls alive in background drawer.',
              value: _notificationServiceActive,
              onChanged: (val) {
                setState(() => _notificationServiceActive = val);
              },
            ),

            const SizedBox(height: 20),
            const Text(
              'Quick Bubble Action Shortcuts',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildShortcutCard('Screen Shield', Icons.security, Colors.blue, () {
                  setState(() {
                    _privacyShadeEnabled = !_privacyShadeEnabled;
                  });
                }),
                _buildShortcutCard('Clip Board', Icons.copy, Colors.amber, () {
                  setState(() => _currentTab = 2);
                }),
                _buildShortcutCard('Bill Splitter', Icons.calculate, Colors.green, () {
                  setState(() => _currentTab = 3);
                }),
                _buildShortcutCard('Decision Wheel', Icons.casino, Colors.purple, () {
                  setState(() => _currentTab = 3);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: value ? Colors.tealAccent : Colors.grey),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        value: value,
        activeColor: Colors.teal,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildShortcutCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 155,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: Peeking Shield / Privacy Screen Overlay
  Widget _buildPrivacyGuardTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield, color: Colors.blueAccent, size: 36),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Screen Peeking Shield',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _privacyShadeEnabled
                              ? 'Shield is currently ACTIVE on screen overlay.'
                              : 'Enable shield to obscure private chat or bank details on buses or in public.',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _privacyShadeEnabled,
                    activeColor: Colors.blueAccent,
                    onChanged: (val) {
                      setState(() {
                        _privacyShadeEnabled = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Adjust Privacy Guard Overlay',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Opacity Control
            Text('Shade Opacity: ${(_shadeOpacity * 100).toInt()}%',
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
            Slider(
              value: _shadeOpacity,
              min: 0.3,
              max: 1.0,
              activeColor: Colors.blueAccent,
              onChanged: (val) => setState(() => _shadeOpacity = val),
            ),

            // Height Control
            Text('Shade Height: ${_shadeHeight.toInt()} px',
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
            Slider(
              value: _shadeHeight,
              min: 80.0,
              max: 350.0,
              activeColor: Colors.blueAccent,
              onChanged: (val) => setState(() => _shadeHeight = val),
            ),

            // Position Y Control
            Text('Vertical Position Y: ${_shadePositionY.toInt()} px',
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
            Slider(
              value: _shadePositionY,
              min: 50.0,
              max: 500.0,
              activeColor: Colors.blueAccent,
              onChanged: (val) => setState(() => _shadePositionY = val),
            ),

            const SizedBox(height: 12),
            const Text('Shade Style Color', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildColorOption(Colors.black),
                const SizedBox(width: 12),
                _buildColorOption(const Color(0xFF0F172A)),
                const SizedBox(width: 12),
                _buildColorOption(Colors.indigo.shade900),
                const SizedBox(width: 12),
                _buildColorOption(Colors.brown.shade900),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    bool isSelected = _shadeColor == color;
    return GestureDetector(
      onTap: () => setState(() => _shadeColor = color),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.tealAccent : Colors.grey,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: isSelected ? const Icon(Icons.check, color: Colors.tealAccent, size: 20) : null,
      ),
    );
  }

  // TAB 3: ClipStack Clipboard Shelf
  Widget _buildClipStackTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ClipStack Staging Shelf',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            const Text(
              'Save multiple snippets to quickly paste from the floating overlay while multitasking.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Input box
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _clipInputController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Type or paste quick note/link...',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Color(0xFF1E293B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Color(0xFF334155)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _addClipboardSnippet,
                  child: const Icon(Icons.add, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 20),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _clipboardItems.length,
              itemBuilder: (context, index) {
                final item = _clipboardItems[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item['category'] ?? 'Clip',
                              style: const TextStyle(fontSize: 10, color: Colors.tealAccent, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.copy, size: 18, color: Colors.grey),
                                tooltip: 'Copy to Clipboard',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Copied "${item['text']}" to Clipboard!'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 18, color: Colors.redAccent),
                                onPressed: () {
                                  setState(() {
                                    _clipboardItems.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['text'] ?? '',
                        style: const TextStyle(fontSize: 13, color: Colors.white),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // TAB 4: Floating Quick Tools Hub
  Widget _buildQuickToolsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bill & Split Calculator
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
                  Row(
                    children: const [
                      Icon(Icons.calculate, color: Colors.greenAccent),
                      SizedBox(width: 8),
                      Text(
                        'Floating Bill Splitter & Discount Calc',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: const InputDecoration(
                            labelText: 'Price (\$) =',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => _calculateSplit(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _discountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: const InputDecoration(
                            labelText: 'Discount % =',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => _calculateSplit(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _taxController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: const InputDecoration(
                            labelText: 'Tax % =',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => _calculateSplit(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _peopleController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: const InputDecoration(
                            labelText: 'People =',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => _calculateSplit(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withOpacity(0.4)),
                    ),
                    child: Text(
                      _calculatedSplitResult,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Decision Spinner Tool
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
                  Row(
                    children: const [
                      Icon(Icons.casino, color: Colors.purpleAccent),
                      SizedBox(width: 8),
                      Text(
                        'Quick Micro-Decision Spinner',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _decisionOptions
                        .map((opt) => Chip(
                              label: Text(opt, style: const TextStyle(fontSize: 11, color: Colors.white)),
                              backgroundColor: const Color(0xFF334155),
                              deleteIcon: const Icon(Icons.close, size: 14, color: Colors.grey),
                              onDeleted: () {
                                setState(() {
                                  _decisionOptions.remove(opt);
                                });
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _decisionInputController,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: const InputDecoration(
                            hintText: 'Add option (e.g. Lunch, Task)...',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
                        onPressed: () {
                          if (_decisionInputController.text.trim().isNotEmpty) {
                            setState(() {
                              _decisionOptions.add(_decisionInputController.text.trim());
                              _decisionInputController.clear();
                            });
                          }
                        },
                        child: const Text('Add', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.shuffle, color: Colors.white),
                          label: const Text('Spin Random Picker', style: TextStyle(color: Colors.white)),
                          onPressed: _spinDecision,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      _spinWinner,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.amberAccent),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Soundscape Ambient Generator
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.volume_up, color: Colors.tealAccent),
                          SizedBox(width: 8),
                          Text(
                            'Ambient Background Sound Masker',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          _isPlayingSound ? Icons.pause_circle_filled : Icons.play_circle_fill,
                          color: Colors.tealAccent,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPlayingSound = !_isPlayingSound;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Active Track: $_activeSoundTrack ${_isPlayingSound ? "(Playing in background)" : "(Paused)"}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: ['Rain & Thunder', 'Cafe Ambient', 'Deep White Noise', 'Ocean Waves']
                        .map((track) => ChoiceChip(
                              label: Text(track, style: const TextStyle(fontSize: 11)),
                              selected: _activeSoundTrack == track,
                              selectedColor: Colors.teal,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _activeSoundTrack = track;
                                    _isPlayingSound = true;
                                  });
                                }
                              },
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET: Simulated Screen Privacy Guard Overlay Bar
  Widget _buildPrivacyShadeOverlay() {
    return Positioned(
      top: _shadePositionY,
      left: 0,
      right: 0,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            _shadePositionY = (_shadePositionY + details.delta.dy).clamp(40.0, 550.0);
          });
        },
        child: Container(
          height: _shadeHeight,
          decoration: BoxDecoration(
            color: _shadeColor.withOpacity(_shadeOpacity),
            boxShadow: const [
              BoxShadow(color: Colors.black87, blurRadius: 10, spreadRadius: 2),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.drag_handle, color: Colors.white70),
                    SizedBox(width: 8),
                    Text(
                      '🔒 PEEKING SHIELD ACTIVE (Drag to Adjust)',
                      style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70, size: 18),
                  onPressed: () => setState(() => _privacyShadeEnabled = false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET: Simulated Draggable Floating Overlay Dock Bubble
  Widget _buildInteractiveFloatingBubble() {
    return Positioned(
      left: _bubblePosition.dx,
      top: _bubblePosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubblePosition = Offset(
              (_bubblePosition.dx + details.delta.dx).clamp(10.0, MediaQuery.of(context).size.width - 70),
              (_bubblePosition.dy + details.delta.dy).clamp(40.0, MediaQuery.of(context).size.height - 120),
            );
          });
        },
        child: Material(
          elevation: 10,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: Column(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.tealAccent, Colors.indigoAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    _isExpandedDock ? Icons.close : Icons.layers,
                    color: Colors.black,
                    size: 28,
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpandedDock = !_isExpandedDock;
                    });
                  },
                ),
              ),
              if (_isExpandedDock) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.tealAccent.withOpacity(0.5)),
                    boxShadow: const [
                      BoxShadow(color: Colors.black87, blurRadius: 10),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildFloatingDockIconButton(Icons.security, Colors.blueAccent, () {
                        setState(() => _privacyShadeEnabled = !_privacyShadeEnabled);
                      }),
                      const SizedBox(height: 6),
                      _buildFloatingDockIconButton(Icons.copy, Colors.amberAccent, () {
                        setState(() => _currentTab = 2);
                      }),
                      const SizedBox(height: 6),
                      _buildFloatingDockIconButton(Icons.calculate, Colors.greenAccent, () {
                        setState(() => _currentTab = 3);
                      }),
                      const SizedBox(height: 6),
                      _buildFloatingDockIconButton(
                        _isPlayingSound ? Icons.volume_up : Icons.volume_off,
                        Colors.purpleAccent,
                        () {
                          setState(() => _isPlayingSound = !_isPlayingSound);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingDockIconButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}