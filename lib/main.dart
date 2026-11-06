import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const FloatDeckApp());
}

class FloatDeckApp extends StatelessWidget {
  const FloatDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatDeck Utility Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F111A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.indigo,
          secondary: Colors.teal,
          surface: Color(0xFF181C28),
        ),
      ),
      home: const MainDeckScreen(),
    );
  }
}

class ClipItem {
  final String id;
  final String content;
  final String category; // Link, Phone, Email, Text
  final DateTime timestamp;

  ClipItem({
    required this.id,
    required this.content,
    required this.category,
    required this.timestamp,
  });
}

class MainDeckScreen extends StatefulWidget {
  const MainDeckScreen({super.key});

  @override
  State<MainDeckScreen> createState() => _MainDeckScreenState();
}

class _MainDeckScreenState extends State<MainDeckScreen> with TickerProviderStateMixin {
  int _currentTabIndex = 0;

  // Floating Overlay Bubble State
  bool _isOverlayBubbleActive = true;
  Offset _bubblePosition = const Offset(20, 150);
  bool _isBubbleExpanded = false;

  // Simulated Floating Notification Trigger State
  String? _activeNotificationText;
  Timer? _notificationTimer;

  // Clipboard Vault State
  final List<ClipItem> _clipboardVault = [
    ClipItem(
      id: '1',
      content: 'https://flutter.dev/docs/get-started',
      category: 'Link',
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
    ),
    ClipItem(
      id: '2',
      content: 'support@floatdeck.app',
      category: 'Email',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ClipItem(
      id: '3',
      content: '+1 (800) 555-0199',
      category: 'Phone',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];
  final TextEditingController _clipInputController = TextEditingController();
  String _selectedCategoryFilter = 'All';

  // PiP Teleprompter State
  final TextEditingController _prompterController = TextEditingController(
    text: 'Welcome to FloatDeck! This live floating teleprompter allows you to read your scripts, presentation points, or notes while keeping your view clean and overlaying your workspace. Adjust speed, text size, and opacity dynamically below!',
  );
  bool _isPrompterScrolling = false;
  double _prompterScrollSpeed = 2.0;
  double _prompterFontSize = 18.0;
  double _prompterOpacity = 0.85;
  late ScrollController _prompterScrollController;
  Timer? _prompterTimer;

  // Ambient Engine State
  bool _isAmbientPlaying = false;
  String _activeAmbientSound = 'Rain & Thunder';
  late AnimationController _visualizerController;

  @override
  void initState() {
    super.initState();
    _prompterScrollController = ScrollController();
    _visualizerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _notificationTimer?.cancel();
    _prompterTimer?.cancel();
    _clipInputController.dispose();
    _prompterController.dispose();
    _prompterScrollController.dispose();
    _visualizerController.dispose();
    super.dispose();
  }

  void _triggerFloatingNotification(String message) {
    _notificationTimer?.cancel();
    setState(() {
      _activeNotificationText = message;
    });
    _notificationTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _activeNotificationText = null;
        });
      }
    });
  }

  void _addClip VaultItem() {
    final text = _clipInputController.text.trim();
    if (text.isEmpty) return;

    String cat = 'Text';
    if (text.contains('http://') || text.contains('https://')) {
      cat = 'Link';
    } else if (text.contains('@') && text.contains('.')) {
      cat = 'Email';
    } else if (RegExp(r'^[0-9\-\+\s\(\)]+$').hasMatch(text) && text.length >= 7) {
      cat = 'Phone';
    }

    setState(() {
      _clipboardVault.insert(
        0,
        ClipItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: text,
          category: cat,
          timestamp: DateTime.now(),
        ),
      );
      _clipInputController.clear();
    });
    _triggerFloatingNotification('New snippet saved to Vault as [$cat]');
  }

  void _togglePrompterScroll() {
    setState(() {
      _isPrompterScrolling = !_isPrompterScrolling;
    });

    if (_isPrompterScrolling) {
      _prompterTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        if (!_prompterScrollController.hasClients) return;
        double maxScroll = _prompterScrollController.position.maxScrollExtent;
        double currentScroll = _prompterScrollController.offset;
        if (currentScroll >= maxScroll) {
          _prompterScrollController.jumpTo(0);
        } else {
          _prompterScrollController.animateTo(
            currentScroll + _prompterScrollSpeed,
            duration: const Duration(milliseconds: 50),
            curve: Curves.linear,
          );
        }
      });
    } else {
      _prompterTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Tab Content Area
            Positioned.fill(
              child: IndexedStack(
                index: _currentTabIndex,
                children: [
                  _buildOverlayStudioTab(),
                  _buildClipVaultTab(),
                  _buildPiPPrompterTab(),
                  _buildAmbientEngineTab(),
                ],
              ),
            ),

            // Simulated Dynamic Top Floating Notification Banner
            if (_activeNotificationText != null)
              Positioned(
                top: 12,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade800,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black87,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                    border: Border.all(color: Colors.teal, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active, color: Colors.amber, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _activeNotificationText!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70, size: 18),
                        onPressed: () {
                          setState(() {
                            _activeNotificationText = null;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),

            // Floating System Overlay Bubble Widget
            if (_isOverlayBubbleActive)
              Positioned(
                left: _bubblePosition.dx,
                top: _bubblePosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      double newX = _bubblePosition.dx + details.delta.dx;
                      double newY = _bubblePosition.dy + details.delta.dy;
                      // Keep within screen bounds
                      newX = newX.clamp(0.0, screenSize.width - 60.0);
                      newY = newY.clamp(0.0, screenSize.height - 120.0);
                      _bubblePosition = Offset(newX, newY);
                    });
                  },
                  onTap: () {
                    setState(() {
                      _isBubbleExpanded = !_isBubbleExpanded;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.indigo.shade600,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black87,
                              blurRadius: 12,
                              spreadRadius: 2,
                            )
                          ],
                          border: Border.all(color: Colors.teal, width: 2),
                        ),
                        child: Icon(
                          _isBubbleExpanded ? Icons.close : Icons.widgets,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      if (_isBubbleExpanded) ...[
                        const SizedBox(height: 8),
                        Container(
                          width: 200,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E2435),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.indigo.shade300, width: 1),
                            boxShadow: const [
                              BoxShadow(color: Colors.black87, blurRadius: 16),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'FloatDeck Quick Tools',
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const Divider(color: Colors.white70),
                              ListTile(
                                dense: true,
                                padding: EdgeInsets.zero,
                                leading: const Icon(Icons.flash_on, color: Colors.amber, size: 18),
                                title: const Text('Simulate Alert', style: TextStyle(fontSize: 12)),
                                onTap: () {
                                  _triggerFloatingNotification('Quick Floating System Shortcut Executed!');
                                  setState(() => _isBubbleExpanded = false);
                                },
                              ),
                              ListTile(
                                dense: true,
                                padding: EdgeInsets.zero,
                                leading: const Icon(Icons.content_paste, color: Colors.cyan, size: 18),
                                title: const Text('Quick Vault Clip', style: TextStyle(fontSize: 12)),
                                onTap: () {
                                  setState(() {
                                    _currentTabIndex = 1;
                                    _isBubbleExpanded = false;
                                  });
                                },
                              ),
                              ListTile(
                                dense: true,
                                padding: EdgeInsets.zero,
                                leading: const Icon(Icons.picture_in_picture, color: Colors.green, size: 18),
                                title: const Text('PiP Teleprompter', style: TextStyle(fontSize: 12)),
                                onTap: () {
                                  setState(() {
                                    _currentTabIndex = 2;
                                    _isBubbleExpanded = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) => setState(() => _currentTabIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF141824),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Overlay Studio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: 'Clip Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.picture_in_picture),
            label: 'PiP Reader',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volume_up),
            label: 'Ambient HUD',
          ),
        ],
      ),
    );
  }

  // TAB 1: OVERLAY STUDIO & FLOATING HUD SIMULATION
  Widget _buildOverlayStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Floating Overlay Hub', 'Manage display-over-apps tools & dynamic shortcuts'),
          const SizedBox(height: 16),

          // Main Toggle Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF181C28),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo.shade800),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade900,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.widgets, color: Colors.teal, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Floating System Bubble',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Drag & access tools over any app screen',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isOverlayBubbleActive,
                  activeColor: Colors.teal,
                  onChanged: (val) {
                    setState(() {
                      _isOverlayBubbleActive = val;
                    });
                    _triggerFloatingNotification(
                      val ? 'Floating Bubble enabled on screen' : 'Floating Bubble disabled',
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Permissions & Overlay Status',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          _buildStatusRow('Display Over Other Apps', 'Granted', Icons.check_circle, Colors.green),
          _buildStatusRow('Floating Notifications Banner', 'Active', Icons.check_circle, Colors.green),
          _buildStatusRow('Background Clipboard Sync', 'Ready', Icons.info, Colors.amber),

          const SizedBox(height: 20),
          const Text(
            'Simulate Floating Banner Trigger',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade700,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.copy, size: 16),
                label: const Text('Clip Saved Banner'),
                onPressed: () => _triggerFloatingNotification('Copied: "https://github.com/flutter"'),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.timer, size: 16),
                label: const Text('Task Alert Banner'),
                onPressed: () => _triggerFloatingNotification('FloatDeck: Continuous background task active'),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade700,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.flash_on, size: 16),
                label: const Text('System Memory Cleaned'),
                onPressed: () => _triggerFloatingNotification('FloatDeck Utility: 140MB Cache freed'),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF141824),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '💡 Why FloatDeck stays on screen',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  'FloatDeck gives you persistent, floating micro-utilities without leaving your main workflow. Use the Clip Vault to process snippets or switch to Desk Ambient mode while working.',
                  style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // TAB 2: SMART CLIPBOARD VAULT & TRANSFORMER
  Widget _buildClipVaultTab() {
    final filteredClips = _selectedCategoryFilter == 'All'
        ? _clipboardVault
        : _clipboardVault.where((c) => c.category == _selectedCategoryFilter).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Smart Clip Vault', 'Extract, transform, and categorize copied text snippets'),
          const SizedBox(height: 16),

          // Clip Input Field
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF181C28),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo.shade700),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _clipInputController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Paste or type text, link, phone, or email here...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Parse & Save Snippet', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: _addClipVaultItem,
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Link', 'Email', 'Phone', 'Text'].map((category) {
                final isSelected = _selectedCategoryFilter == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: Colors.teal.shade800,
                    backgroundColor: const Color(0xFF181C28),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedCategoryFilter = category;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Snippets List
          if (filteredClips.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: const Text(
                'No snippets found in this category',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredClips.length,
              itemBuilder: (context, index) {
                final clip = filteredClips[index];
                IconData catIcon = Icons.text_snippet;
                Color catColor = Colors.blue;

                if (clip.category == 'Link') {
                  catIcon = Icons.link;
                  catColor = Colors.cyan;
                } else if (clip.category == 'Email') {
                  catIcon = Icons.email;
                  catColor = Colors.amber;
                } else if (clip.category == 'Phone') {
                  catIcon = Icons.phone;
                  catColor = Colors.green;
                }

                return Card(
                  color: const Color(0xFF181C28),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(catIcon, color: catColor, size: 18),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: catColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                clip.category,
                                style: TextStyle(color: catColor, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.grey, size: 18),
                              onPressed: () {
                                setState(() {
                                  _clipboardVault.removeWhere((item) => item.id == clip.id);
                                });
                                _triggerFloatingNotification('Snippet deleted');
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 6),
                        SelectableText(
                          clip.content,
                          style: const TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              '${clip.timestamp.hour}:${clip.timestamp.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                            const Spacer(),
                            TextButton.icon(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              icon: const Icon(Icons.copy, size: 14, color: Colors.teal),
                              label: const Text('Copy Clean', style: TextStyle(color: Colors.teal, fontSize: 12)),
                              onPressed: () {
                                _triggerFloatingNotification('Copied snippet to OS Clipboard!');
                              },
                            )
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

  // TAB 3: PIP FLOATING READER & TELEPROMPTER
  Widget _buildPiPPrompterTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('PiP Teleprompter & Reader', 'Overlay scrolling text reader for video or study'),
          const SizedBox(height: 16),

          // Prompter Control Panel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF181C28),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo.shade800),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isPrompterScrolling ? Colors.red : Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      icon: Icon(_isPrompterScrolling ? Icons.pause : Icons.play_arrow),
                      label: Text(_isPrompterScrolling ? 'Pause Prompter' : 'Start Scroll'),
                      onPressed: _togglePrompterScroll,
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Reset'),
                      onPressed: () {
                        if (_prompterScrollController.hasClients) {
                          _prompterScrollController.jumpTo(0);
                        }
                      },
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Text('Scroll Speed: ${_prompterScrollSpeed.toStringAsFixed(1)}', style: const TextStyle(fontSize: 12)),
                Slider(
                  value: _prompterScrollSpeed,
                  min: 0.5,
                  max: 8.0,
                  activeColor: Colors.teal,
                  onChanged: (val) {
                    setState(() => _prompterScrollSpeed = val);
                  },
                ),
                Text('Text Font Size: ${_prompterFontSize.toInt()}px', style: const TextStyle(fontSize: 12)),
                Slider(
                  value: _prompterFontSize,
                  min: 12.0,
                  max: 32.0,
                  activeColor: Colors.amber,
                  onChanged: (val) {
                    setState(() => _prompterFontSize = val);
                  },
                ),
                Text('Overlay Opacity: ${(_prompterOpacity * 100).toInt()}%', style: const TextStyle(fontSize: 12)),
                Slider(
                  value: _prompterOpacity,
                  min: 0.2,
                  max: 1.0,
                  activeColor: Colors.purple,
                  onChanged: (val) {
                    setState(() => _prompterOpacity = val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Live PiP Teleprompter Preview Window',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          // Prompter Live Box
          Container(
            height: 220,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(_prompterOpacity),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.shade400, width: 2),
              boxShadow: const [
                BoxShadow(color: Colors.black87, blurRadius: 10),
              ],
            ),
            child: SingleChildScrollView(
              controller: _prompterScrollController,
              child: Text(
                _prompterController.text,
                style: TextStyle(
                  fontSize: _prompterFontSize,
                  color: Colors.white,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          TextField(
            controller: _prompterController,
            maxLines: 4,
            style: const TextStyle(fontSize: 13),
            decoration: const InputDecoration(
              labelText: 'Edit Script / Text Content',
              labelStyle: TextStyle(color: Colors.teal),
              border: OutlineInputBorder(),
            ),
            onChanged: (val) {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  // TAB 4: AMBIENT DESK ENGINE & SCREEN VISUALIZER
  Widget _buildAmbientEngineTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Ambient Desk Engine', 'Active focus screen visualizer & noise generator'),
          const SizedBox(height: 16),

          // Visualizer Screen Display Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade900, const Color(0xFF141824)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.teal.shade700, width: 1.5),
            ),
            child: Column(
              children: [
                const Icon(Icons.wb_sunny_outlined, color: Colors.amber, size: 36),
                const SizedBox(height: 12),
                Text(
                  _isAmbientPlaying ? 'AUDIO VISUALIZER ACTIVE' : 'DESK AMBIENT READY',
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _activeAmbientSound,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 20),

                // Animated Visualizer Bars
                SizedBox(
                  height: 50,
                  child: AnimatedBuilder(
                    animation: _visualizerController,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(12, (index) {
                          double heightFactor = _isAmbientPlaying
                              ? (0.2 + ((index % 4 + 1) * 0.2 * _visualizerController.value))
                              : 0.1;
                          return Container(
                            width: 8,
                            height: 40 * heightFactor,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: index % 2 == 0 ? Colors.teal : Colors.amber,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isAmbientPlaying ? Colors.amber : Colors.teal,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  icon: Icon(_isAmbientPlaying ? Icons.pause : Icons.play_arrow),
                  label: Text(
                    _isAmbientPlaying ? 'Stop Ambient Engine' : 'Start Focus Soundscape',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    setState(() {
                      _isAmbientPlaying = !_isAmbientPlaying;
                    });
                    _triggerFloatingNotification(
                      _isAmbientPlaying
                          ? 'Playing background soundscape: $_activeAmbientSound'
                          : 'Ambient soundscape stopped',
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Select Soundscape Profile',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          _buildSoundProfileTile('Rain & Thunder', Icons.thunderstorm, 'Deep relaxing rainfall for long work sessions'),
          _buildSoundProfileTile('Cyberpunk Coffee Shop', Icons.local_cafe, 'Subtle background chatter & lofi hum'),
          _buildSoundProfileTile('Deep Space White Noise', Icons.blur_on, 'Constant static frequency for deep concentration'),
          _buildSoundProfileTile('Ocean Wave Flow', Icons.waves, 'Rhythmic natural tide sound simulation'),
        ],
      ),
    );
  }

  Widget _buildSoundProfileTile(String title, IconData icon, String subtitle) {
    final isSelected = _activeAmbientSound == title;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF181C28),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? Colors.teal : Colors.transparent, width: 1.5),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.teal : Colors.grey),
        title: Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.teal, size: 20) : null,
        onTap: () {
          setState(() {
            _activeAmbientSound = title;
          });
          _triggerFloatingNotification('Soundscape switched to: $title');
        },
      ),
    );
  }

  Widget _buildHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildStatusRow(String label, String status, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF181C28),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}