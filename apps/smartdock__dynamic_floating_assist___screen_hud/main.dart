import 'package:flutter/material.dart';

void main() {
  runApp(const SmartDockApp());
}

class SmartDockApp extends StatelessWidget {
  const SmartDockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartDock Assist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Global Floating Overlay States
  bool _isServiceActive = true;
  bool _showFloatingDock = true;
  bool _showPrivacyShield = true;
  bool _showQuickNote = false;
  bool _showClipboardBar = true;
  bool _enableScreenTint = false;
  double _tintOpacity = 0.35;
  Color _dockAccentColor = Colors.teal;

  // Draggable HUD Positions
  Offset _dockPosition = const Offset(20, 180);
  Offset _privacyShieldPosition = const Offset(20, 320);
  Offset _quickNotePosition = const Offset(40, 100);

  // Clipboard Data
  final List<String> _clipboardHistory = [
    "https://flutter.dev - Official Flutter Docs",
    "Meeting code: 849-201-492",
    "Special discount promo code: SAVE20NOW",
    "Send quick invoice report to team by 5 PM"
  ];

  // Quick Note Text
  String _stickyNoteText = "Remember to check floating screen options!";

  // Dynamic Theme Colors List
  final List<Color> _themeColors = [
    Colors.teal,
    Colors.indigo,
    Colors.purple,
    Colors.amber,
    Colors.deepOrange,
    Colors.cyan,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildLiveHUDSandbox(),
      _buildSmartClipboardTab(),
      _buildPrivacyAndTintTab(),
      _buildDockStudioTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _dockAccentColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.widgets, color: _dockAccentColor, size: 22),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'SmartDock Assist',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                Text(
                  _isServiceActive ? 'ACTIVE' : 'OFF',
                  style: TextStyle(
                    color: _isServiceActive ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Switch(
                  value: _isServiceActive,
                  activeColor: _dockAccentColor,
                  onChanged: (val) {
                    setState(() {
                      _isServiceActive = val;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: _dockAccentColor,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Live HUD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: 'Clipboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            label: 'Privacy Zone',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Dock Studio',
          ),
        ],
      ),
    );
  }

  // TAB 1: LIVE FLOATING HUD SANDBOX
  Widget _buildLiveHUDSandbox() {
    return SafeArea(
      child: Stack(
        children: [
          // Background Sandbox Info
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBannerCard(
                  title: "Interactive Screen Overlay HUD",
                  description:
                      "Drag floating bubbles around your screen. Toggle screen shields, sticky notes, and quick clipboard feeds that stay above apps.",
                  icon: Icons.touch_app,
                  color: Colors.teal,
                ),
                const SizedBox(height: 16),
                
                // Quick Toggle Chips
                const Text(
                  "Active Floating Overlays",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(
                      selected: _showFloatingDock,
                      label: const Text("Floating Dock Bubble"),
                      avatar: const Icon(Icons.apps, size: 16),
                      selectedColor: _dockAccentColor.withOpacity(0.3),
                      onSelected: (val) => setState(() => _showFloatingDock = val),
                    ),
                    FilterChip(
                      selected: _showPrivacyShield,
                      label: const Text("Anti-Peep Shield"),
                      avatar: const Icon(Icons.visibility_off, size: 16),
                      selectedColor: Colors.purple.withOpacity(0.3),
                      onSelected: (val) => setState(() => _showPrivacyShield = val),
                    ),
                    FilterChip(
                      selected: _showQuickNote,
                      label: const Text("Sticky Note HUD"),
                      avatar: const Icon(Icons.edit_note, size: 16),
                      selectedColor: Colors.amber.withOpacity(0.3),
                      onSelected: (val) => setState(() => _showQuickNote = val),
                    ),
                    FilterChip(
                      selected: _showClipboardBar,
                      label: const Text("Clipboard Feed"),
                      avatar: const Icon(Icons.content_paste, size: 16),
                      selectedColor: Colors.blue.withOpacity(0.3),
                      onSelected: (val) => setState(() => _showClipboardBar = val),
                    ),
                    FilterChip(
                      selected: _enableScreenTint,
                      label: const Text("Blue Light Filter"),
                      avatar: const Icon(Icons.nightlight_round, size: 16),
                      selectedColor: Colors.deepOrange.withOpacity(0.3),
                      onSelected: (val) => setState(() => _enableScreenTint = val),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Interactive Instructions Box
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white70),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.teal, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "HUD Overlay Capabilities",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildBulletItem("Drag the floating dock icon to place it anywhere on screen."),
                      _buildBulletItem("The Anti-Peep Shield hides sensitive text or financial data from side onlookers."),
                      _buildBulletItem("Floating Notes let you jot thoughts without app switching."),
                      _buildBulletItem("Live Clipboard captures screen text and formats it instantly."),
                    ],
                  ),
                ),
                const SizedBox(height: 250), // Buffer space for overlays
              ],
            ),
          ),

          // BLUE LIGHT SCREEN TINT OVERLAY SIMULATOR
          if (_enableScreenTint && _isServiceActive)
            IgnorePointer(
              child: Container(
                color: Colors.amber.withOpacity(_tintOpacity),
              ),
            ),

          // DRAGGABLE FLOATING DOCK BUBBLE
          if (_showFloatingDock && _isServiceActive)
            Positioned(
              left: _dockPosition.dx,
              top: _dockPosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _dockPosition += details.delta;
                  });
                },
                child: DraggableFloatingDockWidget(
                  accentColor: _dockAccentColor,
                  onOpenNote: () => setState(() => _showQuickNote = !_showQuickNote),
                  onToggleShield: () => setState(() => _showPrivacyShield = !_showPrivacyShield),
                ),
              ),
            ),

          // DRAGGABLE ANTI-PEEP PRIVACY SHIELD
          if (_showPrivacyShield && _isServiceActive)
            Positioned(
              left: _privacyShieldPosition.dx,
              top: _privacyShieldPosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _privacyShieldPosition += details.delta;
                  });
                },
                child: Container(
                  width: 280,
                  height: 90,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purple.withOpacity(0.8), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.security, color: Colors.purpleAccent, size: 16),
                              SizedBox(width: 6),
                              Text(
                                "ANTI-PEEP PRIVACY SHIELD",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => setState(() => _showPrivacyShield = false),
                            child: const Icon(Icons.close, color: Colors.grey, size: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "•••• •••• •••• 8842 [CONFIDENTIAL DATA SHIELDED]",
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 11,
                            fontFamily: 'monospace',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // DRAGGABLE FLOATING QUICK NOTE
          if (_showQuickNote && _isServiceActive)
            Positioned(
              left: _quickNotePosition.dx,
              top: _quickNotePosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _quickNotePosition += details.delta;
                  });
                },
                child: Container(
                  width: 240,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withOpacity(0.6), width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black87,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.edit_note, color: Colors.amber, size: 18),
                              SizedBox(width: 4),
                              Text(
                                "Floating Note",
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => setState(() => _showQuickNote = false),
                            child: const Icon(Icons.close, color: Colors.grey, size: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: TextEditingController(text: _stickyNoteText),
                        onChanged: (val) => _stickyNoteText = val,
                        maxLines: 2,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        decoration: const InputDecoration(
                          hintText: "Type live screen note...",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // LIVE FLOATING CLIPBOARD NOTIFICATION BAR AT BOTTOM
          if (_showClipboardBar && _isServiceActive && _clipboardHistory.isNotEmpty)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.withOpacity(0.5)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black87,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.content_paste_go, color: Colors.teal, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "LIVE CLIPBOARD DETECTED",
                            style: TextStyle(
                              color: Colors.teal,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                          Text(
                            _clipboardHistory.first,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.white, size: 18),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Copied to system clipboard!"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // TAB 2: SMART CLIPBOARD & MICRO-TOOLS
  Widget _buildSmartClipboardTab() {
    final TextEditingController inputController = TextEditingController();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBannerCard(
              title: "Smart Clipboard Stack",
              description:
                  "Auto-capture, clean, and format copied text instantly without losing your history.",
              icon: Icons.content_paste,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),

            // Quick Text Transformer Utility
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Quick Text Micro-Formatter",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: inputController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: "Enter text to transform or clean...",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                        icon: const Icon(Icons.cleaning_services, size: 14, color: Colors.white),
                        label: const Text("Clean Spaces", style: TextStyle(color: Colors.white, fontSize: 11)),
                        onPressed: () {
                          if (inputController.text.isNotEmpty) {
                            setState(() {
                              _clipboardHistory.insert(
                                0,
                                inputController.text.trim().replaceAll(RegExp(r'\s+'), ' '),
                              );
                            });
                          }
                        },
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                        icon: const Icon(Icons.text_fields, size: 14, color: Colors.white),
                        label: const Text("UPPERCASE", style: TextStyle(color: Colors.white, fontSize: 11)),
                        onPressed: () {
                          if (inputController.text.isNotEmpty) {
                            setState(() {
                              _clipboardHistory.insert(0, inputController.text.toUpperCase());
                            });
                          }
                        },
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                        icon: const Icon(Icons.link, size: 14, color: Colors.white),
                        label: const Text("Extract URLs", style: TextStyle(color: Colors.white, fontSize: 11)),
                        onPressed: () {
                          final reg = RegExp(r'(https?://[^\s]+)');
                          final match = reg.firstMatch(inputController.text);
                          if (match != null) {
                            setState(() {
                              _clipboardHistory.insert(0, match.group(0)!);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Clipboard History Stack",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
                  label: const Text("Clear All", style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                  onPressed: () {
                    setState(() {
                      _clipboardHistory.clear();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (_clipboardHistory.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "No saved clips yet. Copy text anywhere on phone to build your floating stack!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _clipboardHistory.length,
                itemBuilder: (context, index) {
                  final item = _clipboardHistory[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white70),
                    ),
                    child: ListTile(
                      dense: true,
                      leading: const Icon(Icons.content_copy, color: Colors.teal, size: 18),
                      title: Text(
                        item,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.share, size: 16, color: Colors.grey),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Sharing clip...")),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 16, color: Colors.redAccent),
                            onPressed: () {
                              setState(() {
                                _clipboardHistory.removeAt(index);
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

  // TAB 3: PRIVACY SHIELD & TINT CONTROL
  Widget _buildPrivacyAndTintTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBannerCard(
              title: "Privacy & Screen Comfort",
              description:
                  "Protect sensitive data from side-glance onlookers and reduce night eye-strain with active floating tints.",
              icon: Icons.shield,
              color: Colors.purple,
            ),
            const SizedBox(height: 16),

            // Anti-Peep Shield Config Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.visibility_off, color: Colors.purpleAccent, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Anti-Peep Privacy Shield",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      Switch(
                        value: _showPrivacyShield,
                        activeColor: Colors.purple,
                        onChanged: (val) => setState(() => _showPrivacyShield = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Creates an adjustable opaque dark strip over passwords, bank details, or private chats.",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      minimumSize: const Size(double.infinity, 42),
                    ),
                    icon: const Icon(Icons.aspect_ratio, color: Colors.white, size: 18),
                    label: const Text("Reset Privacy Shield Position", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      setState(() {
                        _privacyShieldPosition = const Offset(20, 200);
                        _showPrivacyShield = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Privacy Shield reset to top center!")),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Blue Light Filter Config
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.nightlight_round, color: Colors.amber, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Night Reading Tint Overlay",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      Switch(
                        value: _enableScreenTint,
                        activeColor: Colors.amber,
                        onChanged: (val) => setState(() => _enableScreenTint = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Applies a soft warm filter over the screen to eliminate blue light strain during late night browsing.",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text("Warmth Intensity:", style: TextStyle(color: Colors.white, fontSize: 12)),
                      Expanded(
                        child: Slider(
                          value: _tintOpacity,
                          min: 0.1,
                          max: 0.7,
                          activeColor: Colors.amber,
                          onChanged: (val) {
                            setState(() {
                              _tintOpacity = val;
                              if (!_enableScreenTint) _enableScreenTint = true;
                            });
                          },
                        ),
                      ),
                      Text(
                        "${(_tintOpacity * 100).toInt()}%",
                        style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 4: DOCK STUDIO & SYSTEM CONFIG
  Widget _buildDockStudioTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBannerCard(
              title: "Floating Dock Studio",
              description:
                  "Customize dynamic accent colors, bubble appearance, and system overlay permissions.",
              icon: Icons.tune,
              color: Colors.deepOrange,
            ),
            const SizedBox(height: 16),

            // Accent Color Chooser
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Dock Theme Accent Color",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _themeColors.map((color) {
                      final isSelected = _dockAccentColor == color;
                      return GestureDetector(
                        onTap: () => setState(() => _dockAccentColor = color),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.white : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: [
                              if (isSelected)
                                BoxShadow(
                                  color: color.withOpacity(0.6),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                            ],
                          ),
                          child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // System Permissions Simulation
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "System Overlay Permissions Hub",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  _buildPermissionRow(
                    title: "Display Over Other Apps",
                    status: "GRANTED",
                    isGranted: true,
                    icon: Icons.layers,
                  ),
                  const Divider(color: Colors.white70),
                  _buildPermissionRow(
                    title: "Floating Notification HUD",
                    status: "GRANTED",
                    isGranted: true,
                    icon: Icons.notifications_active,
                  ),
                  const Divider(color: Colors.white70),
                  _buildPermissionRow(
                    title: "Screen Capture Micro-Service",
                    status: "READY",
                    isGranted: true,
                    icon: Icons.camera_alt,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // HELPER CARD BUILDERS
  Widget _buildBannerCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.3), const Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRow({
    required String title,
    required String status,
    required bool isGranted,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isGranted ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: isGranted ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CUSTOM DRAGGABLE FLOATING DOCK WIDGET WITH EXPANDABLE MENU
class DraggableFloatingDockWidget extends StatefulWidget {
  final Color accentColor;
  final VoidCallback onOpenNote;
  final VoidCallback onToggleShield;

  const DraggableFloatingDockWidget({
    super.key,
    required this.accentColor,
    required this.onOpenNote,
    required this.onToggleShield,
  });

  @override
  State<DraggableFloatingDockWidget> createState() => _DraggableFloatingDockWidgetState();
}

class _DraggableFloatingDockWidgetState extends State<DraggableFloatingDockWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isExpanded)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: widget.accentColor.withOpacity(0.8), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black87,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_note, color: Colors.amber, size: 20),
                  tooltip: "Sticky Note",
                  onPressed: () {
                    widget.onOpenNote();
                    setState(() => _isExpanded = false);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.visibility_off, color: Colors.purpleAccent, size: 20),
                  tooltip: "Shield",
                  onPressed: () {
                    widget.onToggleShield();
                    setState(() => _isExpanded = false);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.content_copy, color: Colors.teal, size: 20),
                  tooltip: "Copy Helper",
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Quick Floating OCR Scan Simulated!")),
                    );
                    setState(() => _isExpanded = false);
                  },
                ),
              ],
            ),
          ),
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: widget.accentColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.accentColor.withOpacity(0.5),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              _isExpanded ? Icons.close : Icons.widgets,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ],
    );
  }
}