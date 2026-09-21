import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const FloatEdgeApp());
}

class FloatEdgeApp extends StatelessWidget {
  const FloatEdgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatEdge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0F17),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.teal,
          surface: Color(0xFF161A29),
        ),
        useMaterial3: true,
      ),
      home: const FloatEdgeHome(),
    );
  }
}

class FloatEdgeHome extends StatefulWidget {
  const FloatEdgeHome({super.key});

  @override
  State<FloatEdgeHome> createState() => _FloatEdgeHomeState();
}

class _FloatEdgeHomeState extends State<FloatEdgeHome>
    with SingleTickerProviderStateMixin {
  int _currentTab = 0;

  // Floating Overlay Bubble Position
  double _bubbleX = 280.0;
  double _bubbleY = 320.0;
  bool _isOverlayOpen = false;
  bool _isOverlayEnabled = true;

  // Active Dynamic Theme
  Color _accentColor = Colors.blue;
  String _themeName = "Cyber Neon";

  // Clip Vault State
  final List<Map<String, String>> _clipVault = [
    {
      "title": "Home Wi-Fi Key",
      "content": "WIFI_5G_FAST_9823",
      "tag": "Personal"
    },
    {
      "title": "Delivery Address",
      "content": "742 Evergreen Terrace, Apt 4B",
      "tag": "Address"
    },
    {
      "title": "Bank IBAN / Account",
      "content": "US89 3704 0023 1190 2841",
      "tag": "Finance"
    },
    {
      "title": "Quick Email Reply",
      "content":
          "Hi! Thanks for reaching out. I'll get back to you shortly.",
      "tag": "Work"
    },
  ];
  String _clipFilter = "All";
  final TextEditingController _clipSearchController = TextEditingController();

  // Sticky Floating Notes State
  final List<Map<String, String>> _stickyNotes = [
    {
      "title": "Groceries to buy",
      "body": "Almond Milk, Fresh Bread, Espresso Beans",
      "color": "Amber"
    },
    {
      "title": "Meeting Prep",
      "body": "Review Q3 marketing deck before 3 PM call",
      "color": "Teal"
    },
  ];

  // Decision Maker State
  final List<String> _decisionChoices = [
    "Order Pizza",
    "Cook at Home",
    "Sushi Night",
    "Mexican Tacos"
  ];
  String _decisionResult = "Tap 'Spin Decision' to choose!";
  bool _isSpinning = false;

  // Micro Calculator State
  double _billAmount = 48.50;
  double _tipPercentage = 15;
  int _splitCount = 2;

  // Ambient Soundscape State
  bool _isPlayingAmbient = false;
  int _selectedAmbientTrack = 0;
  final List<Map<String, dynamic>> _ambientTracks = [
    {
      "title": "Midnight Rain",
      "desc": "Calming raindrops on window glass",
      "icon": Icons.water_drop
    },
    {
      "title": "Cyber Synth Ambient",
      "desc": "Deep rhythmic low-fi focus pulse",
      "icon": Icons.graphic_eq
    },
    {
      "title": "Cozy Cafe Buzz",
      "desc": "Warm background coffee shop murmur",
      "icon": Icons.coffee
    },
    {
      "title": "Forest Stream",
      "desc": "Gentle running water & soft breeze",
      "icon": Icons.park
    },
  ];

  @override
  void dispose() {
    _clipSearchController.dispose();
    super.dispose();
  }

  void _addNewClip(String title, String content, String tag) {
    setState(() {
      _clipVault.insert(0, {
        "title": title,
        "content": content,
        "tag": tag,
      });
    });
  }

  void _addNewNote(String title, String body, String colorName) {
    setState(() {
      _stickyNotes.insert(0, {
        "title": title,
        "body": body,
        "color": colorName,
      });
    });
  }

  void _spinDecision() {
    if (_decisionChoices.isEmpty) return;
    setState(() {
      _isSpinning = true;
      _decisionResult = "Deciding...";
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      final random = Random();
      final selected =
          _decisionChoices[random.nextInt(_decisionChoices.length)];
      setState(() {
        _isSpinning = false;
        _decisionResult = "Selected: $selected!";
      });
    });
  }

  void _copyToClipboardSimulated(String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _accentColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Copied to Floating Clipboard: "$text"',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Main Body Content based on active tab
          SafeArea(
            child: Column(
              children: [
                // Top Simulated Dynamic Island Overlay Header Bar
                _buildDynamicIslandHeader(),

                // Scrollable View Content
                Expanded(
                  child: IndexedStack(
                    index: _currentTab,
                    children: [
                      _buildOverlayDashboardTab(),
                      _buildClipVaultTab(),
                      _buildToolsTab(),
                      _buildAmbientSoundscapeTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Simulated Interactive Floating Overlay Bubble
          if (_isOverlayEnabled)
            Positioned(
              left: _bubbleX,
              top: _bubbleY,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubbleX =
                        (_bubbleX + details.delta.dx).clamp(10.0, size.width - 70.0);
                    _bubbleY = (_bubbleY + details.delta.dy)
                        .clamp(80.0, size.height - 120.0);
                  });
                },
                onTap: () {
                  setState(() {
                    _isOverlayOpen = !_isOverlayOpen;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: _accentColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _accentColor.withOpacity(0.5),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isOverlayOpen ? Icons.close : Icons.layers,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "FloatHUD",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Interactive Floating Radial Overlay Menu Popup
          if (_isOverlayOpen && _isOverlayEnabled)
            Positioned(
              left: (_bubbleX - 120).clamp(20.0, size.width - 240.0),
              top: (_bubbleY - 140).clamp(100.0, size.height - 300.0),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 230,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2436),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _accentColor, width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black87,
                        blurRadius: 24,
                        spreadRadius: 4,
                      )
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
                              Icon(Icons.bolt, color: Colors.amber, size: 18),
                              SizedBox(width: 6),
                              Text(
                                "Quick Actions",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _isOverlayOpen = false),
                            child: const Icon(Icons.close,
                                color: Colors.white70, size: 16),
                          )
                        ],
                      ),
                      const Divider(color: Colors.white70, height: 16),
                      _buildOverlayMenuItem(
                        icon: Icons.content_copy,
                        title: "Copy Top Clip",
                        subtitle: _clipVault.isNotEmpty
                            ? _clipVault.first["title"]!
                            : "No Clips",
                        onTap: () {
                          if (_clipVault.isNotEmpty) {
                            _copyToClipboardSimulated(
                                _clipVault.first["content"]!);
                          }
                          setState(() => _isOverlayOpen = false);
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildOverlayMenuItem(
                        icon: Icons.music_note,
                        title: "Toggle Ambient Sound",
                        subtitle: _isPlayingAmbient
                            ? "Playing Audio"
                            : "Paused",
                        onTap: () {
                          setState(() {
                            _isPlayingAmbient = !_isPlayingAmbient;
                            _isOverlayOpen = false;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildOverlayMenuItem(
                        icon: Icons.casino,
                        title: "Quick Decision Spinner",
                        subtitle: "Tap to spin choice",
                        onTap: () {
                          setState(() {
                            _currentTab = 2;
                            _isOverlayOpen = false;
                          });
                          _spinDecision();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (index) {
          setState(() {
            _currentTab = index;
          });
        },
        backgroundColor: const Color(0xFF131724),
        selectedItemColor: _accentColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_customize),
            label: 'HUD Suite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Clip Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Tools & Calc',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.graphic_eq),
            label: 'Ambient',
          ),
        ],
      ),
    );
  }

  // Header Bar simulating a Floating Dynamic Island / System Status overlay
  Widget _buildDynamicIslandHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F30),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _accentColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: _isOverlayEnabled ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _isOverlayEnabled
                  ? "FloatEdge Overlay Active • Vault: ${_clipVault.length}"
                  : "Overlay Disabled",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Wrap(
            spacing: 8,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isOverlayEnabled = !_isOverlayEnabled;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isOverlayEnabled
                        ? _accentColor.withOpacity(0.2)
                        : Colors.white70,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isOverlayEnabled ? _accentColor : Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _isOverlayEnabled ? "HUD ON" : "HUD OFF",
                    style: TextStyle(
                      color: _isOverlayEnabled ? _accentColor : Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: _accentColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: HUD Dashboard & Sticky Notes Studio
  Widget _buildOverlayDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _accentColor.withOpacity(0.8),
                  const Color(0xFF1E2436),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black87,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.touch_app, color: Colors.white, size: 26),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Always-On Floating HUD",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Drag the Floating Bubble anywhere on screen. Tap it to immediately access quick actions, copied snippets, and tools from any workflow.",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    _buildThemeChip("Cyber Neon", Colors.blue),
                    _buildThemeChip("Emerald Glow", Colors.teal),
                    _buildThemeChip("Sunset Amber", Colors.amber),
                    _buildThemeChip("Deep Purple", Colors.purple),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Sticky Floating Notes Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Floating Sticky Notes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle, color: _accentColor),
                onPressed: _showAddNoteDialog,
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (_stickyNotes.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  "No sticky notes yet. Tap + to add one!",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _stickyNotes.length,
              itemBuilder: (context, index) {
                final note = _stickyNotes[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF181C2B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border(
                      left: BorderSide(
                        color: _getNoteColor(note["color"] ?? "Blue"),
                        width: 5,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              note["title"] ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.grey, size: 18),
                            onPressed: () {
                              setState(() {
                                _stickyNotes.removeAt(index);
                              });
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        note["body"] ?? "",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
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

  Color _getNoteColor(String colorName) {
    switch (colorName) {
      case "Amber":
        return Colors.amber;
      case "Teal":
        return Colors.teal;
      case "Purple":
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  Widget _buildThemeChip(String label, Color color) {
    final isSelected = _themeName == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _themeName = label;
          _accentColor = color;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.black87,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  // TAB 2: Smart Clipboard Vault & Quick Snippets
  Widget _buildClipVaultTab() {
    final filteredClips = _clipVault.where((clip) {
      final matchesFilter =
          _clipFilter == "All" || clip["tag"] == _clipFilter;
      final query = _clipSearchController.text.toLowerCase();
      final matchesSearch = clip["title"]!.toLowerCase().contains(query) ||
          clip["content"]!.toLowerCase().contains(query);
      return matchesFilter && matchesSearch;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Clipboard Vault & Snippets",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _showAddClipDialog,
                icon: const Icon(Icons.add, size: 18),
                label: const Text("New Clip"),
              )
            ],
          ),
          const SizedBox(height: 14),

          // Search Input Field
          TextField(
            controller: _clipSearchController,
            style: const TextStyle(color: Colors.white),
            onChanged: (val) => setState(() {}),
            decoration: InputDecoration(
              hintText: "Search snippets, keys, addresses...",
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF181C2B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Tag Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ["All", "Personal", "Address", "Finance", "Work"]
                  .map((tag) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: _clipFilter == tag,
                          label: Text(tag),
                          selectedColor: _accentColor,
                          labelStyle: TextStyle(
                            color:
                                _clipFilter == tag ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                          backgroundColor: const Color(0xFF181C2B),
                          onSelected: (selected) {
                            setState(() {
                              _clipFilter = tag;
                            });
                          },
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),

          if (filteredClips.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  "No clips match your query.",
                  style: TextStyle(color: Colors.grey),
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
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF181C2B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white70),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            clip["title"] ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _accentColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              clip["tag"] ?? "General",
                              style: TextStyle(
                                color: _accentColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F111A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          clip["content"] ?? "",
                          style: const TextStyle(
                            color: Colors.tealAccent,
                            fontFamily: 'monospace',
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(color: _accentColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () =>
                                _copyToClipboardSimulated(clip["content"]!),
                            icon: const Icon(Icons.content_copy, size: 16),
                            label: const Text("1-Tap Copy"),
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

  // TAB 3: Decision Engine & Quick Tip/Split Calculator
  Widget _buildToolsTab() {
    final tipAmount = (_billAmount * _tipPercentage) / 100;
    final totalAmount = _billAmount + tipAmount;
    final perPerson = totalAmount / (_splitCount > 0 ? _splitCount : 1);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Decision Engine Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF181C2B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _accentColor.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.casino, color: Colors.amber, size: 24),
                    SizedBox(width: 10),
                    Text(
                      "Micro Decision Engine",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Stuck on simple daily micro-choices? Tap spin to make an instant random selection.",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F111A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white70),
                  ),
                  child: Center(
                    child: Text(
                      _decisionResult,
                      style: TextStyle(
                        color: _isSpinning ? Colors.amber : _accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isSpinning ? null : _spinDecision,
                    icon: _isSpinning
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : const Icon(Icons.refresh),
                    label: Text(
                      _isSpinning ? "Spinning..." : "Spin Decision",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Micro Split & Tip Calculator
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF181C2B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.calculate, color: Colors.tealAccent, size: 24),
                    SizedBox(width: 10),
                    Text(
                      "Instant Tip & Bill Splitter",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Bill Input
                const Text("Bill Amount",
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 6),
                TextField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixText: "\$ ",
                    prefixStyle: TextStyle(
                        color: _accentColor, fontWeight: FontWeight.bold),
                    filled: true,
                    fillColor: const Color(0xFF0F111A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _billAmount = double.tryParse(val) ?? 0.0;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Tip Percentage Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Tip Percentage",
                        style: TextStyle(color: Colors.white70, fontSize: 13)),
                    Text("${_tipPercentage.toInt()}%",
                        style: TextStyle(
                            color: _accentColor, fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: _tipPercentage,
                  min: 0,
                  max: 30,
                  divisions: 6,
                  activeColor: _accentColor,
                  onChanged: (val) {
                    setState(() {
                      _tipPercentage = val;
                    });
                  },
                ),

                // Split People Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Split Between",
                        style: TextStyle(color: Colors.white70, fontSize: 13)),
                    Text("$_splitCount People",
                        style: TextStyle(
                            color: _accentColor, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.remove_circle, color: Colors.grey),
                      onPressed: () {
                        if (_splitCount > 1) {
                          setState(() => _splitCount--);
                        }
                      },
                    ),
                    Expanded(
                      child: Slider(
                        value: _splitCount.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        activeColor: _accentColor,
                        onChanged: (val) {
                          setState(() {
                            _splitCount = val.toInt();
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.grey),
                      onPressed: () {
                        if (_splitCount < 10) {
                          setState(() => _splitCount++);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Summary Calculation Cards
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F111A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text("Total + Tip",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 11)),
                            const SizedBox(height: 4),
                            FittedBox(
                              child: Text(
                                "\$${totalAmount.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _accentColor),
                        ),
                        child: Column(
                          children: [
                            const Text("Per Person",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 11)),
                            const SizedBox(height: 4),
                            FittedBox(
                              child: Text(
                                "\$${perPerson.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: _accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
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

  // TAB 4: Ambient Audio Soundscape & Focus Player
  Widget _buildAmbientSoundscapeTab() {
    final activeTrack = _ambientTracks[_selectedAmbientTrack];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ambient Focus Soundscape",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Keep soothing audio playing in the background while multitasking.",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Active Playing Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1E2436),
                  _accentColor.withOpacity(0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _accentColor),
            ),
            child: Column(
              children: [
                Icon(
                  activeTrack["icon"] as IconData,
                  size: 50,
                  color: _accentColor,
                ),
                const SizedBox(height: 10),
                Text(
                  activeTrack["title"] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activeTrack["desc"] as String,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Animated Sound Bars Simulator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(8, (index) {
                    final height =
                        _isPlayingAmbient ? (15.0 + (index % 4) * 8.0) : 6.0;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 6,
                      height: height,
                      decoration: BoxDecoration(
                        color: _isPlayingAmbient
                            ? _accentColor
                            : Colors.white70,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isPlayingAmbient ? Colors.redAccent : _accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPlayingAmbient = !_isPlayingAmbient;
                    });
                  },
                  icon: Icon(_isPlayingAmbient ? Icons.pause : Icons.play_arrow),
                  label: Text(_isPlayingAmbient ? "Pause Sound" : "Start Sound"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            "Select Soundscape",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _ambientTracks.length,
            itemBuilder: (context, index) {
              final track = _ambientTracks[index];
              final isSelected = _selectedAmbientTrack == index;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF181C2B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? _accentColor : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: ListTile(
                  leading: Icon(track["icon"] as IconData, color: _accentColor),
                  title: Text(
                    track["title"] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    track["desc"] as String,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: _accentColor)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedAmbientTrack = index;
                      _isPlayingAmbient = true;
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Dialog to Add New Clipboard Snippet
  void _showAddClipDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedTag = "Personal";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF181C2B),
              title: const Text("New Vault Snippet",
                  style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Snippet Title",
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
                        labelText: "Content / Text",
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedTag,
                      dropdownColor: const Color(0xFF181C2B),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Category Tag",
                        border: OutlineInputBorder(),
                      ),
                      items: ["Personal", "Address", "Finance", "Work"]
                          .map((t) => DropdownMenuItem(
                                value: t,
                                child: Text(t),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedTag = val);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child:
                      const Text("Cancel", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: _accentColor),
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        contentController.text.isNotEmpty) {
                      _addNewClip(
                        titleController.text,
                        contentController.text,
                        selectedTag,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save Clip",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Dialog to Add Sticky Note
  void _showAddNoteDialog() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    String selectedColor = "Blue";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF181C2B),
              title: const Text("New Sticky Note",
                  style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Title",
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: bodyController,
                      maxLines: 2,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Note Body",
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedColor,
                      dropdownColor: const Color(0xFF181C2B),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Border Accent",
                        border: OutlineInputBorder(),
                      ),
                      items: ["Blue", "Amber", "Teal", "Purple"]
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedColor = val);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child:
                      const Text("Cancel", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: _accentColor),
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      _addNewNote(
                        titleController.text,
                        bodyController.text,
                        selectedColor,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Add Note",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}