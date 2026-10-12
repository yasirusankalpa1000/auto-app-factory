import 'package:flutter/material.dart';

void main() {
  runApp(const SideDeckApp());
}

class SideDeckApp extends StatelessWidget {
  const SideDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SideDeck Overlay HUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF12121D),
      ),
      home: const MainDashboardScreen(),
    );
  }
}

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _currentTabIndex = 0;
  bool _isOverlayEnabled = true;
  bool _isNotificationListenerActive = true;
  bool _isAccessibilityActive = false;
  
  // Floating bubble position simulator
  Offset _bubblePosition = const Offset(20, 250);
  bool _isDrawerOpen = false;

  // ClipShelf State
  final List<Map<String, String>> _clipboardItems = [
    {
      'title': 'Amazon Promo Code',
      'content': 'DISCOUNT20OFF',
      'category': 'Shopping',
      'time': '10 mins ago'
    },
    {
      'title': 'Delivery Address',
      'content': '742 Evergreen Terrace, Springfield, OR 97477',
      'category': 'Addresses',
      'time': '1 hour ago'
    },
    {
      'title': 'Client Quick Reply',
      'content': 'Thanks for reaching out! I will review the file and get back to you shortly.',
      'category': 'Work',
      'time': '3 hours ago'
    },
    {
      'title': 'Price Quote',
      'content': 'Total amount estimated: \$149.99 with free shipping.',
      'category': 'Shopping',
      'time': '5 hours ago'
    },
  ];

  String _selectedCategory = 'All';

  // Quick Calculator Overlay State
  double _origPrice = 100.0;
  double _discountPercent = 15.0;

  // Trivia / Brain Break State
  int _score = 0;
  int _currentQuestionIndex = 0;
  final List<Map<String, dynamic>> _triviaQuestions = [
    {
      'question': 'Which phone gesture is most commonly used to trigger edge overlays?',
      'options': ['Swipe from Side', 'Double Tap Screen', 'Shake Phone', 'Triple Volume Down'],
      'answer': 0,
    },
    {
      'question': 'What saves maximum screen battery on OLED displays while browsing?',
      'options': ['Full White Mode', 'Pure Dark/Dim Overlay', 'High Refresh Rate', 'Maximum Volume'],
      'answer': 1,
    },
    {
      'question': 'What is the standard dynamic shortcut panel called on Android smartphones?',
      'options': ['Side Panel / Edge HUD', 'Bottom Bar', 'Top Shelf', 'Air Command'],
      'answer': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Body Content based on active tab
            Positioned.fill(
              child: IndexedStack(
                index: _currentTabIndex,
                children: [
                  _buildHudControlTab(),
                  _buildClipShelfTab(),
                  _buildFloatingToolsTab(),
                  _buildBrainBreakTab(),
                  _buildPermissionsTab(),
                ],
              ),
            ),

            // Simulated System Floating Bubble Overlay
            if (_isOverlayEnabled)
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
                      _isDrawerOpen = !_isDrawerOpen;
                    });
                  },
                  child: Material(
                    elevation: 10,
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Colors.deepPurple, Colors.indigo],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.5),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.layers,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),

            // Simulated Floating Drawer Overlay Modal
            if (_isOverlayEnabled && _isDrawerOpen)
              Positioned(
                left: 20,
                right: 20,
                top: 100,
                child: _buildFloatingOverlayDrawer(),
              ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTabIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1E1E2C),
        indicatorColor: Colors.deepPurple,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.widgets_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.widgets, color: Colors.white),
            label: 'HUD',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_paste_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.content_paste, color: Colors.white),
            label: 'ClipShelf',
          ),
          NavigationDestination(
            icon: Icon(Icons.build_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.build, color: Colors.white),
            label: 'Tools',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.psychology, color: Colors.white),
            label: 'BrainBreak',
          ),
          NavigationDestination(
            icon: Icon(Icons.security_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.security, color: Colors.white),
            label: 'Access',
          ),
        ],
      ),
    );
  }

  // TAB 1: HUD CONTROL
  Widget _buildHudControlTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBanner(),
          const SizedBox(height: 20),
          _buildOverlayStatusCard(),
          const SizedBox(height: 20),
          Text(
            'Smart Context Modes',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select active mode to customize dynamic floating shortcuts',
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
          ),
          const SizedBox(height: 12),
          _buildContextModeGrid(),
          const SizedBox(height: 20),
          _buildActiveOverlayPreviewCard(),
        ],
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade900, Colors.indigo.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.amber, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SideDeck Overlay Engine',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Floating HUD active over all apps. Drag the purple bubble anytime!',
                  style: TextStyle(color: Colors.grey[300], fontSize: 12),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    _isOverlayEnabled ? Icons.check_circle : Icons.pause_circle_filled,
                    color: _isOverlayEnabled ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Display Above Apps HUD',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Switch(
                value: _isOverlayEnabled,
                activeColor: Colors.deepPurpleAccent,
                onChanged: (val) {
                  setState(() {
                    _isOverlayEnabled = val;
                  });
                },
              ),
            ],
          ),
          const Divider(color: Colors.white70, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.content_paste, color: Colors.tealAccent, size: 20),
                  const SizedBox(width: 10),
                  const Text(
                    'Auto-Capture Clipboard',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
              Switch(
                value: _isNotificationListenerActive,
                activeColor: Colors.teal,
                onChanged: (val) {
                  setState(() {
                    _isNotificationListenerActive = val;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContextModeGrid() {
    final modes = [
      {'title': 'Shopping Hub', 'desc': 'Price comparison & promo vault', 'icon': Icons.shopping_bag, 'color': Colors.amber},
      {'title': 'Chat Assistant', 'desc': 'Quick replies & phrase book', 'icon': Icons.chat_bubble, 'color': Colors.blue},
      {'title': 'Focus Reading', 'desc': 'Screen filter & dynamic sticky notes', 'icon': Icons.menu_book, 'color': Colors.teal},
      {'title': 'Work / Research', 'desc': 'Multi-clipboard & link shelf', 'icon': Icons.work, 'color': Colors.purple},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.3,
      ),
      itemCount: modes.length,
      itemBuilder: (context, index) {
        final mode = modes[index];
        final Color color = mode['color'] as Color;
        return InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Activated ${mode['title']} mode for Floating HUD!'),
                backgroundColor: color,
                duration: const Duration(seconds: 1),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(mode['icon'] as IconData, color: color, size: 26),
                const SizedBox(height: 8),
                Text(
                  mode['title'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  mode['desc'] as String,
                  style: TextStyle(color: Colors.grey[400], fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActiveOverlayPreviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.touch_app, color: Colors.indigoAccent),
              SizedBox(width: 8),
              Text(
                'Try Interactive Overlay',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the purple floating bubble anywhere on screen to test opening the SideDeck overlay drawer directly!',
            style: TextStyle(color: Colors.grey[300], fontSize: 13),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _isDrawerOpen = !_isDrawerOpen;
              });
            },
            icon: const Icon(Icons.open_in_new, size: 18),
            label: Text(_isDrawerOpen ? 'Close Floating Overlay Drawer' : 'Open Floating Overlay Drawer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 44),
            ),
          ),
        ],
      ),
    );
  }

  // FLOATING OVERLAY DRAWER SIMULATOR
  Widget _buildFloatingOverlayDrawer() {
    return Material(
      elevation: 20,
      color: const Color(0xFF181824),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.deepPurpleAccent, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.layers, color: Colors.deepPurpleAccent),
                    SizedBox(width: 8),
                    Text(
                      'SideDeck Floating HUD',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _isDrawerOpen = false;
                    });
                  },
                ),
              ],
            ),
            const Divider(color: Colors.white70),
            const SizedBox(height: 8),
            const Text(
              'Quick Floating Shortcuts:',
              style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAxisAlignment.start,
              children: [
                _buildDrawerActionButton(Icons.copy, 'Recent Clip', Colors.teal, () {
                  _showMiniModal('Copied Recent Item: DISCOUNT20OFF');
                }),
                _buildDrawerActionButton(Icons.calculate, 'Discount \$', Colors.amber, () {
                  _showMiniModal('Quick Calc: \$100 - 15% = \$85.00');
                }),
                _buildDrawerActionButton(Icons.note_add, 'Sticky Note', Colors.orange, () {
                  _showMiniModal('Pinned Floating Sticky Note to Screen!');
                }),
                _buildDrawerActionButton(Icons.translate, 'Translate', Colors.blue, () {
                  _showMiniModal('Auto-Translated snippet to English!');
                }),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  Icon(Icons.lightbulb, color: Colors.amber, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tip: Move bubble anywhere by dragging its border!',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
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

  Widget _buildDrawerActionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  void _showMiniModal(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.deepPurpleAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // TAB 2: CLIPSHELF & SNIPPET VAULT
  Widget _buildClipShelfTab() {
    final filtered = _selectedCategory == 'All'
        ? _clipboardItems
        : _clipboardItems.where((item) => item['category'] == _selectedCategory).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ClipShelf Vault',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.deepPurpleAccent, size: 28),
                onPressed: _addNewSnippetDialog,
              ),
            ],
          ),
          Text(
            'Auto-saved clips available inside floating overlay',
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
          ),
          const SizedBox(height: 14),
          _buildCategorySelector(),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final item = filtered[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2C),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white70),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['title'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item['category'] ?? '',
                            style: const TextStyle(color: Colors.deepPurpleAccent, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['content'] ?? '',
                      style: TextStyle(color: Colors.grey[300], fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['time'] ?? '',
                          style: TextStyle(color: Colors.grey[500], fontSize: 11),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.copy, color: Colors.tealAccent, size: 18),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Copied "${item['title']}" to clipboard!'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
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
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    final categories = ['All', 'Shopping', 'Addresses', 'Work'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSelected = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              selectedColor: Colors.deepPurple,
              backgroundColor: const Color(0xFF1E1E2C),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[400],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = cat;
                  });
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  void _addNewSnippetDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          title: const Text('Add Quick Snippet', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Snippet Content',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    _clipboardItems.insert(0, {
                      'title': titleController.text,
                      'content': contentController.text,
                      'category': 'Work',
                      'time': 'Just now',
                    });
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // TAB 3: FLOATING TOOLS SUITE
  Widget _buildFloatingToolsTab() {
    double discountedPrice = _origPrice - (_origPrice * (_discountPercent / 100));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,