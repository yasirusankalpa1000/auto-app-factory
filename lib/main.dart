import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const OverlayGuardApp());
}

class OverlayGuardApp extends StatelessWidget {
  const OverlayGuardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlayGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const MainHomeScreen(),
    );
  }
}

class SnippetItem {
  final String id;
  final String title;
  final String content;
  final String category;
  bool isFavorite;

  SnippetItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.isFavorite = false,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;

  // Floating Overlay State
  bool _isOverlayEnabled = true;
  bool _isNotificationBannerEnabled = true;
  bool _isAccessibilityEnabled = true;
  Offset _bubblePosition = const Offset(20, 220);
  bool _isFloatingMenuOpen = false;
  String? _activeNotificationText;

  // Anti-Peep Mask Settings
  bool _isPrivacyMaskActive = true;
  double _maskOpacity = 0.65;
  double _maskSlitHeight = 110.0;
  Color _selectedMaskColor = Colors.black;

  // Snippet Stash Data
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: '1',
      title: 'Work Email Signature',
      content: 'Best regards,\nAlex Mercer\nLead Product Architect | TechCorp',
      category: 'Work',
      isFavorite: true,
    ),
    SnippetItem(
      id: '2',
      title: 'Quick Bus Response',
      content: 'On the way home now! Will reach in about 15 minutes.',
      category: 'Quick Replies',
    ),
    SnippetItem(
      id: '3',
      title: 'Portfolio Link Template',
      content: 'Check out my latest portfolio and case studies at https://alexmercer.dev',
      category: 'Links',
      isFavorite: true,
    ),
    SnippetItem(
      id: '4',
      title: 'WiFi Access Info',
      content: 'SSID: Guest_HQ_5G\nPass: Secur3P@ssw0rd\$2025',
      category: 'Quick Replies',
    ),
  ];

  String _selectedCategory = 'All';
  String _searchQuery = '';

  // Ambient Reader Audio Visualizer State
  bool _isPlayingAmbient = false;
  String _selectedAmbientTrack = 'Gentle Rain';
  double _ambientVolume = 0.7;
  Timer? _soundTimer;
  List<double> _waveformHeights = [0.3, 0.7, 0.4, 0.9, 0.5, 0.8, 0.2, 0.6];

  @override
  void initState() {
    super.initState();
    _startWaveformAnimation();
  }

  @override
  void dispose() {
    _soundTimer?.cancel();
    super.dispose();
  }

  void _startWaveformAnimation() {
    _soundTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (_isPlayingAmbient && mounted) {
        setState(() {
          _waveformHeights = List.generate(
            8,
            (index) => (0.2 + (0.8 * ((index + timer.tick) % 5) / 5.0)),
          );
        });
      }
    });
  }

  void _showNotification(String message) {
    if (!_isNotificationBannerEnabled) return;
    setState(() {
      _activeNotificationText = message;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _activeNotificationText = null;
        });
      }
    });
  }

  void _addNewSnippet(String title, String content, String category) {
    setState(() {
      _snippets.insert(
        0,
        SnippetItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title.isEmpty ? 'Untitled Snippet' : title,
          content: content,
          category: category,
        ),
      );
    });
    _showNotification('Saved new snippet: $title');
  }

  void _cleanTextSnippet(SnippetItem item, String action) {
    String updated = item.content;
    if (action == 'lowercase') {
      updated = item.content.toLowerCase();
    } else if (action == 'single_line') {
      updated = item.content.replaceAll('\n', ' ');
    } else if (action == 'strip_urls') {
      updated = item.content.replaceAll(RegExp(r'https?://\S+'), '[URL]');
    }

    setState(() {
      final index = _snippets.indexWhere((element) => element.id == item.id);
      if (index != -1) {
        _snippets[index] = SnippetItem(
          id: item.id,
          title: item.title,
          content: updated,
          category: item.category,
          isFavorite: item.isFavorite,
        );
      }
    });
    _showNotification('Text formatted successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Body Navigation Tabs
            Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: _buildBodyTabContent(),
                ),
              ],
            ),

            // Anti-Peep Simulated Screen Overlay
            if (_isPrivacyMaskActive) _buildPrivacyMaskOverlay(),

            // Interactive Floating Bubble Overlay
            if (_isOverlayEnabled) _buildDraggableFloatingBubble(),

            // Simulated Floating Banner Notification
            if (_activeNotificationText != null) _buildTopNotificationBanner(),

            // Floating Quick HUD Modal Menu
            if (_isFloatingMenuOpen) _buildFloatingQuickMenu(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // --- TOP BAR ---
  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Icon(Icons.security, color: Colors.indigo, size: 22.0),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'OverlayGuard',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _isOverlayEnabled ? 'Overlay Active' : 'Overlay Disabled',
                  style: TextStyle(
                    color: _isOverlayEnabled ? Colors.green : Colors.grey,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _isPrivacyMaskActive ? Icons.visibility_off : Icons.visibility,
              color: _isPrivacyMaskActive ? Colors.amber : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isPrivacyMaskActive = !_isPrivacyMaskActive;
              });
              _showNotification(
                _isPrivacyMaskActive ? 'Privacy Guard Engaged' : 'Privacy Guard Off',
              );
            },
            tooltip: 'Toggle Anti-Peep Mask',
          ),
          IconButton(
            icon: Icon(
              _isOverlayEnabled ? Icons.layers : Icons.layers_clear,
              color: _isOverlayEnabled ? Colors.teal : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isOverlayEnabled = !_isOverlayEnabled;
              });
            },
            tooltip: 'Toggle Floating Bubble',
          ),
        ],
      ),
    );
  }

  // --- NAVIGATION TAB ROUTER ---
  Widget _buildBodyTabContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildAntiPeepTab();
      case 1:
        return _buildSnippetStashTab();
      case 2:
        return _buildAmbientReaderTab();
      case 3:
        return _buildSystemPermissionsTab();
      default:
        return _buildAntiPeepTab();
    }
  }

  // --- TAB 1: ANTI-PEEP & PRIVACY MASK CONTROL ---
  Widget _buildAntiPeepTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Public Anti-Peep Screen Shield', Icons.security),
          const SizedBox(height: 8.0),
          const Text(
            'Protects sensitive messages and documents from onlookers on public buses, trains, or open office spaces.',
            style: TextStyle(color: Colors.grey, fontSize: 13.0),
            softWrap: true,
          ),
          const SizedBox(height: 16.0),

          // Interactive Simulation Preview Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: Colors.indigo.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.touch_app, color: Colors.indigo, size: 20.0),
                    const SizedBox(width: 8.0),
                    const Expanded(
                      child: Text(
                        'Live Public Transit Reading Demo',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                        softWrap: true,
                      ),
                    ),
                    Switch(
                      value: _isPrivacyMaskActive,
                      activeColor: Colors.amber,
                      onChanged: (val) {
                        setState(() {
                          _isPrivacyMaskActive = val;
                        });
                      },
                    )
                  ],
                ),
                const Divider(color: Colors.grey, height: 20.0),
                const Text(
                  'Confidential Bank Message:',
                  style: TextStyle(color: Colors.amber, fontSize: 12.0, fontWeight: FontWeight.bold),
                  softWrap: true,
                ),
                const SizedBox(height: 6.0),
                const Text(
                  'Your OTP for transaction of \$1,250.00 to Account #8839 is 492-019. Do not share with anyone.',
                  style: TextStyle(color: Colors.white70, fontSize: 14.0),
                  softWrap: true,
                ),
                const SizedBox(height: 12.0),
                const Text(
                  'Private Chat Thread:',
                  style: TextStyle(color: Colors.teal, fontSize: 12.0, fontWeight: FontWeight.bold),
                  softWrap: true,
                ),
                const SizedBox(height: 6.0),
                const Text(
                  'Hey! Let us finalize the launch budget of \$45,000 for the new product design. Meet at 4 PM.',
                  style: TextStyle(color: Colors.white70, fontSize: 14.0),
                  softWrap: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20.0),
          _buildSectionHeader('Mask Controls', Icons.tune),
          const SizedBox(height: 12.0),

          // Opacity Slider
          Text(
            'Mask Opacity: ${(_maskOpacity * 100).toInt()}%',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            softWrap: true,
          ),
          Slider(
            value: _maskOpacity,
            min: 0.1,
            max: 0.95,
            activeColor: Colors.amber,
            onChanged: (val) {
              setState(() {
                _maskOpacity = val;
              });
            },
          ),

          // Slit Window Height Slider
          Text(
            'Reading Window Height: ${_maskSlitHeight.toInt()} px',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            softWrap: true,
          ),
          Slider(
            value: _maskSlitHeight,
            min: 60.0,
            max: 250.0,
            activeColor: Colors.indigo,
            onChanged: (val) {
              setState(() {
                _maskSlitHeight = val;
              });
            },
          ),

          const SizedBox(height: 12.0),
          const Text(
            'Shield Tint Color',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            softWrap: true,
          ),
          const SizedBox(height: 10.0),
          Wrap(
            spacing: 12.0,
            runSpacing: 10.0,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              _buildColorChoiceChip('Stealth Black', Colors.black),
              _buildColorChoiceChip('Deep Midnight', Colors.indigo),
              _buildColorChoiceChip('Night Amber', Colors.amber),
              _buildColorChoiceChip('Forest Grey', Colors.blueGrey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorChoiceChip(String label, Color color) {
    final bool isSelected = _selectedMaskColor == color;
    return ChoiceChip(
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12.0)),
      selected: isSelected,
      selectedColor: Colors.indigo,
      backgroundColor: Colors.grey.withOpacity(0.2),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedMaskColor = color;
          });
        }
      },
    );
  }

  // --- TAB 2: MULTI-CLIPBOARD SNIPPET STASH ---
  Widget _buildSnippetStashTab() {
    final filteredSnippets = _snippets.where((item) {
      final matchesCategory =
          _selectedCategory == 'All' || item.category == _selectedCategory;
      final matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.content.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader('Smart Snippet Stash', Icons.content_paste),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _showAddSnippetBottomSheet(context),
                    icon: const Icon(Icons.add, size: 18.0),
                    label: const Text('Add Snippet'),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),

              // Search Bar
              TextField(
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search stored snippets...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12.0),

              // Category Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Work', 'Quick Replies', 'Links'].map((cat) {
                    final bool isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(cat, style: const TextStyle(color: Colors.white)),
                        selected: isSelected,
                        selectedColor: Colors.indigo,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        onSelected: (val) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // Snippet List
        Expanded(
          child: filteredSnippets.isEmpty
              ? const Center(
                  child: Text(
                    'No snippets found. Add one above!',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: filteredSnippets.length,
                  itemBuilder: (context, index) {
                    final item = filteredSnippets[index];
                    return Card(
                      color: Colors.blueGrey.withOpacity(0.12),
                      margin: const EdgeInsets.only(bottom: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(
                          color: item.isFavorite
                              ? Colors.amber.withOpacity(0.5)
                              : Colors.transparent,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: Colors.indigo.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: Text(
                                    item.category,
                                    style: const TextStyle(
                                        color: Colors.indigoAccent, fontSize: 11.0),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    item.isFavorite
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: item.isFavorite
                                        ? Colors.amber
                                        : Colors.grey,
                                    size: 20.0,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      item.isFavorite = !item.isFavorite;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 6.0),
                            Text(
                              item.content,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13.0),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                            const Divider(color: Colors.grey, height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.build,
                                      color: Colors.teal, size: 18.0),
                                  tooltip: 'Clean / Format Text',
                                  onSelected: (val) =>
                                      _cleanTextSnippet(item, val),
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'lowercase',
                                      child: Text('Convert to Lowercase'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'single_line',
                                      child: Text('Remove Line Breaks'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'strip_urls',
                                      child: Text('Hide URLs'),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent, size: 18.0),
                                  onPressed: () {
                                    setState(() {
                                      _snippets.removeWhere(
                                          (e) => e.id == item.id);
                                    });
                                    _showNotification('Snippet deleted');
                                  },
                                ),
                                const SizedBox(width: 8.0),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 6.0),
                                  ),
                                  onPressed: () {
                                    _showNotification(
                                        'Copied to Clipboard: "${item.title}"');
                                  },
                                  icon: const Icon(Icons.content_copy,
                                      size: 16.0),
                                  label: const Text('Copy',
                                      style: TextStyle(fontSize: 12.0)),
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
    );
  }

  void _showAddSnippetBottomSheet(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String category = 'Work';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20.0,
            left: 20.0,
            right: 20.0,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Quick Snippet',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                  softWrap: true,
                ),
                const SizedBox(height: 12.0),
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Snippet Title',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12.0),
                TextField(
                  controller: contentController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Content / Response Text',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12.0),
                StatefulBuilder(
                  builder: (context, setModalState) {
                    return Row(
                      children: [
                        const Text('Category: ',
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(width: 10.0),
                        DropdownButton<String>(
                          value: category,
                          dropdownColor: Colors.black,
                          style: const TextStyle(color: Colors.amber),
                          items: ['Work', 'Quick Replies', 'Links']
                              .map((c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                category = val;
                              });
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.all(14.0),
                    ),
                    onPressed: () {
                      if (contentController.text.isNotEmpty) {
                        _addNewSnippet(
                          titleController.text,
                          contentController.text,
                          category,
                        );
                        Navigator.pop(ctx);
                      }
                    },
                    child: const Text('Save Snippet',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- TAB 3: AMBIENT READER & EYE PROTECTOR ---
  Widget _buildAmbientReaderTab() {
    final tracks = ['Gentle Rain', 'Ocean Waves', 'Night Cafe', 'Deep Forest', 'White Noise'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Ambient Reading Helper & Audio', Icons.volume_up),
          const SizedBox(height: 8.0),
          const Text(
            'Keep user focused during extended reading or working routines with soothing soundscapes.',
            style: TextStyle(color: Colors.grey, fontSize: 13.0),
            softWrap: true,
          ),
          const SizedBox(height: 20.0),

          // Player Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.withOpacity(0.4), Colors.purple.withOpacity(0.2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.indigo.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                Icon(
                  _isPlayingAmbient ? Icons.graphic_eq : Icons.music_note,
                  color: _isPlayingAmbient ? Colors.amber : Colors.white,
                  size: 40.0,
                ),
                const SizedBox(height: 10.0),
                Text(
                  _selectedAmbientTrack,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                  softWrap: true,
                ),
                const SizedBox(height: 4.0),
                Text(
                  _isPlayingAmbient ? 'Playing Ambient Noise' : 'Paused',
                  style: TextStyle(
                    color: _isPlayingAmbient ? Colors.green : Colors.grey,
                    fontSize: 12.0,
                  ),
                  softWrap: true,
                ),
                const SizedBox(height: 16.0),

                // Animated Sound Wavebar Simulation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _waveformHeights.map((h) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3.0),
                      width: 6.0,
                      height: _isPlayingAmbient ? (h * 40.0) + 6.0 : 6.0,
                      decoration: BoxDecoration(
                        color: _isPlayingAmbient ? Colors.amber : Colors.grey,
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      onPressed: () {
                        setState(() {
                          _isPlayingAmbient = !_isPlayingAmbient;
                        });
                        _showNotification(
                          _isPlayingAmbient
                              ? 'Started Audio: $_selectedAmbientTrack'
                              : 'Audio Paused',
                        );
                      },
                      child: Icon(_isPlayingAmbient ? Icons.pause : Icons.play_arrow),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    const Icon(Icons.volume_down, color: Colors.grey),
                    Expanded(
                      child: Slider(
                        value: _ambientVolume,
                        min: 0.0,
                        max: 1.0,
                        activeColor: Colors.amber,
                        onChanged: (val) {
                          setState(() {
                            _ambientVolume = val;
                          });
                        },
                      ),
                    ),
                    const Icon(Icons.volume_up, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20.0),
          const Text(
            'Select Soundscape Track',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            softWrap: true,
          ),
          const SizedBox(height: 10.0),

          Column(
            children: tracks.map((track) {
              final isSelected = _selectedAmbientTrack == track;
              return Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.indigo.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  title: Text(
                    track,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.amber)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedAmbientTrack = track;
                    });
                    _showNotification('Track changed to $track');
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: SYSTEM OVERLAY & PERMISSIONS HUD ---
  Widget _buildSystemPermissionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('System Overlay & Permission HUD', Icons.settings),
          const SizedBox(height: 8.0),
          const Text(
            'Configure real-time device permissions to allow OverlayGuard to float over other apps.',
            style: TextStyle(color: Colors.grey, fontSize: 13.0),
            softWrap: true,
          ),
          const SizedBox(height: 20.0),

          _buildPermissionToggleTile(
            title: 'Display Over Other Apps',
            subtitle: 'Allows the floating bubble & anti-peep shield to hover above active applications.',
            value: _isOverlayEnabled,
            icon: Icons.layers,
            onChanged: (val) {
              setState(() {
                _isOverlayEnabled = val;
              });
              _showNotification('Display Overlay Permission updated');
            },
          ),
          const SizedBox(height: 12.0),

          _buildPermissionToggleTile(
            title: 'Floating Notification Banners',
            subtitle: 'Shows subtle interactive top alerts for instant feedback.',
            value: _isNotificationBannerEnabled,
            icon: Icons.notifications_active,
            onChanged: (val) {
              setState(() {
                _isNotificationBannerEnabled = val;
              });
            },
          ),
          const SizedBox(height: 12.0),

          _buildPermissionToggleTile(
            title: 'Accessibility Shortcut Service',
            subtitle: 'Enables high-performance low-latency screen dimming.',
            value: _isAccessibilityEnabled,
            icon: Icons.accessibility,
            onChanged: (val) {
              setState(() {
                _isAccessibilityEnabled = val;
              });
            },
          ),

          const SizedBox(height: 24.0),
          _buildSectionHeader('Usage Tips & Daily Value', Icons.lightbulb),
          const SizedBox(height: 12.0),

          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.indigo.withOpacity(0.2)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• Commuting Mode:',
                  style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                  softWrap: true,
                ),
                Text(
                  'Drag the anti-peep mask over sensitive chat fields while riding public buses or trains.',
                  style: TextStyle(color: Colors.white70, fontSize: 12.0),
                  softWrap: true,
                ),
                SizedBox(height: 8.0),
                Text(
                  '• Multi-Copy Vault:',
                  style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                  softWrap: true,
                ),
                Text(
                  'Save standard work emails, signatures, and quick responses to paste instantly anywhere.',
                  style: TextStyle(color: Colors.white70, fontSize: 12.0),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionToggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: value ? Colors.indigo : Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Icon(icon, color: Colors.white, size: 20.0),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.0),
                  softWrap: true,
                ),
                const SizedBox(height: 4.0),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 11.0),
                  softWrap: true,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: Colors.teal,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // --- FLOATING OVERLAY COMPONENTS ---

  // 1. Draggable Floating Bubble Button
  Widget _buildDraggableFloatingBubble() {
    return Positioned(
      left: _bubblePosition.dx,
      top: _bubblePosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubblePosition += details.delta;
          });
        },
        onTap: () {
          setState(() {
            _isFloatingMenuOpen = !_isFloatingMenuOpen;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: _isPrivacyMaskActive ? Colors.amber : Colors.indigo,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: Icon(
            _isPrivacyMaskActive ? Icons.security : Icons.apps,
            color: Colors.black,
            size: 26.0,
          ),
        ),
      ),
    );
  }

  // 2. Simulated Anti-Peep Shield Mask Overlay Widget
  Widget _buildPrivacyMaskOverlay() {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: Stack(
          children: [
            // Dark Tint Top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 180.0,
              child: Container(
                color: _selectedMaskColor.withOpacity(_maskOpacity),
              ),
            ),
            // Middle Slit Clear View Window
            Positioned(
              top: 180.0,
              left: 0,
              right: 0,
              height: _maskSlitHeight,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: Colors.amber.withOpacity(0.8),
                      width: 2.0,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      color: Colors.black.withOpacity(0.6),
                      child: const Text(
                        'PEEP SHIELD ACTIVE',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 9.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Dark Tint Bottom
            Positioned(
              top: 180.0 + _maskSlitHeight,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: _selectedMaskColor.withOpacity(_maskOpacity),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Simulated Top Notification Banner Widget
  Widget _buildTopNotificationBanner() {
    return Positioned(
      top: 10.0,
      left: 20.0,
      right: 20.0,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 10.0,
              )
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.notifications_active, color: Colors.amber, size: 20.0),
              const SizedBox(width: 10.0),
              Expanded(
                child: Text(
                  _activeNotificationText!,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13.0),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 4. Floating Quick Control HUD Menu Modal Card
  Widget _buildFloatingQuickMenu() {
    return Positioned(
      left: 20.0,
      right: 20.0,
      bottom: 80.0,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: Colors.amber.withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.8),
                blurRadius: 16.0,
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
                    'Floating QuickHUD Tools',
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                    softWrap: true,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _isFloatingMenuOpen = false;
                      });
                    },
                  ),
                ],
              ),
              const Divider(color: Colors.grey),
              const SizedBox(height: 6.0),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                crossAxisAlignment: WrapCrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isPrivacyMaskActive ? Colors.amber : Colors.grey[800],
                      foregroundColor:
                          _isPrivacyMaskActive ? Colors.black : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPrivacyMaskActive = !_isPrivacyMaskActive;
                      });
                    },
                    icon: const Icon(Icons.security, size: 16.0),
                    label: const Text('Peep Shield'),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isPlayingAmbient ? Colors.teal : Colors.grey[800],
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPlayingAmbient = !_isPlayingAmbient;
                      });
                    },
                    icon: const Icon(Icons.volume_up, size: 16.0),
                    label: const Text('Ambient Audio'),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (_snippets.isNotEmpty) {
                        _showNotification(
                          'Quick Copied: ${_snippets.first.title}',
                        );
                      }
                      setState(() {
                        _isFloatingMenuOpen = false;
                      });
                    },
                    icon: const Icon(Icons.content_copy, size: 16.0),
                    label: const Text('Copy Top Clip'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- BOTTOM NAVIGATION ---
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      selectedItemColor: Colors.amber,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.security),
          label: 'Anti-Peep',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.content_paste),
          label: 'Snippets',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.volume_up),
          label: 'Ambient',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'System HUD',
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo, size: 20.0),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}