import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const SnapHUDApp());
}

class SnapHUDApp extends StatelessWidget {
  const SnapHUDApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapHUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF12131C),
      ),
      home: const MainHUDDashboard(),
    );
  }
}

class MainHUDDashboard extends StatefulWidget {
  const MainHUDDashboard({Key? key}) : super(key: key);

  @override
  State<MainHUDDashboard> createState() => _MainHUDDashboardState();
}

class _MainHUDDashboardState extends State<MainHUDDashboard> {
  int _currentTab = 0;

  // Floating Overlay Control State
  bool _isOverlayActive = true;
  double _overlayOpacity = 0.85;
  Color _overlayColor = Colors.deepPurple;
  Offset _bubblePosition = const Offset(20, 150);
  bool _showReadingFilter = false;
  Color _filterTint = Colors.amber.withOpacity(0.15);

  // Decision Engine State
  final List<String> _decisionOptions = [
    'Eat Healthy Salad',
    'Order Pizza',
    'Take a 15 min Walk',
    'Power Nap 20m',
    'Read 5 Pages',
    'Drink Water Now',
  ];
  final TextEditingController _customOptionController = TextEditingController();
  String _selectedDecision = 'Tap Spin to Decide!';
  bool _isSpinning = false;

  // Quick Tools State
  final TextEditingController _priceController = TextEditingController(text: '100');
  final TextEditingController _discountController = TextEditingController(text: '15');
  final TextEditingController _peopleController = TextEditingController(text: '2');
  double _finalCalculatedPrice = 85.0;
  double _perPersonPrice = 42.5;

  // Notification Simulation
  final List<Map<String, String>> _activeNotifications = [
    {
      'title': '⚡ Hydration Goal',
      'body': 'Time to drink 250ml water!',
      'time': 'Just Now'
    },
    {
      'title': '🎯 Quick Focus Boost',
      'body': '5 min micro-break recommended.',
      'time': '10m ago'
    },
  ];

  void _recalculateMath() {
    double price = double.tryParse(_priceController.text) ?? 0.0;
    double discount = double.tryParse(_discountController.text) ?? 0.0;
    int people = int.tryParse(_peopleController.text) ?? 1;
    if (people < 1) people = 1;

    double discounted = price - (price * (discount / 100.0));
    setState(() {
      _finalCalculatedPrice = discounted < 0 ? 0 : discounted;
      _perPersonPrice = _finalCalculatedPrice / people;
    });
  }

  void _spinDecision() async {
    if (_decisionOptions.isEmpty || _isSpinning) return;
    setState(() {
      _isSpinning = true;
      _selectedDecision = 'Spinning options...';
    });

    for (int i = 0; i < 10; i++) {
      await Future.delayed(Duration(milliseconds: 100 + (i * 20)));
      int randomIndex = Random().nextInt(_decisionOptions.length);
      setState(() {
        _selectedDecision = _decisionOptions[randomIndex];
      });
    }

    setState(() {
      _isSpinning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Sight Filter Tint Simulation
          if (_showReadingFilter)
            IgnorePointer(
              child: Container(
                color: _filterTint,
              ),
            ),

          SafeArea(
            child: Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: IndexedStack(
                    index: _currentTab,
                    children: [
                      _buildFloatingHUDStudioTab(),
                      _buildMicroDecisionTab(),
                      _buildQuickToolsTab(),
                      _buildNotificationsSimTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Interactive Draggable Floating Bubble HUD Simulation
          if (_isOverlayActive)
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubblePosition += details.delta;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: _overlayColor.withOpacity(_overlayOpacity),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.widgets, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'SnapHUD Active',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: _spinDecision,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.shuffle, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (idx) => setState(() => _currentTab = idx),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E1F2E),
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'HUD Studio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shuffle),
            label: 'Decide',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Quick Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: 'Floating Heads',
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1F2E),
        border: Border(
          bottom: BorderSide(color: Colors.white70, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.dashboard, color: Colors.deepPurpleAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SnapHUD Live Studio',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _isOverlayActive ? '● Floating Overlay Enabled' : '○ Overlay Idle',
                  style: TextStyle(
                    color: _isOverlayActive ? Colors.greenAccent : Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isOverlayActive,
            activeColor: Colors.deepPurpleAccent,
            onChanged: (val) {
              setState(() => _isOverlayActive = val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingHUDStudioTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBannerCard(
              title: 'Floating Assistant Engine',
              subtitle: 'Drag the dynamic bubble anywhere! Test ambient screen tints and floating shortcuts.',
              icon: Icons.touch_app,
              badge: 'ALWAYS ON TOP',
            ),
            const SizedBox(height: 20),

            // HUD Customizer
            const Text(
              'Floating Bubble Customizer',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1F2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Bubble Opacity', style: TextStyle(color: Colors.white70)),
                      Text('${(_overlayOpacity * 100).toInt()}%', style: const TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: _overlayOpacity,
                    min: 0.3,
                    max: 1.0,
                    activeColor: Colors.deepPurpleAccent,
                    onChanged: (v) => setState(() => _overlayOpacity = v),
                  ),
                  const SizedBox(height: 10),
                  const Text('HUD Color Theme', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildColorChip('Deep Purple', Colors.deepPurple),
                      _buildColorChip('Teal Shield', Colors.teal),
                      _buildColorChip('Amber Glow', Colors.amber),
                      _buildColorChip('Crimson Nitro', Colors.red),
                      _buildColorChip('Midnight Blue', Colors.indigo),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sight Protector Screen Tint Engine
            const Text(
              'Ambient Sight-Saver Overlay',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1F2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.visibility, color: _showReadingFilter ? Colors.amber : Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Warm Reading Filter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            Text('Reduces fatigue during long reading sessions', style: TextStyle(color: Colors.grey, fontSize: 11)),
                          ],
                        ),
                      ),
                      Switch(
                        value: _showReadingFilter,
                        activeColor: Colors.amber,
                        onChanged: (val) {
                          setState(() => _showReadingFilter = val);
                        },
                      ),
                    ],
                  ),
                  if (_showReadingFilter) ...[
                    const Divider(color: Colors.white70, height: 20),
                    Row(
                      children: [
                        _buildFilterPreset('Amber Warm', Colors.amber.withOpacity(0.18)),
                        const SizedBox(width: 8),
                        _buildFilterPreset('Soft Green', Colors.green.withOpacity(0.15)),
                        const SizedBox(width: 8),
                        _buildFilterPreset('Sepia', Colors.orange.withOpacity(0.15)),
                      ],
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorChip(String name, Color col) {
    bool isSelected = _overlayColor == col;
    return ChoiceChip(
      label: Text(name),
      selected: isSelected,
      selectedColor: col,
      backgroundColor: const Color(0xFF2A2C3D),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.white70,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (selected) {
        if (selected) setState(() => _overlayColor = col);
      },
    );
  }

  Widget _buildFilterPreset(String label, Color col) {
    bool active = _filterTint == col;
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: active ? Colors.amber : const Color(0xFF2A2C3D),
          foregroundColor: active ? Colors.black : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () => setState(() => _filterTint = col),
        child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildMicroDecisionTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBannerCard(
              title: 'Micro-Decision Engine',
              subtitle: 'Stop wasting time deciding what to eat, do, or focus on. Let SnapHUD decide instantly!',
              icon: Icons.shuffle,
              badge: 'DECISION fatigue KILLER',
            ),
            const SizedBox(height: 20),

            // Spin Display Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple.shade900, const Color(0xFF1E1F2E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'HUD DECISION MATRIX RESULT',
                    style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      _selectedDecision,
                      key: ValueKey<String>(_selectedDecision),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _isSpinning ? null : _spinDecision,
                    icon: _isSpinning
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.play_arrow),
                    label: Text(_isSpinning ? 'SPINNING...' : 'SPIN DECISION WHEEL'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Decision Item Management
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Current Options Matrix',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  '${_decisionOptions.length} Items',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Add Custom Option Input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customOptionController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Add custom choice (e.g. Clean Desk)...',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFF1E1F2E),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white70),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  backgroundColor: Colors.deepPurple,
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    if (_customOptionController.text.trim().isNotEmpty) {
                      setState(() {
                        _decisionOptions.add(_customOptionController.text.trim());
                        _customOptionController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Option Chips Wrap
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _decisionOptions.map((opt) {
                return Chip(
                  label: Text(opt, style: const TextStyle(color: Colors.white, fontSize: 12)),
                  backgroundColor: const Color(0xFF1E1F2E),
                  deleteIcon: const Icon(Icons.close, size: 14, color: Colors.grey),
                  onDeleted: () {
                    setState(() {
                      _decisionOptions.remove(opt);
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.white70),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickToolsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBannerCard(
              title: 'Context Micro-Calculators',
              subtitle: 'Instant daily micro calculations: split bill math & discount calculations with zero delay.',
              icon: Icons.calculate,
              badge: 'FAST UTILITY',
            ),
            const SizedBox(height: 20),

            // Fast Math Suite Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1F2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '⚡ Discount & Bill Split Calculator',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          onChanged: (_) => _recalculateMath(),
                          decoration: InputDecoration(
                            labelText: 'Original Price (\$)',
                            labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                            filled: true,
                            fillColor: const Color(0xFF2A2C3D),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _discountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          onChanged: (_) => _recalculateMath(),
                          decoration: InputDecoration(
                            labelText: 'Discount (%)',
                            labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                            filled: true,
                            fillColor: const Color(0xFF2A2C3D),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _peopleController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (_) => _recalculateMath(),
                    decoration: InputDecoration(
                      labelText: 'Split Between (People)',
                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                      filled: true,
                      fillColor: const Color(0xFF2A2C3D),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('FINAL TOTAL', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                              '\$${_finalCalculatedPrice.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(height: 30, width: 1, color: Colors.white70),
                        Column(
                          children: [
                            const Text('PER PERSON', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                              '\$${_perPersonPrice.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.amberAccent, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Fast Text Snippets Engine
            const Text(
              'Floating Response Snippets',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSnippetTile('I am on my way!', Icons.directions_run),
                _buildSnippetTile('Can I call you in 10 mins?', Icons.phone),
                _buildSnippetTile('Please send details.', Icons.send),
                _buildSnippetTile('Running slightly late.', Icons.schedule),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSnippetTile(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1F2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.deepPurpleAccent),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Copied: "$text"'),
                  duration: const Duration(seconds: 1),
                  backgroundColor: Colors.deepPurple,
                ),
              );
            },
            child: const Icon(Icons.content_copy, size: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSimTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBannerCard(
              title: 'Floating Heads & Action Banners',
              subtitle: 'Simulate high-priority dynamic banners and contextual overlay alerts without switching apps.',
              icon: Icons.notifications_active,
              badge: 'SYSTEM OVERLAY DEMO',
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Active Sticky Alerts',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _activeNotifications.add({
                        'title': '💡 Micro Task Alert',
                        'body': 'Take a deep breath and stretch!',
                        'time': 'Just Now'
                      });
                    });
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Alert', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (_activeNotifications.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1F2E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text('No active notifications', style: TextStyle(color: Colors.grey)),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _activeNotifications.length,
                itemBuilder: (context, index) {
                  final notif = _activeNotifications[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1F2E),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.flash_on, color: Colors.amberAccent, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    notif['title'] ?? '',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  Text(
                                    notif['time'] ?? '',
                                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notif['body'] ?? '',
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.greenAccent, size: 18),
                          onPressed: () {
                            setState(() {
                              _activeNotifications.removeAt(index);
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
      ),
    );
  }

  Widget _buildBannerCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String badge,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1F2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(color: Colors.deepPurpleAccent, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(icon, color: Colors.deepPurpleAccent, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      softWrap: true,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}