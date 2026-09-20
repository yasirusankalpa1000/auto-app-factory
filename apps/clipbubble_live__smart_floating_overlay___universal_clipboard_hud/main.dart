import 'package:flutter/material.dart';

void main() {
  runApp(const ClipBubbleApp());
}

class ClipBubbleApp extends StatelessWidget {
  const ClipBubbleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClipBubble Live',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        cardTheme: CardTheme(
          color: const Color(0xFF1E293B),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class ClipItem {
  final String id;
  final String text;
  final String category; // 'OTP', 'URL', 'PHONE', 'BANK', 'TEXT'
  final DateTime timestamp;
  bool isPinned;
  final String? actionSubtitle;

  ClipItem({
    required this.id,
    required this.text,
    required this.category,
    required this.timestamp,
    this.isPinned = false,
    this.actionSubtitle,
  });
}

class TextSnippet {
  final String id;
  final String title;
  final String content;
  final IconData icon;

  TextSnippet({
    required this.id,
    required this.title,
    required this.content,
    required this.icon,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedTabIndex = 0;
  
  // Overlay Settings State
  bool _isOverlayEnabled = true;
  bool _isNotificationHudEnabled = true;
  bool _autoCleanLinks = true;
  bool _autoDismissOTP = true;
  
  // Floating Bubble Simulation State
  bool _isBubbleExpanded = false;
  Offset _bubblePosition = const Offset(20, 200);

  // Simulated Live Data
  final List<ClipItem> _clips = [
    ClipItem(
      id: '1',
      text: '849201',
      category: 'OTP',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      actionSubtitle: 'Detected OTP Code • Auto-expires in 5m',
    ),
    ClipItem(
      id: '2',
      text: 'https://store.example.com/product/9923?utm_source=social&utm_medium=click&ref=tracker99',
      category: 'URL',
      timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
      actionSubtitle: 'Tracking tags removable',
    ),
    ClipItem(
      id: '3',
      text: '+1 (555) 019-2834',
      category: 'PHONE',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      actionSubtitle: 'Ready for Direct Dial or WhatsApp',
    ),
    ClipItem(
      id: '4',
      text: 'Account: 0049-8832-1920 | Routing: 121000358',
      category: 'BANK',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isPinned: true,
      actionSubtitle: 'Formatted Bank Transfer Info',
    ),
    ClipItem(
      id: '5',
      text: 'Meeting notes: Discuss Q3 UI design floating bar specs and permissions flow.',
      category: 'TEXT',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  final List<TextSnippet> _snippets = [
    TextSnippet(
      id: 's1',
      title: 'Bank Account Info',
      content: 'Bank: Commercial Bank\nAcc Name: Alex Miller\nAcc No: 8829-1092-4412\nBranch: Downtown Main',
      icon: Icons.account_balance,
    ),
    TextSnippet(
      id: 's2',
      title: 'Home Address & Note',
      content: '742 Evergreen Terrace, Sector 4, Apartment 12B. Gate code: #4092',
      icon: Icons.home,
    ),
    TextSnippet(
      id: 's3',
      title: 'Wi-Fi Details',
      content: 'SSID: Home_Guest_5G | Password: FastConnect2025!',
      icon: Icons.wifi,
    ),
    TextSnippet(
      id: 's4',
      title: 'Quick Business Reply',
      content: 'Hello! Thanks for reaching out. Please check our dynamic rates at example.com or reply to schedule a call.',
      icon: Icons.chat_bubble_outline,
    ),
  ];

  String _searchQuery = '';
  String _selectedCategoryFilter = 'ALL';

  void _addNewClip(String text, String category) {
    setState(() {
      _clips.insert(
        0,
        ClipItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          category: category,
          timestamp: DateTime.now(),
          actionSubtitle: 'Recently added snippet',
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied & saved to ClipBubble: "$text"'),
        backgroundColor: Colors.indigo,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddClipDialog() {
    final TextEditingController textController = TextEditingController();
    String selectedCat = 'TEXT';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1E293B),
            title: const Text('Add Manual Clip Snippet'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Type or paste content here...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Type: ', style: TextStyle(color: Colors.white70)),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: selectedCat,
                      dropdownColor: const Color(0xFF1E293B),
                      items: ['TEXT', 'OTP', 'URL', 'PHONE', 'BANK']
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c, style: const TextStyle(color: Colors.white)),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedCat = val);
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                onPressed: () {
                  if (textController.text.trim().isNotEmpty) {
                    _addNewClip(textController.text.trim(), selectedCat);
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Save Clip', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  String _cleanUrl(String original) {
    try {
      final uri = Uri.parse(original);
      return '${uri.scheme}://${uri.host}${uri.path}';
    } catch (_) {
      return original;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildTopNotificationBanner(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedTabIndex,
                    children: [
                      _buildLiveHubTab(),
                      _buildSmartClipsTab(),
                      _buildTextExpanderTab(),
                      _buildOverlaySettingsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Interactive Draggable Floating Bubble Simulator
          if (_isOverlayEnabled) _buildDraggableFloatingBubble(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) => setState(() => _selectedTabIndex = index),
        backgroundColor: const Color(0xFF0F172A),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt),
            label: 'Live Hub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste_go),
            label: 'Clips Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on),
            label: 'Expander',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: _selectedTabIndex == 1
          ? FloatingActionButton(
              onPressed: _showAddClipDialog,
              backgroundColor: Colors.tealAccent,
              child: const Icon(Icons.add, color: Colors.black),
            )
          : null,
    );
  }

  // Floating Notification Status Bar Bar Header
  Widget _buildTopNotificationBanner() {
    if (!_isNotificationHudEnabled) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      color: const Color(0xFF1E1B4B),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.indigo,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.layers, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'ClipBubble Floating Assistant Active',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Monitoring clipboard • Ready to auto-parse OTPs & links',
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.tealAccent, width: 0.5),
            ),
            child: Row(
              children: const [
                Icon(Icons.circle, color: Colors.greenAccent, size: 8),
                SizedBox(width: 4),
                Text(
                  'RUNNING',
                  style: TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 1: LIVE HUB & OVERLAY DEMO
  Widget _buildLiveHubTab() {
    final recentClip = _clips.isNotEmpty ? _clips.first : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF312E81), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.indigoAccent.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.touch_app, color: Colors.tealAccent, size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Universal Screen Assistant',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Seamless copy-paste without leaving your apps',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isOverlayEnabled ? Colors.indigo : Colors.grey.shade800,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isOverlayEnabled = !_isOverlayEnabled;
                          });
                        },
                        icon: Icon(_isOverlayEnabled ? Icons.visibility : Icons.visibility_off),
                        label: Text(_isOverlayEnabled ? 'Overlay Active' : 'Enable Overlay'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.tealAccent,
                        side: const BorderSide(color: Colors.tealAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        _addNewClip('903812', 'OTP');
                      },
                      icon: const Icon(Icons.bolt, size: 18),
                      label: const Text('Simulate Copy'),
                    ),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Active Detected Clipboard Highlight Card
          const Text(
            'LATEST DETECTED CLIPBOARD ACTION',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),

          if (recentClip != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _getCategoryBadge(recentClip.category),
                        const SizedBox(width: 8),
                        Text(
                          _getCategoryTitle(recentClip.category),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatTime(recentClip.timestamp),
                          style: const TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SelectableText(
                      recentClip.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (recentClip.actionSubtitle != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        recentClip.actionSubtitle!,
                        style: const TextStyle(color: Colors.amberAccent, fontSize: 11),
                      ),
                    ],
                    const Divider(height: 24, color: Colors.white70),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _buildClipActionButtons(recentClip),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 20),

          // Quick Dynamic Tools
          const Text(
            'FLOATING DIRECTIVITY TOOLS',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: _buildQuickToolCard(
                  icon: Icons.shield,
                  color: Colors.tealAccent,
                  title: 'Clean Links',
                  subtitle: 'Strip URL tracking tags automatically',
                  onTap: () {
                    _addNewClip('https://shop.com/item?utm_source=fb_ad', 'URL');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickToolCard(
                  icon: Icons.vpn_key,
                  color: Colors.amberAccent,
                  title: 'OTP Auto Paste',
                  subtitle: 'Detect 4-6 digit SMS codes live',
                  onTap: () {
                    _addNewClip('492018', 'OTP');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickToolCard(
                  icon: Icons.phone_forwarded,
                  color: Colors.lightBlueAccent,
                  title: 'WhatsApp Router',
                  subtitle: 'Chat unsaved numbers directly',
                  onTap: () {
                    _addNewClip('+1 (555) 998-3312', 'PHONE');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickToolCard(
                  icon: Icons.payments,
                  color: Colors.greenAccent,
                  title: 'Bank Formatter',
                  subtitle: 'Format account numbers & codes',
                  onTap: () {
                    _addNewClip('Bank Acc: 9982-1029-4410', 'BANK');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TAB 2: SMART CLIPS FEED & HISTORY
  Widget _buildSmartClipsTab() {
    final filtered = _clips.where((item) {
      final matchesSearch = item.text.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCat = _selectedCategoryFilter == 'ALL' || item.category == _selectedCategoryFilter;
      return matchesSearch && matchesCat;
    }).toList();

    return Column(
      children: [
        // Search & Filter Header
        Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFF0F172A),
          child: Column(
            children: [
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search copied items, OTPs, numbers...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['ALL', 'OTP', 'URL', 'PHONE', 'BANK', 'TEXT'].map((cat) {
                    final isSelected = _selectedCategoryFilter == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(cat),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black : Colors.white70,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        selectedColor: Colors.tealAccent,
                        backgroundColor: const Color(0xFF1E293B),
                        onSelected: (val) {
                          setState(() {
                            _selectedCategoryFilter = cat;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ),

        // Clips List Feed
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.content_paste, size: 48, color: Colors.grey),
                      SizedBox(height: 12),
                      Text('No clipboard items found', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _getCategoryBadge(item.category),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _formatTime(item.timestamp),
                                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                                  ),
                                ),
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    item.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                                    color: item.isPinned ? Colors.tealAccent : Colors.grey,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      item.isPinned = !item.isPinned;
                                    });
                                  },
                                ),
                                const SizedBox(width: 12),
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      _clips.removeWhere((c) => c.id == item.id);
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SelectableText(
                              item.text,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _buildClipActionButtons(item),
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

  // TAB 3: TEXT EXPANDER & REPETITIVE SNIPPETS
  Widget _buildTextExpanderTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.tealAccent.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.flash_on, color: Colors.tealAccent, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '1-Tap Text Expander',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Instant copy templates available directly on your floating bubble overlay',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
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
                'FREQUENT TEXT TEMPLATES',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  _showAddSnippetDialog();
                },
                icon: const Icon(Icons.add, size: 16, color: Colors.tealAccent),
                label: const Text('Add Template', style: TextStyle(color: Colors.tealAccent, fontSize: 12)),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _snippets.length,
            itemBuilder: (context, index) {
              final snip = _snippets[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAddSnippetDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('New Text Template'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Template Title (e.g., WiFi Pass)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Text Content',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            onPressed: () {
              if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                setState(() {
                  _snippets.add(
                    TextSnippet(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text,
                      content: contentController.text,
                      icon: Icons.notes,
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save Template', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // TAB 4: OVERLAY PERMISSIONS & SYSTEM SETTINGS
  Widget _buildOverlaySettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SYSTEM & OVERLAY PERMISSIONS',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),

          // Permission Status Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildPermissionTile(
                    title: 'Display Over Other Apps',
                    subtitle: 'Required to draw floating clipboard bubble over messaging & web apps',
                    isGranted: true,
                    icon: Icons.layers,
                  ),
                  const Divider(height: 20, color: Colors.white70),
                  _buildPermissionTile(
                    title: 'Clipboard Listener Permission',
                    subtitle: 'Monitors text copy events to automatically parse OTPs and links',
                    isGranted: true,
                    icon: Icons.content_paste,
                  ),
                  const Divider(height: 20, color: Colors.white70),
                  _buildPermissionTile(
                    title: 'Background Notification HUD',
                    subtitle: 'Keeps quick clipboard actions active in top status bar',
                    isGranted: true,
                    icon: Icons.notifications_active,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'AUTOMATION PREFERENCES',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),

          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: _isOverlayEnabled,
                  activeColor: Colors.tealAccent,
                  title: const Text('Show Floating Overlay Bubble', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Draggable floating target on phone screen', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  onChanged: (val) => setState(() => _isOverlayEnabled = val),
                ),
                const Divider(height: 1, color: Colors.white70),
                SwitchListTile(
                  value: _isNotificationHudEnabled,
                  activeColor: Colors.tealAccent,
                  title: const Text('Top Notification HUD Bar', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Show live active banner status', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  onChanged: (val) => setState(() => _isNotificationHudEnabled = val),
                ),
                const Divider(height: 1, color: Colors.white70),
                SwitchListTile(
                  value: _autoCleanLinks,
                  activeColor: Colors.tealAccent,
                  title: const Text('Auto-Strip URL Tracking Tags', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Removes utm_source, ref, and affiliate parameters automatically', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  onChanged: (val) => setState(() => _autoCleanLinks = val),
                ),
                const Divider(height: 1, color: Colors.white70),
                SwitchListTile(
                  value: _autoDismissOTP,
                  activeColor: Colors.tealAccent,
                  title: const Text('Auto-Expire Copied OTPs', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Clears sensitive verification codes after 5 minutes for security', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  onChanged: (val) => setState(() => _autoDismissOTP = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Card(
            color: const Color(0xFF1E1B4B),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.indigoAccent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Privacy Protected',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'All copied clips are stored locally on your device. Zero cloud sync or data transmission.',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Interactive Draggable Floating Bubble UI Simulator
  Widget _buildDraggableFloatingBubble() {
    return Positioned(
      left: _bubblePosition.dx,
      top: _bubblePosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubblePosition += details.delta;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isBubbleExpanded = !_isBubbleExpanded;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.indigo, Colors.teal],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                  border: Border.all(color: Colors.tealAccent, width: 2),
                ),
                child: const Icon(
                  Icons.content_copy,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),

            if (_isBubbleExpanded) ...[
              const SizedBox(height: 8),
              Container(
                width: 240,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.tealAccent.withOpacity(0.5)),
                  boxShadow: const [
                    BoxShadow(color: Colors.black87, blurRadius: 12),
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
                          'ClipBubble Overlay HUD',
                          style: TextStyle(
                            color: Colors.tealAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _isBubbleExpanded = false),
                          child: const Icon(Icons.close, size: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white70, height: 16),

                    if (_clips.isNotEmpty) ...[
                      const Text(
                        'Quick Paste Latest:',
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _clips.first.text,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    const Text(
                      '1-Tap Quick Expander:',
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _snippets.take(3).map((s) {
                        return InkWell(
                          onTap: () {
                            _addNewClip(s.content, 'TEXT');
                            setState(() => _isBubbleExpanded = false);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.indigo.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.indigoAccent, width: 0.5),
                            ),
                            child: Text(
                              s.title,
                              style: const TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  // Helpers
  Widget _getCategoryBadge(String cat) {
    Color bg = Colors.indigo;
    IconData icon = Icons.text_snippet;

    switch (cat) {
      case 'OTP':
        bg = Colors.amber.shade800;
        icon = Icons.security;
        break;
      case 'URL':
        bg = Colors.teal;
        icon = Icons.link;
        break;
      case 'PHONE':
        bg = Colors.blue;
        icon = Icons.phone;
        break;
      case 'BANK':
        bg = Colors.green.shade700;
        icon = Icons.account_balance;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: bg, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            cat,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _getCategoryTitle(String cat) {
    switch (cat) {
      case 'OTP':
        return 'Verification Code Detected';
      case 'URL':
        return 'Web Address Link';
      case 'PHONE':
        return 'Phone Number';
      case 'BANK':
        return 'Bank Transfer Details';
      default:
        return 'Copied Text Snippet';
    }
  }

  List<Widget> _buildClipActionButtons(ClipItem item) {
    final List<Widget> actions = [];

    // Standard Copy Button
    actions.add(
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Copied: "${item.text}"'),
              backgroundColor: Colors.indigo,
              duration: const Duration(seconds: 1),
            ),
          );
        },
        icon: const Icon(Icons.content_copy, size: 14),
        label: const Text('Copy', style: TextStyle(fontSize: 11)),
      ),
    );

    // Contextual Category Actions
    if (item.category == 'URL') {
      actions.add(
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.tealAccent,
            side: const BorderSide(color: Colors.tealAccent),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            final cleaned = _cleanUrl(item.text);
            _addNewClip(cleaned, 'URL');
          },
          icon: const Icon(Icons.cleaning_services, size: 14),
          label: const Text('Clean URL', style: TextStyle(fontSize: 11)),
        ),
      );
    } else if (item.category == 'PHONE') {
      actions.add(
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.greenAccent,
            side: const BorderSide(color: Colors.greenAccent),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Opening WhatsApp shortcut for ${item.text}...'),
                backgroundColor: Colors.green,
              ),
            );
          },
          icon: const Icon(Icons.chat, size: 14),
          label: const Text('WhatsApp', style: TextStyle(fontSize: 11)),
        ),
      );
    } else if (item.category == 'OTP') {
      actions.add(
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.amberAccent,
            side: const BorderSide(color: Colors.amberAccent),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('1-Tap OTP Auto-filled into active input field!'),
                backgroundColor: Colors.amber,
              ),
            );
          },
          icon: const Icon(Icons.bolt, size: 14),
          label: const Text('Auto-Fill OTP', style: TextStyle(fontSize: 11)),
        ),
      );
    }

    return actions;
  }

  Widget _buildQuickToolCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionTile({
    required String title,
    required String subtitle,
    required bool isGranted,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.indigo.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.indigoAccent, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          isGranted ? Icons.check_circle : Icons.error,
          color: isGranted ? Colors.greenAccent : Colors.redAccent,
          size: 20,
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}