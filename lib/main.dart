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

class MainDeckScreen extends StatefulWidget {
  const MainDeckScreen({super.key});

  @override
  State<MainDeckScreen> createState() => _MainDeckScreenState();
}

class _MainDeckScreenState extends State<MainDeckScreen> {
  int _selectedTabIndex = 0;
  bool _overlayServiceEnabled = true;
  bool _floatingHeadsNotificationEnabled = true;

  // Position of draggable floating HUD bubble
  Offset _bubblePosition = const Offset(20, 200);
  bool _isOverlayExpanded = false;

  // Multi-Clipboard Vault items
  final List<String> _clipboard Vault = [
    'https://flutter.dev - Multi-platform framework',
    'Meeting Notes: Finalize product launch budget at \$2,500.',
    'Customer Support Contact: support@floatdeck.app',
    '#Tech #Productivity #Flutter #ViralApp',
  ];

  // Quick Sticky Notes
  final List<String> _stickyNotes = [
    'Buy milk & fresh coffee beans on the way home.',
    'Check display over apps permission status.',
  ];

  // Text Transformer Input
  final TextEditingController _textTransformController = TextEditingController();
  String _transformedResult = '';

  // Sticky Note Controller
  final TextEditingController _noteInputController = TextEditingController();

  void _addClipboardItem(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _clipboardVault.insert(0, text.trim());
    });
  }

  void _addStickyNote(String note) {
    if (note.trim().isEmpty) return;
    setState(() {
      _stickyNotes.insert(0, note.trim());
      _noteInputController.clear();
    });
  }

  void _transformText(String action) {
    final raw = _textTransformController.text;
    if (raw.isEmpty) return;

    setState(() {
      switch (action) {
        case 'HASHTAG':
          _transformedResult = raw
              .split(' ')
              .where((word) => word.isNotEmpty)
              .map((word) => '#${word.replaceAll(RegExp(r'[^\w]'), '')}')
              .join(' ');
          break;
        case 'UPPER':
          _transformedResult = raw.toUpperCase();
          break;
        case 'LOWER':
          _transformedResult = raw.toLowerCase();
          break;
        case 'SLUG':
          _transformedResult = raw
              .trim()
              .toLowerCase()
              .replaceAll(RegExp(r'[^\w\s]'), '')
              .replaceAll(RegExp(r'\s+'), '-');
          break;
        case 'CLEAN':
          _transformedResult = raw.replaceAll(RegExp(r'\s+'), ' ').trim();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Dashboard View
            Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedTabIndex,
                    children: [
                      _buildHUDCanvasTab(screenSize),
                      _buildClipboardVaultTab(),
                      _buildTextTransformerTab(),
                      _buildOverlayConfigTab(),
                    ],
                  ),
                ),
              ],
            ),

            // Interactive Floating HUD Bubble Simulation
            if (_overlayServiceEnabled)
              Positioned(
                left: _bubblePosition.dx.clamp(10, screenSize.width - 70),
                top: _bubblePosition.dy.clamp(10, screenSize.height - 150),
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
                    width: _isOverlayExpanded ? 280 : 58,
                    height: _isOverlayExpanded ? 260 : 58,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF242238),
                      borderRadius: BorderRadius.circular(_isOverlayExpanded ? 20 : 30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withAlpha(100),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                      border: Border.all(color: Colors.deepPurpleAccent, width: 1.5),
                    ),
                    child: _isOverlayExpanded
                        ? _buildExpandedFloatingPanel()
                        : const Center(
                            child: Icon(
                              Icons.widgets,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTabIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _selectedTabIndex = idx;
          });
        },
        backgroundColor: const Color(0xFF161524),
        indicatorColor: Colors.deepPurple,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Colors.white),
            label: 'Floating HUD',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_copy_outlined),
            selectedIcon: Icon(Icons.content_copy, color: Colors.white),
            label: 'Multi-Clip',
          ),
          NavigationDestination(
            icon: Icon(Icons.transform),
            selectedIcon: Icon(Icons.transform, color: Colors.white),
            label: 'Smart Text',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune),
            selectedIcon: Icon(Icons.tune, color: Colors.white),
            label: 'Overlay Deck',
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF161524),
        border: Border(
          bottom: BorderSide(color: Colors.white70, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withAlpha(50),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.layers, color: Colors.deepPurpleAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'FloatDeck Dynamic HUD',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _overlayServiceEnabled
                      ? 'Overlay Active • Drag bubble anywhere'
                      : 'Overlay Service Paused',
                  style: TextStyle(
                    fontSize: 12,
                    color: _overlayServiceEnabled ? Colors.greenAccent : Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Switch(
            value: _overlayServiceEnabled,
            activeColor: Colors.deepPurpleAccent,
            onChanged: (val) {
              setState(() {
                _overlayServiceEnabled = val;
              });
            },
          ),
        ],
      ),
    );
  }

  // --- TAB 1: Floating HUD Interactive Simulator ---
  Widget _buildHUDCanvasTab(Size screenSize) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.touch_app, color: Colors.amberAccent),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Interactive Overlay Simulator',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'FloatDeck stays active over other apps so you never lose your context. Drag the purple floating bubble on screen or tap it to reveal dynamic quick tools!',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.check_circle, size: 16, color: Colors.greenAccent),
                      label: const Text('Display Above Apps: Granted'),
                      backgroundColor: Colors.white70,
                      side: BorderSide.none,
                    ),
                    Chip(
                      avatar: const Icon(Icons.notifications_active, size: 16, color: Colors.amberAccent),
                      label: Text(_floatingHeadsNotificationEnabled ? 'Heads Notification: ON' : 'Heads Notification: OFF'),
                      backgroundColor: Colors.white70,
                      side: BorderSide.none,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quick Floating Sticky Notes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.deepPurpleAccent),
                onPressed: () => _showAddNoteDialog(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_stickyNotes.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('No sticky notes saved.', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _stickyNotes.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color(0xFF1F1D36),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.sticky_note_2, color: Colors.amberAccent),
                    title: Text(
                      _stickyNotes[index],
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                      onPressed: () {
                        setState(() {
                          _stickyNotes.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // --- TAB 2: Multi-Clipboard Vault ---
  Widget _buildClipboardVaultTab() {
    final TextEditingController newClipController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Multi-Clipboard Vault',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Store multiple links, address blocks, and text snippets to paste anytime from your floating bubble.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: newClipController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Enter new snippet to save...',
                          hintStyle: TextStyle(color: Colors.grey),
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      onPressed: () {
                        _addClipboardItem(newClipController.text);
                        newClipController.clear();
                      },
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Saved Snippets',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _clipboardVault.length,
            itemBuilder: (context, index) {
              final item = _clipboardVault[index];
              return Card(
                color: const Color(0xFF1F1D36),
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.copy, size: 16, color: Colors.tealAccent),
                            label: const Text('Copy Quick', style: TextStyle(color: Colors.tealAccent, fontSize: 12)),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Copied: "$item"'),
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: Colors.teal,
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 18),
                            onPressed: () {
                              setState(() {
                                _clipboardVault.removeAt(index);
                              });
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

  // --- TAB 3: Smart Text Transformer ---
  Widget _buildTextTransformerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Smart Text & Social Hashtag Transformer',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Instantly format raw sentences into hashtags, clean slugs, or capitalized text without leaving your active app.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _textTransformController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Type or paste raw text here...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _transformText('HASHTAG'),
                      icon: const Icon(Icons.tag, size: 16),
                      label: const Text('Hashtags'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _transformText('SLUG'),
                      icon: const Icon(Icons.link, size: 16),
                      label: const Text('URL Slug'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _transformText('UPPER'),
                      icon: const Icon(Icons.text_fields, size: 16),
                      label: const Text('UPPERCASE'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _transformText('CLEAN'),
                      icon: const Icon(Icons.cleaning_services, size: 16),
                      label: const Text('Clean Spaces'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_transformedResult.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Transformed Result',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.white70),
                        onPressed: () {
                          _addClipboardItem(_transformedResult);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Saved result to Multi-Clipboard Vault!'),
                              backgroundColor: Colors.deepPurple,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SelectableText(
                    _transformedResult,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --- TAB 4: Overlay & Service Settings ---
  Widget _buildOverlayConfigTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overlay Dock Configurations',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Display Above Other Apps', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Allows floating HUD bubble over standard apps', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  value: _overlayServiceEnabled,
                  activeColor: Colors.deepPurpleAccent,
                  onChanged: (val) {
                    setState(() {
                      _overlayServiceEnabled = val;
                    });
                  },
                ),
                const Divider(color: Colors.white70),
                SwitchListTile(
                  title: const Text('Floating Heads Notification', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Keep instant tray control in status bar', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  value: _floatingHeadsNotificationEnabled,
                  activeColor: Colors.deepPurpleAccent,
                  onChanged: (val) {
                    setState(() {
                      _floatingHeadsNotificationEnabled = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Why Keep FloatDeck Running?',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.amberAccent),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.flash_on, color: Colors.amberAccent, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Instant copy-paste snippets during chats without losing typing cursor.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.security, color: Colors.greenAccent, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Zero cloud data uploads - everything stays 100% private on your phone memory.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Draggable Dynamic Overlay Card Content ---
  Widget _buildExpandedFloatingPanel() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.bubble_chart, color: Colors.deepPurpleAccent, size: 18),
                SizedBox(width: 6),
                Text(
                  'FloatDeck Dock',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isOverlayExpanded = false;
                });
              },
              child: const Icon(Icons.close, color: Colors.grey, size: 18),
            ),
          ],
        ),
        const Divider(color: Colors.white70, height: 12),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Vault Quick Access:',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 4),
                if (_clipboardVault.isEmpty)
                  const Text('No clip saved.', style: TextStyle(color: Colors.white70, fontSize: 11))
                else
                  ..._clipboardVault.take(3).map(
                        (clip) => Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  clip,
                                  style: const TextStyle(color: Colors.white, fontSize: 11),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Quick copied: $clip'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                                child: const Icon(Icons.copy, color: Colors.tealAccent, size: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161524),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withAlpha(15)),
      ),
      child: child,
    );
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F1D36),
        title: const Text('New Floating Sticky Note', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _noteInputController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Type note content...',
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
            onPressed: () {
              _addStickyNote(_noteInputController.text);
              Navigator.pop(ctx);
            },
            child: const Text('Add Note', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}