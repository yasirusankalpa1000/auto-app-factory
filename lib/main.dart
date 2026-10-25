import 'package:flutter/material.dart';

void main() {
  runApp(const FloatDeckApp());
}

class FloatDeckApp extends StatelessWidget {
  const FloatDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatDeck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        cardColor: const Color(0xFF1E293B),
        useMaterial3: true,
      ),
      home: const MainDeckScreen(),
    );
  }
}

class MainDeckScreen extends StatefulWidget {
  const MainDeckScreen({super.key});

  @override
  State<MainDeckScreen> createState() => _MainDeckScreenState();
}

class _MainDeckScreenState extends State<MainDeckScreen> {
  int _currentTabIndex = 0;

  // Floating Bubble position & state
  Offset _bubblePosition = const Offset(20, 200);
  bool _isBubbleExpanded = false;
  bool _isOverlayActive = true;
  double _screenDimmerOpacity = 0.15;
  Color _screenFilterColor = Colors.orange;

  // ClipVault State
  final List<Map<String, dynamic>> _clips = [
    {
      'id': '1',
      'title': 'Office Wi-Fi Password',
      'content': 'SecureWiFi_2025!#Key',
      'tag': 'Work',
      'copies': 14,
    },
    {
      'id': '2',
      'title': 'Client Billing Address',
      'content': '742 Evergreen Terrace, Suite 400, NY 10001',
      'tag': 'Finance',
      'copies': 8,
    },
    {
      'id': '3',
      'title': 'Quick Email Signature',
      'content': 'Best regards,\nAlex Vance | Senior UX Designer\n+1 (555) 019-2831',
      'tag': 'Personal',
      'copies': 29,
    },
    {
      'id': '4',
      'title': 'Support Ticket Format',
      'content': '[BUG]: Brief summary\n[STEPS]: 1, 2, 3\n[EXPECTED]: Result',
      'tag': 'Work',
      'copies': 5,
    },
  ];

  String _searchQuery = '';
  String _selectedTagFilter = 'All';

  // Ambient Mixer state
  bool _isAudioPlaying = false;
  double _rainVolume = 0.6;
  double _cafeVolume = 0.3;
  double _forestVolume = 0.4;

  // Screen Ruler state
  double _rulerInches = 4.5;

  void _addClip(String title, String content, String tag) {
    setState(() {
      _clips.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': title,
        'content': content,
        'tag': tag,
        'copies': 0,
      });
    });
  }

  void _incrementCopy(String id) {
    setState(() {
      for (var clip in _clips) {
        if (clip['id'] == id) {
          clip['copies'] = (clip['copies'] as int) + 1;
          break;
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to dynamic floating clipboard!'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _deleteClip(String id) {
    setState(() {
      _clips.removeWhere((clip) => clip['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Screen Dimmer Overlay Simulator
          if (_isOverlayActive && _screenDimmerOpacity > 0.0)
            IgnorePointer(
              child: Container(
                width: screenSize.width,
                height: screenSize.height,
                color: _screenFilterColor.withOpacity(_screenDimmerOpacity),
              ),
            ),

          // Main Screen Navigation Body
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: IndexedStack(
                    index: _currentTabIndex,
                    children: [
                      _buildFloatingHubTab(screenSize),
                      _buildClipVaultTab(),
                      _buildScreenToolsTab(),
                      _buildAmbientTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Interactive Draggable Floating Bubble
          Positioned(
            left: _bubblePosition.dx,
            top: _bubblePosition.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  double newX = _bubblePosition.dx + details.delta.dx;
                  double newY = _bubblePosition.dy + details.delta.dy;
                  // Clamp bounds
                  newX = newX.clamp(10.0, screenSize.width - 70.0);
                  newY = newY.clamp(50.0, screenSize.height - 120.0);
                  _bubblePosition = Offset(newX, newY);
                });
              },
              child: _buildFloatingWidget(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) => setState(() => _currentTabIndex = index),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1E293B),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Floating HUD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy),
            label: 'ClipVault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.straighten),
            label: 'Screen Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volume_up),
            label: 'Ambient Deck',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: const Color(0xFF1E293B),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Icon(Icons.layers, color: Colors.tealAccent, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'FloatDeck Assist',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Live Context Floating Overlay Active',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _isOverlayActive ? Icons.visibility : Icons.visibility_off,
              color: _isOverlayActive ? Colors.tealAccent : Colors.grey,
            ),
            tooltip: 'Toggle Filter Overlay',
            onPressed: () {
              setState(() {
                _isOverlayActive = !_isOverlayActive;
              });
            },
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating Hub & Live Assistant
  Widget _buildFloatingHubTab(Size screenSize) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF312E81), Color(0xFF1E1B4B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: Colors.indigo.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.stars, color: Colors.amber, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Floating Buddy Dock Active',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          softWrap: true,
                        ),
                      ),
                      Switch(
                        value: _isOverlayActive,
                        activeColor: Colors.tealAccent,
                        onChanged: (val) => setState(() => _isOverlayActive = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Drag the glowing floating bubble anywhere on your screen. Tap it to expand live dynamic macros, screen ruler, or quick clipboard pastes.',
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Floating Customization Settings
            const Text(
              'Floating Buddy Controls',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),

            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Reset Floating Widget Position', style: TextStyle(color: Colors.white)),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _bubblePosition = const Offset(20, 200);
                            });
                          },
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('Reset'),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.grey),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Quick Sticky Floating Note', style: TextStyle(color: Colors.white)),
                        Chip(
                          label: const Text('Pinned'),
                          backgroundColor: Colors.teal.withOpacity(0.3),
                          labelStyle: const TextStyle(color: Colors.tealAccent, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quick Floating Macros List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Quick Dock Items',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text('Tap item to pin', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _clips.take(3).length,
              itemBuilder: (context, index) {
                final clip = _clips[index];
                return Card(
                  color: const Color(0xFF1E293B),
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.withOpacity(0.3),
                      child: Text(
                        clip['tag'][0],
                        style: const TextStyle(color: Colors.indigoAccent, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      clip['title'],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      clip['content'],
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.content_copy, color: Colors.tealAccent, size: 20),
                      onPressed: () => _incrementCopy(clip['id']),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: ClipVault (Multi-Clip Manager)
  Widget _buildClipVaultTab() {
    final filteredClips = _clips.where((clip) {
      final matchesSearch = clip['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          clip['content'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesTag = _selectedTagFilter == 'All' || clip['tag'] == _selectedTagFilter;
      return matchesSearch && matchesTag;
    }).toList();

    return SafeArea(
      child: Column(
        children: [
          // Search & Filter Header
          Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color(0xFF0F172A),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search saved clips...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.tealAccent),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Work', 'Finance', 'Personal'].map((tag) {
                      final isSelected = _selectedTagFilter == tag;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(tag),
                          selected: isSelected,
                          selectedColor: Colors.teal,
                          backgroundColor: const Color(0xFF1E293B),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedTagFilter = tag);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Clips List
          Expanded(
            child: filteredClips.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.content_copy, size: 48, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('No clips found in vault', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: filteredClips.length,
                    itemBuilder: (context, index) {
                      final clip = filteredClips[index];
                      return Card(
                        color: const Color(0xFF1E293B),
                        margin: const EdgeInsets.only(bottom: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      clip['tag'],
                                      style: const TextStyle(
                                        color: Colors.indigoAccent,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Used ${clip['copies']}x',
                                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                                      ),
                                      const SizedBox(width: 8),
                                      InkWell(
                                        onTap: () => _deleteClip(clip['id']),
                                        child: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                clip['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                softWrap: true,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F172A),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  clip['content'],
                                  style: const TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'monospace'),
                                  softWrap: true,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  onPressed: () => _incrementCopy(clip['id']),
                                  icon: const Icon(Icons.copy, size: 16),
                                  label: const Text('Quick Copy'),
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
    );
  }

  // FAB for ClipVault
  Widget _buildClipVaultFAB() {
    return FloatingActionButton(
      backgroundColor: Colors.teal,
      child: const Icon(Icons.add, color: Colors.white),
      onPressed: () {
        _showAddClipDialog();
      },
    );
  }

  void _showAddClipDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedTag = 'Work';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E293B),
              title: const Text('Add Snippet to ClipVault', style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: contentController,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Content / Text Snippet',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedTag,
                      dropdownColor: const Color(0xFF1E293B),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Tag Category',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                      items: ['Work', 'Finance', 'Personal', 'Code'].map((tag) {
                        return DropdownMenuItem(value: tag, child: Text(tag));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => selectedTag = val);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () {
                    if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                      _addClip(titleController.text, contentController.text, selectedTag);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Snippet', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // TAB 3: Screen Tools (Ruler, Dimmer & Hex Extractor)
  Widget _buildScreenToolsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Screen Dimmer & Light Filter',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Filter Warmth Intensity', style: TextStyle(color: Colors.white)),
                        Text('${(_screenDimmerOpacity * 100).round()}%',
                            style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                      value: _screenDimmerOpacity,
                      min: 0.0,
                      max: 0.6,
                      activeColor: Colors.tealAccent,
                      inactiveColor: Colors.grey,
                      onChanged: (val) {
                        setState(() => _screenDimmerOpacity = val);
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildColorToneButton('Warm Amber', Colors.orange),
                        _buildColorToneButton('Deep Red', Colors.red),
                        _buildColorToneButton('Soft Blue', Colors.blue),
                        _buildColorToneButton('Night Dark', Colors.black),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Interactive On-Screen Ruler',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),

            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Target Measure Length:', style: TextStyle(color: Colors.white)),
                        Text(
                          '${_rulerInches.toStringAsFixed(1)} Inches (${(_rulerInches * 2.54).toStringAsFixed(1)} cm)',
                          style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Slider(
                      value: _rulerInches,
                      min: 1.0,
                      max: 8.0,
                      activeColor: Colors.amber,
                      inactiveColor: Colors.grey,
                      onChanged: (val) => setState(() => _rulerInches = val),
                    ),
                    const SizedBox(height: 12),

                    // Visual Ruler Widget Representation
                    Container(
                      height: 70,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.15),
                        border: Border.all(color: Colors.amber),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: CustomPaint(
                        painter: RulerPainter(inches: _rulerInches),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Visual Color Hex Generator',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),

            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: _screenFilterColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          'Selected Hex: #${_screenFilterColor.value.toRadixString(16).substring(2).toUpperCase()}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A)),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Hex #${_screenFilterColor.value.toRadixString(16).substring(2).toUpperCase()} copied!'),
                                backgroundColor: Colors.indigo,
                              ),
                            );
                          },
                          icon: const Icon(Icons.copy, size: 16, color: Colors.tealAccent),
                          label: const Text('Copy Hex Code', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorToneButton(String label, Color color) {
    final bool isSelected = _screenFilterColor == color;
    return GestureDetector(
      onTap: () => setState(() => _screenFilterColor = color),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 18,
            child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? Colors.tealAccent : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // TAB 4: Ambient Deck (Sound Engine & Equalizer)
  Widget _buildAmbientTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Audio Play/Pause Master Switch
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: Colors.teal.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  IconButton(
                    iconSize: 48,
                    icon: Icon(
                      _isAudioPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                      color: Colors.tealAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        _isAudioPlaying = !_isAudioPlaying;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isAudioPlaying ? 'Background Ambient Audio Active' : 'Sound Mixer Paused',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          softWrap: true,
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Listen to custom mix while reading or working in other apps',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Animated Visualizer Bars Simulator
            if (_isAudioPlaying) ...[
              const Text('Live Equalizer Pulse', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 8),
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(12, (index) {
                    final double height = 10.0 + ((index * 7) % 25);
                    return Container(
                      width: 6,
                      height: height,
                      decoration: BoxDecoration(
                        color: Colors.tealAccent,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),
            ],

            const Text(
              'Multi-Channel Sound Faders',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),

            _buildSoundChannelCard('Gentle Rain', Icons.water_drop, _rainVolume, (val) {
              setState(() => _rainVolume = val);
            }),
            _buildSoundChannelCard('Coffee Shop Ambience', Icons.coffee, _cafeVolume, (val) {
              setState(() => _cafeVolume = val);
            }),
            _buildSoundChannelCard('Pine Forest Wind', Icons.air, _forestVolume, (val) {
              setState(() => _forestVolume = val);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundChannelCard(String name, IconData icon, double volume, ValueChanged<double> onChanged) {
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.tealAccent, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  Slider(
                    value: volume,
                    min: 0.0,
                    max: 1.0,
                    activeColor: Colors.tealAccent,
                    inactiveColor: Colors.grey.shade800,
                    onChanged: onChanged,
                  ),
                ],
              ),
            ),
            Text(
              '${(volume * 100).round()}%',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // Floating Overlay Bubble Widget
  Widget _buildFloatingWidget() {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Expanded Quick Control Card
          if (_isBubbleExpanded)
            Container(
              width: 220,
              padding: const EdgeInsets.all(12.0),
              margin: const EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: Colors.tealAccent.withOpacity(0.5)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black87,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'FloatDeck Quick Dock',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () => setState(() => _isBubbleExpanded = false),
                        child: const Icon(Icons.close, color: Colors.grey, size: 16),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.content_copy, color: Colors.tealAccent, size: 18),
                    title: const Text('Quick Paste Pin', style: TextStyle(color: Colors.white, fontSize: 12)),
                    onTap: () {
                      if (_clips.isNotEmpty) {
                        _incrementCopy(_clips.first['id']);
                      }
                    },
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.tune, color: Colors.amber, size: 18),
                    title: const Text('Toggle Night Dimmer', style: TextStyle(color: Colors.white, fontSize: 12)),
                    onTap: () {
                      setState(() {
                        _isOverlayActive = !_isOverlayActive;
                      });
                    },
                  ),
                ],
              ),
            ),

          // Main Floating Draggable Bubble Button
          FloatingActionButton.small(
            heroTag: 'floating_dock_bubble',
            backgroundColor: Colors.teal,
            onPressed: () {
              setState(() {
                _isBubbleExpanded = !_isBubbleExpanded;
              });
            },
            child: const Icon(Icons.widgets, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Screen Ruler Tool
class RulerPainter extends CustomPainter {
  final double inches;
  RulerPainter({required this.inches});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 2.0;

    final double totalTicks = inches * 8; // 1/8 inch ticks
    final double tickSpacing = size.width / totalTicks;

    for (int i = 0; i <= totalTicks; i++) {
      double x = i * tickSpacing;
      double tickHeight = 10.0;

      if (i % 8 == 0) {
        tickHeight = 25.0; // Major inch mark
      } else if (i % 4 == 0) {
        tickHeight = 18.0; // Half inch mark
      } else if (i % 2 == 0) {
        tickHeight = 14.0; // Quarter inch mark
      }

      canvas.drawLine(Offset(x, 0), Offset(x, tickHeight), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant RulerPainter oldDelegate) {
    return oldDelegate.inches != inches;
  }
}