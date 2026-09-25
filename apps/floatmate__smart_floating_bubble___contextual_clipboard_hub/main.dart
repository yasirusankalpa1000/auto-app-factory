import 'package:flutter/material.dart';

void main() {
  runApp(const FloatMateApp());
}

class FloatMateApp extends StatelessWidget {
  const FloatMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFAFAFA),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class SnippetItem {
  final String id;
  final String content;
  final String type; // Phone, Email, Link, LKR, Address, General
  final String timestamp;
  bool isPinned;

  SnippetItem({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isPinned = false,
  });
}

class FloatingNote {
  final String id;
  String text;
  Color color;
  bool isMinimized;

  FloatingNote({
    required this.id,
    required this.text,
    required this.color,
    this.isMinimized = false,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  // Floating Overlay Control State
  bool _isOverlayEnabled = true;
  bool _isNotificationTriggerEnabled = true;
  Offset _bubblePosition = const Offset(140, 220);
  Color _bubbleColor = Colors.indigo;
  double _bubbleSize = 64.0;
  double _bubbleOpacity = 0.90;

  // Clipboard & Parser State
  final TextEditingController _rawTextController = TextEditingController();
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: '1',
      content: '0771234567 - Call for delivery verification',
      type: 'Phone',
      timestamp: '10 mins ago',
      isPinned: true,
    ),
    SnippetItem(
      id: '2',
      content: 'Bank Account: Commercial Bank 8001239941 (Sampath)',
      type: 'LKR',
      timestamp: '25 mins ago',
      isPinned: true,
    ),
    SnippetItem(
      id: '3',
      content: 'https://myshop.lk/item/392',
      type: 'Link',
      timestamp: '1 hour ago',
    ),
    SnippetItem(
      id: '4',
      content: 'support@floatmate.app',
      type: 'Email',
      timestamp: '2 hours ago',
    ),
  ];

  // Floating Notes State
  final List<FloatingNote> _floatingNotes = [
    FloatingNote(
      id: '1',
      text: 'Transfer LKR 4,500 to supplier before 4 PM',
      color: Colors.amber,
    ),
    FloatingNote(
      id: '2',
      text: 'Order tracking: #SL-994821',
      color: Colors.blue,
    ),
  ];

  final TextEditingController _newNoteController = TextEditingController();

  void _addParsedSnippet(String text) {
    if (text.trim().isEmpty) return;

    String type = 'General';
    if (text.contains('http://') || text.contains('https://') || text.contains('.com') || text.contains('.lk')) {
      type = 'Link';
    } else if (text.contains('@') && text.contains('.')) {
      type = 'Email';
    } else if (RegExp(r'(?:[0-9]{9,11})').hasMatch(text)) {
      type = 'Phone';
    } else if (text.toLowerCase().contains('rs') || text.toLowerCase().contains('lkr') || text.toLowerCase().contains('bank')) {
      type = 'LKR';
    }

    setState(() {
      _snippets.insert(
        0,
        SnippetItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: text.trim(),
          type: type,
          timestamp: 'Just now',
        ),
      );
      _rawTextController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to FloatMate Snippet Hub as $type'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addFloatingNote(String noteText) {
    if (noteText.trim().isEmpty) return;
    setState(() {
      _floatingNotes.add(
        FloatingNote(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: noteText.trim(),
          color: Colors.teal,
        ),
      );
      _newNoteController.clear();
    });
  }

  @override
  void dispose() {
    _rawTextController.dispose();
    _newNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.widgets, color: Colors.indigo),
            SizedBox(width: 8),
            Text(
              'FloatMate',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: FilterChip(
              avatar: Icon(
                _isOverlayEnabled ? Icons.check_circle : Icons.clear,
                color: _isOverlayEnabled ? Colors.green : Colors.grey,
                size: 18,
              ),
              label: Text(_isOverlayEnabled ? 'Overlay Active' : 'Overlay Paused'),
              selected: _isOverlayEnabled,
              onSelected: (bool selected) {
                setState(() {
                  _isOverlayEnabled = selected;
                });
              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildFloatingHubTab(),
            _buildSmartSnippetsTab(),
            _buildFloatingNotesTab(),
            _buildCustomizerTab(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.touch_app),
            selectedIcon: Icon(Icons.touch_app, color: Colors.indigo),
            label: 'Float Hub',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_paste),
            selectedIcon: Icon(Icons.content_paste, color: Colors.indigo),
            label: 'Snippets',
          ),
          NavigationDestination(
            icon: Icon(Icons.layers),
            selectedIcon: Icon(Icons.layers, color: Colors.indigo),
            label: 'Overlay Notes',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            selectedIcon: Icon(Icons.settings, color: Colors.indigo),
            label: 'Customizer',
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating Assistant Canvas & Quick Floating Overlay Simulator
  Widget _buildFloatingHubTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Banner / Status Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.indigo.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bolt, color: Colors.indigo, size: 28),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Live Floating Context Assistant',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'FloatMate stays accessible over any app. Drag the test bubble below around your simulated screen or tap it to open instant shortcuts.',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                    softWrap: true,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildStatusBadge(
                        'Display Over Apps: Allowed',
                        Icons.layers,
                        Colors.teal,
                      ),
                      _buildStatusBadge(
                        'Floating Notification: Active',
                        Icons.notifications,
                        Colors.blue,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Interactive Overlay Screen Preview',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Dynamic Drag Canvas Box
          Container(
            height: 320,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade400, width: 1.5),
            ),
            child: Stack(
              children: [
                // Background Simulated App Context
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.person, size: 20, color: Colors.indigo),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Simulated Chat / Web Page Context',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Client: "Please deposit LKR 12,500 to account 800129941 Commercial Bank and call 0771234567 when done!"',
                            style: TextStyle(fontSize: 12, color: Colors.black87),
                            softWrap: true,
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: Text(
                            'Drag the FloatMate bubble anywhere inside this zone',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

                // Interactive Draggable Bubble
                if (_isOverlayEnabled)
                  Positioned(
                    left: _bubblePosition.dx,
                    top: _bubblePosition.dy,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          double newX = _bubblePosition.dx + details.delta.dx;
                          double newY = _bubblePosition.dy + details.delta.dy;
                          // Clamp inside bounding box
                          if (newX < 10) newX = 10;
                          if (newX > 260) newX = 260;
                          if (newY < 10) newY = 10;
                          if (newY > 240) newY = 240;
                          _bubblePosition = Offset(newX, newY);
                        });
                      },
                      onTap: () {
                        _showQuickActionBottomSheet(context);
                      },
                      child: Opacity(
                        opacity: _bubbleOpacity,
                        child: Container(
                          width: _bubbleSize,
                          height: _bubbleSize,
                          decoration: BoxDecoration(
                            color: _bubbleColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _bubbleColor.withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: const Icon(
                            Icons.widgets,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Quick Context Tool Cards
          const Text(
            'Active Floating Tools',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  title: 'Smart Snip',
                  subtitle: 'Auto-detect text',
                  icon: Icons.center_focus_strong,
                  color: Colors.purple,
                  onTap: () {
                    _addParsedSnippet('Client order: LKR 12,500 - Account 800129941');
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildQuickActionCard(
                  title: 'Quick Float Note',
                  subtitle: 'Pin over screen',
                  icon: Icons.note_add,
                  color: Colors.amber.shade800,
                  onTap: () {
                    _addFloatingNote('Verify payment receipt LKR 12,500');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  title: 'Float Dial',
                  subtitle: 'Fast caller bubble',
                  icon: Icons.phone_in_talk,
                  color: Colors.green,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Floating Speed Dial Overlay Activated!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildQuickActionCard(
                  title: 'Notify Trigger',
                  subtitle: 'Persistent bar',
                  icon: Icons.notifications_active,
                  color: Colors.blue,
                  onTap: () {
                    setState(() {
                      _isNotificationTriggerEnabled = !_isNotificationTriggerEnabled;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TAB 2: Smart Clipboard Parser & Snippet Storage
  Widget _buildSmartSnippetsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Context Text Parser',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Paste any raw message, phone number, link, or bank text below. FloatMate instantly categorizes it into floating actionable cards.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
            softWrap: true,
          ),
          const SizedBox(height: 12),

          // Input Box
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: _rawTextController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Paste WhatsApp text, email, bank account, or phone number here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainALIGNMENT.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          _rawTextController.clear();
                        },
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Clear'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          _addParsedSnippet(_rawTextController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.bolt, size: 18),
                        label: const Text('Parse & Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Snippet List Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Saved Floating Snippets',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Chip(
                label: Text('${_snippets.length} items'),
                backgroundColor: Colors.indigo.shade50,
              )
            ],
          ),
          const SizedBox(height: 10),

          // Snippet List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _snippets.length,
            itemBuilder: (context, index) {
              final item = _snippets[index];
              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: item.isPinned
                      ? const BorderSide(color: Colors.indigo, width: 1.5)
                      : BorderSide.none,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildTypeBadge(item.type),
                          const SizedBox(width: 8),
                          Text(
                            item.timestamp,
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              item.isPinned ? Icons.star : Icons.star_border,
                              color: item.isPinned ? Colors.amber : Colors.grey,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                item.isPinned = !item.isPinned;
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                            onPressed: () {
                              setState(() {
                                _snippets.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.content,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        softWrap: true,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Copied to system clipboard!'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: const Icon(Icons.copy, size: 14),
                            label: const Text('1-Tap Copy', style: TextStyle(fontSize: 12)),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Floating Context Bubble Triggered!'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: const Icon(Icons.open_in_new, size: 14),
                            label: const Text('Float Over', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      )
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

  // TAB 3: Dynamic Overlay Notes & Sticky Pad
  Widget _buildFloatingNotesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Persistent Floating Sticky Notes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Keep important reminders pinned visually on top of other screen tasks like transfers, addresses, or phone codes.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          // Add New Note Card
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: _newNoteController,
                    decoration: const InputDecoration(
                      labelText: 'Create New Floating Sticky Note',
                      hintText: 'e.g. Call Bank Manager at 3:00 PM',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _addFloatingNote(_newNoteController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Pin Note'),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Active Sticky Notes
          const Text(
            'Active Floating Notes',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _floatingNotes.length,
            itemBuilder: (context, index) {
              final note = _floatingNotes[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: note.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: note.color, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.push_pin, color: note.color, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Floating Sticky Card',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            note.isMinimized ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey.shade700,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              note.isMinimized = !note.isMinimized;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red, size: 20),
                          onPressed: () {
                            setState(() {
                              _floatingNotes.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                    if (!note.isMinimized) ...[
                      const SizedBox(height: 8),
                      Text(
                        note.text,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        softWrap: true,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('Amber'),
                            selected: note.color == Colors.amber,
                            onSelected: (bool sel) {
                              if (sel) setState(() => note.color = Colors.amber);
                            },
                          ),
                          ChoiceChip(
                            label: const Text('Blue'),
                            selected: note.color == Colors.blue,
                            onSelected: (bool sel) {
                              if (sel) setState(() => note.color = Colors.blue);
                            },
                          ),
                          ChoiceChip(
                            label: const Text('Teal'),
                            selected: note.color == Colors.teal,
                            onSelected: (bool sel) {
                              if (sel) setState(() => note.color = Colors.teal);
                            },
                          ),
                        ],
                      )
                    ]
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // TAB 4: Floating Bubble Customizer & Controls
  Widget _buildCustomizerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Bubble Customizer',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tailor your floating assistant theme, transparency, size, and display rules for maximum daily comfort.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          // Bubble Color Selector
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bubble Color Theme',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildColorPickerCircle(Colors.indigo),
                      _buildColorPickerCircle(Colors.purple),
                      _buildColorPickerCircle(Colors.teal),
                      _buildColorPickerCircle(Colors.deepOrange),
                      _buildColorPickerCircle(Colors.green),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Sliders Widget
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bubble Size: ${_bubbleSize.toInt()} px',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Slider(
                    value: _bubbleSize,
                    min: 48.0,
                    max: 80.0,
                    divisions: 8,
                    activeColor: _bubbleColor,
                    onChanged: (val) {
                      setState(() {
                        _bubbleSize = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Opacity: ${(_bubbleOpacity * 100).toInt()}%',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Slider(
                    value: _bubbleOpacity,
                    min: 0.3,
                    max: 1.0,
                    divisions: 7,
                    activeColor: _bubbleColor,
                    onChanged: (val) {
                      setState(() {
                        _bubbleOpacity = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Toggles
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Enable Floating Overlay'),
                  subtitle: const Text('Show floating action bubble above other apps'),
                  value: _isOverlayEnabled,
                  onChanged: (val) {
                    setState(() {
                      _isOverlayEnabled = val;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Persistent Notification Trigger'),
                  subtitle: const Text('Quickly restore bubble from notification shade'),
                  value: _isNotificationTriggerEnabled,
                  onChanged: (val) {
                    setState(() {
                      _isNotificationTriggerEnabled = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // App Info
          Center(
            child: Column(
              children: const [
                Text(
                  'FloatMate v2.5.0 • Live Floating Productivity',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  'Designed for daily high-engagement context assistance',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildColorPickerCircle(Color color) {
    bool isSelected = _bubbleColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          _bubbleColor = color;
        });
      },
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 22)
            : null,
      ),
    );
  }

  Widget _buildStatusBadge(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeBadge(String type) {
    Color bg = Colors.grey.shade200;
    Color fg = Colors.black87;
    IconData icon = Icons.text_snippet;

    if (type == 'Phone') {
      bg = Colors.green.shade100;
      fg = Colors.green.shade900;
      icon = Icons.phone;
    } else if (type == 'Link') {
      bg = Colors.blue.shade100;
      fg = Colors.blue.shade900;
      icon = Icons.link;
    } else if (type == 'Email') {
      bg = Colors.purple.shade100;
      fg = Colors.purple.shade900;
      icon = Icons.email;
    } else if (type == 'LKR') {
      bg = Colors.amber.shade100;
      fg = Colors.amber.shade900;
      icon = Icons.monetization_on;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            type,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: fg),
          ),
        ],
      ),
    );
  }

  void _showQuickActionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.widgets, color: Colors.indigo),
                    SizedBox(width: 8),
                    Text(
                      'FloatMate Quick Overlay Actions',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.indigo,
                    child: Icon(Icons.content_paste, color: Colors.white, size: 20),
                  ),
                  title: const Text('Snip Clipboard Text'),
                  subtitle: const Text('Auto-extract phone numbers and prices'),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _currentIndex = 1);
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.note_add, color: Colors.white, size: 20),
                  ),
                  title: const Text('New Floating Sticky Note'),
                  subtitle: const Text('Pin quick reminder on top of apps'),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _currentIndex = 2);
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: Icon(Icons.settings, color: Colors.white, size: 20),
                  ),
                  title: const Text('Customize Bubble'),
                  subtitle: const Text('Change floating icon color & transparency'),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _currentIndex = 3);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}