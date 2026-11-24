import 'package:flutter/material.dart';

void main() {
  runApp(const OmniHudApp());
}

class OmniHudApp extends StatelessWidget {
  const OmniHudApp({super.key});

  @override
  Widget build(BuildContext me) {
    return MaterialApp(
      title: 'OmniHUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainHudScreen(),
    );
  }
}

class MainHudScreen extends StatefulWidget {
  const MainHudScreen({super.key});

  @override
  State<MainHudScreen> createState() => _MainHudScreenState();
}

class _MainHudScreenState extends State<MainHudScreen> {
  int _selectedTab = 0;

  // Floating Overlay State
  bool _overlayEnabled = true;
  bool _notificationBubbleEnabled = true;
  bool _autoCleanClipboard = true;
  bool _dimmerActive = false;
  double _bubbleOpacity = 0.9;
  double _dimmerLevel = 0.35;
  Offset _bubblePosition = const Offset(20, 180);
  bool _isBubbleExpanded = false;

  // Sanitizer State
  final TextEditingController _urlController = TextEditingController();
  String _cleanedUrlResult = '';
  int _linksCleanedCount = 14;

  // Sticky Notes State
  final List<Map<String, dynamic>> _stickyNotes = [
    {
      'title': 'Shopping Price Check',
      'body': 'Compare item code #4928 with site offer: \$49.99 vs \$39.50',
      'color': Colors.amber,
      'pinned': true
    },
    {
      'title': 'Quick Recipe Code',
      'body': 'Bake 180C for 25 mins. Add 2 tsp cinnamon.',
      'color': Colors.teal,
      'pinned': false
    }
  ];
  final TextEditingController _noteTitleController = TextEditingController();
  final TextEditingController _noteBodyController = TextEditingController();

  // Quick Calculator Overlay State
  double _billAmount = 85.0;
  double _tipPercentage = 15.0;
  int _splitPeople = 2;

  @override
  void dispose() {
    _urlController.dispose();
    _noteTitleController.dispose();
    _noteBodyController.dispose();
    super.dispose();
  }

  void _sanitizeUrl() {
    final rawText = _urlController.text.trim();
    if (rawText.isEmpty) {
      setState(() {
        _cleanedUrlResult = 'Please paste a valid URL standard string.';
      });
      return;
    }

    try {
      Uri uri = Uri.parse(rawText);
      if (!uri.hasQuery) {
        setState(() {
          _cleanedUrlResult = rawText;
        });
        return;
      }

      // Filter out tracking parameters like utm_, fbclid, igshid, ref, etc.
      Map<String, String> cleanParams = {};
      uri.queryParameters.forEach((key, value) {
        final k = key.toLowerCase();
        if (!k.startsWith('utm_') &&
            k != 'fbclid' &&
            k != 'igshid' &&
            k != 'gclid' &&
            !k.startsWith('ref') &&
            k != 'si' &&
            k != 'mc_eid') {
          cleanParams[key] = value;
        }
      });

      Uri cleanUri = uri.replace(queryParameters: cleanParams.isEmpty ? null : cleanParams);
      setState(() {
        _cleanedUrlResult = cleanUri.toString();
        _linksCleanedCount++;
      });
    } catch (e) {
      // Basic manual cleanup fallback
      int queryIndex = rawText.indexOf('?');
      if (queryIndex != -1) {
        setState(() {
          _cleanedUrlResult = rawText.substring(0, queryIndex);
          _linksCleanedCount++;
        });
      } else {
        setState(() {
          _cleanedUrlResult = rawText;
        });
      }
    }
  }

  void _addNewNote() {
    if (_noteTitleController.text.trim().isEmpty) return;
    setState(() {
      _stickyNotes.insert(0, {
        'title': _noteTitleController.text.trim(),
        'body': _noteBodyController.text.trim(),
        'color': Colors.indigo,
        'pinned': false,
      });
      _noteTitleController.clear();
      _noteBodyController.clear();
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main App Screen View
          SafeArea(
            child: Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedTab,
                    children: [
                      _buildOverlayControlTab(),
                      _buildSanitizerTab(),
                      _buildNotesTab(),
                      _buildQuickCalcTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sight Guard Dimmer Overlay Preview Simulation
          if (_dimmerActive)
            IgnorePointer(
              child: Container(
                color: Colors.black.withOpacity(_dimmerLevel),
              ),
            ),

          // Interactive Draggable Floating HUD Widget Simulation
          if (_overlayEnabled) _buildDraggableFloatingHud(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) => setState(() => _selectedTab = index),
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarThemeData() != null
              ? BottomNavigationBarItem(
                  icon: Icon(Icons.layers),
                  label: 'HUD Dock',
                )
              : BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: 'CleanClip',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt),
            label: 'Floating Note',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Quick Math',
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(
          bottom: BorderSide(color: Colors.white70, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.widgets, color: Colors.tealAccent, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'OmniHUD Floating Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'System Overlay & Micro Utilities Active',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _dimmerActive ? Icons.visibility_off : Icons.visibility,
              color: _dimmerActive ? Colors.amber : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _dimmerActive = !_dimmerActive;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_dimmerActive
                      ? 'SightGuard Screen Dimmer Activated'
                      : 'Screen Dimmer Deactivated'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'Toggle SightGuard Screen Dimmer',
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating Assistant Controls & Status
  Widget _buildOverlayControlTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _overlayEnabled
                    ? [Colors.teal.withOpacity(0.4), Colors.indigo.withOpacity(0.4)]
                    : [Colors.grey.withOpacity(0.3), Colors.black87],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _overlayEnabled ? Colors.tealAccent : Colors.grey,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      _overlayEnabled ? Icons.check_circle : Icons.pause_circle_filled,
                      color: _overlayEnabled ? Colors.tealAccent : Colors.grey,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _overlayEnabled
                                ? 'Floating Overlay Engine ACTIVE'
                                : 'Floating Overlay Standby',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const Text(
                            'Display over apps permission active. Drag bubble anywhere.',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _overlayEnabled,
                      activeColor: Colors.tealAccent,
                      onChanged: (val) {
                        setState(() {
                          _overlayEnabled = val;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Floating HUD Settings',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),

          // Option Controls
          _buildControlTile(
            title: 'Floating Notification Bar',
            subtitle: 'Show quick control center in android notification drawer',
            icon: Icons.notifications_active,
            value: _notificationBubbleEnabled,
            onChanged: (val) => setState(() => _notificationBubbleEnabled = val),
          ),
          _buildControlTile(
            title: 'Auto Clean Copied Links',
            subtitle: 'Automatically sanitize tracking parameters when copying text',
            icon: Icons.cleaning_services,
            value: _autoCleanClipboard,
            onChanged: (val) => setState(() => _autoCleanClipboard = val),
          ),

          const SizedBox(height: 16),
          // Opacity Slider
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Floating Bubble Transparency',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${(_bubbleOpacity * 100).toInt()}%',
                      style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Slider(
                  value: _bubbleOpacity,
                  min: 0.3,
                  max: 1.0,
                  activeColor: Colors.tealAccent,
                  inactiveColor: Colors.grey,
                  onChanged: (val) => setState(() => _bubbleOpacity = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Dimmer Slider Control
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'SightGuard Dimmer Intensity',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${(_dimmerLevel * 100).toInt()}%',
                      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Slider(
                  value: _dimmerLevel,
                  min: 0.1,
                  max: 0.75,
                  activeColor: Colors.amber,
                  inactiveColor: Colors.grey,
                  onChanged: (val) => setState(() => _dimmerLevel = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Live Quick Tip Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.indigo.withOpacity(0.5)),
            ),
            child: Row(
              children: const [
                Icon(Icons.touch_app, color: Colors.indigoAccent),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tip: Drag the glowing floating bubble on screen to any edge. Tap it to reveal instant tools anywhere on your device!',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white70),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: Colors.tealAccent),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        value: value,
        activeColor: Colors.tealAccent,
        onChanged: onChanged,
      ),
    );
  }

  // TAB 2: CleanClip Link Sanitizer
  Widget _buildSanitizerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat Counter
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CleanClip Stripper',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Strips utm_, fbclid, tracking tags from shared URLs',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.teal),
                  ),
                  child: Text(
                    '$_linksCleanedCount Cleaned',
                    style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Paste Tracked URL / Link:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          TextField(
            controller: _urlController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'e.g. https://example.com/item?utm_source=social&fbclid=xyz123&ref=share',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white70),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.tealAccent),
              ),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _sanitizeUrl,
                  icon: const Icon(Icons.cleaning_services, color: Colors.black),
                  label: const Text('Sanitize & Clean Link', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  _urlController.clear();
                  setState(() => _cleanedUrlResult = '');
                },
                icon: const Icon(Icons.refresh, color: Colors.grey),
                tooltip: 'Clear input',
              ),
            ],
          ),

          const SizedBox(height: 24),

          if (_cleanedUrlResult.isNotEmpty) ...[
            const Text(
              'Sanitized Clean Result:',
              style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F2942),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.withOpacity(0.6)),
              ),
              child: SelectableText(
                _cleanedUrlResult,
                style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cleaned link copied to clipboard!')),
                );
              },
              icon: const Icon(Icons.content_copy, size: 18),
              label: const Text('Copy Clean Link'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E293B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // TAB 3: Floating Sticky Notes Overlay Creator
  Widget _buildNotesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overlay Sticky Notes',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddNoteDialog(),
                icon: const Icon(Icons.add, size: 18, color: Colors.black),
                label: const Text('New Note', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Floating notes remain accessible while using other apps.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _stickyNotes.length,
            itemBuilder: (context, index) {
              final note = _stickyNotes[index];
              final Color accentColor = note['color'] as Color;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accentColor.withOpacity(0.6), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            note['title'] ?? '',
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.grey, size: 20),
                          onPressed: () {
                            setState(() {
                              _stickyNotes.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      note['body'] ?? '',
                      style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.layers, size: 12, color: Colors.tealAccent),
                              SizedBox(width: 4),
                              Text('Overlay Ready', style: TextStyle(color: Colors.tealAccent, fontSize: 10)),
                            ],
                          ),
                        ),
                      ],
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Add Overlay Note', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _noteTitleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Note Title',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteBodyController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Note details...',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: _addNewNote,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent),
            child: const Text('Save Note', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  // TAB 4: Quick Calculation & Split HUD
  Widget _buildQuickCalcTab() {
    double totalTip = _billAmount * (_tipPercentage / 100);
    double grandTotal = _billAmount + totalTip;
    double perPerson = grandTotal / (_splitPeople < 1 ? 1 : _splitPeople);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Quick-Split Calculator',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Text(
            'Calculate bill split & tip instantly in floating context.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Total Display Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF312E81), Color(0xFF1E1B4B)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigoAccent),
            ),
            child: Column(
              children: [
                const Text('PAYMENT PER PERSON', style: TextStyle(color: Colors.indigoAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                FittedBox(
                  child: Text(
                    '\$${perPerson.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(color: Colors.white70, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Bill Total', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        Text('\$${_billAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Tip Amount', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        Text('\$${totalTip.toStringAsFixed(2)}', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Grand Total', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        Text('\$${grandTotal.toStringAsFixed(2)}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Input Sliders
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Base Bill Amount:', style: TextStyle(color: Colors.white)),
                    Text('\$${_billAmount.toStringAsFixed(0)}', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: _billAmount,
                  min: 5.0,
                  max: 500.0,
                  divisions: 99,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) => setState(() => _billAmount = val),
                ),

                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tip Percentage:', style: TextStyle(color: Colors.white)),
                    Text('${_tipPercentage.toInt()}%', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: _tipPercentage,
                  min: 0.0,
                  max: 30.0,
                  divisions: 30,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) => setState(() => _tipPercentage = val),
                ),

                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Split People:', style: TextStyle(color: Colors.white)),
                    Text('$_splitPeople People', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                      onPressed: () {
                        if (_splitPeople > 1) setState(() => _splitPeople--);
                      },
                    ),
                    Expanded(
                      child: Slider(
                        value: _splitPeople.toDouble(),
                        min: 1,
                        max: 12,
                        divisions: 11,
                        activeColor: Colors.amber,
                        onChanged: (val) => setState(() => _splitPeople = val.toInt()),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Colors.amber),
                      onPressed: () {
                        if (_splitPeople < 12) setState(() => _splitPeople++);
                      },
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

  // Interactive Draggable Floating Widget
  Widget _buildDraggableFloatingHud() {
    return Positioned(
      left: _bubblePosition.dx,
      top: _bubblePosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubblePosition += details.delta;
          });
        },
        child: Opacity(
          opacity: _bubbleOpacity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bubble Main Trigger Button
              InkWell(
                onTap: () {
                  setState(() {
                    _isBubbleExpanded = !_isBubbleExpanded;
                  });
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.tealAccent, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.tealAccent.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.widgets,
                      color: Colors.tealAccent,
                      size: 28,
                    ),
                  ),
                ),
              ),

              // Expanded Floating Quick Control Drawer
              if (_isBubbleExpanded)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(12),
                  width: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B).withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.tealAccent.withOpacity(0.5)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black87,
                        blurRadius: 10,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'OmniHUD Floating',
                            style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _isBubbleExpanded = false),
                            child: const Icon(Icons.close, color: Colors.grey, size: 16),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white70, height: 12),
                      _buildFloatingActionItem(
                        icon: Icons.cleaning_services,
                        label: 'Auto Clean Clip',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Clipboard Auto-Sanitizer Active!')),
                          );
                        },
                      ),
                      _buildFloatingActionItem(
                        icon: Icons.visibility,
                        label: 'Toggle Dimmer',
                        onTap: () {
                          setState(() => _dimmerActive = !_dimmerActive);
                        },
                      ),
                      _buildFloatingActionItem(
                        icon: Icons.note_alt,
                        label: 'Quick Screen Note',
                        onTap: () {
                          setState(() => _selectedTab = 2);
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 16),
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
}