import 'package:flutter/material.dart';

void main() {
  runApp(const FloatDeckApp());
}

class FloatDeckApp extends StatelessWidget {
  const FloatDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatDeck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal,
          secondary: Colors.indigo,
          surface: Colors.grey.shade50,
        ),
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      home: const MainDeckScreen(),
    );
  }
}

class ClipItem {
  final String id;
  final String content;
  final String category; // 'Code', 'Link', 'Price', 'Note'
  final DateTime timestamp;

  ClipItem({
    required this.id,
    required this.content,
    required this.category,
    required this.timestamp,
  });
}

class MainDeckScreen extends StatefulWidget {
  const MainDeckScreen({super.key});

  @override
  State<MainDeckScreen> createState() => _MainDeckScreenState();
}

class _MainDeckScreenState extends State<MainDeckScreen> {
  int _currentTabIndex = 0;
  bool _isOverlayEnabled = true;
  bool _showFloatingBubble = true;
  bool _allowFloatingNotifs = true;

  // Floating Bubble Position
  Offset _bubblePosition = const Offset(20, 180);
  bool _isBubbleExpanded = false;

  // Saved Snippets
  final List<ClipItem> _snippets = [
    ClipItem(
      id: '1',
      content: 'SUMMER50OFF - Promo Code',
      category: 'Code',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    ClipItem(
      id: '2',
      content: 'https://example.com/item/48192',
      category: 'Link',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ClipItem(
      id: '3',
      content: 'Total Budget Split: \$45.50 per person',
      category: 'Price',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];

  String _selectedCategoryFilter = 'All';

  // Notification simulation alert
  String? _activeNotificationBanner;

  void _triggerFloatingNotification(String message) {
    if (!_allowFloatingNotifs) return;
    setState(() {
      _activeNotificationBanner = message;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _activeNotificationBanner = null;
        });
      }
    });
  }

  void _addSnippet(String text, String cat) {
    if (text.trim().isEmpty) return;
    setState(() {
      _snippets.insert(
        0,
        ClipItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: text.trim(),
          category: cat,
          timestamp: DateTime.now(),
        ),
      );
    });
    _triggerFloatingNotification('Saved to FloatDeck Clip: "$cat"');
  }

  void _deleteSnippet(String id) {
    setState(() {
      _snippets.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FloatDeck Assistant',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Floating Smart Screen Overlay Hub',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isOverlayEnabled ? Icons.layers : Icons.layers_clear,
              color: Colors.white,
            ),
            tooltip: 'Toggle Floating Assistant',
            onPressed: () {
              setState(() {
                _isOverlayEnabled = !_isOverlayEnabled;
              });
              _triggerFloatingNotification(
                _isOverlayEnabled
                    ? 'FloatDeck Active: Ready on screen'
                    : 'FloatDeck Overlay Paused',
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Tab Body
            Column(
              children: [
                // Top Master Control Bar
                Container(
                  color: Colors.teal.shade50,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: _isOverlayEnabled
                            ? Colors.teal
                            : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _isOverlayEnabled
                              ? 'Overlay Running • Floating Hub Ready'
                              : 'Overlay Standby • Tap icon to resume',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _isOverlayEnabled
                                ? Colors.teal.shade900
                                : Colors.grey.shade700,
                          ),
                          overflow: TextOverflow.ellipsis,
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
                ),

                // Main Tab Navigation Content
                Expanded(
                  child: IndexedStack(
                    index: _currentTabIndex,
                    children: [
                      _buildOverlaySimulatorTab(),
                      _buildDropDeckTab(),
                      _buildMicroToolsTab(),
                      _buildSettingsTab(),
                    ],
                  ),
                ),
              ],
            ),

            // Floating Active Notification Banner Banner (Simulated Overlay Notification)
            if (_activeNotificationBanner != null)
              Positioned(
                top: 10,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.indigo.shade900,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.notifications_active,
                          color: Colors.amber,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _activeNotificationBanner!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white70,
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              _activeNotificationBanner = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Simulated Draggable Floating Assistant Bubble
            if (_isOverlayEnabled && _showFloatingBubble)
              Positioned(
                left: _bubblePosition.dx,
                top: _bubblePosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      double newX = _bubblePosition.dx + details.delta.dx;
                      double newY = _bubblePosition.dy + details.delta.dy;
                      // Keep within screen boundaries
                      newX = newX.clamp(0.0, size.width - 60.0);
                      newY = newY.clamp(0.0, size.height - 180.0);
                      _bubblePosition = Offset(newX, newY);
                    });
                  },
                  onTap: () {
                    setState(() {
                      _isBubbleExpanded = !_isBubbleExpanded;
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black87,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          _isBubbleExpanded
                              ? Icons.close
                              : Icons.widgets,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      if (_isBubbleExpanded)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(12),
                          width: 220,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black87,
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.teal.shade200,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.bolt,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Quick Float Dock',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 12),
                              _buildBubbleActionButton(
                                icon: Icons.content_paste,
                                label: 'Quick Clipboard Drop',
                                onTap: () {
                                  _showQuickPasteModal();
                                },
                              ),
                              _buildBubbleActionButton(
                                icon: Icons.calculate,
                                label: 'Discount & Split Helper',
                                onTap: () {
                                  setState(() {
                                    _currentTabIndex = 2;
                                    _isBubbleExpanded = false;
                                  });
                                },
                              ),
                              _buildBubbleActionButton(
                                icon: Icons.casino,
                                label: 'Micro-Decision Wheel',
                                onTap: () {
                                  setState(() {
                                    _currentTabIndex = 2;
                                    _isBubbleExpanded = false;
                                  });
                                },
                              ),
                              _buildBubbleActionButton(
                                icon: Icons.snippet_folder,
                                label: 'Open Clip Vault (${_snippets.length})',
                                onTap: () {
                                  setState(() {
                                    _currentTabIndex = 1;
                                    _isBubbleExpanded = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Overlay Screen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste_go),
            label: 'DropDeck Clips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Micro Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildBubbleActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.teal.shade800),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: Floating Overlay Interactive Workspace Simulator
  Widget _buildOverlaySimulatorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade700, Colors.indigo.shade800],
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
                    Icon(Icons.touch_app, color: Colors.white, size: 28),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Floating Screen Overlay Active',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'The teal floating bubble on your screen is live! Drag it anywhere. Tap it while browsing social apps, shopping, or reading to open quick tools instantly.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        _showQuickPasteModal();
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Drop Snippet Now'),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white70),
                      ),
                      onPressed: () {
                        _triggerFloatingNotification(
                          'Test Floating Alert: System level preview active!',
                        );
                      },
                      icon: const Icon(Icons.notifications_active, size: 18),
                      label: const Text('Test Float Banner'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Active Floating Dock Status',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Clips Stored',
                  value: '${_snippets.length}',
                  icon: Icons.snippet_folder,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: 'Floating Status',
                  value: _isOverlayEnabled ? 'Active' : 'Off',
                  icon: Icons.layers,
                  color: _isOverlayEnabled ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Interactive Micro Snippet Quick Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.flash_on, color: Colors.amber, size: 22),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Instant Micro-Clipboard Stash',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Quickly drop links, tracking IDs, or text while using other apps.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 12),
                _QuickAddBar(
                  onAdd: (text, cat) {
                    _addSnippet(text, cat);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Usage Context Tips
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.indigo.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.indigo.shade800),
                    const SizedBox(width: 8),
                    Text(
                      'Why Keep FloatDeck Ready?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Never lose coupon promo codes during checkout.\n'
                  '• Split restaurant bills with tax and tip without switching to standard calculators.\n'
                  '• Spin the decision wheel when stuck on small micro-decisions.\n'
                  '• Collect research snippets while scrolling feeds.',
                  style: TextStyle(fontSize: 12, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: DropDeck Snippet Collector & Vault
  Widget _buildDropDeckTab() {
    final filtered = _selectedCategoryFilter == 'All'
        ? _snippets
        : _snippets
            .where((item) => item.category == _selectedCategoryFilter)
            .toList();

    return Column(
      children: [
        // Filter Chips Bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Code', 'Link', 'Price', 'Note'].map((cat) {
                final isSel = _selectedCategoryFilter == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSel,
                    selectedColor: Colors.teal,
                    labelStyle: TextStyle(
                      color: isSel ? Colors.white : Colors.black87,
                      fontWeight:
                          isSel ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          _selectedCategoryFilter = cat;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.content_paste_off,
                        size: 60,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No snippets found in "$_selectedCategoryFilter"',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => _showQuickPasteModal(),
                        icon: const Icon(Icons.add),
                        label: const Text('Add First Snippet'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _buildCategoryBadge(item.category),
                                const Spacer(),
                                Text(
                                  _formatTime(item.timestamp),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                InkWell(
                                  onTap: () => _deleteSnippet(item.id),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SelectableText(
                              item.content,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                  ),
                                  onPressed: () {
                                    _triggerFloatingNotification(
                                      'Copied snippet to clipboard!',
                                    );
                                  },
                                  icon: const Icon(Icons.copy, size: 16),
                                  label: const Text(
                                    'Copy',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                  ),
                                  onPressed: () {
                                    _triggerFloatingNotification(
                                      'Snippet shared via FloatDock',
                                    );
                                  },
                                  icon: const Icon(Icons.share, size: 16),
                                  label: const Text(
                                    'Share',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
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

  Widget _buildCategoryBadge(String category) {
    Color bg = Colors.grey.shade200;
    Color fg = Colors.black87;
    IconData icon = Icons.bookmark;

    switch (category) {
      case 'Code':
        bg = Colors.amber.shade100;
        fg = Colors.amber.shade900;
        icon = Icons.confirmation_number;
        break;
      case 'Link':
        bg = Colors.blue.shade100;
        fg = Colors.blue.shade900;
        icon = Icons.link;
        break;
      case 'Price':
        bg = Colors.green.shade100;
        fg = Colors.green.shade900;
        icon = Icons.monetization_on;
        break;
      case 'Note':
        bg = Colors.purple.shade100;
        fg = Colors.purple.shade900;
        icon = Icons.note;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            category,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  // TAB 3: Context Micro Tools (Discount/Split & Decision Wheel)
  Widget _buildMicroToolsTab() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: Colors.teal,
              indicatorColor: Colors.teal,
              tabs: [
                Tab(
                  icon: Icon(Icons.splitscreen, size: 18),
                  text: 'Discount & Split',
                ),
                Tab(
                  icon: Icon(Icons.casino, size: 18),
                  text: 'Decision Wheel',
                ),
                Tab(
                  icon: Icon(Icons.aspect_ratio, size: 18),
                  text: 'Screen & Aspect',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildDiscountSplitTool(),
                _buildDecisionWheelTool(),
                _buildScreenAspectTool(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Micro Tool 1: Discount & Bill Splitter
  Widget _buildDiscountSplitTool() {
    return _DiscountSplitWidget(
      onSaveToClip: (resultText) {
        _addSnippet(resultText, 'Price');
      },
    );
  }

  // Micro Tool 2: Decision Wheel Spinner
  Widget _buildDecisionWheelTool() {
    return _DecisionWheelWidget(
      onDecisionMade: (choice) {
        _triggerFloatingNotification('Decision Wheel picked: "$choice"');
      },
    );
  }

  // Micro Tool 3: Screen & Aspect Ratio Quick Tool
  Widget _buildScreenAspectTool() {
    return _AspectCalcWidget();
  }

  // TAB 4: Floating Settings & Permissions Simulator
  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Widget Settings',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Show Draggable Screen Bubble'),
                  subtitle: const Text(
                    'Maintains live floating button over all app views',
                  ),
                  value: _showFloatingBubble,
                  activeColor: Colors.teal,
                  onChanged: (val) {
                    setState(() {
                      _showFloatingBubble = val;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Floating Notifications Banner'),
                  subtitle: const Text(
                    'Show floating alerts for quick clip operations',
                  ),
                  value: _allowFloatingNotifs,
                  activeColor: Colors.teal,
                  onChanged: (val) {
                    setState(() {
                      _allowFloatingNotifs = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'System Permissions Guide',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'For full overlay capabilities on your physical device, FloatDeck uses standard permissions:',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          _buildPermissionTile(
            title: 'Display Over Other Apps',
            desc: 'Allows floating bubble to remain accessible everywhere.',
            isGranted: true,
            icon: Icons.layers,
          ),
          const SizedBox(height: 8),
          _buildPermissionTile(
            title: 'Notification Access',
            desc: 'Displays micro floating banners for snippet updates.',
            isGranted: true,
            icon: Icons.notifications_active,
          ),
          const SizedBox(height: 20),

          // About App Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FloatDeck Overlay Assistant v1.0',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Designed for instant daily context micro-tasks without switching active apps.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionTile({
    required String title,
    required String desc,
    required bool isGranted,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.teal.shade50,
            child: Icon(icon, color: Colors.teal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Chip(
            label: Text(
              isGranted ? 'Active' : 'Grant',
              style: TextStyle(
                fontSize: 10,
                color: isGranted ? Colors.green.shade900 : Colors.black,
              ),
            ),
            backgroundColor:
                isGranted ? Colors.green.shade100 : Colors.amber.shade100,
          ),
        ],
      ),
    );
  }

  void _showQuickPasteModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick Drop to FloatDeck',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _QuickAddBar(
                onAdd: (text, cat) {
                  _addSnippet(text, cat);
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

// Sub-Widget for Quick Add Snippet Input Bar
class _QuickAddBar extends StatefulWidget {
  final Function(String text, String category) onAdd;

  const _QuickAddBar({required this.onAdd});

  @override
  State<_QuickAddBar> createState() => _QuickAddBarState();
}

class _QuickAddBarState extends State<_QuickAddBar> {
  final TextEditingController _controller = TextEditingController();
  String _selectedCat = 'Note';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          maxLines: 2,
          decoration: const InputDecoration(
            hintText: 'Paste promo code, link, tracking ID, or note...',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text(
              'Tag:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Note', 'Code', 'Link', 'Price'].map((cat) {
                    final isSel = _selectedCat == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        label: Text(cat, style: const TextStyle(fontSize: 11)),
                        selected: isSel,
                        onSelected: (val) {
                          if (val) {
                            setState(() {
                              _selectedCat = cat;
                            });
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  widget.onAdd(_controller.text, _selectedCat);
                  _controller.clear();
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}

// Discount & Split Micro Tool Widget
class _DiscountSplitWidget extends StatefulWidget {
  final Function(String result) onSaveToClip;

  const _DiscountSplitWidget({required this.onSaveToClip});

  @override
  State<_DiscountSplitWidget> createState() => _DiscountSplitWidgetState();
}

class _DiscountSplitWidgetState extends State<_DiscountSplitWidget> {
  final TextEditingController _amountController =
      TextEditingController(text: '100.00');
  double _discountPercent = 15.0;
  double _taxPercent = 8.0;
  int _splitPeople = 2;

  @override
  Widget build(BuildContext context) {
    final double rawAmount = double.tryParse(_amountController.text) ?? 0.0;
    final double discountVal = rawAmount * (_discountPercent / 100);
    final double afterDiscount = rawAmount - discountVal;
    final double taxVal = afterDiscount * (_taxPercent / 100);
    final double finalTotal = afterDiscount + taxVal;
    final double perPerson =
        _splitPeople > 0 ? finalTotal / _splitPeople : finalTotal;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Bill Splitter & Discount Calc',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            onChanged: (v) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Original Bill / Price (\$)',
              prefixIcon: Icon(Icons.monetization_on),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Discount Slider
          Text(
            'Discount: ${_discountPercent.toInt()}%',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Slider(
            value: _discountPercent,
            min: 0,
            max: 90,
            divisions: 18,
            activeColor: Colors.teal,
            label: '${_discountPercent.toInt()}%',
            onChanged: (val) {
              setState(() {
                _discountPercent = val;
              });
            },
          ),

          // Tax Slider
          Text(
            'Tax / Tip: ${_taxPercent.toInt()}%',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Slider(
            value: _taxPercent,
            min: 0,
            max: 30,
            divisions: 30,
            activeColor: Colors.indigo,
            label: '${_taxPercent.toInt()}%',
            onChanged: (val) {
              setState(() {
                _taxPercent = val;
              });
            },
          ),

          // Split Counter
          Row(
            children: [
              const Text(
                'Split between:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: _splitPeople > 1
                    ? () => setState(() => _splitPeople--)
                    : null,
              ),
              Text(
                '$_splitPeople people',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => setState(() => _splitPeople++),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Result Display Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.shade200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Discount Saved:'),
                    Text(
                      '-\$${discountVal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Bill (with Tax):'),
                    Text(
                      '\$${finalTotal.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Each Person Pays:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${perPerson.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      final summary =
                          'Split Total: \$${finalTotal.toStringAsFixed(2)} | \$${perPerson.toStringAsFixed(2)} each ($_splitPeople people)';
                      widget.onSaveToClip(summary);
                    },
                    icon: const Icon(Icons.bookmark_add, size: 18),
                    label: const Text('Save Calculation to Clips'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Decision Wheel Spinner Widget
class _DecisionWheelWidget extends StatefulWidget {
  final Function(String choice) onDecisionMade;

  const _DecisionWheelWidget({required this.onDecisionMade});

  @override
  State<_DecisionWheelWidget> createState() => _DecisionWheelWidgetState();
}

class _DecisionWheelWidgetState extends State<_DecisionWheelWidget> {
  final TextEditingController _optionController = TextEditingController(
    text: 'Pizza, Burger, Sushi, Tacos, Salad',
  );
  String? _selectedResult;
  bool _isSpinning = false;

  void _spinWheel() {
    final rawText = _optionController.text;
    final options = rawText
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (options.isEmpty) return;

    setState(() {
      _isSpinning = true;
      _selectedResult = null;
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        options.shuffle();
        final picked = options.first;
        setState(() {
          _selectedResult = picked;
          _isSpinning = false;
        });
        widget.onDecisionMade(picked);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Decision Picker',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Can\'t decide what to eat, what to buy, or which micro-task to start? Enter options separated by commas.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _optionController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Options (Comma separated)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _isSpinning ? null : _spinWheel,
              icon: _isSpinning
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.casino),
              label: Text(_isSpinning ? 'Picking Choice...' : 'Spin Decision Wheel'),
            ),
          ),
          const SizedBox(height: 24),

          if (_selectedResult != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade400, width: 2),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.stars,
                    color: Colors.amber,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'DECISION PICKED!',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedResult!,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// Aspect Ratio Quick Tool
class _AspectCalcWidget extends StatefulWidget {
  @override
  State<_AspectCalcWidget> createState() => _AspectCalcWidgetState();
}

class _AspectCalcWidgetState extends State<_AspectCalcWidget> {
  final TextEditingController _wController = TextEditingController(text: '1920');
  final TextEditingController _hController = TextEditingController(text: '1080');

  @override
  Widget build(BuildContext context) {
    final double w = double.tryParse(_wController.text) ?? 1;
    final double h = double.tryParse(_hController.text) ?? 1;

    double gcd(double a, double b) {
      return b < 0.001 ? a : gcd(b, a % b);
    }

    final double divisor = gcd(w, h);
    final String ratio =
        '${(w / (divisor > 0 ? divisor : 1)).round()} : ${(h / (divisor > 0 ? divisor : 1)).round()}';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Screen & Aspect Ratio Calculator',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Useful for quick graphic design, mobile video editing, or web layout sizing.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _wController,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Width (px)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _hController,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Height (px)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.indigo.shade200),
            ),
            child: Column(
              children: [
                const Text(
                  'Calculated Aspect Ratio',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  ratio,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}