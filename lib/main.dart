import 'package:flutter/material.dart';

void main() {
  runApp(const BubbleMateApp());
}

class BubbleMateApp extends StatelessWidget {
  const BubbleMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BubbleMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class SnippetItem {
  final String id;
  final String shortcut;
  final String title;
  final String content;
  final String category;
  int copyCount;

  SnippetItem({
    required this.id,
    required this.shortcut,
    required this.title,
    required this.content,
    required this.category,
    this.copyCount = 0,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  bool _isOverlayEnabled = true;
  bool _isFloatingBubbleVisible = true;
  double _bubbleOpacity = 0.9;
  double _bubbleSize = 58.0;
  Color _bubbleColor = Colors.indigo;

  // Floating bubble drag coordinates inside preview
  Offset _bubblePosition = const Offset(20, 150);

  // Text Cleaner State
  final TextEditingController _cleanerInputController = TextEditingController();
  String _cleanedResult = '';
  String _cleanerStatus = '';

  // Expander Vault State
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: '1',
      shortcut: '!bank',
      title: 'Primary Bank Account',
      content: 'Bank: Commercial Bank\nAccount: 8004920192\nName: Alex Dev\nBranch: Main Metro',
      category: 'Finance',
      copyCount: 14,
    ),
    SnippetItem(
      id: '2',
      shortcut: '!addr',
      title: 'Home Delivery Address',
      content: 'No. 42/B, Green Garden Avenue, Suite 400, Silicon Bay, CA 94025',
      category: 'Personal',
      copyCount: 28,
    ),
    SnippetItem(
      id: '3',
      shortcut: '!email',
      title: 'Work Email Signature',
      content: 'Alex Dev | Senior Mobile Engineer\nEmail: alex.dev@enterprise.io\nPhone: +1 (555) 234-5678',
      category: 'Work',
      copyCount: 42,
    ),
    SnippetItem(
      id: '4',
      shortcut: '!zoom',
      title: 'Personal Meeting Room',
      content: 'https://meet.platform.io/join/849-204-119?pwd=sec789',
      category: 'Work',
      copyCount: 9,
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  // Notification simulation messages
  String _activeNotificationText = '';

  @override
  void dispose() {
    _cleanerInputController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showToast(String message) {
    setState(() {
      _activeNotificationText = message;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, overflow: TextOverflow.ellipsis),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.indigo,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  void _addNewSnippet(String shortcut, String title, String content, String category) {
    setState(() {
      _snippets.add(
        SnippetItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          shortcut: shortcut.startsWith('!') ? shortcut : '!$shortcut',
          title: title,
          content: content,
          category: category,
        ),
      );
    });
    _showToast('Snippet "$shortcut" saved to Quick Vault!');
  }

  void _cleanText(String type) {
    String text = _cleanerInputController.text;
    if (text.isEmpty) {
      _showToast('Please enter or paste text to clean!');
      return;
    }

    String result = text;
    String statusMsg = '';

    switch (type) {
      case 'strip_utm':
        // Strip query parameters like utm_source, fbclid, etc.
        try {
          Uri uri = Uri.parse(text.trim());
          if (uri.hasQuery) {
            Map<String, String> queryParams = Map.from(uri.queryParameters);
            queryParams.removeWhere((key, value) =>
                key.startsWith('utm_') ||
                key == 'fbclid' ||
                key == 'gclid' ||
                key == 'si' ||
                key == 'ref');
            Uri cleanUri = uri.replace(queryParameters: queryParams.isEmpty ? null : queryParams);
            result = cleanUri.toString();
            statusMsg = 'Cleaned URL: Removed tracking tags (UTM/fbclid)!';
          } else {
            statusMsg = 'No tracking parameters found in URL.';
          }
        } catch (_) {
          statusMsg = 'Formatted text string successfully.';
        }
        break;

      case 'trim_spaces':
        result = text.replaceAll(RegExp(r'\s+'), ' ').trim();
        statusMsg = 'Removed duplicate spaces & extra line breaks!';
        break;

      case 'uppercase':
        result = text.toUpperCase();
        statusMsg = 'Converted to UPPERCASE!';
        break;

      case 'lowercase':
        result = text.toLowerCase();
        statusMsg = 'Converted to lowercase!';
        break;

      case 'bullet_points':
        List<String> lines = text.split('\n');
        result = lines.where((l) => l.trim().isNotEmpty).map((l) => '• ${l.trim()}').join('\n');
        statusMsg = 'Formatted list into clean bullet points!';
        break;

      case 'extract_phones':
        RegExp phoneRegex = RegExp(r'\+?\d[\d\s\-\(\)]{7,}\d');
        Iterable<Match> matches = phoneRegex.allMatches(text);
        List<String> found = matches.map((m) => m.group(0)!.trim()).toList();
        if (found.isNotEmpty) {
          result = found.join('\n');
          statusMsg = 'Extracted ${found.length} phone number(s)!';
        } else {
          result = 'No phone numbers found.';
          statusMsg = 'No numbers detected.';
        }
        break;
    }

    setState(() {
      _cleanedResult = result;
      _cleanerStatus = statusMsg;
    });
    _showToast(statusMsg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bubble_chart, color: Colors.indigo, size: 24),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'BubbleMate Hub',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isOverlayEnabled ? Icons.layers : Icons.layers_clear,
              color: _isOverlayEnabled ? Colors.indigo : Colors.grey,
            ),
            tooltip: 'Toggle Simulated Overlay',
            onPressed: () {
              setState(() {
                _isOverlayEnabled = !_isOverlayEnabled;
                _isFloatingBubbleVisible = _isOverlayEnabled;
              });
              _showToast(_isOverlayEnabled ? 'Overlay Dock Enabled' : 'Overlay Dock Paused');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black87),
            onPressed: () => _showSettingsBottomSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Live Status Floating Banner
            if (_activeNotificationText.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.indigo.shade50,
                child: Row(
                  children: [
                    const Icon(Icons.notifications_active, color: Colors.indigo, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _activeNotificationText,
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() => _activeNotificationText = ''),
                      child: const Icon(Icons.close, color: Colors.indigo, size: 16),
                    ),
                  ],
                ),
              ),

            // Tab View Body
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  _buildOverlay HubTab(),
                  _buildExpanderVaultTab(),
                  _buildTextSanitizerTab(),
                  _buildQuickToolsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: Colors.indigo,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.touch_app),
              label: 'Overlay Dock',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bolt),
              label: 'Text Expander',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cleaning_services),
              label: 'Sanitizer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              label: 'Tools Dock',
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // TAB 1: OVERLAY HUB & FLOATING BUBBLE SIMULATOR
  // -------------------------------------------------------------
  Widget _buildOverlayHubTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Status Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isOverlayEnabled
                    ? [Colors.indigo, Colors.blue.shade700]
                    : [Colors.grey.shade700, Colors.grey.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
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
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isOverlayEnabled ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isOverlayEnabled ? 'Floating Companion Active' : 'Companion Paused',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Text(
                            'Display Over Apps Permission: Granted',
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isOverlayEnabled,
                      activeColor: Colors.white,
                      activeTrackColor: Colors.indigoAccent,
                      onChanged: (val) {
                        setState(() {
                          _isOverlayEnabled = val;
                          _isFloatingBubbleVisible = val;
                        });
                        _showToast(val ? 'Floating Bubble enabled' : 'Floating Bubble disabled');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Drag the interactive bubble anywhere inside the preview arena below to test quick launching your shortcuts & sanitizer.',
                  style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // SIMULATED MOBILE SCREEN ARENA
          const Text(
            'Live Floating Bubble Arena',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 8),

          Container(
            height: 340,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300, width: 2),
            ),
            child: Stack(
              children: [
                // Background Simulated App Context
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 12,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            Container(
                              height: 12,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Simulated Screen Overlay Area',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Tap or drag the floating bubble anywhere. BubbleMate stays accessible while you write messages or browse.',
                                style: TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAxisAlignment.center,
                          children: [
                            ActionChip(
                              avatar: const Icon(Icons.copy, size: 14),
                              label: const Text('Simulate Copy', style: TextStyle(fontSize: 11)),
                              onPressed: () {
                                _cleanerInputController.text =
                                    'https://example.com/product?id=902&utm_source=facebook&fbclid=123987';
                                _showToast('Copied tracking link into sanitizer!');
                              },
                            ),
                            ActionChip(
                              avatar: const Icon(Icons.bolt, size: 14),
                              label: const Text('Test !bank', style: TextStyle(fontSize: 11)),
                              onPressed: () {
                                _showToast('Auto Expanded: Commercial Bank 8004920192');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Interactive Draggable Bubble Simulation
                if (_isFloatingBubbleVisible)
                  Positioned(
                    left: _bubblePosition.dx,
                    top: _bubblePosition.dy,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          double newX = _bubblePosition.dx + details.delta.dx;
                          double newY = _bubblePosition.dy + details.delta.dy;
                          // Clamp inside the arena bounds (340 height, approx container width)
                          newX = newX.clamp(0.0, 260.0);
                          newY = newY.clamp(0.0, 270.0);
                          _bubblePosition = Offset(newX, newY);
                        });
                      },
                      onTap: () => _openFloatingQuickSheet(context),
                      child: Opacity(
                        opacity: _bubbleOpacity,
                        child: Container(
                          width: _bubbleSize,
                          height: _bubbleSize,
                          decoration: BoxDecoration(
                            color: _bubbleColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _bubbleColor.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.bubble_chart, color: Colors.white, size: 28),
                              Positioned(
                                right: 4,
                                top: 4,
                                child: CircleAvatar(
                                  radius: 5,
                                  backgroundColor: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Customization Controls
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bubble Appearance & Behavior',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Bubble Opacity', style: TextStyle(fontSize: 12)),
                      ),
                      Slider(
                        value: _bubbleOpacity,
                        min: 0.3,
                        max: 1.0,
                        divisions: 7,
                        activeColor: Colors.indigo,
                        label: '${(_bubbleOpacity * 100).round()}%',
                        onChanged: (val) => setState(() => _bubbleOpacity = val),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Bubble Size', style: TextStyle(fontSize: 12)),
                      ),
                      Slider(
                        value: _bubbleSize,
                        min: 44.0,
                        max: 72.0,
                        divisions: 7,
                        activeColor: Colors.indigo,
                        label: '${_bubbleSize.round()}px',
                        onChanged: (val) => setState(() => _bubbleSize = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Theme Color', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    crossAxisAlignment: WrapCrossAxisAlignment.center,
                    children: [
                      _buildColorSelector(Colors.indigo),
                      _buildColorSelector(Colors.teal),
                      _buildColorSelector(Colors.deepOrange),
                      _buildColorSelector(Colors.purple),
                      _buildColorSelector(Colors.blue),
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

  Widget _buildColorSelector(Color color) {
    bool isSelected = _bubbleColor == color;
    return InkWell(
      onTap: () => setState(() => _bubbleColor = color),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.black, width: 2.5) : null,
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : null,
      ),
    );
  }

  // -------------------------------------------------------------
  // TAB 2: TEXT EXPANDER & SNIPPET VAULT
  // -------------------------------------------------------------
  Widget _buildExpanderVaultTab() {
    List<SnippetItem> filtered = _snippets.where((item) {
      bool matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      bool matchesSearch = item.shortcut.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.content.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Auto Text Expander',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      'Type shortcuts to instantly insert full text',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddSnippetDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Shortcut'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Search Field
          TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search shortcuts (!bank, !addr...)',
              prefixIcon: const Icon(Icons.search, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Finance', 'Personal', 'Work'].map((cat) {
                bool isSel = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSel,
                    selectedColor: Colors.indigo.withOpacity(0.15),
                    labelStyle: TextStyle(
                      color: isSel ? Colors.indigo : Colors.black87,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedCategory = cat);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Snippets List
          filtered.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  child: const Column(
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('No text shortcuts found', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  separatorBuilder: (c, i) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.indigo.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item.shortcut,
                                    style: const TextStyle(
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Used ${item.copyCount}x',
                                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.content,
                              style: const TextStyle(fontSize: 12, color: Colors.black87),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() => item.copyCount++);
                                    _showToast('Copied "${item.shortcut}" to clipboard!');
                                  },
                                  icon: const Icon(Icons.content_copy, size: 16),
                                  label: const Text('Quick Copy'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.indigo,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      size: 18, color: Colors.grey),
                                  onPressed: () {
                                    setState(() {
                                      _snippets.removeWhere((s) => s.id == item.id);
                                    });
                                    _showToast('Shortcut removed');
                                  },
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
    );
  }

  // -------------------------------------------------------------
  // TAB 3: SMART LINK & TEXT SANITIZER
  // -------------------------------------------------------------
  Widget _buildTextSanitizerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Text & Link Sanitizer',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Text(
            'Clean copied links, strip UTM trackers, reformat messy chats.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Input Box
          TextField(
            controller: _cleanerInputController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Paste link or raw text here...',
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _cleanerInputController.clear();
                  setState(() => _cleanedResult = '');
                },
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Action Chips Matrix
          const Text(
            'Sanitizer Actions:',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              _buildSanitizerActionButton('Strip Tracking URLs', Icons.link_off, () {
                _cleanText('strip_utm');
              }),
              _buildSanitizerActionButton('Clean Extra Spaces', Icons.space_bar, () {
                _cleanText('trim_spaces');
              }),
              _buildSanitizerActionButton('Make Bullet Points', Icons.format_list_bulleted, () {
                _cleanText('bullet_points');
              }),
              _buildSanitizerActionButton('Extract Phone Numbers', Icons.phone, () {
                _cleanText('extract_phones');
              }),
              _buildSanitizerActionButton('UPPERCASE', Icons.text_fields, () {
                _cleanText('uppercase');
              }),
              _buildSanitizerActionButton('lowercase', Icons.text_format, () {
                _cleanText('lowercase');
              }),
            ],
          ),
          const SizedBox(height: 20),

          // Output Card
          if (_cleanedResult.isNotEmpty) ...[
            const Text(
              'Sanitized Output:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    _cleanedResult,
                    style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          _cleanerStatus,
                          style: const TextStyle(fontSize: 11, color: Colors.indigo),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _showToast('Sanitized output copied!');
                        },
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text('Copy Output'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSanitizerActionButton(String label, IconData icon, VoidCallback onTap) {
    return ActionChip(
      avatar: Icon(icon, size: 16, color: Colors.indigo),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.indigo.shade200),
      onPressed: onTap,
    );
  }

  // -------------------------------------------------------------
  // TAB 4: QUICK TOOLS & UTILITY DOCK
  // -------------------------------------------------------------
  Widget _buildQuickToolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Tools Dock',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Text(
            'Micro-utilities accessible inside the overlay companion.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Grid of Micro Tools
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildToolCard(
                title: 'Quick Converter',
                subtitle: 'Currency & Units',
                icon: Icons.calculate,
                color: Colors.teal,
                onTap: () => _showQuickConverterDialog(context),
              ),
              _buildToolCard(
                title: 'Decision Picker',
                subtitle: 'Random Choice',
                icon: Icons.casino,
                color: Colors.deepOrange,
                onTap: () => _showDecisionSpinnerDialog(context),
              ),
              _buildToolCard(
                title: 'Floating Note',
                subtitle: 'Quick Pin Board',
                icon: Icons.push_pin,
                color: Colors.purple,
                onTap: () => _showQuickNoteDialog(context),
              ),
              _buildToolCard(
                title: 'System Stats',
                subtitle: 'Memory & Cache',
                icon: Icons.speed,
                color: Colors.blue,
                onTap: () {
                  _showToast('BubbleMate overlay running smoothly (RAM: 18MB)');
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Overlay Permission Status Box
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.shield, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Overlay Services Health',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'BubbleMate is designed to stay minimal on battery and RAM. Keep overlay permissions enabled to let shortcuts trigger from any app.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 16),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'Background Floating Service Active',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton(
                        onPressed: () => _showToast('Service status optimized.'),
                        child: const Text('Optimize'),
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

  Widget _buildToolCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // DIALOGS & OVERLAY SHEETS
  // -------------------------------------------------------------

  void _openFloatingQuickSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bubble_chart, color: Colors.indigo),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Floating Companion Quick Menu',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8),
                const Text('Instant Copy Vault:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAxisAlignment.center,
                  children: _snippets.map((snip) {
                    return ActionChip(
                      avatar: const Icon(Icons.bolt, size: 14, color: Colors.indigo),
                      label: Text(snip.shortcut, style: const TextStyle(fontSize: 12)),
                      onPressed: () {
                        Navigator.pop(context);
                        _showToast('Copied ${snip.shortcut} (${snip.title})');
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.cleaning_services, color: Colors.indigo),
                  title: const Text('Sanitize Copied Link in Clipboard'),
                  subtitle: const Text('Strips UTM tags instantly'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _currentIndex = 2; // Navigate to Sanitizer
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddSnippetDialog(BuildContext context) {
    final shortcutCtrl = TextEditingController();
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    String cat = 'Finance';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Text Shortcut'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: shortcutCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Shortcut Tag (e.g. !tax or !zoom)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Title / Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contentCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Full Expanded Text',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (shortcutCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                  _addNewSnippet(shortcutCtrl.text, titleCtrl.text, contentCtrl.text, cat);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              child: const Text('Save Shortcut', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showQuickConverterDialog(BuildContext context) {
    final amountCtrl = TextEditingController(text: '100');
    double usdToEur = 0.92;
    double usdToGbp = 0.79;
    double resultEur = 92.0;
    double resultGbp = 79.0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulWidgetBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Quick Currency Converter'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: amountCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'USD Amount (\$)',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        double amt = double.tryParse(val) ?? 0.0;
                        setDialogState(() {
                          resultEur = amt * usdToEur;
                          resultGbp = amt * usdToGbp;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('EUR (€):', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('€${resultEur.toStringAsFixed(2)}'),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('GBP (£):', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('£${resultGbp.toStringAsFixed(2)}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDecisionSpinnerDialog(BuildContext context) {
    final List<String> options = ['Option A', 'Option B'];
    final optionCtrl = TextEditingController();
    String pickedResult = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulWidgetBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Quick Decision Picker'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: optionCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Add Choice',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.indigo),
                          onPressed: () {
                            if (optionCtrl.text.isNotEmpty) {
                              setDialogState(() {
                                options.add(optionCtrl.text);
                                optionCtrl.clear();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAxisAlignment.center,
                      children: options.map((opt) {
                        return Chip(
                          label: Text(opt, style: const TextStyle(fontSize: 11)),
                          onDeleted: () {
                            setDialogState(() {
                              options.remove(opt);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    if (pickedResult.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Selected: $pickedResult',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (options.isNotEmpty) {
                      options.shuffle();
                      setDialogState(() {
                        pickedResult = options.first;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                  child: const Text('Pick Random', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showQuickNoteDialog(BuildContext context) {
    final noteCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Floating Sticky Note'),
          content: TextField(
            controller: noteCtrl,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Type quick temporary memory notes...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                if (noteCtrl.text.isNotEmpty) {
                  _showToast('Sticky note pinned to floating dock!');
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              child: const Text('Pin Note', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BubbleMate Settings',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.flash_on, color: Colors.indigo),
                  title: const Text('Auto-Copy Sanitized Text'),
                  trailing: Switch(value: true, onChanged: (v) {}),
                ),
                ListTile(
                  leading: const Icon(Icons.vibration, color: Colors.indigo),
                  title: const Text('Haptic Feedback on Bubble Tap'),
                  trailing: Switch(value: true, onChanged: (v) {}),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}