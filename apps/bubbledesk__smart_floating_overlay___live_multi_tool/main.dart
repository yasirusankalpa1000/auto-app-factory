import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BubbleDeskApp());
}

class BubbleDeskApp extends StatelessWidget {
  const BubbleDeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BubbleDesk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
          surface: const Color(0xFF181824),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0F17),
        cardTheme: CardTheme(
          color: const Color(0xFF222232),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
  int _selectedIndex = 0;

  // Floating Overlay System State
  bool _isOverlayActive = true;
  bool _isFloatingExpanded = false;
  Offset _bubblePosition = const Offset(20, 200);
  String _floatingNoteText = '';
  
  // App State Data
  bool _displayPermissionGranted = true;
  bool _notificationPermissionGranted = true;
  
  // Clipboard Matrix Data
  final List<Map<String, String>> _clipboardMatrix = [
    {
      'title': 'Meeting Agenda Draft',
      'content': '1. Review Q3 metrics\n2. Demo BubbleDesk overlay\n3. Finalize release candidate',
      'tag': 'Work'
    },
    {
      'title': 'Support Phone Line',
      'content': '+18005550199',
      'tag': 'Phone'
    },
    {
      'title': 'Product Web Portal',
      'content': 'https://bubbledesk.app/live-hub',
      'tag': 'Links'
    },
  ];

  // Quick Action Utilities State
  final TextEditingController _quickPhoneController = TextEditingController();
  final TextEditingController _quickMessageController = TextEditingController();
  final TextEditingController _textSanitizerController = TextEditingController();
  String _sanitizerOutput = '';
  
  // Productivity Stats
  int _copyCount = 14;
  int _timeSavedMinutes = 38;

  @override
  void dispose() {
    _quickPhoneController.dispose();
    _quickMessageController.dispose();
    _textSanitizerController.dispose();
    super.dispose();
  }

  void _addClipboardSnippet(String title, String content, String tag) {
    setState(() {
      _clipboardMatrix.insert(0, {
        'title': title.isEmpty ? 'Quick Clip' : title,
        'content': content,
        'tag': tag,
      });
      _copyCount++;
      _timeSavedMinutes += 2;
    });
  }

  void _sanitizeText(String mode) {
    final raw = _textSanitizerController.text;
    if (raw.isEmpty) return;

    String result = raw;
    if (mode == 'clean') {
      result = raw.replaceAll(RegExp(r'\s+'), ' ').trim();
    } else if (mode == 'uppercase') {
      result = raw.toUpperCase();
    } else if (mode == 'lowercase') {
      result = raw.toLowerCase();
    } else if (mode == 'extract_phones') {
      final matches = RegExp(r'\+?[0-9]{7,15}').allMatches(raw);
      result = matches.map((m) => m.group(0)).join('\n');
      if (result.isEmpty) result = 'No phone numbers detected.';
    } else if (mode == 'extract_links') {
      final matches = RegExp(r'https?://[^\s]+').allMatches(raw);
      result = matches.map((m) => m.group(0)).join('\n');
      if (result.isEmpty) result = 'No links detected.';
    }

    setState(() {
      _sanitizerOutput = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Main Body Tabs
          SafeArea(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildFloatingHubTab(),
                _buildQuickToolsTab(),
                _buildClipboardMatrixTab(),
                _buildScreenRulerTab(),
                _buildSettingsTab(),
              ],
            ),
          ),

          // Simulated Interactive Floating Bubble Overlay
          if (_isOverlayActive)
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    double newX = _bubblePosition.dx + details.delta.dx;
                    double newY = _bubblePosition.dy + details.delta.dy;
                    // Clamp to screen bounds
                    newX = newX.clamp(10.0, size.width - 70.0);
                    newY = newY.clamp(30.0, size.height - 120.0);
                    _bubblePosition = Offset(newX, newY);
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'main_floating_bubble',
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          _isFloatingExpanded = !_isFloatingExpanded;
                        });
                      },
                      child: const Icon(Icons.bubble_chart),
                    ),
                    if (_isFloatingExpanded)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: 240,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF28283C),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.deepPurpleAccent, width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black87,
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.flash_on, color: Colors.amber, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      'Desk Overlay',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isFloatingExpanded = false;
                                    });
                                  },
                                  child: const Icon(Icons.close, size: 16, color: Colors.grey),
                                )
                              ],
                            ),
                            const Divider(color: Colors.grey, height: 16),
                            const Text(
                              'Quick Scratchpad:',
                              style: TextStyle(color: Colors.white70, fontSize: 10),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              maxLines: 2,
                              style: const TextStyle(fontSize: 11, color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Type fast note here...',
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 11),
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(6),
                              ),
                              onChanged: (val) {
                                _floatingNoteText = val;
                              },
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () {
                                      if (_floatingNoteText.isNotEmpty) {
                                        _addClipboardSnippet('Floating Note', _floatingNoteText, 'Drafts');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Saved note to Dropzone!'),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text('Save Note', style: TextStyle(fontSize: 10, color: Colors.white)),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: _floatingNoteText));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Copied to system clipboard!'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: const Text('Copy All', style: TextStyle(fontSize: 10, color: Colors.white)),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF14141F),
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bubble_chart),
            label: 'Overlay Dock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on),
            label: 'Direct Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: 'Dropzone',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.straighten),
            label: 'Screen Suite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Control',
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating Dock & Dynamic Island Simulator
  Widget _buildFloatingHubTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.deepPurple, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.layers, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'BubbleDesk Overlay System',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            softWrap: true,
                          ),
                          Text(
                            _isOverlayActive ? 'Active Floating Bubble Engine' : 'Floating Engine Paused',
                            style: TextStyle(
                              color: _isOverlayActive ? Colors.greenAccent : Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text(
                        'Display Over Other Apps',
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Switch(
                      value: _isOverlayActive,
                      activeColor: Colors.greenAccent,
                      onChanged: (val) {
                        setState(() {
                          _isOverlayActive = val;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Live Engagement Banner
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.stars, color: Colors.amber, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Daily Efficiency Gain',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Saved ~$_timeSavedMinutes mins today across $_copyCount floating actions!',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Quick Overlay Toggles',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              _buildFeatureChip(
                icon: Icons.chat,
                label: 'Unsaved WA Dial',
                color: Colors.teal,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              _buildFeatureChip(
                icon: Icons.cleaning_services,
                label: 'Text Sanitizer',
                color: Colors.blue,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              _buildFeatureChip(
                icon: Icons.content_paste,
                label: 'Dropzone Stack',
                color: Colors.purple,
                onTap: () => setState(() => _selectedIndex = 2),
              ),
              _buildFeatureChip(
                icon: Icons.straighten,
                label: 'Screen Ruler',
                color: Colors.orange,
                onTap: () => setState(() => _selectedIndex = 3),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Interactive Drag Hint Card
          Card(
            color: const Color(0xFF1C1C2B),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.touch_app, color: Colors.deepPurpleAccent),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Interactive Overlay Bubble',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Look at the floating purple bubble on your screen! Drag it anywhere, tap it to expand the quick note widget, and copy thoughts without leaving your current screen.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    softWrap: true,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      minimumSize: const Size(double.infinity, 38),
                    ),
                    onPressed: () {
                      setState(() {
                        _bubblePosition = const Offset(50, 250);
                        _isFloatingExpanded = true;
                      });
                    },
                    icon: const Icon(Icons.center_focus_strong, size: 16, color: Colors.white),
                    label: const Text('Center & Open Overlay', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: Direct Utility Tools (WhatsApp No-Save Chat & Text Sanitizer)
  Widget _buildQuickToolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Direct Communication & Text Studio',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Solve daily micro-frustrations instantly without saving contacts.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // WhatsApp Unsaved Chat Generator
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.message, color: Colors.teal),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Direct WhatsApp (No Contact Saved)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _quickPhoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      labelText: 'Phone Number (with country code)',
                      hintText: 'e.g. +14155552671',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _quickMessageController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      labelText: 'Pre-filled Optional Message',
                      hintText: 'Hello, regarding your listing...',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: () {
                        final phone = _quickPhoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
                        if (phone.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a valid phone number.')),
                          );
                          return;
                        }
                        final msg = Uri.encodeComponent(_quickMessageController.text);
                        final waUrl = 'https://wa.me/$phone?text=$msg';
                        
                        Clipboard.setData(ClipboardData(text: waUrl));
                        _addClipboardSnippet('Direct Chat Link', waUrl, 'Links');
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Copied Direct Link: wa.me/$phone'),
                            action: SnackBarAction(
                              label: 'OK',
                              onPressed: () {},
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.open_in_new, color: Colors.white, size: 18),
                      label: const Text('Generate Direct WhatsApp Link', style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Smart Text Sanitizer Studio
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.amber),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Smart Text Sanitizer & Extractor',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _textSanitizerController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Paste raw messy text, email blocks, or links here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.cleaning_services, size: 14, color: Colors.white),
                        label: const Text('Remove Extra Spaces', style: TextStyle(fontSize: 11)),
                        onPressed: () => _sanitizeText('clean'),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.text_fields, size: 14, color: Colors.white),
                        label: const Text('UPPERCASE', style: TextStyle(fontSize: 11)),
                        onPressed: () => _sanitizeText('uppercase'),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.phone, size: 14, color: Colors.white),
                        label: const Text('Extract Phones', style: TextStyle(fontSize: 11)),
                        onPressed: () => _sanitizeText('extract_phones'),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.link, size: 14, color: Colors.white),
                        label: const Text('Extract Links', style: TextStyle(fontSize: 11)),
                        onPressed: () => _sanitizeText('extract_links'),
                      ),
                    ],
                  ),
                  if (_sanitizerOutput.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text('Sanitized Result:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141420),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade800),
                      ),
                      child: SelectableText(
                        _sanitizerOutput,
                        style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontFamily: 'monospace'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _sanitizerOutput));
                          _addClipboardSnippet('Sanitized Output', _sanitizerOutput, 'Work');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Result copied & saved to Dropzone!')),
                          );
                        },
                        icon: const Icon(Icons.copy, size: 14),
                        label: const Text('Copy Result', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // TAB 3: Dynamic Clipboard Matrix & Dropzone Hub
  Widget _buildClipboardMatrixTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dropzone & Pinned Clips',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      'Multi-slot dynamic clipboard matrix',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.deepPurpleAccent, size: 30),
                onPressed: () => _showAddClipDialog(),
              )
            ],
          ),
          const SizedBox(height: 16),

          if (_clipboardMatrix.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text('Dropzone empty. Tap + to add clips!', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _clipboardMatrix.length,
              itemBuilder: (context, index) {
                final item = _clipboardMatrix[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getTagColor(item['tag'] ?? 'Work'),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item['tag'] ?? 'Work',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.copy, size: 18, color: Colors.grey),
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: item['content'] ?? ''));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Copied clip to system clipboard!')),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                                  onPressed: () {
                                    setState(() {
                                      _clipboardMatrix.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['title'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['content'] ?? '',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
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

  // TAB 4: On-Screen Ruler & Measurement Suite
  Widget _buildScreenRulerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Screen Measurement & Grid HUD',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Calibrated digital screen ruler & precision measuring tool.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 20),

          // Simulated Interactive On-Screen Ruler
          Card(
            color: const Color(0xFF161622),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('0 px', style: TextStyle(color: Colors.amber, fontSize: 10)),
                      Text('100 px', style: TextStyle(color: Colors.amber, fontSize: 10)),
                      Text('200 px', style: TextStyle(color: Colors.amber, fontSize: 10)),
                      Text('300 px', style: TextStyle(color: Colors.amber, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.amberAccent),
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomPaint(
                      painter: RulerPainter(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Place any physical object or align design elements directly on your screen to measure.',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Quick Screen Tools Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Precision Quick Tools',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.color_lens, color: Colors.purpleAccent),
                    title: const Text('Screen Color Inspector', style: TextStyle(fontSize: 13, color: Colors.white)),
                    subtitle: const Text('Extract HEX / RGB codes live from screen overlay', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    trailing: Switch(value: true, onChanged: (v) {}),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.grid_on, color: Colors.blueAccent),
                    title: const Text('Alignment Crosshair Overlay', style: TextStyle(fontSize: 13, color: Colors.white)),
                    subtitle: const Text('Display alignment crosshairs on top of all apps', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    trailing: Switch(value: false, onChanged: (v) {}),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // TAB 5: System Permissions & App Controls
  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Control & Permissions',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ensure all permissions are enabled for seamless floating execution.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.layers, color: Colors.deepPurpleAccent),
                  title: const Text('Display Over Apps Permission', style: TextStyle(fontSize: 13, color: Colors.white)),
                  subtitle: const Text('Required for persistent floating dock overlay', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  value: _displayPermissionGranted,
                  onChanged: (val) {
                    setState(() {
                      _displayPermissionGranted = val;
                      _isOverlayActive = val;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_active, color: Colors.amber),
                  title: const Text('Notification Bar Quick Service', style: TextStyle(fontSize: 13, color: Colors.white)),
                  subtitle: const Text('Keep live ticker active in notification panel', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  value: _notificationPermissionGranted,
                  onChanged: (val) {
                    setState(() {
                      _notificationPermissionGranted = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info, color: Colors.blueAccent),
                      SizedBox(width: 8),
                      Text('About BubbleDesk Engine', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'BubbleDesk v2.5 is designed to maximize micro-productivity by reducing app-switching context loss. Keep your overlay dock active to access clip dropzones and fast tools anywhere.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    softWrap: true,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Engine Build Status:', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                        child: const Text('ONLINE & READY', style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Dialog to Add Custom Dropzone Clip
  void _showAddClipDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedTag = 'Work';

    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF222232),
              title: const Text('New Dropzone Clip', style: TextStyle(color: Colors.white, fontSize: 16)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: const InputDecoration(
                        labelText: 'Title / Label',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: contentController,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: const InputDecoration(
                        labelText: 'Snippet Content',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Category: ', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(width: 8),
                        DropdownButton<String>(
                          value: selectedTag,
                          dropdownColor: const Color(0xFF222232),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                          items: <String>['Work', 'Phone', 'Links', 'Drafts'].map((String val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                selectedTag = val;
                              });
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
                  onPressed: () {
                    if (contentController.text.isNotEmpty) {
                      _addClipboardSnippet(titleController.text, contentController.text, selectedTag);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add Clip', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Helpers
  Widget _buildFeatureChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          border: Border.all(color: color.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Color _getTagColor(String tag) {
    switch (tag) {
      case 'Phone':
        return Colors.teal;
      case 'Links':
        return Colors.blue;
      case 'Drafts':
        return Colors.orange;
      default:
        return Colors.deepPurple;
    }
  }
}

// Custom Painter for Screen Ruler
class RulerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amberAccent
      ..strokeWidth = 1.0;

    double step = size.width / 30;
    for (int i = 0; i <= 30; i++) {
      double x = i * step;
      double height = (i % 10 == 0) ? 24.0 : ((i % 5 == 0) ? 14.0 : 8.0);
      canvas.drawLine(Offset(x, 0), Offset(x, height), paint);
      canvas.drawLine(Offset(x, size.height), Offset(x, size.height - height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}