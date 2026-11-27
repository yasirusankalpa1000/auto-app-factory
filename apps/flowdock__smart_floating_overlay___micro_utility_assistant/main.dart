import 'package:flutter/material.dart';

void main() {
  runApp(const FlowDockApp());
}

class FlowDockApp extends StatelessWidget {
  const FlowDockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlowDock Utility',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121418),
      ),
      themeMode: ThemeMode.system,
      home: const MainHomeScreen(),
    );
  }
}

// Model for Clipboard Items
class ClipboardItem {
  final String id;
  final String content;
  final String type; // 'link', 'phone', 'price', 'text'
  final DateTime timestamp;
  bool isPinned;

  ClipboardItem({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isPinned = false,
  });
}

// Model for Sticky Notes
class StickyNote {
  final String id;
  String title;
  String text;
  Color color;
  bool isPinnedToBubble;

  StickyNote({
    required this.id,
    required this.title,
    required this.text,
    required this.color,
    this.isPinnedToBubble = false,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  
  // App-wide State
  bool _overlayPermissionGranted = true;
  bool _notificationPermissionGranted = true;
  bool _isFloatingBubbleEnabled = true;
  double _bubbleOpacity = 0.9;
  Color _bubbleColor = Colors.indigo;
  
  // Position of Floating Overlay Bubble inside the viewport
  Offset _bubblePosition = const Offset(20, 200);
  bool _isBubbleExpanded = false;
  String _activeToolInBubble = 'quick_calc';

  // Eye Care Filter state
  bool _isScreenFilterActive = false;
  double _filterOpacity = 0.25;
  Color _filterColor = Colors.amber;

  // Efficiency / Gamification Stats
  int _dailyActions = 14;
  int _streakDays = 5;

  // Data Stores
  final List<ClipboardItem> _clipboardHistory = [
    ClipboardItem(
      id: '1',
      content: 'https://flutter.dev/docs/get-started',
      type: 'link',
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      isPinned: true,
    ),
    ClipboardItem(
      id: '2',
      content: '\$149.99 sale discount item',
      type: 'price',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ClipboardItem(
      id: '3',
      content: '+1 (555) 019-2834',
      type: 'phone',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    ClipboardItem(
      id: '4',
      content: 'Remember to check the quarterly budget metrics before meeting.',
      type: 'text',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  final List<StickyNote> _notes = [
    StickyNote(
      id: 'n1',
      title: 'Shopping List',
      text: 'Milk, Eggs, Whole Wheat Bread, Almond Milk',
      color: Colors.amber,
      isPinnedToBubble: true,
    ),
    StickyNote(
      id: 'n2',
      title: 'Meeting Key Points',
      text: '1. Review design guidelines\n2. Finalize AdMob layout\n3. Launch beta test',
      color: Colors.teal,
    ),
  ];

  // Quick Calculator State inside Floating Tool
  double _billAmount = 85.0;
  double _discountPercent = 15.0;
  int _splitPeople = 2;

  final TextEditingController _clipInputController = TextEditingController();
  final TextEditingController _noteTitleController = TextEditingController();
  final TextEditingController _noteTextController = TextEditingController();

  @override
  void dispose() {
    _clipInputController.dispose();
    _noteTitleController.dispose();
    _noteTextController.dispose();
    super.dispose();
  }

  void _addClipboardItem(String text) {
    if (text.trim().isEmpty) return;
    String detectedType = 'text';
    if (text.startsWith('http://') || text.startsWith('https://')) {
      detectedType = 'link';
    } else if (text.contains('\$') || RegExp(r'^\d+(\.\d+)?$').hasMatch(text.trim())) {
      detectedType = 'price';
    } else if (RegExp(r'^[+]*[(]?[0-9]{1,4}[)]?[-\s./0-9]*$').hasMatch(text.trim())) {
      detectedType = 'phone';
    }

    setState(() {
      _clipboardHistory.insert(
        0,
        ClipboardItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: text.trim(),
          type: detectedType,
          timestamp: DateTime.now(),
        ),
      );
      _dailyActions++;
    });
    _clipInputController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item added to FlowDock Clipboard!'), duration: Duration(seconds: 2)),
    );
  }

  void _addStickyNote() {
    if (_noteTitleController.text.trim().isEmpty) return;
    setState(() {
      _notes.insert(
        0,
        StickyNote(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _noteTitleController.text.trim(),
          text: _noteTextController.text.trim(),
          color: Colors.teal,
        ),
      );
      _dailyActions++;
    });
    _noteTitleController.clear();
    _noteTextController.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Body Navigator Screens
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildDashboardTab(),
                _buildClipboardTab(),
                _buildToolsTab(),
                _buildNotesTab(),
              ],
            ),
          ),

          // Optional Screen Dimmer / Eye Care Overlay Simulator
          if (_isScreenFilterActive)
            IgnorePointer(
              child: Container(
                color: _filterColor.withOpacity(_filterOpacity),
              ),
            ),

          // Interactive Draggable Floating Bubble System
          if (_isFloatingBubbleEnabled) _buildDraggableFloatingDock(),
        ],
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
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dock',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_copy_outlined),
            selectedIcon: Icon(Icons.content_copy),
            label: 'Clipboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Tools',
          ),
          NavigationDestination(
            icon: Icon(Icons.note_alt_outlined),
            selectedIcon: Icon(Icons.note_alt),
            label: 'Stickies',
          ),
        ],
      ),
    );
  }

  // Floating Overlay Bubble Widget Logic
  Widget _buildDraggableFloatingDock() {
    return Positioned(
      left: _bubblePosition.dx,
      top: _bubblePosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            double newX = _bubblePosition.dx + details.delta.dx;
            double newY = _bubblePosition.dy + details.delta.dy;
            // Screen boundary clamping logic
            final screenSize = MediaQuery.of(context).size;
            newX = newX.clamp(10.0, screenSize.width - 70.0);
            newY = newY.clamp(40.0, screenSize.height - 120.0);
            _bubblePosition = Offset(newX, newY);
          });
        },
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(28),
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            width: _isBubbleExpanded ? 280 : 56,
            height: _isBubbleExpanded ? 340 : 56,
            decoration: BoxDecoration(
              color: _bubbleColor.withOpacity(_bubbleOpacity),
              borderRadius: BorderRadius.circular(_isBubbleExpanded ? 20 : 28),
              boxShadow: [
                BoxShadow(
                  color: _bubbleColor.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _isBubbleExpanded ? _buildExpandedBubbleContent() : _buildCollapsedBubbleIcon(),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedBubbleIcon() {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: () {
        setState(() {
          _isBubbleExpanded = true;
        });
      },
      child: const Center(
        child: Icon(
          Icons.widgets,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildExpandedBubbleContent() {
    double discountedTotal = _billAmount * (1 - (_discountPercent / 100));
    double perPerson = discountedTotal / (_splitPeople > 0 ? _splitPeople : 1);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bubble Header Bar
            Row(
              children: [
                const Icon(Icons.flash_on, color: Colors.amber, size: 20),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'FlowDock Overlay',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    setState(() {
                      _isBubbleExpanded = false;
                    });
                  },
                ),
              ],
            ),
            const Divider(color: Colors.white70, height: 12),

            // Quick Tool Mode Selector Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _bubbleTabButton(Icons.calculate, 'quick_calc'),
                _bubbleTabButton(Icons.content_copy, 'clipboard'),
                _bubbleTabButton(Icons.note, 'notes'),
              ],
            ),
            const SizedBox(height: 10),

            // Inner Active Tool Payload
            if (_activeToolInBubble == 'quick_calc') ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Price \$:', style: TextStyle(color: Colors.white, fontSize: 12)),
                        SizedBox(
                          width: 80,
                          height: 30,
                          child: TextField(
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _billAmount = double.tryParse(val) ?? _billAmount;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text('Discount: ${_discountPercent.toInt()}%', style: const TextStyle(color: Colors.white, fontSize: 12)),
                        Expanded(
                          child: Slider(
                            value: _discountPercent,
                            min: 0,
                            max: 75,
                            activeColor: Colors.amber,
                            onChanged: (val) {
                              setState(() {
                                _discountPercent = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Final: \$${discountedTotal.toStringAsFixed(2)}  (\$${perPerson.toStringAsFixed(2)}/p)',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (_activeToolInBubble == 'clipboard') ...[
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _clipboardHistory.isEmpty
                    ? const Center(child: Text('No Clips', style: TextStyle(color: Colors.white70)))
                    : ListView.builder(
                        itemCount: _clipboardHistory.length,
                        shrinkWrap: true,
                        itemBuilder: (context, idx) {
                          final item = _clipboardHistory[idx];
                          return ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                            title: Text(
                              item.content,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.copy, color: Colors.amber, size: 14),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Copied to system clipboard!'), duration: Duration(seconds: 1)),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ] else ...[
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _notes.isEmpty
                    ? const Center(child: Text('No Stickies', style: TextStyle(color: Colors.white70)))
                    : ListView.builder(
                        itemCount: _notes.length,
                        shrinkWrap: true,
                        itemBuilder: (context, idx) {
                          final n = _notes[idx];
                          return ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                            title: Text(
                              n.title,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            subtitle: Text(
                              n.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _bubbleTabButton(IconData icon, String mode) {
    bool isSelected = _activeToolInBubble == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeToolInBubble = mode;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white70 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: isSelected ? Colors.amberAccent : Colors.white, size: 20),
      ),
    );
  }

  // TAB 1: DOCK CONTROL & OVERLAY PREVIEW
  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.widgets,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FlowDock Hub',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      softWrap: true,
                    ),
                    const Text(
                      'Smart Overlay & Daily Micro-Utility',
                      style: TextStyle(color: Colors.grey),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Engagement Streak Card
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: Icon(Icons.stars, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Efficiency Streak: $_streakDays Days!',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          softWrap: true,
                        ),
                        Text(
                          '$_dailyActions micro-actions solved today without leaving context.',
                          style: TextStyle(color: Colors.grey[700], fontSize: 13),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Permission & Floating Service Toggles Card
          const Text(
            'System Overlay Controls',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Floating Screen Bubble Dock', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Draggable floating helper visible on top of screens'),
                    value: _isFloatingBubbleEnabled,
                    activeColor: Colors.indigo,
                    onChanged: (val) {
                      setState(() {
                        _isFloatingBubbleEnabled = val;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Display Over Apps Permission', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Simulated system overlay authorization'),
                    value: _overlayPermissionGranted,
                    activeColor: Colors.teal,
                    onChanged: (val) {
                      setState(() {
                        _overlayPermissionGranted = val;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(val ? 'Overlay permission granted!' : 'Overlay permission revoked!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Smart Notification Bar', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Quick actions available directly in notification tray'),
                    value: _notificationPermissionGranted,
                    activeColor: Colors.teal,
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

          // Customization Palette Card
          const Text(
            'Bubble Customization',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Theme Color', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    crossAxisAlignment: WrapCrossAxisAlignment.start,
                    children: [
                      _colorChip(Colors.indigo),
                      _colorChip(Colors.teal),
                      _colorChip(Colors.deepPurple),
                      _colorChip(Colors.deepOrange),
                      _colorChip(Colors.blueGrey),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Bubble Opacity:', style: TextStyle(fontWeight: FontWeight.w500)),
                      Expanded(
                        child: Slider(
                          value: _bubbleOpacity,
                          min: 0.4,
                          max: 1.0,
                          activeColor: _bubbleColor,
                          onChanged: (val) {
                            setState(() {
                              _bubbleOpacity = val;
                            });
                          },
                        ),
                      ),
                      Text('${(_bubbleOpacity * 100).toInt()}%'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Simulate Smart Notification Trigger Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.notifications_active),
              label: const Text('Test Smart Sticky Notification Bar', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                _showNotificationSimBottomSheet(context);
              },
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _colorChip(Color color) {
    bool isSelected = _bubbleColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          _bubbleColor = color;
        });
      },
      child: CircleAvatar(
        radius: 18,
        backgroundColor: color,
        child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
      ),
    );
  }

  // TAB 2: CLIPBOARD INSPECTOR
  Widget _buildClipboardTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Smart Clipboard Inspector',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const Text(
              'Auto-categorized micro-content captured on the fly.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Add Manual Clip Input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _clipInputController,
                    decoration: const InputDecoration(
                      hintText: 'Paste or type link, phone, or text...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onPressed: () => _addClipboardItem(_clipInputController.text),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // List of Clips
            Expanded(
              child: _clipboardHistory.isEmpty
                  ? const Center(child: Text('No saved clips yet.'))
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _clipboardHistory.length,
                      itemBuilder: (context, idx) {
                        final item = _clipboardHistory[idx];
                        IconData iconData = Icons.text_snippet;
                        Color badgeColor = Colors.grey;

                        if (item.type == 'link') {
                          iconData = Icons.link;
                          badgeColor = Colors.blue;
                        } else if (item.type == 'phone') {
                          iconData = Icons.phone;
                          badgeColor = Colors.green;
                        } else if (item.type == 'price') {
                          iconData = Icons.attach_money;
                          badgeColor = Colors.amber;
                        }

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: badgeColor.withOpacity(0.2),
                              child: Icon(iconData, color: badgeColor),
                            ),
                            title: Text(
                              item.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            subtitle: Text(
                              'Captured ${item.timestamp.hour}:${item.timestamp.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    item.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                                    color: item.isPinned ? Colors.indigo : Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      item.isPinned = !item.isPinned;
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                  onPressed: () {
                                    setState(() {
                                      _clipboardHistory.removeAt(idx);
                                    });
                                  },
                                ),
                              ],
                            ),
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

  // TAB 3: MICRO-TOOLS ENGINE (Calculators & Eye Filter)
  Widget _buildToolsTab() {
    double discountedTotal = _billAmount * (1 - (_discountPercent / 100));
    double perPerson = discountedTotal / (_splitPeople > 0 ? _splitPeople : 1);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Tools Engine',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const Text(
            'Instant daily helpers without opening heavy standalone apps.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Tool Card 1: Instant Discount & Bill Splitter
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.monetization_on, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(
                        'Instant Discount & Bill Splitter',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Original Price (\$)'),
                      ),
                      SizedBox(
                        width: 120,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          onChanged: (val) {
                            setState(() {
                              _billAmount = double.tryParse(val) ?? 0.0;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('Discount: ${_discountPercent.toInt()}%'),
                      Expanded(
                        child: Slider(
                          value: _discountPercent,
                          min: 0,
                          max: 90,
                          activeColor: Colors.teal,
                          onChanged: (val) {
                            setState(() {
                              _discountPercent = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Split Persons: $_splitPeople'),
                      Expanded(
                        child: Slider(
                          value: _splitPeople.toDouble(),
                          min: 1,
                          max: 10,
                          divisions: 9,
                          activeColor: Colors.teal,
                          onChanged: (val) {
                            setState(() {
                              _splitPeople = val.toInt();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Final Payable: \$${discountedTotal.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Each Person Pays: \$${perPerson.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Tool Card 2: Screen Eye Care & Reading Filter Guard
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.visibility, color: Colors.amber),
                          SizedBox(width: 8),
                          Text(
                            'Eye Care Screen Dimmer Filter',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      Switch(
                        value: _isScreenFilterActive,
                        activeColor: Colors.amber,
                        onChanged: (val) {
                          setState(() {
                            _isScreenFilterActive = val;
                          });
                        },
                      ),
                    ],
                  ),
                  const Text(
                    'Applies warm tint tint over screen to reduce night eye strain while browsing.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  if (_isScreenFilterActive) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Warm Intensity:'),
                        Expanded(
                          child: Slider(
                            value: _filterOpacity,
                            min: 0.1,
                            max: 0.6,
                            activeColor: Colors.amber,
                            onChanged: (val) {
                              setState(() {
                                _filterOpacity = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // TAB 4: FLOATING STICKY NOTES
  Widget _buildNotesTab() {
    return SafeArea(
      child: Padding(
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
                      'Floating Stickies',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      'Pin micro notes right on your floating dock.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('New Note'),
                  onPressed: () => _showAddNoteDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _notes.isEmpty
                  ? const Center(child: Text('No active sticky notes.'))
                  : GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: _notes.length,
                      itemBuilder: (context, idx) {
                        final note = _notes[idx];
                        return Card(
                          color: note.color.withOpacity(0.15),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: note.color, width: 1.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        note.title,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, size: 18, color: Colors.redAccent),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        setState(() {
                                          _notes.removeAt(idx);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const Divider(height: 10),
                                Expanded(
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Text(
                                      note.text,
                                      style: const TextStyle(fontSize: 13),
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

  // Dialog to Add Sticky Notes
  void _showAddNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Create Sticky Note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _noteTitleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _noteTextController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Note Content',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _addStickyNote,
              child: const Text('Save Note'),
            ),
          ],
        );
      },
    );
  }

  // Bottom Sheet simulating System Floating Notification Bar
  void _showNotificationSimBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.notifications_active, color: Colors.indigo),
                      SizedBox(width: 10),
                      Text(
                        'FlowDock Live Floating Notification',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.widgets, size: 20, color: Colors.indigo),
                            SizedBox(width: 8),
                            Text('FlowDock Quick Dock Active', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ActionChip(
                              avatar: const Icon(Icons.copy, size: 16),
                              label: const Text('Clipboard'),
                              onPressed: () {},
                            ),
                            ActionChip(
                              avatar: const Icon(Icons.calculate, size: 16),
                              label: const Text('Calc Split'),
                              onPressed: () {},
                            ),
                            ActionChip(
                              avatar: const Icon(Icons.note_add, size: 16),
                              label: const Text('Add Sticky'),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Dismiss Preview'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}