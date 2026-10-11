import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const OverlayIQApp());
}

class OverlayIQApp extends StatelessWidget {
  const OverlayIQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlayIQ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF101820),
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
  int _currentTabIndex = 0;

  // System Permissions Simulation
  bool _displayOverAppsPerm = true;
  bool _floatingNotiPerm = true;
  bool _autoClipCapture = true;

  // Dynamic Floating Banner Notification
  String? _activeNotificationText;
  bool _showBannerNoti = false;

  // Floating Overlay Bubble Position (Relative inside Canvas)
  double _bubbleX = 20.0;
  double _bubbleY = 120.0;
  bool _isFloatingMenuOpen = false;

  // Floating Quick Note State
  final TextEditingController _quickNoteController = TextEditingController();
  String _activePinnedNote = "Tap 'Pin to Overlay' on any snippet!";

  // Clipboard & Snippets
  final List<Map<String, String>> _snippets = [
    {
      'id': '1',
      'type': 'Price',
      'title': 'Online Deal Price',
      'content': 'Special discount item: \$24.99 down from \$49.99',
      'time': '10 mins ago',
    },
    {
      'id': '2',
      'type': 'Link',
      'title': 'Recipe Video URL',
      'content': 'https://youtube.com/watch?v=quick-dinner-ideas',
      'time': '1 hour ago',
    },
    {
      'id': '3',
      'type': 'Note',
      'title': 'Meeting Gate Pass Code',
      'content': 'Security Pass Code: #8892 - Door 3 B',
      'time': '3 hours ago',
    },
  ];

  // Micro Decision Engine State
  final TextEditingController _decisionTopicController =
      TextEditingController(text: 'What should we eat for dinner tonight?');
  final List<Map<String, dynamic>> _decisionOptions = [
    {'name': 'Home Cooked Pasta', 'weight': 4, 'score': 0.0},
    {'name': 'Sushi Delivery', 'weight': 3, 'score': 0.0},
    {'name': 'Healthy Salad Bowl', 'weight': 5, 'score': 0.0},
  ];
  String _decisionWinner = '';

  // Floating Multi-Tools State
  double _screenBrightnessTint = 0.0;
  double _calcVal1 = 0;
  double _calcVal2 = 0;
  String _calcResult = "0.0";
  final TextEditingController _currencyInput = TextEditingController(text: "100");
  String _convertedCurrency = "\$100.00 = €92.50";

  void _triggerFloatingNotification(String message) {
    if (!_floatingNotiPerm) return;
    setState(() {
      _activeNotificationText = message;
      _showBannerNoti = true;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showBannerNoti = false;
        });
      }
    });
  }

  void _addSnippet(String title, String content, String type) {
    if (content.trim().isEmpty) return;
    setState(() {
      _snippets.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'type': type,
        'title': title.isEmpty ? 'Micro Snippet' : title,
        'content': content,
        'time': 'Just now',
      });
    });
    _triggerFloatingNotification('New snippet saved to OverlayIQ Vault!');
  }

  void _runDecisionEngine() {
    if (_decisionOptions.isEmpty) return;
    final random = Random();
    int totalWeight = 0;
    for (var opt in _decisionOptions) {
      totalWeight += (opt['weight'] as int);
    }
    
    int pick = random.nextInt(totalWeight > 0 ? totalWeight : 1);
    int current = 0;
    String winner = _decisionOptions.first['name'];

    for (var opt in _decisionOptions) {
      current += (opt['weight'] as int);
      if (pick < current) {
        winner = opt['name'];
        break;
      }
    }

    setState(() {
      _decisionWinner = winner;
      for (var opt in _decisionOptions) {
        opt['score'] = (opt['weight'] as int) / (totalWeight > 0 ? totalWeight : 1);
      }
    });

    _triggerFloatingNotification('Decision Engine Picked: $_decisionWinner');
  }

  @override.dispose() {
    _quickNoteController.dispose();
    _decisionTopicController.dispose();
    _currencyInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar & Permission Status
            _buildTopAppBar(),

            // Interactive Dynamic Floating Banner Notification Toast
            if (_showBannerNoti && _activeNotificationText != null)
              _buildFloatingNotificationBanner(),

            // Main Dynamic Tab Content View
            Expanded(
              child: IndexedStack(
                index: _currentTabIndex,
                children: [
                  _buildFloatingHudCanvasTab(),
                  _buildClipboardVaultTab(),
                  _buildDecisionEngineTab(),
                  _buildMultiToolDeckTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        backgroundColor: const Color(0xFF16222F),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Floating HUD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy),
            label: 'Snippets Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Decider',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Deck Tools',
          ),
        ],
      ),
    );
  }

  // Header Widget
  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      color: const Color(0xFF16222F),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.bolt, color: Colors.tealAccent, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OverlayIQ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Smart Floating Assistant Active',
                  style: TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_active, color: Colors.amber),
            tooltip: 'Test Floating Banner',
            onPressed: () {
              _triggerFloatingNotification('⚡ Live Overlay Alert: Quick Snippet copied!');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
    );
  }

  // Dynamic Floating Notification Banner
  Widget _buildFloatingNotificationBanner() {
    return Container(
      margin: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.teal.shade800,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.tealAccent.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.flare, color: Colors.amber, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _activeNotificationText ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _showBannerNoti = false;
              });
            },
            child: const Icon(Icons.close, color: Colors.white70, size: 18),
          ),
        ],
      ),
    );
  }

  // TAB 1: FLOATING HUD CANVAS & INTERACTIVE OVERLAY DEMO
  Widget _buildFloatingHudCanvasTab() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Explanation Card
                  Card(
                    color: const Color(0xFF1E2C3A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.phone_android, color: Colors.tealAccent, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Interactive Floating Screen Dock',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Drag the floating bubble below anywhere on screen! Tap it to expand floating overlay tools that remain accessible over any routine activity.',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildStatusBadge(
                                'Display over apps',
                                _displayOverAppsPerm,
                                Colors.green,
                              ),
                              _buildStatusBadge(
                                'Floating Alert Banner',
                                _floatingNotiPerm,
                                Colors.teal,
                              ),
                              _buildStatusBadge(
                                'Auto Snippet Capture',
                                _autoClipCapture,
                                Colors.blue,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Floating Canvas Area (Simulated Phone Display Screen)
                  Container(
                    height: 380,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1218),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.teal.withOpacity(0.3), width: 2),
                    ),
                    child: Stack(
                      children: [
                        // Background Phone Preview Graphics
                        Positioned.fill(
                          child: Opacity(
                            opacity: _screenBrightnessTint > 0 ? (1.0 - _screenBrightnessTint) : 0.8,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 10,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade800,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF182533),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('Reading Article...',
                                                    style: TextStyle(
                                                        color: Colors.white70, fontSize: 11)),
                                                Text('Shopping Deals Active',
                                                    style: TextStyle(
                                                        color: Colors.grey, fontSize: 9)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // Active Pinned Quick Note Banner on simulated screen
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.teal.shade700),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.pin_drop,
                                            color: Colors.tealAccent, size: 18),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Pinned Overlay Note:\n$_activePinnedNote',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                            ),
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Draggable Floating Bubble
                        Positioned(
                          left: _bubbleX,
                          top: _bubbleY,
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                _bubbleX += details.delta.dx;
                                _bubbleY += details.delta.dy;
                                // Keep inside bounds
                                _bubbleX = _bubbleX.clamp(10.0, 260.0);
                                _bubbleY = _bubbleY.clamp(10.0, 300.0);
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isFloatingMenuOpen = !_isFloatingMenuOpen;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.tealAccent,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.tealAccent.withOpacity(0.6),
                                          blurRadius: 12,
                                          spreadRadius: 2,
                                        )
                                      ],
                                    ),
                                    child: Icon(
                                      _isFloatingMenuOpen ? Icons.close : Icons.bolt,
                                      color: Colors.black,
                                      size: 26,
                                    ),
                                  ),
                                ),

                                // Expanded Floating Dock Panel
                                if (_isFloatingMenuOpen)
                                  Container(
                                    margin: const EdgeInsets.topRight(8),
                                    width: 190,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1B2A38),
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black87,
                                          blurRadius: 10,
                                        )
                                      ],
                                      border: Border.all(color: Colors.tealAccent, width: 1.5),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Overlay Quick Menu',
                                          style: TextStyle(
                                            color: Colors.tealAccent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                        const Divider(color: Colors.white70, height: 12),
                                        _buildFloatingMenuItem(
                                          Icons.copy,
                                          'Clipboard Vault',
                                          () {
                                            setState(() => _currentTabIndex = 1);
                                          },
                                        ),
                                        _buildFloatingMenuItem(
                                          Icons.tune,
                                          'Spin Decider',
                                          () {
                                            setState(() => _currentTabIndex = 2);
                                          },
                                        ),
                                        _buildFloatingMenuItem(
                                          Icons.calculate,
                                          'Quick Math/Calc',
                                          () {
                                            setState(() => _currentTabIndex = 3);
                                          },
                                        ),
                                        _buildFloatingMenuItem(
                                          Icons.note_add,
                                          'Quick Overlay Note',
                                          _showQuickNoteDialog,
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

                  // Quick Action Dock Bar
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _triggerFloatingNotification('⚡ Floating Widget Dock Refreshed!');
                          },
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Reset Floating Position'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: _showQuickNoteDialog,
                        icon: const Icon(Icons.edit_note, size: 18),
                        label: const Text('Quick Note'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF243447),
                          foregroundColor: Colors.tealAccent,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // TAB 2: CLIPBOARD & SNIPPET VAULT
  Widget _buildClipboardVaultTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Clipboard Snippet Vault',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Auto-organize micro notes, prices & links',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _showAddSnippetDialog,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Item'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Snippets List
          Expanded(
            child: _snippets.isEmpty
                ? const Center(
                    child: Text(
                      'No saved snippets yet.\nTap "Add Item" or copy text while using the app!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _snippets.length,
                    itemBuilder: (context, index) {
                      final item = _snippets[index];
                      return Card(
                        color: const Color(0xFF1A2634),
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.teal.withOpacity(0.2),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _buildTypeBadge(item['type'] ?? 'Note'),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item['title'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    item['time'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SelectableText(
                                item['content'] ?? '',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _activePinnedNote = item['content'] ?? '';
                                      });
                                      _triggerFloatingNotification(
                                        'Pinned to Floating Screen Overlay!',
                                      );
                                    },
                                    icon: const Icon(Icons.push_pin,
                                        size: 14, color: Colors.tealAccent),
                                    label: const Text(
                                      'Pin to Overlay',
                                      style: TextStyle(
                                          color: Colors.tealAccent, fontSize: 11),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        size: 18, color: Colors.redAccent),
                                    onPressed: () {
                                      setState(() {
                                        _snippets.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // TAB 3: SMART MICRO DECISION MATRIX
  Widget _buildDecisionEngineTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Smart Decision Engine',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Solve daily dilemmas & micro choices instantly with weighted probability',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 14),

            // Decision Topic Input
            TextField(
              controller: _decisionTopicController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                labelText: 'Micro Dilemma Topic',
                labelStyle: const TextStyle(color: Colors.tealAccent),
                filled: true,
                fillColor: const Color(0xFF182533),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Choice Options & Priorities',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.tealAccent),
                  onPressed: _showAddOptionDialog,
                ),
              ],
            ),

            // Options List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _decisionOptions.length,
              itemBuilder: (context, idx) {
                final opt = _decisionOptions[idx];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2634),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              opt['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'Weight Preference: ${opt['weight']}/5',
                              style: const TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey, size: 18),
                        onPressed: () {
                          setState(() {
                            _decisionOptions.removeAt(idx);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 14),

            // Spin / Resolve Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _runDecisionEngine,
                icon: const Icon(Icons.casino, color: Colors.black),
                label: const Text(
                  'SPIN & SOLVE DILEMMA',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Winner Output Display
            if (_decisionWinner.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade900.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.tealAccent, width: 1.5),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.stars, color: Colors.amber, size: 36),
                    const SizedBox(height: 6),
                    const Text(
                      'RECOMMENDED CHOICE',
                      style: TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _decisionWinner,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // TAB 4: MULTI-TOOL DECK (FLOATING CALC, CONVERTER, TINT)
  Widget _buildMultiToolDeckTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Multi-Tool Floating Deck',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Instant mini utility tools ready for screen floating',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),

            // Tool 1: Floating Screen Dimmer / Tint Filter
            Card(
              color: const Color(0xFF182533),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.remove_red_eye, color: Colors.amber, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Floating Screen Dimmer Overlay',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Reduces eye strain while reading articles or late night browsing',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    Slider(
                      value: _screenBrightnessTint,
                      min: 0.0,
                      max: 0.8,
                      activeColor: Colors.tealAccent,
                      onChanged: (val) {
                        setState(() {
                          _screenBrightnessTint = val;
                        });
                      },
                    ),
                    Text(
                      'Filter Tint Strength: ${(
                        _screenBrightnessTint * 100
                      ).toInt()}%',
                      style: const TextStyle(color: Colors.tealAccent, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tool 2: Instant Math Calculator
            Card(
              color: const Color(0xFF182533),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.calculate, color: Colors.tealAccent, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Instant Micro Calculator',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: const InputDecoration(
                              labelText: 'Num 1',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (v) => _calcVal1 = double.tryParse(v) ?? 0,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: const InputDecoration(
                              labelText: 'Num 2',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (v) => _calcVal2 = double.tryParse(v) ?? 0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _calcResult = (_calcVal1 + _calcVal2).toStringAsFixed(2);
                            });
                          },
                          child: const Text('+'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _calcResult = (_calcVal1 - _calcVal2).toStringAsFixed(2);
                            });
                          },
                          child: const Text('-'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _calcResult = (_calcVal1 * _calcVal2).toStringAsFixed(2);
                            });
                          },
                          child: const Text('×'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _calcResult = _calcVal2 != 0
                                  ? (_calcVal1 / _calcVal2).toStringAsFixed(2)
                                  : 'Error';
                            });
                          },
                          child: const Text('÷'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Result: $_calcResult',
                      style: const TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tool 3: Quick Currency / Price Converter
            Card(
              color: const Color(0xFF182533),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.monetization_on, color: Colors.greenAccent, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Quick Deal Price Converter',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _currencyInput,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: const InputDecoration(
                              labelText: 'USD Amount (\$) ',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            final val = double.tryParse(_currencyInput.text) ?? 0;
                            setState(() {
                              _convertedCurrency =
                                  '\$${val.toStringAsFixed(2)} = €${(val * 0.925).toStringAsFixed(2)}';
                            });
                          },
                          child: const Text('Convert'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _convertedCurrency,
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
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

  // Helper UI Elements & Dialogs
  Widget _buildStatusBadge(String label, bool active, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active ? color.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: active ? color : Colors.grey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            active ? Icons.check_circle : Icons.cancel,
            size: 12,
            color: active ? color : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(String type) {
    Color bg = Colors.blue;
    if (type == 'Price') bg = Colors.green;
    if (type == 'Link') bg = Colors.purple;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: bg, width: 0.8),
      ),
      child: Text(
        type,
        style: TextStyle(color: bg, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFloatingMenuItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.tealAccent, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickNoteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF182533),
          title: const Text('Instant Floating Note',
              style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: _quickNoteController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Type micro note to keep pinned on screen...',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_quickNoteController.text.trim().isNotEmpty) {
                  setState(() {
                    _activePinnedNote = _quickNoteController.text.trim();
                  });
                  _triggerFloatingNotification('Pinned Note Updated!');
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Pin Note'),
            ),
          ],
        );
      },
    );
  }

  void _showAddSnippetDialog() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    String selectedType = 'Note';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF182533),
              title: const Text('Save Micro Snippet',
                  style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: contentCtrl,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Content / Link / Price',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      value: selectedType,
                      dropdownColor: const Color(0xFF182533),
                      isExpanded: true,
                      style: const TextStyle(color: Colors.white),
                      items: ['Note', 'Price', 'Link'].map((String val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(val),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedType = val;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _addSnippet(
                      titleCtrl.text.trim(),
                      contentCtrl.text.trim(),
                      selectedType,
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text('Save Snippet'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddOptionDialog() {
    final optionCtrl = TextEditingController();
    double weightVal = 3.0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF182533),
              title: const Text('Add Decision Choice',
                  style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: optionCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Option Name (e.g., Pizza Delivery)',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Priority Preference: ${weightVal.toInt()}/5',
                    style: const TextStyle(color: Colors.tealAccent, fontSize: 12),
                  ),
                  Slider(
                    value: weightVal,
                    min: 1.0,
                    max: 5.0,
                    divisions: 4,
                    activeColor: Colors.tealAccent,
                    onChanged: (v) {
                      setDialogState(() {
                        weightVal = v;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (optionCtrl.text.trim().isNotEmpty) {
                      setState(() {
                        _decisionOptions.add({
                          'name': optionCtrl.text.trim(),
                          'weight': weightVal.toInt(),
                          'score': 0.0,
                        });
                      });
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text('Add Choice'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF182533),
              title: const Text('OverlayIQ Configuration',
                  style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SwitchListTile(
                      title: const Text('Display Over Apps',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                      value: _displayOverAppsPerm,
                      activeColor: Colors.tealAccent,
                      onChanged: (val) {
                        setDialogState(() {
                          _displayOverAppsPerm = val;
                        });
                        setState(() {
                          _displayOverAppsPerm = val;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Floating Notifications',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                      value: _floatingNotiPerm,
                      activeColor: Colors.tealAccent,
                      onChanged: (val) {
                        setDialogState(() {
                          _floatingNotiPerm = val;
                        });
                        setState(() {
                          _floatingNotiPerm = val;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Auto-Capture Clipboard',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                      value: _autoClipCapture,
                      activeColor: Colors.tealAccent,
                      onChanged: (val) {
                        setDialogState(() {
                          _autoClipCapture = val;
                        });
                        setState(() {
                          _autoClipCapture = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}