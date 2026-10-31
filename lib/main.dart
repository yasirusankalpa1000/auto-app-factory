import 'package:flutter/material.dart';

void main() {
  runApp(const FloatingCockpitApp());
}

class FloatingCockpitApp extends StatelessWidget {
  const FloatingCockpitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatingCockpit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121418),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentTab = 0;

  // Floating Overlay Service State
  bool _isOverlayEnabled = true;
  bool _showFloatingBubble = true;

  // Privacy Shield State
  bool _privacyShieldActive = true;
  double _privacyOpacity = 0.85;
  double _privacyHeight = 160.0;
  double _privacyYPosition = 220.0;
  Color _shieldColor = Colors.black;

  // Ambient Soundscape State
  bool _isPlayingSounds = false;
  double _volRain = 0.6;
  double _volWaves = 0.3;
  double _volCafe = 0.0;
  double _volFire = 0.4;

  // Quick Clipboard Vault State
  final List<Map<String, String>> _clipboardVault = [
    {
      'title': 'Work Email Signature',
      'content': 'Best regards,\nAlex Silva | Senior Project Lead\nalex@techcorp.io'
    },
    {
      'title': 'Bank Account Swift Info',
      'content': 'Account: 9876-5432-1002\nBank: Metro Capital Bank\nSWIFT: METROUS33'
    },
    {
      'title': 'Home Address Quick Share',
      'content': ' Apt 4B, 742 Evergreen Terrace, Springfield, OR 97477'
    },
    {
      'title': 'Standard Meeting RSVP',
      'content': 'Thanks for the invite! I will be joining the meeting on time.'
    },
  ];

  // Floating Quick Notes State
  final List<String> _quickNotes = [
    'Buy coffee beans on the way home',
    'Review quarterly budget report by 4 PM',
    'Call doctor for prescription update',
  ];

  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _clipTitleController = TextEditingController();
  final TextEditingController _clipContentController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    _clipTitleController.dispose();
    _clipContentController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Body Screens
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: IndexedStack(
                    index: _currentTab,
                    children: [
                      _buildCockpitTab(),
                      _buildPrivacyShieldTab(),
                      _buildAmbientSoundTab(),
                      _buildClipboardVaultTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Simulated Floating Privacy Shield Screen Overlay
          if (_privacyShieldActive)
            Positioned(
              top: _privacyYPosition,
              left: 0,
              right: 0,
              height: _privacyHeight,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  setState(() {
                    _privacyYPosition = (_privacyYPosition + details.delta.dy)
                        .clamp(80.0, MediaQuery.of(context).size.height - 200.0);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _shieldColor.withOpacity(_privacyOpacity),
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: Colors.teal.withOpacity(0.8),
                        width: 2,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.shield, color: Colors.teal, size: 20),
                              SizedBox(width: 8),
                              Text(
                                "PRIVACY SHIELD ACTIVE (Drag Up/Down)",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _privacyShieldActive = false;
                              });
                              _showSnackBar("Privacy Shield Hidden");
                            },
                            child: const Icon(Icons.visibility_off,
                                color: Colors.white70, size: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Simulated Floating Action Bubble Dock
          if (_isOverlayEnabled && _showFloatingBubble)
            Positioned(
              right: 16,
              bottom: 90,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(30),
                color: Colors.teal,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          _privacyShieldActive
                              ? Icons.shield
                              : Icons.security_outlined,
                          color: Colors.white,
                        ),
                        tooltip: "Toggle Privacy Shield",
                        onPressed: () {
                          setState(() {
                            _privacyShieldActive = !_privacyShieldActive;
                          });
                          _showSnackBar(_privacyShieldActive
                              ? "Privacy Shield Activated"
                              : "Privacy Shield Deactivated");
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          _isPlayingSounds ? Icons.volume_up : Icons.volume_off,
                          color: Colors.white,
                        ),
                        tooltip: "Toggle Ambient Sounds",
                        onPressed: () {
                          setState(() {
                            _isPlayingSounds = !_isPlayingSounds;
                          });
                          _showSnackBar(_isPlayingSounds
                              ? "Ambient Sounds Playing"
                              : "Ambient Sounds Muted");
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.content_copy, color: Colors.white),
                        tooltip: "Quick Copy Vault",
                        onPressed: () {
                          setState(() {
                            _currentTab = 3;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white70, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentTab,
          onTap: (index) {
            setState(() {
              _currentTab = index;
            });
          },
          backgroundColor: const Color(0xFF181B20),
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Cockpit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shield),
              label: 'Privacy Shield',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.waves),
              label: 'Ambient Sound',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.content_copy),
              label: 'Clipboard',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Color(0xFF181B20),
        border: Border(bottom: BorderSide(color: Colors.white70, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.apps, color: Colors.teal, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "FloatingCockpit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "System Floating Utility Hub",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Overlay",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Switch(
                value: _isOverlayEnabled,
                activeColor: Colors.teal,
                onChanged: (val) {
                  setState(() {
                    _isOverlayEnabled = val;
                    if (!val) {
                      _privacyShieldActive = false;
                      _showFloatingBubble = false;
                    } else {
                      _showFloatingBubble = true;
                    }
                  });
                  _showSnackBar(val
                      ? "Floating Dock Enabled"
                      : "Floating Dock Service Stopped");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TAB 1: COCKPIT OVERVIEW
  Widget _buildCockpitTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active System Status Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.teal.withOpacity(0.2),
                  Colors.blueGrey.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.circle, color: Colors.green, size: 12),
                        SizedBox(width: 8),
                        Text(
                          "SYSTEM OVERLAY ACTIVE",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Chip(
                      label: const Text(
                        "Draw Over Apps Ready",
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      backgroundColor: Colors.teal.withOpacity(0.4),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  "Keep FloatingCockpit accessible while using WhatsApp, banking apps, social media, or e-readers.",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            "Quick Controls",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Quick Toggle Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _buildControlTile(
                title: "Privacy Shield",
                subtitle: _privacyShieldActive ? "ACTIVE" : "OFF",
                icon: Icons.shield,
                isActive: _privacyShieldActive,
                onTap: () {
                  setState(() {
                    _privacyShieldActive = !_privacyShieldActive;
                  });
                },
              ),
              _buildControlTile(
                title: "Ambient Mixer",
                subtitle: _isPlayingSounds ? "PLAYING" : "MUTED",
                icon: Icons.waves,
                isActive: _isPlayingSounds,
                onTap: () {
                  setState(() {
                    _isPlayingSounds = !_isPlayingSounds;
                  });
                },
              ),
              _buildControlTile(
                title: "Floating Dock",
                subtitle: _showFloatingBubble ? "VISIBLE" : "HIDDEN",
                icon: Icons.widgets,
                isActive: _showFloatingBubble,
                onTap: () {
                  setState(() {
                    _showFloatingBubble = !_showFloatingBubble;
                  });
                },
              ),
              _buildControlTile(
                title: "Saved Snippets",
                subtitle: "${_clipboardVault.length} Items",
                icon: Icons.content_copy,
                isActive: true,
                onTap: () {
                  setState(() {
                    _currentTab = 3;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Quick Scratchpad / Notes Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Floating Quick Notes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.teal),
                onPressed: () => _showAddNoteDialog(),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _quickNotes.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2228),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white70),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit_note, color: Colors.teal, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _quickNotes[index],
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        softWrap: true,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey, size: 18),
                      onPressed: () {
                        setState(() {
                          _quickNotes.removeAt(index);
                        });
                        _showSnackBar("Note removed");
                      },
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

  Widget _buildControlTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? Colors.teal.withOpacity(0.15) : const Color(0xFF1E2228),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? Colors.teal : Colors.white70,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: isActive ? Colors.teal : Colors.grey, size: 26),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isActive ? Colors.teal : Colors.grey,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: PRIVACY PEEP SHIELD CUSTOMIZER
  Widget _buildPrivacyShieldTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2228),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.shield, color: Colors.teal),
                        SizedBox(width: 8),
                        Text(
                          "Peep Shield Overlay",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _privacyShieldActive,
                      activeColor: Colors.teal,
                      onChanged: (val) {
                        setState(() {
                          _privacyShieldActive = val;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Blocks side-viewers on public transport, cafes, or offices from reading your private chat screen or banking details.",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            "Shield Parameters",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Opacity Slider
          _buildSliderRow(
            label: "Shield Darkness Opacity",
            value: _privacyOpacity,
            min: 0.2,
            max: 0.98,
            displayValue: "${(_privacyOpacity * 100).toInt()}%",
            onChanged: (val) {
              setState(() {
                _privacyOpacity = val;
              });
            },
          ),
          const SizedBox(height: 16),

          // Height Slider
          _buildSliderRow(
            label: "Shield Band Height",
            value: _privacyHeight,
            min: 80.0,
            max: 400.0,
            displayValue: "${_privacyHeight.toInt()} px",
            onChanged: (val) {
              setState(() {
                _privacyHeight = val;
              });
            },
          ),
          const SizedBox(height: 16),

          // Y Position Slider
          _buildSliderRow(
            label: "Vertical Screen Position",
            value: _privacyYPosition,
            min: 60.0,
            max: 500.0,
            displayValue: "${_privacyYPosition.toInt()} Y",
            onChanged: (val) {
              setState(() {
                _privacyYPosition = val;
              });
            },
          ),
          const SizedBox(height: 24),

          const Text(
            "Shield Tint Color",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            children: [
              _buildColorOption(Colors.black, "Pitch Black"),
              _buildColorOption(const Color(0xFF0F172A), "Midnight Blue"),
              _buildColorOption(const Color(0xFF18181B), "Dark Charcoal"),
              _buildColorOption(const Color(0xFF022C22), "Deep Forest"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow({
    required String label,
    required double value,
    required double min,
    required double max,
    required String displayValue,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2228),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
              Text(
                displayValue,
                style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            activeColor: Colors.teal,
            inactiveColor: Colors.grey.shade800,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(Color color, String name) {
    bool isSelected = _shieldColor == color;
    return InkWell(
      onTap: () {
        setState(() {
          _shieldColor = color;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.teal : Colors.white70,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(Icons.check, color: Colors.teal, size: 14),
              const SizedBox(width: 4),
            ],
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 3: AMBIENT SOUNDSCAPE MIXER
  Widget _buildAmbientSoundTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2228),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.waves,
                          color: _isPlayingSounds ? Colors.teal : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Ambient Audio Engine",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isPlayingSounds
                          ? "Mixer active in background"
                          : "Background sound engine paused",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isPlayingSounds = !_isPlayingSounds;
                    });
                  },
                  icon: Icon(_isPlayingSounds ? Icons.pause : Icons.play_arrow),
                  label: Text(_isPlayingSounds ? "Pause" : "Play All"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            "Soundscape Multi-Track Sliders",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          _buildSoundTrack(
            name: "Soft Rainfall",
            icon: Icons.water_drop,
            volume: _volRain,
            onChanged: (v) => setState(() => _volRain = v),
          ),
          _buildSoundTrack(
            name: "Ocean Waves",
            icon: Icons.waves,
            volume: _volWaves,
            onChanged: (v) => setState(() => _volWaves = v),
          ),
          _buildSoundTrack(
            name: "Cozy Fireplace",
            icon: Icons.local_fire_department,
            volume: _volFire,
            onChanged: (v) => setState(() => _volFire = v),
          ),
          _buildSoundTrack(
            name: "Coffee Shop Ambience",
            icon: Icons.coffee,
            volume: _volCafe,
            onChanged: (v) => setState(() => _volCafe = v),
          ),
        ],
      ),
    );
  }

  Widget _buildSoundTrack({
    required String name,
    required IconData icon,
    required double volume,
    required ValueChanged<double> onChanged,
  }) {
    bool isActive = volume > 0 && _isPlayingSounds;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2228),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? Colors.teal.withOpacity(0.5) : Colors.white70,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: isActive ? Colors.teal : Colors.grey, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              Text(
                "${(volume * 100).toInt()}%",
                style: TextStyle(
                  color: isActive ? Colors.teal : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Slider(
            value: volume,
            min: 0.0,
            max: 1.0,
            activeColor: Colors.teal,
            inactiveColor: Colors.grey.shade800,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // TAB 4: QUICK CLIPBOARD VAULT
  Widget _buildClipboardVaultTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Quick Clipboard Vault",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "1-Tap paste templates for emails, banking, & messages",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _showAddSnippetDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                child: const Text("+ Add"),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _clipboardVault.length,
            itemBuilder: (context, index) {
              final item = _clipboardVault[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2228),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white70),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['title'] ?? '',
                          style: const TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.content_copy,
                                  color: Colors.white70, size: 18),
                              onPressed: () {
                                _showSnackBar("Copied '${item['title']}' to Clipboard!");
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.grey, size: 18),
                              onPressed: () {
                                setState(() {
                                  _clipboardVault.removeAt(index);
                                });
                                _showSnackBar("Snippet deleted");
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['content'] ?? '',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
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

  void _showAddNoteDialog() {
    _noteController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E2228),
          title: const Text("Add Quick Floating Note",
              style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: _noteController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Enter note text...",
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (_noteController.text.isNotEmpty) {
                  setState(() {
                    _quickNotes.add(_noteController.text);
                  });
                  Navigator.pop(context);
                  _showSnackBar("Quick Note Saved");
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showAddSnippetDialog() {
    _clipTitleController.clear();
    _clipContentController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E2228),
          title: const Text("Add Clipboard Vault Item",
              style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _clipTitleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Title (e.g. My Phone Number)",
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _clipContentController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Snippet Text",
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (_clipTitleController.text.isNotEmpty &&
                    _clipContentController.text.isNotEmpty) {
                  setState(() {
                    _clipboardVault.add({
                      'title': _clipTitleController.text,
                      'content': _clipContentController.text,
                    });
                  });
                  Navigator.pop(context);
                  _showSnackBar("Snippet Added to Vault");
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}