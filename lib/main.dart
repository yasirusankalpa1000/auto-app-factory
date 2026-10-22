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
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0E17),
      ),
      home: const MainDeckScreen(),
    );
  }
}

class ClipItem {
  final String id;
  String text;
  String category;
  bool isPinned;
  DateTime timestamp;

  ClipItem({
    required this.id,
    required this.text,
    required this.category,
    this.isPinned = false,
    required this.timestamp,
  });
}

class FloatingWidgetConfig {
  String name;
  IconData icon;
  Color color;
  bool enabled;
  double opacity;

  FloatingWidgetConfig({
    required this.name,
    required this.icon,
    required this.color,
    this.enabled = true,
    this.opacity = 0.9,
  });
}

class MainDeckScreen extends StatefulWidget {
  const MainDeckScreen({super.key});

  @override
  State<MainDeckScreen> createState() => _MainDeckScreenState();
}

class _MainDeckScreenState extends State<MainDeckScreen> {
  int _selectedIndex = 0;
  bool _isOverlayEnabled = true;
  bool _showFloatingNotification = true;
  double _overlayOpacity = 0.85;
  String _selectedCategory = 'All';

  // Simulated Floating Bubble Positions
  Offset _bubble1Offset = const Offset(30, 150);
  Offset _bubble2Offset = const Offset(260, 220);
  Offset _bubble3Offset = const Offset(150, 380);

  // Active Floating Clips Data
  final List<ClipItem> _clips = [
    ClipItem(
      id: '1',
      text: 'Meeting Code: 849-201-992 (Passcode: 4421)',
      category: 'Work',
      isPinned: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
    ),
    ClipItem(
      id: '2',
      text: 'Discount Code: SAVE20NOW for order total > \$25.00',
      category: 'Shopping',
      isPinned: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ClipItem(
      id: '3',
      text: 'Grocery list: Almond milk, Organic Oats, Dark Chocolate, Avocados',
      category: 'Personal',
      isPinned: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    ClipItem(
      id: '4',
      text: 'https://developer.flutter.dev/docs/components/floating-action',
      category: 'Links',
      isPinned: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  // Floating Widgets Configuration
  final List<FloatingWidgetConfig> _widgets = [
    FloatingWidgetConfig(
      name: 'Smart Clipboard',
      icon: Icons.assignment_outlined,
      color: Colors.blue,
      enabled: true,
    ),
    FloatingWidgetConfig(
      name: 'Floating Sticky Note',
      icon: Icons.note_alt_outlined,
      color: Colors.amber,
      enabled: true,
    ),
    FloatingWidgetConfig(
      name: 'Quick Text Cleaner',
      icon: Icons.auto_fix_high,
      color: Colors.teal,
      enabled: true,
    ),
    FloatingWidgetConfig(
      name: 'Live Screen Snippet',
      icon: Icons.crop_free,
      color: Colors.purple,
      enabled: false,
    ),
  ];

  final TextEditingController _clipInputController = TextEditingController();

  void _addClip(String text, String category) {
    if (text.trim().isEmpty) return;
    setState(() {
      _clips.insert(
        0,
        ClipItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          category: category,
          isPinned: true,
          timestamp: DateTime.now(),
        ),
      );
    });
    _clipInputController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pinned to Floating Deck Dock!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _togglePin(String id) {
    setState(() {
      final item = _clips.firstWhere((c) => c.id == id);
      item.isPinned = !item.isPinned;
    });
  }

  void _deleteClip(String id) {
    setState(() {
      _clips.removeWhere((c) => c.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Persistent Status & Notification Bar Simulation
            _buildFloatingOverlayHeader(),

            // Body Screen Content
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  _buildOverlayPlaygroundTab(),
                  _buildClipVaultTab(),
                  _buildWidgetStudioTab(),
                  _buildSmartToolsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: const Color(0xFF161524),
        indicatorColor: Colors.deepPurple,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.touch_app_outlined),
            selectedIcon: Icon(Icons.touch_app, color: Colors.white),
            label: 'Floating Dock',
          ),
          NavigationDestination(
            icon: Icon(Icons.layers_outlined),
            selectedIcon: Icon(Icons.layers, color: Colors.white),
            label: 'Clip Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.widgets_outlined),
            selectedIcon: Icon(Icons.widgets, color: Colors.white),
            label: 'Widget Studio',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune),
            selectedIcon: Icon(Icons.tune, color: Colors.white),
            label: 'Tools & Overlay',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingOverlayHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1A2C),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.layers_rounded,
                  color: Colors.deepPurpleAccent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'FloatDeck Service',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _isOverlayEnabled
                                ? Colors.green.withOpacity(0.2)
                                : Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _isOverlayEnabled ? 'ACTIVE OVERLAY' : 'PAUSED',
                            style: TextStyle(
                              color: _isOverlayEnabled
                                  ? Colors.greenAccent
                                  : Colors.grey,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Display over other apps permission granted',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
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
          if (_showFloatingNotification && _isOverlayEnabled) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.deepPurpleAccent.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.notifications_active,
                    size: 16,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Floating Banner: 2 active text pins ready on screen edge',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showFloatingNotification = false;
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  // TAB 1: Floating Overlay Playground
  Widget _buildOverlayPlaygroundTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Screen Overlay Playground',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Drag floating bubbles around your virtual screen context',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  avatar: const Icon(Icons.touch_app, size: 14),
                  label: const Text('Live Test', style: TextStyle(fontSize: 11)),
                  backgroundColor: Colors.deepPurple.withOpacity(0.2),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Virtual Phone Screen Viewport with Draggable Overlay Bubbles
            Container(
              height: 380,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1D2A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isOverlayEnabled
                      ? Colors.deepPurpleAccent.withOpacity(0.5)
                      : Colors.white70,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Simulated Apps Background Pattern
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.15,
                      child: GridView.count(
                        crossAxisCount: 4,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: List.generate(
                          12,
                          (index) => Container(
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              index % 3 == 0
                                  ? Icons.chat_bubble
                                  : index % 3 == 1
                                      ? Icons.shopping_bag
                                      : Icons.public,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (!_isOverlayEnabled)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Floating Overlay Switch Disabled',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),

                  // Draggable Floating Overlay Widget 1 - Clipboard Quick Pin
                  if (_isOverlayEnabled)
                    Positioned(
                      left: _bubble1Offset.dx,
                      top: _bubble1Offset.dy,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            _bubble1Offset += details.delta;
                          });
                        },
                        child: Opacity(
                          opacity: _overlayOpacity,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade800,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black87,
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.assignment_outlined,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 130),
                                  child: Text(
                                    _clips.isNotEmpty
                                        ? _clips.first.text
                                        : 'No Clip Pinned',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Draggable Floating Overlay Widget 2 - Sticky Note Bubble
                  if (_isOverlayEnabled)
                    Positioned(
                      left: _bubble2Offset.dx,
                      top: _bubble2Offset.dy,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            _bubble2Offset += details.delta;
                          });
                        },
                        child: Opacity(
                          opacity: _overlayOpacity,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.amber.shade700,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.8),
                                width: 2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black87,
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.note_alt,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                Text(
                                  'Note',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Draggable Floating Overlay Widget 3 - Smart Action Hub Bar
                  if (_isOverlayEnabled)
                    Positioned(
                      left: _bubble3Offset.dx,
                      top: _bubble3Offset.dy,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            _bubble3Offset += details.delta;
                          });
                        },
                        child: Opacity(
                          opacity: _overlayOpacity,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF28263D),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.teal.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.teal.shade700,
                                  child: const Icon(
                                    Icons.auto_fix_high,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Float Hub',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.open_in_full,
                                  size: 12,
                                  color: Colors.white70,
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
            const SizedBox(height: 16),

            // Dynamic Dock Quick Controls
            const Text(
              'Quick Floating Dock Actions',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildActionButton(
                  icon: Icons.refresh,
                  label: 'Reset Floating Positions',
                  color: Colors.blue,
                  onTap: () {
                    setState(() {
                      _bubble1Offset = const Offset(30, 150);
                      _bubble2Offset = const Offset(260, 220);
                      _bubble3Offset = const Offset(150, 380);
                    });
                  },
                ),
                _buildActionButton(
                  icon: Icons.opacity,
                  label: 'Toggle Dock Opacity',
                  color: Colors.purple,
                  onTap: () {
                    setState(() {
                      _overlayOpacity = _overlayOpacity <= 0.5 ? 0.95 : 0.45;
                    });
                  },
                ),
                _buildActionButton(
                  icon: Icons.notification_add,
                  label: 'Trigger Banner Mock',
                  color: Colors.teal,
                  onTap: () {
                    setState(() {
                      _showFloatingNotification = true;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: Clip & Context Vault
  Widget _buildClipVaultTab() {
    final categories = ['All', 'Work', 'Shopping', 'Personal', 'Links'];
    final filteredClips = _selectedCategory == 'All'
        ? _clips
        : _clips.where((c) => c.category == _selectedCategory).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Floating Clip & Context Vault',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Items saved here appear instantly on your screen overlay dock',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 14),

            // Quick Add Clip Input Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1D2A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _clipInputController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText:
                          'Type or paste text/link to float over apps...',
                      hintStyle: TextStyle(color: Colors.white70, fontSize: 12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        spacing: 6,
                        children: ['Work', 'Shopping', 'Personal'].map((cat) {
                          return InkWell(
                            onTap: () {
                              _addClip(_clipInputController.text, cat);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: Colors.deepPurple.withOpacity(0.4)),
                              ),
                              child: Text(
                                '+ $cat',
                                style: const TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _addClip(_clipInputController.text, 'Personal');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        icon: const Icon(Icons.pin_drop,
                            size: 14, color: Colors.white),
                        label: const Text('Pin Clip',
                            style:
                                TextStyle(fontSize: 11, color: Colors.white)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Category Selector Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((cat) {
                  final isSel = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat, style: const TextStyle(fontSize: 11)),
                      selected: isSel,
                      selectedColor: Colors.deepPurple,
                      backgroundColor: const Color(0xFF1E1D2A),
                      labelStyle: TextStyle(
                        color: isSel ? Colors.white : Colors.white70,
                      ),
                      onSelected: (val) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // List of Clips
            if (filteredClips.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    'No clips found in this category.',
                    style: TextStyle(color: Colors.white.withOpacity(0.4)),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredClips.length,
                itemBuilder: (context, index) {
                  final clip = filteredClips[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B1A2C),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: clip.isPinned
                            ? Colors.deepPurpleAccent.withOpacity(0.4)
                            : Colors.white70,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                clip.category,
                                style: const TextStyle(
                                  color: Colors.tealAccent,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                clip.isPinned
                                    ? Icons.push_pin
                                    : Icons.push_pin_outlined,
                                size: 16,
                                color: clip.isPinned
                                    ? Colors.amber
                                    : Colors.white70,
                              ),
                              onPressed: () => _togglePin(clip.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  size: 16, color: Colors.white70),
                              onPressed: () => _deleteClip(clip.id),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          clip.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            height: 1.3,
                          ),
                          softWrap: true,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Added ${clip.timestamp.minute}m ago',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 10,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Copied clip to system memory!'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.copy,
                                      size: 12, color: Colors.deepPurpleAccent),
                                  SizedBox(width: 4),
                                  Text(
                                    'Copy',
                                    style: TextStyle(
                                      color: Colors.deepPurpleAccent,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
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
      ),
    );
  }

  // TAB 3: Widget Studio
  Widget _buildWidgetStudioTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Floating Widget Studio',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Customize mini tools floating on your device screen',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),

            // Active Floating Modules List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _widgets.length,
              itemBuilder: (context, index) {
                final w = _widgets[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1A2C),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: w.enabled
                          ? w.color.withOpacity(0.5)
                          : Colors.white70,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: w.color.withOpacity(0.2),
                            child: Icon(w.icon, color: w.color, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  w.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  w.enabled
                                      ? 'Active floating widget'
                                      : 'Disabled',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: w.enabled,
                            activeColor: w.color,
                            onChanged: (val) {
                              setState(() {
                                w.enabled = val;
                              });
                            },
                          ),
                        ],
                      ),
                      if (w.enabled) ...[
                        const Divider(color: Colors.white70, height: 20),
                        Row(
                          children: [
                            const Text(
                              'Transparency:',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.white70),
                            ),
                            Expanded(
                              child: Slider(
                                value: w.opacity,
                                min: 0.3,
                                max: 1.0,
                                activeColor: w.color,
                                onChanged: (val) {
                                  setState(() {
                                    w.opacity = val;
                                  });
                                },
                              ),
                            ),
                            Text(
                              '${(w.opacity * 100).round()}%',
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.deepPurpleAccent.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Unlock Floating Mini Translator',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Select text on screen and auto-translate in a floating bubble',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Floating Module Unlocked!'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                    ),
                    child: const Text('Unlock',
                        style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 4: Smart Tools & Floating Overlay Config
  Widget _buildSmartToolsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Smart Screen Micro-Tools',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Instant tools optimized for floating overlay action',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),

            // Quick Text Cleaner Engine
            _buildToolCard(
              title: 'Dynamic Text Formatter & Cleaner',
              description:
                  'Removes line breaks, extra spaces, and special symbols from copied texts instantly.',
              icon: Icons.auto_fix_high,
              color: Colors.teal,
              buttonLabel: 'Format Clipboard Text',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Clipboard text auto-formatted and cleaned!'),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // Quick Screen Price Tag Converter Simulator
            _buildToolCard(
              title: 'On-Screen Price & Tax Converter',
              description:
                  'Extract numbers from floating text and auto-apply local tax or discount calculation.',
              icon: Icons.monetization_on,
              color: Colors.green,
              buttonLabel: 'Calculate \$ Pricing',
              onPressed: () {
                _showPriceConverterDialog(context);
              },
            ),
            const SizedBox(height: 12),

            // Floating Overlay Permission Settings Guide
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1A2C),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.security, size: 18, color: Colors.deepPurpleAccent),
                      SizedBox(width: 8),
                      Text(
                        'Overlay System Diagnostics',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildDiagnosticRow('Display over other apps', true),
                  _buildDiagnosticRow('Background auto-start', true),
                  _buildDiagnosticRow('Floating banner notifications', true),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('System overlay permissions re-verified!'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white70,
                      minimumSize: const Size(double.infinity, 36),
                    ),
                    child: const Text(
                      'Re-check Floating Overlay Permissions',
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

  Widget _buildDiagnosticRow(String label, bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
          ),
          Row(
            children: [
              Icon(
                active ? Icons.check_circle : Icons.cancel,
                size: 14,
                color: active ? Colors.greenAccent : Colors.redAccent,
              ),
              const SizedBox(width: 4),
              Text(
                active ? 'Granted' : 'Missing',
                style: TextStyle(
                  color: active ? Colors.greenAccent : Colors.redAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String buttonLabel,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1A2C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 11,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color.withOpacity(0.2),
              side: BorderSide(color: color.withOpacity(0.5)),
            ),
            child: Text(
              buttonLabel,
              style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showPriceConverterDialog(BuildContext context) {
    final controller = TextEditingController(text: '49.99');
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1D2A),
          title: const Text('Floating Price Calculator', style: TextStyle(color: Colors.white, fontSize: 15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Amount (\$) ',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              const Text('With +10% Local Sales Tax: \$54.98', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 13)),
              const Text('With -20% Discount Code: \$39.99', style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Done', style: TextStyle(color: Colors.deepPurpleAccent)),
            )
          ],
        );
      },
    );
  }
}