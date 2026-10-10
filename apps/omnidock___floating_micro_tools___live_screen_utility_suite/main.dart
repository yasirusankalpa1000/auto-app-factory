import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const OmniDockApp());
}

class OmniDockApp extends StatelessWidget {
  const OmniDockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniDock Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
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
  int _selectedTabIndex = 0;
  bool _isOverlayActive = true;
  Offset _bubblePosition = const Offset(20, 160);
  bool _isBubbleExpanded = false;

  // Clipboard Snippets Data
  final List<String> _clipboardSnippets = [
    'Delivery Address: 742 Evergreen Terrace, Springfield',
    'Tax ID / Account Number: 8839-2041-9921',
    'Wi-Fi Passphrase: SecurityKey2025!',
  ];
  final TextEditingController _snippetController = TextEditingController();

  // Deal Comparator Data
  final TextEditingController _item1NameController = TextEditingController(text: 'Option A (Small)');
  final TextEditingController _item1PriceController = TextEditingController(text: '4.50');
  final TextEditingController _item1QtyController = TextEditingController(text: '350');

  final TextEditingController _item2NameController = TextEditingController(text: 'Option B (Large)');
  final TextEditingController _item2PriceController = TextEditingController(text: '7.90');
  final TextEditingController _item2QtyController = TextEditingController(text: '750');

  String _comparatorResult = 'Tap "Compare Best Value" to see savings.';
  String _bestOption = '';

  // Decision Maker Data
  final List<String> _decisions = [
    'Order Food Online',
    'Cook at Home',
    'Take a 15-min Walk',
    'Read 5 Pages',
    'Quick Power Nap'
  ];
  final TextEditingController _newDecisionController = TextEditingController();
  String _selectedDecision = 'Spin the wheel to decide!';
  bool _isSpinning = false;

  // Speed Reader Data
  final TextEditingController _speedTextController = TextEditingController(
    text: 'OmniDock keeps your everyday micro tools floating right at your fingertips so you save time and money.',
  );
  List<String> _readerWords = [];
  int _currentWordIndex = 0;
  bool _isReaderPlaying = false;
  int _wpm = 250;
  Timer? _readerTimer;

  // Active Notification Stream Simulation
  String _simulatedNotification = 'OmniDock Overlay Engine is active and running.';

  @override {
    super.initState();
    _updateReaderWords();
  }

  @override
  void dispose() {
    _snippetController.dispose();
    _item1NameController.dispose();
    _item1PriceController.dispose();
    _item1QtyController.dispose();
    _item2NameController.dispose();
    _item2PriceController.dispose();
    _item2QtyController.dispose();
    _newDecisionController.dispose();
    _speedTextController.dispose();
    _readerTimer?.cancel();
    super.dispose();
  }

  void _updateReaderWords() {
    setState(() {
      _readerWords = _speedTextController.text
          .trim()
          .split(RegExp(r'\s+'))
          .where((w) => w.isNotEmpty)
          .toList();
      _currentWordIndex = 0;
    });
  }

  void _toggleSpeedReader() {
    if (_readerWords.isEmpty) return;
    if (_isReaderPlaying) {
      _readerTimer?.cancel();
      setState(() => _isReaderPlaying = false);
    } else {
      setState(() => _isReaderPlaying = true);
      final intervalMs = (60000 / _wpm).round();
      _readerTimer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
        if (_currentWordIndex < _readerWords.length - 1) {
          setState(() {
            _currentWordIndex++;
          });
        } else {
          timer.cancel();
          setState(() {
            _isReaderPlaying = false;
            _currentWordIndex = 0;
          });
        }
      });
    }
  }

  void _calculateBestDeal() {
    final p1 = double.tryParse(_item1PriceController.text) ?? 0.0;
    final q1 = double.tryParse(_item1QtyController.text) ?? 0.0;
    final p2 = double.tryParse(_item2PriceController.text) ?? 0.0;
    final q2 = double.tryParse(_item2QtyController.text) ?? 0.0;

    if (p1 <= 0 || q1 <= 0 || p2 <= 0 || q2 <= 0) {
      setState(() {
        _comparatorResult = 'Please enter valid positive numbers for price and quantity/weight.';
        _bestOption = '';
      });
      return;
    }

    final unitPrice1 = p1 / q1;
    final unitPrice2 = p2 / q2;

    if (unitPrice1 < unitPrice2) {
      final savingsPercent = ((unitPrice2 - unitPrice1) / unitPrice2 * 100).toStringAsFixed(1);
      setState(() {
        _bestOption = _item1NameController.text;
        _comparatorResult = '${_item1NameController.text} is $savingsPercent% CHEAPER per unit!\n'
            'Unit Rate: \$${unitPrice1.toStringAsFixed(4)} / unit vs \$${unitPrice2.toStringAsFixed(4)} / unit.';
        _simulatedNotification = 'Smart Deal: Save $savingsPercent% with ${_item1NameController.text}';
      });
    } else if (unitPrice2 < unitPrice1) {
      final savingsPercent = ((unitPrice1 - unitPrice2) / unitPrice1 * 100).toStringAsFixed(1);
      setState(() {
        _bestOption = _item2NameController.text;
        _comparatorResult = '${_item2NameController.text} is $savingsPercent% CHEAPER per unit!\n'
            'Unit Rate: \$${unitPrice2.toStringAsFixed(4)} / unit vs \$${unitPrice1.toStringAsFixed(4)} / unit.';
        _simulatedNotification = 'Smart Deal: Save $savingsPercent% with ${_item2NameController.text}';
      });
    } else {
      setState(() {
        _bestOption = 'Both Equal';
        _comparatorResult = 'Both options offer the EXACT same value per unit (\$${unitPrice1.toStringAsFixed(4)} / unit).';
      });
    }
  }

  void _spinDecisionWheel() {
    if (_decisions.isEmpty || _isSpinning) return;
    setState(() {
      _isSpinning = true;
      _selectedDecision = 'Spinning the decision wheel...';
    });

    int counter = 0;
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      counter++;
      setState(() {
        _selectedDecision = _decisions[counter % _decisions.length];
      });
      if (counter >= 18) {
        timer.cancel();
        final finalIndex = DateTime.now().millisecondsSinceEpoch % _decisions.length;
        setState(() {
          _selectedDecision = _decisions[finalIndex];
          _isSpinning = false;
          _simulatedNotification = 'Decision Made: ${_decisions[finalIndex]}';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 2,
        title: Row(
          children: [
            const Icon(Icons.widgets, color: Colors.indigoAccent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'OmniDock Assistant',
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isOverlayActive ? Icons.layers : Icons.layers_clear,
              color: _isOverlayActive ? Colors.greenAccent : Colors.grey,
            ),
            tooltip: 'Toggle Simulated Floating Dock',
            onPressed: () {
              setState(() {
                _isOverlayActive = !_isOverlayActive;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Live Notification Banner Ticker
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: Colors.indigo.withOpacity(0.2),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active, color: Colors.amber, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _simulatedNotification,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Navigation Body
                Expanded(
                  child: IndexedStack(
                    index: _selectedTabIndex,
                    children: [
                      _buildFloatingDockHomeTab(),
                      _buildPriceComparatorTab(),
                      _buildClipboardStackTab(),
                      _buildDecisionMakerTab(),
                      _buildSpeedReaderTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating Draggable Overlay Bubble Simulation
          if (_isOverlayActive)
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubblePosition = Offset(
                      (_bubblePosition.dx + details.delta.dx).clamp(0.0, MediaQuery.of(context).size.width - 70),
                      (_bubblePosition.dy + details.delta.dy).clamp(60.0, MediaQuery.of(context).size.height - 150),
                    );
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_isBubbleExpanded)
                      Container(
                        width: 220,
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B).withOpacity(0.95),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.indigoAccent, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Quick Dock Tools',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.indigoAccent,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => setState(() => _isBubbleExpanded = false),
                                  child: const Icon(Icons.close, size: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                            const Divider(color: Colors.white70, height: 12),
                            _buildQuickActionTile(Icons.compare_arrows, 'Deal Comparator', () {
                              setState(() {
                                _selectedTabIndex = 1;
                                _isBubbleExpanded = false;
                              });
                            }),
                            _buildQuickActionTile(Icons.content_paste, 'Floating Clips', () {
                              setState(() {
                                _selectedTabIndex = 2;
                                _isBubbleExpanded = false;
                              });
                            }),
                            _buildQuickActionTile(Icons.casino, 'Decision Maker', () {
                              setState(() {
                                _selectedTabIndex = 3;
                                _isBubbleExpanded = false;
                              });
                            }),
                            _buildQuickActionTile(Icons.speed, 'Speed Reader', () {
                              setState(() {
                                _selectedTabIndex = 4;
                                _isBubbleExpanded = false;
                              });
                            }),
                          ],
                        ),
                      ),
                    FloatingActionButton.small(
                      heroTag: 'floating_dock_bubble',
                      backgroundColor: Colors.indigoAccent,
                      onPressed: () {
                        setState(() {
                          _isBubbleExpanded = !_isBubbleExpanded;
                        });
                      },
                      child: Icon(
                        _isBubbleExpanded ? Icons.tune : Icons.bolt,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.indigoAccent,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Compare'),
          BottomNavigationBarItem(icon: Icon(Icons.content_copy), label: 'Clipboard'),
          BottomNavigationBarItem(icon: Icon(Icons.casino), label: 'Decide'),
          BottomNavigationBarItem(icon: Icon(Icons.speed), label: 'Reader'),
        ],
      ),
    );
  }

  Widget _buildQuickActionTile(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.white70),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: DASHBOARD HOME ---
  Widget _buildFloatingDockHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.indigo, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.bolt, color: Colors.amber, size: 28),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Floating Assistant Active',
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Drag the floating bolt icon anywhere on your screen. Tap it anytime to access instant calculators, clipboards, and micro-tools.',
                  softWrap: true,
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAxisAlignment.center,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.check_circle, color: Colors.greenAccent, size: 16),
                      label: const Text('Overlay Dock Enabled', style: TextStyle(fontSize: 11)),
                      backgroundColor: Colors.black87,
                    ),
                    Chip(
                      avatar: const Icon(Icons.speed, color: Colors.cyanAccent, size: 16),
                      label: const Text('Fast Context Switching', style: TextStyle(fontSize: 11)),
                      backgroundColor: Colors.black87,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Daily Micro-Utility Suite',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            title: 'Unit Price & Grocery Deal Comparator',
            description: 'Compare item weights/prices instantly before buying to make sure you get the absolute best deal.',
            icon: Icons.shopping_bag,
            color: Colors.teal,
            onTap: () => setState(() => _selectedTabIndex = 1),
          ),
          const SizedBox(height: 10),
          _buildFeatureCard(
            title: 'Floating Clipboard Stack',
            description: 'Keep your addresses, tracking codes, and quick responses stored and ready to copy.',
            icon: Icons.layers,
            color: Colors.orange,
            onTap: () => setState(() => _selectedTabIndex = 2),
          ),
          const SizedBox(height: 10),
          _buildFeatureCard(
            title: 'Instant Micro-Decision Wheel',
            description: 'Eliminate daily decision fatigue when choosing what to eat, what task to start, or where to go.',
            icon: Icons.casino,
            color: Colors.purpleAccent,
            onTap: () => setState(() => _selectedTabIndex = 3),
          ),
          const SizedBox(height: 10),
          _buildFeatureCard(
            title: 'Floating Speed Reader',
            description: 'Read long articles word-by-word at 200-500 WPM using rapid visual presentation.',
            icon: Icons.speed,
            color: Colors.blueAccent,
            onTap: () => setState(() => _selectedTabIndex = 4),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            description,
            softWrap: true,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  // --- TAB 2: SMART PRICE COMPARATOR ---
  Widget _buildPriceComparatorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Unit Price & Deal Comparator',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Calculate true unit cost (per gram, ml, or unit) to see which package saves you real money.',
            softWrap: true,
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildItemInputCard(
                  title: 'Option A',
                  nameController: _item1NameController,
                  priceController: _item1PriceController,
                  qtyController: _item1QtyController,
                  accentColor: Colors.blueAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildItemInputCard(
                  title: 'Option B',
                  nameController: _item2NameController,
                  priceController: _item2PriceController,