import 'package:flutter/material.dart';

void main() {
  runApp(const OmniOverlayApp());
}

class OmniOverlayApp extends StatefulWidget {
  const OmniOverlayApp({super.key});

  @override
  State<OmniOverlayApp> createState() => _OmniOverlayAppState();
}

class _OmniOverlayAppState extends State<OmniOverlayApp> {
  bool _isDarkMode = true;
  Color _accentColor = Colors.deepPurple;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _changeAccent(Color newColor) {
    setState(() {
      _accentColor = newColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniOverlay Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: _accentColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _accentColor,
          brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: MainOverlayScreen(
        isDarkMode: _isDarkMode,
        onToggleTheme: _toggleTheme,
        accentColor: _accentColor,
        onChangeAccent: _changeAccent,
      ),
    );
  }
}

class ClipItem {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime createdAt;
  bool isPinned;

  ClipItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
    this.isPinned = false,
  });
}

class MainOverlayScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final Color accentColor;
  final ValueChanged<Color> onChangeAccent;

  const MainOverlayScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.accentColor,
    required this.onChangeAccent,
  });

  @override
  State<MainOverlayScreen> createState() => _MainOverlayScreenState();
}

class _MainOverlayScreenState extends State<MainOverlayScreen> {
  int _currentBottomIndex = 0;

  // Floating Overlay System State
  bool _overlayPermissionGranted = true;
  bool _notificationPermissionGranted = true;
  bool _isOverlayActive = true;
  bool _showFloatingDrawer = false;
  Offset _bubblePosition = const Offset(280.0, 320.0);
  String _activeFloatingTool = 'Clipboard Dock';

  // Stats
  int _clipsCopiedToday = 14;
  int _hoursSaved = 3;

  // Clipboard Store
  final List<ClipItem> _clips = [
    ClipItem(
      id: '1',
      title: 'Home Delivery Address',
      content: 'No. 42, Sunrise Boulevard, Metro District, NY 10001',
      category: 'Addresses',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isPinned: true,
    ),
    ClipItem(
      id: '2',
      title: 'Standard Business Reply',
      content: 'Thanks for reaching out! I will review your details and get back to you within 2 hours.',
      category: 'Replies',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isPinned: true,
    ),
    ClipItem(
      id: '3',
      title: 'Tax Identification Code',
      content: 'TX-98234-88A9-2024',
      category: 'Codes',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ClipItem(
      id: '4',
      title: 'Wi-Fi Guest Password',
      content: 'GuestPass_2024!$ecure',
      category: 'Codes',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  String _selectedCategoryFilter = 'All';
  String _searchQuery = '';

  // Quick Reply Generator State
  String _rawInputText = '';
  String _generatedResponse = '';
  String _selectedTone = 'Professional';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.layers, color: widget.accentColor),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'OmniOverlay Studio',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: widget.onToggleTheme,
            tooltip: 'Toggle Dark/Light Mode',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: _showNotificationStatusSheet,
            tooltip: 'Live Floating Notification Status',
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(
              index: _currentBottomIndex,
              children: [
                _buildFloatingStudioTab(),
                _buildClipboardVaultTab(),
                _buildContextReplyTab(),
                _buildSettingsAndToolsTab(),
              ],
            ),

            // Live Floating Bubble Simulator Overlay
            if (_isOverlayActive)
              Positioned(
                left: _bubblePosition.dx,
                top: _bubblePosition.dy,
                child: GestureDetec1tor(
                  onPanUpdate: (details) {
                    setState(() {
                      _bubblePosition += details.delta;
                    });
                  },
                  child: DraggableFloatingBubble(
                    accentColor: widget.accentColor,
                    isOpen: _showFloatingDrawer,
                    onTap: () {
                      setState(() {
                        _showFloatingDrawer = !_showFloatingDrawer;
                      });
                    },
                    activeTool: _activeFloatingTool,
                  ),
                ),
              ),

            // Expanded Floating Overlay Drawer Preview
            if (_isOverlayActive && _showFloatingDrawer)
              Positioned(
                left: (_bubblePosition.dx - 180).clamp(10.0, MediaQuery.of(context).size.width - 210),
                top: (_bubblePosition.dy + 60).clamp(10.0, MediaQuery.of(context).size.height - 250),
                child: Material(
                  elevation: 12,
                  borderRadius: BorderRadius.circular(16),
                  color: widget.isDarkMode ? Colors.grey[900] : Colors.white,
                  child: Container(
                    width: 220,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: widget.accentColor.withOpacity(0.5), width: 1.5),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Floating Companion',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _showFloatingDrawer = false;
                                });
                              },
                              child: const Icon(Icons.close, size: 16),
                            )
                          ],
                        ),
                        const Divider(height: 12),
                        const Text(
                          'Quick Clips Dock:',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        const SizedBox(height: 6),
                        ..._clips.take(2).map(
                              (clip) => Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: widget.accentColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        clip.title,
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _showToast('Copied "${clip.title}" from Floating Overlay!');
                                        setState(() {
                                          _clipsCopiedToday++;
                                        });
                                      },
                                      child: Icon(Icons.copy, size: 14, color: widget.accentColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.accentColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              _showToast('Floating Quick Action Executed!');
                            },
                            icon: const Icon(Icons.flash_on, size: 14),
                            label: const Text('Fast Action', style: TextStyle(fontSize: 11)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() {
            _currentBottomIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: widget.accentColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_customize),
            label: 'Overlay Studio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: 'Clip Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Smart Reply',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Tools & Config',
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating Overlay Studio & Real-time Launcher
  Widget _buildFloatingStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Switch Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: widget.accentColor.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.smart_toy, color: widget.accentColor, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isOverlayActive ? 'Floating Overlay ACTIVE' : 'Floating Overlay OFF',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: _isOverlayActive ? widget.accentColor : Colors.grey,
                              ),
                            ),
                            const Text(
                              'Stays on top of all installed Android/iOS apps',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isOverlayActive,
                        activeColor: widget.accentColor,
                        onChanged: (val) {
                          setState(() {
                            _isOverlayActive = val;
                          });
                          _showToast(val ? 'Overlay Activated on Screen' : 'Overlay Disabled');
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricWidget('Clips Pasted', '$_clipsCopiedToday', Icons.copy),
                      _buildMetricWidget('Hours Saved', '${_hoursSaved}h', Icons.bolt),
                      _buildMetricWidget('Active Mode', 'Smart Clip', Icons.layers),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Floating Tool Selector',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap a tool below to dock it into your live floating overlay bubble:',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildToolChip('Clipboard Dock', Icons.paste),
              _buildToolChip('Quick Decision Matrix', Icons.explore),
              _buildToolChip('Mini Note Pad', Icons.note_alt),
              _buildToolChip('Live Calculator Snippet', Icons.calculate),
              _buildToolChip('Tone Converter', Icons.transform),
            ],
          ),

          const SizedBox(height: 24),
          const Text(
            'Overlay Screen Interactive Simulator',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: widget.isDarkMode ? Colors.black87 : Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone_android, size: 48, color: Colors.grey.withOpacity(0.5)),
                      const SizedBox(height: 8),
                      const Text(
                        'Virtual Phone Screen',
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                      const Text(
                        'Drag the floating bubble around your screen!',
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Chip(
                    avatar: Icon(Icons.touch_app, size: 14, color: widget.accentColor),
                    label: const Text('Drag Bubble Anywhere', style: TextStyle(fontSize: 10)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricWidget(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: widget.accentColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildToolChip(String title, IconData icon) {
    final bool isSelected = _activeFloatingTool == title;
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : widget.accentColor),
          const SizedBox(width: 6),
          Text(title),
        ],
      ),
      selected: isSelected,
      selectedColor: widget.accentColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : (widget.isDarkMode ? Colors.white : Colors.black),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (bool selected) {
        if (selected) {
          setState(() {
            _activeFloatingTool = title;
          });
          _showToast('Docked "$title" into Floating Overlay');
        }
      },
    );
  }

  // TAB 2: Smart Clipboard Vault
  Widget _buildClipboardVaultTab() {
    final filteredClips = _clips.where((clip) {
      final matchesCategory = _selectedCategoryFilter == 'All' || clip.category == _selectedCategoryFilter;
      final matchesSearch = clip.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          clip.content.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Input
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search stored clips & snippets...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              ),
              const SizedBox(height: 12),
              // Category Filter Pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Addresses', 'Replies', 'Codes', 'Notes'].map((cat) {
                    final bool isSel = _selectedCategoryFilter == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(cat),
                        selected: isSel,
                        selectedColor: widget.accentColor.withOpacity(0.2),
                        checkmarkColor: widget.accentColor,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategoryFilter = cat;
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
        Expanded(
          child: filteredClips.isEmpty
              ? const Center(
                  child: Text(
                    'No clips found. Create one using + button!',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredClips.length,
                  itemBuilder: (context, index) {
                    final clip = filteredClips[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                clip.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: widget.accentColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                clip.category,
                                style: TextStyle(fontSize: 10, color: widget.accentColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            clip.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                clip.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                                color: clip.isPinned ? widget.accentColor : Colors.grey,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  clip.isPinned = !clip.isPinned;
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 20, color: Colors.green),
                              onPressed: () {
                                _showToast('Copied "${clip.title}" to device clipboard!');
                                setState(() {
                                  _clipsCopiedToday++;
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _showAddClipDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add New Smart Clip Snippet', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddClipDialog() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    String category = 'Replies';

    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Clip'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Title / Keyword',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: contentCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Clip Text Content',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: category,
                      items: ['Addresses', 'Replies', 'Codes', 'Notes'].map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => category = val);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: widget.accentColor, foregroundColor: Colors.white),
                  onPressed: () {
                    if (titleCtrl.text.trim().isNotEmpty && contentCtrl.text.trim().isNotEmpty) {
                      setState(() {
                        _clips.insert(
                          0,
                          ClipItem(
                            id: DateTime.now().toString(),
                            title: titleCtrl.text.trim(),
                            content: contentCtrl.text.trim(),
                            category: category,
                            createdAt: DateTime.now(),
                          ),
                        );
                      });
                      Navigator.pop(context);
                      _showToast('New clip added to Vault!');
                    }
                  },
                  child: const Text('Save Clip'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // TAB 3: Smart Response Engine
  Widget _buildContextReplyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: widget.accentColor.withOpacity(0.1),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: widget.accentColor, size: 32),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contextual Reply Transformer',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Paste rough thoughts -> Convert to ready-to-send messages!',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
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

          const Text(
            '1. Enter Raw Thought or Incoming Message:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'e.g., "cannot come to meeting today because sick, reschedule tomorrow"',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) {
              setState(() {
                _rawInputText = val;
              });
            },
          ),
          const SizedBox(height: 16),

          const Text(
            '2. Select Reply Tone:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Professional', 'Polite Decline', 'Friendly Chat', 'Sales Pitch', 'Short & Direct'].map((tone) {
              final isSel = _selectedTone == tone;
              return ChoiceChip(
                label: Text(tone),
                selected: isSel,
                selectedColor: widget.accentColor,
                labelStyle: TextStyle(color: isSel ? Colors.white : Colors.black),
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedTone = tone;
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _generateSmartResponse,
              icon: const Icon(Icons.flash_on),
              label: const Text('Transform Response Now'),
            ),
          ),

          if (_generatedResponse.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text(
              'Generated Smart Reply:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: widget.isDarkMode ? Colors.grey[850] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: widget.accentColor.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _generatedResponse,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          _showToast('Copied generated reply to clipboard!');
                          setState(() {
                            _clipsCopiedToday++;
                          });
                        },
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text('Copy Reply'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.accentColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _clips.insert(
                              0,
                              ClipItem(
                                id: DateTime.now().toString(),
                                title: 'Smart Reply: $_selectedTone',
                                content: _generatedResponse,
                                category: 'Replies',
                                createdAt: DateTime.now(),
                              ),
                            );
                          });
                          _showToast('Saved to Clip Vault!');
                        },
                        icon: const Icon(Icons.bookmark_add, size: 16),
                        label: const Text('Save to Vault'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _generateSmartResponse() {
    if (_rawInputText.trim().isEmpty) {
      _showToast('Please type some text first!');
      return;
    }

    setState(() {
      if (_selectedTone == 'Professional') {
        _generatedResponse =
            'Hello, thank you for reaching out. Regrettably, I am unable to attend today due to unforeseen circumstances. Could we kindly reschedule for tomorrow? Best regards.';
      } else if (_selectedTone == 'Polite Decline') {
        _generatedResponse =
            'Hi there! Thanks so much for thinking of me. Unfortunately, my schedule is completely packed today, so I will have to pass this time. Hope you understand!';
      } else if (_selectedTone == 'Friendly Chat') {
        _generatedResponse =
            'Hey! Sorry about today, caught a bit under the weather. Let\'s definitely catch up tomorrow instead! 😊';
      } else if (_selectedTone == 'Sales Pitch') {
        _generatedResponse =
            'Hi! I appreciate your interest. Let\'s quickly reconnect tomorrow so I can present our top tailored options for your workflow!';
      } else {
        _generatedResponse = 'Cannot make it today. Reschedule for tomorrow morning, please.';
      }
    });
  }

  // TAB 4: Settings & Tools Config
  Widget _buildSettingsAndToolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Overlay Permissions Simulator',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Display Over Other Apps Permission'),
                  subtitle: const Text('Allows floating bubble overlay on screen'),
                  value: _overlayPermissionGranted,
                  activeColor: widget.accentColor,
                  onChanged: (val) {
                    setState(() {
                      _overlayPermissionGranted = val;
                      if (!val) _isOverlayActive = false;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Live Notification Bar Status'),
                  subtitle: const Text('Keep quick access controls in status bar'),
                  value: _notificationPermissionGranted,
                  activeColor: widget.accentColor,
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

          const Text(
            'Customize Floating Accent Theme',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildColorOption(Colors.deepPurple, 'Purple'),
              _buildColorOption(Colors.teal, 'Teal'),
              _buildColorOption(Colors.indigo, 'Indigo'),
              _buildColorOption(Colors.amber, 'Amber'),
              _buildColorOption(Colors.blueAccent, 'Blue'),
            ],
          ),

          const SizedBox(height: 24),
          Card(
            color: widget.isDarkMode ? Colors.grey[900] : Colors.grey[100],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.monetization_on, color: Colors.amber[700]),
                      const SizedBox(width: 8),
                      const Text(
                        'AdMob Banner Placeholder',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'This spot is optimized for Google AdMob smart banner monetization when deployed!',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 50,
                    width: double.infinity,
                    color: widget.accentColor.withOpacity(0.2),
                    child: const Center(
                      child: Text(
                        'ADVERTISEMENT SLOT (320 x 50)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(Color color, String name) {
    final bool isSelected = widget.accentColor.value == color.value;
    return GestureDetector(
      onTap: () {
        widget.onChangeAccent(color);
        _showToast('Theme changed to $name');
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: isSelected ? 22 : 18,
            child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
          ),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  void _showNotificationStatusSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.notifications_active, color: widget.accentColor),
                    const SizedBox(width: 10),
                    const Text(
                      'Live Notification Controller',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'OmniOverlay maintains a high-priority persistent notification bar for rapid single-tap copying across any app context.',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.copy),
                  title: const Text('Quick Copy Last Clip'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    Navigator.pop(context);
                    _showToast('Last clip copied!');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.screen_lock_portrait),
                  title: const Text('Toggle Floating Bubble Screen Visibility'),
                  trailing: Switch(
                    value: _isOverlayActive,
                    onChanged: (val) {
                      setState(() {
                        _isOverlayActive = val;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class DraggableFloatingBubble extends StatelessWidget {
  final Color accentColor;
  final bool isOpen;
  final VoidCallback onTap;
  final String activeTool;

  const DraggableFloatingBubble({
    super.key,
    required this.accentColor,
    required this.isOpen,
    required this.onTap,
    required this.activeTool,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      shape: const CircleBorder(),
      color: accentColor,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Icon(
              isOpen ? Icons.close : Icons.layers,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}