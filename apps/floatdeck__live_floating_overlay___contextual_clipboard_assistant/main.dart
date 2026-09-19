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
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF12181F),
      ),
      home: const MainDeckScreen(),
    );
  }
}

class ClipItem {
  final String id;
  final String content;
  final String category; // 'Phone', 'Price', 'URL', 'Email', 'Text'
  final DateTime timestamp;
  bool isPinned;

  ClipItem({
    required this.id,
    required this.content,
    required this.category,
    required this.timestamp,
    this.isPinned = false,
  });
}

class MainDeckScreen extends StatefulWidget {
  const MainDeckScreen({super.key});

  @override
  State<MainDeckScreen> createState() => _MainDeckScreenState();
}

class _MainDeckScreenState extends State<MainDeckScreen> with SingleTickerProviderStateMixin {
  int _currentBottomNavIndex = 0;
  
  // Floating Overlay Control State
  bool _overlayPermissionGranted = true;
  bool _overlayActive = true;
  bool _isFloatingExpanded = false;
  Offset _floatingPos = const Offset(20, 200);
  String _activeFloatingTool = 'Clipboard';

  // System Notification Bar Control State
  bool _stickyNotificationActive = true;
  bool _autoCopyNotify = true;

  // Clip Storage State
  final List<ClipItem> _clips = [
    ClipItem(
      id: '1',
      content: 'https://flutter.dev/docs/development',
      category: 'URL',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isPinned: true,
    ),
    ClipItem(
      id: '2',
      content: 'Order Total: \$49.99 (Discount code: SAVE20)',
      category: 'Price',
      timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
      isPinned: true,
    ),
    ClipItem(
      id: '3',
      content: '+1 (555) 019-2834 - Delivery Driver',
      category: 'Phone',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ClipItem(
      id: '4',
      content: 'support@service-center.org',
      category: 'Email',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];

  final TextEditingController _clipInputController = TextEditingController();

  // Simulated Analytics
  int _appSwitchesSaved = 148;
  int _minutesSaved = 42;

  void _addNewClip(String text) {
    if (text.trim().isEmpty) return;

    String category = 'Text';
    if (text.contains('http://') || text.contains('https://')) {
      category = 'URL';
    } else if (text.contains('\$') || text.toLowerCase().contains('usd')) {
      category = 'Price';
    } else if (text.contains('@') && text.contains('.')) {
      category = 'Email';
    } else if (RegExp(r'[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}').hasMatch(text)) {
      category = 'Phone';
    }

    setState(() {
      _clips.insert(
        0,
        ClipItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: text.trim(),
          category: category,
          timestamp: DateTime.now(),
        ),
      );
      _clipInputController.clear();
      _appSwitchesSaved += 3;
      _minutesSaved += 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Clip captured & tagged as [$category]!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteClip(String id) {
    setState(() {
      _clips.removeWhere((item) => item.id == id);
    });
  }

  void _togglePin(ClipItem clip) {
    setState(() {
      clip.isPinned = !clip.isPinned;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.layers, color: Colors.teal),
            const SizedBox(width: 8),
            const Text(
              'FloatDeck HUD',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _overlayActive ? Colors.teal.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _overlayActive ? Colors.teal : Colors.red),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: _overlayActive ? Colors.teal : Colors.red,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _overlayActive ? 'OVERLAY ON' : 'OFF',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _overlayActive ? Colors.teal : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A222D),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Main Body Navigator
          SafeArea(
            child: IndexedStack(
              index: _currentBottomNavIndex,
              children: [
                _buildOverlayControlTab(size),
                _buildSmartClipVaultTab(),
                _buildNotificationDeckTab(),
                _buildAnalyticsTab(),
              ],
            ),
          ),

          // SIMULATED SYSTEM FLOATING OVERLAY HEAD (Interactive draggable bubble)
          if (_overlayActive)
            Positioned(
              left: _floatingPos.dx,
              top: _floatingPos.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _floatingPos = Offset(
                      (_floatingPos.dx + details.delta.dx).clamp(10.0, size.width - 70.0),
                      (_floatingPos.dy + details.delta.dy).clamp(60.0, size.height - 180.0),
                    );
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Floating Head Icon
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isFloatingExpanded = !_isFloatingExpanded;
                        });
                      },
                      child: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.teal,
                        child: Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Colors.teal, Colors.cyan],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Center(
                            child: Icon(
                              _isFloatingExpanded ? Icons.close : Icons.widgets,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Expanded Floating Mini Window Preview
                    if (_isFloatingExpanded)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: 240,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2733),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.teal.withOpacity(0.5), width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black87,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.bolt, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                const Expanded(
                                  child: Text(
                                    'FloatDeck Overlay Head',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isFloatingExpanded = false;
                                    });
                                  },
                                  child: const Icon(Icons.close, size: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                            const Divider(color: Colors.white70, height: 12),
                            const Text(
                              'Recent Fast Clip:',
                              style: TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _clips.isNotEmpty ? _clips.first.content : 'No clips captured yet',
                                style: const TextStyle(fontSize: 11, color: Colors.tealAccent),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                _buildMiniActionButton(Icons.content_copy, 'Copy', () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Quick copied to clipboard!')),
                                  );
                                }),
                                _buildMiniActionButton(Icons.share, 'Share', () {}),
                                _buildMiniActionButton(Icons.add, 'Snip', () {
                                  _addNewClip('Snip sample \$19.99 from screen context');
                                }),
                              ],
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A222D),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Overlay Dock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy),
            label: 'Clip Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: 'Sticky Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Stats & Time',
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 1: OVERLAY DOCK CONTROLLER
  // ---------------------------------------------------------------------------
  Widget _buildOverlayControlTab(Size size) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade900.withOpacity(0.6), Colors.blueGrey.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shield, color: Colors.tealAccent, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'System Floating Permission',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            softWrap: true,
                          ),
                          Text(
                            _overlayPermissionGranted
                                ? 'Display Over Other Apps: GRANTED'
                                : 'Permission required for background dock',
                            style: TextStyle(
                              color: _overlayPermissionGranted ? Colors.greenAccent : Colors.orangeAccent,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'FloatDeck adds an interactive floating action head on top of Chrome, WhatsApp, Shopping apps & PDF readers to prevent constant app switching.',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                  softWrap: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Main Overlay Toggle Switch
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2733),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.smartphone, color: Colors.teal),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enable Screen Floating Bubble',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        'Keep assistant bubble visible on system screen',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _overlayActive,
                  activeColor: Colors.teal,
                  onChanged: (val) {
                    setState(() {
                      _overlayActive = val;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            'Floating Tool Dock Selection',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose which micro-tool active bubble launches on quick single tap:',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          // Grid Selection for active overlay mode
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildToolCard(
                'Clipboard Vault',
                'Auto-detects URLs, numbers & price tags',
                Icons.content_copy,
                _activeFloatingTool == 'Clipboard',
                () => setState(() => _activeFloatingTool = 'Clipboard'),
              ),
              _buildToolCard(
                'Quick Snip Memo',
                'Instant screen text micro-notes',
                Icons.edit_note,
                _activeFloatingTool == 'Memo',
                () => setState(() => _activeFloatingTool = 'Memo'),
              ),
              _buildToolCard(
                'Dynamic Actions',
                '1-Tap Call, Search & Map Navigator',
                Icons.bolt,
                _activeFloatingTool == 'Actions',
                () => setState(() => _activeFloatingTool = 'Actions'),
              ),
              _buildToolCard(
                'AdMob Revenue Hub',
                'Engagement rewarded power shortcuts',
                Icons.monetization_on,
                _activeFloatingTool == 'Rewards',
                () => setState(() => _activeFloatingTool = 'Rewards'),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.amber.shade900.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade700),
            ),
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.amber),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Tip: Drag the teal floating bubble anywhere around your screen margins to reposition it comfortably while browsing!',
                    style: TextStyle(fontSize: 11, color: Colors.amberAccent),
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

  Widget _buildToolCard(
    String title,
    String subtitle,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal.withOpacity(0.25) : const Color(0xFF1E2733),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.teal : Colors.white70,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: isSelected ? Colors.tealAccent : Colors.grey),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isSelected ? Colors.white : Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 2: SMART CLIP VAULT
  // ---------------------------------------------------------------------------
  Widget _buildSmartClipVaultTab() {
    return Column(
      children: [
        // Input Box for Clip Simulation
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _clipInputController,
                      style: const TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Paste or type snippet (e.g. \$19.99, phone, URL)',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        fillColor: Color(0xFF1E2733),
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _addNewClip(_clipInputController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildQuickTagChip('All Clips', true),
                    _buildQuickTagChip('Prices (\$)'),
                    _buildQuickTagChip('Links'),
                    _buildQuickTagChip('Phones'),
                    _buildQuickTagChip('Emails'),
                  ],
                ),
              ),
            ],
          ),
        ),

        // List of Captured Clips
        Expanded(
          child: _clips.isEmpty
              ? const Center(
                  child: Text(
                    'No clipped items saved yet.\nUse floating bubble or paste above!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _clips.length,
                  itemBuilder: (context, index) {
                    final clip = _clips[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2733),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: clip.isPinned ? Colors.teal : Colors.white70,
                          width: clip.isPinned ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(clip.category).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _getCategoryColor(clip.category),
                                  ),
                                ),
                                child: Text(
                                  clip.category.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: _getCategoryColor(clip.category),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: Icon(
                                  clip.isPinned ? Icons.star : Icons.star_border,
                                  color: clip.isPinned ? Colors.amber : Colors.grey,
                                  size: 20,
                                ),
                                onPressed: () => _togglePin(clip),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.grey, size: 20),
                                onPressed: () => _deleteClip(clip.id),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          SelectableText(
                            clip.content,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                '${clip.timestamp.hour}:${clip.timestamp.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                              const Spacer(),
                              _buildActionButtonForItem(clip),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildQuickTagChip(String label, [bool isSelected = false]) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        backgroundColor: isSelected ? Colors.teal : const Color(0xFF1E2733),
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'URL':
        return Colors.blue;
      case 'Price':
        return Colors.green;
      case 'Phone':
        return Colors.amber;
      case 'Email':
        return Colors.purple;
      default:
        return Colors.teal;
    }
  }

  Widget _buildActionButtonForItem(ClipItem clip) {
    IconData icon = Icons.content_copy;
    String actionLabel = 'Copy';

    if (clip.category == 'URL') {
      icon = Icons.open_in_new;
      actionLabel = 'Open Link';
    } else if (clip.category == 'Phone') {
      icon = Icons.phone;
      actionLabel = 'Dial';
    } else if (clip.category == 'Email') {
      icon = Icons.email;
      actionLabel = 'Send Email';
    } else if (clip.category == 'Price') {
      icon = Icons.attach_money;
      actionLabel = 'Compare';
    }

    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Triggered "$actionLabel" for snippet!')),
        );
      },
      icon: Icon(icon, size: 14, color: Colors.white),
      label: Text(actionLabel, style: const TextStyle(fontSize: 11, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal.shade800,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 3: STICKY NOTIFICATION DECK
  // ---------------------------------------------------------------------------
  Widget _buildNotificationDeckTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sticky System Notification Controls',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          const Text(
            'Keep an active control bar in your phone notification drawer for zero-app-switch actions.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Toggles
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2733),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.notifications_active, color: Colors.amber),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Persistent Notification Deck',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Switch(
                      value: _stickyNotificationActive,
                      activeColor: Colors.teal,
                      onChanged: (val) {
                        setState(() {
                          _stickyNotificationActive = val;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(color: Colors.white70),
                Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.cyan),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Auto Copy-Snip Alert Popups',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Switch(
                      value: _autoCopyNotify,
                      activeColor: Colors.teal,
                      onChanged: (val) {
                        setState(() {
                          _autoCopyNotify = val;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            'Live Notification Preview',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.tealAccent),
          ),
          const SizedBox(height: 8),

          // SIMULATED SYSTEM NOTIFICATION BANNER
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF252F3E),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white70),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black87,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.layers, size: 16, color: Colors.teal),
                    const SizedBox(width: 6),
                    const Text(
                      'FloatDeck Active Context Hub',
                      style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    const Text(
                      'now',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Quick Snip Buffer: 4 Items Stored',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  _clips.isNotEmpty ? 'Latest: ${_clips.first.content}' : 'Ready to capture clips',
                  style: const TextStyle(fontSize: 11, color: Colors.tealAccent),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNotificationActionButton(Icons.add_a_photo, 'Snip Screen'),
                    _buildNotificationActionButton(Icons.content_paste, 'Paste Vault'),
                    _buildNotificationActionButton(Icons.cleaning_services, 'Clear Buffer'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationActionButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.tealAccent),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 4: USAGE STATS & AD ENGAGEMENT HUB
  // ---------------------------------------------------------------------------
  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Workflow Intelligence',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          const Text(
            'Track time saved by staying inside floating contextual overlays.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Stat Cards Row
          Row(
            children: [
              Expanded(
                child: _buildStatMetricCard(
                  '$_appSwitchesSaved',
                  'App Switches Saved',
                  Icons.swap_horiz,
                  Colors.teal,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatMetricCard(
                  '${_minutesSaved}m',
                  'Daily Time Saved',
                  Icons.timer,
                  Colors.amber,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2733),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.amber),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'AdMob Revenue Engagement Simulation',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'High user dwell time achieved! Users keep FloatDeck open / floating continuously throughout daily browsing.',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                  softWrap: true,
                ),
                const SizedBox(height: 12),
                const LinearProgressIndicator(
                  value: 0.82,
                  backgroundColor: Colors.black87,
                  color: Colors.teal,
                  minHeight: 8,
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Active Screen Session: 2h 14m', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Text('Est. eCPM Boost: High', style: TextStyle(fontSize: 10, color: Colors.tealAccent)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'Pro Active Overlay Skin Options',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 10),

          // Customization Bubbles
          Wrap(
            spacing: 12,
            children: [
              _buildThemeBadge('Teal Cyber', Colors.teal, true),
              _buildThemeBadge('Neon Purple', Colors.purple, false),
              _buildThemeBadge('Amber Gold', Colors.amber, false),
              _buildThemeBadge('Deep Crimson', Colors.red, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatMetricCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2733),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
            softWrap: true,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeBadge(String title, Color color, bool active) {
    return Chip(
      avatar: CircleAvatar(backgroundColor: color, radius: 6),
      label: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          color: active ? Colors.white : Colors.grey,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      backgroundColor: active ? color.withOpacity(0.3) : const Color(0xFF1E2733),
      side: BorderSide(color: active ? color : Colors.white70),
    );
  }

  Widget _buildMiniActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.teal.shade900,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 10, color: Colors.tealAccent),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}