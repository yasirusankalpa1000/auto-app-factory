import 'package:flutter/material.dart';

void main() {
  runApp(const BubbleDeckApp());
}

class BubbleDeckApp extends StatelessWidget {
  const BubbleDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BubbleDeck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.teal,
          secondary: Colors.amber,
          surface: Color(0xFF1E293B),
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

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedTabIndex = 0;
  bool _isOverlayActive = true;

  // App Global State
  Offset _bubbleOffset = const Offset(20, 180);
  bool _isBubbleExpanded = false;
  Color _bubbleColor = Colors.teal;
  double _bubbleOpacity = 0.9;
  double _bubbleSize = 56.0;

  // Permission states
  bool _permDisplayOverApps = true;
  bool _permClipboardRead = true;
  bool _permAccessibility = true;
  bool _permNotificationListener = false;

  // Multi-Clipboard items
  final List<Map<String, dynamic>> _clipboardItems = [
    {
      'id': '1',
      'text': 'ACCT: 8940-1294-5501 (Commercial Bank Sri Lanka)',
      'category': 'Banking',
      'isPinned': true,
      'time': '2 mins ago',
    },
    {
      'id': '2',
      'text': 'https://maps.google.com/?q=6.9271,79.8612',
      'category': 'Links',
      'isPinned': true,
      'time': '15 mins ago',
    },
    {
      'id': '3',
      'text': 'Package tracking code: LK-99201-X9',
      'category': 'Codes',
      'isPinned': false,
      'time': '1 hour ago',
    },
    {
      'id': '4',
      'text': 'Payment total: \$145.50 for monthly cloud utility bill',
      'category': 'Finance',
      'isPinned': false,
      'time': '3 hours ago',
    },
  ];

  // Text Expander Shortcuts
  final List<Map<String, String>> _textExpanders = [
    {
      'trigger': '!acc',
      'replacement': 'Bank Account: 8940-1294-5501 | Name: A. B. Perera',
      'uses': '34',
    },
    {
      'trigger': '!mail',
      'replacement': 'dev.user@example.com',
      'uses': '89',
    },
    {
      'trigger': '!loc',
      'replacement': 'No. 45, Main Street, Colombo 03, Sri Lanka',
      'uses': '12',
    },
    {
      'trigger': '!thanks',
      'replacement': 'Thank you for your response! Let me know if you need anything else.',
      'uses': '56',
    },
  ];

  // Active floating tools
  bool _toolMultiClip = true;
  bool _toolExpander = true;
  bool _toolQuickCalc = true;
  bool _toolStickyNotes = true;

  // Quick Sticky Note state
  String _floatingStickyText = 'Call delivery driver regarding order #8812';

  void _addClipboardItem(String text, String category) {
    setState(() {
      _clipboardItems.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'text': text,
        'category': category,
        'isPinned': false,
        'time': 'Just now',
      });
    });
  }

  void _addTextExpander(String trigger, String replacement) {
    setState(() {
      _textExpanders.add({
        'trigger': trigger.startsWith('!') ? trigger : '!$trigger',
        'replacement': replacement,
        'uses': '0',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildSandboxTab(),
      _buildClipboardTab(),
      _buildExpanderTab(),
      _buildToolsStudioTab(),
      _buildPermissionsTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.widgets, color: Colors.teal),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'BubbleDeck',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: _isOverlayActive
                  ? Colors.green.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isOverlayActive ? Colors.green : Colors.grey,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  size: 10,
                  color: _isOverlayActive ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  _isOverlayActive ? 'OVERLAY ON' : 'PAUSED',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _isOverlayActive ? Colors.green : Colors.grey,
                  ),
                ),
                Switch(
                  value: _isOverlayActive,
                  activeColor: Colors.teal,
                  onChanged: (val) {
                    setState(() {
                      _isOverlayActive = val;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: pages[_selectedTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        onTap: (idx) {
          setState(() {
            _selectedTabIndex = idx;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.touch_app),
            label: 'Sandbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy),
            label: 'Multi-Clip',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt),
            label: 'Expander',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Studio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            label: 'System',
          ),
        ],
      ),
    );
  }

  // TAB 1: Live Interactive Overlay Sandbox
  Widget _buildSandboxTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informational header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Colors.teal),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Drag the floating bubble around the phone sandbox below! Tap it to test live dynamic floating actions.',
                      style: const TextStyle(fontSize: 13, color: Colors.white70),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Phone Simulator Sandbox Frame
            Center(
              child: Container(
                width: 320,
                height: 480,
                decoration: BoxDecoration(
                  color: const Color(0xFF020617),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.grey.shade700, width: 4),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black87,
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      // Simulated background phone wallpaper & mock app interface
                      Positioned.fill(
                        child: Column(
                          children: [
                            // Mock Phone Status Bar
                            Container(
                              height: 28,
                              color: Colors.black87,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '09:41',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.wifi, size: 12, color: Colors.white),
                                      SizedBox(width: 4),
                                      Icon(Icons.battery_full, size: 12, color: Colors.white),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Simulated Chat App Screen Background
                            Expanded(
                              child: Container(
                                color: const Color(0xFF0F172A),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1E293B),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.teal,
                                            child: Text('W', style: TextStyle(fontSize: 10, color: Colors.white)),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'WhatsApp Chat Simulation',
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _buildMockChatMessage('Hey! Can you send me your bank details & tracking ID?'),
                                    const SizedBox(height: 8),
                                    _buildMockChatMessage('Tap the floating bubble to paste instantly without switching apps!', isUser: true),
                                    const Spacer(),
                                    // Mock text input bar
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1E293B),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.emoji_emotions, size: 16, color: Colors.grey),
                                          SizedBox(width: 8),
                                          Text(
                                            'Type a message...',
                                            style: TextStyle(fontSize: 11, color: Colors.grey),
                                          ),
                                          Spacer(),
                                          Icon(Icons.send, size: 16, color: Colors.teal),
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

                      // Interactive Draggable Floating Bubble Overlay
                      if (_isOverlayActive)
                        Positioned(
                          left: _bubbleOffset.dx,
                          top: _bubbleOffset.dy,
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                double newX = _bubbleOffset.dx + details.delta.dx;
                                double newY = _bubbleOffset.dy + details.delta.dy;
                                // Clamp within simulated screen boundaries
                                newX = newX.clamp(0.0, 260.0);
                                newY = newY.clamp(30.0, 410.0);
                                _bubbleOffset = Offset(newX, newY);
                              });
                            },
                            onTap: () {
                              setState(() {
                                _isBubbleExpanded = !_isBubbleExpanded;
                              });
                            },
                            child: Material(
                              elevation: 8,
                              shape: const CircleBorder(),
                              color: _bubbleColor.withOpacity(_bubbleOpacity),
                              child: Container(
                                width: _bubbleSize,
                                height: _bubbleSize,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _isBubbleExpanded ? Icons.close : Icons.layers,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            ),
                          ),
                        ),

                      // Expanded Dynamic Floating Action Drawer Overlay
                      if (_isOverlayActive && _isBubbleExpanded)
                        Positioned(
                          left: (_bubbleOffset.dx > 130) ? _bubbleOffset.dx - 180 : _bubbleOffset.dx + 10,
                          top: (_bubbleOffset.dy > 250) ? _bubbleOffset.dy - 180 : _bubbleOffset.dy + 10,
                          child: Container(
                            width: 200,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B).withOpacity(0.95),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.teal.withOpacity(0.6), width: 1.5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black87,
                                  blurRadius: 12,
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
                                    const Row(
                                      children: [
                                        Icon(Icons.bolt, size: 14, color: Colors.amber),
                                        SizedBox(width: 4),
                                        Text(
                                          'Quick Actions',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isBubbleExpanded = false;
                                        });
                                      },
                                      child: const Icon(Icons.close, size: 14, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const Divider(height: 12, color: Colors.white70),

                                // Action Item 1: Multi Clipboard Stack
                                if (_toolMultiClip) ...[
                                  _buildFloatingActionItem(
                                    icon: Icons.content_paste,
                                    label: 'Paste Recent Bank',
                                    color: Colors.teal,
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Pasted bank details to current app!'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                      setState(() {
                                        _isBubbleExpanded = false;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 6),
                                ],

                                // Action Item 2: Dynamic Expander Trigger
                                if (_toolExpander) ...[
                                  _buildFloatingActionItem(
                                    icon: Icons.text_fields,
                                    label: 'Insert !mail Macro',
                                    color: Colors.amber,
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Expanded !mail -> dev.user@example.com'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                      setState(() {
                                        _isBubbleExpanded = false;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 6),
                                ],

                                // Action Item 3: Quick Sticky Note Peek
                                if (_toolStickyNotes) ...[
                                  _buildFloatingActionItem(
                                    icon: Icons.sticky_note_2,
                                    label: 'Read Floating Note',
                                    color: Colors.orange,
                                    onTap: () {
                                      _showStickyNoteModal(context);
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Live Diagnostics card
            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Floating Overlay Performance',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatChip(Icons.memory, 'Memory', '14 MB'),
                        _buildStatChip(Icons.speed, 'Latency', '2 ms'),
                        _buildStatChip(Icons.touch_app, 'Triggers Today', '128'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMockChatMessage(String text, {bool isUser = false}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(maxWidth: 200),
        decoration: BoxDecoration(
          color: isUser ? Colors.teal.shade800 : const Color(0xFF334155),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 10, color: Colors.white),
          softWrap: true,
        ),
      ),
    );
  }

  Widget _buildFloatingActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Colors.teal),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // TAB 2: Multi-Clipboard History Stack Vault
  Widget _buildClipboardTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Multi-Clipboard Vault',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddClipDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('New Clip'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Items copied anywhere on your phone are stacked floatingly in real-time.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Search Bar
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search stored clips & numbers...',
                prefixIcon: Icon(Icons.search, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
            const SizedBox(height: 16),

            // Stored Clipboard Cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _clipboardItems.length,
              itemBuilder: (context, index) {
                final item = _clipboardItems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: const Color(0xFF1E293B),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item['category'],
                                style: const TextStyle(fontSize: 10, color: Colors.teal, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              item['time'],
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                            IconButton(
                              icon: Icon(
                                item['isPinned'] ? Icons.star : Icons.star_border,
                                size: 18,
                                color: item['isPinned'] ? Colors.amber : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  item['isPinned'] = !item['isPinned'];
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['text'],
                          style: const TextStyle(fontSize: 13, color: Colors.white),
                          softWrap: true,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _clipboardItems.removeAt(index);
                                });
                              },
                              icon: const Icon(Icons.delete, size: 14, color: Colors.grey),
                              label: const Text('Remove', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Copied clip to active system clipboard!')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal.shade700,
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.copy, size: 14),
                              label: const Text('Copy Quick', style: TextStyle(fontSize: 11)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // TAB 3: Text Expander Macros
  Widget _buildExpanderTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Text Expander Engine',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddExpanderDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                  ),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('New Macro'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Type short triggers anywhere on screen to replace them instantly with full snippets.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Active Expanders List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _textExpanders.length,
              itemBuilder: (context, index) {
                final macro = _textExpanders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: const Color(0xFF1E293B),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.amber.withOpacity(0.2),
                      child: const Icon(Icons.bolt, color: Colors.amber, size: 20),
                    ),
                    title: Text(
                      macro['trigger']!,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          macro['replacement']!,
                          style: const TextStyle(fontSize: 12, color: Colors.white70),
                          softWrap: true,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Used ${macro['uses']} times',
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey, size: 18),
                      onPressed: () {
                        setState(() {
                          _textExpanders.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // TAB 4: Floating Tools & Customization Studio
  Widget _buildToolsStudioTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Floating Overlay Studio',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Customize bubble appearance, active overlay widgets, and opacity.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Active Modules Toggle
            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enabled Overlay Utilities',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: const Text('Multi-Clipboard Stack', style: TextStyle(fontSize: 13)),
                      subtitle: const Text('Captures copied text items', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      value: _toolMultiClip,
                      activeColor: Colors.teal,
                      onChanged: (val) => setState(() => _toolMultiClip = val),
                    ),
                    SwitchListTile(
                      title: const Text('Dynamic Text Expander', style: TextStyle(fontSize: 13)),
                      subtitle: const Text('Replaces !shortcuts auto-magically', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      value: _toolExpander,
                      activeColor: Colors.teal,
                      onChanged: (val) => setState(() => _toolExpander = val),
                    ),
                    SwitchListTile(
                      title: const Text('Quick Floating Calculator', style: TextStyle(fontSize: 13)),
                      subtitle: const Text('Mini calculation pad over active apps', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      value: _toolQuickCalc,
                      activeColor: Colors.teal,
                      onChanged: (val) => setState(() => _toolQuickCalc = val),
                    ),
                    SwitchListTile(
                      title: const Text('Sticky Floating Reminders', style: TextStyle(fontSize: 13)),
                      subtitle: const Text('Pins micro notes over screen', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      value: _toolStickyNotes,
                      activeColor: Colors.teal,
                      onChanged: (val) => setState(() => _toolStickyNotes = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bubble Styling Customizer
            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bubble Aesthetics',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    const Text('Bubble Primary Theme Color', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      crossAxisAlignment: WrapCrossAxisAlignment.center,
                      children: [
                        _buildColorOption(Colors.teal),
                        _buildColorOption(Colors.amber),
                        _buildColorOption(Colors.indigo),
                        _buildColorOption(Colors.purple),
                        _buildColorOption(Colors.orange),
                        _buildColorOption(Colors.blue),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Bubble Opacity: ${(_bubbleOpacity * 100).round()}%', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    Slider(
                      value: _bubbleOpacity,
                      min: 0.3,
                      max: 1.0,
                      activeColor: Colors.teal,
                      onChanged: (val) => setState(() => _bubbleOpacity = val),
                    ),
                    Text('Bubble Diameter: ${_bubbleSize.round()} px', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    Slider(
                      value: _bubbleSize,
                      min: 40.0,
                      max: 72.0,
                      activeColor: Colors.teal,
                      onChanged: (val) => setState(() => _bubbleSize = val),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    bool isSelected = _bubbleColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          _bubbleColor = color;
        });
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 3,
          ),
        ),
        child: isSelected ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
      ),
    );
  }

  // TAB 5: Permissions & Diagnostic Center
  Widget _buildPermissionsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'System Integration & Permissions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'BubbleDeck requires specific Android/iOS system permissions to display overlays above apps.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            _buildPermissionTile(
              title: 'Display Over Other Apps',
              description: 'Allows the floating bubble action pad to stay visible over WhatsApp, Chrome, etc.',
              isGranted: _permDisplayOverApps,
              onChanged: (val) => setState(() => _permDisplayOverApps = val),
            ),
            const SizedBox(height: 10),
            _buildPermissionTile(
              title: 'Clipboard Auto-Sync',
              description: 'Automatically intercepts copied text into your multi-clipboard stack.',
              isGranted: _permClipboardRead,
              onChanged: (val) => setState(() => _permClipboardRead = val),
            ),
            const SizedBox(height: 10),
            _buildPermissionTile(
              title: 'Accessibility Service (Text Expander)',
              description: 'Detects dynamic text macro triggers like !acc and expands them automatically.',
              isGranted: _permAccessibility,
              onChanged: (val) => setState(() => _permAccessibility = val),
            ),
            const SizedBox(height: 10),
            _buildPermissionTile(
              title: 'Notification Reader',
              description: 'Captures OTPs and tracking codes directly into floating actions.',
              isGranted: _permNotificationListener,
              onChanged: (val) => setState(() => _permNotificationListener = val),
            ),
            const SizedBox(height: 20),

            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.security, color: Colors.teal),
                        SizedBox(width: 8),
                        Text(
                          'Privacy & Security Guarantee',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'All clipboard items, text macros, and notes stay strictly on your local device. No data is ever sent to external cloud servers.',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionTile({
    required String title,
    required String description,
    required bool isGranted,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      color: const Color(0xFF1E293B),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              isGranted ? Icons.check_circle : Icons.warning,
              color: isGranted ? Colors.green : Colors.amber,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            Switch(
              value: isGranted,
              activeColor: Colors.teal,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  // Modals & Dialogs
  void _showStickyNoteModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.sticky_note_2, color: Colors.orange),
                  SizedBox(width: 8),
                  Text(
                    'Floating Sticky Note Preview',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: TextEditingController(text: _floatingStickyText),
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Quick Floating Reminder',
                ),
                onChanged: (val) {
                  _floatingStickyText = val;
                },
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Save Note', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddClipDialog(BuildContext context) {
    final textController = TextEditingController();
    final catController = TextEditingController(text: 'General');

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text('Add Stored Clip'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'Clip Text / Bank Details / Link',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: catController,
                decoration: const InputDecoration(
                  labelText: 'Category Tag',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  _addClipboardItem(textController.text, catController.text);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Save Snippet', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showAddExpanderDialog(BuildContext context) {
    final trigController = TextEditingController();
    final repController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text('Create Text Macro Shortcut'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: trigController,
                decoration: const InputDecoration(
                  labelText: 'Trigger (e.g. !addr)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: repController,
                decoration: const InputDecoration(
                  labelText: 'Full Expanded Text',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                if (trigController.text.isNotEmpty && repController.text.isNotEmpty) {
                  _addTextExpander(trigController.text, repController.text);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add Macro', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}