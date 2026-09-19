import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const ShieldPeekApp());
}

class ShieldPeekApp extends StatelessWidget {
  const ShieldPeekApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShieldPeek',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF10141D),
        colorScheme: const ColorScheme.dark(
          primary: Colors.teal,
          secondary: Colors.amber,
          surface: Color(0xFF1E2430),
          background: Color(0xFF10141D),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1E2430),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        useMaterial3: true,
      ),
      home: const MainDashboard(),
    );
  }
}

class MainDashboard extends StatefulWidget {
  const MainDashboard({Key? key}) : super(key: key);

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;

  // Filter Settings
  double _filterOpacity = 0.75;
  double _stripPosition = 0.35; // 0.0 to 0.8
  double _stripHeight = 0.22; // height of visible aperture
  String _filterStyle = 'Strip'; // 'Strip', 'Matrix', 'Frosted', 'Blackout'
  bool _isFloatingDeckActive = true;
  bool _showTopNotificationBar = false;
  String _lastNotificationText = '';

  // Snoop Guard State
  bool _motionGuardEnabled = true;
  int _snoopAttemptsBlocked = 18;
  int _privacyScore = 94;

  // Secret Scratchpad
  final List<String> _scratchpadNotes = [
    'Bank Account PIN: 8**4 (Hidden)',
    'Confidential meeting code: #9021',
    'Private Wi-Fi: PrivacyVault_5G',
  ];
  final TextEditingController _noteController = TextEditingController();

  void _triggerNotificationToast(String message) {
    setState(() {
      _lastNotificationText = message;
      _showTopNotificationBar = true;
    });
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showTopNotificationBar = false;
        });
      }
    });
  }

  void _addNewNote() {
    if (_noteController.text.trim().isNotEmpty) {
      setState(() {
        _scratchpadNotes.add(_noteController.text.trim());
        _noteController.clear();
      });
      _triggerNotificationToast('Secret note encrypted and saved!');
    }
  }

  void _deleteNote(int index) {
    setState(() {
      _scratchpadNotes.removeAt(index);
    });
    _triggerNotificationToast('Secret note deleted securely.');
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildShieldStudioTab(),
                _buildCamouflageTab(),
                _buildFloatingDeckTab(),
                _buildSnoopAnalyticsTab(),
              ],
            ),
          ),

          // Simulated Top Floating System Notification Bar
          if (_showTopNotificationBar)
            Positioned(
              top: 40,
              left: 16,
              right: 16,
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFF2A324B),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.teal.withOpacity(0.5), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shield, color: Colors.teal, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'ShieldPeek Privacy Guard',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _lastNotificationText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey, size: 18),
                        onPressed: () {
                          setState(() {
                            _showTopNotificationBar = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Simulated Floating Quick Deck Widget Overlay
          if (_isFloatingDeckActive)
            Positioned(
              right: 12,
              bottom: 110,
              child: DynamicFloatingDeckWidget(
                onCamouflageTrigger: () {
                  _launchCamouflageOverlay(context, 'update');
                },
                onQuickShieldToggle: () {
                  setState(() {
                    _filterOpacity = _filterOpacity > 0.3 ? 0.15 : 0.85;
                  });
                  _triggerNotificationToast(
                    _filterOpacity > 0.3 ? 'Privacy Mask Opacity Boosted!' : 'Privacy Mask Dimmed',
                  );
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF2D3548), width: 0.8)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: const Color(0xFF141923),
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.visibility_off),
              label: 'Shield Studio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.phonelink_setup),
              label: 'Camouflage',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              label: 'Floating Deck',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.security),
              label: 'Snoop Guard',
            ),
          ],
        ),
      ),
    );
  }

  // ================= TAB 1: SHIELD STUDIO =================
  Widget _buildShieldStudioTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            title: 'Anti-Peeking Filter Studio',
            subtitle: 'Real-time screen mask & aperture strip control',
            icon: Icons.layers,
          ),
          const SizedBox(height: 16),

          // Interactive Phone Preview Simulation Frame
          Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.teal.withOpacity(0.6), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.15),
                  blurRadius: 12,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Stack(
              children: [
                // Simulated Private Screen Content
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              radius: 14,
                              child: Icon(Icons.person, size: 16, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Private Chat with Legal Advisor',
                              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(4)),
                              child: const Text('CONFIDENTIAL', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                        const Divider(color: Colors.white70, height: 16),
                        const Text(
                          'Message: The acquisition agreement details are ready. Transfer amount is \$24,500. Do not share this code: 9912.',
                          style: TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: const Color(0xFF2A2D3A), borderRadius: BorderRadius.circular(8)),
                          child: const Row(
                            children: [
                              Icon(Icons.lock, color: Colors.amber, size: 16),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Encrypted Bank Vault Code: #8892-X10',
                                  style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                // Dynamic Anti-Snoop Overlay Filter
                Positioned.fill(
                  child: IgnorePointer(
                    child: DynamicPrivacyOverlay(
                      opacity: _filterOpacity,
                      stripPosition: _stripPosition,
                      stripHeight: _stripHeight,
                      styleMode: _filterStyle,
                    ),
                  ),
                ),

                // Draggable Visual Strip Slider Control Overlay
                Positioned(
                  left: 12,
                  right: 12,
                  top: 280 * _stripPosition,
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      setState(() {
                        double newPos = _stripPosition + (details.delta.dy / 280);
                        _stripPosition = newPos.clamp(0.0, 0.75);
                      });
                    },
                    child: Container(
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [BoxShadow(color: Colors.black87, blurRadius: 4)],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.drag_handle, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Drag to move clear reading slot',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Controls & Sliders
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Mask Style', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Strip', 'Matrix', 'Frosted', 'Blackout'].map((mode) {
                      bool isSelected = _filterStyle == mode;
                      return ChoiceChip(
                        label: Text(mode),
                        selected: isSelected,
                        selectedColor: Colors.teal,
                        backgroundColor: const Color(0xFF2A324B),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _filterStyle = mode);
                            _triggerNotificationToast('Mask style set to $mode');
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const Divider(height: 24, color: Colors.white70),

                  // Filter Opacity Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Mask Darkness / Opacity', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      Text('${(_filterOpacity * 100).toInt()}%', style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: _filterOpacity,
                    min: 0.1,
                    max: 0.95,
                    activeColor: Colors.teal,
                    inactiveColor: Colors.white70,
                    onChanged: (val) => setState(() => _filterOpacity = val),
                  ),

                  // Reading Slot Height Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Reading Slot Height', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      Text('${(_stripHeight * 100).toInt()}%', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: _stripHeight,
                    min: 0.10,
                    max: 0.45,
                    activeColor: Colors.amber,
                    inactiveColor: Colors.white70,
                    onChanged: (val) => setState(() => _stripHeight = val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // AdMob Placeholder Banner Card
          _buildAdMobBannerCard(),
        ],
      ),
    );
  }

  // ================= TAB 2: CAMOUFLAGE SCREENS =================
  Widget _buildCamouflageTab() {
    final List<Map<String, dynamic>> camouflageTypes = [
      {
        'id': 'update',
        'title': 'Fake System Update',
        'desc': 'Triggers a realistic "Installing System Update 84%" screen to stop peeping.',
        'icon': Icons.system_update,
        'color': Colors.blueAccent,
      },
      {
        'id': 'battery',
        'title': 'Fake Low Battery 1%',
        'desc': 'Shows a realistic OS Low Battery Shutdown warning pop-up.',
        'icon': Icons.battery_alert,
        'color': Colors.redAccent,
      },
      {
        'id': 'call',
        'title': 'Fake Urgent Call',
        'desc': 'Simulates an incoming urgent phone call from "Strict Boss".',
        'icon': Icons.phone_in_talk,
        'color': Colors.green,
      },
      {
        'id': 'bsod',
        'title': 'Fake System Crash (BSOD)',
        'desc': 'Displays a technical system diagnostic error screen.',
        'icon': Icons.bug_report,
        'color': Colors.purpleAccent,
      },
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            title: 'Camouflage Screen Launcher',
            subtitle: 'Instant full-screen disguises to instantly hide your phone activity',
            icon: Icons.phonelink_setup,
          ),
          const SizedBox(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: camouflageTypes.length,
            itemBuilder: (context, index) {
              final item = camouflageTypes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (item['color'] as Color).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['desc'] as String,
                              style: const TextStyle(color: Colors.white70, fontSize: 11),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onPressed: () => _launchCamouflageOverlay(context, item['id'] as String),
                        child: const Text('Launch', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildAdMobBannerCard(),
        ],
      ),
    );
  }

  // ================= TAB 3: FLOATING DECK & SCRATCHPAD =================
  Widget _buildFloatingDeckTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            title: 'Floating Deck & Secret Scratchpad',
            subtitle: 'Quick access widget bubbles and encrypted floating notes',
            icon: Icons.widgets,
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.touch_app, color: Colors.amber, size: 30),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Floating Screen Bubble',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _isFloatingDeckActive ? 'Bubble is active on edge of screen' : 'Floating bubble disabled',
                          style: const TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isFloatingDeckActive,
                    activeColor: Colors.teal,
                    onChanged: (val) {
                      setState(() => _isFloatingDeckActive = val);
                      _triggerNotificationToast(val ? 'Floating deck bubble enabled' : 'Floating deck bubble hidden');
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Secret Floating Scratchpad Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lock, color: Colors.teal, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Secret Scratchpad (Encrypted)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const Spacer(),
                      Text(
                        '${_scratchpadNotes.length} notes',
                        style: const TextStyle(color: Colors.teal, fontSize: 11, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _noteController,
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Type secret note or code...',
                            hintStyle: const TextStyle(color: Colors.white70, fontSize: 12),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: const Color(0xFF141923),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        style: IconButton.styleFrom(backgroundColor: Colors.teal),
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: _addNewNote,
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _scratchpadNotes.length,
                    itemBuilder: (context, idx) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141923),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white70),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.key, size: 14, color: Colors.amber),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _scratchpadNotes[idx],
                                style: const TextStyle(fontSize: 12, color: Colors.white70),
                                softWrap: true,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 16, color: Colors.redAccent),
                              onPressed: () => _deleteNote(idx),
                            )
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildAdMobBannerCard(),
        ],
      ),
    );
  }

  // ================= TAB 4: SNOOP GUARD ANALYTICS =================
  Widget _buildSnoopAnalyticsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            title: 'Snoop Guard & Analytics',
            subtitle: 'Motion tilt alerts, privacy score, and security history',
            icon: Icons.security,
          ),
          const SizedBox(height: 16),

          // Privacy Score Card
          Card(
            color: const Color(0xFF172D3A),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: CircularProgressIndicator(
                          value: _privacyScore / 100,
                          strokeWidth: 6,
                          color: Colors.teal,
                          backgroundColor: Colors.white70,
                        ),
                      ),
                      Text(
                        '$_privacyScore%',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                      )
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Privacy Shield Rating',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Your screen is well protected against shoulder peeking in public.',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          children: [
                            Chip(
                              label: const Text('High Protection', style: TextStyle(fontSize: 9, color: Colors.white)),
                              backgroundColor: Colors.teal.withOpacity(0.4),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Motion Pick-Up Guard Toggle
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.screen_lock_portrait, color: Colors.deepOrange, size: 26),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pick-Up Motion Snoop Guard',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Triggers a discrete vibration pulse when device is tilted or moved unexpectedly.',
                              style: TextStyle(color: Colors.white70, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _motionGuardEnabled,
                        activeColor: Colors.teal,
                        onChanged: (val) {
                          setState(() => _motionGuardEnabled = val);
                          _triggerNotificationToast(val ? 'Motion Snoop Guard Activated' : 'Motion Guard Disabled');
                        },
                      )
                    ],
                  ),
                  const Divider(height: 20, color: Colors.white70),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Snoop Pick-Up Attempts Blocked:', style: TextStyle(fontSize: 12, color: Colors.white70)),
                      Text('$_snoopAttemptsBlocked', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal)),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Security Audit Checklist
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Daily Privacy Checklist', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  _buildCheckItem('Notification previews hidden on lockscreen', true),
                  _buildCheckItem('Anti-Peeking Filter active on chat apps', true),
                  _buildCheckItem('Camouflage gesture assigned', true),
                  _buildCheckItem('Screen timeout set under 30 seconds', false),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildAdMobBannerCard(),
        ],
      ),
    );
  }

  // ================= HELPER WIDGETS =================
  Widget _buildHeader({required String title, required String subtitle, required IconData icon}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.teal, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: Colors.white70),
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCheckItem(String text, bool checked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            checked ? Icons.check_circle : Icons.error_outline,
            color: checked ? Colors.teal : Colors.amber,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: checked ? Colors.white70 : Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdMobBannerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2230),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white70),
      ),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.monetization_on, color: Colors.amber, size: 14),
              SizedBox(width: 6),
              Text(
                'ADVERTISEMENT SPACE (ADMOB READY)',
                style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            'Support ShieldPeek Free Privacy Tools - Banner Ad Placement (\$0.00)',
            style: TextStyle(color: Colors.white70, fontSize: 9),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Camouflage Fullscreen Overlay Launcher
  void _launchCamouflageOverlay(BuildContext context, String type) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CamouflageScreenOverlay(type: type),
      ),
    );
  }
}

// Custom Dynamic Privacy Overlay Painter Widget
class DynamicPrivacyOverlay extends StatelessWidget {
  final double opacity;
  final double stripPosition;
  final double stripHeight;
  final String styleMode;

  const DynamicPrivacyOverlay({
    Key? key,
    required this.opacity,
    required this.stripPosition,
    required this.stripHeight,
    required this.styleMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (styleMode == 'Blackout') {
      return Container(color: Colors.black.withOpacity(opacity));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double topHeight = constraints.maxHeight * stripPosition;
        double apertureH = constraints.maxHeight * stripHeight;
        double bottomHeight = constraints.maxHeight - (topHeight + apertureH);
        if (bottomHeight < 0) bottomHeight = 0;

        Color maskColor = styleMode == 'Matrix' ? Colors.green.shade900 : Colors.black;

        return Column(
          children: [
            // Top Dark Mask
            Container(
              height: topHeight,
              width: double.infinity,
              color: maskColor.withOpacity(opacity),
              child: styleMode == 'Matrix'
                  ? const Center(
                      child: Text('0101010101 PRIVATE DATA ENCRYPTED 10101010',
                          style: TextStyle(color: Colors.greenAccent, fontSize: 10)))
                  : null,
            ),
            // Middle Clear Aperture Window
            Container(
              height: apertureH,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(color: Colors.teal.withOpacity(0.8), width: 1.5),
                ),
              ),
            ),
            // Bottom Dark Mask
            Expanded(
              child: Container(
                width: double.infinity,
                color: maskColor.withOpacity(opacity),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Dynamic Floating Deck Widget Overlay Simulation
class DynamicFloatingDeckWidget extends StatelessWidget {
  final VoidCallback onCamouflageTrigger;
  final VoidCallback onQuickShieldToggle;

  const DynamicFloatingDeckWidget({
    Key? key,
    required this.onCamouflageTrigger,
    required this.onQuickShieldToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2638).withOpacity(0.95),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.teal, width: 1.5),
          boxShadow: const [BoxShadow(color: Colors.black87, blurRadius: 10)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onQuickShieldToggle,
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.teal,
                child: Icon(Icons.visibility_off, color: Colors.white, size: 18),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: onCamouflageTrigger,
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.flash_on, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Camouflage Screen Overlay Widget
class CamouflageScreenOverlay extends StatefulWidget {
  final String type;

  const CamouflageScreenOverlay({Key? key, required this.type}) : super(key: key);

  @override
  State<CamouflageScreenOverlay> createState() => _CamouflageScreenOverlayState();
}

class _CamouflageScreenOverlayState extends State<CamouflageScreenOverlay> {
  double _progress = 0.84;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.type == 'update') {
      _timer = Timer.periodic(const Duration(milliseconds: 600), (t) {
        if (mounted) {
          setState(() {
            _progress += 0.01;
            if (_progress >= 0.99) _progress = 0.84;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onDoubleTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: [
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: _buildCamouflageBody(),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(12)),
                child: const Text('Double tap anywhere to exit', style: TextStyle(color: Colors.white70, fontSize: 10)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCamouflageBody() {
    switch (widget.type) {
      case 'update':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.blueAccent, strokeWidth: 3),
            const SizedBox(height: 30),
            const Text(
              'Installing System Update...',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              '${(_progress * 100).toInt()}% completed',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(value: _progress, backgroundColor: Colors.white70, color: Colors.blueAccent),
            ),
            const SizedBox(height: 40),
            const Text(
              'Do not turn off your phone or unplug the battery.',
              style: TextStyle(color: Colors.white70, fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        );

      case 'battery':
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF222630),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.battery_alert, color: Colors.redAccent, size: 54),
              const SizedBox(height: 16),
              const Text(
                'Power Off Warning',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your battery level has dropped to 1%. Your device will shut down immediately.',
                style: TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Powering Off...', style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        );

      case 'call':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 48, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text('Strict Boss', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Incoming Urgent Call...', style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.call_end, color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.call, color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        );

      case 'bsod':
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: