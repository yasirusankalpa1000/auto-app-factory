import 'package:flutter/material.dart';

void main() {
  runApp(const BubbleHudApp());
}

class BubbleHudApp extends StatefulWidget {
  const BubbleHudApp({super.key});

  @override
  State<BubbleHudApp> createState() => _BubbleHudAppState();
}

class _BubbleHudAppState extends State<BubbleHudApp> {
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BubbleHUD',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: MainHudScreen(
        isDarkMode: _isDarkMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class ClipboardItem {
  final String id;
  final String content;
  final String category;
  final DateTime timestamp;

  ClipboardItem({
    required this.id,
    required this.content,
    required this.category,
    required this.timestamp,
  });
}

class MainHudScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const MainHudScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<MainHudScreen> createState() => _MainHudScreenState();
}

class _MainHudScreenState extends State<MainHudScreen> {
  int _currentIndex = 0;

  // Floating Overlay Settings
  bool _overlayPermission = true;
  bool _notificationPermission = true;
  bool _isBubbleActive = true;
  bool _showDynamicIsland = true;
  double _bubbleOpacity = 0.9;
  double _bubbleSize = 58.0;
  String _activeTheme = 'Neon Cyan';

  // Floating Banner Alert state
  bool _isBannerVisible = false;
  String _bannerTitle = '';
  String _bannerMessage = '';

  // Clipboard Stack
  final List<ClipboardItem> _clipboardStack = [
    ClipboardItem(
      id: '1',
      content: 'https://example.com/share?utm_source=tracker&ref=123',
      category: 'URL Link',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ClipboardItem(
      id: '2',
      content: 'Meeting passcode: 8829-4102-SECURE',
      category: 'Security Code',
      timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
    ),
    ClipboardItem(
      id: '3',
      content: 'Hey, I am currently in a meeting. Will call you back in 15 mins!',
      category: 'Quick Reply',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  // Micro Calc State
  String _calcDisplay = '0';
  String _calcSubDisplay = '';
  double? _firstOperand;
  String? _operator;
  bool _shouldResetCalc = false;

  // Scratchpad
  final TextEditingController _scratchpadController = TextEditingController(
    text: 'Floating Sticky Note:\n- Buy groceries\n- Review project specs\n- Clean clipboard history',
  );

  // Audio Ambient State
  bool _isAudioPlaying = false;
  String _currentSoundTrack = 'Rain Ambient HUD';

  void _triggerFloatingBanner(String title, String message) {
    setState(() {
      _bannerTitle = title;
      _bannerMessage = message;
      _isBannerVisible = true;
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _isBannerVisible = false;
        });
      }
    });
  }

  void _addClipboardSnippet(String text, String category) {
    if (text.trim().isEmpty) return;
    setState(() {
      _clipboardStack.insert(
        0,
        ClipboardItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: text.trim(),
          category: category,
          timestamp: DateTime.now(),
        ),
      );
    });
    _triggerFloatingBanner('Clipboard Saved', 'Added snippet to Floating HUD Stack');
  }

  void _cleanAndSanitizeUrl(int index) {
    String raw = _clipboardStack[index].content;
    if (raw.contains('?')) {
      String cleaned = raw.split('?').first;
      setState(() {
        _clipboardStack[index] = ClipboardItem(
          id: _clipboardStack[index].id,
          content: cleaned,
          category: 'Cleaned Link',
          timestamp: DateTime.now(),
        );
      });
      _triggerFloatingBanner('URL Sanitized', 'Tracking parameters stripped successfully!');
    } else {
      _triggerFloatingBanner('URL Clean', 'No extra tracking parameters found.');
    }
  }

  void _onCalcNumberPress(String val) {
    setState(() {
      if (_calcDisplay == '0' || _shouldResetCalc) {
        _calcDisplay = val;
        _shouldResetCalc = false;
      } else {
        _calcDisplay += val;
      }
    });
  }

  void _onCalcOpPress(String op) {
    setState(() {
      _firstOperand = double.tryParse(_calcDisplay);
      _operator = op;
      _calcSubDisplay = '$_calcDisplay $op';
      _shouldResetCalc = true;
    });
  }

  void _onCalcEquals() {
    if (_firstOperand == null || _operator == null) return;
    double second = double.tryParse(_calcDisplay) ?? 0.0;
    double result = 0.0;

    switch (_operator) {
      case '+':
        result = _firstOperand! + second;
        break;
      case '-':
        result = _firstOperand! - second;
        break;
      case '×':
        result = _firstOperand! * second;
        break;
      case '÷':
        result = second != 0 ? _firstOperand! / second : 0.0;
        break;
    }

    setState(() {
      _calcDisplay = result % 1 == 0 ? result.toInt().toString() : result.toStringAsFixed(2);
      _calcSubDisplay = '';
      _firstOperand = null;
      _operator = null;
      _shouldResetCalc = true;
    });
  }

  void _onCalcClear() {
    setState(() {
      _calcDisplay = '0';
      _calcSubDisplay = '';
      _firstOperand = null;
      _operator = null;
      _shouldResetCalc = false;
    });
  }

  @override
  void dispose() {
    _scratchpadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHudPlaygroundTab(),
      _buildClipboardEngineTab(),
      _buildNotificationTriggersTab(),
      _buildMiniDeskTab(),
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildTopHeader(),
                Expanded(child: pages[_currentIndex]),
              ],
            ),
            if (_isBannerVisible) _buildAnimatedOverlayBanner(),
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
            icon: Icon(Icons.bubble_chart),
            selectedIcon: Icon(Icons.bubble_chart, color: Colors.indigo),
            label: 'HUD Desk',
          ),
          NavigationDestination(
            icon: Icon(Icons.copy),
            selectedIcon: Icon(Icons.copy, color: Colors.indigo),
            label: 'Clipboard Stack',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_active),
            selectedIcon: Icon(Icons.notifications_active, color: Colors.indigo),
            label: 'Floating Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.widgets),
            selectedIcon: Icon(Icons.widgets, color: Colors.indigo),
            label: 'Mini Tools',
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bubble_chart, color: Colors.indigo, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BubbleHUD Command',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _isBubbleActive ? 'Floating Assistant Active' : 'Overlay Hibernating',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isBubbleActive ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: widget.onToggleTheme,
            tooltip: 'Toggle Theme',
          ),
          Switch(
            value: _isBubbleActive,
            activeColor: Colors.indigo,
            onChanged: (val) {
              setState(() {
                _isBubbleActive = val;
              });
              _triggerFloatingBanner(
                val ? 'HUD Enabled' : 'HUD Suspended',
                val ? 'Floating Overlay head is visible on screen.' : 'Overlay hidden from desktop.',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedOverlayBanner() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF1E1E2E),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.indigo.withOpacity(0.6), width: 1.5),
            gradient: const LinearGradient(
              colors: [Color(0xFF1E1E2E), Color(0xFF2D2D44)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.indigo,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainMin: MainAxisSize.min,
                  children: [
                    Text(
                      _bannerTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _bannerMessage,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey, size: 18),
                onPressed: () {
                  setState(() {
                    _isBannerVisible = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TAB 1: HUD Playground & Interactive Phone Screen Simulator
  Widget _buildHudPlaygroundTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPermissionAlertCard(),
          const SizedBox(height: 16),
          const Text(
            'Live Screen Floating Overlay',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildPhoneSimulatorCanvas(),
          const SizedBox(height: 20),
          const Text(
            'Floating Bubble Customizer',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildBubbleControlsCard(),
        ],
      ),
    );
  }

  Widget _buildPermissionAlertCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.indigo.withOpacity(0.2)),
      ),
      color: Colors.indigo.withOpacity(0.08),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.security, color: Colors.indigo),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Floating System Permissions',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                Chip(
                  label: Text(
                    (_overlayPermission && _notificationPermission) ? 'READY' : 'ACTION NEEDED',
                    style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: (_overlayPermission && _notificationPermission) ? Colors.green : Colors.orange,
                  padding: EdgeInsets.zero,
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text('Display Above Other Apps', style: TextStyle(fontSize: 13)),
                ),
                Switch(
                  value: _overlayPermission,
                  activeColor: Colors.indigo,
                  onChanged: (val) {
                    setState(() {
                      _overlayPermission = val;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text('Floating Notification Listener', style: TextStyle(fontSize: 13)),
                ),
                Switch(
                  value: _notificationPermission,
                  activeColor: Colors.indigo,
                  onChanged: (val) {
                    setState(() {
                      _notificationPermission = val;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneSimulatorCanvas() {
    return Container(
      height: 320,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.indigo.withOpacity(0.4), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background phone screen wallpaper simulation
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone_android, size: 64, color: Colors.indigo.withOpacity(0.2)),
                const SizedBox(height: 8),
                Text(
                  'Interactive Mobile Canvas',
                  style: TextStyle(color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.bold),
                ),
                Text(
                  'Tap floating widgets to test actions',
                  style: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 11),
                ),
              ],
            ),
          ),

          // Dynamic Island Top Bar Preview
          if (_showDynamicIsland)
            Positioned(
              top: 12,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    _triggerFloatingBanner('Dynamic HUD Banner', 'Expanded top notification bar on active display.');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.indigo.withOpacity(0.5), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'BubbleHUD Active',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.music_note, color: Colors.indigoAccent, size: 14),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Main Floating Head Bubble (Draggable feel / Clickable)
          if (_isBubbleActive)
            Positioned(
              top: 110,
              right: 24,
              child: GestureDetector(
                onTap: () {
                  _triggerFloatingBanner(
                    'Floating Bubble Clicked',
                    'Quick drawer trigger opened. Clipboard stack ready.',
                  );
                },
                child: Opacity(
                  opacity: _bubbleOpacity,
                  child: Container(
                    width: _bubbleSize,
                    height: _bubbleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colors.indigo, Colors.blueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.5),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.bubble_chart, color: Colors.white, size: 28),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Edge Drawer Shortcut HUD (Left side)
          Positioned(
            left: 0,
            top: 100,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.85),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.content_paste, color: Colors.white, size: 18),
                    onPressed: () {
                      _triggerFloatingBanner('Floating Clipboard Quick View', 'Showing top item: "${_clipboardStack.first.content}"');
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(height: 12),
                  IconButton(
                    icon: const Icon(Icons.calculate, color: Colors.white, size: 18),
                    onPressed: () {
                      _triggerFloatingBanner('Floating Calc Widget', 'Display: $_calcDisplay');
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(height: 12),
                  IconButton(
                    icon: const Icon(Icons.edit_note, color: Colors.white, size: 18),
                    onPressed: () {
                      _triggerFloatingBanner('Floating Scratchpad', 'Quick Note open in overlay window.');
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar HUD Status
          Positioned(
            bottom: 12,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Theme: $_activeTheme',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  Text(
                    'Clippings: ${_clipboardStack.length}',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubbleControlsCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Dynamic Island Banner:', style: TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                Switch(
                  value: _showDynamicIsland,
                  activeColor: Colors.indigo,
                  onChanged: (val) {
                    setState(() {
                      _showDynamicIsland = val;
                    });
                  },
                ),
              ],
            ),
            const Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Floating Bubble Size:', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('${_bubbleSize.toInt()} px', style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: _bubbleSize,
                  min: 40.0,
                  max: 80.0,
                  activeColor: Colors.indigo,
                  onChanged: (val) {
                    setState(() {
                      _bubbleSize = val;
                    });
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Bubble Opacity:', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('${(_bubbleOpacity * 100).toInt()}%', style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: _bubbleOpacity,
                  min: 0.3,
                  max: 1.0,
                  activeColor: Colors.indigo,
                  onChanged: (val) {
                    setState(() {
                      _bubbleOpacity = val;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Overlay Theme:', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<String>(
                    value: _activeTheme,
                    isExpanded: true,
                    underline: Container(height: 1, color: Colors.indigo),
                    items: ['Neon Cyan', 'Cyber Purple', 'Stealth Dark', 'Solar Gold']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _activeTheme = val;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: Smart Clipboard Stack & Context Engine
  Widget _buildClipboardEngineTab() {
    final TextEditingController inputController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAddClipboardCard(inputController),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Clipboard HUD Stack',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _clipboardStack.clear();
                  });
                  _triggerFloatingBanner('Clipboard Cleared', 'Stack history emptied.');
                },
                icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                label: const Text('Clear All', style: TextStyle(color: Colors.red, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _clipboardStack.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: widget.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.content_paste_off, size: 48, color: Colors.grey),
                      SizedBox(height: 12),
                      Text('Clipboard Stack Empty', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Copied text snippets will appear floating here automatically.', style: TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.center),
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _clipboardStack.length,
                  itemBuilder: (context, index) {
                    final item = _clipboardStack[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.indigo.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item.category,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${item.timestamp.hour}:${item.timestamp.minute.toString().padLeft(2, '0')}',
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SelectableText(
                              item.content,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () {
                                    _triggerFloatingBanner('Copied to Clipboard', 'Snippet ready to paste anywhere.');
                                  },
                                  icon: const Icon(Icons.copy, size: 14),
                                  label: const Text('Copy', style: TextStyle(fontSize: 11)),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                    minimumSize: const Size(0, 30),
                                  ),
                                ),
                                if (item.content.startsWith('http'))
                                  OutlinedButton.icon(
                                    onPressed: () => _cleanAndSanitizeUrl(index),
                                    icon: const Icon(Icons.cleaning_services, size: 14, color: Colors.teal),
                                    label: const Text('Sanitize URL', style: TextStyle(fontSize: 11, color: Colors.teal)),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                      minimumSize: const Size(0, 30),
                                    ),
                                  ),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _scratchpadController.text += '\n• ${item.content}';
                                    });
                                    _triggerFloatingBanner('Added to Scratchpad', 'Appended snippet to sticky notes.');
                                  },
                                  icon: const Icon(Icons.push_pin, size: 14, color: Colors.orange),
                                  label: const Text('Pin to Sticky', style: TextStyle(fontSize: 11, color: Colors.orange)),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                    minimumSize: const Size(0, 30),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                                  onPressed: () {
                                    setState(() {
                                      _clipboardStack.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildAddClipboardCard(TextEditingController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Snippet to HUD Stack',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Paste text, URL, code snippet, or note...',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      String cat = 'Quick Note';
                      if (controller.text.startsWith('http')) cat = 'URL Link';
                      _addClipboardSnippet(controller.text, cat);
                      controller.clear();
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Push to Stack'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // TAB 3: Floating Notification Trigger & Alerts Center
  Widget _buildNotificationTriggersTab() {
    final TextEditingController notifTitleCtrl = TextEditingController(text: 'Incoming Message');
    final TextEditingController notifMsgCtrl = TextEditingController(text: 'Hey! Are we still meeting for coffee at 4 PM?');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.bolt, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'Simulate Overlay Notification',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Test how floating heads and banner notifications appear while using other apps.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: notifTitleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Alert Header',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: notifMsgCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Notification Content',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _triggerFloatingBanner(notifTitleCtrl.text, notifMsgCtrl.text);
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Fire Floating Overlay'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Quick Stealth Auto-Replies',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildQuickReplyTile('On the way, give me 10 mins!'),
          _buildQuickReplyTile('In a call right now, send a text.'),
          _buildQuickReplyTile('Got it! Thanks for updating me.'),
          _buildQuickReplyTile('Please send the attachment link.'),
        ],
      ),
    );
  }

  Widget _buildQuickReplyTile(String replyText) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: ListTile(
        dense: true,
        title: Text(replyText, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        trailing: IconButton(
          icon: const Icon(Icons.send, color: Colors.indigo, size: 18),
          onPressed: () {
            _addClipboardSnippet(replyText, 'Quick Reply');
            _triggerFloatingBanner('Auto-Reply Ready', 'Saved snippet to floating stack!');
          },
        ),
      ),
    );
  }

  // TAB 4: Floating Mini-Desk Tools (Quick Calc, Scratchpad, Ambient Player)
  Widget _buildMiniDeskTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Desk Overlay Tools',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildFloatingCalcCard(),
          const SizedBox(height: 16),
          _buildFloatingScratchpadCard(),
          const SizedBox(height: 16),
          _buildAmbientAudioCard(),
        ],
      ),
    );
  }

  Widget _buildFloatingCalcCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.calculate, color: Colors.indigo),
                SizedBox(width: 8),
                Text('Floating Calc HUD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (_calcSubDisplay.isNotEmpty)
                    Text(_calcSubDisplay, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  Text(
                    _calcDisplay,
                    style: const TextStyle(color: Colors.greenAccent, fontSize: 24, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                Row(
                  children: [
                    _calcBtn('7', () => _onCalcNumberPress('7')),
                    _calcBtn('8', () => _onCalcNumberPress('8')),
                    _calcBtn('9', () => _onCalcNumberPress('9')),
                    _calcBtn('÷', () => _onCalcOpPress('÷'), color: Colors.orange),
                  ],
                ),
                Row(
                  children: [
                    _calcBtn('4', () => _onCalcNumberPress('4')),
                    _calcBtn('5', () => _onCalcNumberPress('5')),
                    _calcBtn('6', () => _onCalcNumberPress('6')),
                    _calcBtn('×', () => _onCalcOpPress('×'), color: Colors.orange),
                  ],
                ),
                Row(
                  children: [
                    _calcBtn('1', () => _onCalcNumberPress('1')),
                    _calcBtn('2', () => _onCalcNumberPress('2')),
                    _calcBtn('3', () => _onCalcNumberPress('3')),
                    _calcBtn('-', () => _onCalcOpPress('-'), color: Colors.orange),
                  ],
                ),
                Row(
                  children: [
                    _calcBtn('C', _onCalcClear, color: Colors.redAccent),
                    _calcBtn('0', () => _onCalcNumberPress('0')),
                    _calcBtn('=', _onCalcEquals, color: Colors.green),
                    _calcBtn('+', () => _onCalcOpPress('+'), color: Colors.orange),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _calcBtn(String label, VoidCallback onTap, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            backgroundColor: color ?? (widget.isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            foregroundColor: color != null ? Colors.white : (widget.isDarkMode ? Colors.white : Colors.black),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildFloatingScratchpadCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.edit_note, color: Colors.orange),
                const SizedBox(width: 8),
                const Text('Floating Sticky Notes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () {
                    _addClipboardSnippet(_scratchpadController.text, 'Scratchpad Note');
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _scratchpadController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type quick floating notes...',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmbientAudioCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.graphic_eq, color: Colors.purple),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Floating Ambient Noise HUD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(_currentSoundTrack, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            IconButton(
              icon: Icon(_isAudioPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, color: Colors.indigo, size: 36),
              onPressed: () {
                setState(() {
                  _isAudioPlaying = !_isAudioPlaying;
                });
                _triggerFloatingBanner(
                  _isAudioPlaying ? 'Ambient Playing' : 'Ambient Paused',
                  _isAudioPlaying ? 'Background focus sound active on floating layer.' : 'Sound stream paused.',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}