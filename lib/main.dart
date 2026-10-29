import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const FloatHubApp());
}

class FloatHubApp extends StatelessWidget {
  const FloatHubApp({super.key});

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'FloatHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF12121A),
      ),
      home: const MainDeskScreen(),
    );
  }
}

class MainDeskScreen extends StatefulWidget {
  const MainDeskScreen({super.key});

  @override
  State<MainDeskScreen> createState() => _MainDeskScreenState();
}

class _MainDeskScreenState extends State<MainDeskScreen>
    with SingleTickerProviderStateMixin {
  int _currentTab = 0;

  // Floating Overlay Bubble Position
  double _floatX = 25.0;
  double _floatY = 180.0;
  bool _isFloatExpanded = false;
  bool _isOverlayPermissionGranted = true;

  // Clipboard & Text Vault Data
  final List<String> _clipboardVault = [
    'https://example.com/item?utm_source=social&utm_medium=click_ref_9921',
    'Contact team at support@floathub.app or call +1 800 555 0199 for help.',
    'Quick meeting notes: Review M3 UI layout, finalize overlay notifications, push code.',
  ];
  final TextEditingController _textTransformerController =
      TextEditingController();

  // Floating Notification Hub
  final List<Map<String, String>> _pinnedNotifications = [
    {
      'title': '⚡ Quick Clipboard Active',
      'body': 'Tap float bubble to auto-format text',
      'tag': 'SYSTEM',
    },
    {
      'title': '📌 Daily Focus Target',
      'body': 'Complete app architecture & publish update',
      'tag': 'MEMO',
    },
  ];
  final TextEditingController _newNotifTitleController =
      TextEditingController();
  final TextEditingController _newNotifBodyController =
      TextEditingController();

  // Ambient Lounge State (Keeps user active in app)
  bool _isSoundPlaying = false;
  String _activeSound = '🌧️ Midnight Rain';
  double _soundVolume = 0.7;
  late AnimationController _animController;

  // Utility Converters
  final TextEditingController _aspectWidthController =
      TextEditingController(text: '1920');
  final TextEditingController _aspectHeightController =
      TextEditingController(text: '1080');
  String _aspectRatioResult = '16:9 (Widescreen HD)';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    _textTransformerController.dispose();
    _newNotifTitleController.dispose();
    _newNotifBodyController.dispose();
    _aspectWidthController.dispose();
    _aspectHeightController.dispose();
    super.dispose();
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // --- Utility Actions ---
  void _cleanTrackingUrls() {
    String text = _textTransformerController.text;
    if (text.isEmpty) return;
    Uri? uri = Uri.tryParse(text);
    if (uri != null && uri.hasQuery) {
      String cleanUrl = '${uri.scheme}://${uri.host}${uri.path}';
      setState(() {
        _textTransformerController.text = cleanUrl;
      });
      _showSnackBar('Tracking parameters stripped!');
    } else {
      // Remove query params manually with regex if needed
      String cleaned = text.replaceAll(RegExp(r'\?utm_[^&\s]+'), '');
      setState(() {
        _textTransformerController.text = cleaned;
      });
      _showSnackBar('Cleaned text parameters!');
    }
  }

  void _extractEmailsAndPhones() {
    String text = _textTransformerController.text;
    final emailRegExp = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    final phoneRegExp = RegExp(r'\+?[0-9\s\-\(\)]{8,}');

    final emails = emailRegExp.allMatches(text).map((m) => m.group(0)).toList();
    final phones = phoneRegExp.allMatches(text).map((m) => m.group(0)).toList();

    StringBuffer sb = StringBuffer();
    if (emails.isNotEmpty) {
      sb.writeln('--- Extracted Emails ---');
      for (var e in emails) {
        sb.writeln(e);
      }
    }
    if (phones.isNotEmpty) {
      sb.writeln('--- Extracted Numbers ---');
      for (var p in phones) {
        sb.writeln(p);
      }
    }

    if (sb.isEmpty) {
      _showSnackBar('No emails or phones detected.');
    } else {
      setState(() {
        _textTransformerController.text = sb.toString().trim();
      });
      _showSnackBar('Data extracted!');
    }
  }

  void _calculateAspectRatio() {
    double w = double.tryParse(_aspectWidthController.text) ?? 0;
    double h = double.tryParse(_aspectHeightController.text) ?? 0;
    if (w <= 0 || h <= 0) {
      setState(() {
        _aspectRatioResult = 'Please enter valid dimension numbers';
      });
      return;
    }
    double ratio = w / h;
    int gcd(int a, int b) => b == 0 ? a : gcd(b, a % b);
    int common = gcd(w.toInt(), h.toInt());
    int simplifiedW = w.toInt() ~/ common;
    int simplifiedH = h.toInt() ~/ common;

    setState(() {
      _aspectRatioResult =
          'Ratio: $simplifiedW:$simplifiedH (Factor: ${ratio.toStringAsFixed(2)})';
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Main Body Screens
          SafeArea(
            child: Column(
              children: [
                _buildHeaderBar(),
                Expanded(
                  child: IndexedStack(
                    index: _currentTab,
                    children: [
                      _buildClipboardVaultTab(),
                      _buildNotificationShadeTab(),
                      _buildAmbientLoungeTab(),
                      _buildMicroToolboxTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Interactive Floating Bubble Simulation Overlay
          Positioned(
            left: _floatX,
            top: _floatY,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _floatX += details.delta.dx;
                  _floatY += details.delta.dy;
                  // Keep bubble on screen
                  if (_floatX < 10) _floatX = 10;
                  if (_floatX > screenSize.width - 70) {
                    _floatX = screenSize.width - 70;
                  }
                  if (_floatY < 50) _floatY = 50;
                  if (_floatY > screenSize.height - 120) {
                    _floatY = screenSize.height - 120;
                  }
                });
              },
              child: _buildDraggableFloatingBubble(),
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
          onTap: (idx) => setState(() => _currentTab = idx),
          backgroundColor: const Color(0xFF1A1A26),
          selectedItemColor: Colors.deepPurpleAccent,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'Clip Vault',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.layers),
              label: 'Floating Hub',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.graphic_eq),
              label: 'Sound Lounge',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              label: 'Toolbox',
            ),
          ],
        ),
      ),
    );
  }

  // --- Header ---
  Widget _buildHeaderBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF181824),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.deepPurpleAccent),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FloatHub Engine',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Floating Utility & Desk Assistant',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _isOverlayPermissionGranted
                  ? Colors.green.withOpacity(0.2)
                  : Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isOverlayPermissionGranted
                    ? Colors.green
                    : Colors.amber,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isOverlayPermissionGranted
                      ? Icons.check_circle
                      : Icons.warning_amber,
                  size: 14,
                  color: _isOverlayPermissionGranted
                      ? Colors.green
                      : Colors.amber,
                ),
                const SizedBox(width: 4),
                Text(
                  _isOverlayPermissionGranted ? 'FLOAT ACTIVE' : 'GRANT OVERLAY',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _isOverlayPermissionGranted
                        ? Colors.green
                        : Colors.amber,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 1: Clipboard & Smart Vault ---
  Widget _buildClipboardVaultTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              'Contextual Text Transformer',
              'Paste text to clean URLs, format, or extract contact details instantly.',
              Icons.cleaning_services,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _textTransformerController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Paste messy text, links, or articles here...',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1E1E2C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white70),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.deepPurpleAccent),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    ClipboardData? data = await Clipboard.getData('text/plain');
                    if (data != null && data.text != null) {
                      setState(() {
                        _textTransformerController.text = data.text!;
                      });
                      _showSnackBar('Pasted from device clipboard!');
                    }
                  },
                  icon: const Icon(Icons.content_paste, size: 16),
                  label: const Text('Paste'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _cleanTrackingUrls,
                  icon: const Icon(Icons.link_off, size: 16),
                  label: const Text('Strip Tracking Links'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.tealAccent,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _extractEmailsAndPhones,
                  icon: const Icon(Icons.contacts, size: 16),
                  label: const Text('Extract Contacts'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.amberAccent,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    String text = _textTransformerController.text;
                    if (text.isNotEmpty) {
                      Clipboard.setData(ClipboardData(text: text));
                      if (!_clipboardVault.contains(text)) {
                        setState(() {
                          _clipboardVault.insert(0, text);
                        });
                      }
                      _showSnackBar('Copied to Clipboard Vault!');
                    }
                  },
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Copy & Save'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.greenAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(
              'Clipboard Vault History',
              'Quick access to previously saved clips.',
              Icons.history,
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _clipboardVault.length,
              itemBuilder: (context, index) {
                final item = _clipboardVault[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2C),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white70),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notes, color: Colors.grey, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy,
                            color: Colors.deepPurpleAccent, size: 18),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: item));
                          _showSnackBar('Copied snippet!');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.redAccent, size: 18),
                        onPressed: () {
                          setState(() {
                            _clipboardVault.removeAt(index);
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
      ),
    );
  }

  // --- TAB 2: Floating Notification Hub ---
  Widget _buildNotificationShadeTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              'System Overlay & Shade Launcher',
              'Pin live actionable widgets and custom notifications directly to your status shade.',
              Icons.layers,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.shade900.withOpacity(0.5),
                    const Color(0xFF1E1E2C),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Display Above Apps Permission',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Switch(
                        value: _isOverlayPermissionGranted,
                        activeColor: Colors.deepPurpleAccent,
                        onChanged: (val) {
                          setState(() {
                            _isOverlayPermissionGranted = val;
                          });
                          _showSnackBar(
                            val
                                ? 'Floating Overlay Service Active'
                                : 'Overlay Disabled',
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Allows the FloatHub quick bubble to stay accessible over messaging, browser, and social apps.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(
              'Create Pinned Shade Banner',
              'Add dynamic quick alerts to stay visible in system bar.',
              Icons.add_alert,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newNotifTitleController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Banner Title (e.g. 🛒 Shopping List)',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1E1E2C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white70),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _newNotifBodyController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Details / Quick Text...',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1E1E2C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white70),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_newNotifTitleController.text.trim().isNotEmpty) {
                    setState(() {
                      _pinnedNotifications.add({
                        'title': _newNotifTitleController.text.trim(),
                        'body': _newNotifBodyController.text.trim(),
                        'tag': 'CUSTOM',
                      });
                      _newNotifTitleController.clear();
                      _newNotifBodyController.clear();
                    });
                    _showSnackBar('Pinned to Notification Shade preview!');
                  }
                },
                icon: const Icon(Icons.push_pin, size: 18),
                label: const Text('Pin Notification to Status Bar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Active Pinned Banners Preview',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _pinnedNotifications.length,
              itemBuilder: (context, idx) {
                final notif = _pinnedNotifications[idx];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2C),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepPurple.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active,
                          color: Colors.amberAccent),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notif['title'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              notif['body'] ?? '',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _pinnedNotifications.removeAt(idx);
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
      ),
    );
  }

  // --- TAB 3: Ambient Sound Lounge (Session Retention Engine) ---
  Widget _buildAmbientLoungeTab() {
    final sounds = [
      {'name': '🌧️ Midnight Rain', 'desc': 'Calming steady rainfall'},
      {'name': '🌊 Deep Ocean Waves', 'desc': 'Rhythmic shore dynamics'},
      {'name': '☕ Cozy Coffeehouse', 'desc': 'Warm background hum'},
      {'name': '🔥 Campfire Glow', 'desc': 'Soothing wood crackle'},
      {'name': '🌌 Space Drift', 'desc': 'Subtle deep binaural tone'},
    ];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              'Ambient Audio Desk & Retention Lounge',
              'Keep FloatHub running seamlessly in the background while working or studying.',
              Icons.graphic_eq,
            ),
            const SizedBox(height: 16),

            // Sound Player Main Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.shade800,
                    Colors.indigo.shade900,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    _activeSound,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isSoundPlaying
                        ? 'Playing active soundscape in background...'
                        : 'Audio soundscape paused',
                    style: TextStyle(
                      color: _isSoundPlaying ? Colors.greenAccent : Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Animated Visualizer Bars
                  AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(9, (index) {
                          double heightFactor = _isSoundPlaying
                              ? (0.3 +
                                  0.7 *
                                      ((index % 3 == 0)
                                          ? _animController.value
                                          : (1 - _animController.value)))
                              : 0.15;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 40 * heightFactor,
                            decoration: BoxDecoration(
                              color: Colors.tealAccent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Volume Controls
                  Row(
                    children: [
                      const Icon(Icons.volume_down, color: Colors.white70),
                      Expanded(
                        child: Slider(
                          value: _soundVolume,
                          activeColor: Colors.tealAccent,
                          inactiveColor: Colors.white70,
                          onChanged: (val) {
                            setState(() {
                              _soundVolume = val;
                            });
                          },
                        ),
                      ),
                      const Icon(Icons.volume_up, color: Colors.white70),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Toggle Play/Pause
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isSoundPlaying = !_isSoundPlaying;
                      });
                      _showSnackBar(
                        _isSoundPlaying
                            ? 'Started ambient sound engine'
                            : 'Paused sound',
                      );
                    },
                    icon: Icon(
                      _isSoundPlaying ? Icons.pause : Icons.play_arrow,
                      size: 24,
                    ),
                    label: Text(_isSoundPlaying ? 'PAUSE AMBIENCE' : 'START AMBIENCE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Soundscape Spectrum',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sounds.length,
              itemBuilder: (context, i) {
                final s = sounds[i];
                final isSelected = _activeSound == s['name'];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.deepPurple.withOpacity(0.3)
                        : const Color(0xFF1E1E2C),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? Colors.deepPurpleAccent
                          : Colors.white70,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      s['name']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      s['desc']!,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle,
                            color: Colors.tealAccent)
                        : const Icon(Icons.play_circle_outline,
                            color: Colors.grey),
                    onTap: () {
                      setState(() {
                        _activeSound = s['name']!;
                        _isSoundPlaying = true;
                      });
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 4: Micro-Toolbox ---
  Widget _buildMicroToolboxTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              'Micro-Utility Desk',
              'Instant high-demand micro tools for daily usage.',
              Icons.widgets,
            ),
            const SizedBox(height: 16),

            // Aspect Ratio Calculator Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.aspect_ratio, color: Colors.deepPurpleAccent),
                      SizedBox(width: 8),
                      Text(
                        'Aspect Ratio & Dimension Helper',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _aspectWidthController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Width (px)',
                            labelStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: const Color(0xFF12121A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        child: Text('×'),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _aspectHeightController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Height (px)',
                            labelStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: const Color(0xFF12121A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _calculateAspectRatio,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Calculate'),
                      ),
                      Flexible(
                        child: Text(
                          _aspectRatioResult,
                          style: const TextStyle(
                            color: Colors.tealAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick QR & Text Quick-Share Action
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.qr_code_2, color: Colors.amberAccent),
                      SizedBox(width: 8),
                      Text(
                        'Instant Text-to-QR Generator',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Generate quick visible QR grid patterns for instant screen scanning without extra apps.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.qr_code,
                            size: 100,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'FloatHub Instant Matrix',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 10,
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
          ],
        ),
      ),
    );
  }

  // --- Draggable Floating Bubble Overlay Component ---
  Widget _buildDraggableFloatingBubble() {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isFloatExpanded)
            Container(
              width: 210,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.deepPurpleAccent, width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black87,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '⚡ Float QuickDesk',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Icon(Icons.touch_app, color: Colors.tealAccent, size: 14),
                    ],
                  ),
                  const Divider(color: Colors.white70, height: 12),
                  _buildFloatActionItem(
                    icon: Icons.content_paste_go,
                    label: 'Quick Paste Vault',
                    onTap: () async {
                      ClipboardData? data =
                          await Clipboard.getData('text/plain');
                      if (data != null && data.text != null) {
                        _showSnackBar('Quick Copied: ${data.text}');
                      }
                    },
                  ),
                  _buildFloatActionItem(
                    icon: _isSoundPlaying ? Icons.pause : Icons.play_arrow,
                    label: _isSoundPlaying ? 'Pause Ambience' : 'Start Ambience',
                    onTap: () {
                      setState(() {
                        _isSoundPlaying = !_isSoundPlaying;
                      });
                    },
                  ),
                  _buildFloatActionItem(
                    icon: Icons.cleaning_services,
                    label: 'Clean Text Link',
                    onTap: () {
                      _cleanTrackingUrls();
                    },
                  ),
                ],
              ),
            ),

          // Main Floating Trigger Icon
          GestureDetector(
            onTap: () {
              setState(() {
                _isFloatExpanded = !_isFloatExpanded;
              });
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Colors.deepPurpleAccent, Colors.tealAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurpleAccent.withOpacity(0.5),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                _isFloatExpanded ? Icons.close : Icons.widgets,
                color: Colors.black,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        onTap();
        setState(() {
          _isFloatExpanded = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepPurpleAccent, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Section Header
  Widget _buildSectionHeader(String title, String subtitle, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.deepPurpleAccent, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}