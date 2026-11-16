import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const FloatDockApp());
}

class FloatDockApp extends StatelessWidget {
  const FloatDockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatDock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainDockScreen(),
    );
  }
}

class MainDockScreen extends StatefulWidget {
  const MainDockScreen({super.key});

  @override
  State<MainDockScreen> createState() => _MainDockScreenState();
}

class _MainDockScreenState extends State<MainDockScreen> {
  int _currentIndex = 0;
  
  // Floating Overlay Control State
  bool _isOverlayEnabled = true;
  bool _isBubbleExpanded = false;
  Offset _bubblePosition = const Offset(280, 220);
  String _activeWidget = 'None';
  
  // Clipboard Items State
  final List<Map<String, String>> _clipboardItems = [
    {'type': 'Link', 'text': 'https://flutter.dev/docs', 'time': '10 mins ago'},
    {'type': 'Number', 'text': '+1 800 555 0199', 'time': '25 mins ago'},
    {'type': 'Code', 'text': 'PASS-2025-X99', 'time': '1 hour ago'},
    {'type': 'Text', 'text': 'Buy groceries: Milk, Eggs, Almonds', 'time': '2 hours ago'},
  ];
  final TextEditingController _clipInputController = TextEditingController();
  
  // Floating Notes State
  final List<String> _quickNotes = [
    'Call manager at 4 PM',
    'Review project draft code',
    'Pay utility bills before Friday'
  ];
  final TextEditingController _noteInputController = TextEditingController();

  // Monetization & Retention Session Tracker State
  int _sessionSeconds = 0;
  int _rewardPoints = 120;
  Timer? _sessionTimer;

  // Decision Wheel State
  final List<String> _decisionOptions = ['Option A', 'Option B', 'Option C', 'Option D'];
  String _selectedDecision = 'Tap Spin to Decide!';

  @override
  void initState() {
    super.initState();
    _startSessionTimer();
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _clipInputController.dispose();
    _noteInputController.dispose();
    super.dispose();
  }

  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _sessionSeconds++;
          if (_sessionSeconds % 10 == 0) {
            _rewardPoints += 5; // Earn points for staying in app
          }
        });
      }
    });
  }

  void _addClipboardItem(String text) {
    if (text.trim().isEmpty) return;
    String category = 'Text';
    if (text.startsWith('http://') || text.startsWith('https://')) {
      category = 'Link';
    } else if (RegExp(r'^[0-9+\s\-()]+$').hasMatch(text)) {
      category = 'Number';
    }
    setState(() {
      _clipboardItems.insert(0, {
        'type': category,
        'text': text.trim(),
        'time': 'Just now',
      });
      _clipInputController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved to Float Clipboard!')),
    );
  }

  void _addQuickNote(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _quickNotes.insert(0, text.trim());
      _noteInputController.clear();
    });
  }

  void _spinDecisionWheel() {
    final list = ['Order Pizza 🍕', 'Cook at Home 🥗', 'Take a Walk 🚶', 'Work 1 Hour 💻', 'Power Nap 😴'];
    list.shuffle();
    setState(() {
      _selectedDecision = list.first;
    });
  }

  void _showFloatingNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: const [
            Icon(Icons.bubble_chart, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'FloatDock Active: Quick Overlay Bubble is pinned to screen!',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildDockSimulatorTab(),
      _buildClipboardTab(),
      _buildFloatingToolsTab(),
      _buildRetentionRewardsTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.layers, color: Colors.teal),
            SizedBox(width: 8),
            Text(
              'FloatDock',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '$_rewardPoints pts',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bubble_chart),
            label: 'Float Dock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy),
            label: 'Clipboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Micro Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ads_click),
            label: 'Rewards & Ads',
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating Dock Canvas Simulator
  Widget _buildDockSimulatorTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Switch Card
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.mobile_screen_share, color: Colors.teal, size: 36),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Display Over Apps Dock',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            softWrap: true,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isOverlayEnabled
                                ? 'Status: Active Overlay Dock'
                                : 'Status: Overlay Disabled',
                            style: TextStyle(
                              fontSize: 12,
                              color: _isOverlayEnabled ? Colors.greenAccent : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isOverlayEnabled,
                      activeColor: Colors.teal,
                      onChanged: (val) {
                        setState(() => _isOverlayEnabled = val);
                        if (val) _showFloatingNotification();
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Live Interactive Phone Canvas
            const Text(
              'Interactive Screen Canvas Preview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Container(
              height: 380,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF020617),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.teal.withOpacity(0.5), width: 2),
              ),
              child: Stack(
                children: [
                  // Mock Phone Background UI
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('09:41 AM', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              Icon(Icons.wifi, color: Colors.grey, size: 14),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.search, color: Colors.grey),
                                SizedBox(width: 8),
                                Text('Simulated Phone Screen...', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: List.generate(
                              6,
                              (idx) => Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.apps, color: Colors.white70, size: 24),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Center(
                            child: Text(
                              _activeWidget == 'None'
                                  ? 'Tap or drag the Floating Bubble!'
                                  : 'Active Overlay Tool: $_activeWidget',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.teal, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),

                  // Draggable & Tappable Floating Bubble
                  if (_isOverlayEnabled)
                    Positioned(
                      left: _bubblePosition.dx.clamp(10.0, 260.0),
                      top: _bubblePosition.dy.clamp(10.0, 300.0),
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.teal.withOpacity(0.5),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.bubble_chart,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            if (_isBubbleExpanded)
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E293B),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.teal),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.content_copy, color: Colors.cyan, size: 20),
                                      onPressed: () {
                                        setState(() {
                                          _activeWidget = 'Clipboard Stack';
                                          _isBubbleExpanded = false;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit_note, color: Colors.amber, size: 20),
                                      onPressed: () {
                                        setState(() {
                                          _activeWidget = 'Quick Note Bubble';
                                          _isBubbleExpanded = false;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.casino, color: Colors.purpleAccent, size: 20),
                                      onPressed: () {
                                        setState(() {
                                          _activeWidget = 'Decision Wheel';
                                          _isBubbleExpanded = false;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick Setup Action Buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _showFloatingNotification,
                  icon: const Icon(Icons.notifications_active, size: 18),
                  label: const Text('Test Float Notification'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _bubblePosition = const Offset(140, 150);
                    });
                  },
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Reset Dock Position'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.teal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: Dynamic Clipboard Memory Stack
  Widget _buildClipboardTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Float Dynamic Clipboard',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            const Text(
              'Capture copied text, links, and numbers instantly for 1-tap floating access.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Add Input Box
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _clipInputController,
                    decoration: InputDecoration(
                      hintText: 'Type or paste content to pin...',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: () => _addClipboardItem(_clipInputController.text),
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(backgroundColor: Colors.teal),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Clipboard Item List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _clipboardItems.length,
              itemBuilder: (context, index) {
                final item = _clipboardItems[index];
                IconData typeIcon = Icons.text_fields;
                Color typeColor = Colors.teal;
                if (item['type'] == 'Link') {
                  typeIcon = Icons.link;
                  typeColor = Colors.cyan;
                } else if (item['type'] == 'Number') {
                  typeIcon = Icons.phone;
                  typeColor = Colors.greenAccent;
                } else if (item['type'] == 'Code') {
                  typeIcon = Icons.vpn_key;
                  typeColor = Colors.amber;
                }

                return Card(
                  color: const Color(0xFF1E293B),
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: typeColor.withOpacity(0.2),
                      child: Icon(typeIcon, color: typeColor, size: 20),
                    ),
                    title: Text(
                      item['text'] ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${item[\'type\']} • ${item[\'time\']}',
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy, color: Colors.grey, size: 18),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Copied: ${item[\'text\']}')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
                          onPressed: () {
                            setState(() {
                              _clipboardItems.removeAt(index);
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

  // TAB 3: Floating Micro-Tools
  Widget _buildFloatingToolsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Notes Card
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.edit_note, color: Colors.amber),
                        SizedBox(width: 8),
                        Text(
                          'Floating Quick Notes',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _noteInputController,
                            decoration: InputDecoration(
                              hintText: 'Add floating reminder...',
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                              filled: true,
                              fillColor: const Color(0xFF0F172A),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _addQuickNote(_noteInputController.text),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: _quickNotes.map((note) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline, color: Colors.teal, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  note,
                                  style: const TextStyle(color: Colors.white, fontSize: 13),
                                  softWrap: true,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.grey, size: 16),
                                onPressed: () {
                                  setState(() {
                                    _quickNotes.remove(note);
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
            ),
            const SizedBox(height: 16),

            // Decision Spinner Overlay Tool
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.casino, color: Colors.purpleAccent),
                        SizedBox(width: 8),
                        Text(
                          'Floating Decision Helper',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.purpleAccent.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Quick Random Decision Spinner',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _selectedDecision,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purpleAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _spinDecisionWheel,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Spin Random Picker'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 45),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 4: Retention Dashboard & AdMob Showcase
  Widget _buildRetentionRewardsTab() {
    int sessionMinutes = _sessionSeconds ~/ 60;
    int sessionSecs = _sessionSeconds % 60;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Session Engagement Stats
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Active Session Duration',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${sessionMinutes.toString().padLeft(2, '0')}:${sessionSecs.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.timer, color: Colors.teal, size: 28),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: (_sessionSeconds % 60) / 60,
                      backgroundColor: const Color(0xFF0F172A),
                      color: Colors.teal,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Earn 5 bonus points every 10 seconds of app usage!',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Monetization & Ad Placement Placeholder Showcase
            const Text(
              'Float Monetization Integration',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.ads_click, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'AdMob Banner Placeholder',
                        style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'High engagement screen float overlays ensure long user retention and maximized AdMob banner & rewarded video earnings.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _rewardPoints += 50;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Rewarded Video Watched! +50 Points Earned!')),
                      );
                    },
                    icon: const Icon(Icons.play_circle_fill, size: 18),
                    label: const Text('Watch Rewarded Ad (+50 Pts)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick App Settings & Permissions Simulator
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'App Floating Permissions',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Display Over Other Apps', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
                      ],
                    ),
                    const Divider(color: Color(0xFF0F172A), height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Float Notification Trigger', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}