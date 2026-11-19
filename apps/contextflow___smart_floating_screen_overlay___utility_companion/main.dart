import 'package:flutter/material.dart';

void main() {
  runApp(const ContextFlowApp());
}

class ContextFlowApp extends StatelessWidget {
  const ContextFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ContextFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFA5F0FF),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    FloatingHUDTab(),
    ClipStackTab(),
    OverlayPermissionsTab(),
    QuickToolsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.widgets),
            selectedIcon: Icon(Icons.widgets, color: Colors.indigo),
            label: 'Floating HUD',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_copy),
            selectedIcon: Icon(Icons.content_copy, color: Colors.indigo),
            label: 'Clip Stack',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_active),
            selectedIcon: Icon(Icons.notifications_active, color: Colors.indigo),
            label: 'Floating Bar',
          ),
          NavigationDestination(
            icon: Icon(Icons.build),
            selectedIcon: Icon(Icons.build, color: Colors.indigo),
            label: 'Context Tools',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 1: FLOATING OVERLAY HUD & BUBBLE SIMULATOR
// -----------------------------------------------------------------------------
class FloatingHUDTab extends StatefulWidget {
  const FloatingHUDTab({super.key});

  @override
  State<FloatingHUDTab> createState() => _FloatingHUDTabState();
}

class _FloatingHUDTabState extends State<FloatingHUDTab> {
  Offset _bubblePosition = const Offset(150, 220);
  bool _isBubbleExpanded = false;
  bool _isFloatingServiceActive = true;
  String _activeTool = 'Quick Snippet';
  
  final TextEditingController _quickNoteController = TextEditingController();
  final List<String> _pinnedNotes = [
    'Order ID: #FL-9920',
    'Meeting link: https://meet.link/cf-980',
    'Discount code: SAVE25NOW',
  ];

  @override
  void dispose() {
    _quickNoteController.dispose();
    super.dispose();
  }

  void _addQuickNote() {
    if (_quickNoteController.text.trim().isNotEmpty) {
      setState(() {
        _pinnedNotes.insert(0, _quickNoteController.text.trim());
        _quickNoteController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note pinned to Floating Widget Stack!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 16),
                  _buildServiceControlCard(),
                  const SizedBox(height: 16),
                  _buildWidgetCustomizerCard(),
                  const SizedBox(height: 16),
                  _buildActiveNotesCard(),
                  const SizedBox(height: 120), // Spacing for floating interactive space
                ],
              ),
            ),
            // Floating Interactive Canvas Overlay Bubble
            if (_isFloatingServiceActive)
              Positioned(
                left: _bubblePosition.dx.clamp(10.0, constraints.maxWidth - 200.0),
                top: _bubblePosition.dy.clamp(10.0, constraints.maxHeight - 200.0),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _bubblePosition += details.delta;
                    });
                  },
                  child: _isBubbleExpanded
                      ? _buildExpandedFloatingMenu()
                      : _buildCollapsedBubble(),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Floating HUD Companion',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Drag the floating bubble around your screen! Access instant clips, quick tools, and micro-notes anywhere.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceControlCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: _isFloatingServiceActive ? Colors.green : Colors.grey,
              child: Icon(
                _isFloatingServiceActive ? Icons.verified_user : Icons.shield,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isFloatingServiceActive ? 'Floating Overlay Active' : 'Overlay Service Paused',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    _isFloatingServiceActive
                        ? 'Bubble visible over other app windows'
                        : 'Enable overlay to restore floating bubble',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            Switch(
              value: _isFloatingServiceActive,
              onChanged: (val) {
                setState(() {
                  _isFloatingServiceActive = val;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetCustomizerCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Active Bubble Quick Mode',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildModeChip('Quick Snippet', Icons.content_copy),
                _buildModeChip('Micro Calc', Icons.calculate),
                _buildModeChip('Translator', Icons.translate),
                _buildModeChip('Quick Note', Icons.note_alt),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeChip(String title, IconData icon) {
    final bool isSelected = _activeTool == title;
    return FilterChip(
      selected: isSelected,
      avatar: Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.indigo),
      label: Text(title),
      selectedColor: Colors.indigo,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (bool selected) {
        if (selected) {
          setState(() {
            _activeTool = title;
          });
        }
      },
    );
  }

  Widget _buildActiveNotesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Floating Dock Pinboard',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quickNoteController,
                    decoration: const InputDecoration(
                      hintText: 'Type text snippet to pin...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _addQuickNote,
                  icon: const Icon(Icons.add),
                  backgroundColor: Colors.indigo,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _pinnedNotes.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = _pinnedNotes[index];
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.push_pin, color: Colors.amber, size: 20),
                  title: Text(
                    item,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    onPressed: () {
                      setState(() {
                        _pinnedNotes.removeAt(index);
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

  Widget _buildCollapsedBubble() {
    return Material(
      elevation: 8,
      shape: const CircleBorder(),
      color: Colors.indigo,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          setState(() {
            _isBubbleExpanded = true;
          });
        },
        child: Container(
          width: 58,
          height: 58,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.widgets, color: Colors.white, size: 22),
              SizedBox(height: 2),
              Text(
                'HUD',
                style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedFloatingMenu() {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(16),
      color: Colors.indigo.shade900,
      child: Container(
        width: 210,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.touch_app, color: Colors.amber, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      _activeTool,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isBubbleExpanded = false;
                    });
                  },
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ],
            ),
            const Divider(color: Colors.white70),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _pinnedNotes.isNotEmpty
                    ? 'Top Clip: ${_pinnedNotes.first}'
                    : 'No quick clips saved yet. Add from dock!',
                style: const TextStyle(color: Colors.white70, fontSize: 11),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.white, size: 18),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Quick snippet copied to clipboard!')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.calculate, color: Colors.white, size: 18),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Micro-Calc Widget Triggered!')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white, size: 18),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sharing floating content...')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 2: SMART CLIPBOARD & SNIPPET STACK MANAGER
// -----------------------------------------------------------------------------
class ClipStackTab extends StatefulWidget {
  const ClipStackTab({super.key});

  @override
  State<ClipStackTab> createState() => _ClipStackTabState();
}

class _ClipStackTabState extends State<ClipStackTab> {
  final List<Map<String, dynamic>> _clipHistory = [
    {
      'text': 'RS-88942-PAYMENT-REF',
      'category': 'Finance',
      'pinned': true,
      'time': '10 mins ago',
    },
    {
      'text': 'john.developer@contextflow.app',
      'category': 'Contact',
      'pinned': true,
      'time': '35 mins ago',
    },
    {
      'text': 'Delivery Address: 142 Blue Harbor Way, Suite 4',
      'category': 'Address',
      'pinned': false,
      'time': '1 hr ago',
    },
    {
      'text': 'https://github.com/flutter/flutter',
      'category': 'Link',
      'pinned': false,
      'time': '3 hrs ago',
    },
  ];

  String _selectedCategory = 'All';
  final TextEditingController _newClipController = TextEditingController();

  @override
  void dispose() {
    _newClipController.dispose();
    super.dispose();
  }

  void _addNewClip() {
    if (_newClipController.text.trim().isNotEmpty) {
      setState(() {
        _clipHistory.insert(0, {
          'text': _newClipController.text.trim(),
          'category': 'Custom',
          'pinned': false,
          'time': 'Just now',
        });
        _newClipController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to Clip Stack!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredClips = _selectedCategory == 'All'
        ? _clipHistory
        : _clipHistory.where((c) => c['category'] == _selectedCategory).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildInputCard(),
          const SizedBox(height: 16),
          _buildCategoryFilter(),
          const SizedBox(height: 16),
          _buildClipList(filteredClips),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Smart Clip & Snippet Stack',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Keep your frequent texts, codes, and links ready for 1-tap pasting anywhere without re-typing.',
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            TextField(
              controller: _newClipController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Enter new snippet or quick text to save...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addNewClip,
                icon: const Icon(Icons.add),
                label: const Text('Save Snippet to Stack'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = ['All', 'Finance', 'Contact', 'Address', 'Link', 'Custom'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSelected = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              selectedColor: Colors.teal,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (bool selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = cat;
                  });
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildClipList(List<Map<String, dynamic>> clips) {
    if (clips.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('No clips found in this category.'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: clips.length,
      itemBuilder: (context, index) {
        final clip = clips[index];
        final bool isPinned = clip['pinned'] == true;

        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(
              clip['text'],
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      clip['category'],
                      style: TextStyle(fontSize: 10, color: Colors.teal.shade800),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    clip['time'],
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    isPinned ? Icons.star : Icons.star_border,
                    color: isPinned ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      clip['pinned'] = !isPinned;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.teal),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Copied: "${clip['text']}"')),
                    );
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

// -----------------------------------------------------------------------------
// TAB 3: FLOATING NOTIFICATION & EDGE LAUNCHER CONTROLLER
// -----------------------------------------------------------------------------
class OverlayPermissionsTab extends StatefulWidget {
  const OverlayPermissionsTab({super.key});

  @override
  State<OverlayPermissionsTab> createState() => _OverlayPermissionsTabState();
}

class _OverlayPermissionsTabState extends State<OverlayPermissionsTab> {
  bool _overlayPermissionGranted = true;
  bool _persistentNotificationActive = true;
  bool _edgeSwipeHandleActive = true;
  double _floatingBubbleOpacity = 0.9;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildPermissionStatusCard(),
          const SizedBox(height: 16),
          _buildNotificationBarPreview(),
          const SizedBox(height: 16),
          _buildHUDAppSettingsCard(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Floating Overlay & Edge Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Manage persistent screen floating permissions, notification bar actions, and edge swipe triggers.',
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionStatusCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'System Overlay Permissions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Display Over Other Apps'),
              subtitle: const Text('Required to float HUD widgets over social media & browser apps'),
              value: _overlayPermissionGranted,
              onChanged: (val) {
                setState(() {
                  _overlayPermissionGranted = val;
                });
              },
            ),
            const Divider(height: 1),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Edge Swipe Gesture Handle'),
              subtitle: const Text('Swipe from right screen edge to open clip tray anytime'),
              value: _edgeSwipeHandleActive,
              onChanged: (val) {
                setState(() {
                  _edgeSwipeHandleActive = val;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationBarPreview() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Persistent Floating Notification Bar',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Switch(
                  value: _persistentNotificationActive,
                  onChanged: (val) {
                    setState(() {
                      _persistentNotificationActive = val;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Live Notification Drawer Companion Preview:',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.widgets, color: Colors.amber, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'ContextFlow Active Companion',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildNotifActionBtn('Copy Pin #1', Icons.content_copy),
                      _buildNotifActionBtn('Calc HUD', Icons.calculate),
                      _buildNotifActionBtn('Toggle Bubble', Icons.open_in_new),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotifActionBtn(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildHUDAppSettingsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Floating Overlay Transparency',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.opacity, color: Colors.deepPurple),
                Expanded(
                  child: Slider(
                    value: _floatingBubbleOpacity,
                    min: 0.3,
                    max: 1.0,
                    divisions: 7,
                    label: '${(_floatingBubbleOpacity * 100).round()}%',
                    onChanged: (val) {
                      setState(() {
                        _floatingBubbleOpacity = val;
                      });
                    },
                  ),
                ),
                Text(
                  '${(_floatingBubbleOpacity * 100).round()}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 4: CONTEXT POWER TOOLS (MICRO UTILITIES)
// -----------------------------------------------------------------------------
class QuickToolsTab extends StatefulWidget {
  const QuickToolsTab({super.key});

  @override
  State<QuickToolsTab> createState() => _QuickToolsTabState();
}

class _QuickToolsTabState extends State<QuickToolsTab> {
  // Micro Calc
  String _calcResult = '0';
  String _calcInput = '';

  // Quick Currency / Rate Converter
  final TextEditingController _amountController = TextEditingController(text: '100');
  double _convertedUsdToEur = 92.5;

  // Text Case Converter
  final TextEditingController _textTransformerController = TextEditingController();
  String _transformedText = '';

  @override
  void dispose() {
    _amountController.dispose();
    _textTransformerController.dispose();
    super.dispose();
  }

  void _onCalcPress(String val) {
    setState(() {
      if (val == 'C') {
        _calcInput = '';
        _calcResult = '0';
      } else if (val == '=') {
        try {
          // Simple evaluation simulation for utility numbers
          if (_calcInput.contains('+')) {
            final parts = _calcInput.split('+');
            double res = double.parse(parts[0]) + double.parse(parts[1]);
            _calcResult = res.toString();
          } else if (_calcInput.contains('-')) {
            final parts = _calcInput.split('-');
            double res = double.parse(parts[0]) - double.parse(parts[1]);
            _calcResult = res.toString();
          } else if (_calcInput.contains('*')) {
            final parts = _calcInput.split('*');
            double res = double.parse(parts[0]) * double.parse(parts[1]);
            _calcResult = res.toString();
          } else {
            _calcResult = _calcInput;
          }
        } catch (e) {
          _calcResult = 'Error';
        }
      } else {
        _calcInput += val;
      }
    });
  }

  void _convertCurrency() {
    double amt = double.tryParse(_amountController.text) ?? 0.0;
    setState(() {
      _convertedUsdToEur = amt * 0.925;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildQuickCalcWidget(),
          const SizedBox(height: 16),
          _buildTextTransformerWidget(),
          const SizedBox(height: 16),
          _buildQuickConverterWidget(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade800,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Context Utility Tools',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Micro tools designed to open in floating mini-windows over your active apps.',
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCalcWidget() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Floating Micro-Calculator',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _calcInput.isEmpty ? '0' : _calcInput,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _calcResult,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['7', '8', '9', '+', '4', '5', '6', '-', '1', '2', '3', '*', 'C', '0', '='].map((btn) {
                return SizedBox(
                  width: 55,
                  height: 42,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: btn == '=' ? Colors.indigo : Colors.grey.shade200,
                      foregroundColor: btn == '=' ? Colors.white : Colors.black,
                    ),
                    onPressed: () => _onCalcPress(btn),
                    child: Text(btn, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextTransformerWidget() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Text Case & Format Transformer',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _textTransformerController,
              decoration: const InputDecoration(
                hintText: 'Type or paste text to transform...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _transformedText = _textTransformerController.text.toUpperCase();
                    });
                  },
                  child: const Text('UPPERCASE'),
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _transformedText = _textTransformerController.text.toLowerCase();
                    });
                  },
                  child: const Text('lowercase'),
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _transformedText = _textTransformerController.text
                          .replaceAll(' ', '_')
                          .toLowerCase();
                    });
                  },
                  child: const Text('snake_case'),
                ),
              ],
            ),
            if (_transformedText.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  _transformedText,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickConverterWidget() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Instant Currency Micro-Converter',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount (\$) USD',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _convertCurrency,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  child: const Text('Convert'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Estimated EUR (€):', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    '€${_convertedUsdToEur.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}