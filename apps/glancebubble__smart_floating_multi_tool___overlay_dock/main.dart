import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const GlanceBubbleApp());
}

class GlanceBubbleApp extends StatelessWidget {
  const GlanceBubbleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlanceBubble',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121218),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentBottomNavIndex = 0;
  
  // Overlay & Bubble Simulation State
  bool _isOverlayEnabled = true;
  Offset _bubblePosition = const Offset(280, 200);
  bool _isBubbleExpanded = false;
  Color _selectedBubbleColor = Colors.deepPurple;
  double _bubbleSize = 60.0;
  double _bubbleOpacity = 0.9;
  
  // Quick Floating Notes Data
  final List<Map<String, String>> _pinnedNotes = [
    {
      'id': '1',
      'title': 'Wifi Password',
      'content': 'Office_Guest_5G#2025!',
      'tag': 'Important'
    },
    {
      'id': '2',
      'title': 'Delivery Address',
      'content': 'Building 4B, Tech Park, Suite 201',
      'tag': 'Work'
    },
  ];

  // Clipboard & Text Sanitizer State
  final TextEditingController _clipboardInputController = TextEditingController();
  List<String> _extractedUrls = [];
  List<String> _extractedPhones = [];
  List<String> _extractedEmails = [];
  String _sanitizedResultText = '';

  // Quick Converter State
  double _quickCalcInput = 100.0;
  String _selectedConversionType = 'USD to EUR';

  @override
  void dispose() {
    _clipboardInputController.dispose();
    super.dispose();
  }

  void _parseTextContent(String text) {
    setState(() {
      _sanitizedResultText = text.trim().replaceAll(RegExp(r'\s+'), ' ');
      
      // Extract URLs
      final urlRegExp = RegExp(r'https?://[^\s]+');
      _extractedUrls = urlRegExp.allMatches(text).map((m) => m.group(0)!).toList();

      // Extract Phone Numbers
      final phoneRegExp = RegExp(r'\+?[0-9]{8,15}');
      _extractedPhones = phoneRegExp.allMatches(text).map((m) => m.group(0)!).toList();

      // Extract Emails
      final emailRegExp = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
      _extractedEmails = emailRegExp.allMatches(text).map((m) => m.group(0)!).toList();
    });
  }

  void _copyToClipboard(String content, String label) {
    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addNote(String title, String content, String tag) {
    if (title.trim().isEmpty) return;
    setState(() {
      _pinnedNotes.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': title,
        'content': content,
        'tag': tag.isEmpty ? 'General' : tag,
      });
    });
  }

  void _deleteNote(String id) {
    setState(() {
      _pinnedNotes.removeWhere((note) => note['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.bubble_chart, color: Colors.amber),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'GlanceBubble Hub',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(_isOverlayEnabled ? 'Overlay Active' : 'Dock Off'),
              selected: _isOverlayEnabled,
              onSelected: (val) {
                setState(() {
                  _isOverlayEnabled = val;
                });
              },
              selectedColor: Colors.teal.withOpacity(0.3),
              checkmarkColor: Colors.teal,
              avatar: Icon(
                _isOverlayEnabled ? Icons.visibility : Icons.visibility_off,
                size: 16,
                color: _isOverlayEnabled ? Colors.teal : Colors.grey,
              ),
            ),
          ),
        ],
        backgroundColor: const Color(0xFF1E1E28),
        elevation: 2,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: IndexedStack(
              index: _currentBottomNavIndex,
              children: [
                _buildDashboardSimulatorTab(),
                _buildTextSanitizerTab(),
                _buildStickyNotesTab(),
                _buildBubbleCustomizerTab(),
              ],
            ),
          ),
          
          // Simulated Draggable Floating Overlay Bubble
          if (_isOverlayEnabled) _buildInteractiveFloatingBubble(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E1E28),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Simulator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: 'Sanitizer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.push_pin),
            label: 'Sticky HUD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.palette),
            label: 'Bubble Studio',
          ),
        ],
      ),
    );
  }

  // TAB 1: Simulator & Quick Drawer
  Widget _buildDashboardSimulatorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade900, Colors.indigo.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.deepPurple.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.touch_app, color: Colors.amber),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Live Overlay Interactive Demo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'The floating bubble icon on the right side simulates the background service overlay. Drag it anywhere or tap it to reveal quick desktop-grade utilities without closing current app!',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  softWrap: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Quick Overlay Tools Preview',
            style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold, color: Colors.amber),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildToolCard(
                icon: Icons.copy,
                title: 'Instant Smart Copy',
                desc: 'Auto clean & format copied text',
                color: Colors.teal,
                onTap: () {
                  setState(() => _currentBottomNavIndex = 1);
                },
              ),
              _buildToolCard(
                icon: Icons.note_add,
                title: 'Sticky Floating Notes',
                desc: 'Pin notes over active apps',
                color: Colors.orange,
                onTap: () {
                  setState(() => _currentBottomNavIndex = 2);
                },
              ),
              _buildToolCard(
                icon: Icons.calculate,
                title: 'Quick Unit Convert',
                desc: 'Instant micro math dock',
                color: Colors.blue,
                onTap: () {
                  _showQuickConverterModal();
                },
              ),
              _buildToolCard(
                icon: Icons.security,
                title: 'Permissions HUD',
                desc: 'Display over apps controller',
                color: Colors.purple,
                onTap: () {
                  _showPermissionInfoDialog();
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E28),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Active Dynamic Status Ticker',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Overlay Service: ${!_isOverlayEnabled ? "Paused" : "Running Ready"}',
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.layers, color: Colors.blue, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pinned Overlay Items: ${_pinnedNotes.length} active badges',
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
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

  // TAB 2: Text Sanitizer & Link Extractor
  Widget _buildTextSanitizerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Clipboard & Text Sanitizer',
            style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.amber),
          ),
          const SizedBox(height: 6),
          const Text(
            'Paste dirty text from websites or messages to automatically strip line breaks, extract actionable phone numbers, emails, and links for 1-tap copy.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
            softWrap: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _clipboardInputController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Paste messy raw text here (e.g. Call me at +1234567890 or visit https://example.com)...',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              filled: true,
              fillColor: const Color(0xFF1E1E28),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.deepPurple),
              ),
            ),
            onChanged: _parseTextContent,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final data = await Clipboard.getData('text/plain');
                  if (data != null && data.text != null) {
                    _clipboardInputController.text = data.text!;
                    _parseTextContent(data.text!);
                  }
                },
                icon: const Icon(Icons.content_paste, size: 16),
                label: const Text('Paste from Clipboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  _clipboardInputController.clear();
                  _parseTextContent('');
                },
                icon: const Icon(Icons.cleaning_services, size: 16),
                label: const Text('Clear Text'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_sanitizedResultText.isNotEmpty) ...[
            const Text(
              'Sanitized Clean Text:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E28),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: SelectableText(
                _sanitizedResultText,
                style: const TextStyle(color: Colors.tealAccent, fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (_extractedPhones.isNotEmpty) ...[
            const Text(
              'Extracted Phone Numbers:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _extractedPhones.map((phone) {
                return ActionChip(
                  avatar: const Icon(Icons.phone, size: 14, color: Colors.green),
                  label: Text(phone),
                  onPressed: () => _copyToClipboard(phone, 'Phone Number'),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
          if (_extractedUrls.isNotEmpty) ...[
            const Text(
              'Extracted Web Links:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _extractedUrls.map((url) {
                return ActionChip(
                  avatar: const Icon(Icons.link, size: 14, color: Colors.blue),
                  label: Text(
                    url,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPressed: () => _copyToClipboard(url, 'Link'),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
          if (_extractedEmails.isNotEmpty) ...[
            const Text(
              'Extracted Emails:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purpleAccent),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _extractedEmails.map((email) {
                return ActionChip(
                  avatar: const Icon(Icons.email, size: 14, color: Colors.purple),
                  label: Text(email),
                  onPressed: () => _copyToClipboard(email, 'Email Address'),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // TAB 3: Sticky Notes & HUD Pin Store
  Widget _buildStickyNotesTab() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final tagController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Floating Sticky Notes',
                  style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.amber),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.teal, size: 28),
                onPressed: () {
                  _showAddNoteModal(titleController, contentController, tagController);
                },
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Keep critical passwords, phone numbers, and codes floating on screen while multitasking.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
            softWrap: true,
          ),
          const SizedBox(height: 16),
          if (_pinnedNotes.isEmpty)
            Center(
              child: Container(
                padding: const EdgeInsets.all(32),
                child: const Column(
                  children: [
                    Icon(Icons.push_pin_outlined, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'No sticky notes pinned yet.\nTap + above to add one!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _pinnedNotes.length,
              itemBuilder: (context, index) {
                final note = _pinnedNotes[index];
                return Card(
                  color: const Color(0xFF1E1E28),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.deepPurple.withOpacity(0.3)),
                  ),
                  child: ListTile,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          note['title'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          note['tag'] ?? 'General',
                          style: const TextStyle(fontSize: 10, color: Colors.amber),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      note['content'] ?? '',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                      softWrap: true,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18, color: Colors.teal),
                        onPressed: () => _copyToClipboard(note['content'] ?? '', note['title'] ?? 'Note'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18, color: Colors.redAccent),
                        onPressed: () => _deleteNote(note['id']!),
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

  // TAB 4: Floating Bubble Customizer Studio
  Widget _buildBubbleCustomizerTab() {
    final List<Color> colorOptions = [
      Colors.deepPurple,
      Colors.teal,
      Colors.amber,
      Colors.redAccent,
      Colors.blue,
      Colors.indigo,
      Colors.orange,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Overlay Customizer Studio',
            style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.amber),
          ),
          const SizedBox(height: 6),
          const Text(
            'Personalize the look, feel, and opacity of your screen companion overlay bubble.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
            softWrap: true,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E28),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Bubble Accent Color',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: colorOptions.map((color) {
                    final isSelected = _selectedBubbleColor == color;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedBubbleColor = color;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.white : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: color.withOpacity(0.6),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  )
                                ]
                              : [],
                        ),
                        child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E28),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Bubble Size (Width & Height)', style: TextStyle(color: Colors.white)),
                    Text('${_bubbleSize.toInt()} px', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: _bubbleSize,
                  min: 45.0,
                  max: 85.0,
                  activeColor: _selectedBubbleColor,
                  onChanged: (val) {
                    setState(() {
                      _bubbleSize = val;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Overlay Opacity', style: TextStyle(color: Colors.white)),
                    Text('${(_bubbleOpacity * 100).toInt()}%', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: _bubbleOpacity,
                  min: 0.3,
                  max: 1.0,
                  activeColor: _selectedBubbleColor,
                  onChanged: (val) {
                    setState(() {
                      _bubbleOpacity = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.teal),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Pro Tip: Keep Opacity around 80%',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'This makes the floating dock non-intrusive while watching videos or reading web articles.',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Interactive Floating Overlay Widget (Simulated Screen Buddy)
  Widget _buildInteractiveFloatingBubble() {
    return Positioned(
      left: _bubblePosition.dx,
      top: _bubblePosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubblePosition += details.delta;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Opacity(
              opacity: _bubbleOpacity,
              child: FloatingActionButton(
                heroTag: 'floating_dock_btn',
                backgroundColor: _selectedBubbleColor,
                elevation: 8,
                onPressed: () {
                  setState(() {
                    _isBubbleExpanded = !_isBubbleExpanded;
                  });
                },
                child: Icon(
                  _isBubbleExpanded ? Icons.close : Icons.bubble_chart,
                  color: Colors.white,
                  size: _bubbleSize * 0.5,
                ),
              ),
            ),
            if (_isBubbleExpanded) ...[
              const SizedBox(height: 8),
              Container(
                width: 220,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E28).withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _selectedBubbleColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Glance Floating Dock',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber),
                        ),
                        InkWell(
                          onTap: () => setState(() => _isBubbleExpanded = false),
                          child: const Icon(Icons.close, size: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.grey),
                    _buildFloatingActionRow(
                      icon: Icons.cleaning_services,
                      title: 'Sanitize Clipboard',
                      onTap: () {
                        setState(() {
                          _isBubbleExpanded = false;
                          _currentBottomNavIndex = 1;
                        });
                      },
                    ),
                    _buildFloatingActionRow(
                      icon: Icons.push_pin,
                      title: 'View Sticky Notes',
                      onTap: () {
                        setState(() {
                          _isBubbleExpanded = false;
                          _currentBottomNavIndex = 2;
                        });
                      },
                    ),
                    _buildFloatingActionRow(
                      icon: Icons.calculate,
                      title: 'Micro Calculator',
                      onTap: () {
                        setState(() => _isBubbleExpanded = false);
                        _showQuickConverterModal();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionRow({required IconData icon, required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.tealAccent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard({
    required IconData icon,
    required String title,
    required String desc,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E28),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              desc,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddNoteModal(
    TextEditingController titleCtrl,
    TextEditingController contentCtrl,
    TextEditingController tagCtrl,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E28),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Pinned Sticky Note',
                  style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.amber),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Note Title (e.g., Gate Code)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contentCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Content or Text snippet',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: tagCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Category Tag (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _addNote(titleCtrl.text, contentCtrl.text, tagCtrl.text);
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Pin to Overlay'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showQuickConverterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E28),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            double convertedValue = _quickCalcInput;
            if (_selectedConversionType == 'USD to EUR') {
              convertedValue = _quickCalcInput * 0.92;
            } else if (_selectedConversionType == 'EUR to USD') {
              convertedValue = _quickCalcInput * 1.08;
            } else if (_selectedConversionType == 'Kg to Lbs') {
              convertedValue = _quickCalcInput * 2.20462;
            }

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overlay Micro Converter Dock',
                      style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.amber),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedConversionType,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Conversion Pair',
                      ),
                      dropdownColor: const Color(0xFF121218),
                      items: const [
                        DropdownMenuItem(value: 'USD to EUR', child: Text('USD (\$1) -> EUR (€0.92)')),
                        DropdownMenuItem(value: 'EUR to USD', child: Text('EUR (€1) -> USD (\$1.08)')),
                        DropdownMenuItem(value: 'Kg to Lbs', child: Text('Kilograms (1kg) -> Pounds (2.20 lbs)')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() {
                            _selectedConversionType = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Enter Input Value',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        setModalState(() {
                          _quickCalcInput = double.tryParse(val) ?? 0.0;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.deepPurple),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Result:', style: TextStyle(color: Colors.white, fontSize: 16)),
                          Text(
                            convertedValue.toStringAsFixed(2),
                            style: const TextStyle(
                              color: Colors.tealAccent,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showPermissionInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E28),
        title: const Row(
          children: [
            Icon(Icons.security, color: Colors.amber),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'System Overlay Status',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'GlanceBubble requires "Display over other apps" & Notification permissions for full floating dock features.',
                style: TextStyle(color: Colors.white70, fontSize: 13),
                softWrap: true,
              ),
              SizedBox(height: 12),
              Text(
                '1. Display Over Apps: ENABLED (Simulated)\n2. Sticky Notification Dock: ENABLED',
                style: TextStyle(color: Colors.tealAccent, fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }
}