import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

void main() {
  runApp(const FloatPulseApp());
}

class FloatPulseApp extends StatelessWidget {
  const FloatPulseApp({super.key});

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'FloatPulse HUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyan,
          secondary: Colors.tealAccent,
          surface: Color(0xFF161E2E),
          background: Color(0xFF0B0F19),
        ),
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

class _MainHomeScreenState extends State<MainHomeScreen> with TickerProviderStateMixin {
  int _selectedTabIndex = 0;

  // Floating Overlay System State
  bool _isOverlayEnabled = true;
  bool _isFloatingExpanded = false;
  Offset _bubblePosition = const Offset(20, 220);
  String _floatingActiveNote = "Tap floating bubble for instant actions";

  // System Permissions Simulation
  bool _hasOverlayPermission = true;
  bool _hasNotificationPermission = true;

  // Notification Ticker Simulation
  String _activeTickerText = "FloatPulse HUD active • Tap to expand dynamic controls";
  bool _showTickerBar = true;

  // Ambient Audio Engine State
  bool _isAmbientPlaying = false;
  double _rainVolume = 0.6;
  double _cafeVolume = 0.3;
  double _wavesVolume = 0.5;
  double _fireVolume = 0.2;
  late AnimationController _visualizerController;

  // Smart Clipboard & Text Transformer State
  final TextEditingController _textTransformController = TextEditingController(text: "Total invoice amount is \$149.99! Contact: support@example.com or visit https://example.com");
  String _transformedText = "";
  List<String> _pinnedSnippets = [
    "Meeting Link: https://meet.jit.si/floatpulse-demo",
    "Wi-Fi Key: PulseNet-9824-Secure",
    "Quick Note: Review project design deliverables before 5 PM"
  ];

  // Screen Micro Tools State
  double _screenDimLevel = 0.0;
  double _billAmount = 85.50;
  int _splitPeople = 3;
  double _tipPercentage = 15.0;
  double _rulerMarkerPosition = 120.0;

  @override
  void initState() {
    super.initState();
    _visualizerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _performTextTransform("Clean Extra Spaces");
  }

  @override
  void dispose() {
    _visualizerController.dispose();
    _textTransformController.dispose();
    super.dispose();
  }

  void _performTextTransform(String mode) {
    String source = _textTransformController.text;
    setState(() {
      switch (mode) {
        case "Clean Extra Spaces":
          _transformedText = source.replaceAll(RegExp(r'\s+'), ' ').trim();
          break;
        case "UPPERCASE":
          _transformedText = source.toUpperCase();
          break;
        case "lowercase":
          _transformedText = source.toLowerCase();
          break;
        case "Strip Emails & URLs":
          _transformedText = source.replaceAll(RegExp(r'https?://\S+|[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'), '[REDACTED]');
          break;
        case "URL Encode":
          _transformedText = Uri.encodeComponent(source);
          break;
        case "Extract Numbers":
          Iterable<Match> matches = RegExp(r'\d+(\.\d+)?').allMatches(source);
          _transformedText = matches.map((m) => m.group(0)).join(', ');
          break;
        default:
          _transformedText = source;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Main Body Area
          SafeArea(
            child: Column(
              children: [
                // Top Header & Status Bar Ticker
                _buildDynamicHeader(),
                if (_showTickerBar) _buildFloatingTickerWidget(),
                
                // Content Tab View
                Expanded(
                  child: IndexedStack(
                    index: _selectedTabIndex,
                    children: [
                      _buildOverlayHubTab(screenSize),
                      _buildAmbientAudioTab(),
                      _buildSmartClipboardTab(),
                      _buildMicroToolsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Screen Dimmer Overlay Layer
          if (_screenDimLevel > 0)
            IgnorePointer(
              ignoring: true,
              child: Container(
                color: Colors.black.withOpacity(_screenDimLevel * 0.75),
              ),
            ),

          // Real Interactive Floating Dynamic Bubble Widget (Overlay Simulator)
          if (_isOverlayEnabled)
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubblePosition += details.delta;
                    // Keep floating widget on screen bounds
                    _bubblePosition = Offset(
                      _bubblePosition.dx.clamp(10.0, screenSize.width - 70.0),
                      _bubblePosition.dy.clamp(50.0, screenSize.height - 120.0),
                    );
                  });
                },
                onTap: () {
                  setState(() {
                    _isFloatingExpanded = !_isFloatingExpanded;
                  });
                },
                child: _buildDraggableFloatingWidget(),
              ),
            ),
        ],
      ),

      // Bottom Navigation Dock
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF111827),
          border: Border(top: BorderSide(color: Color(0xFF1F2937), width: 1.0)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedTabIndex,
          onTap: (index) {
            setState(() {
              _selectedTabIndex = index;
            });
          },
          backgroundColor: const Color(0xFF111827),
          selectedItemColor: Colors.cyan,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_customize),
              label: 'Floating HUD',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.graphic_eq),
              label: 'Ambient Deck',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.text_snippet),
              label: 'Smart Clip',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.build_circle),
              label: 'Micro Tools',
            ),
          ],
        ),
      ),
    );
  }

  // Header Banner
  Widget _buildDynamicHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        border: Border(bottom: BorderSide(color: Color(0xFF1F2937))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.cyan.withOpacity(0.4)),
            ),
            child: const Icon(Icons.layers_sharp, color: Colors.cyan, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FloatPulse HUD',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Active Dynamic Screen Overlay & Micro Matrix',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _isOverlayEnabled ? Icons.visibility : Icons.visibility_off,
              color: _isOverlayEnabled ? Colors.tealAccent : Colors.grey,
            ),
            tooltip: 'Toggle Dynamic Overlay',
            onPressed: () {
              setState(() {
                _isOverlayEnabled = !_isOverlayEnabled;
              });
            },
          ),
        ],
      ),
    );
  }

  // Dynamic Floating Ticker Widget
  Widget _buildFloatingTickerWidget() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF064E3B),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: Colors.tealAccent, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _activeTickerText,
              style: const TextStyle(color: Colors.tealAccent, fontSize: 12, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _showTickerBar = false;
              });
            },
            child: const Icon(Icons.close, color: Colors.white70, size: 16),
          ),
        ],
      ),
    );
  }

  // Visual Interactive Draggable Floating Widget HUD Bubble
  Widget _buildDraggableFloatingWidget() {
    if (_isFloatingExpanded) {
      return Material(
        elevation: 12,
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF1E293B),
        child: Container(
          width: 240,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.cyan.withOpacity(0.5), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.cyan.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 2,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.widgets, color: Colors.cyan, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'HUD Overlay',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => setState(() => _isFloatingExpanded = false),
                    child: const Icon(Icons.close, color: Colors.grey, size: 18),
                  )
                ],
              ),
              const Divider(color: Colors.white70, height: 16),
              Text(
                _floatingActiveNote,
                style: const TextStyle(color: Colors.white70, fontSize: 11),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildBubbleActionButton(
                    icon: _isAmbientPlaying ? Icons.pause : Icons.play_arrow,
                    label: _isAmbientPlaying ? 'Audio ON' : 'Audio OFF',
                    color: Colors.tealAccent,
                    onTap: () {
                      setState(() {
                        _isAmbientPlaying = !_isAmbientPlaying;
                        _activeTickerText = _isAmbientPlaying ? "Ambient audio focus deck playing" : "Ambient audio paused";
                      });
                    },
                  ),
                  _buildBubbleActionButton(
                    icon: Icons.copy,
                    label: 'Quick Snippet',
                    color: Colors.amber,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pinned snippet copied from overlay!'), duration: Duration(seconds: 1)),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }

    return Material(
      elevation: 8,
      shape: const CircleBorder(),
      color: Colors.transparent,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Colors.cyan, Colors.teal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.cyan.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Center(
          child: Icon(Icons.center_focus_strong, color: Colors.black, size: 28),
        ),
      ),
    );
  }

  Widget _buildBubbleActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 12),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: Floating Overlay Controls Hub
  Widget _buildOverlayHubTab(Size screenSize) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overlay Status Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.cyan.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _isOverlayEnabled ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isOverlayEnabled ? Icons.check_circle : Icons.warning_amber_rounded,
                        color: _isOverlayEnabled ? Colors.greenAccent : Colors.orange,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isOverlayEnabled ? "Floating Overlay Running" : "Overlay Engine Paused",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            _isOverlayEnabled ? "Drag the floating bubble anywhere on screen" : "Enable overlay to trigger screen assistant",
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isOverlayEnabled,
                      activeColor: Colors.cyan,
                      onChanged: (val) {
                        setState(() {
                          _isOverlayEnabled = val;
                          _activeTickerText = val ? "Floating HUD mode enabled" : "Floating HUD disabled";
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'SYSTEM PERMISSIONS STATUS',
                  style: TextStyle(color: Colors.cyan, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildPermissionBadge("Display Over Apps", _hasOverlayPermission, () {
                      setState(() => _hasOverlayPermission = !_hasOverlayPermission);
                    }),
                    _buildPermissionBadge("Floating Notifications", _hasNotificationPermission, () {
                      setState(() => _hasNotificationPermission = !_hasNotificationPermission);
                    }),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'Floating Quick Scratchpad',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          const Text(
            'Text entered here updates the floating overlay widget dynamically:',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 10),

          TextField(
            onChanged: (val) {
              setState(() {
                _floatingActiveNote = val.isEmpty ? "Tap floating bubble for instant actions" : val;
              });
            },
            maxLines: 2,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Type text for instant floating overlay preview...',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.cyan),
              ),
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            'Active HUD Widgets Suite',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),

          _buildWidgetToggleTile(
            title: "Live Ambient Audio Widget",
            subtitle: "Controls background focus audio layer from overlay",
            icon: Icons.graphic_eq,
            color: Colors.tealAccent,
            isActive: _isAmbientPlaying,
            onToggle: () {
              setState(() {
                _isAmbientPlaying = !_isAmbientPlaying;
              });
            },
          ),
          const SizedBox(height: 10),
          _buildWidgetToggleTile(
            title: "Dynamic Ticker Notification",
            subtitle: "Shows live status banner at the top of screen",
            icon: Icons.notifications,
            color: Colors.amber,
            isActive: _showTickerBar,
            onToggle: () {
              setState(() {
                _showTickerBar = !_showTickerBar;
              });
            },
          ),
          const SizedBox(height: 10),
          _buildWidgetToggleTile(
            title: "Active Screen Dimmer Filter",
            subtitle: "Applies night light tint overlay to whole app",
            icon: Icons.opacity,
            color: Colors.purpleAccent,
            isActive: _screenDimLevel > 0,
            onToggle: () {
              setState(() {
                _screenDimLevel = _screenDimLevel > 0 ? 0.0 : 0.35;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionBadge(String label, bool granted, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: granted ? Colors.teal.withOpacity(0.15) : Colors.red.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: granted ? Colors.tealAccent : Colors.redAccent),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(granted ? Icons.check : Icons.close, size: 14, color: granted ? Colors.tealAccent : Colors.redAccent),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: granted ? Colors.tealAccent : Colors.redAccent, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetToggleTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isActive,
    required VoidCallback onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isActive ? color.withOpacity(0.2) : const Color(0xFF0F172A),
              foregroundColor: isActive ? color : Colors.grey,
              side: BorderSide(color: isActive ? color : Colors.grey.withOpacity(0.3)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onPressed: onToggle,
            child: Text(isActive ? "ACTIVE" : "TOGGLE"),
          ),
        ],
      ),
    );
  }

  // TAB 2: Ambient Focus Sound Matrix (Long-retention feature)
  Widget _buildAmbientAudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Audio Master Player Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF064E3B), Color(0xFF022C22)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ambient Layer Deck',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          _isAmbientPlaying ? 'Multi-track audio playing...' : 'Audio deck standby',
                          style: TextStyle(color: Colors.tealAccent.withOpacity(0.8), fontSize: 12),
                        ),
                      ],
                    ),
                    IconButton(
                      iconSize: 42,
                      icon: Icon(
                        _isAmbientPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                        color: Colors.tealAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          _isAmbientPlaying = !_isAmbientPlaying;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Live Audio Visualizer Bars
                SizedBox(
                  height: 36,
                  child: AnimatedBuilder(
                    animation: _visualizerController,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(24, (index) {
                          double height = _isAmbientPlaying
                              ? (math.sin((_visualizerController.value * math.pi * 2) + index * 0.4).abs() * 28 + 6)
                              : 4.0;
                          return Container(
                            width: 5,
                            height: height,
                            decoration: BoxDecoration(
                              color: Colors.tealAccent.withOpacity(0.6 + (index % 4) * 0.1),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'Sound Layer Mixers',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),

          _buildSoundSliderTile(
            name: "Heavy Rain & Thunder",
            icon: Icons.water_drop,
            color: Colors.blueAccent,
            value: _rainVolume,
            onChanged: (val) => setState(() => _rainVolume = val),
          ),
          const SizedBox(height: 10),
          _buildSoundSliderTile(
            name: "Cozy Coffee Shop",
            icon: Icons.local_cafe,
            color: Colors.amber,
            value: _cafeVolume,
            onChanged: (val) => setState(() => _cafeVolume = val),
          ),
          const SizedBox(height: 10),
          _buildSoundSliderTile(
            name: "Ocean Waves",
            icon: Icons.waves,
            color: Colors.cyan,
            value: _wavesVolume,
            onChanged: (val) => setState(() => _wavesVolume = val),
          ),
          const SizedBox(height: 10),
          _buildSoundSliderTile(
            name: "Fireplace Crackle",
            icon: Icons.local_fire_department,
            color: Colors.deepOrangeAccent,
            value: _fireVolume,
            onChanged: (val) => setState(() => _fireVolume = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSoundSliderTile({
    required String name,
    required IconData icon,
    required Color color,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
              Text(
                '${(value * 100).toInt()}%',
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              thumbColor: color,
              overlayColor: color.withOpacity(0.2),
              trackHeight: 3,
            ),
            child: Slider(
              value: value,
              min: 0.0,
              max: 1.0,
              onChanged: onChanged,
            ),
          )
        ],
      ),
    );
  }

  // TAB 3: Smart Contextual Clipboard & Text Transformer
  Widget _buildSmartClipboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contextual Clipboard Matrix',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          const Text(
            'Paste dirty text to instantly format, redact, or extract key details:',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 12),

          // Source Input Field
          TextField(
            controller: _textTransformController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              labelText: 'Source Text Buffer',
              labelStyle: const TextStyle(color: Colors.cyan),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _textTransformController.clear();
                  _performTextTransform("");
                },
              ),
            ),
            onChanged: (val) => _performTextTransform("Clean Extra Spaces"),
          ),

          const SizedBox(height: 12),
          const Text(
            'Instant Transformers:',
            style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTransformChip("Clean Extra Spaces"),
              _buildTransformChip("UPPERCASE"),
              _buildTransformChip("lowercase"),
              _buildTransformChip("Strip Emails & URLs"),
              _buildTransformChip("URL Encode"),
              _buildTransformChip("Extract Numbers"),
            ],
          ),

          const SizedBox(height: 16),

          // Transformed Result Display Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.cyan.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'PROCESSED RESULT',
                      style: TextStyle(color: Colors.cyan, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                    ),
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Transformed text copied to system clipboard!'), duration: Duration(seconds: 1)),
                        );
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.content_copy, color: Colors.cyan, size: 14),
                          SizedBox(width: 4),
                          Text('Copy', style: TextStyle(color: Colors.cyan, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SelectableText(
                  _transformedText.isEmpty ? "No text output generated yet." : _transformedText,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'monospace'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pinned Snippets Deck',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.cyan),
                onPressed: () {
                  if (_textTransformController.text.isNotEmpty) {
                    setState(() {
                      _pinnedSnippets.insert(0, _textTransformController.text);
                    });
                  }
                },
              )
            ],
          ),
          const SizedBox(height: 8),

          Column(
            children: _pinnedSnippets.map((snippet) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bookmark, color: Colors.amber, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        snippet,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 18),
                      onPressed: () {
                        setState(() {
                          _pinnedSnippets.remove(snippet);
                        });
                      },
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTransformChip(String modeName) {
    return ActionChip(
      label: Text(modeName),
      labelStyle: const TextStyle(color: Colors.tealAccent, fontSize: 11, fontWeight: FontWeight.w600),
      backgroundColor: const Color(0xFF1E293B),
      side: const BorderSide(color: Colors.teal),
      onPressed: () => _performTextTransform(modeName),
    );
  }

  // TAB 4: Micro Utilities (Ruler, Quick Bill Splitter, Night Dimmer)
  Widget _buildMicroToolsTab() {
    double totalPerPerson = (_billAmount * (1 + _tipPercentage / 100)) / (_splitPeople > 0 ? _splitPeople : 1);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instant Bill Splitter Micro Tool
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.monetization_on, color: Colors.greenAccent, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Micro Bill & Tip Calculator',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Per Person: \$${totalPerPerson.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Total: \$${(_billAmount * (1 + _tipPercentage / 100)).toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _billAmount,
                        min: 5.0,
                        max: 500.0,
                        activeColor: Colors.greenAccent,
                        onChanged: (val) => setState(() => _billAmount = val),
                      ),
                    ),
                    Text('\$${_billAmount.toInt()}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Split between $_splitPeople people', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.cyan),
                          onPressed: () {
                            if (_splitPeople > 1) setState(() => _splitPeople--);
                          },
                        ),
                        Text('$_splitPeople', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.cyan),
                          onPressed: () => setState(() => _splitPeople++),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Dynamic Screen Ruler Micro Tool
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.straighten, color: Colors.amber, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'On-Screen Pixel Ruler',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    Text(
                      '${_rulerMarkerPosition.toInt()} px',
                      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(height: 12),

                // Ruler Scale Visualizer
                GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _rulerMarkerPosition = (_rulerMarkerPosition + details.delta.dx).clamp(10.0, 300.0);
                    });
                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.withOpacity(0.5)),
                    ),
                    child: Stack(
                      children: [
                        // Ruler Ticks
                        Positioned.fill(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(20, (i) {
                              return Container(
                                width: 1,
                                height: (i % 5 == 0) ? 30 : 15,
                                color: Colors.grey.withOpacity(0.5),
                              );
                            }),
                          ),
                        ),
                        // Drag Indicator Bar
                        Positioned(
                          left: _rulerMarkerPosition,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 3,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Screen Color Filter / Dimmer Tool Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.nightlight_round, color: Colors.purpleAccent, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Screen Night Filter Level',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _screenDimLevel,
                        min: 0.0,
                        max: 0.8,
                        activeColor: Colors.purpleAccent,
                        onChanged: (val) {
                          setState(() {
                            _screenDimLevel = val;
                          });
                        },
                      ),
                    ),
                    Text(
                      '${(_screenDimLevel * 100).toInt()}%',
                      style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}