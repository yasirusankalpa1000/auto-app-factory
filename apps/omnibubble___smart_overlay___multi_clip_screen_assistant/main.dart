import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const OmniBubbleApp());
}

class OmniBubbleApp extends StatelessWidget {
  const OmniBubbleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniBubble Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class ClipSnippet {
  final String id;
  final String content;
  final String category; // 'Link', 'Number', 'Note', 'Bank/ID'
  final DateTime timestamp;
  bool isPinned;

  ClipSnippet({
    required this.id,
    required this.content,
    required this.category,
    required this.timestamp,
    this.isPinned = false,
  });
}

class NotificationDockCard {
  final String id;
  final String title;
  final String detail;
  final IconData icon;
  final Color badgeColor;
  bool isActive;

  NotificationDockCard({
    required this.id,
    required this.title,
    required this.detail,
    required this.icon,
    required this.badgeColor,
    this.isActive = true,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentTabIndex = 0;
  bool _isOverlayEnabled = true;
  Offset _bubblePosition = const Offset(280, 400);
  bool _isBubbleExpanded = false;
  String _selectedCategoryFilter = 'All';

  final TextEditingController _clipInputController = TextEditingController();
  final TextEditingController _quickToolInputController = TextEditingController();

  final List<ClipSnippet> _clipList = [
    ClipSnippet(
      id: '1',
      content: 'Account: 8004921021 (BOC Bank)',
      category: 'Bank/ID',
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      isPinned: true,
    ),
    ClipSnippet(
      id: '2',
      content: 'https://flutter.dev/docs/get-started',
      category: 'Link',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ClipSnippet(
      id: '3',
      content: 'Meeting venue: 45/A, Galle Road, Colombo 03',
      category: 'Note',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    ClipSnippet(
      id: '4',
      content: '+94 77 123 4567',
      category: 'Number',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isPinned: true,
    ),
  ];

  final List<NotificationDockCard> _dockCards = [
    NotificationDockCard(
      id: 'n1',
      title: 'Active Shopping List Snippet',
      detail: 'Milk, Bread, Eggs, Coffee beans',
      icon: Icons.check_box,
      badgeColor: Colors.amber,
      isActive: true,
    ),
    NotificationDockCard(
      id: 'n2',
      title: 'Pinned Account Info',
      detail: 'Sampath Bank: 1009 4512 8890',
      icon: Icons.monetization_on,
      badgeColor: Colors.teal,
      isActive: true,
    ),
    NotificationDockCard(
      id: 'n3',
      title: 'Quick Speech/Text Scratchpad',
      detail: 'Call delivery driver before 4 PM today',
      icon: Icons.schedule,
      badgeColor: Colors.purple,
      isActive: false,
    ),
  ];

  void _addNewClip(String text, String category) {
    if (text.trim().isEmpty) return;
    setState(() {
      _clipList.insert(
        0,
        ClipSnippet(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: text.trim(),
          category: category,
          timestamp: DateTime.now(),
        ),
      );
    });
    _clipInputController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved to Multi-Clip Vault!')),
    );
  }

  void _copyToSystemClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: "$text"'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteClip(String id) {
    setState(() {
      _clipList.removeWhere((item) => item.id == id);
    });
  }

  void _togglePin(String id) {
    setState(() {
      final item = _clipList.firstWhere((element) => element.id == id);
      item.isPinned = !item.isPinned;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OmniBubble Assistant',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Row(
            children: [
              const Text(
                'Overlay',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
              Switch(
                value: _isOverlayEnabled,
                activeColor: Colors.amber,
                onChanged: (val) {
                  setState(() {
                    _isOverlayEnabled = val;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        val
                            ? 'Display Floating Overlay enabled!'
                            : 'Display Floating Overlay disabled.',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: _currentTabIndex,
            children: [
              _buildMultiClipVaultTab(),
              _buildFloatingStudioTab(),
              _buildNotificationDockTab(),
              _buildQuickToolsTab(),
            ],
          ),

          // Simulated Interactive On-Screen Floating Overlay Bubble
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
                    _isBubbleExpanded = !_isBubbleExpanded;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.widgets,
                        color: Colors.white,
                        size: 26,
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                            ),
                          ],
                          border: Border.all(color: Colors.indigo.shade100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Omni Quick Dock',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.indigo,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isBubbleExpanded = false;
                                    });
                                  },
                                  child: const Icon(Icons.close, size: 16),
                                ),
                              ],
                            ),
                            const Divider(height: 12),
                            const Text(
                              'Latest Clip:',
                              style: TextStyle(
                                  fontSize: 10, color: Colors.grey),
                            ),
                            Text(
                              _clipList.isNotEmpty
                                  ? _clipList.first.content
                                  : 'No clips available',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    if (_clipList.isNotEmpty) {
                                      _copyToSystemClipboard(
                                          _clipList.first.content);
                                    }
                                  },
                                  icon: const Icon(Icons.content_copy,
                                      size: 12),
                                  label: const Text(
                                    'Copy',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    _showAddClipDialog(context);
                                  },
                                  icon: const Icon(Icons.add, size: 12),
                                  label: const Text(
                                    'New',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
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
        currentIndex: _currentTabIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (idx) {
          setState(() {
            _currentTabIndex = idx;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Multi-Clip',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.touch_app),
            label: 'Overlay Studio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Status Dock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Quick Tools',
          ),
        ],
      ),
    );
  }

  // TAB 1: MULTI-CLIP VAULT
  Widget _buildMultiClipVaultTab() {
    final filteredList = _selectedCategoryFilter == 'All'
        ? _clipList
        : _clipList
            .where((item) => item.category == _selectedCategoryFilter)
            .toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick input bar
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _clipInputController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText:
                          'Type or paste long text, account info, URLs, notes...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: ['Note', 'Bank/ID', 'Link', 'Number']
                                .map(
                                  (cat) => Padding(
                                    padding:
                                        const EdgeInsets.only(right: 6.0),
                                    child: ActionChip(
                                      label: Text(
                                        cat,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                      onPressed: () {
                                        _addNewClip(
                                          _clipInputController.text,
                                          cat,
                                        );
                                      },
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          _addNewClip(_clipInputController.text, 'Note');
                        },
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Save Clip'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Category Filter Badges
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Pinned', 'Bank/ID', 'Link', 'Number', 'Note']
                    .map((cat) {
                  final isSelected = _selectedCategoryFilter == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(cat),
                      selectedColor: Colors.indigo.shade100,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategoryFilter = cat;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // Header stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Saved Snippets (${filteredList.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Clipboard.getData(Clipboard.kTextPlain).then((value) {
                      if (value != null && value.text != null) {
                        _addNewClip(value.text!, 'Note');
                      }
                    });
                  },
                  icon: const Icon(Icons.content_paste, size: 16),
                  label: const Text('Fetch System Clipboard'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // List of clips
            if (filteredList.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                child: Column(
                  children: const [
                    Icon(Icons.layers_clear, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'No clip snippets found in this category.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final item = filteredList[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(item.category)
                                      .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.category,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: _getCategoryColor(item.category),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.all(4),
                                    icon: Icon(
                                      item.isPinned
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: item.isPinned
                                          ? Colors.amber
                                          : Colors.grey,
                                      size: 20,
                                    ),
                                    onPressed: () => _togglePin(item.id),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.all(4),
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    onPressed: () => _deleteClip(item.id),
                                  ),
                                ],
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
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item.timestamp.hour}:${item.timestamp.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo.shade50,
                                  foregroundColor: Colors.indigo,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                ),
                                onPressed: () =>
                                    _copyToSystemClipboard(item.content),
                                icon: const Icon(Icons.copy, size: 14),
                                label: const Text(
                                  'Copy Clip',
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
          ],
        ),
      ),
    );
  }

  // TAB 2: OVERLAY STUDIO (FLOATING ASSISTANT CONFIG)
  Widget _buildFloatingStudioTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.indigo, Colors.blueAccent],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'On-Screen Floating Bubble',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Access your copied links, bank numbers, and quick micro-tools over top of Facebook, WhatsApp, or Chrome without switching apps!',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _bubblePosition = const Offset(150, 300);
                            _isOverlayEnabled = true;
                          });
                        },
                        child: const Text('Reset Bubble Position'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Overlay Quick Action Buttons',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            _buildSettingToggleTile(
              title: 'Auto-Copy Latest Clip on Tap',
              subtitle: 'Single click on floating bubble pastes active clip',
              icon: Icons.bolt,
              value: true,
            ),
            _buildSettingToggleTile(
              title: 'Display Above Apps Permission',
              subtitle: 'Simulated System Overlay Status: Granted',
              icon: Icons.visibility,
              value: true,
            ),
            _buildSettingToggleTile(
              title: 'Smart Screen Edge Snapping',
              subtitle: 'Bubble automatically snaps to phone left/right margin',
              icon: Icons.border_outer,
              value: true,
            ),

            const SizedBox(height: 16),
            const Text(
              'Interactive Sandbox Preview',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.touch_app, color: Colors.indigo, size: 32),
                    SizedBox(height: 6),
                    Text(
                      'Drag the floating widget on your screen!',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Tap it to open quick clipboard shortcuts dynamic drawer.',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
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

  // TAB 3: NOTIFICATION DOCK TAB
  Widget _buildNotificationDockTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'System Notification Dock Cards',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            const Text(
              'Pin persistent customizable widgets inside your mobile swipe-down notification shade for instant access.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _dockCards.length,
              itemBuilder: (context, index) {
                final card = _dockCards[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: card.badgeColor,
                          foregroundColor: Colors.white,
                          child: Icon(card.icon, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                card.detail,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: card.isActive,
                          activeColor: Colors.indigo,
                          onChanged: (val) {
                            setState(() {
                              card.isActive = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(14),
                ),
                onPressed: () => _showAddDockCardDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Create Sticky Notification Card'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 4: QUICK TOOLS TAB
  Widget _buildQuickToolsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Instant Screen Utilities',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            const Text(
              'Clean, format, or extract information from copied texts instantly.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Utility Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Text Cleaner & Extractor Tool',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _quickToolInputController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Paste unstructured messy text or message here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          final text = _quickToolInputController.text;
                          final numbersOnly =
                              text.replaceAll(RegExp(r'[^0-9+]'), ' ');
                          _quickToolInputController.text =
                              numbersOnly.replaceAll(RegExp(r'\s+'), ' ').trim();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Extracted Phone/Account Numbers!')),
                          );
                        },
                        icon: const Icon(Icons.phone, size: 14),
                        label: const Text('Extract Numbers'),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          final text = _quickToolInputController.text;
                          _quickToolInputController.text = text.toUpperCase();
                        },
                        icon: const Icon(Icons.text_fields, size: 14),
                        label: const Text('UPPERCASE'),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          final text = _quickToolInputController.text;
                          _quickToolInputController.text =
                              text.replaceAll(RegExp(r'\s+'), ' ').trim();
                        },
                        icon: const Icon(Icons.cleaning_services, size: 14),
                        label: const Text('Clean Spaces'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            // Live Device Stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.dashboard, color: Colors.indigo),
                      SizedBox(width: 8),
                      Text(
                        'Active Floating Dashboard Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  _buildStatRow('Saved Clips Count', '${_clipList.length} items'),
                  _buildStatRow('Pinned Snippets',
                      '${_clipList.where((x) => x.isPinned).length} items'),
                  _buildStatRow('Active Dock Cards',
                      '${_dockCards.where((x) => x.isActive).length} active'),
                  _buildStatRow('Floating Overlay Service',
                      _isOverlayEnabled ? 'Running (Active)' : 'Disabled'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // HELPER WIDGETS & DIALOGS
  Widget _buildSettingToggleTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        trailing: Icon(
          value ? Icons.check_circle : Icons.circle_outlined,
          color: value ? Colors.green : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
          Text(
            val,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String cat) {
    switch (cat) {
      case 'Bank/ID':
        return Colors.teal;
      case 'Link':
        return Colors.blue;
      case 'Number':
        return Colors.orange;
      default:
        return Colors.indigo;
    }
  }

  void _showAddClipDialog(BuildContext context) {
    final controller = TextEditingController();
    String category = 'Note';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Quick Clip'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter text content...',
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
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _addNewClip(controller.text, category);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save Snippet'),
          ),
        ],
      ),
    );
  }

  void _showAddDockCardDialog(BuildContext context) {
    final titleController = TextEditingController();
    final detailController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Sticky Status Card'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Card Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: detailController,
              decoration: const InputDecoration(
                labelText: 'Detail / Message',
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
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                setState(() {
                  _dockCards.add(
                    NotificationDockCard(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text,
                      detail: detailController.text,
                      icon: Icons.star,
                      badgeColor: Colors.indigo,
                      isActive: true,
                    ),
                  );
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Pinned card to system notification shade!')),
                );
              }
            },
            child: const Text('Pin Card'),
          ),
        ],
      ),
    );
  }
}