import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const SmartFloatApp());
}

class SmartFloatApp extends StatefulWidget {
  const SmartFloatApp({super.key});

  @override
  State<SmartFloatApp> createState() => _SmartFloatAppState();
}

class _SmartFloatAppState extends State<SmartFloatApp> {
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartFloat',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFA5B4FC),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: MainDockScreen(
        isDarkMode: _isDarkMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class MainDockScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const MainDockScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<MainDockScreen> createState() => _MainDockScreenState();
}

class _MainDockScreenState extends State<MainDockScreen> {
  int _currentIndex = 0;
  bool _floatingOverlayEnabled = true;
  bool _notificationPermissionGranted = true;
  bool _isFloatingBubbleExpanded = false;

  // Active floating toast preview state
  String? _activeToastMessage;
  IconData _activeToastIcon = Icons.star;

  void _triggerFloatingToast(String message, IconData icon) {
    setState(() {
      _activeToastMessage = message;
      _activeToastIcon = icon;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _activeToastMessage == message) {
        setState(() {
          _activeToastMessage = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.layers, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'SmartFloat Studio',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
            tooltip: 'Toggle Dark Mode',
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Screen content switcher
            IndexedStack(
              index: _currentIndex,
              children: [
                _buildHUDDockTab(),
                const SmartClipboardTab(),
                NotifierStudioTab(onTriggerBanner: _triggerFloatingToast),
                const MicroDecisionTab(),
              ],
            ),

            // Animated Simulated Floating Overlay Toast Banner
            if (_activeToastMessage != null)
              Positioned(
                top: 12,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.indigo,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white70),
                    ),
                    child: Row(
                      children: [
                        Icon(_activeToastIcon, color: Colors.amber, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _activeToastMessage!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            softWrap: true,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70, size: 18),
                          onPressed: () {
                            setState(() {
                              _activeToastMessage = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Simulated Draggable Floating Overlay Widget Bubble
            if (_floatingOverlayEnabled)
              Positioned(
                bottom: 80,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_isFloatingBubbleExpanded) ...[
                      _buildFloatingActionItem(
                        icon: Icons.content_paste,
                        label: 'Paste & Format',
                        color: Colors.teal,
                        onTap: () {
                          setState(() {
                            _currentIndex = 1;
                            _isFloatingBubbleExpanded = false;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildFloatingActionItem(
                        icon: Icons.notifications_active,
                        label: 'Banner Studio',
                        color: Colors.orange,
                        onTap: () {
                          setState(() {
                            _currentIndex = 2;
                            _isFloatingBubbleExpanded = false;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildFloatingActionItem(
                        icon: Icons.psychology,
                        label: 'Decision Wheel',
                        color: Colors.purple,
                        onTap: () {
                          setState(() {
                            _currentIndex = 3;
                            _isFloatingBubbleExpanded = false;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isFloatingBubbleExpanded = !_isFloatingBubbleExpanded;
                        });
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black87,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          _isFloatingBubbleExpanded ? Icons.close : Icons.widgets,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _isFloatingBubbleExpanded = false;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Floating Dock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: 'Smart Clip',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: 'Banner Studio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Decision Wheel',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black87,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHUDDockTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overlay permission HUD banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.indigo, Colors.blue],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bolt, color: Colors.amber, size: 28),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Floating Screen HUD Active',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'READY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'SmartFloat creates a live overlay bubble on top of other apps so you can format text, answer messages, and launch tools instantly.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  softWrap: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Permissions & Controls Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'System Overlay Controls',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Display Over Other Apps'),
                    subtitle: const Text('Enable floating action dock bubble on home screen'),
                    value: _floatingOverlayEnabled,
                    activeColor: Colors.indigo,
                    onChanged: (val) {
                      setState(() {
                        _floatingOverlayEnabled = val;
                      });
                      _triggerFloatingToast(
                        val ? 'Floating Dock Activated' : 'Floating Dock Disabled',
                        val ? Icons.check : Icons.info,
                      );
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Floating Notifications Banner'),
                    subtitle: const Text('Show dynamic top overlay alerts for clipboard actions'),
                    value: _notificationPermissionGranted,
                    activeColor: Colors.indigo,
                    onChanged: (val) {
                      setState(() {
                        _notificationPermissionGranted = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Interactive Screen Preview Mockup
          const Text(
            'Live HUD Desktop Preview',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade900,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo, width: 2),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.phone_android, color: Colors.white70, size: 48),
                      SizedBox(height: 8),
                      Text(
                        'Simulated Phone Screen View',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        'Tap the bottom-right bubble to expand quick dock tools!',
                        style: TextStyle(color: Colors.indigoAccent, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.stars, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Overlay Mode Active',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Quick Dock Features List
          const Text(
            'Floating Action Modules',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildModuleChip(Icons.content_paste, 'Text Extractor', Colors.teal),
              _buildModuleChip(Icons.auto_awesome, 'Tone Transformer', Colors.purple),
              _buildModuleChip(Icons.notifications_active, 'Overlay Banner', Colors.orange),
              _buildModuleChip(Icons.psychology, 'Decision Helper', Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModuleChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// TAB 2: Smart Clipboard & Text Studio
class SmartClipboardTab extends StatefulWidget {
  const SmartClipboardTab({super.key});

  @override
  State<SmartClipboardTab> createState() => _SmartClipboardTabState();
}

class _SmartClipboardTabState extends State<SmartClipboardTab> {
  final TextEditingController _textController = TextEditingController(
    text: 'Hey! Call me at +1 555 019 2834 or email support@smartfloat.app. Check https://flutter.dev for updates! Total cost is \$49.99.',
  );

  List<String> _extractedPhones = [];
  List<String> _extractedEmails = [];
  List<String> _extractedUrls = [];
  String _formattedResultText = '';
  String _selectedTone = 'Formal';

  @override
  void initState() {
    super.initState();
    _processText();
  }

  void _processText() {
    final raw = _textController.text;

    // Extract emails regex
    final emailRegex = RegExp(r'[a-zA-Z0-9.\-_]+@[a-zA-Z0-9.\-_]+\.[a-zA-Z]+');
    _extractedEmails = emailRegex.allMatches(raw).map((m) => m.group(0)!).toList();

    // Extract phone numbers simple regex
    final phoneRegex = RegExp(r'\+?[0-9][0-9\-\s]{8,14}[0-9]');
    _extractedPhones = phoneRegex.allMatches(raw).map((m) => m.group(0)!).toList();

    // Extract URLs regex
    final urlRegex = RegExp(r'https?://[^\s]+');
    _extractedUrls = urlRegex.allMatches(raw).map((m) => m.group(0)!).toList();

    _applyToneTransform(_selectedTone);
  }

  void _applyToneTransform(String tone) {
    setState(() {
      _selectedTone = tone;
      final text = _textController.text.trim();
      if (text.isEmpty) {
        _formattedResultText = '';
        return;
      }

      switch (tone) {
        case 'Formal':
          _formattedResultText = 'Dear Recipient,\n\nI am writing regarding the following details: "$text"\n\nPlease review at your earliest convenience.\n\nBest regards.';
          break;
        case 'Friendly':
          _formattedResultText = 'Hey there! 😊 Just wanted to share this with you:\n\n"$text"\n\nLet me know what you think!';
          break;
        case 'Viral/Caption':
          _formattedResultText = '🔥 You won\'t believe this! 👇\n\n$text\n\n#Productivity #SmartFloat #LifeHack #Tech';
          break;
        case 'Concise Summary':
          _formattedResultText = '• Key Content: $text\n• Emails Found: ${_extractedEmails.length}\n• Phones Found: ${_extractedPhones.length}';
          break;
        default:
          _formattedResultText = text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final wordCount = _textController.text.trim().isEmpty
        ? 0
        : _textController.text.trim().split(RegExp(r'\s+')).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.content_paste, color: Colors.indigo),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Smart Clipboard Extractor',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Paste any raw text or article to instantly parse emails, numbers, links, and transform messaging tones.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          // Raw Input Field
          TextField(
            controller: _textController,
            maxLines: 4,
            onChanged: (_) => _processText(),
            decoration: InputDecoration(
              labelText: 'Raw Text Input',
              hintText: 'Paste message or social snippet here...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _textController.clear();
                  _processText();
                },
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Live Metrics Badge Row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                avatar: const Icon(Icons.text_fields, size: 16, color: Colors.indigo),
                label: Text('Words: $wordCount'),
              ),
              Chip(
                avatar: const Icon(Icons.email, size: 16, color: Colors.teal),
                label: Text('Emails: ${_extractedEmails.length}'),
              ),
              Chip(
                avatar: const Icon(Icons.phone, size: 16, color: Colors.orange),
                label: Text('Phones: ${_extractedPhones.length}'),
              ),
              Chip(
                avatar: const Icon(Icons.link, size: 16, color: Colors.blue),
                label: Text('Links: ${_extractedUrls.length}'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Extracted Elements Card
          if (_extractedEmails.isNotEmpty || _extractedPhones.isNotEmpty || _extractedUrls.isNotEmpty) ...[
            Card(
              color: Colors.indigo.withOpacity(0.08),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Extracted Direct Data:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    ..._extractedEmails.map((e) => _buildExtractedRow(Icons.email, e, Colors.teal)),
                    ..._extractedPhones.map((p) => _buildExtractedRow(Icons.phone, p, Colors.orange)),
                    ..._extractedUrls.map((u) => _buildExtractedRow(Icons.link, u, Colors.blue)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Tone Selection Row
          const Text(
            'Instant Tone Transformer',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Formal', 'Friendly', 'Viral/Caption', 'Concise Summary'].map((tone) {
                final isSelected = _selectedTone == tone;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(tone),
                    selected: isSelected,
                    selectedColor: Colors.indigo,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (val) {
                      if (val) _applyToneTransform(tone);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Result Output Card
          Container(
            padding: const EdgeInsets.all(14),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.indigo.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Formatted Output ($_selectedTone)',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.indigo),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 18),
                      tooltip: 'Copy Transformed Text',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Transformed text copied to clipboard!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const Divider(),
                Text(
                  _formattedResultText,
                  style: const TextStyle(fontSize: 13),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtractedRow(IconData icon, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 16),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// TAB 3: Notifier & Overlay Banner Studio
class NotifierStudioTab extends StatefulWidget {
  final Function(String message, IconData icon) onTriggerBanner;

  const NotifierStudioTab({super.key, required this.onTriggerBanner});

  @override
  State<NotifierStudioTab> createState() => _NotifierStudioTabState();
}

class _NotifierStudioTabState extends State<NotifierStudioTab> {
  final TextEditingController _customBannerText = TextEditingController(
    text: '⚡ Meeting in 10 mins! Keep SmartFloat active.',
  );
  IconData _selectedBannerIcon = Icons.stars;

  final List<Map<String, dynamic>> _quickAlerts = [
    {'title': '🚀 Priority Reminder', 'text': 'Finish updating app presentation draft!', 'icon': Icons.bolt},
    {'title': '💡 Quick Idea', 'text': 'Add dark mode theme switch to customer app.', 'icon': Icons.lightbulb},
    {'title': '📞 Call Back Alert', 'text': 'Follow up with client regarding project scope.', 'icon': Icons.phone},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.notifications_active, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Floating Banner Notification Studio',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Create top floating overlay banners that stay visible over other apps during important tasks.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          // Custom Banner Creator
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trigger Custom Floating Banner',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _customBannerText,
                    decoration: InputDecoration(
                      labelText: 'Overlay Message Text',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Choose Icon: '),
                      const SizedBox(width: 10),
                      Wrap(
                        spacing: 8,
                        children: [
                          Icons.stars,
                          Icons.favorite,
                          Icons.warning,
                          Icons.check_circle,
                        ].map((icon) {
                          final isSelected = _selectedBannerIcon == icon;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedBannerIcon = icon;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.indigo : Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                icon,
                                color: isSelected ? Colors.white : Colors.black87,
                                size: 18,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Launch Floating Banner Now'),
                      onPressed: () {
                        if (_customBannerText.text.isNotEmpty) {
                          widget.onTriggerBanner(_customBannerText.text, _selectedBannerIcon);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Quick Preset Banners
          const Text(
            'Quick Floating Presets',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ..._quickAlerts.map((alert) {
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange.withOpacity(0.2),
                  child: Icon(alert['icon'] as IconData, color: Colors.orange),
                ),
                title: Text(
                  alert['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                subtitle: Text(
                  alert['text'] as String,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.send, color: Colors.indigo),
                  tooltip: 'Trigger Overlay',
                  onPressed: () {
                    widget.onTriggerBanner(alert['text'] as String, alert['icon'] as IconData);
                  },
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

// TAB 4: Micro Decision Studio & Quick Helper
class MicroDecisionTab extends StatefulWidget {
  const MicroDecisionTab({super.key});

  @override
  State<MicroDecisionTab> createState() => _MicroDecisionTabState();
}

class _MicroDecisionTabState extends State<MicroDecisionTab> {
  final List<String> _options = [
    'Take a 5-min walk 🚶',
    'Drink water 💧',
    'Quick phone call 📞',
    'Reply to emails ✉️',
    'Focused 15m Sprint ⚡',
  ];

  String _selectedDecision = 'Tap button to roll micro decision!';
  bool _isRolling = false;

  void _rollDecision() {
    setState(() {
      _isRolling = true;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      final random = Random();
      final choice = _options[random.nextInt(_options.length)];
      if (mounted) {
        setState(() {
          _selectedDecision = choice;
          _isRolling = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.psychology, color: Colors.purple),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Micro-Decision Engine',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Eliminate decision fatigue during your daily workflow with instant micro-decision picks.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          // Randomizer Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(Icons.tune, color: Colors.purple, size: 40),
                  const SizedBox(height: 12),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _selectedDecision,
                      key: ValueKey(_selectedDecision),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: _isRolling
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh),
                      label: Text(_isRolling ? 'Selecting...' : 'Spin Micro Decision'),
                      onPressed: _isRolling ? null : _rollDecision,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Current Pool Options
          const Text(
            'Current Decision Pool',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _options.map((opt) {
              return Chip(
                backgroundColor: Colors.purple.withOpacity(0.1),
                label: Text(opt, style: const TextStyle(fontSize: 12)),
                deleteIcon: const Icon(Icons.close, size: 14),
                onDeleted: () {
                  if (_options.length > 2) {
                    setState(() {
                      _options.remove(opt);
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Quick Split Helper Widget
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.calculate, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(
                        'Quick Bill & Tip Splitter HUD',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Quickly calculate 15% tip split for \$45.00 bill:',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Subtotal: \$45.00', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('Tip (15%): \$6.75', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                      Text('Total: \$51.75', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}