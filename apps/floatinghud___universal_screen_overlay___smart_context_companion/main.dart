import 'package:flutter/material.dart';

void main() {
  runApp(const FloatingHUDApp());
}

class FloatingHUDApp extends StatelessWidget {
  const FloatingHUDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatingHUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0F1A),
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
  int _selectedNavIndex = 0;

  // Floating Overlay Bubble State
  Offset _bubblePosition = const Offset(20, 150);
  bool _isHudExpanded = false;
  double _hudOpacity = 0.95;
  Color _hudAccentColor = Colors.deepPurple;
  
  // App Features Data
  final List<String> _clipboardHistory = [
    'https://flutter.dev/docs',
    'OTP Code: 849201 (Expires in 5m)',
    'Meeting ID: 849-204-1102',
    'Deliver to: 42 Wallaby Way, Sydney',
    'Project Budget: \$1,250.00'
  ];

  final List<Map<String, dynamic>> _stickyNotes = [
    {
      'id': '1',
      'title': 'Shopping List',
      'content': 'Milk, Eggs, Coffee beans, Oat bread',
      'color': Colors.amber,
      'isPinned': true
    },
    {
      'id': '2',
      'title': 'Call Client',
      'content': 'Discuss UI layout & float window permissions at 4 PM',
      'color': Colors.teal,
      'isPinned': false
    },
  ];

  final TextEditingController _noteTitleController = TextEditingController();
  final TextEditingController _noteContentController = TextEditingController();
  final TextEditingController _clipInputController = TextEditingController();

  // Floating Calculation Helper State
  double _billAmount = 85.0;
  int _peopleCount = 3;
  double _tipPercentage = 15.0;

  // Floating Counter Goal
  int _dailyTargetCount = 12;
  int _currentGoalCount = 7;

  @override
  void dispose() {
    _noteTitleController.dispose();
    _noteContentController.dispose();
    _clipInputController.dispose();
    super.dispose();
  }

  void _addClipboardItem(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _clipboardHistory.insert(0, text.trim());
      _clipInputController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved to Floating Clipboard Sniffer!')),
    );
  }

  void _addNewNote() {
    if (_noteTitleController.text.trim().isEmpty) return;
    setState(() {
      _stickyNotes.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': _noteTitleController.text.trim(),
        'content': _noteContentController.text.trim(),
        'color': Colors.indigo,
        'isPinned': true,
      });
      _noteTitleController.clear();
      _noteContentController.clear();
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161626),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _hudAccentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.widgets, color: _hudAccentColor),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'FloatingHUD',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.visibility),
            tooltip: 'Toggle Overlay Test Mode',
            onPressed: () {
              setState(() {
                _isHudExpanded = !_isHudExpanded;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'HUD Settings',
            onPressed: () => _showSettingsModal(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content Body based on selected Navigation Tab
            Positioned.fill(
              child: IndexedStack(
                index: _selectedNavIndex,
                children: [
                  _buildOverlaySimulatorTab(),
                  _buildClipboardSnifferTab(),
                  _buildStickyNotesTab(),
                  _buildQuickToolsTab(),
                ],
              ),
            ),

            // Draggable Floating Overlay Bubble Simulator
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubblePosition += details.delta;
                  });
                },
                child: _isHudExpanded
                    ? _buildExpandedHudWindow()
                    : _buildCollapsedHudBubble(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedNavIndex,
        backgroundColor: const Color(0xFF161626),
        indicatorColor: _hudAccentColor.withOpacity(0.3),
        onDestinationSelected: (index) {
          setState(() {
            _selectedNavIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Overlay Screen',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_copy),
            label: 'Clipboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.push_pin),
            label: 'Sticky Notes',
          ),
          NavigationDestination(
            icon: Icon(Icons.build),
            label: 'Tools Deck',
          ),
        ],
      ),
      floatingActionButton: _selectedNavIndex == 2
          ? FloatingActionButton.extended(
              onPressed: () => _showAddNoteDialog(context),
              backgroundColor: _hudAccentColor,
              icon: const Icon(Icons.add),
              label: const Text('New Floating Note'),
            )
          : null,
    );
  }

  // --- COLLAPSED FLOATING BUBBLE ---
  Widget _buildCollapsedHudBubble() {
    return Material(
      color: Colors.transparent,
      elevation: 8,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: () {
          setState(() {
            _isHudExpanded = true;
          });
        },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _hudAccentColor.withOpacity(_hudOpacity),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white70, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.layers, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text(
                'HUD Floating Active',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- EXPANDED FLOATING OVERLAY WINDOW ---
  Widget _buildExpandedHudWindow() {
    return Material(
      color: Colors.transparent,
      elevation: 12,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 290,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E30).withOpacity(_hudOpacity),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _hudAccentColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HUD Header Bar
            Row(
              children: [
                Icon(Icons.drag_indicator, color: Colors.grey.shade400, size: 18),
                const SizedBox(width: 4),
                const Expanded(
                  child: Text(
                    'Quick Overlay Dock',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isHudExpanded = false;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.close, color: Colors.white70, size: 18),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white70, height: 16),
            
            // Floating Tools Speed Dials inside Widget
            const Text(
              'Active Context Tools:',
              style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAxisAlignment.center,
              children: [
                _buildMiniHudChip(
                  icon: Icons.content_copy,
                  label: '${_clipboardHistory.length} Clips',
                  color: Colors.blue,
                  onTap: () {
                    setState(() => _selectedNavIndex = 1);
                  },
                ),
                _buildMiniHudChip(
                  icon: Icons.push_pin,
                  label: '${_stickyNotes.length} Notes',
                  color: Colors.amber,
                  onTap: () {
                    setState(() => _selectedNavIndex = 2);
                  },
                ),
                _buildMiniHudChip(
                  icon: Icons.calculate,
                  label: 'Quick Split',
                  color: Colors.teal,
                  onTap: () {
                    setState(() => _selectedNavIndex = 3);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Top Pinned Sticky Preview inside Overlay
            if (_stickyNotes.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (_stickyNotes.first['color'] as Color).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: (_stickyNotes.first['color'] as Color).withOpacity(0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.push_pin,
                          size: 14,
                          color: _stickyNotes.first['color'] as Color,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _stickyNotes.first['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _stickyNotes.first['content'] as String,
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildMiniHudChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: OVERLAY SCREEN & LIVE PREVIEW ---
  Widget _buildOverlaySimulatorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Banner Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_hudAccentColor, Colors.indigo.shade800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _hudAccentColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.bolt, color: Colors.amber, size: 24),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Display Above Other Apps Active',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Drag the purple floating HUD bubble anywhere on screen. Access clips, quick notes, and multi-split calculations without switching apps!',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  softWrap: true,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isHudExpanded = !_isHudExpanded;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  icon: Icon(_isHudExpanded ? Icons.visibility_off : Icons.touch_app),
                  label: Text(_isHudExpanded ? 'Collapse HUD Bubble' : 'Expand HUD Menu'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Active Floating Tools Suite',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),

          // Tools Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildToolFeatureCard(
                title: 'Clipboard Sniffer',
                subtitle: '${_clipboardHistory.length} copied items ready',
                icon: Icons.content_copy,
                color: Colors.blue,
                onTap: () => setState(() => _selectedNavIndex = 1),
              ),
              _buildToolFeatureCard(
                title: 'Overlay Sticky Notes',
                subtitle: '${_stickyNotes.length} pinned sticky cards',
                icon: Icons.push_pin,
                color: Colors.amber,
                onTap: () => setState(() => _selectedNavIndex = 2),
              ),
              _buildToolFeatureCard(
                title: 'Quick Multi-Splitter',
                subtitle: 'Tip & bill instant calculation',
                icon: Icons.calculate,
                color: Colors.teal,
                onTap: () => setState(() => _selectedNavIndex = 3),
              ),
              _buildToolFeatureCard(
                title: 'Target Counter Ring',
                subtitle: '$_currentGoalCount / $_dailyTargetCount completed today',
                icon: Icons.touch_app,
                color: Colors.deepOrange,
                onTap: () => setState(() => _selectedNavIndex = 3),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Permission Helper Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF161626),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: const Row(
              children: [
                Icon(Icons.security, color: Colors.greenAccent, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overlay Permission Status: Granted',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'System floating widget is enabled and ready to assist daily routines.',
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildToolFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF161626),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 2: LIVE CLIPBOARD SNIFFER ---
  Widget _buildClipboardSnifferTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Clipboard Sniffer & Stack',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            const Text(
              'Quickly paste copied text clips to keep available in your floating screen overlay.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),

            // Input Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _clipInputController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Paste or type text to add...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF161626),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addClipboardItem(_clipInputController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // List of Clips
            Expanded(
              child: _clipboardHistory.isEmpty
                  ? const Center(
                      child: Text(
                        'No clipboard entries saved.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _clipboardHistory.length,
                      itemBuilder: (context, index) {
                        final clip = _clipboardHistory[index];
                        return Card(
                          color: const Color(0xFF161626),
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.white70),
                          ),
                          child: ListTile,
                        ).buildClipTile(clip, index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper extension logic for clip item
  Widget _buildClipListTileItem(String clip, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF161626),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        children: [
          const Icon(Icons.description, color: Colors.blue, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              clip,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, color: Colors.white70, size: 18),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied clip to active device buffer!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
            onPressed: () {
              setState(() {
                _clipboardHistory.removeAt(index);
              });
            },
          ),
        ],
      ),
    );
  }

  // --- TAB 3: OVERLAY STICKY NOTES ---
  Widget _buildStickyNotesTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Floating Sticky Notes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            const Text(
              'Pinned sticky cards seamlessly stay accessible in your overlay view.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _stickyNotes.isEmpty
                  ? const Center(
                      child: Text(
                        'No sticky notes added yet.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _stickyNotes.length,
                      itemBuilder: (context, index) {
                        final note = _stickyNotes[index];
                        final Color cardColor = note['color'] as Color;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: cardColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: cardColor.withOpacity(0.5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.push_pin, color: cardColor, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      note['title'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.grey, size: 18),
                                    onPressed: () {
                                      setState(() {
                                        _stickyNotes.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                note['content'] as String,
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                                softWrap: true,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 4: FLOATING TOOLS DECK ---
  Widget _buildQuickToolsTab() {
    double tipAmount = (_billAmount * _tipPercentage) / 100;
    double totalAmount = _billAmount + tipAmount;
    double perPerson = _peopleCount > 0 ? totalAmount / _peopleCount : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Micro-Tools Deck',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'High-speed utility calculators & target rings that run inside the float window.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // 1. Quick Tip & Bill Splitter Tool
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF161626),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.teal.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.calculate, color: Colors.teal),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Floating Bill & Tip Splitter',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Bill:', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    Text(
                      '\$${_billAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.tealAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _billAmount,
                  min: 5.0,
                  max: 500.0,
                  divisions: 99,
                  activeColor: Colors.teal,
                  onChanged: (val) {
                    setState(() => _billAmount = val);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Split Among (${_peopleCount} People):', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.white70),
                          onPressed: () {
                            if (_peopleCount > 1) {
                              setState(() => _peopleCount--);
                            }
                          },
                        ),
                        Text(
                          '$_peopleCount',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.white70),
                          onPressed: () {
                            setState(() => _peopleCount++);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(color: Colors.white70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Per Person Pays:', style: TextStyle(color: Colors.white, fontSize: 14)),
                    Text(
                      '\$${perPerson.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. Target Counter Ring Widget
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF161626),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.deepOrange.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.touch_app, color: Colors.deepOrange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Floating Screen Tap Target Ring',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Progress: $_currentGoalCount / $_dailyTargetCount',
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: _dailyTargetCount > 0
                                  ? (_currentGoalCount / _dailyTargetCount).clamp(0.0, 1.0)
                                  : 0.0,
                              minHeight: 10,
                              backgroundColor: Colors.white70,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentGoalCount++;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- MODALS & DIALOGS ---
  void _showAddNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E30),
          title: const Text('Add Floating Sticky Note', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _noteTitleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteContentController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Content...',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: _addNewNote,
              style: ElevatedButton.styleFrom(backgroundColor: _hudAccentColor),
              child: const Text('Save Note'),
            ),
          ],
        );
      },
    );
  }

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161626),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Floating HUD Customizer Lab',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('HUD Opacity / Transparency:', style: TextStyle(color: Colors.grey)),
                      Text(
                        '${(_hudOpacity * 100).toInt()}%',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Slider(
                    value: _hudOpacity,
                    min: 0.3,
                    max: 1.0,
                    activeColor: _hudAccentColor,
                    onChanged: (val) {
                      setModalState(() {
                        _hudOpacity = val;
                      });
                      setState(() {
                        _hudOpacity = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text('Theme Accent Color:', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    children: [
                      Colors.deepPurple,
                      Colors.teal,
                      Colors.amber,
                      Colors.deepOrange,
                      Colors.blue,
                    ].map((color) {
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            _hudAccentColor = color;
                          });
                          setState(() {
                            _hudAccentColor = color;
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: color,
                          radius: 16,
                          child: _hudAccentColor == color
                              ? const Icon(Icons.check, color: Colors.white, size: 16)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// Extension to map List tiles reliably
extension ClipTileBuilder on ListTile {
  Widget buildClipTile(String clip, int index) {
    return Builder(
      builder: (context) {
        final state = context.findAncestorStateOfType<_MainHomeScreenState>();
        if (state == null) return const SizedBox();
        return state._buildClipListTileItem(clip, index);
      },
    );
  }
}