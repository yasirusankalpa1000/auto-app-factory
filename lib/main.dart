import 'package:flutter/material.dart';

void main() {
  runApp(const OverlayDockApp());
}

class OverlayDockApp extends StatelessWidget {
  const OverlayDockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlayDock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121218),
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
  int _currentIndex = 0;

  // Floating Bubble Overlay State
  Offset _bubblePosition = const Offset(20, 200);
  bool _isOverlayExpanded = false;
  bool _overlayPermissionEnabled = true;

  // Notification Heads-up Banner State
  bool _showBannerNotification = false;
  String _bannerText = 'OverlayDock running in smart multi-task mode';

  // Data Collections
  final List<String> _stashItems = [
    'PROMO CODE: SAVE20NOW',
    'Bank Ref: 8940-2210-9931',
    'Delivery Address: 742 Evergreen Terrace',
  ];

  final List<Map<String, String>> _stickyNotes = [
    {'title': 'Grocery List', 'content': 'Milk, Organic Eggs, Bread, Avocados'},
    {'title': 'Meeting Code', 'content': 'Zoom PIN: 902 441 112'},
  ];

  // Unit Price Comparer Inputs
  final TextEditingController _item1Price = TextEditingController(text: '4.50');
  final TextEditingController _item1Qty = TextEditingController(text: '500');
  final TextEditingController _item2Price = TextEditingController(text: '6.20');
  final TextEditingController _item2Qty = TextEditingController(text: '750');
  String _comparisonResult = 'Tap calculate to compare unit prices!';

  @override
  void dispose() {
    _item1Price.dispose();
    _item1Qty.dispose();
    _item2Price.dispose();
    _item2Qty.dispose();
    super.dispose();
  }

  void _triggerHeadsUpNotification(String msg) {
    setState(() {
      _bannerText = msg;
      _showBannerNotification = true;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showBannerNotification = false;
        });
      }
    });
  }

  void _calculateUnitPrice() {
    final double? p1 = double.tryParse(_item1Price.text);
    final double? q1 = double.tryParse(_item1Qty.text);
    final double? p2 = double.tryParse(_item2Price.text);
    final double? q2 = double.tryParse(_item2Qty.text);

    if (p1 == null || q1 == null || p2 == null || q2 == null || q1 == 0 || q2 == 0) {
      setState(() {
        _comparisonResult = 'Please enter valid positive numbers for both items.';
      });
      return;
    }

    final double unit1 = p1 / q1;
    final double unit2 = p2 / q2;

    setState(() {
      if ((unit1 - unit2).abs() < 0.00001) {
        _comparisonResult = 'Both items have equal unit cost! (\$${unit1.toStringAsFixed(4)} / unit)';
      } else if (unit1 < unit2) {
        final double diffPercent = ((unit2 - unit1) / unit2) * 100;
        _comparisonResult = 'Option A is better value! Save ${diffPercent.toStringAsFixed(1)}%\n(A: \$${unit1.toStringAsFixed(4)} vs B: \$${unit2.toStringAsFixed(4)})';
      } else {
        final double diffPercent = ((unit1 - unit2) / unit1) * 100;
        _comparisonResult = 'Option B is better value! Save ${diffPercent.toStringAsFixed(1)}%\n(B: \$${unit2.toStringAsFixed(4)} vs A: \$${unit1.toStringAsFixed(4)})';
      }
    });
    _triggerHeadsUpNotification('Unit price calculation completed');
  }

  void _addStashItem(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _stashItems.insert(0, text.trim());
    });
    _triggerHeadsUpNotification('Saved snippet to Floating Stash!');
  }

  void _addStickyNote(String title, String content) {
    if (title.trim().isEmpty) return;
    setState(() {
      _stickyNotes.insert(0, {'title': title.trim(), 'content': content.trim()});
    });
    _triggerHeadsUpNotification('New floating sticky note pinned!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Screen Content Tabs
            Positioned.fill(
              child: Column(
                children: [
                  // Top Status Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: const Color(0xFF1E1E28),
                    child: Row(
                      children: [
                        const Icon(Icons.layers, color: Colors.deepPurpleAccent),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'OverlayDock Assistant',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _overlayPermissionEnabled ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _overlayPermissionEnabled ? Colors.green : Colors.red,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _overlayPermissionEnabled ? Icons.check_circle : Icons.warning,
                                size: 14,
                                color: _overlayPermissionEnabled ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _overlayPermissionEnabled ? 'Active Overlay' : 'Permission Off',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _overlayPermissionEnabled ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Active Body Content
                  Expanded(
                    child: IndexedStack(
                      index: _currentIndex,
                      children: [
                        _buildFloatingCanvasTab(),
                        _buildStashTab(),
                        _buildPriceCompareTab(),
                        _buildSettingsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Animated Simulated Heads-up Notification Banner
            if (_showBannerNotification)
              Positioned(
                top: 10,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.indigo,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_active, color: Colors.amber),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _bannerText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showBannerNotification = false;
                            });
                          },
                          child: const Icon(Icons.close, color: Colors.white70, size: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Interactive Draggable Floating Bubble
            if (_overlayPermissionEnabled)
              Positioned(
                left: _bubblePosition.dx,
                top: _bubblePosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _bubblePosition += details.delta;
                    });
                  },
                  onTap: () {
                    setState(() {
                      _isOverlayExpanded = !_isOverlayExpanded;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.deepPurple, Colors.blueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.5),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.widgets,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),

            // Expanded Floating Dock Dynamic Quick Menu
            if (_overlayPermissionEnabled && _isOverlayExpanded)
              Positioned(
                left: (_bubblePosition.dx + 60 > MediaQuery.of(context).size.width - 220)
                    ? MediaQuery.of(context).size.width - 220
                    : _bubblePosition.dx + 60,
                top: _bubblePosition.dy,
                child: Material(
                  elevation: 12,
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFF252536),
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.5)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Floating Tools',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isOverlayExpanded = false;
                                });
                              },
                              child: const Icon(Icons.close, color: Colors.white70, size: 16),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white70, height: 16),
                        _buildQuickActionButton(
                          icon: Icons.note_add,
                          label: 'Quick Sticky',
                          onTap: () {
                            _showQuickStickyDialog();
                            setState(() {
                              _isOverlayExpanded = false;
                            });
                          },
                        ),
                        _buildQuickActionButton(
                          icon: Icons.calculate,
                          label: 'Price Check',
                          onTap: () {
                            setState(() {
                              _currentIndex = 2;
                              _isOverlayExpanded = false;
                            });
                          },
                        ),
                        _buildQuickActionButton(
                          icon: Icons.copy,
                          label: 'Paste Snippet',
                          onTap: () {
                            _addStashItem('Clipboard Stash Item #${_stashItems.length + 1}');
                            setState(() {
                              _isOverlayExpanded = false;
                            });
                          },
                        ),
                        _buildQuickActionButton(
                          icon: Icons.notifications_active,
                          label: 'Test HUD Banner',
                          onTap: () {
                            _triggerHeadsUpNotification('Floating assistant active on screen');
                            setState(() {
                              _isOverlayExpanded = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1E1E28),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Canvas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Stash Pin',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Comparer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: FLOATING CANVAS & STICKY BOARD ---
  Widget _buildFloatingCanvasTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade900, const Color(0xFF2A2A3D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.touch_app, color: Colors.amber, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Interactive Floating Assistant Active',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Drag the glowing purple floating bubble anywhere on screen. Tap it to reveal instant micro-tools while you use other apps.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  softWrap: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Pinned Sticky Notes Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pinned Floating Sticky Notes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showQuickStickyDialog,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('New Pin'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (_stickyNotes.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No sticky notes pinned yet. Tap "New Pin" to create your first visual memo!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _stickyNotes.length,
              itemBuilder: (context, index) {
                final note = _stickyNotes[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF232332),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.push_pin, color: Colors.amber, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note['title'] ?? 'Note',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              note['content'] ?? '',
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey, size: 18),
                        onPressed: () {
                          setState(() {
                            _stickyNotes.removeAt(index);
                          });
                          _triggerHeadsUpNotification('Sticky note unpinned');
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

  // --- TAB 2: CLIPBOARD STASH & QUICK SNIPPETS ---
  Widget _buildStashTab() {
    final TextEditingController snippetController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Text & Code Stash',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Store temporary promo codes, dynamic links, phone numbers, or dynamic instructions without cluttering your main notes app.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          // Add New Snippet Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF232332),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: snippetController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Paste or type text snippet...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.deepPurpleAccent),
                  onPressed: () {
                    _addStashItem(snippetController.text);
                    snippetController.clear();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Stash List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _stashItems.length,
            itemBuilder: (context, index) {
              final item = _stashItems[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white70),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.short_text, color: Colors.blueAccent),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.tealAccent, size: 18),
                      onPressed: () {
                        _triggerHeadsUpNotification('Copied to clipboard: "$item"');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey, size: 18),
                      onPressed: () {
                        setState(() {
                          _stashItems.removeAt(index);
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

  // --- TAB 3: UNIT PRICE & SHOPPING COMPARER ---
  Widget _buildPriceCompareTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Micro Price Comparer',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Instantly calculate which package gives you the best value per gram/ml/unit while shopping in real-time.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
            softWrap: true,
          ),
          const SizedBox(height: 20),

          // Option A Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF232332),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Option A (Standard Pack)',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _item1Price,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: const InputDecoration(
                          labelText: 'Price (\$)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _item1Qty,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: const InputDecoration(
                          labelText: 'Quantity/Weight',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Option B Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF232332),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purpleAccent.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Option B (Bulk / Promo Pack)',
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _item2Price,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: const InputDecoration(
                          labelText: 'Price (\$)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _item2Qty,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: const InputDecoration(
                          labelText: 'Quantity/Weight',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Calculate Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _calculateUnitPrice,
              icon: const Icon(Icons.calculate),
              label: const Text(
                'Compare Deals Now',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Calculation Output Display Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A24),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber, size: 28),
                const SizedBox(height: 8),
                Text(
                  _comparisonResult,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: FLOATING ASSISTANT SETTINGS & PERMISSIONS ---
  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overlay & Assistant Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Toggle Floating Permission
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF232332),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Display Over Other Apps',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Allows the floating bubble dock to remain visible on screen.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _overlayPermissionEnabled,
                  activeColor: Colors.deepPurpleAccent,
                  onChanged: (val) {
                    setState(() {
                      _overlayPermissionEnabled = val;
                    });
                    _triggerHeadsUpNotification(
                      val ? 'Display overlay enabled' : 'Display overlay paused',
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Quick Action Cards
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF232332),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Dock Actions',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAxisAlignment.center,
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.refresh, size: 16, color: Colors.white),
                      label: const Text('Reset Bubble Position'),
                      backgroundColor: Colors.deepPurple,
                      labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                      onPressed: () {
                        setState(() {
                          _bubblePosition = const Offset(20, 200);
                        });
                        _triggerHeadsUpNotification('Floating bubble position reset');
                      },
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.clear_all, size: 16, color: Colors.white),
                      label: const Text('Clear Stash Items'),
                      backgroundColor: Colors.redAccent.shade700,
                      labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                      onPressed: () {
                        setState(() {
                          _stashItems.clear();
                        });
                        _triggerHeadsUpNotification('Stash items cleared');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // App Info Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: Colors.tealAccent),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'OverlayDock is optimized for daily multi-tasking without screen jumping. Keeps users productive and engaged continuous hours daily!',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
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

  // Helper dialog for creating sticky notes
  void _showQuickStickyDialog() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF232332),
          title: const Text('Pin New Sticky Note', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: contentCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Content / Snippet',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                _addStickyNote(titleCtrl.text, contentCtrl.text);
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
              child: const Text('Pin Note', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Helper widget for floating menu items
  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepPurpleAccent, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}