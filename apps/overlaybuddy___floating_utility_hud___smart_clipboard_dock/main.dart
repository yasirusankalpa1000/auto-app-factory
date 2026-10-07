import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OverlayBuddyApp());
}

class OverlayBuddyApp extends StatelessWidget {
  const OverlayBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlayBuddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F1A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
          surface: const Color(0xFF181828),
        ),
        cardTheme: const CardTheme(
          color: Color(0xFF1E1E32),
          elevation: 2,
        ),
      ),
      home: const OverlayBuddyHome(),
    );
  }
}

class OverlayBuddyHome extends StatefulWidget {
  const OverlayBuddyHome({super.key});

  @override
  State<OverlayBuddyHome> createState() => _OverlayBuddyHomeState();
}

class _OverlayBuddyHomeState extends State<OverlayBuddyHome>
    with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;

  // Floating Overlay Dock State
  bool _isOverlayEnabled = true;
  Offset _overlayPosition = const Offset(20, 180);
  double _dockOpacity = 0.95;
  Color _dockAccentColor = Colors.tealAccent;

  // Permissions Simulator State
  bool _displayOverAppsPerm = true;
  bool _notificationPerm = true;
  bool _clipboardListenerPerm = true;

  // Smart Clipboard Parser State
  final TextEditingController _clipboardInputController =
      TextEditingController();
  List<String> _extractedPhones = [];
  List<String> _extractedEmails = [];
  List<String> _extractedUrls = [];

  // Shopping Calc Dock State
  double _originalPrice = 100.0;
  double _discountPercent = 15.0;
  double _taxPercent = 8.0;
  int _splitCount = 2;

  // Stash & Decision Wheel State
  final List<Map<String, String>> _stashList = [
    {
      'title': 'Tracking Code',
      'content': 'TRK-984021-SL',
      'category': 'Clipboard'
    },
    {
      'title': 'Delivery Note',
      'content': 'Call upon arrival at main entrance',
      'category': 'Note'
    },
    {
      'title': 'Shopping Item',
      'content': 'Wireless Headphones - Final \$77.28',
      'category': 'Calc'
    },
  ];

  final List<String> _wheelChoices = [
    'Order Food',
    'Take a Walk',
    'Reply Emails',
    'Study 20 Mins',
    'Drink Water',
    'Quick Cleaning'
  ];
  String _wheelResult = 'Tap Spin to Decide!';
  bool _isSpinning = false;

  @override
  void initState() {
    super.initState();
    _clipboardInputController.text =
        'Hey! Check out this item for \$120. Contact support@shop.com or call +1 800 555 0199 for discounts. Details: https://shop.com/deal';
    _parseClipboardText(_clipboardInputController.text);
  }

  @override
  void dispose() {
    _clipboardInputController.dispose();
    super.dispose();
  }

  void _parseClipboardText(String text) {
    final phoneRegex =
        RegExp(r'(\+?\d{1,3}[-.\s]?)?\(?\d{2,4}\)?[-.\s]?\d{3,4}[-.\s]?\d{3,4}');
    final emailRegex =
        RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    final urlRegex = RegExp(r'https?://[^\s]+');

    setState(() {
      _extractedPhones = phoneRegex
          .allMatches(text)
          .map((m) => m.group(0) ?? '')
          .where((s) => s.length >= 7)
          .toList();
      _extractedEmails =
          emailRegex.allMatches(text).map((m) => m.group(0) ?? '').toList();
      _extractedUrls =
          urlRegex.allMatches(text).map((m) => m.group(0) ?? '').toList();
    });
  }

  void _addStashItem(String title, String content, String category) {
    setState(() {
      _stashList.insert(
          0, {'title': title, 'content': content, 'category': category});
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pinned "$title" to Floating Stash!'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _spinWheel() async {
    if (_isSpinning) return;
    setState(() {
      _isSpinning = true;
      _wheelResult = 'Spinning decisions...';
    });
    await Future.delayed(const Duration(milliseconds: 900));
    final random = Random();
    final picked = _wheelChoices[random.nextInt(_wheelChoices.length)];
    setState(() {
      _wheelResult = 'Decision: $picked';
      _isSpinning = false;
    });
  }

  void _showFloatingOverlayModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.widgets, color: Colors.tealAccent),
                          SizedBox(width: 8),
                          Text(
                            'Floating Quick HUD Dock',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white70),
                  const SizedBox(height: 8),
                  const Text(
                    'Quick Actions (Active Overlay)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.tealAccent,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAxisAlignment.center,
                    children: [
                      ActionChip(
                        avatar:
                            const Icon(Icons.content_paste, size: 16),
                        label: const Text('Paste Context'),
                        backgroundColor: const Color(0xFF282845),
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _selectedTabIndex = 1;
                          });
                        },
                      ),
                      ActionChip(
                        avatar:
                            const Icon(Icons.discount_outlined, size: 16),
                        label: const Text('Calc Price'),
                        backgroundColor: const Color(0xFF282845),
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _selectedTabIndex = 2;
                          });
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.casino, size: 16),
                        label: const Text('Decision Wheel'),
                        backgroundColor: const Color(0xFF282845),
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _selectedTabIndex = 3;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Recent Floating Stash',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_stashList.isEmpty)
                    const Text('No stash items saved yet.',
                        style: TextStyle(color: Colors.grey))
                  else
                    Column(
                      children: _stashList.take(3).map((item) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF24243D),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.bookmark,
                                  size: 16, color: Colors.amberAccent),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${item['title']}: ${item['content']}',
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 16),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                      text: item['content'] ?? ''));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Copied to clipboard!'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Main Nav View
          SafeArea(
            child: Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedTabIndex,
                    children: [
                      _buildOverlayConfigTab(),
                      _buildSmartClipboardTab(),
                      _buildCalcDockTab(),
                      _buildStashAndWheelTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Dynamic Floating Overlay Dock Widget (Draggable over screen)
          if (_isOverlayEnabled)
            Positioned(
              left: _overlayPosition.dx,
              top: _overlayPosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    double newX = _overlayPosition.dx + details.delta.dx;
                    double newY = _overlayPosition.dy + details.delta.dy;
                    newX = newX.clamp(10.0, screenSize.width - 70.0);
                    newY = newY.clamp(40.0, screenSize.height - 130.0);
                    _overlayPosition = Offset(newX, newY);
                  });
                },
                onTap: _showFloatingOverlayModal,
                child: Opacity(
                  opacity: _dockOpacity,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E38),
                      shape: BoxShape.circle,
                      border: Border.all(color: _dockAccentColor, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: _dockAccentColor.withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.bolt,
                          color: Colors.white,
                          size: 26,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'HUD',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (idx) {
          setState(() {
            _selectedTabIndex = idx;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF121224),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.layers_outlined),
            activeIcon: Icon(Icons.layers),
            label: 'Overlay HUD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.find_in_page_outlined),
            activeIcon: Icon(Icons.find_in_page),
            label: 'Clipboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
            activeIcon: Icon(Icons.calculate),
            label: 'Shopping Calc',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.casino_outlined),
            activeIcon: Icon(Icons.casino),
            label: 'Wheel & Stash',
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF141428),
        border: Border(
          bottom: BorderSide(color: Color(0xFF282845), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.widgets, color: Colors.tealAccent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'OverlayBuddy HUD',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
                Text(
                  'Contextual Screen Assistant & Quick Tools',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _isOverlayEnabled
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isOverlayEnabled ? Colors.green : Colors.red,
                width: 1,
              ),
            ),
            child: Text(
              _isOverlayEnabled ? 'HUD ACTIVE' : 'OFFLINE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: _isOverlayEnabled ? Colors.greenAccent : Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating Overlay Controls & Permission Simulator
  Widget _buildOverlayConfigTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.touch_app, color: Colors.amberAccent),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Floating Screen Buddy',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                softWrap: true,
                              ),
                              Text(
                                'Drag the floating HUD bubble anywhere on screen for instant micro-tools.',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _isOverlayEnabled,
                          activeColor: Colors.tealAccent,
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
              ),
            ),
            const SizedBox(height: 16),

            // Dock Visual Customization
            const Text(
              'Floating Dock Settings',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Bubble Opacity',
                            style: TextStyle(color: Colors.white70)),
                        Text('${(_dockOpacity * 100).round()}%',
                            style: const TextStyle(
                                color: Colors.tealAccent,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                      value: _dockOpacity,
                      min: 0.3,
                      max: 1.0,
                      activeColor: Colors.tealAccent,
                      onChanged: (v) => setState(() => _dockOpacity = v),
                    ),
                    const Divider(color: Colors.white70),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Glow Accent Color',
                            style: TextStyle(color: Colors.white70)),
                        Wrap(
                          spacing: 8,
                          crossAxisAlignment: WrapCrossAxisAlignment.center,
                          children: [
                            _colorPickerChip(Colors.tealAccent),
                            _colorPickerChip(Colors.purpleAccent),
                            _colorPickerChip(Colors.amberAccent),
                            _colorPickerChip(Colors.blueAccent),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Permission Status Monitor Card
            const Text(
              'System Integration & Permissions',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    _buildPermissionRow(
                      title: 'Display Over Other Apps',
                      subtitle: 'Allows dynamic floating widget overlay',
                      value: _displayOverAppsPerm,
                      onChanged: (v) =>
                          setState(() => _displayOverAppsPerm = v),
                    ),
                    const Divider(color: Colors.white70),
                    _buildPermissionRow(
                      title: 'Notification Access',
                      subtitle: 'For persistent quick utility bar notifications',
                      value: _notificationPerm,
                      onChanged: (v) => setState(() => _notificationPerm = v),
                    ),
                    const Divider(color: Colors.white70),
                    _buildPermissionRow(
                      title: 'Auto Clipboard Monitor',
                      subtitle: 'Extracts numbers & links upon standard copy',
                      value: _clipboardListenerPerm,
                      onChanged: (v) =>
                          setState(() => _clipboardListenerPerm = v),
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

  Widget _colorPickerChip(Color color) {
    final bool isSelected = _dockAccentColor == color;
    return GestureDetector(
      onTap: () => setState(() => _dockAccentColor = color),
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2.5,
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.white),
                  softWrap: true,
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                  softWrap: true,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: Colors.tealAccent,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // TAB 2: Smart Contextual Clipboard & Regex Text Parser
  Widget _buildSmartClipboardTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Smart Clipboard Parser',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final data = await Clipboard.getData(Clipboard.kTextPlain);
                    if (data?.text != null) {
                      _clipboardInputController.text = data!.text!;
                      _parseClipboardText(data.text!);
                    }
                  },
                  icon: const Icon(Icons.paste, size: 16),
                  label: const Text('Paste'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Input Text Box
            TextField(
              controller: _clipboardInputController,
              maxLines: 4,
              style: const TextStyle(fontSize: 13, color: Colors.white),
              onChanged: _parseClipboardText,
              decoration: const InputDecoration(
                hintText: 'Paste message, email snippet, or unstructured text...',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Color(0xFF1B1B30),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Color(0xFF2E2E50)),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Quick Text Clean Actions Bar
            const Text(
              '1-Tap Text Transformers',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAxisAlignment.center,
              children: [
                ActionChip(
                  label: const Text('Remove Extra Spaces'),
                  onPressed: () {
                    final cleaned = _clipboardInputController.text
                        .replaceAll(RegExp(r'\s+'), ' ')
                        .trim();
                    _clipboardInputController.text = cleaned;
                    _parseClipboardText(cleaned);
                  },
                ),
                ActionChip(
                  label: const Text('UPPERCASE'),
                  onPressed: () {
                    final cleaned = _clipboardInputController.text.toUpperCase();
                    _clipboardInputController.text = cleaned;
                  },
                ),
                ActionChip(
                  label: const Text('Strip Linebreaks'),
                  onPressed: () {
                    final cleaned = _clipboardInputController.text
                        .replaceAll(RegExp(r'[\r\n]+'), ' ');
                    _clipboardInputController.text = cleaned;
                    _parseClipboardText(cleaned);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Parsed Context Extractor Results
            const Text(
              'Auto-Extracted Data Context',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Extracted Phone Numbers Card
            _buildExtractedCategoryCard(
              title: 'Phone Numbers',
              icon: Icons.phone_android,
              items: _extractedPhones,
              emptyMsg: 'No phone numbers detected in text.',
              accentColor: Colors.blueAccent,
            ),
            const SizedBox(height: 10),

            // Extracted Emails Card
            _buildExtractedCategoryCard(
              title: 'Email Addresses',
              icon: Icons.email_outlined,
              items: _extractedEmails,
              emptyMsg: 'No emails detected in text.',
              accentColor: Colors.purpleAccent,
            ),
            const SizedBox(height: 10),

            // Extracted URLs Card
            _buildExtractedCategoryCard(
              title: 'Web Links & URLs',
              icon: Icons.link,
              items: _extractedUrls,
              emptyMsg: 'No URLs detected in text.',
              accentColor: Colors.tealAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtractedCategoryCard({
    required String title,
    required IconData icon,
    required List<String> items,
    required String emptyMsg,
    required Color accentColor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: accentColor),
                const SizedBox(width: 8),
                Text(
                  '$title (${items.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              Text(emptyMsg,
                  style: const TextStyle(fontSize: 12, color: Colors.grey))
            else
              Column(
                children: items.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141424),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy,
                              size: 16, color: Colors.grey),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: item));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Copied "$item"'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.push_pin_outlined,
                              size: 16, color: Colors.tealAccent),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          onPressed: () => _addStashItem(title, item, 'Parsed'),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  // TAB 3: Dynamic Shopping & Discount Calc Dock
  Widget _buildCalcDockTab() {
    final discountAmount = _originalPrice * (_discountPercent / 100.0);
    final priceAfterDiscount = _originalPrice - discountAmount;
    final taxAmount = priceAfterDiscount * (_taxPercent / 100.0);
    final finalPrice = priceAfterDiscount + taxAmount;
    final pricePerPerson = finalPrice / max(1, _splitCount);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shopping Price Dock',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Instant floating micro-calc for sales, tax & bill sharing.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Price Entry Input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Original Tag Price',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.tealAccent),
                      decoration: InputDecoration(
                        prefixText: '\$ ',
                        prefixStyle: const TextStyle(
                            color: Colors.tealAccent, fontSize: 18),
                        filled: true,
                        fillColor: const Color(0xFF141426),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _originalPrice = double.tryParse(val) ?? 0.0;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Sliders Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Discount Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Discount Percentage',
                            style: TextStyle(color: Colors.white70)),
                        Text('${_discountPercent.round()}% OFF',
                            style: const TextStyle(
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                      value: _discountPercent,
                      min: 0,
                      max: 90,
                      divisions: 18,
                      activeColor: Colors.amberAccent,
                      onChanged: (v) => setState(() => _discountPercent = v),
                    ),
                    const Divider(color: Colors.white70),

                    // Tax Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Sales Tax / Service Charge',
                            style: TextStyle(color: Colors.white70)),
                        Text('${_taxPercent.round()}% Tax',
                            style: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                      value: _taxPercent,
                      min: 0,
                      max: 30,
                      divisions: 30,
                      activeColor: Colors.blueAccent,
                      onChanged: (v) => setState(() => _taxPercent = v),
                    ),
                    const Divider(color: Colors.white70),

                    // Split Bill Counter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Split Between People',
                            style: TextStyle(color: Colors.white70)),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: Colors.grey),
                              onPressed: () {
                                if (_splitCount > 1) {
                                  setState(() => _splitCount--);
                                }
                              },
                            ),
                            Text('$_splitCount',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline,
                                  color: Colors.tealAccent),
                              onPressed: () {
                                setState(() => _splitCount++);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Calculated Output Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E283C),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Saved Amount:',
                          style: TextStyle(color: Colors.grey)),
                      Text('-\$${discountAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tax Added:',
                          style: TextStyle(color: Colors.grey)),
                      Text('+\$${taxAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(color: Colors.white70, height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Final Price:',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      Text('\$${finalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.tealAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                    ],
                  ),
                  if (_splitCount > 1) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Per Person ($_splitCount people):',
                            style: const TextStyle(
                                color: Colors.amberAccent, fontSize: 13)),
                        Text('\$${pricePerPerson.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _addStashItem(
                          'Shopping Item',
                          'Final: \$${finalPrice.toStringAsFixed(2)} (${_discountPercent.round()}% OFF)',
                          'Calc',
                        );
                      },
                      icon: const Icon(Icons.bookmark_add),
                      label: const Text('Pin Result to Floating Stash'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
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

  // TAB 4: Decision Wheel & Floating Stash Manager
  Widget _buildStashAndWheelTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Micro Decision Spinner Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.casino, color: Colors.amberAccent),
                        SizedBox(width: 8),
                        Text(
                          'Daily Micro-Decision Wheel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Stuck on what to do, eat, or pick next? Let the decision wheel pick instantly!',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      softWrap: true,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141426),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amberAccent.withOpacity(0.4)),
                      ),
                      child: Center(
                        child: Text(
                          _wheelResult,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _isSpinning
                                ? Colors.grey
                                : Colors.amberAccent,
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _isSpinning ? null : _spinWheel,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Spin Random Picker'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Saved Stash List Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Saved Floating Stash',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (_stashList.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _stashList.clear();
                      });
                    },
                    child: const Text('Clear All',
                        style: TextStyle(color: Colors.redAccent)),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            if (_stashList.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Column(
                      children: const [
                        Icon(Icons.bookmark_outline,
                            size: 32, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'Your stash is empty.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'Pin parsed links, notes, or prices for floating overlay access!',
                          style: TextStyle(fontSize: 11, color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _stashList.length,
                itemBuilder: (ctx, index) {
                  final item = _stashList[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.withOpacity(0.2),
                        child: Icon(
                          item['category'] == 'Calc'
                              ? Icons.calculate
                              : item['category'] == 'Parsed'
                                  ? Icons.find_in_page
                                  : Icons.note_alt,
                          color: Colors.tealAccent,
                          size: 18,
                        ),
                      ),
                      title: Text(
                        item['title'] ?? 'Item',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                      subtitle: Text(
                        item['content'] ?? '',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.copy,
                                size: 18, color: Colors.grey),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                  text: item['content'] ?? ''));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Copied item text!'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                size: 18, color: Colors.redAccent),
                            onPressed: () {
                              setState(() {
                                _stashList.removeAt(index);
                              });
                            },
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
}