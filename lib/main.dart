import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const ClipDockApp());
}

class ClipDockApp extends StatelessWidget {
  const ClipDockApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'ClipDock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      home: const MainDockScreen(),
    );
  }
}

class ClipItem {
  final String id;
  String content;
  final String category; // 'Phone', 'Link', 'Email', 'Note'
  final DateTime timestamp;

  ClipItem({
    required this.id,
    required this.content,
    required this.category,
    required this.timestamp,
  });
}

class MainDockScreen extends StatefulWidget {
  const MainDockScreen({Key? key}) : super(key: key);

  @override
  State<MainDockScreen> createState() => _MainDockScreenState();
}

class _MainDockScreenState extends State<MainDockScreen> {
  int _currentTabIndex = 0;

  // Floating Overlay System State
  bool _isOverlayEnabled = true;
  bool _isDisplayAboveAppsGranted = true;
  bool _isNotificationsEnabled = true;
  bool _isBubbleExpanded = false;
  Offset _bubblePosition = const Offset(20.0, 200.0);

  // Clip Vault State
  final List<ClipItem> _clips = [
    ClipItem(
      id: '1',
      content: '+1 (555) 019-2834 - Delivery Agent Contact',
      category: 'Phone',
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
    ),
    ClipItem(
      id: '2',
      content: 'https://maps.google.com/?q=Central+Station+Meeting+Point',
      category: 'Link',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ClipItem(
      id: '3',
      content: 'Invoice total: \$149.99 - Order #88204928',
      category: 'Note',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    ClipItem(
      id: '4',
      content: 'support.team@service-portal.org',
      category: 'Email',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];
  String _selectedCategoryFilter = 'All';
  final TextEditingController _newClipController = TextEditingController();

  // Speed Reader State
  final TextEditingController _readerController = TextEditingController(
    text:
        'ClipDock enhances your mobile multitasking workflow by capturing snippets, cleaning messy text formatting, masking private details, and accelerating your reading speed up to 600 words per minute without leaving your current app screen context.',
  );
  List<String> _readerWords = [];
  int _currentWordIndex = 0;
  bool _isReading = false;
  int _wordsPerMinute = 300;
  Timer? _readerTimer;

  // Decision Spinner State
  final List<String> _decisionOptions = [
    'Order Food Online',
    'Cook Home Meal',
    'Take a 15-Min Walk',
    'Review Pending Tasks',
    'Call Friend',
  ];
  final TextEditingController _decisionInputController =
      TextEditingController();
  String _selectedDecisionResult = '';
  bool _isSpinning = false;

  // Text Inspector State
  final TextEditingController _textAController = TextEditingController();
  final TextEditingController _textBController = TextEditingController();
  String _inspectionSummary = 'Enter text in both boxes to compare differences.';

  @override
  void initState() {
    super.initState();
    _prepareReaderWords();
  }

  @override
  void dispose() {
    _newClipController.dispose();
    _readerController.dispose();
    _decisionInputController.dispose();
    _textAController.dispose();
    _textBController.dispose();
    _readerTimer?.cancel();
    super.dispose();
  }

  void _prepareReaderWords() {
    final rawText = _readerController.text.trim();
    if (rawText.isNotEmpty) {
      setState(() {
        _readerWords = rawText.split(RegExp(r'\s+'));
        _currentWordIndex = 0;
      });
    } else {
      setState(() {
        _readerWords = ['No', 'text', 'provided.'];
        _currentWordIndex = 0;
      });
    }
  }

  void _toggleSpeedReader() {
    if (_isReading) {
      _stopSpeedReader();
    } else {
      if (_readerWords.isEmpty) _prepareReaderWords();
      setState(() {
        _isReading = true;
      });
      final intervalMs = (60000 / _wordsPerMinute).round();
      _readerTimer?.cancel();
      _readerTimer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
        if (_currentWordIndex < _readerWords.length - 1) {
          setState(() {
            _currentWordIndex++;
          });
        } else {
          _stopSpeedReader();
        }
      });
    }
  }

  void _stopSpeedReader() {
    _readerTimer?.cancel();
    setState(() {
      _isReading = false;
    });
  }

  void _addNewClip(String content, String category) {
    if (content.trim().isEmpty) return;
    setState(() {
      _clips.insert(
        0,
        ClipItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: content.trim(),
          category: category,
          timestamp: DateTime.now(),
        ),
      );
      _newClipController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saved to Clip Vault!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _applyTextTransform(ClipItem item, String mode) {
    String original = item.content;
    String transformed = original;

    if (mode == 'mask') {
      // Replace numbers and email chars with asterisks for sensitive data hiding
      transformed = original.replaceAll(RegExp(r'\d'), '*');
      transformed = transformed.replaceAll(
          RegExp(r'(?<=.{2}).(?=.*@)'), '*');
    } else if (mode == 'clean') {
      // Remove linebreaks and double spaces
      transformed =
          original.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ');
    } else if (mode == 'titlecase') {
      transformed = original.split(' ').map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join(' ');
    }

    setState(() {
      item.content = transformed;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applied transformation: $mode'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _spinDecisionWheel() {
    if (_decisionOptions.isEmpty) return;
    setState(() {
      _isSpinning = true;
      _selectedDecisionResult = 'Spinning options...';
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      final randomIndex =
          (DateTime.now().millisecondsSinceEpoch) % _decisionOptions.length;
      setState(() {
        _isSpinning = false;
        _selectedDecisionResult = _decisionOptions[randomIndex];
      });
    });
  }

  void _compareTexts() {
    final textA = _textAController.text;
    final textB = _textBController.text;

    if (textA.isEmpty || textB.isEmpty) {
      setState(() {
        _inspectionSummary = 'Please enter text in both fields to compare.';
      });
      return;
    }

    final lenA = textA.length;
    final lenB = textB.length;
    final wordsA = textA.trim().split(RegExp(r'\s+')).length;
    final wordsB = textB.trim().split(RegExp(r'\s+')).length;
    final isIdentical = textA == textB;

    setState(() {
      _inspectionSummary = isIdentical
          ? 'MATCH PERFECT: Both text snippets are 100% identical.'
          : 'DIFFERENCE DETECTED:\n• Snippet A: $lenA chars, $wordsA words\n• Snippet B: $lenB chars, $wordsB words\n• Length Difference: ${(lenA - lenB).abs()} chars';
    });
  }

  List<ClipItem> get _filteredClips {
    if (_selectedCategoryFilter == 'All') return _clips;
    return _clips
        .where((clip) => clip.category == _selectedCategoryFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.layers, color: Colors.amber),
            SizedBox(width: 8),
            Text(
              'ClipDock Engine',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isOverlayEnabled
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.white,
            ),
            tooltip: 'Toggle Floating Bubble',
            onPressed: () {
              setState(() {
                _isOverlayEnabled = !_isOverlayEnabled;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Tab Content Area
            Positioned.fill(
              child: IndexedStack(
                index: _currentTabIndex,
                children: [
                  _buildOverlayDockTab(),
                  _buildClipVaultTab(),
                  _buildSpeedReaderTab(),
                  _buildMicroToolsTab(),
                ],
              ),
            ),

            // Simulated Floating Bubble System Overlay
            if (_isOverlayEnabled) _buildInteractiveFloatingBubble(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey[600],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy),
            label: 'Clip Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt),
            label: 'Speed Read',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Micro Tools',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: OVERLAY DOCK CONTROLS ---
  Widget _buildOverlayDockTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Status Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_active,
                          color: Colors.indigo,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Floating Overlay Active',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              _isOverlayEnabled
                                  ? 'System dock bubble visible on screen'
                                  : 'Overlay dock currently hidden',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isOverlayEnabled,
                        activeColor: Colors.indigo,
                        onPressed: (val) {
                          setState(() {
                            _isOverlayEnabled = val;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Text(
            'SYSTEM PERMISSIONS & SETTINGS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),

          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Display Over Other Apps'),
                  subtitle: const Text(
                      'Allows floating dock bubble to hover over browsers and apps'),
                  value: _isDisplayAboveAppsGranted,
                  secondary: const Icon(Icons.layers_outlined, color: Colors.indigo),
                  onChanged: (val) {
                    setState(() {
                      _isDisplayAboveAppsGranted = val;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Live Notification Bridge'),
                  subtitle: const Text(
                      'Keep quick clip capture accessible in phone status bar'),
                  value: _isNotificationsEnabled,
                  secondary: const Icon(Icons.notifications_none,
                      color: Colors.indigo),
                  onChanged: (val) {
                    setState(() {
                      _isNotificationsEnabled = val;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'QUICK OVERLAY SHORTCUTS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: _buildActionTile(
                  icon: Icons.add_link,
                  title: 'New Clip',
                  color: Colors.teal,
                  onTap: () {
                    _showAddClipBottomSheet(context);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionTile(
                  icon: Icons.psychology,
                  title: 'Micro Decision',
                  color: Colors.purple,
                  onTap: () {
                    setState(() {
                      _currentTabIndex = 3;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionTile(
                  icon: Icons.speed,
                  title: 'Speed Reader',
                  color: Colors.orange,
                  onTap: () {
                    setState(() {
                      _currentTabIndex = 2;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionTile(
                  icon: Icons.security,
                  title: 'Mask Private Text',
                  color: Colors.blueGrey,
                  onTap: () {
                    if (_clips.isNotEmpty) {
                      _applyTextTransform(_clips.first, 'mask');
                      setState(() {
                        _currentTabIndex = 1;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 2: CLIP VAULT TAB ---
  Widget _buildClipVaultTab() {
    final filteredList = _filteredClips;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Action Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _newClipController,
                  decoration: const InputDecoration(
                    hintText: 'Quick paste or type new clip...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  _addNewClip(_newClipController.text, 'Note');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Save'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Category Chips Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Phone', 'Link', 'Email', 'Note'].map((cat) {
                final isSelected = _selectedCategoryFilter == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: Colors.indigo.shade100,
                    checkmarkColor: Colors.indigo,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.indigo : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
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

          const SizedBox(height: 16),

          if (filteredList.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Icon(Icons.content_paste_off,
                        size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      'No clips found in "$_selectedCategoryFilter"',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final clip = filteredList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade50,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                clip.category.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${clip.timestamp.hour.toString().padLeft(2, '0')}:${clip.timestamp.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  size: 18, color: Colors.redAccent),
                              onPressed: () {
                                setState(() {
                                  _clips.removeWhere((item) => item.id == clip.id);
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        SelectableText(
                          clip.content,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 6),
                        // Smart Quick Transformers Bar
                        Wrap(
                          spacing: 6,
                          crossAxisAlignment: WrapCrossAxisAlignment.center,
                          children: [
                            ActionChip(
                              avatar: const Icon(Icons.cleaning_services,
                                  size: 14),
                              label: const Text('Clean Lines',
                                  style: TextStyle(fontSize: 11)),
                              onPressed: () =>
                                  _applyTextTransform(clip, 'clean'),
                            ),
                            ActionChip(
                              avatar: const Icon(Icons.security, size: 14),
                              label: const Text('Mask Private',
                                  style: TextStyle(fontSize: 11)),
                              onPressed: () =>
                                  _applyTextTransform(clip, 'mask'),
                            ),
                            ActionChip(
                              avatar: const Icon(Icons.text_fields, size: 14),
                              label: const Text('Title Case',
                                  style: TextStyle(fontSize: 11)),
                              onPressed: () =>
                                  _applyTextTransform(clip, 'titlecase'),
                            ),
                            ActionChip(
                              avatar: const Icon(Icons.bolt, size: 14),
                              label: const Text('Speed Read',
                                  style: TextStyle(fontSize: 11)),
                              onPressed: () {
                                _readerController.text = clip.content;
                                _prepareReaderWords();
                                setState(() {
                                  _currentTabIndex = 2;
                                });
                              },
                            ),
                          ],
                        ),
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

  // --- TAB 3: RSVP SPEED READER TAB ---
  Widget _buildSpeedReaderTab() {
    final currentWord = (_readerWords.isNotEmpty &&
            _currentWordIndex < _readerWords.length)
        ? _readerWords[_currentWordIndex]
        : 'Ready';

    final progress = _readerWords.isNotEmpty
        ? (_currentWordIndex + 1) / _readerWords.length
        : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // High Speed Reader Box
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      currentWord,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                        letterSpacing: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Word ${_readerWords.isNotEmpty ? _currentWordIndex + 1 : 0} of ${_readerWords.length}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Progress Indicator
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: Colors.indigo,
            minHeight: 6,
          ),

          const SizedBox(height: 20),

          // Play / Pause and Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 32,
                icon: const Icon(Icons.replay_10),
                onPressed: () {
                  setState(() {
                    _currentWordIndex =
                        (_currentWordIndex - 10).clamp(0, _readerWords.length - 1);
                  });
                },
              ),
              const SizedBox(width: 16),
              FloatingActionButton.large(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                onPressed: _toggleSpeedReader,
                child: Icon(_isReading ? Icons.pause : Icons.play_arrow),
              ),
              const SizedBox(width: 16),
              IconButton(
                iconSize: 32,
                icon: const Icon(Icons.forward_10),
                onPressed: () {
                  setState(() {
                    _currentWordIndex =
                        (_currentWordIndex + 10).clamp(0, _readerWords.length - 1);
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Speed WPM Slider
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Reading Speed (WPM):',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$_wordsPerMinute WPM',
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _wordsPerMinute.toDouble(),
                    min: 150,
                    max: 600,
                    divisions: 9,
                    activeColor: Colors.indigo,
                    label: '$_wordsPerMinute WPM',
                    onChanged: (val) {
                      setState(() {
                        _wordsPerMinute = val.round();
                      });
                      if (_isReading) {
                        _toggleSpeedReader();
                        _toggleSpeedReader();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Editable Source Text Box
          TextField(
            controller: _readerController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Source Text to Speed Read',
              hintText: 'Paste long article or text snippet here...',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => _prepareReaderWords(),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: MICRO TOOLS & DECISION ENGINE ---
  Widget _buildMicroToolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Micro Decision Spinner Tool
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.psychology, color: Colors.purple),
                      SizedBox(width: 8),
                      Text(
                        'Micro Decision Engine',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Eliminate everyday decision fatigue! Spin for quick micro choices.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        _selectedDecisionResult.isEmpty
                            ? 'Tap Spin to pick an option'
                            : _selectedDecisionResult,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _isSpinning ? Colors.purple : Colors.deepPurple,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isSpinning ? null : _spinDecisionWheel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: Text(_isSpinning ? 'Selecting...' : 'Spin Choice'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _decisionInputController,
                          decoration: const InputDecoration(
                            hintText: 'Add new choice option...',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.purple),
                        onPressed: () {
                          final newOpt = _decisionInputController.text.trim();
                          if (newOpt.isNotEmpty) {
                            setState(() {
                              _decisionOptions.add(newOpt);
                              _decisionInputController.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: _decisionOptions.map((opt) {
                      return Chip(
                        label: Text(
                          opt,
                          style: const TextStyle(fontSize: 11),
                        ),
                        deleteIcon: const Icon(Icons.close, size: 14),
                        onDeleted: () {
                          setState(() {
                            _decisionOptions.remove(opt);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Text Difference Inspector Tool
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.compare_arrows, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(
                        'Text Diff & Match Inspector',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _textAController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Text Snippet A',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => _compareTexts(),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _textBController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Text Snippet B',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => _compareTexts(),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _inspectionSummary,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
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

  // --- INTERACTIVE FLOATING OVERLAY BUBBLE WIDGET ---
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Floating Trigger Button
            FloatingActionButton.small(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              elevation: 6,
              onPressed: () {
                setState(() {
                  _isBubbleExpanded = !_isBubbleExpanded;
                });
              },
              child: Icon(_isBubbleExpanded ? Icons.close : Icons.layers),
            ),

            // Expanded Quick Floating Menu Drawer
            if (_isBubbleExpanded)
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 200,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Floating Dock Assistant',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const Divider(height: 12),
                    _buildBubbleMenuItem(
                      icon: Icons.add,
                      label: 'Quick Note',
                      onTap: () {
                        setState(() {
                          _isBubbleExpanded = false;
                        });
                        _showAddClipBottomSheet(context);
                      },
                    ),
                    _buildBubbleMenuItem(
                      icon: Icons.bolt,
                      label: 'Speed Reader',
                      onTap: () {
                        setState(() {
                          _isBubbleExpanded = false;
                          _currentTabIndex = 2;
                        });
                      },
                    ),
                    _buildBubbleMenuItem(
                      icon: Icons.psychology,
                      label: 'Micro Choice',
                      onTap: () {
                        setState(() {
                          _isBubbleExpanded = false;
                          _currentTabIndex = 3;
                        });
                        _spinDecisionWheel();
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBubbleMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.indigo),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddClipBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        String category = 'Note';
        final tempController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 16,
                left: 16,
                right: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Capture New Clip Snippet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: tempController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Paste or type tracking info, address, notes...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: ['Note', 'Phone', 'Link', 'Email'].map((cat) {
                      final isSelected = category == cat;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              category = cat;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (tempController.text.trim().isNotEmpty) {
                          _addNewClip(tempController.text, category);
                          Navigator.pop(ctx);
                        }
                      },
                      child: const Text('Save to Clip Vault'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}