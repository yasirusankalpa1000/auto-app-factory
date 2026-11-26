import 'package:flutter/material.dart';

void main() {
  runApp(const BubbleLensApp());
}

class BubbleLensApp extends StatefulWidget {
  const BubbleLensApp({super.key});

  @override
  State<BubbleLensApp> createState() => _BubbleLensAppState();
}

class _BubbleLensAppState extends State<BubbleLensApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  Color _hudColor = Colors.indigo;

  void _changeHudColor(Color color) {
    setState(() {
      _hudColor = color;
    });
  }

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BubbleLens HUD',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: _hudColor,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: _hudColor,
        scaffoldBackgroundColor: const Color(0xFF12141D),
      ),
      home: MainHUDHomeScreen(
        currentHudColor: _hudColor,
        onColorChanged: _changeHudColor,
        onToggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

// Model classes
class SnippetItem {
  final String id;
  String title;
  String content;
  String category;
  Color badgeColor;
  bool isPinned;
  DateTime timestamp;

  SnippetItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.badgeColor,
    this.isPinned = false,
    required this.timestamp,
  });
}

class SoundTrack {
  final String title;
  final String category;
  final IconData icon;
  bool isPlaying;

  SoundTrack({
    required this.title,
    required this.category,
    required this.icon,
    this.isPlaying = false,
  });
}

class MainHUDHomeScreen extends StatefulWidget {
  final Color currentHudColor;
  final ValueChanged<Color> onColorChanged;
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const MainHUDHomeScreen({
    super.key,
    required this.currentHudColor,
    required this.onColorChanged,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<MainHUDHomeScreen> createState() => _MainHUDHomeScreenState();
}

class _MainHUDHomeScreenState extends State<MainHUDHomeScreen> {
  int _currentTab = 0;

  // Floating Overlay State Simulation
  Offset _bubblePosition = const Offset(280, 220);
  bool _isBubbleExpanded = false;
  bool _overlayPermissionGranted = true;
  bool _notificationPermissionGranted = true;
  double _bubbleOpacity = 0.9;
  double _bubbleSize = 58.0;

  // Notification simulation popup
  String? _floatingNotificationText;

  // Sample Snippets / Quick Notes Stash
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: '1',
      title: 'Price Comparison - Laptop',
      content: 'Store A: \$899 | Store B: \$849 with coupon code SAVE50',
      category: 'Shopping',
      badgeColor: Colors.blue,
      isPinned: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    SnippetItem(
      id: '2',
      title: 'Research Paper Highlight',
      content:
          'Neural screen parsing reduces context-switching delay by up to 64%.',
      category: 'Study',
      badgeColor: Colors.purple,
      isPinned: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    SnippetItem(
      id: '3',
      title: 'Quick Verification Code',
      content: 'OTP: 849201 - Expires in 10 minutes',
      category: 'Security',
      badgeColor: Colors.amber,
      isPinned: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  // Soundscape Tracks
  final List<SoundTrack> _soundTracks = [
    SoundTrack(
        title: 'Deep Focus Rain',
        category: 'Atmosphere',
        icon: Icons.water_drop),
    SoundTrack(
        title: 'Lo-Fi Night Vibes',
        category: 'Relax',
        icon: Icons.music_note),
    SoundTrack(
        title: 'Cyber Cafe Ambience',
        category: 'Work',
        icon: Icons.local_cafe),
    SoundTrack(
        title: 'Forest Wind & Birds',
        category: 'Nature',
        icon: Icons.park),
  ];

  double _ambientVolume = 0.7;

  // Add Snippet Dialog
  void _openAddSnippetDialog({SnippetItem? existingItem}) {
    final titleController =
        TextEditingController(text: existingItem?.title ?? '');
    final contentController =
        TextEditingController(text: existingItem?.content ?? '');
    String category = existingItem?.category ?? 'General';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existingItem == null
            ? 'Add Floating Snippet'
            : 'Edit Snippet'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Snippet Label',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Text Content / Snippet',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: category,
                items: ['General', 'Shopping', 'Study', 'Security', 'Work']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) category = val;
                },
                decoration: const InputDecoration(
                  labelText: 'Category Tag',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (contentController.text.trim().isEmpty) return;
              setState(() {
                if (existingItem != null) {
                  existingItem.title = titleController.text.isEmpty
                      ? 'Quick Note'
                      : titleController.text;
                  existingItem.content = contentController.text;
                  existingItem.category = category;
                } else {
                  _snippets.insert(
                    0,
                    SnippetItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text.isEmpty
                          ? 'Quick Snippet'
                          : titleController.text,
                      content: contentController.text,
                      category: category,
                      badgeColor: category == 'Shopping'
                          ? Colors.blue
                          : category == 'Study'
                              ? Colors.purple
                              : category == 'Security'
                                  ? Colors.amber
                                  : Colors.teal,
                      timestamp: DateTime.now(),
                    ),
                  );
                }
              });
              Navigator.pop(ctx);
              _triggerFloatingNotification('Snippet saved to Lens Vault');
            },
            child: const Text('Save Snippet'),
          ),
        ],
      ),
    );
  }

  void _triggerFloatingNotification(String message) {
    setState(() {
      _floatingNotificationText = message;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _floatingNotificationText = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: IndexedStack(
                    index: _currentTab,
                    children: [
                      _buildOverlayStudioTab(),
                      _buildSnippetStashTab(),
                      _buildSoundscapeTab(),
                      _buildSettingsTab(),
                    ],
                  ),
                ),
              ],
            ),

            // Interactive Simulated Floating Bubble HUD Overlay
            if (_overlayPermissionGranted) _buildInteractiveFloatingBubble(),

            // Interactive Floating Notification HUD Banner
            if (_floatingNotificationText != null)
              _buildFloatingNotificationBanner(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTab,
        onDestinationSelected: (idx) {
          setState(() {
            _currentTab = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.layers),
            selectedIcon: Icon(Icons.layers),
            label: 'HUD Studio',
          ),
          NavigationDestination(
            icon: Icon(Icons.copy),
            selectedIcon: Icon(Icons.copy),
            label: 'Snippets',
          ),
          NavigationDestination(
            icon: Icon(Icons.volume_up),
            selectedIcon: Icon(Icons.volume_up),
            label: 'Ambience',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune),
            selectedIcon: Icon(Icons.tune),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.currentHudColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.widgets,
              color: widget.currentHudColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BubbleLens HUD',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _overlayPermissionGranted
                      ? 'HUD Bubble Active on Screen'
                      : 'HUD Overlay Disabled',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _overlayPermissionGranted
                            ? Colors.green
                            : Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            tooltip: 'Toggle Theme',
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_active),
            tooltip: 'Test Floating Banner',
            onPressed: () {
              _triggerFloatingNotification(
                  'Quick HUD Alert: Lens captured 1 new clipboard text!');
            },
          ),
        ],
      ),
    );
  }

  // TAB 1: HUD OVERLAY STUDIO (Interactive Playground & Bubble Control)
  Widget _buildOverlayStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBannerCard(),
          const SizedBox(height: 16),
          Text(
            'Live Floating Bubble Controls',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Display Over Apps Permission'),
                    subtitle: const Text(
                        'Allows floating HUD bubble to stay above web browser, shopping apps & chats.'),
                    value: _overlayPermissionGranted,
                    activeColor: widget.currentHudColor,
                    onChanged: (val) {
                      setState(() {
                        _overlayPermissionGranted = val;
                      });
                      _triggerFloatingNotification(val
                          ? 'Floating HUD Overlay Enabled'
                          : 'Floating HUD Overlay Disabled');
                    },
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Text('Bubble Opacity'),
                      Expanded(
                        child: Slider(
                          value: _bubbleOpacity,
                          min: 0.3,
                          max: 1.0,
                          activeColor: widget.currentHudColor,
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
                  Row(
                    children: [
                      const Text('Bubble Size'),
                      Expanded(
                        child: Slider(
                          value: _bubbleSize,
                          min: 44.0,
                          max: 76.0,
                          activeColor: widget.currentHudColor,
                          onChanged: (val) {
                            setState(() {
                              _bubbleSize = val;
                            });
                          },
                        ),
                      ),
                      Text('${_bubbleSize.toInt()}px'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'HUD Theme Palette Accent',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildColorChip('Indigo Night', Colors.indigo),
                _buildColorChip('Cyber Teal', Colors.teal),
                _buildColorChip('Sunset Amber', Colors.orange),
                _buildColorChip('Deep Purple', Colors.purple),
                _buildColorChip('Emerald Mint', Colors.green),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Quick Pinned Floating Notes',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _snippets.where((s) => s.isPinned).length,
            itemBuilder: (context, index) {
              final pinnedList = _snippets.where((s) => s.isPinned).toList();
              final item = pinnedList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: item.badgeColor.withOpacity(0.2),
                    child: Icon(Icons.push_pin,
                        color: item.badgeColor, size: 20),
                  ),
                  title: Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    item.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: () {
                      _triggerFloatingNotification(
                          'Copied "${item.title}" to clipboard');
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.currentHudColor,
            widget.currentHudColor.withOpacity(0.7),
          ],
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.touch_app, color: Colors.white),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Interactive Floating Bubble HUD',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Drag the floating bubble anywhere on your screen! Tap it to open instant micro-notes, live ambient audio controls, and screen snippet captures while using other apps.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
            softWrap: true,
          ),
        ],
      ),
    );
  }

  Widget _buildColorChip(String label, Color color) {
    final isSelected = widget.currentHudColor.value == color.value;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: color.withOpacity(0.25),
        avatar: CircleAvatar(backgroundColor: color),
        onSelected: (selected) {
          if (selected) {
            widget.onColorChanged(color);
          }
        },
      ),
    );
  }

  // TAB 2: SNIPPETS & CLIPBOARD VAULT
  Widget _buildSnippetStashTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search snippets...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () => _openAddSnippetDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _snippets.isEmpty
                ? const Center(child: Text('No saved snippets yet.'))
                : ListView.builder(
                    itemCount: _snippets.length,
                    itemBuilder: (context, index) {
                      final snippet = _snippets[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Chip(
                                    label: Text(
                                      snippet.category,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: snippet.badgeColor,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: Icon(
                                      snippet.isPinned
                                          ? Icons.push_pin
                                          : Icons.push_pin_outlined,
                                      color: snippet.isPinned
                                          ? widget.currentHudColor
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        snippet.isPinned = !snippet.isPinned;
                                      });
                                      _triggerFloatingNotification(
                                        snippet.isPinned
                                            ? 'Pinned to Floating HUD'
                                            : 'Unpinned from Floating HUD',
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 20),
                                    onPressed: () => _openAddSnippetDialog(
                                        existingItem: snippet),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        size: 20, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _snippets.removeAt(index);
                                      });
                                      _triggerFloatingNotification(
                                          'Snippet deleted');
                                    },
                                  ),
                                ],
                              ),
                              Text(
                                snippet.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 6),
                              SelectableText(
                                snippet.content,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withOpacity(0.85),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Saved ${snippet.timestamp.hour.toString().padLeft(2, '0')}:${snippet.timestamp.minute.toString().padLeft(2, '0')}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.grey),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      _triggerFloatingNotification(
                                          'Snippet copied to clipboard');
                                    },
                                    icon:
                                        const Icon(Icons.copy, size: 16),
                                    label: const Text('Copy Text'),
                                  ),
                                ],
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
    );
  }

  // TAB 3: AMBIENT FOCUS SOUNDSCAPE
  Widget _buildSoundscapeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: widget.currentHudColor.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.music_note,
                      size: 40, color: widget.currentHudColor),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Background Focus Soundscape',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          'Keep calm audio playing in background while using floating HUD tools over other apps.',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Master Volume Control',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Row(
            children: [
              const Icon(Icons.volume_down),
              Expanded(
                child: Slider(
                  value: _ambientVolume,
                  onChanged: (val) {
                    setState(() {
                      _ambientVolume = val;
                    });
                  },
                  activeColor: widget.currentHudColor,
                ),
              ),
              const Icon(Icons.volume_up),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Soundscape Channels',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _soundTracks.length,
            itemBuilder: (context, index) {
              final track = _soundTracks[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: track.isPlaying
                        ? widget.currentHudColor
                        : Colors.grey.withOpacity(0.2),
                    child: Icon(
                      track.icon,
                      color: track.isPlaying
                          ? Colors.white
                          : Theme.of(context).iconTheme.color,
                    ),
                  ),
                  title: Text(track.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(track.category),
                  trailing: IconButton(
                    icon: Icon(
                      track.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      size: 36,
                      color: widget.currentHudColor,
                    ),
                    onPressed: () {
                      setState(() {
                        track.isPlaying = !track.isPlaying;
                      });
                      _triggerFloatingNotification(track.isPlaying
                          ? 'Playing: ${track.title}'
                          : 'Paused: ${track.title}');
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // TAB 4: SETTINGS & PERMISSIONS
  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'App Permissions & System Integrations',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Display Over Other Apps'),
                  subtitle: const Text('Required for floating screen bubble HUD.'),
                  value: _overlayPermissionGranted,
                  onChanged: (val) {
                    setState(() {
                      _overlayPermissionGranted = val;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Smart Notification Listener'),
                  subtitle:
                      const Text('Allows auto-capturing OTPs & clipboard banners.'),
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
          Text(
            'Lens HUD Utility Features',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.cleaning_services),
                  title: const Text('Clear Floating Snippet Cache'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _triggerFloatingNotification('Snippet cache cleared');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share Lens HUD App'),
                  subtitle: const Text('Invite friends to reduce context switching!'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _triggerFloatingNotification('Sharing link copied');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About BubbleLens HUD'),
                  subtitle: const Text('Version 2.4.0 - Smart Screen Utility'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // FLOATING BUBBLE OVERLAY WIDGET SIMULATOR
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Expanded HUD Menu Popup
            if (_isBubbleExpanded)
              Container(
                width: 230,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: widget.currentHudColor.withOpacity(0.4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Lens Quick HUD',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isBubbleExpanded = false;
                            });
                          },
                          child: const Icon(Icons.close, size: 16),
                        ),
                      ],
                    ),
                    const Divider(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        ActionChip(
                          avatar: const Icon(Icons.add, size: 14),
                          label: const Text('Quick Note',
                              style: TextStyle(fontSize: 11)),
                          onPressed: () {
                            setState(() => _isBubbleExpanded = false);
                            _openAddSnippetDialog();
                          },
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.copy, size: 14),
                          label: const Text('Clip Vault',
                              style: TextStyle(fontSize: 11)),
                          onPressed: () {
                            setState(() {
                              _isBubbleExpanded = false;
                              _currentTab = 1;
                            });
                          },
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.volume_up, size: 14),
                          label: const Text('Soundscape',
                              style: TextStyle(fontSize: 11)),
                          onPressed: () {
                            setState(() {
                              _isBubbleExpanded = false;
                              _currentTab = 2;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: widget.currentHudColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.lightbulb, size: 14, color: Colors.amber),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Drag bubble anywhere on screen',
                              style: TextStyle(fontSize: 10),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Floating Bubble Sphere Button
            Opacity(
              opacity: _bubbleOpacity,
              child: FloatingActionButton.small(
                heroTag: 'floating_lens_bubble',
                backgroundColor: widget.currentHudColor,
                onPressed: () {
                  setState(() {
                    _isBubbleExpanded = !_isBubbleExpanded;
                  });
                },
                child: AnimatedRotation(
                  turns: _isBubbleExpanded ? 0.25 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    _isBubbleExpanded ? Icons.close : Icons.widgets,
                    color: Colors.white,
                    size: _bubbleSize * 0.45,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FLOATING HEADS-UP NOTIFICATION BANNER
  Widget _buildFloatingNotificationBanner() {
    return Positioned(
      top: 10,
      left: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: widget.currentHudColor.withOpacity(0.5), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: widget.currentHudColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.notifications_active,
                    color: widget.currentHudColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _floatingNotificationText ?? '',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () {
                  setState(() {
                    _floatingNotificationText = null;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}