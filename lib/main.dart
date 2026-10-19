import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const FloatingHudApp());
}

class FloatingHudApp extends StatelessWidget {
  const FloatingHudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatingHUD Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      home: const MainOverlayScreen(),
    );
  }
}

class MainOverlayScreen extends StatefulWidget {
  const MainOverlayScreen({super.key});

  @override
  State<MainOverlayScreen> createState() => _MainOverlayScreenState();
}

class _MainOverlayScreenState extends State<MainOverlayScreen> {
  // Floating HUD Position & State
  double _hudX = 20.0;
  double _hudY = 120.0;
  bool _isHudExpanded = false;
  bool _isOverlayEnabled = true;
  int _activeHudTab = 0; // 0: Clipboard, 1: Smart Reply, 2: Sticky Memo

  // Screen Warm Light Filter State
  bool _isWarmFilterActive = false;
  double _filterOpacity = 0.20;

  // App Theme Customizer
  Color _hudThemeColor = Colors.indigo;

  // Data Stores
  final List<Map<String, String>> _clipboardVault = [
    {
      'title': 'Work Email Signature',
      'text': 'Best regards,\nAlex Silva | Product Lead\nPhone: +1 555-0199',
      'tag': 'Work'
    },
    {
      'title': 'Delivery Address',
      'text': 'Building B, 4th Floor, Suite 402, High Street',
      'tag': 'Personal'
    },
    {
      'title': 'Bank Account Quick Info',
      'text': 'Account: 88401923 | Bank: Commercial Hub | SWIFT: CHUBUS',
      'tag': 'Finance'
    },
    {
      'title': 'Zoom Meeting ID & Pass',
      'text': 'ID: 890 2210 4491 | Passcode: 772091',
      'tag': 'Work'
    },
  ];

  final List<Map<String, String>> _smartReplies = [
    {
      'category': 'Casual',
      'prompt': 'Running Late',
      'text': 'Hey! On my way now, should be there in about 10-15 mins! Sorry for the delay.'
    },
    {
      'category': 'Work',
      'prompt': 'Acknowledge Email',
      'text': 'Received with thanks. I will review the documents and get back to you shortly.'
    },
    {
      'category': 'Casual',
      'prompt': 'Call You Later',
      'text': 'Hey, in a meeting right now. Will call you back as soon as I am free!'
    },
    {
      'category': 'Payment',
      'prompt': 'Request Receipt',
      'text': 'Hi, payment has been sent! Could you please confirm receipt when convenient?'
    },
  ];

  final List<Map<String, String>> _stickyNotes = [
    {'title': 'Buy Grocery Items', 'content': 'Milk, Eggs, Bread, Green Tea, Espresso pods'},
    {'title': 'Call Architect', 'content': 'Check floor plan updates for 2nd floor balcony'},
  ];

  final TextEditingController _clipTitleController = TextEditingController();
  final TextEditingController _clipTextController = TextEditingController();
  final TextEditingController _stickyTitleController = TextEditingController();
  final TextEditingController _stickyContentController = TextEditingController();

  void _showToast(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    _showToast('Copied to Clipboard!');
  }

  void _addNewClip() {
    if (_clipTitleController.text.trim().isEmpty || _clipTextController.text.trim().isEmpty) {
      _showToast('Please enter both title and snippet text.');
      return;
    }
    setState(() {
      _clipboardVault.insert(0, {
        'title': _clipTitleController.text.trim(),
        'text': _clipTextController.text.trim(),
        'tag': 'Custom',
      });
      _clipTitleController.clear();
      _clipTextController.clear();
    });
    Navigator.pop(context);
    _showToast('Snippet saved to Quick Vault!');
  }

  void _addStickyNote() {
    if (_stickyTitleController.text.trim().isEmpty || _stickyContentController.text.trim().isEmpty) {
      _showToast('Please enter title and note body.');
      return;
    }
    setState(() {
      _stickyNotes.insert(0, {
        'title': _stickyTitleController.text.trim(),
        'content': _stickyContentController.text.trim(),
      });
      _stickyTitleController.clear();
      _stickyContentController.clear();
    });
    Navigator.pop(context);
    _showToast('Sticky Memo pinned to screen!');
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.layers, color: _hudThemeColor),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'FloatingHUD Dock',
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isWarmFilterActive ? Icons.remove_red_eye : Icons.visibility_off,
              color: _isWarmFilterActive ? Colors.amber : Colors.grey,
            ),
            tooltip: 'Toggle Night Warm Filter',
            onPressed: () {
              setState(() {
                _isWarmFilterActive = !_isWarmFilterActive;
              });
              _showToast(
                _isWarmFilterActive ? 'Screen Comfort Filter Enabled' : 'Screen Filter Disabled',
              );
            },
          ),
          IconButton(
            icon: Icon(
              _isOverlayEnabled ? Icons.widgets : Icons.widgets_outlined,
              color: _hudThemeColor,
            ),
            tooltip: 'Toggle Floating Dock Overlay',
            onPressed: () {
              setState(() {
                _isOverlayEnabled = !_isOverlayEnabled;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // MAIN APP DASHBOARD & UTILITY WORKSPACE
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HERO STATS & LIVE CONTROLS CARD
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: _hudThemeColor.withOpacity(0.15),
                                child: Icon(Icons.tune, color: _hudThemeColor),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Live Screen Overlay Dock',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Always accessible on screen without closing apps',
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 0, height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAxisAlignment.center,
                            children: [
                              FilterChip(
                                selected: _isOverlayEnabled,
                                label: Text(_isOverlayEnabled ? 'Overlay Active' : 'Overlay Hidden'),
                                avatar: Icon(_isOverlayEnabled ? Icons.check : Icons.close, size: 16),
                                onSelected: (val) {
                                  setState(() {
                                    _isOverlayEnabled = val;
                                  });
                                },
                              ),
                              FilterChip(
                                selected: _isWarmFilterActive,
                                label: Text(_isWarmFilterActive ? 'Warm Light ON' : 'Warm Light OFF'),
                                avatar: const Icon(Icons.lightbulb, size: 16),
                                selectedColor: Colors.amber.withOpacity(0.3),
                                onSelected: (val) {
                                  setState(() {
                                    _isWarmFilterActive = val;
                                  });
                                },
                              ),
                            ],
                          ),
                          if (_isWarmFilterActive) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.brightness_6, size: 18, color: Colors.amber),
                                const SizedBox(width: 8),
                                const Text('Filter Warmth: ', style: TextStyle(fontSize: 12)),
                                Expanded(
                                  child: Slider(
                                    value: _filterOpacity,
                                    min: 0.05,
                                    max: 0.45,
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

                  const SizedBox(height: 20),

                  // DASHBOARD QUICK ACTION SECTIONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          'Quick Clipboard Vault',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _hudThemeColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => _openAddClipModal(context),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Snippet'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // CLIPBOARD SNIPPETS LIST
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _clipboardVault.length,
                    itemBuilder: (context, index) {
                      final item = _clipboardVault[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item['title'] ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Chip(
                                label: Text(
                                  item['tag'] ?? 'General',
                                  style: const TextStyle(fontSize: 10),
                                ),
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              item['text'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.content_copy, size: 20),
                            color: _hudThemeColor,
                            onPressed: () => _copyToClipboard(item['text'] ?? ''),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // SMART MESSAGING REPLIES SECTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          'Smart Reply Templates',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          _showToast('Reply templates refreshed');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _smartReplies.map((reply) {
                        return Container(
                          width: 220,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.chat_bubble_outline, size: 16, color: _hudThemeColor),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      reply['prompt'] ?? '',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                reply['text'] ?? '',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton.icon(
                                  style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                                  onPressed: () => _copyToClipboard(reply['text'] ?? ''),
                                  icon: const Icon(Icons.copy, size: 14),
                                  label: const Text('Copy', style: TextStyle(fontSize: 12)),
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // HUD ACCENT COLOR SELECTOR
                  const Text(
                    'Customize Floating Theme Color',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    children: [
                      Colors.indigo,
                      Colors.teal,
                      Colors.purple,
                      Colors.deepOrange,
                      Colors.blueGrey,
                    ].map((color) {
                      final isSelected = _hudThemeColor == color;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _hudThemeColor = color;
                          });
                        },
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: color,
                          child: isSelected
                              ? const Icon(Icons.check, color: Colors.white, size: 18)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // NIGHT / WARM EYE PROTECTION OVERLAY SIMULATOR
          if (_isWarmFilterActive)
            IgnorePointer(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.amber.withOpacity(_filterOpacity),
              ),
            ),

          // DRAGGABLE FLOATING HUD OVERLAY WIDGET
          if (_isOverlayEnabled)
            Positioned(
              left: _hudX,
              top: _hudY,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _hudX = (_hudX + details.delta.dx)
                        .clamp(0.0, screenSize.width - (_isHudExpanded ? 300.0 : 60.0));
                    _hudY = (_hudY + details.delta.dy)
                        .clamp(60.0, screenSize.height - (_isHudExpanded ? 360.0 : 80.0));
                  });
                },
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(_isHudExpanded ? 20 : 30),
                  color: Theme.of(context).cardColor,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _isHudExpanded ? 300 : 56,
                    height: _isHudExpanded ? 360 : 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(_isHudExpanded ? 20 : 30),
                      border: Border.all(color: _hudThemeColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: _hudThemeColor.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: _isHudExpanded ? _buildExpandedHudContent() : _buildCollapsedHudIcon(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // COLLAPSED HUD BUBBLE ICON
  Widget _buildCollapsedHudIcon() {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        setState(() {
          _isHudExpanded = true;
        });
      },
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.widgets, color: _hudThemeColor, size: 28),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${_clipboardVault.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // EXPANDED HUD OVERLAY DOCK
  Widget _buildExpandedHudContent() {
    return Column(
      children: [
        // HUD HEADER
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _hudThemeColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: Row(
            children: [
              const Icon(Icons.open_with, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Floating Dock',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isHudExpanded = false;
                  });
                },
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ],
          ),
        ),

        // HUD TAB NAVIGATION BAR
        Container(
          color: Theme.of(context).colorScheme.surface,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _hudTabButton(0, Icons.content_copy, 'Clips'),
              _hudTabButton(1, Icons.chat_bubble_outline, 'Replies'),
              _hudTabButton(2, Icons.note, 'Memos'),
            ],
          ),
        ),

        const Divider(height: 1),

        // HUD CONTENT VIEW
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: _buildHudTabBody(),
          ),
        ),
      ],
    );
  }

  Widget _hudTabButton(int index, IconData icon, String label) {
    final isSelected = _activeHudTab == index;
    return InkWell(
      onTap: () {
        setState(() {
          _activeHudTab = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? _hudThemeColor : Colors.grey,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? _hudThemeColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHudTabBody() {
    if (_activeHudTab == 0) {
      // TAB 0: QUICK CLIPBOARD HUD
      return ListView.builder(
        itemCount: _clipboardVault.length,
        itemBuilder: (context, index) {
          final clip = _clipboardVault[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 6),
            child: ListTile(
              dense: true,
              title: Text(
                clip['title'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                clip['text'] ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.copy, size: 16),
                onPressed: () => _copyToClipboard(clip['text'] ?? ''),
              ),
            ),
          );
        },
      );
    } else if (_activeHudTab == 1) {
      // TAB 1: SMART REPLIES HUD
      return ListView.builder(
        itemCount: _smartReplies.length,
        itemBuilder: (context, index) {
          final reply = _smartReplies[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 6),
            child: ListTile(
              dense: true,
              title: Text(
                reply['prompt'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                reply['text'] ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.send, size: 16),
                onPressed: () => _copyToClipboard(reply['text'] ?? ''),
              ),
            ),
          );
        },
      );
    } else {
      // TAB 2: STICKY MEMO HUD
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pinned Sticky Notes',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () => _openAddStickyModal(context),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Icon(Icons.add, size: 14, color: _hudThemeColor),
                      Text('New', style: TextStyle(fontSize: 11, color: _hudThemeColor)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
            child: ListView.builder(
              itemCount: _stickyNotes.length,
              itemBuilder: (context, index) {
                final note = _stickyNotes[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note['title'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        note['content'] ?? '',
                        style: const TextStyle(fontSize: 10),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
  }

  void _openAddClipModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Save Quick Snippet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _clipTitleController,
                decoration: const InputDecoration(
                  labelText: 'Snippet Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _clipTextController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Text Content / Address / Account',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _hudThemeColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _addNewClip,
                  child: const Text('Save to Clipboard Vault'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openAddStickyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pin Sticky Memo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _stickyTitleController,
                decoration: const InputDecoration(
                  labelText: 'Memo Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _stickyContentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Sticky Note Details',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _addStickyNote,
                  child: const Text('Pin Note to Overlay'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}