import 'package:flutter/material.dart';

void main() {
  runApp(const FloatingHUDApp());
}

class FloatingHUDApp extends StatelessWidget {
  const FloatingHUDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatingHUD Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF12121A),
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
  int _currentIndex = 0;

  // Floating HUD interactive state
  Offset _bubblePosition = const Offset(30, 200);
  bool _isOverlayActive = true;
  bool _isBubbleExpanded = false;
  Color _hudThemeColor = Colors.deepPurpleAccent;
  double _hudOpacity = 0.9;
  double _hudSize = 60.0;

  // Clipboard Tools State
  final TextEditingController _clipInputController = TextEditingController(
    text: "  https://example.com/item?ref=123&track=abc  \n\nSAMPLE  text  with   EXTRA   spaces!  ",
  );
  String _clipProcessedOutput = "";

  // Sticky Notes State
  final List<Map<String, String>> _stickies = [
    {"title": "Wi-Fi Pass", "content": "Office_5G: SafePass2025!", "color": "blue"},
    {"title": "Grocery Quick", "content": "Milk, Eggs, Dark Chocolate", "color": "amber"},
  ];
  final TextEditingController _stickyTitleCtrl = TextEditingController();
  final TextEditingController _stickyContentCtrl = TextEditingController();

  // Micro Decision State
  final TextEditingController _decisionInputCtrl = TextEditingController();
  final List<String> _decisionOptions = ["Take a 10m Walk", "Coffee Break", "Finish High Priority Task", "Power Nap"];
  String _decisionResult = "Tap 'Pick for Me' to decide!";

  @override
  void initState() {
    super.initState();
    _processClipboardText();
  }

  void _processClipboardText() {
    setState(() {
      String raw = _clipInputController.text;
      // Clean spaces and formatting
      _clipProcessedOutput = raw
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
    });
  }

  void _addSticky() {
    if (_stickyTitleCtrl.text.trim().isEmpty) return;
    setState(() {
      _stickies.add({
        "title": _stickyTitleCtrl.text.trim(),
        "content": _stickyContentCtrl.text.trim(),
        "color": "teal",
      });
      _stickyTitleCtrl.clear();
      _stickyContentCtrl.clear();
    });
    Navigator.of(context).pop();
  }

  void _pickDecision() {
    if (_decisionOptions.isEmpty) return;
    setState(() {
      final List<String> shuffled = List.from(_decisionOptions)..shuffle();
      _decisionResult = shuffled.first;
    });
  }

  void _addDecisionOption() {
    if (_decisionInputCtrl.text.trim().isEmpty) return;
    setState(() {
      _decisionOptions.add(_decisionInputCtrl.text.trim());
      _decisionInputCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content Views
            IndexedStack(
              index: _currentIndex,
              children: [
                _buildHUDStudioTab(),
                _buildClipboardTab(),
                _buildStickiesAndDecisionTab(),
                _buildSystemHUDTab(),
              ],
            ),

            // Floating Dynamic HUD Overlay Simulator
            if (_isOverlayActive)
              Positioned(
                left: _bubblePosition.dx,
                top: _bubblePosition.dy,
                child: GestureDetecorHUD(
                  hudSize: _hudSize,
                  hudOpacity: _hudOpacity,
                  hudColor: _hudThemeColor,
                  isExpanded: _isBubbleExpanded,
                  onPanUpdate: (details) {
                    setState(() {
                      final screenSize = MediaQuery.of(context).size;
                      double newX = _bubblePosition.dx + details.delta.dx;
                      double newY = _bubblePosition.dy + details.delta.dy;
                      newX = newX.clamp(10.0, screenSize.width - _hudSize - 10.0);
                      newY = newY.clamp(10.0, screenSize.height - _hudSize - 80.0);
                      _bubblePosition = Offset(newX, newY);
                    });
                  },
                  onTap: () {
                    setState(() {
                      _isBubbleExpanded = !_isBubbleExpanded;
                    });
                  },
                  onQuickAction: (action) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('HUD Action Triggered: $action'),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    setState(() {
                      _isBubbleExpanded = false;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.widgets),
            label: 'HUD Studio',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_paste_search),
            label: 'Smart Clip',
          ),
          NavigationDestination(
            icon: Icon(Icons.touch_app),
            label: 'Tools & Decider',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune),
            label: 'Overlay Settings',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: HUD STUDIO ---
  Widget _buildHUDStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader("Floating HUD Studio", "Interactive on-screen assistant HUD with quick actions"),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFF1E1E2C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.layers, color: _hudThemeColor, size: 28),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Active Overlay Permission",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                        ),
                      ),
                      Switch(
                        value: _isOverlayActive,
                        activeColor: _hudThemeColor,
                        onChanged: (val) {
                          setState(() {
                            _isOverlayActive = val;
                          });
                        },
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white70, height: 24),
                  const Text(
                    "Drag the glowing HUD bubble anywhere on screen. Tap it to expand micro-actions menu!",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text("Quick Status Bar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard("Battery Health", "98% • Good", Icons.battery_charging_full, Colors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard("RAM Usage", "3.4 GB / 8 GB", Icons.memory, Colors.blue),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFF1E1E2C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.notifications_active, color: Colors.amber),
              title: const Text("Simulate Floating Toast Notification", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              subtitle: const Text("Tests system floating alerts over active apps", style: TextStyle(color: Colors.white70, fontSize: 12)),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: const [
                          Icon(Icons.bolt, color: Colors.black),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "FloatingHUD Alert: System running smoothly!",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.amber,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text("Trigger", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: SMART CLIPBOARD HUB ---
  Widget _buildClipboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader("Smart Clipboard Sanitizer", "Clean URLs, trim whitespace & format copied texts instantly"),
          const SizedBox(height: 16),
          TextField(
            controller: _clipInputController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Paste or Type Raw Clipboard Content",
              labelStyle: TextStyle(color: Colors.white70),
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurpleAccent)),
            ),
            onChanged: (_) => _processClipboardText(),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.cleaning_services, size: 18),
                label: const Text("Remove Extra Spaces"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                onPressed: () {
                  setState(() {
                    _clipInputController.text = _clipInputController.text.replaceAll(RegExp(r'\s+'), ' ').trim();
                    _processClipboardText();
                  });
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.text_fields, size: 18),
                label: const Text("UPPERCASE"),
                onPressed: () {
                  setState(() {
                    _clipInputController.text = _clipInputController.text.toUpperCase();
                    _processClipboardText();
                  });
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.link_off, size: 18),
                label: const Text("Strip URL Query Params"),
                onPressed: () {
                  setState(() {
                    String text = _clipInputController.text;
                    int queryIdx = text.indexOf('?');
                    if (queryIdx != -1) {
                      _clipInputController.text = text.substring(0, queryIdx);
                    }
                    _processClipboardText();
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Processed Clean Result:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  _clipProcessedOutput.isEmpty ? "No output processed yet" : _clipProcessedOutput,
                  style: const TextStyle(color: Colors.greenAccent, fontSize: 14, fontFamily: 'monospace'),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.copy, size: 16, color: Colors.white),
                      label: const Text("Copy Output", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Cleaned text copied to clipboard!"),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
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

  // --- TAB 3: TOOLS & MICRO DECIDER ---
  Widget _buildStickiesAndDecisionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader("Micro Decision Matrix & Stickies", "Resolve choice paralysis & pin instant notes"),
          const SizedBox(height: 16),
          // Decision Card
          Card(
            color: const Color(0xFF1E1E2C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.casino, color: Colors.amber),
                      SizedBox(width: 8),
                      Text("What should I do now?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.withOpacity(0.4)),
                    ),
                    child: Center(
                      child: Text(
                        _decisionResult,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _decisionInputCtrl,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Add custom choice...",
                            hintStyle: TextStyle(color: Colors.white70),
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.amber, size: 32),
                        onPressed: _addDecisionOption,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _decisionOptions
                        .map(
                          (opt) => Chip(
                            label: Text(opt, style: const TextStyle(fontSize: 12, color: Colors.white)),
                            backgroundColor: Colors.black87,
                            onDeleted: () {
                              setState(() {
                                _decisionOptions.remove(opt);
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.play_arrow),
                      label: const Text("Pick For Me!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: _pickDecision,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Quick Floating Stickies", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              IconButton(
                icon: const Icon(Icons.note_add, color: Colors.tealAccent),
                onPressed: _showAddStickyDialog,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _stickies.length,
            itemBuilder: (context, index) {
              final item = _stickies[index];
              return Card(
                color: const Color(0xFF1E1E2C),
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.teal, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.push_pin, color: Colors.tealAccent),
                  title: Text(item["title"] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  subtitle: Text(item["content"] ?? "", style: const TextStyle(color: Colors.white70)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _stickies.removeAt(index);
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

  // --- TAB 4: SYSTEM HUD & OVERLAY SETTINGS ---
  Widget _buildSystemHUDTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader("Overlay & Display Settings", "Customize visual parameters of your floating assistant"),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFF1E1E2C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("HUD Bubble Size", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  Slider(
                    value: _hudSize,
                    min: 40.0,
                    max: 90.0,
                    activeColor: _hudThemeColor,
                    onChanged: (val) {
                      setState(() {
                        _hudSize = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text("HUD Opacity", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  Slider(
                    value: _hudOpacity,
                    min: 0.3,
                    max: 1.0,
                    activeColor: _hudThemeColor,
                    onChanged: (val) {
                      setState(() {
                        _hudOpacity = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text("Accent Theme Color", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    children: [
                      _buildColorSwatch(Colors.deepPurpleAccent),
                      _buildColorSwatch(Colors.blueAccent),
                      _buildColorSwatch(Colors.tealAccent),
                      _buildColorSwatch(Colors.amber),
                      _buildColorSwatch(Colors.redAccent),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFF1E1E2C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const ListTile(
              leading: Icon(Icons.info, color: Colors.blue),
              title: Text("Display Above Other Apps", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text(
                "Grants overlay permission to keep FloatingHUD accessible while using social media, games, or browsers.",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSwatch(Color color) {
    bool isSelected = _hudThemeColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          _hudThemeColor = color;
        });
      },
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
        ),
      ),
    );
  }

  Widget _buildHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  void _showAddStickyDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          title: const Text("New Floating Sticky", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _stickyTitleCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Title",
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _stickyContentCtrl,
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Sticky Content",
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: _addSticky,
              child: const Text("Save Note"),
            ),
          ],
        );
      },
    );
  }
}

// --- INTERACTIVE FLOATING HUD BUBBLE COMPONENT ---
class GestureDetecorHUD extends StatelessWidget {
  final double hudSize;
  final double hudOpacity;
  final Color hudColor;
  final bool isExpanded;
  final Function(DragUpdateDetails) onPanUpdate;
  final VoidCallback onTap;
  final Function(String) onQuickAction;

  const GestureDetecorHUD({
    super.key,
    required this.hudSize,
    required this.hudOpacity,
    required this.hudColor,
    required this.isExpanded,
    required this.onPanUpdate,
    required this.onTap,
    required this.onQuickAction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onPanUpdate,
      onTap: onTap,
      child: Opacity(
        opacity: hudOpacity,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: isExpanded ? 220 : hudSize,
          height: isExpanded ? 180 : hudSize,
          padding: EdgeInsets.all(isExpanded ? 12 : 0),
          decoration: BoxDecoration(
            color: const Color(0xFF181824).withOpacity(0.95),
            borderRadius: BorderRadius.circular(isExpanded ? 20 : hudSize / 2),
            border: Border.all(color: hudColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: hudColor.withOpacity(0.5),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: isExpanded
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.bolt, color: hudColor, size: 20),
                            const SizedBox(width: 4),
                            const Text(
                              "HUD Actions",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                        const Icon(Icons.close, color: Colors.white70, size: 18),
                      ],
                    ),
                    const Divider(color: Colors.white70, height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQuickActionButton(Icons.copy, "Clip", () => onQuickAction("Clean Clip")),
                        _buildQuickActionButton(Icons.casino, "Decide", () => onQuickAction("Quick Choice")),
                        _buildQuickActionButton(Icons.speed, "RAM", () => onQuickAction("Boost Memory")),
                      ],
                    ),
                  ],
                )
              : Center(
                  child: Icon(
                    Icons.widgets,
                    color: hudColor,
                    size: hudSize * 0.5,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(IconData icon, String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: hudColor.withOpacity(0.2),
            child: Icon(icon, color: hudColor, size: 18),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}