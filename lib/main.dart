import 'package:flutter/material.dart';

void main() {
  runApp(const OverlayHubApp());
}

class OverlayHubApp extends StatelessWidget {
  const OverlayHubApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlayHub',
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
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;
  bool _isOverlayEnabled = true;
  bool _isFloatingBubbleVisible = true;
  double _overlayOpacity = 0.9;
  String _activeWidgetTheme = 'Deep Purple';

  // Clipboard Stack Data
  final List<Map<String, dynamic>> _clipboardItems = [
    {
      'id': '1',
      'text': 'Track parcel ID: package-9842-colombo',
      'category': 'Codes',
      'isPinned': true,
      'time': '10 mins ago'
    },
    {
      'id': '2',
      'text': 'Delivery Address: No. 42, Main Street, Nugegoda',
      'category': 'Address',
      'isPinned': true,
      'time': '30 mins ago'
    },
    {
      'id': '3',
      'text': 'Promo Code: SAVE20NOW',
      'category': 'Deals',
      'isPinned': false,
      'time': '1 hour ago'
    },
    {
      'id': '4',
      'text': 'Meeting link: https://meet.example.com/xyz-123',
      'category': 'Links',
      'isPinned': false,
      'time': '2 hours ago'
    },
  ];

  // Quick Floating Notes
  final List<Map<String, String>> _quickNotes = [
    {'title': 'Grocery List', 'content': 'Milk, Eggs, Whole Wheat Bread, Tea'},
    {'title': 'WiFi Password', 'content': 'Home_Guest_2025!'},
    {'title': 'Idea Scratchpad', 'content': 'Build floating overlay companion!'},
  ];

  void _addClipboardItem(String text, String category) {
    if (text.trim().isEmpty) return;
    setState(() {
      _clipboardItems.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'text': text.trim(),
        'category': category,
        'isPinned': false,
        'time': 'Just now',
      });
    });
  }

  void _addQuickNote(String title, String content) {
    if (title.trim().isEmpty || content.trim().isEmpty) return;
    setState(() {
      _quickNotes.insert(0, {
        'title': title.trim(),
        'content': content.trim(),
      });
    });
  }

  void _togglePinClipboard(String id) {
    setState(() {
      for (var item in _clipboardItems) {
        if (item['id'] == id) {
          item['isPinned'] = !(item['isPinned'] as bool);
          break;
        }
      }
    });
  }

  void _deleteClipboard(String id) {
    setState(() {
      _clipboardItems.removeWhere((item) => item['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildDashboardTab(),
      _buildClipboardStackTab(),
      _buildDecisionMatrixTab(),
      _buildOverlayStudioTab(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: IndexedStack(
              index: _selectedIndex,
              children: pages,
            ),
          ),
          // Interactive Simulated Floating Bubble Overlay Widget
          if (_isFloatingBubbleVisible)
            Positioned(
              right: 16,
              bottom: 110,
              child: GestureDetector(
                onTap: () {
                  _showQuickFloatingPanel(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(_overlayOpacity),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                    border: Border.all(color: Colors.white70, width: 2),
                  ),
                  child: const Icon(
                    Icons.layers,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white70, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: const Color(0xFF1A1A24),
          selectedItemColor: Colors.deepPurpleAccent,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Hub',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.copy),
              label: 'Clipboard Stack',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate),
              label: 'Decision Rate',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tune),
              label: 'Overlay Studio',
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: DASHBOARD HUB ---
  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Status Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'OverlayHub Studio',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Multitasking & Floating Micro-Tools',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _isOverlayEnabled
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isOverlayEnabled ? Colors.green : Colors.red,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isOverlayEnabled ? Icons.check_circle : Icons.error,
                      size: 14,
                      color: _isOverlayEnabled ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isOverlayEnabled ? 'Overlay Active' : 'Overlay Paused',
                      style: TextStyle(
                        fontSize: 11,
                        color: _isOverlayEnabled ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Quick Action Cards Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4A148C), Color(0xFF311B92)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.bolt, color: Colors.amber, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'System Floating Dock Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Access clipboard items, quick notes, and decision calculators instantly over any app using the floating widget head.',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        _showQuickFloatingPanel(context);
                      },
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text('Launch Test Panel'),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isFloatingBubbleVisible = !_isFloatingBubbleVisible;
                        });
                      },
                      icon: Icon(
                        _isFloatingBubbleVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 16,
                      ),
                      label: Text(
                        _isFloatingBubbleVisible
                            ? 'Hide Floating Bubble'
                            : 'Show Floating Bubble',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            'Quick Scratchpad Notes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // Notes List Horizontal Cards
          SizedBox(
            height: 125,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _quickNotes.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    width: 110,
                    margin: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      onTap: () => _showAddNoteDialog(context),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A24),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: Colors.deepPurpleAccent, width: 1.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_circle_outline,
                                color: Colors.deepPurpleAccent, size: 30),
                            SizedBox(height: 6),
                            Text(
                              'New Note',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                final note = _quickNotes[index - 1];
                return Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A24),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white70),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.sticky_note_2,
                              color: Colors.amber, size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              note['title'] ?? '',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          note['content'] ?? '',
                          style: const TextStyle(
                              fontSize: 11, color: Colors.white70),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Clipboard Stack',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _selectedIndex = 1),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Recent Stack Items Preview
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
                _clipboardItems.length > 3 ? 3 : _clipboardItems.length,
            itemBuilder: (context, index) {
              final item = _clipboardItems[index];
              return _buildClipboardTile(item);
            },
          ),
        ],
      ),
    );
  }

  // --- TAB 2: CLIPBOARD STACK MANAGER ---
  Widget _buildClipboardStackTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFF1A1A24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Clipboard Memory Stack',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _showAddSnippetDialog(context),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add Snippet'),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Instant snippet memory stack for quick copying & floating access.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        Expanded(
          child: _clipboardItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.copy_all, size: 48, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        'Clipboard stack is empty',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _clipboardItems.length,
                  itemBuilder: (context, index) {
                    final item = _clipboardItems[index];
                    return _buildClipboardTile(item);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildClipboardTile(Map<String, dynamic> item) {
    final bool isPinned = item['isPinned'] as bool;
    final String category = item['category'] ?? 'General';

    Color categoryColor = Colors.blue;
    if (category == 'Codes') categoryColor = Colors.purple;
    if (category == 'Address') categoryColor = Colors.orange;
    if (category == 'Deals') categoryColor = Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPinned ? Colors.amber.withOpacity(0.5) : Colors.white70,
          width: isPinned ? 1.5 : 1,
        ),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        title: Text(
          item['text'] ?? '',
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 10,
                    color: categoryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                item['time'] ?? '',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: isPinned ? Colors.amber : Colors.grey,
                size: 18,
              ),
              onPressed: () => _togglePinClipboard(item['id']),
            ),
            IconButton(
              icon: const Icon(Icons.copy, color: Colors.tealAccent, size: 18),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Copied: "${item['text']}"'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: Colors.redAccent, size: 18),
              onPressed: () => _deleteClipboard(item['id']),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 3: SMART DECISION MATRIX & UNIT CALCULATOR ---
  Widget _buildDecisionMatrixTab() {
    return const DecisionMatrixView();
  }

  // --- TAB 4: OVERLAY STUDIO & SETTINGS ---
  Widget _buildOverlayStudioTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overlay Studio & Permissions',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Configure your system floating head and quick multitasking controls.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Master Switch Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A24),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Display Above Other Apps',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Simulate system float permission for screen overlay access.',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  value: _isOverlayEnabled,
                  activeColor: Colors.deepPurpleAccent,
                  onChanged: (val) {
                    setState(() {
                      _isOverlayEnabled = val;
                      _isFloatingBubbleVisible = val;
                    });
                  },
                ),
                const Divider(color: Colors.white70),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Show Quick Floating Head Bubble',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Keep floating shortcut bubble visible on screen edge.',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  value: _isFloatingBubbleVisible,
                  activeColor: Colors.deepPurpleAccent,
                  onChanged: (val) {
                    setState(() {
                      _isFloatingBubbleVisible = val;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'Bubble Customization',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A24),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Overlay Opacity',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    Text(
                      '${(_overlayOpacity * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _overlayOpacity,
                  min: 0.3,
                  max: 1.0,
                  activeColor: Colors.deepPurpleAccent,
                  inactiveColor: Colors.grey.shade800,
                  onChanged: (val) {
                    setState(() {
                      _overlayOpacity = val;
                    });
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  'Theme Palette',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: [
                    _buildThemeChip('Deep Purple', Colors.deepPurple),
                    _buildThemeChip('Ocean Blue', Colors.blue),
                    _buildThemeChip('Emerald Green', Colors.green),
                    _buildThemeChip('Amber Dark', Colors.amber),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          // Live Usage Metrics
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A24),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.stars, color: Colors.amber, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Daily Efficiency Stats',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('14', 'App Switches Saved'),
                    _buildStatColumn('8', 'Clipboard Snaps'),
                    _buildStatColumn('5 min', 'Active Overlay'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeChip(String label, Color color) {
    final bool isSelected = _activeWidgetTheme == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: color,
      backgroundColor: const Color(0xFF2A2A38),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey,
        fontSize: 11,
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _activeWidgetTheme = label;
          });
        }
      },
    );
  }

  Widget _buildStatColumn(String count, String title) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurpleAccent,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  // --- FLOATING OVERLAY MODAL SHEET SIMULATION ---
  void _showQuickFloatingPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A26),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            border: Border(top: BorderSide(color: Colors.deepPurpleAccent, width: 2)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.layers, color: Colors.deepPurpleAccent, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Floating Multitasking Overlay',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white70),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick Clipboard Access',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._clipboardItems.take(2).map((item) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF242434),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item['text'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Pasted: ${item['text']}')),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Copy',
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 16),
                      const Text(
                        'Floating Micro-Note Scratchpad',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.tealAccent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF242434),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Shopping List: Apples, Milk, Bread, Coffee beans',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Add Snippet Dialog
  void _showAddSnippetDialog(BuildContext context) {
    final controller = TextEditingController();
    String category = 'General';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A24),
          title: const Text('Add Snippet to Stack',
              style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter text or snippet...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent),
              onPressed: () {
                _addClipboardItem(controller.text, category);
                Navigator.pop(context);
              },
              child: const Text('Save Snippet', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Add Note Dialog
  void _showAddNoteDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A24),
          title: const Text('New Scratchpad Note',
              style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Note Title',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Content...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent),
              onPressed: () {
                _addQuickNote(titleController.text, contentController.text);
                Navigator.pop(context);
              },
              child: const Text('Add Note', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

// --- TAB 3 DETAILED VIEW: SMART DECISION & PRICE COMPARISON MATRIX ---
class DecisionMatrixView extends StatefulWidget {
  const DecisionMatrixView({Key? key}) : super(key: key);

  @override
  State<DecisionMatrixView> createState() => _DecisionMatrixViewState();
}

class _DecisionMatrixViewState extends State<DecisionMatrixView> {
  final TextEditingController _priceA = TextEditingController(text: '12.99');
  final TextEditingController _qtyA = TextEditingController(text: '500');

  final TextEditingController _priceB = TextEditingController(text: '19.99');
  final TextEditingController _qtyB = TextEditingController(text: '900');

  double _unitRateA = 0.0;
  double _unitRateB = 0.0;
  String _winner = '';

  @override
  void initState() {
    super.initState();
    _calculateComparison();
  }

  void _calculateComparison() {
    final double pA = double.tryParse(_priceA.text) ?? 0.0;
    final double qA = double.tryParse(_qtyA.text) ?? 1.0;

    final double pB = double.tryParse(_priceB.text) ?? 0.0;
    final double qB = double.tryParse(_qtyB.text) ?? 1.0;

    setState(() {
      _unitRateA = qA > 0 ? (pA / qA) * 100 : 0.0; // Cost per 100 units
      _unitRateB = qB > 0 ? (pB / qB) * 100 : 0.0;

      if (_unitRateA > 0 && _unitRateB > 0) {
        if (_unitRateA < _unitRateB) {
          final double diff = ((_unitRateB - _unitRateA) / _unitRateB) * 100;
          _winner = 'Option A is ${diff.toStringAsFixed(1)}% cheaper per unit!';
        } else if (_unitRateB < _unitRateA) {
          final double diff = ((_unitRateA - _unitRateB) / _unitRateA) * 100;
          _winner = 'Option B is ${diff.toStringAsFixed(1)}% cheaper per unit!';
        } else {
          _winner = 'Both options offer equal value!';
        }
      } else {
        _winner = 'Enter valid prices and quantities.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Deal & Unit Price Decision Matrix',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Compare two options side-by-side to find the absolute best value instantly while shopping.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Option A Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A24),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Option A',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _priceA,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        onChanged: (_) => _calculateComparison(),
                        decoration: const InputDecoration(
                          labelText: 'Price (\$)',
                          labelStyle: TextStyle(color: Colors.grey, fontSize: 11),
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _qtyA,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        onChanged: (_) => _calculateComparison(),
                        decoration: const InputDecoration(
                          labelText: 'Qty / Grams',
                          labelStyle: TextStyle(color: Colors.grey, fontSize: 11),
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Rate: \$${_unitRateA.toStringAsFixed(2)} / 100u',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Option B Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A24),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purple.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Option B',
                        style: TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _priceB,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        onChanged: (_) => _calculateComparison(),
                        decoration: const InputDecoration(
                          labelText: 'Price (\$)',
                          labelStyle: TextStyle(color: Colors.grey, fontSize: 11),
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _qtyB,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        onChanged: (_) => _calculateComparison(),
                        decoration: const InputDecoration(
                          labelText: 'Qty / Grams',
                          labelStyle: TextStyle(color: Colors.grey, fontSize: 11),
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Rate: \$${_unitRateB.toStringAsFixed(2)} / 100u',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Winner Summary Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF004D40), Color(0xFF00796B)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.stars, color: Colors.amber, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Decision Matrix Verdict',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _winner,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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