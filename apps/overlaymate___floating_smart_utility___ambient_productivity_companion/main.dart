import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const OverlayMateApp());
}

class OverlayMateApp extends StatelessWidget {
  const OverlayMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlayMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.amberAccent,
          surface: Color(0xFF1E293B),
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

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  bool _isBubbleEnabled = true;
  bool _isPrivacyShieldActive = false;
  bool _isNotificationBannerVisible = true;
  double _bubbleX = 20.0;
  double _bubbleY = 220.0;
  bool _showFloatingMenu = false;

  final List<String> _quickNotifications = [
    '💡 Quick Tip: Double tap bubble to clip current screen text',
    '⚡ Bionic Reader ready: 1 snippet saved in stash',
    '🎧 Ambient Soundscape "Midnight Rain" playing in background',
  ];
  int _activeNotificationIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildFloatingHudTab(),
      const SpeedReaderTab(),
      const AmbientVisualizerTab(),
      const StashAndDecisionTab(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildTopAppBar(),
                if (_isNotificationBannerVisible) _buildFloatingBanner(),
                Expanded(child: screens[_currentIndex]),
              ],
            ),
          ),

          // Privacy Dimming Overlay Simulation
          if (_isPrivacyShieldActive)
            IgnorePointer(
              ignoring: false,
              child: Container(
                color: Colors.black.withOpacity(0.75),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.visibility_off, size: 48, color: Colors.tealAccent),
                      const SizedBox(height: 12),
                      const Text(
                        'Privacy Shield Active',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap button below to reveal screen',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPrivacyShieldActive = false;
                          });
                        },
                        icon: const Icon(Icons.remove_red_eye),
                        label: const Text('Disable Shield'),
                      )
                    ],
                  ),
                ),
              ),
            ),

          // Simulated Interactive System Floating Bubble
          if (_isBubbleEnabled && !_isPrivacyShieldActive) _buildDraggableFloatingBubble(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Overlay HUD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.speed),
            label: 'Speed Reader',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.graphic_eq),
            label: 'Ambient Sound',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Stash & Choice',
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF1E293B),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.tealAccent.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bubble_chart, color: Colors.tealAccent, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OverlayMate Pro',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Floating Utility & Screen Companion',
                  style: TextStyle(fontSize: 11, color: Colors.tealAccent),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _isBubbleEnabled ? Icons.sensors : Icons.sensors_off,
              color: _isBubbleEnabled ? Colors.tealAccent : Colors.grey,
            ),
            tooltip: 'Toggle Dynamic Overlay Bubble',
            onPressed: () {
              setState(() {
                _isBubbleEnabled = !_isBubbleEnabled;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isBubbleEnabled ? 'Floating Widget Overlay Enabled' : 'Overlay Disabled'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBanner() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade800, Colors.indigo.shade900],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black87, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: Colors.amberAccent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _quickNotifications[_activeNotificationIndex],
              style: const TextStyle(fontSize: 12, color: Colors.white),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _activeNotificationIndex = (_activeNotificationIndex + 1) % _quickNotifications.length;
              });
            },
            child: const Icon(Icons.refresh, color: Colors.white70, size: 18),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _isNotificationBannerVisible = false;
              });
            },
            child: const Icon(Icons.close, color: Colors.white70, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableFloatingBubble() {
    return Positioned(
      left: _bubbleX,
      top: _bubbleY,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubbleX += details.delta.dx;
            _bubbleY += details.delta.dy;
          });
        },
        onTap: () {
          setState(() {
            _showFloatingMenu = !_showFloatingMenu;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.tealAccent, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.tealAccent.withOpacity(0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.bolt, color: Colors.black, size: 30),
            ),
            if (_showFloatingMenu) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.tealAccent, width: 1.5),
                  boxShadow: const [
                    BoxShadow(color: Colors.black87, blurRadius: 10),
                  ],
                ),
                child: Column(
                  children: [
                    _buildBubbleMenuItem(
                      icon: Icons.visibility_off,
                      label: 'Privacy Dim',
                      onTap: () {
                        setState(() {
                          _isPrivacyShieldActive = true;
                          _showFloatingMenu = false;
                        });
                      },
                    ),
                    _buildBubbleMenuItem(
                      icon: Icons.speed,
                      label: 'Speed Reader',
                      onTap: () {
                        setState(() {
                          _currentIndex = 1;
                          _showFloatingMenu = false;
                        });
                      },
                    ),
                    _buildBubbleMenuItem(
                      icon: Icons.graphic_eq,
                      label: 'Audio Ambient',
                      onTap: () {
                        setState(() {
                          _currentIndex = 2;
                          _showFloatingMenu = false;
                        });
                      },
                    ),
                    _buildBubbleMenuItem(
                      icon: Icons.casino,
                      label: 'Choice Spinner',
                      onTap: () {
                        setState(() {
                          _currentIndex = 3;
                          _showFloatingMenu = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildBubbleMenuItem({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.tealAccent),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingHudTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusHeaderCard(),
          const SizedBox(height: 16),
          const Text(
            'Smart Floating Controls',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          _buildControlTile(
            title: 'Display Above Other Apps',
            subtitle: 'Allows floating tools over any application',
            icon: Icons.layers,
            value: _isBubbleEnabled,
            onChanged: (val) => setState(() => _isBubbleEnabled = val),
          ),
          _buildControlTile(
            title: 'Privacy Screen Mask',
            subtitle: 'Darken screen instantly for private browsing',
            icon: Icons.visibility_off,
            value: _isPrivacyShieldActive,
            onChanged: (val) => setState(() => _isPrivacyShieldActive = val),
          ),
          const SizedBox(height: 20),
          const Text(
            'Quick Floating Overlay Tools',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildToolCard(
                title: 'Bionic Reader',
                desc: 'Read articles 3x faster with floating focus WPM engine',
                icon: Icons.speed,
                color: Colors.teal,
                onTap: () => setState(() => _currentIndex = 1),
              ),
              _buildToolCard(
                title: 'Ambient Waves',
                desc: 'Focus music & rain mixer for high screen retention',
                icon: Icons.graphic_eq,
                color: Colors.indigo,
                onTap: () => setState(() => _currentIndex = 2),
              ),
              _buildToolCard(
                title: 'Snippet Stash',
                desc: 'Instant clipboard holder across multi-apps',
                icon: Icons.content_copy,
                color: Colors.amber.shade800,
                onTap: () => setState(() => _currentIndex = 3),
              ),
              _buildToolCard(
                title: 'Micro Spinner',
                desc: 'Solve decision fatigue on the go',
                icon: Icons.casino,
                color: Colors.purple,
                onTap: () => setState(() => _currentIndex = 3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF1E1B4B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black87, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flash_on, color: Colors.amberAccent, size: 28),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Overlay Active Session',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.tealAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'RUNNING',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Keep OverlayMate active to access speed reader, clipboard stash, and soundscapes from any screen on your device!',
            style: TextStyle(color: Colors.white70, fontSize: 13),
            softWrap: true,
          ),
        ],
      ),
    );
  }

  Widget _buildControlTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        secondary: Icon(icon, color: Colors.tealAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        value: value,
        activeColor: Colors.tealAccent,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildToolCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final width = (MediaQuery.of(context).size.width - 44) / 2;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.5), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              radius: 20,
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              desc,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ================= SPEED READER TAB =================
class SpeedReaderTab extends StatefulWidget {
  const SpeedReaderTab({super.key});

  @override
  State<SpeedReaderTab> createState() => _SpeedReaderTabState();
}

class _SpeedReaderTabState extends State<SpeedReaderTab> {
  final TextEditingController _textController = TextEditingController(
    text: 'OverlayMate Bionic Speed Reader enables human brains to process words much faster by focusing eyes on highlighted dynamic anchor points without manual scrolling.',
  );
  List<String> _words = [];
  int _currentWordIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;
  int _wpm = 300;

  @override
  void initState() {
    super.initState();
    _updateWords();
  }

  void _updateWords() {
    setState(() {
      _words = _textController.text.trim().split(RegExp(r'\s+'));
      if (_currentWordIndex >= _words.length) {
        _currentWordIndex = 0;
      }
    });
  }

  void _togglePlay() {
    if (_isPlaying) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }

  void _startTimer() {
    if (_words.isEmpty) return;
    setState(() => _isPlaying = true);
    final intervalMs = (60000 / _wpm).round();
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      if (_currentWordIndex < _words.length - 1) {
        setState(() {
          _currentWordIndex++;
        });
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isPlaying = false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWord = _words.isNotEmpty && _currentWordIndex < _words.length ? _words[_currentWordIndex] : '';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bionic Speed Reader Engine',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            const Text(
              'Read articles & snippets without moving your eyes or scrolling!',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Speed Reader Box
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF020617),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.tealAccent.withOpacity(0.4), width: 1.5),
                boxShadow: const [
                  BoxShadow(color: Colors.black87, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentWord.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.tealAccent,
                        letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Word ${_words.isEmpty ? 0 : _currentWordIndex + 1} of ${_words.length}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Playback Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 32,
                  icon: const Icon(Icons.replay_10, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _currentWordIndex = max(0, _currentWordIndex - 10);
                    });
                  },
                ),
                const SizedBox(width: 16),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.tealAccent,
                  child: IconButton(
                    iconSize: 32,
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.black),
                    onPressed: _togglePlay,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  iconSize: 32,
                  icon: const Icon(Icons.forward_10, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _currentWordIndex = min(_words.length - 1, _currentWordIndex + 10);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // WPM Speed Slider
            Row(
              children: [
                const Icon(Icons.speed, color: Colors.tealAccent, size: 20),
                const SizedBox(width: 8),
                Text('Speed: $_wpm WPM', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: _wpm.toDouble(),
              min: 100,
              max: 700,
              divisions: 12,
              activeColor: Colors.tealAccent,
              inactiveColor: Colors.grey.shade800,
              label: '$_wpm WPM',
              onChanged: (val) {
                setState(() {
                  _wpm = val.round();
                });
                if (_isPlaying) {
                  _startTimer();
                }
              },
            ),
            const SizedBox(height: 16),

            // Input Text Field
            TextField(
              controller: _textController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: const InputDecoration(
                labelText: 'Paste text or article snippet to read',
                labelStyle: TextStyle(color: Colors.tealAccent),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.tealAccent),
                ),
              ),
              onChanged: (_) => _updateWords(),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== AMBIENT VISUALIZER & FOCUS TAB ==========
class AmbientVisualizerTab extends StatefulWidget {
  const AmbientVisualizerTab({super.key});

  @override
  State<AmbientVisualizerTab> createState() => _AmbientVisualizerTabState();
}

class _AmbientVisualizerTabState extends State<AmbientVisualizerTab> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isPlayingSound = true;

  final Map<String, double> _tracks = {
    'Midnight Rain': 0.8,
    'Cafe Ambience': 0.4,
    'Deep Space Synth': 0.6,
    'Forest Wind': 0.2,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ambient Soundscape & Wave',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Background audio retention engine for focus',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(_isPlayingSound ? Icons.pause_circle_filled : Icons.play_circle_filled,
                      color: Colors.amberAccent, size: 36),
                  onPressed: () {
                    setState(() {
                      _isPlayingSound = !_isPlayingSound;
                    });
                  },
                )
              ],
            ),
            const SizedBox(height: 16),

            // Animated Visualizer Box
            Container(
              height: 130,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amberAccent.withOpacity(0.3)),
              ),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(16, (index) {
                      final randomMultiplier = (index % 5 + 1) * 0.18;
                      final height = _isPlayingSound
                          ? (20 + (80 * (_animationController.value * randomMultiplier)))
                          : 8.0;
                      return Container(
                        width: 10,
                        height: height,
                        decoration: BoxDecoration(
                          color: index.isEven ? Colors.tealAccent : Colors.amberAccent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Multi-Track Sound Mixer',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),

            ..._tracks.keys.map((trackName) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.volume_up, color: Colors.tealAccent, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            trackName,
                            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                        Text(
                          '${(_tracks[trackName]! * 100).round()}%',
                          style: const TextStyle(color: Colors.amberAccent, fontSize: 12),
                        ),
                      ],
                    ),
                    Slider(
                      value: _tracks[trackName]!,
                      activeColor: Colors.tealAccent,
                      inactiveColor: Colors.grey.shade800,
                      onChanged: (val) {
                        setState(() {
                          _tracks[trackName] = val;
                        });
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// ========== STASH & DECISION SPINNER TAB ==========
class StashAndDecisionTab extends StatefulWidget {
  const StashAndDecisionTab({super.key});

  @override
  State<StashAndDecisionTab> createState() => _StashAndDecisionTabState();
}

class _StashAndDecisionTabState extends State<StashAndDecisionTab> {
  final List<String> _snippets = [
    '📍 Address: 124 Dynamic Overlay Hub, Tech Park',
    '🔗 Link: https://flutter.dev/docs',
    '💡 Idea: Speed reader overlay with bionic focus anchor',
  ];
  final TextEditingController _snippetController = TextEditingController();

  final List<String> _choices = ['Order Pizza', 'Cook Rice', 'Eat Salad', 'Burgers'];
  int _selectedChoiceIndex = 0;
  bool _isSpinning = false;

  void _spinWheel() {
    if (_isSpinning) return;
    setState(() => _isSpinning = true);
    final random = Random();
    int spins = random.nextInt(15) + 10;
    int counter = 0;

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _selectedChoiceIndex = (_selectedChoiceIndex + 1) % _choices.length;
      });
      counter++;
      if (counter >= spins) {
        timer.cancel();
        setState(() => _isSpinning = false);
      }
    });
  }

  void _addSnippet() {
    if (_snippetController.text.trim().isNotEmpty) {
      setState(() {
        _snippets.insert(0, _snippetController.text.trim());
        _snippetController.clear();
      });
    }
  }

  @override
  void dispose() {
    _snippetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Micro Choice Decision Wheel Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.purpleAccent.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.casino, color: Colors.purpleAccent),
                      SizedBox(width: 8),
                      Text(
                        'Micro Decision Spinner',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Eliminate choice fatigue during daily routines',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade900,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.purpleAccent),
                          ),
                          child: Text(
                            _choices[_selectedChoiceIndex],
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: _isSpinning ? null : _spinWheel,
                          icon: const Icon(Icons.refresh),
                          label: Text(_isSpinning ? 'Spinning...' : 'Spin Decision Wheel'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Snippet Pinboard / Stash
            const Text(
              'Instant Snippet Pinboard Stash',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _snippetController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Type address, link, or snippet to save...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onPressed: _addSnippet,
                  child: const Icon(Icons.add),
                )
              ],
            ),
            const SizedBox(height: 12),

            ..._snippets.map((item) {
              return Card(
                color: const Color(0xFF0F172A),
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(item, style: const TextStyle(fontSize: 13, color: Colors.white)),
                  trailing: IconButton(
                    icon: const Icon(Icons.content_copy, color: Colors.tealAccent, size: 18),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied snippet to clipboard!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}