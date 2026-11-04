import 'package:flutter/material.dart';

void main() {
  runApp(const MicroGlanceApp());
}

class MicroGlanceApp extends StatelessWidget {
  const MicroGlanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MicroGlance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class ClipboardItem {
  final String id;
  final String text;
  final String category;
  final DateTime timestamp;

  ClipboardItem({
    required this.id,
    required this.text,
    required this.category,
    required this.timestamp,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;

  // Floating Overlay State Simulation
  bool _isOverlayEnabled = true;
  double _bubbleX = 20.0;
  double _bubbleY = 220.0;
  bool _isMenuExpanded = false;

  // Privacy Filter State
  bool _privacyFilterActive = false;
  double _privacyOpacity = 0.45;
  Color _privacyTint = Colors.black;

  // Clipboard Stack State
  final List<ClipboardItem> _clipboardList = [
    ClipboardItem(
      id: '1',
      text: 'Order Ref: #MG-99214 - Package tracking link',
      category: 'Shopping',
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
    ),
    ClipboardItem(
      id: '2',
      text: 'Meeting Room Passcode: 8849-210',
      category: 'Work',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    ClipboardItem(
      id: '3',
      text: 'Delivery Address: 402 Park Avenue, Suite 12',
      category: 'Personal',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];
  final TextEditingController _clipInputController = TextEditingController();
  String _selectedTag = 'General';
  String _searchQuery = '';

  // Deal Calc State
  double _originalPrice = 49.99;
  double _discountPercent = 20.0;
  double _taxPercent = 8.0;
  int _splitPeople = 2;

  // Decision Spinner State
  final List<String> _decisionOptions = [
    'Order Salad',
    'Cook Pasta',
    'Sushi Treat',
    'Healthy Smoothie',
    'Quick Wrap'
  ];
  final TextEditingController _decisionInputController = TextEditingController();
  String _pickedDecision = 'Tap spin to pick!';
  bool _isSpinning = false;

  @override
  void dispose() {
    _clipInputController.dispose();
    _decisionInputController.dispose();
    super.dispose();
  }

  void _addClipboardSnippet() {
    if (_clipInputController.text.trim().isEmpty) return;
    setState(() {
      _clipboardList.insert(
        0,
        ClipboardItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: _clipInputController.text.trim(),
          category: _selectedTag,
          timestamp: DateTime.now(),
        ),
      );
      _clipInputController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saved snippet to Floating Clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _spinDecisionWheel() async {
    if (_decisionOptions.isEmpty) return;
    setState(() {
      _isSpinning = true;
      _pickedDecision = 'Evaluating decisions...';
    });
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {
      _decisionOptions.shuffle();
      _pickedDecision = _decisionOptions.first;
      _isSpinning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Tab View
            Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: [
                      _buildOverlayCanvasTab(),
                      _buildClipboardTab(),
                      _buildMicroCalcTab(),
                      _buildPrivacyHUDTab(),
                      _buildDecisionTab(),
                    ],
                  ),
                ),
              ],
            ),

            // Simulated Privacy Filter Tint Screen Layer
            if (_privacyFilterActive)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: _privacyTint.withOpacity(_privacyOpacity),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'PRIVACY SHIELD ACTIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Interactive Simulated Floating Widget Bubble
            if (_isOverlayEnabled) _buildDraggableFloatingBubble(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.widgets),
            label: 'Overlay HUD',
          ),
          NavigationDestination(
            icon: Icon(Icons.copy),
            label: 'Clipboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Deal Splitter',
          ),
          NavigationDestination(
            icon: Icon(Icons.security),
            label: 'Privacy',
          ),
          NavigationDestination(
            icon: Icon(Icons.lightbulb),
            label: 'Decider',
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.layers, color: Colors.teal),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MicroGlance HUD',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Ambient Smart Assist & Clipboard Overlay',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Text(
                'HUD',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Switch(
                value: _isOverlayEnabled,
                activeColor: Colors.teal,
                onChanged: (val) {
                  setState(() {
                    _isOverlayEnabled = val;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableFloatingBubble() {
    final Size screenSize = MediaQuery.of(context).size;

    return Positioned(
      left: _bubbleX,
      top: _bubbleY,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubbleX += details.delta.dx;
            _bubbleY += details.delta.dy;

            // Clamp screen boundaries safely
            if (_bubbleX < 0) _bubbleX = 0;
            if (_bubbleY < 50) _bubbleY = 50;
            if (_bubbleX > screenSize.width - 70) {
              _bubbleX = screenSize.width - 70;
            }
            if (_bubbleY > screenSize.height - 150) {
              _bubbleY = screenSize.height - 150;
            }
          });
        },
        onTap: () {
          setState(() {
            _isMenuExpanded = !_isMenuExpanded;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 8,
              shape: const CircleBorder(),
              color: Colors.teal.shade700,
              child: Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                child: Icon(
                  _isMenuExpanded ? Icons.close : Icons.widgets,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
            if (_isMenuExpanded)
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 220,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black87,
                      blurRadius: 10,
                      offset: Offset(0, 4),
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
                          'Quick HUD Tools',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        InkWell(
                          onTap: () => setState(() => _isMenuExpanded = false),
                          child: const Icon(Icons.close, size: 16),
                        )
                      ],
                    ),
                    const Divider(height: 12),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _privacyFilterActive = !_privacyFilterActive;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            Icon(
                              _privacyFilterActive
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 18,
                              color: Colors.teal,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _privacyFilterActive
                                    ? 'Disable Privacy Filter'
                                    : 'Enable Privacy Filter',
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _showQuickPasteModal();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            Icon(Icons.copy, size: 18, color: Colors.blue),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Paste Latest Snippet',
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _spinDecisionWheel();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            Icon(Icons.refresh, size: 18, color: Colors.purple),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Quick Micro Decision',
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showQuickPasteModal() {
    if (_clipboardList.isEmpty) return;
    final topItem = _clipboardList.first;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.teal),
                  const SizedBox(width: 8),
                  Text(
                    'Active Clip (${topItem.category})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  topItem.text,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  softWrap: true,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied snippet to clipboard buffer!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('Copy to System Buffer'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- TAB 1: OVERLAY CANVAS TAB ---
  Widget _buildOverlayCanvasTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBannerCard(),
          const SizedBox(height: 16),
          const Text(
            'Floating Utility Controls',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: Colors.teal,
                    title: const Text(
                      'Enable Floating Screen Widget',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text(
                      'Draggable shortcut bubble available across app screens.',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: _isOverlayEnabled,
                    onChanged: (val) {
                      setState(() {
                        _isOverlayEnabled = val;
                      });
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE0F2F1),
                      child: Icon(Icons.drag_indicator, color: Colors.teal),
                    ),
                    title: const Text('Bubble Location Reset'),
                    subtitle: const Text('Re-center the floating HUD widget.'),
                    trailing: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _bubbleX = 20.0;
                          _bubbleY = 220.0;
                        });
                      },
                      child: const Text('Reset Pos'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Live Dynamic Context Quick View',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          _buildQuickMetricsGrid(),
        ],
      ),
    );
  }

  Widget _buildBannerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade700, Colors.teal.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Multi-App Ambient Multitasking',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Keep your micro-tools handy without constantly switching apps. Drag the green floating HUD bubble anywhere on screen.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
            softWrap: true,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMetricsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Saved Snippets',
                value: '${_clipboardList.length} Items',
                icon: Icons.copy,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                title: 'Privacy Filter',
                value: _privacyFilterActive ? 'ACTIVE' : 'OFF',
                icon: Icons.security,
                color: _privacyFilterActive ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Quick Split (2P)',
                value: '\$${(_originalPrice / 2).toStringAsFixed(2)}',
                icon: Icons.calculate,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                title: 'Decider Ready',
                value: '${_decisionOptions.length} Choices',
                icon: Icons.lightbulb,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // --- TAB 2: CLIPBOARD STACK ---
  Widget _buildClipboardTab() {
    final filteredClips = _clipboardList.where((clip) {
      if (_searchQuery.isEmpty) return true;
      return clip.text.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          clip.category.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              TextField(
                controller: _clipInputController,
                decoration: InputDecoration(
                  labelText: 'Add snippet to floating stack',
                  hintText: 'Paste or type text, link, address...',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.teal),
                    onPressed: _addClipboardSnippet,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Tag: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Wrap(
                    spacing: 6,
                    crossAxisAlignment: WrapCrossAxisAlignment.center,
                    children: ['General', 'Work', 'Shopping', 'Personal']
                        .map((tag) {
                      final isSelected = _selectedTag == tag;
                      return ChoiceChip(
                        label: Text(tag),
                        selected: isSelected,
                        selectedColor: Colors.teal.shade100,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedTag = tag);
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, size: 20),
                  hintText: 'Filter clipboard snippets...',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: filteredClips.isEmpty
              ? const Center(
                  child: Text(
                    'No snippets in clipboard tray.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredClips.length,
                  itemBuilder: (context, index) {
                    final item = filteredClips[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 1,
                      child: ListTile(
                        title: Text(
                          item.text,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.category,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.teal.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${item.timestamp.hour}:${item.timestamp.minute.toString().padLeft(2, '0')}',
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.copy,
                                  color: Colors.teal, size: 20),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Copied snippet!'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red, size: 20),
                              onPressed: () {
                                setState(() {
                                  _clipboardList.removeWhere(
                                      (element) => element.id == item.id);
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
    );
  }

  // --- TAB 3: MICRO DEAL & SPLIT CALC ---
  Widget _buildMicroCalcTab() {
    final double discountAmount = _originalPrice * (_discountPercent / 100);
    final double priceAfterDiscount = _originalPrice - discountAmount;
    final double taxAmount = priceAfterDiscount * (_taxPercent / 100);
    final double totalPrice = priceAfterDiscount + taxAmount;
    final double perPersonPrice = totalPrice / _splitPeople;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.teal.shade800,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'FINAL TOTAL COST',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(color: Colors.white70, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Savings',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                          Text(
                            '\$${discountAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Per Person ($_splitPeople P)',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                          Text(
                            '\$${perPersonPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Adjust Deal Parameters',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Original Price: \$${_originalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _originalPrice,
                    min: 1.0,
                    max: 500.0,
                    divisions: 499,
                    activeColor: Colors.teal,
                    label: '\$${_originalPrice.toStringAsFixed(2)}',
                    onChanged: (val) => setState(() => _originalPrice = val),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Discount: ${_discountPercent.toStringAsFixed(0)}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _discountPercent,
                    min: 0.0,
                    max: 90.0,
                    divisions: 90,
                    activeColor: Colors.amber.shade700,
                    label: '${_discountPercent.toStringAsFixed(0)}%',
                    onChanged: (val) => setState(() => _discountPercent = val),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tax Rate: ${_taxPercent.toStringAsFixed(1)}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _taxPercent,
                    min: 0.0,
                    max: 35.0,
                    divisions: 70,
                    activeColor: Colors.blue,
                    label: '${_taxPercent.toStringAsFixed(1)}%',
                    onChanged: (val) => setState(() => _taxPercent = val),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Split Bill Between:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _splitPeople > 1
                                ? () => setState(() => _splitPeople--)
                                : null,
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text(
                            '$_splitPeople',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() => _splitPeople++),
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: PRIVACY SCREEN HUD ---
  Widget _buildPrivacyHUDTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    activeColor: Colors.teal,
                    title: const Text(
                      'Activate Public Screen Privacy Filter',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'Dims and tints screen to hide sensitive information from shoulder peekers.',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: _privacyFilterActive,
                    onChanged: (val) {
                      setState(() {
                        _privacyFilterActive = val;
                      });
                    },
                  ),
                  const Divider(),
                  const Text(
                    'Filter Opacity Level',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Slider(
                    value: _privacyOpacity,
                    min: 0.1,
                    max: 0.85,
                    divisions: 15,
                    activeColor: Colors.teal,
                    onChanged: _privacyFilterActive
                        ? (val) => setState(() => _privacyOpacity = val)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tint Theme Accent',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAxisAlignment.center,
                    children: [
                      _buildColorChip('Dark', Colors.black),
                      _buildColorChip('Night Blue', Colors.indigo),
                      _buildColorChip('Warm Amber', Colors.deepOrange),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: const Row(
              children: [
                Icon(Icons.info, color: Colors.amber),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Privacy Filter stays enabled while exploring other tabs, giving you instant on-demand ambient privacy.',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorChip(String label, Color color) {
    final isSelected = _privacyTint == color;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.teal.shade100,
      onSelected: (selected) {
        if (selected) {
          setState(() => _privacyTint = color);
        }
      },
    );
  }

  // --- TAB 5: MICRO-DECISION HUB ---
  Widget _buildDecisionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.shade100),
            ),
            child: Column(
              children: [
                const Icon(Icons.casino, size: 40, color: Colors.teal),
                const SizedBox(height: 10),
                const Text(
                  'Micro Decision Solver',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Resolve daily micro-decision fatigue instantly.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _pickedDecision,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade900,
                    ),
                    softWrap: true,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _isSpinning ? null : _spinDecisionWheel,
                    icon: _isSpinning
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.refresh),
                    label: Text(_isSpinning ? 'Evaluating...' : 'Spin Choice'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current Decision Options',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_decisionOptions.length} items',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _decisionInputController,
                  decoration: const InputDecoration(
                    hintText: 'Add option (e.g. Read Book)',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: () {
                  if (_decisionInputController.text.trim().isNotEmpty) {
                    setState(() {
                      _decisionOptions.add(_decisionInputController.text.trim());
                      _decisionInputController.clear();
                    });
                  }
                },
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: _decisionOptions.map((opt) {
              return Chip(
                label: Text(opt),
                deleteIcon: const Icon(Icons.close, size: 16),
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
}