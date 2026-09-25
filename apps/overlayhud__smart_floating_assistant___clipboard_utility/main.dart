import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const OverlayHUDApp());
}

class OverlayHUDApp extends StatelessWidget {
  const OverlayHUDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlayHUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurpleAccent,
          secondary: Colors.amber,
          surface: const Color(0xFF1E1E2C),
          background: const Color(0xFF12121D),
        ),
        scaffoldBackgroundColor: const Color(0xFF12121D),
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

  // Floating Bubble position logic
  Offset _bubblePosition = const Offset(20, 200);
  bool _isBubbleExpanded = false;
  bool _overlayPermissionGranted = true;
  bool _notificationListenerActive = true;

  // Simulated System Stats
  double _ramUsage = 64.2;
  double _batteryTemp = 36.5;
  int _screenFps = 60;
  Timer? _statTimer;

  // Clipboard & Micro tools state
  final List<String> _clipboardHistory = [
    'https://flutter.dev/docs/get-started',
    'Contact team at support@overlayapp.io for details',
    'Total budget estimated: \$149.99 for sub-total items',
    'Meeting room code: 982-301-441',
  ];
  final TextEditingController _quickNoteController = TextEditingController();
  final List<String> _pinnedNotes = [];

  // Ambience sound simulation
  bool _isPlayingRain = false;
  bool _isPlayingCafe = false;
  bool _isPlayingForest = false;
  double _soundVolume = 0.7;

  // Decision wheel choices
  final List<String> _wheelItems = ['Do It Now', 'Wait 10 Mins', 'Delegate', 'Skip', 'Take a Break'];
  String _selectedDecision = 'Tap Spin to Decide';

  @override
  void initState() {
    super.initState();
    _startStatsSimulator();
  }

  @override
  void dispose() {
    _statTimer?.cancel();
    _quickNoteController.dispose();
    super.dispose();
  }

  void _startStatsSimulator() {
    _statTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _ramUsage = 58.0 + Random().nextDouble() * 15.0;
          _batteryTemp = 35.0 + Random().nextDouble() * 3.0;
          _screenFps = 58 + Random().nextInt(5);
        });
      }
    });
  }

  void _spinDecisionWheel() {
    final random = Random();
    setState(() {
      _selectedDecision = _wheelItems[random.nextInt(_wheelItems.length)];
    });
  }

  void _showFloatingNotification(String title, String body) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.amber),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    body,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main content based on navigation index
            IndexedStack(
              index: _currentIndex,
              children: [
                _buildHUDStudioTab(),
                _buildClipboardRadarTab(),
                _buildAmbienceTab(),
                _buildQuickToolsTab(),
              ],
            ),

            // Floating Interactive HUD Bubble Simulator (Visible across all tabs)
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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.deepPurpleAccent, Colors.blueAccent],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurpleAccent.withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.widgets,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),

            // Expanded Floating Quick Overlay Menu
            if (_isBubbleExpanded)
              Positioned(
                left: max(10.0, min(_bubblePosition.dx - 80, MediaQuery.of(context).size.width - 240)),
                top: min(_bubblePosition.dy + 60, MediaQuery.of(context).size.height - 280),
                child: Container(
                  width: 220,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2C).withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.5)),
                    boxShadow: const [
                      BoxShadow(color: Colors.black87, blurRadius: 20),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                            child: Text(
                              'Overlay Quick Menu',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _isBubbleExpanded = false),
                            child: const Icon(Icons.close, size: 18, color: Colors.white70),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white70),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.copy, color: Colors.tealAccent, size: 20),
                        title: const Text('Quick Paste Note', style: TextStyle(fontSize: 12, color: Colors.white)),
                        onTap: () {
                          setState(() {
                            if (_clipboardHistory.isNotEmpty) {
                              _pinnedNotes.add(_clipboardHistory.first);
                              _showFloatingNotification('Note Pinned', 'Added clipboard item to Floating Notes');
                            }
                            _isBubbleExpanded = false;
                          });
                        },
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.refresh, color: Colors.amberAccent, size: 20),
                        title: const Text('Spin Quick Wheel', style: TextStyle(fontSize: 12, color: Colors.white)),
                        onTap: () {
                          _spinDecisionWheel();
                          _showFloatingNotification('Decision Wheel', 'Selected: $_selectedDecision');
                          setState(() => _isBubbleExpanded = false);
                        },
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.volume_up, color: Colors.blueAccent, size: 20),
                        title: Text(
                          _isPlayingRain ? 'Pause Rain Sound' : 'Play Rain Sound',
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        onTap: () {
                          setState(() {
                            _isPlayingRain = !_isPlayingRain;
                            _showFloatingNotification('Ambience HUD', _isPlayingRain ? 'Rain Ambience Started' : 'Rain Ambience Stopped');
                            _isBubbleExpanded = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1A1A26),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.layers), label: 'HUD Studio'),
          BottomNavigationBarItem(icon: Icon(Icons.content_paste), label: 'Clipboard'),
          BottomNavigationBarItem(icon: Icon(Icons.graphic_eq), label: 'Ambience'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Quick Tools'),
        ],
      ),
    );
  }

  // TAB 1: HUD Studio & Floating Bubble Setup
  Widget _buildHUDStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBadge('System Floating Engine', 'Always active screen assistant preview'),
          const SizedBox(height: 16),

          // System Stats Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Live System Overlay Stats', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                      child: const Text('ACTIVE', style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildStatTile('RAM Usage', '${_ramUsage.toStringAsFixed(1)}%', Icons.memory, Colors.purpleAccent)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildStatTile('Battery Temp', '${_batteryTemp.toStringAsFixed(1)}°C', Icons.thermostat, Colors.orangeAccent)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildStatTile('FPS Gauge', '$_screenFps FPS', Icons.speed, Colors.tealAccent)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Permissions & Overlay Controls
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Permissions & Floating Triggers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.amber)),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Display Over Other Apps', style: TextStyle(fontSize: 14, color: Colors.white)),
                  subtitle: const Text('Allows overlay assistant bubble to float over social & browser apps', style: TextStyle(fontSize: 11, color: Colors.white70)),
                  value: _overlayPermissionGranted,
                  activeColor: Colors.deepPurpleAccent,
                  onChanged: (val) {
                    setState(() => _overlayPermissionGranted = val);
                    _showFloatingNotification('Overlay Status', val ? 'Floating permission enabled' : 'Floating overlay disabled');
                  },
                ),
                const Divider(color: Colors.white70),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Notification Listener & Radar', style: TextStyle(fontSize: 14, color: Colors.white)),
                  subtitle: const Text('Instant heads-up action banners for copied text and links', style: TextStyle(fontSize: 11, color: Colors.white70)),
                  value: _notificationListenerActive,
                  activeColor: Colors.amber,
                  onChanged: (val) {
                    setState(() => _notificationListenerActive = val);
                    _showFloatingNotification('Notification Radar', val ? 'Smart heads-up active' : 'Notification radar muted');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Test Floating Heads-Up Banner Trigger
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.bolt, color: Colors.amber),
              label: const Text('Simulate Floating Heads-Up Banner', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () {
                _showFloatingNotification('OverlayHUD Alert', 'Floating assistant bubble is ready. Drag it anywhere!');
              },
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: Smart Clipboard Radar
  Widget _buildClipboardRadarTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBadge('Clipboard Radar & Formatter', 'Auto-captures copied clips & formats on the fly'),
          const SizedBox(height: 16),

          // Clipboard Items List
          const Text('Captured Clipboard History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.amber)),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _clipboardHistory.length,
            itemBuilder: (context, index) {
              final item = _clipboardHistory[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2C),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white70),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      softWrap: true,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAxisAlignment.center,
                      children: [
                        ActionChip(
                          avatar: const Icon(Icons.text_fields, size: 14, color: Colors.tealAccent),
                          label: const Text('UPPERCASE', style: TextStyle(fontSize: 10, color: Colors.white)),
                          backgroundColor: Colors.black87,
                          onPressed: () {
                            setState(() {
                              _clipboardHistory[index] = item.toUpperCase();
                            });
                          },
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.cleaning_services, size: 14, color: Colors.amberAccent),
                          label: const Text('Trim Spaces', style: TextStyle(fontSize: 10, color: Colors.white)),
                          backgroundColor: Colors.black87,
                          onPressed: () {
                            setState(() {
                              _clipboardHistory[index] = item.replaceAll(RegExp(r'\s+'), ' ').trim();
                            });
                          },
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.pin, size: 14, color: Colors.purpleAccent),
                          label: const Text('Pin to HUD', style: TextStyle(fontSize: 10, color: Colors.white)),
                          backgroundColor: Colors.black87,
                          onPressed: () {
                            setState(() {
                              _pinnedNotes.add(item);
                            });
                            _showFloatingNotification('Pinned', 'Item saved to floating notes HUD');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 16),
          // Quick Price Converter Widget (\$ escaping check)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Instant Currency & Tax HUD Tool', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.tealAccent)),
                const SizedBox(height: 8),
                const Text(
                  'Auto-detected price: \$149.99 (US Market Standard)',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
                        child: const Text('With +10% Tax: \$164.99', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
                        child: const Text('20% Off: \$119.99', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
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

  // TAB 3: Floating Ambience Sound Engine
  Widget _buildAmbienceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBadge('Floating Background Ambience', 'Keep audio playing while browsing other apps'),
          const SizedBox(height: 16),

          // Sound Track 1: Gentle Rain
          _buildSoundCard(
            title: 'Cozy Rain & Thunder',
            subtitle: 'Lo-fi soft rain drop simulator for focus',
            icon: Icons.water_drop,
            color: Colors.blueAccent,
            isPlaying: _isPlayingRain,
            onToggle: () => setState(() => _isPlayingRain = !_isPlayingRain),
          ),
          const SizedBox(height: 12),

          // Sound Track 2: Cafe Atmosphere
          _buildSoundCard(
            title: 'Urban Coffee Shop',
            subtitle: 'Subtle ambient hum & distant cup clinks',
            icon: Icons.coffee,
            color: Colors.amber,
            isPlaying: _isPlayingCafe,
            onToggle: () => setState(() => _isPlayingCafe = !_isPlayingCafe),
          ),
          const SizedBox(height: 12),

          // Sound Track 3: Deep Forest
          _buildSoundCard(
            title: 'Midnight Forest Wind',
            subtitle: 'Gentle breeze and rustic foliage rustle',
            icon: Icons.park,
            color: Colors.greenAccent,
            isPlaying: _isPlayingForest,
            onToggle: () => setState(() => _isPlayingForest = !_isPlayingForest),
          ),
          const SizedBox(height: 20),

          // Master Volume Control
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Ambience Master Volume', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                    Text('${(_soundVolume * 100).toInt()}%', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: _soundVolume,
                  activeColor: Colors.amber,
                  inactiveColor: Colors.white70,
                  onChanged: (val) => setState(() => _soundVolume = val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 4: Quick Tools & Decision Spinner
  Widget _buildQuickToolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBadge('Screen Quick Micro-Tools', 'Micro-utilities for fast on-screen decisions'),
          const SizedBox(height: 16),

          // Micro Tool 1: Floating Decision Spinner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.style, color: Colors.amber),
                    SizedBox(width: 8),
                    Text('Floating Micro-Decision Wheel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      _selectedDecision,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.autorenew, color: Colors.black),
                    label: const Text('Spin Wheel Now', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    onPressed: _spinDecisionWheel,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Micro Tool 2: Pinned Floating Quick Notes
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Quick Sticky Notes Queue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _quickNoteController,
                        style: const TextStyle(fontSize: 13, color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Type quick memo...',
                          hintStyle: TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      backgroundColor: Colors.deepPurpleAccent,
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        if (_quickNoteController.text.trim().isNotEmpty) {
                          setState(() {
                            _pinnedNotes.add(_quickNoteController.text.trim());
                            _quickNoteController.clear();
                          });
                          _showFloatingNotification('Note Added', 'Saved to sticky notes queue');
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_pinnedNotes.isEmpty)
                  const Text('No notes pinned yet. Tap + to save one.', style: TextStyle(color: Colors.white70, fontSize: 12))
                else
                  Column(
                    children: _pinnedNotes.map((note) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const Icon(Icons.push_pin, size: 14, color: Colors.amber),
                            const SizedBox(width: 8),
                            Expanded(child: Text(note, style: const TextStyle(fontSize: 12, color: Colors.white), overflow: TextOverflow.ellipsis)),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 16, color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  _pinnedNotes.remove(note);
                                });
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
        ],
      ),
    );
  }

  // Helper Widget: Header Badge
  Widget _buildHeaderBadge(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurpleAccent.withOpacity(0.3), Colors.blueAccent.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.amber, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white), overflow: TextOverflow.ellipsis),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.white70), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget: System Stat Tile
  Widget _buildStatTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 9, color: Colors.white70), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  // Helper Widget: Sound Card
  Widget _buildSoundCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isPlaying,
    required VoidCallback onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isPlaying ? color : Colors.white70),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white), overflow: TextOverflow.ellipsis),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.white70), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          IconButton(
            style: IconButton.styleFrom(backgroundColor: isPlaying ? color : Colors.black87),
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: isPlaying ? Colors.black : Colors.white),
            onPressed: onToggle,
          ),
        ],
      ),
    );
  }
}