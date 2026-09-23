import 'package:flutter/material.dart';

void main() {
  runApp(const FloatMaxApp());
}

class FloatMaxApp extends StatelessWidget {
  const FloatMaxApp({super.key});

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'FloatMax Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyan,
          secondary: Colors.tealAccent,
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Floating Overlay System State
  bool _isOverlayActive = true;
  bool _isPrivacyMaskActive = false;
  Offset _floatingPos = const Offset(120, 150);
  bool _isExpandedCapsule = false;
  String _capsuleShape = 'Dynamic Island'; // Options: Dynamic Island, Mini Bubble, Side Launcher, Bottom Dock
  Color _accentColor = Colors.cyan;
  double _overlayOpacity = 0.95;
  
  // Stats
  int _actionsPerformed = 28;
  int _clipboardHits = 14;
  int _privacyTimeMinutes = 45;

  // Notification Banner Simulation
  bool _showBanner = false;
  String _bannerTitle = '';
  String _bannerMessage = '';

  // Clipboard Stack
  final List<Map<String, String>> _clipboardItems = [
    {'title': 'Bank Account IBAN', 'text': 'US89370001293840192834', 'category': 'Finance'},
    {'title': 'Office Address', 'text': 'Suite 404, Tech Park Center, Metro Ave', 'category': 'Work'},
    {'title': 'Discount Voucher Code', 'text': 'SAVE2025PROMO', 'category': 'Shopping'},
    {'title': 'Quick Email Sign-off', 'text': 'Best regards,\nAlex Vance | Operations', 'category': 'General'},
  ];

  // Privacy Mask Settings
  double _maskYOffset = 220.0;
  double _maskHeight = 140.0;
  double _maskOpacity = 0.85;

  void _triggerFloatingNotification(String title, String message) {
    setState(() {
      _bannerTitle = title;
      _bannerMessage = message;
      _showBanner = true;
      _actionsPerformed++;
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showBanner = false;
        });
      }
    });
  }

  void _addClipboardSnippet(String title, String text, String category) {
    setState(() {
      _clipboardItems.insert(0, {
        'title': title,
        'text': text,
        'category': category,
      });
      _clipboardHits++;
    });
    _triggerFloatingNotification('Snippet Saved', '"$title" added to Float Floating Stack');
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Main Body Tabs
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildHUDDashboardTab(screenSize),
                _buildClipboardVaultTab(),
                _buildPrivacyGuardTab(screenSize),
                _buildStudioCustomizerTab(),
              ],
            ),
          ),

          // SIMULATED SYSTEM PRIVACY MASK OVERLAY
          if (_isPrivacyMaskActive)
            Positioned(
              top: _maskYOffset,
              left: 0,
              right: 0,
              height: _maskHeight,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  setState(() {
                    _maskYOffset = (_maskYOffset + details.delta.dy).clamp(50.0, screenSize.height - 200.0);
                  });
                },
                child: Container(
                  color: Colors.black.withOpacity(_maskOpacity),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.cyan.withOpacity(0.5), width: 1.5),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.visibility_off, color: Colors.cyan, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Stealth Privacy Shield Active (Drag vertically to adjust position)',
                            style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // INTERACTIVE FLOATING HUD CAPSULE (SIMULATED OVERLAY OVER ALL APPS)
          if (_isOverlayActive)
            Positioned(
              left: _floatingPos.dx,
              top: _floatingPos.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _floatingPos = Offset(
                      (_floatingPos.dx + details.delta.dx).clamp(10.0, screenSize.width - 220.0),
                      (_floatingPos.dy + details.delta.dy).clamp(40.0, screenSize.height - 180.0),
                    );
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A).withOpacity(_overlayOpacity),
                    borderRadius: BorderRadius.circular(_isExpandedCapsule ? 20 : 30),
                    border: Border.all(color: _accentColor, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: _accentColor.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: _accentColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isExpandedCapsule = !_isExpandedCapsule;
                              });
                            },
                            child: Row(
                              children: [
                                Text(
                                  _capsuleShape,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  _isExpandedCapsule ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: () {
                              _triggerFloatingNotification('Float Quick Action', 'Instant clip sync triggered!');
                            },
                            child: Icon(Icons.flash_on, color: _accentColor, size: 16),
                          ),
                        ],
                      ),

                      if (_isExpandedCapsule) ...[
                        const SizedBox(height: 10),
                        Container(
                          width: 200,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'FLOATING QUICK ACTIONS',
                                style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildMicroIconButton(Icons.copy, 'Clip', () {
                                    _triggerFloatingNotification('Clipboard Copied', _clipboardItems.first['text']!);
                                  }),
                                  _buildMicroIconButton(Icons.visibility_off, 'Hide', () {
                                    setState(() {
                                      _isPrivacyMaskActive = !_isPrivacyMaskActive;
                                    });
                                  }),
                                  _buildMicroIconButton(Icons.notifications_active, 'Alert', () {
                                    _triggerFloatingNotification('Float Alert', 'Micro-timer dynamic badge fired!');
                                  }),
                                  _buildMicroIconButton(Icons.tune, 'Dock', () {
                                    setState(() {
                                      _currentIndex = 3;
                                    });
                                  }),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 12),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        _clipboardItems.isNotEmpty ? _clipboardItems[0]['title']! : 'No Clips',
                                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

          // SIMULATED DYNAMIC FLOATING BANNER NOTIFICATION
          if (_showBanner)
            Positioned(
              top: 20,
              left: 16,
              right: 16,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showBanner ? 1.0 : 0.0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Colors.black87, blurRadius: 10, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.notifications_active, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _bannerTitle,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _bannerMessage,
                              style: const TextStyle(color: Colors.white70, fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 16),
                        onPressed: () {
                          setState(() {
                            _showBanner = false;
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

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF0F172A),
        selectedItemColor: _accentColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Float HUD'),
          BottomNavigationBarItem(icon: Icon(Icons.content_copy), label: 'Clipboard Vault'),
          BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Privacy Guard'),
          BottomNavigationBarItem(icon: Icon(Icons.brush), label: 'Studio Design'),
        ],
      ),
    );
  }

  // TAB 1: HUD DASHBOARD & LIVE CONTROLS
  Widget _buildHUDDashboardTab(Size screenSize) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'FloatMax Assistant',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Always-On Screen Micro-Assistant',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _isOverlayActive ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _isOverlayActive ? Colors.green : Colors.red),
                ),
                child: Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: _isOverlayActive ? Colors.green : Colors.red),
                    const SizedBox(width: 6),
                    Text(
                      _isOverlayActive ? 'HUD ACTIVE' : 'DISABLED',
                      style: TextStyle(
                        color: _isOverlayActive ? Colors.green : Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // SYSTEM OVERLAY CONTROLLER CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blueGrey.shade700),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.layers, color: Colors.cyan),
                        SizedBox(width: 10),
                        Text(
                          'Floating System Overlay',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    Switch(
                      value: _isOverlayActive,
                      activeColor: Colors.cyan,
                      onChanged: (val) {
                        setState(() {
                          _isOverlayActive = val;
                        });
                        _triggerFloatingNotification(
                          'Floating Assistant Status',
                          val ? 'Floating Overlay Hub Enabled' : 'Floating Assist Disabled',
                        );
                      },
                    ),
                  ],
                ),
                const Divider(color: Colors.white70),
                const SizedBox(height: 8),
                const Text(
                  'The Floating Action Capsule lets you access instant clipboard items, privacy screen dimming, and quick triggers on top of any active mobile app.',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildStatusBadge(Icons.check_circle, 'Display Above Apps: Granted', Colors.teal),
                    _buildStatusBadge(Icons.check_circle, 'Floating Banner Engine: Ready', Colors.teal),
                    _buildStatusBadge(Icons.check_circle, 'Quick Vault: Active', Colors.teal),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // QUICK METRICS & STATS
          const Text(
            'Daily Efficiency Stats',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard('Actions Saved', '$_actionsPerformed', Icons.bolt, Colors.amber),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricCard('Vault Hits', '$_clipboardHits', Icons.content_copy, Colors.cyan),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricCard('Privacy Active', '${_privacyTimeMinutes}m', Icons.security, Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // FLOATING NOTIFICATION BANNER TESTER
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.notifications_active, color: Colors.tealAccent, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Floating Notification Trigger Studio',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Simulate interactive system floating banners to test alerts while using other apps.',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan.shade800,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        _triggerFloatingNotification('Price Drop Alert', 'Target item discounted by 25%!');
                      },
                      icon: const Icon(Icons.monetization_on, size: 14),
                      label: const Text('Price Alert', style: TextStyle(fontSize: 11)),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade800,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        _triggerFloatingNotification('Private Note Saved', 'Quick text snippet stored in Vault');
                      },
                      icon: const Icon(Icons.star, size: 14),
                      label: const Text('Vault Sync', style: TextStyle(fontSize: 11)),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade800,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        _triggerFloatingNotification('Privacy Guard On', 'Screen Dimming Tint Applied');
                      },
                      icon: const Icon(Icons.security, size: 14),
                      label: const Text('Privacy Banner', style: TextStyle(fontSize: 11)),
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

  // TAB 2: SMART CLIPBOARD VAULT & SNIPPETS
  Widget _buildClipboardVaultTab() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController textController = TextEditingController();

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
                    'Smart Clipboard Vault',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'One-tap snippet copy available inside Floating Assist',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.cyan, size: 28),
                onPressed: () {
                  _showAddSnippetDialog(context, titleController, textController);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _clipboardItems.length,
            itemBuilder: (context, index) {
              final item = _clipboardItems[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white70),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.cyan.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.content_copy, color: Colors.cyan, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item['title']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.shade800,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item['category']!,
                                  style: const TextStyle(color: Colors.white70, fontSize: 9),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['text']!,
                            style: const TextStyle(color: Colors.grey, fontSize: 11),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.tealAccent, size: 18),
                      onPressed: () {
                        _triggerFloatingNotification('Copied to Clipboard', item['text']!);
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
              );
            },
          ),
        ],
      ),
    );
  }

  // TAB 3: PRIVACY GUARD & READING MASK
  Widget _buildPrivacyGuardTab(Size screenSize) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Screen Privacy & Peep Guard',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Mask sensitive password input, bank details, or chat screens in public spaces.',
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.visibility_off, color: Colors.greenAccent),
                        SizedBox(width: 10),
                        Text(
                          'Stealth Mask Mode',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Switch(
                      value: _isPrivacyMaskActive,
                      activeColor: Colors.greenAccent,
                      onChanged: (val) {
                        setState(() {
                          _isPrivacyMaskActive = val;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(color: Colors.white70),
                const SizedBox(height: 10),

                // Mask Height Slider
                Row(
                  children: [
                    const SizedBox(
                      width: 90,
                      child: Text('Mask Height:', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ),
                    Expanded(
                      child: Slider(
                        value: _maskHeight,
                        min: 60.0,
                        max: 300.0,
                        activeColor: Colors.cyan,
                        onChanged: (val) {
                          setState(() {
                            _maskHeight = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                // Mask Opacity Slider
                Row(
                  children: [
                    const SizedBox(
                      width: 90,
                      child: Text('Darkness:', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ),
                    Expanded(
                      child: Slider(
                        value: _maskOpacity,
                        min: 0.3,
                        max: 0.98,
                        activeColor: Colors.cyan,
                        onChanged: (val) {
                          setState(() {
                            _maskOpacity = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Text(
            'Live Privacy Preview Box',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),

          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade900,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Stack(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Confidential Chat Message Sample:\n\n"Hey! My secret access pin is 9921. Please do not share this text with anyone in the metro carriage!"',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
                if (_isPrivacyMaskActive)
                  Positioned(
                    top: 40,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Container(
                      color: Colors.black.withOpacity(_maskOpacity),
                      child: const Center(
                        child: Text(
                          '[ PRIVACY MASK BLOCKS PEEPING ]',
                          style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 4: STUDIO DESIGN & FLOATING STYLE CUSTOMIZER
  Widget _buildStudioCustomizerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Capsule Design Studio',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Customize appearance, theme glow, and position of your Floating HUD',
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 16),

          // Shape Selector
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Capsule Dock Style',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildStyleChip('Dynamic Island'),
                    _buildStyleChip('Mini Bubble'),
                    _buildStyleChip('Side Launcher'),
                    _buildStyleChip('Bottom Dock'),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Glow Color Theme',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildColorPickerCircle(Colors.cyan),
                    _buildColorPickerCircle(Colors.purpleAccent),
                    _buildColorPickerCircle(Colors.amber),
                    _buildColorPickerCircle(Colors.tealAccent),
                    _buildColorPickerCircle(Colors.redAccent),
                  ],
                ),
                const SizedBox(height: 16),

                // Opacity Slider
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
                      child: Text('Dock Opacity:', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ),
                    Expanded(
                      child: Slider(
                        value: _overlayOpacity,
                        min: 0.5,
                        max: 1.0,
                        activeColor: _accentColor,
                        onChanged: (val) {
                          setState(() {
                            _overlayOpacity = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Preset Themes Quick Action
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Instant Floating HUD Presets',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 10),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.bolt, color: Colors.amber),
                  title: const Text('Ultra Efficiency Mode', style: TextStyle(color: Colors.white, fontSize: 12)),
                  subtitle: const Text('Dynamic Island style with max clipboard shortcuts', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan.shade800),
                    onPressed: () {
                      setState(() {
                        _capsuleShape = 'Dynamic Island';
                        _accentColor = Colors.cyan;
                        _overlayOpacity = 0.95;
                      });
                      _triggerFloatingNotification('Preset Applied', 'Ultra Efficiency Floating Mode Active');
                    },
                    child: const Text('Apply', style: TextStyle(fontSize: 10, color: Colors.white)),
                  ),
                ),
                const Divider(color: Colors.white70),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.security, color: Colors.greenAccent),
                  title: const Text('Public Transit Privacy Mode', style: TextStyle(color: Colors.white, fontSize: 12)),
                  subtitle: const Text('Auto-dim mask with stealth notification previews', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade800),
                    onPressed: () {
                      setState(() {
                        _capsuleShape = 'Mini Bubble';
                        _accentColor = Colors.tealAccent;
                        _isPrivacyMaskActive = true;
                      });
                      _triggerFloatingNotification('Privacy Mode', 'Stealth Mask Floating HUD Engaged');
                    },
                    child: const Text('Apply', style: TextStyle(fontSize: 10, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // HELPER WIDGET BUILDERS
  Widget _buildMicroIconButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade800,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 14),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 8)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStyleChip(String shapeName) {
    final bool isSelected = _capsuleShape == shapeName;
    return ChoiceChip(
      label: Text(shapeName, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontSize: 11)),
      selected: isSelected,
      selectedColor: _accentColor,
      backgroundColor: const Color(0xFF0F172A),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _capsuleShape = shapeName;
          });
        }
      },
    );
  }

  Widget _buildColorPickerCircle(Color color) {
    final bool isSelected = _accentColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          _accentColor = color;
        });
      },
      child: Container(
        margin: const EdgeInsets.right(12),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: [
            if (isSelected) BoxShadow(color: color.withOpacity(0.6), blurRadius: 8),
          ],
        ),
      ),
    );
  }

  void _showAddSnippetDialog(BuildContext context, TextEditingController titleCtrl, TextEditingController textCtrl) {
    String selectedCategory = 'General';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text('Add Floating Snippet', style: TextStyle(color: Colors.white, fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: const InputDecoration(
                    labelText: 'Snippet Label',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: textCtrl,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: const InputDecoration(
                    labelText: 'Text Content to Copy',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
              onPressed: () {
                if (titleCtrl.text.isNotEmpty && textCtrl.text.isNotEmpty) {
                  _addClipboardSnippet(titleCtrl.text, textCtrl.text, selectedCategory);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Save Snippet', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}