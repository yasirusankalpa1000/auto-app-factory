import 'package:flutter/material.dart';

void main() {
  runApp(const OmniFloatApp());
}

class OmniFloatApp extends StatelessWidget {
  const OmniFloatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'OmniFloat Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF12181F),
      ),
      home: const MainOverlayScreen(),
    );
  }
}

class MainOverlayScreen extends StatefulWidget {
  const MainOverlayScreen({Key? key}) : super(key: key);

  @override
  State<MainOverlayScreen> createState() => _MainOverlayScreenState();
}

class _MainOverlayScreenState extends State<MainOverlayScreen> {
  int _selectedTabIndex = 0;

  // Floating Bubble Overlay State
  bool _isFloatingEnabled = true;
  double _bubbleX = 20.0;
  double _bubbleY = 180.0;
  bool _isMenuExpanded = false;

  // Eye Care Tint Overlay State
  bool _isEyeTintActive = false;
  double _eyeTintOpacity = 0.25;
  Color _eyeTintThemeColor = Colors.amber;

  // Notification Banner State
  String? _activeNotificationTitle;
  String? _activeNotificationMessage;
  bool _showBannerNotification = false;

  // Clipboard & Snippet Storage
  final List<String> _clipboardSnippets = [
    'Meeting Room Access Code: #8849',
    'Bank Account: 104-982-334-001',
    'Delivery Address: 452 Tech Park Ave, Suite 3',
  ];
  final TextEditingController _snippetController = TextEditingController();

  // Quick Sticky Note State
  final List<Map<String, String>> _stickyNotes = [
    {'title': 'Grocery List', 'body': 'Almond Milk, Oats, Coffee, Eggs'},
    {'title': 'Quick Todo', 'body': 'Call client at 4:30 PM regarding project updates'},
  ];
  final TextEditingController _noteTitleController = TextEditingController();
  final TextEditingController _noteBodyController = TextEditingController();

  // Micro Decision Wheel / Tally Counter
  int _tallyCounter = 0;
  String _decisionResult = 'Tap to Decide!';
  final List<String> _quickOptions = ['Yes', 'No', 'Maybe Later', 'Do it Now'];

  // User Engagement Stats
  int _activeMinutesToday = 42;
  int _overlayActionsCount = 18;

  @override
  void dispose() {
    _snippetController.dispose();
    _noteTitleController.dispose();
    _noteBodyController.dispose();
    super.dispose();
  }

  void _triggerFloatingNotification(String title, String body) {
    setState(() {
      _activeNotificationTitle = title;
      _activeNotificationMessage = body;
      _showBannerNotification = true;
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showBannerNotification = false;
        });
      }
    });
  }

  void _copySnippetToClipboard(String text) {
    _triggerFloatingNotification('Clipboard Copied', text);
    setState(() {
      _overlayActionsCount++;
    });
  }

  void _addSnippet() {
    if (_snippetController.text.trim().isNotEmpty) {
      setState(() {
        _clipboardSnippets.insert(0, _snippetController.text.trim());
        _snippetController.clear();
        _overlayActionsCount++;
      });
      _triggerFloatingNotification('Snippet Saved', 'Added to quick clipboard drawer');
    }
  }

  void _addStickyNote() {
    if (_noteTitleController.text.trim().isNotEmpty) {
      setState(() {
        _stickyNotes.insert(0, {
          'title': _noteTitleController.text.trim(),
          'body': _noteBodyController.text.trim().isEmpty
              ? 'No details added'
              : _noteBodyController.text.trim(),
        });
        _noteTitleController.clear();
        _noteBodyController.clear();
        _overlayActionsCount++;
      });
      Navigator.pop(context);
      _triggerFloatingNotification('Note Pinned', 'Sticky note added to overlay');
    }
  }

  void _makeRandomDecision() {
    final randomIndex = (DateTime.now().millisecondsSinceEpoch) % _quickOptions.length;
    setState(() {
      _decisionResult = _quickOptions[randomIndex];
      _overlayActionsCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background Dashboard Body
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 90.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopHeader(),
                    const SizedBox(height: 16),
                    if (_selectedTabIndex == 0) _buildFloatingHubTab(),
                    if (_selectedTabIndex == 1) _buildOverlayToolsTab(),
                    if (_selectedTabIndex == 2) _buildNotificationSettingsTab(),
                    if (_selectedTabIndex == 3) _buildEngagementStatsTab(),
                  ],
                ),
              ),
            ),
          ),

          // Screen Eye-Care Tint Filter Overlay Simulation
          if (_isEyeTintActive)
            IgnorePointer(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: _eyeTintThemeColor.withOpacity(_eyeTintOpacity),
              ),
            ),

          // Interactive Top Floating Notification Banner
          if (_showBannerNotification)
            Positioned(
              top: 45.0,
              left: 16.0,
              right: 16.0,
              child: Material(
                elevation: 8.0,
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.teal,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active, color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _activeNotificationTitle ?? 'Notification',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _activeNotificationMessage ?? '',
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 20),
                        onPressed: () {
                          setState(() {
                            _showBannerNotification = false;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),

          // Interactive Draggable Floating Bubble Overlay Widget
          if (_isFloatingEnabled)
            Positioned(
              left: _bubbleX,
              top: _bubbleY,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubbleX += details.delta.dx;
                    _bubbleY += details.delta.dy;
                    // Clamp to screen bounds
                    _bubbleX = _bubbleX.clamp(10.0, screenSize.width - 70.0);
                    _bubbleY = _bubbleY.clamp(40.0, screenSize.height - 140.0);
                  });
                },
                onTap: () {
                  setState(() {
                    _isMenuExpanded = !_isMenuExpanded;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.5),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Icon(
                          _isMenuExpanded ? Icons.close : Icons.widgets,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    if (_isMenuExpanded) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: 200,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.teal, width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Floating Quick HUD',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const Divider(color: Colors.white70, height: 12),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.copy, color: Colors.amber, size: 18),
                              title: const Text('Copy Quick Code', style: TextStyle(color: Colors.white, fontSize: 11)),
                              onTap: () {
                                _copySnippetToClipboard(_clipboardSnippets.first);
                              },
                            ),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.remove_red_eye, color: Colors.cyan, size: 18),
                              title: Text(
                                _isEyeTintActive ? 'Disable Eye Filter' : 'Enable Eye Filter',
                                style: const TextStyle(color: Colors.white, fontSize: 11),
                              ),
                              onTap: () {
                                setState(() {
                                  _isEyeTintActive = !_isEyeTintActive;
                                });
                                _triggerFloatingNotification(
                                  'Eye Care Filter',
                                  _isEyeTintActive ? 'Screen Tint Overlay Activated' : 'Screen Tint Overlay Disabled',
                                );
                              },
                            ),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.add_alert, color: Colors.green, size: 18),
                              title: const Text('Test Banner Alert', style: TextStyle(color: Colors.white, fontSize: 11)),
                              onTap: () {
                                _triggerFloatingNotification('OmniFloat Alert', 'Floating dynamic notification active!');
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1E2732),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Float Hub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Overlay Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Balance',
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    return Card(
      color: const Color(0xFF1E2732),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.widgets, color: Colors.teal, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'OmniFloat Hub',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Floating Micro-Assistant & Quick Overlay',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Switch(
              value: _isFloatingEnabled,
              activeColor: Colors.teal,
              onChanged: (val) {
                setState(() {
                  _isFloatingEnabled = val;
                });
                _triggerFloatingNotification(
                  'Floating Dock',
                  val ? 'Floating Assistant Enabled' : 'Floating Assistant Disabled',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingHubTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Floating Bubble Control Box
        Card(
          color: const Color(0xFF1E2732),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.touch_app, color: Colors.amber, size: 22),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Interactive Floating Bubble',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Drag the green floating bubble anywhere on your screen. Tap it to expand quick macro actions without leaving your active app!',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      onPressed: () {
                        setState(() {
                          _bubbleX = 20.0;
                          _bubbleY = 180.0;
                        });
                      },
                      icon: const Icon(Icons.refresh, color: Colors.white, size: 16),
                      label: const Text('Reset Position', style: TextStyle(color: Colors.white)),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        _triggerFloatingNotification('OmniFloat Test', 'Top notification bar simulated!');
                      },
                      icon: const Icon(Icons.flash_on, color: Colors.amber, size: 16),
                      label: const Text('Test Alert', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Eye Care Tint Overlay Quick Control Card
        Card(
          color: const Color(0xFF1E2732),
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
                        Icon(Icons.palette, color: Colors.cyan, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Eye-Care Screen Filter Overlay',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    Switch(
                      value: _isEyeTintActive,
                      activeColor: Colors.cyan,
                      onChanged: (val) {
                        setState(() {
                          _isEyeTintActive = val;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Reduces visual eye fatigue during night reading or long screen sessions.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                if (_isEyeTintActive) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Filter Warmth: ', style: TextStyle(color: Colors.white, fontSize: 12)),
                      Expanded(
                        child: Slider(
                          value: _eyeTintOpacity,
                          min: 0.05,
                          max: 0.5,
                          activeColor: _eyeTintThemeColor,
                          onChanged: (val) {
                            setState(() {
                              _eyeTintOpacity = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildColorChip('Warm Amber', Colors.amber),
                      _buildColorChip('Reading Green', Colors.green),
                      _buildColorChip('Night Red', Colors.red),
                      _buildColorChip('Deep Blue', Colors.blue),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Quick Clipboard Drawer Section
        Card(
          color: const Color(0xFF1E2732),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.copy, color: Colors.orange, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Quick Floating Clipboard Stack',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _snippetController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Add quick code/text snippet...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      onPressed: _addSnippet,
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _clipboardSnippets.length,
                  itemBuilder: (context, index) {
                    final item = _clipboardSnippets[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF12181F),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        dense: true,
                        title: Text(
                          item,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.copy, color: Colors.teal, size: 18),
                          onPressed: () => _copySnippetToClipboard(item),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorChip(String label, Color color) {
    final bool isSelected = _eyeTintThemeColor == color;
    return ChoiceChip(
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11)),
      selected: isSelected,
      selectedColor: color,
      backgroundColor: Colors.grey.withOpacity(0.3),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _eyeTintThemeColor = color;
          });
        }
      },
    );
  }

  Widget _buildOverlayToolsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Floating Sticky Notes Card
        Card(
          color: const Color(0xFF1E2732),
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
                        Icon(Icons.lightbulb, color: Colors.amber, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Floating Sticky Notes',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.teal, size: 26),
                      onPressed: () {
                        _showAddNoteDialog();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Keep essential thoughts pinned in quick floating memory cards.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _stickyNotes.length,
                  itemBuilder: (context, index) {
                    final note = _stickyNotes[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF12181F),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.teal.withOpacity(0.4)),
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
                                  style: const TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  softWrap: true,
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
                          Text(
                            note['body'] ?? '',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                            softWrap: true,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Floating Quick Decision & Tally Counter Tool
        Card(
          color: const Color(0xFF1E2732),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.calculate, color: Colors.purple, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Floating Tally & Micro Decision',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF12181F),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text('Tally Count', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(
                              '$_tallyCounter',
                              style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      _tallyCounter--;
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, color: Colors.teal),
                                  onPressed: () {
                                    setState(() {
                                      _tallyCounter++;
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF12181F),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text('Quick Picker', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(
                              _decisionResult,
                              style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14),
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                              onPressed: _makeRandomDecision,
                              child: const Text('Pick Random', style: TextStyle(color: Colors.white, fontSize: 11)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E2732),
          title: const Text('New Sticky Note', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _noteTitleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Note Title',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteBodyController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Note Details',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: _addStickyNote,
              child: const Text('Save Note', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationSettingsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: const Color(0xFF1E2732),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.notifications_active, color: Colors.teal, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Floating Banner & Notification Hub',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Simulate high-priority floating overlays and system-level alerts directly over your active device view.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 16),
                _buildPermissionRow('Display Over Other Apps', true),
                const Divider(color: Colors.white70),
                _buildPermissionRow('Pop-up Floating Notifications', true),
                const Divider(color: Colors.white70),
                _buildPermissionRow('Background Clipboard Sync', true),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Card(
          color: const Color(0xFF1E2732),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Trigger Custom Floating Alert',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                      onPressed: () {
                        _triggerFloatingNotification('Eye Rest Alert', 'You have been viewing the screen for 30 minutes! Take a 20s eye break.');
                      },
                      icon: const Icon(Icons.remove_red_eye, color: Colors.white, size: 16),
                      label: const Text('Eye Rest Remind', style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                      onPressed: () {
                        _triggerFloatingNotification('Hydration Break', 'Time to drink a glass of water!');
                      },
                      icon: const Icon(Icons.local_drink, color: Colors.white, size: 16),
                      label: const Text('Water Break', style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () {
                        _triggerFloatingNotification('Clipboard Pinned', 'Your key address code is ready to paste.');
                      },
                      icon: const Icon(Icons.copy, color: Colors.white, size: 16),
                      label: const Text('Clipboard Quick Push', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionRow(String title, bool initialVal) {
    return StatefulBuilder(
      builder: (context, setInnerState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                softWrap: true,
              ),
            ),
            Switch(
              value: initialVal,
              activeColor: Colors.teal,
              onChanged: (val) {
                setInnerState(() {});
                _triggerFloatingNotification(
                  'Permission Update',
                  '$title status changed.',
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEngagementStatsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Daily Focus & Screen Balance Score
        Card(
          color: const Color(0xFF1E2732),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.stars, color: Colors.amber, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Daily Screen Engagement Balance',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatIndicator('Active Assistant', '$_activeMinutesToday min', Colors.teal),
                    _buildStatIndicator('Floating Actions', '$_overlayActionsCount', Colors.amber),
                    _buildStatIndicator('Balance Score', '94%', Colors.green),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: 0.84,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  color: Colors.teal,
                  minHeight: 8,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Great balance! OmniFloat overlay reduced your screen app switching by 40% today.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Micro Tasks & Habit Stack Targets
        Card(
          color: const Color(0xFF1E2732),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Active Floating Badges & Milestones',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.verified, color: Colors.teal, size: 28),
                  title: const Text('Overlay Master Level 1', style: TextStyle(color: Colors.white, fontSize: 13)),
                  subtitle: const Text('Used floating clipboard 15+ times', style: TextStyle(color: Colors.grey, fontSize: 11)),
                ),
                const Divider(color: Colors.white70),
                ListTile(
                  leading: const Icon(Icons.shield, color: Colors.cyan, size: 28),
                  title: const Text('Eye Care Defender', style: TextStyle(color: Colors.white, fontSize: 13)),
                  subtitle: const Text('Activated warm screen tint filter overlay', style: TextStyle(color: Colors.grey, fontSize: 11)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatIndicator(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 11),
        ),
      ],
    );
  }
}