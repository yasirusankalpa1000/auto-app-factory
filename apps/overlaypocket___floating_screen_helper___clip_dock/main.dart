import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const OverlayPocketApp());
}

class OverlayPocketApp extends StatelessWidget {
  const OverlayPocketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlayPocket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class StickyNoteItem {
  final String id;
  final String title;
  final String content;
  final Color badgeColor;
  final String category;
  bool isPinnedFloating;

  StickyNoteItem({
    required this.id,
    required this.title,
    required this.content,
    required this.badgeColor,
    required this.category,
    this.isPinnedFloating = true,
  });
}

class ClipVaultItem {
  final String id;
  final String text;
  final String tag;
  final DateTime timestamp;

  ClipVaultItem({
    required this.id,
    required this.text,
    required this.tag,
    required this.timestamp,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedBottomTab = 0;

  // App State Data
  bool _overlayPermission = true;
  bool _notificationPermission = true;
  bool _storagePermission = false;

  bool _isFloatingDockActive = true;
  Color _bubbleColor = Colors.teal;
  double _bubbleOpacity = 0.9;
  Offset _bubblePosition = const Offset(150, 120);

  int _dailyStreak = 4;
  int _totalClipsCopied = 28;

  // Decision Spinner State
  bool _isSpinning = false;
  String _decisionResult = "Tap Spin to decide!";
  final List<String> _decisionOptions = [
    "Do It Right Now!",
    "Wait 10 Minutes",
    "Ask a Friend",
    "Buy Later Today",
    "Save for Weekend",
    "Take 5 Min Break",
  ];

  // Sticky Notes List
  final List<StickyNoteItem> _stickies = [
    StickyNoteItem(
      id: '1',
      title: 'Commercial Bank Acc',
      content: '8000 1234 5678 (J. Perera)',
      badgeColor: Colors.indigo,
      category: 'Banking',
      isPinnedFloating: true,
    ),
    StickyNoteItem(
      id: '2',
      title: 'Delivery Address',
      content: 'No. 45, Flower Rd, Colombo 07',
      badgeColor: Colors.deepOrange,
      category: 'Address',
      isPinnedFloating: true,
    ),
    StickyNoteItem(
      id: '3',
      title: 'Wi-Fi Guest Code',
      content: 'Pass: Hub#2025@Key',
      badgeColor: Colors.purple,
      category: 'Quick Info',
      isPinnedFloating: false,
    ),
  ];

  // Clip Vault
  final List<ClipVaultItem> _clipVault = [
    ClipVaultItem(
      id: '101',
      text: 'https://maps.google.com/?q=6.9271,79.8612',
      tag: 'Location Link',
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
    ),
    ClipVaultItem(
      id: '102',
      text: 'Total Cost: \$45.50 (Includes Express Delivery)',
      tag: 'Shopping',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  // Controllers for Dialogs
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _quickClipController = TextEditingController();

  // Chat Generator state
  String _selectedChatCategory = 'Inquiry';
  String _customizedReplyOutput = '';

  final Map<String, List<String>> _chatTemplates = {
    'Inquiry': [
      "Hello! Is this item currently available? What is the delivery cost to my address?",
      "Hi there, could you please send me the price details and warranty terms?",
    ],
    'Professional': [
      "Thank you for the update! I have received the details and will get back to you shortly.",
      "Hi, kindly check the attached details and let me know if any further info is required.",
    ],
    'Payment': [
      "Payment completed! Please find the reference details: Bank Acc 800012345678.",
      "Hi! Could you please share your bank details and total amount including delivery?",
    ],
    'Friendly': [
      "Hey! I am currently away from my phone. Will reply as soon as possible!",
      "Super busy right now, catch up with you in 20 minutes!",
    ]
  };

  @override
  void initState() {
    super.initState();
    _customizedReplyOutput = _chatTemplates['Inquiry']![0];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _quickClipController.dispose();
    super.dispose();
  }

  void _addNewStickyNote() {
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both title and content')),
      );
      return;
    }

    setState(() {
      _stickies.insert(
        0,
        StickyNoteItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          badgeColor: Colors.teal,
          category: 'Custom',
          isPinnedFloating: true,
        ),
      );
      _titleController.clear();
      _contentController.clear();
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Floating Sticky Note Added!')),
    );
  }

  void _pasteToClipVault() {
    if (_quickClipController.text.trim().isEmpty) return;
    setState(() {
      _clipVault.insert(
        0,
        ClipVaultItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: _quickClipController.text.trim(),
          tag: 'Quick Stash',
          timestamp: DateTime.now(),
        ),
      );
      _totalClipsCopied++;
      _quickClipController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to Clip Vault!')),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: "$text"'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _spinDecision() {
    if (_isSpinning) return;
    setState(() {
      _isSpinning = true;
      _decisionResult = "Spinning choice...";
    });

    Timer(const Duration(milliseconds: 1200), () {
      final rand = math.Random();
      final picked = _decisionOptions[rand.nextInt(_decisionOptions.length)];
      if (mounted) {
        setState(() {
          _isSpinning = false;
          _decisionResult = picked;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.layers, color: Colors.teal),
            SizedBox(width: 8),
            Text(
              'OverlayPocket',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  'Streak: $_dailyStreak d',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Status & Floating Dock Switcher
            _buildFloatingStatusHeader(),

            // Main View Area
            Expanded(
              child: IndexedStack(
                index: _selectedBottomTab,
                children: [
                  _buildFloatingStudioTab(),
                  _buildClipVaultTab(),
                  _buildChatResponseTab(),
                  _buildDecisionSpinnerTab(),
                  _buildPermissionsHubTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedBottomTab,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedBottomTab = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.touch_app),
            label: 'Floating Dock',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_paste),
            label: 'Clip Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.forum),
            label: 'Quick Replies',
          ),
          NavigationDestination(
            icon: Icon(Icons.casino),
            label: 'Decision',
          ),
          NavigationDestination(
            icon: Icon(Icons.security),
            label: 'Permissions',
          ),
        ],
      ),
      floatingActionButton: _selectedBottomTab == 0
          ? FloatingActionButton.extended(
              onPressed: () => _showAddStickyDialog(context),
              backgroundColor: Colors.teal,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Add Sticky',
                style: TextStyle(color: Colors.white, FontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }

  Widget _buildFloatingStatusHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isFloatingDockActive ? Colors.green : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isFloatingDockActive
                        ? 'Floating Overlay Active'
                        : 'Floating Overlay Standby',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Switch(
                value: _isFloatingDockActive,
                activeColor: Colors.teal,
                onChanged: (val) {
                  setState(() {
                    _isFloatingDockActive = val;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating Dock & Overlay HUD Studio
  Widget _buildFloatingStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Interactive Dock Workspace Preview',
            style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Drag the floating pocket bubble below to test desktop overlay position.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          // Interactive Drag Playground Box
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.3), width: 1.5),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phonelink_setup,
                          color: Colors.grey.withOpacity(0.5), size: 36),
                      const SizedBox(height: 6),
                      Text(
                        'Simulated Phone Screen View',
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Floating Draggable Bubble
                if (_isFloatingDockActive)
                  Positioned(
                    left: _bubblePosition.dx,
                    top: _bubblePosition.dy,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          double newX = _bubblePosition.dx + details.delta.dx;
                          double newY = _bubblePosition.dy + details.delta.dy;
                          newX = newX.clamp(10.0, 270.0);
                          newY = newY.clamp(10.0, 130.0);
                          _bubblePosition = Offset(newX, newY);
                        });
                      },
                      child: Opacity(
                        opacity: _bubbleOpacity,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _bubbleColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _bubbleColor.withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: const Icon(
                            Icons.layers,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Bubble Style Customizers
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dock Bubble Customizer',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Color: ', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 8),
                      _buildColorPickerChip(Colors.teal),
                      _buildColorPickerChip(Colors.indigo),
                      _buildColorPickerChip(Colors.deepOrange),
                      _buildColorPickerChip(Colors.purple),
                      _buildColorPickerChip(Colors.black),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Opacity: ', style: TextStyle(fontSize: 12)),
                      Expanded(
                        child: Slider(
                          value: _bubbleOpacity,
                          min: 0.3,
                          max: 1.0,
                          activeColor: Colors.teal,
                          onChanged: (val) {
                            setState(() {
                              _bubbleOpacity = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Active Floating Sticky Notes Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Floating Stickies',
                style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold),
              ),
              Text(
                '${_stickies.length} items',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _stickies.length,
            itemBuilder: (context, index) {
              final item = _stickies[index];
              return Card(
                elevation: 1.5,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 48,
                        decoration: BoxDecoration(
                          color: item.badgeColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item.category,
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.content,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 20, color: Colors.teal),
                        tooltip: 'Quick Copy',
                        onPressed: () => _copyToClipboard(item.content),
                      ),
                      IconButton(
                        icon: Icon(
                          item.isPinnedFloating
                              ? Icons.push_pin
                              : Icons.push_pin_outlined,
                          size: 20,
                          color: item.isPinnedFloating
                              ? Colors.amber
                              : Colors.grey,
                        ),
                        tooltip: 'Toggle Pin',
                        onPressed: () {
                          setState(() {
                            item.isPinnedFloating = !item.isPinnedFloating;
                          });
                        },
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

  Widget _buildColorPickerChip(Color color) {
    bool isSelected = _bubbleColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          _bubbleColor = color;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.teal : Colors.transparent,
            width: 2,
          ),
        ),
        child: CircleAvatar(
          backgroundColor: color,
          radius: 12,
        ),
      ),
    );
  }

  // TAB 2: Smart Clip Vault
  Widget _buildClipVaultTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Clipboard Stash',
            style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Paste quick snippet strings or phone numbers to hold temporary clips.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          // Fast Input Box
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _quickClipController,
                  decoration: const InputDecoration(
                    hintText: 'Paste link, code, address, or number...',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _pasteToClipVault,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
                icon: const Icon(Icons.add_link, color: Colors.white, size: 18),
                label: const Text(
                  'Stash',
                  style: TextStyle(color: Colors.white, FontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Card(
            color: Colors.teal.withOpacity(0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        '$_totalClipsCopied',
                        style: const TextStyle(
                          fontSize: 18,
                          FontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const Text(
                        'Clips Saved',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  Container(width: 1, height: 30, color: Colors.grey.withOpacity(0.3)),
                  const Column(
                    children: [
                      Text(
                        'Instant',
                        style: TextStyle(
                          fontSize: 18,
                          FontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      Text(
                        'Auto-Format',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _clipVault.length,
            itemBuilder: (context, index) {
              final clip = _clipVault[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(
                    clip.text,
                    style: const TextStyle(fontSize: 13, FontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            clip.tag,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.teal, size: 20),
                        onPressed: () => _copyToClipboard(clip.text),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.grey, size: 20),
                        onPressed: () {
                          setState(() {
                            _clipVault.removeAt(index);
                          });
                        },
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

  // TAB 3: Quick Chat Response Generator
  Widget _buildChatResponseTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Response & Template Builder',
            style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Pick quick pre-formatted templates to reply instantly across WhatsApp, IG, or SMS.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            children: _chatTemplates.keys.map((category) {
              final bool isSelected = category == _selectedChatCategory;
              return ChoiceChip(
                label: Text(category),
                selected: isSelected,
                selectedColor: Colors.teal,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                onSelected: (bool selected) {
                  if (selected) {
                    setState(() {
                      _selectedChatCategory = category;
                      _customizedReplyOutput =
                          _chatTemplates[category]![0];
                    });
                  }
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          const Text(
            'Select Template Sample:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),

          Column(
            children: _chatTemplates[_selectedChatCategory]!.map((template) {
              final bool isCurrent = _customizedReplyOutput == template;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? Colors.teal.withOpacity(0.1)
                      : Colors.white,
                  border: Border.all(
                    color: isCurrent ? Colors.teal : Colors.grey.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    template,
                    style: const TextStyle(fontSize: 13),
                  ),
                  trailing: Radio<String>(
                    value: template,
                    groupValue: _customizedReplyOutput,
                    activeColor: Colors.teal,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _customizedReplyOutput = val;
                        });
                      }
                    },
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Output Ready to Copy:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _customizedReplyOutput,
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _copyToClipboard(_customizedReplyOutput),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                          ),
                          icon: const Icon(Icons.copy,
                              color: Colors.white, size: 18),
                          label: const Text(
                            'Copy Text',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _stickies.insert(
                              0,
                              StickyNoteItem(
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                title: 'Quick Reply Template',
                                content: _customizedReplyOutput,
                                badgeColor: Colors.teal,
                                category: 'Reply',
                                isPinnedFloating: true,
                              ),
                            );
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pinned to Floating Stickies!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.push_pin, size: 18),
                        label: const Text('Pin HUD'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 4: Decision Spinner & Engagement Hub
  Widget _buildDecisionSpinnerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Micro-Decision Spinner',
            style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Can\'t decide what to do right now? Spin the instant wheel assistant.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          Center(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isSpinning ? Colors.amber : Colors.teal,
                    boxShadow: [
                      BoxShadow(
                        color: (_isSpinning ? Colors.amber : Colors.teal)
                            .withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 4,
                      )
                    ],
                  ),
                  child: Icon(
                    _isSpinning ? Icons.refresh : Icons.casino,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _decisionResult,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    FontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _spinDecision,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                  label: const Text(
                    'Spin Decision Engine',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),

          const Text(
            'Spinner Decision Pool:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _decisionOptions.map((opt) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  opt,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // TAB 5: Permissions & Floating Notifications Hub
  Widget _buildPermissionsHubTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Permissions & Overlay Setup',
            style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ensure full permission access so OverlayPocket can float over other apps.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Display Over Other Apps (Overlay)'),
                  subtitle: const Text('Allows floating bubble over WhatsApp & Browser'),
                  value: _overlayPermission,
                  activeColor: Colors.teal,
                  onChanged: (val) {
                    setState(() {
                      _overlayPermission = val;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Notification Bar Quick Control'),
                  subtitle: const Text('Shows active stickies in notification panel'),
                  value: _notificationPermission,
                  activeColor: Colors.teal,
                  onChanged: (val) {
                    setState(() {
                      _notificationPermission = val;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Clipboard Auto Stash Access'),
                  subtitle: const Text('Detect copied links automatically'),
                  value: _storagePermission,
                  activeColor: Colors.teal,
                  onChanged: (val) {
                    setState(() {
                      _storagePermission = val;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Card(
            color: Colors.amber.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.amber),
            ),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Note: Displaying over other apps keeps your context stickies and clip helper available 24/7 without closing your chat windows.',
                      style: TextStyle(fontSize: 12, color: Colors.black87),
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

  void _showAddStickyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add Floating Sticky'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title (e.g., Bank Acc, Phone)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _contentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Content to display on HUD',
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
              onPressed: _addNewStickyNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: const Text(
                'Save Sticky',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}