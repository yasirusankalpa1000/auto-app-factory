import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ContextBubbleApp());
}

class ContextBubbleApp extends StatelessWidget {
  const ContextBubbleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ContextBubble',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const MainHubScreen(),
    );
  }
}

class SnippetItem {
  final String id;
  final String title;
  final String content;
  final String category;
  final bool isFavorite;

  SnippetItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.isFavorite = false,
  });
}

class MicroChoice {
  final String title;
  final int weight;

  MicroChoice({required this.title, this.weight = 1});
}

class MainHubScreen extends StatefulWidget {
  const MainHubScreen({Key? key}) : super(key: key);

  @override
  State<MainHubScreen> createState() => _MainHubScreenState();
}

class _MainHubScreenState extends State<MainHubScreen> {
  int _currentTabIndex = 0;
  
  // Floating overlay state
  bool _isBubbleEnabled = true;
  double _bubbleX = 20.0;
  double _bubbleY = 150.0;
  bool _isOverlayMenuOpen = false;
  String _activeNotificationToast = '';

  // Quick Snippets State
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: '1',
      title: 'Quick Home Address',
      content: '123 Innovation Drive, Tech Park, Suite 400',
      category: 'Address',
      isFavorite: true,
    ),
    SnippetItem(
      id: '2',
      title: 'Standard Email Response',
      content: 'Hi! Thanks for reaching out. I will review this and respond shortly.',
      category: 'Work',
      isFavorite: true,
    ),
    SnippetItem(
      id: '3',
      title: 'Wi-Fi Guest Password',
      content: 'SecureGuest2025!\$',
      category: 'Personal',
    ),
  ];

  // Micro Decision State
  final List<MicroChoice> _decisionChoices = [
    MicroChoice(title: 'Order Healthy Salad', weight: 2),
    MicroChoice(title: 'Cook Home Meal', weight: 3),
    MicroChoice(title: 'Grab Fast Food', weight: 1),
  ];
  String _spinResult = 'Tap Spin to Decide!';
  bool _isSpinning = false;

  // Floating scratchpad note
  String _floatingScratchText = 'Type quick reminders here...';
  final TextEditingController _scratchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scratchController.text = _floatingScratchText;
  }

  @override
  void dispose() {
    _scratchController.dispose();
    super.dispose();
  }

  void _triggerFloatingToast(String message) {
    setState(() {
      _activeNotificationToast = message;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _activeNotificationToast == message) {
        setState(() {
          _activeNotificationToast = '';
        });
      }
    });
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    _triggerFloatingToast('Copied $label to clipboard!');
  }

  void _spinDecisionWheel() {
    if (_decisionChoices.isEmpty || _isSpinning) return;
    setState(() {
      _isSpinning = true;
      _spinResult = 'Spinning options...';
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      final random = math.Random();
      final selected = _decisionChoices[random.nextInt(_decisionChoices.length)];
      setState(() {
        _isSpinning = false;
        _spinResult = selected.title;
      });
      _triggerFloatingToast('Decision: ${selected.title}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.bubble_chart, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'ContextBubble',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isBubbleEnabled ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            tooltip: 'Toggle Floating Assistant Bubble',
            onPressed: () {
              setState(() {
                _isBubbleEnabled = !_isBubbleEnabled;
              });
              _triggerFloatingToast(
                _isBubbleEnabled ? 'Floating Bubble Activated' : 'Floating Bubble Hidden',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            tooltip: 'Test Floating Banner Alert',
            onPressed: () {
              _triggerFloatingToast('⚡ Dynamic Overlay Alert: Keep going!');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main Body Screens based on Tab
          SafeArea(
            child: IndexedStack(
              index: _currentTabIndex,
              children: [
                _buildFloatingDockHubTab(),
                _buildSnippetVaultTab(),
                _buildDecisionEngineTab(),
                _buildOverlaySettingsTab(),
              ],
            ),
          ),

          // Dynamic Floating Top Notification Banner
          if (_activeNotificationToast.isNotEmpty)
            Positioned(
              top: 10,
              left: 16,
              right: 16,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                color: Colors.indigo,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.bolt, color: Colors.amber),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _activeNotificationToast,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.close, color: Colors.white, size: 18),
                        onPressed: () {
                          setState(() {
                            _activeNotificationToast = '';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Movable Interactive System Overlay Simulation Bubble
          if (_isBubbleEnabled)
            Positioned(
              left: _bubbleX,
              top: _bubbleY,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubbleX = (_bubbleX + details.delta.dx)
                        .clamp(10.0, screenSize.width - 70.0);
                    _bubbleY = (_bubbleY + details.delta.dy)
                        .clamp(60.0, screenSize.height - 150.0);
                  });
                },
                onTap: () {
                  setState(() {
                    _isOverlayMenuOpen = !_isOverlayMenuOpen;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black87,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Icon(
                          _isOverlayMenuOpen ? Icons.close : Icons.bubble_chart,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Drag Me',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Quick Floating Overlay Action Menu
          if (_isBubbleEnabled && _isOverlayMenuOpen)
            Positioned(
              left: math.min(_bubbleX, screenSize.width - 240.0),
              top: math.min(_bubbleY + 65.0, screenSize.height - 250.0),
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                child: Container(
                  width: 220,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.indigo.withOpacity(0.2)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Floating Overlay Actions',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.indigo,
                        ),
                      ),
                      const Divider(height: 12),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.content_copy, color: Colors.indigo, size: 20),
                        title: const Text('Quick Snippet Copy', style: TextStyle(fontSize: 12)),
                        onTap: () {
                          if (_snippets.isNotEmpty) {
                            _copyToClipboard(_snippets.first.content, _snippets.first.title);
                          }
                          setState(() {
                            _isOverlayMenuOpen = false;
                          });
                        },
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.refresh, color: Colors.indigo, size: 20),
                        title: const Text('Instant Decision Wheel', style: TextStyle(fontSize: 12)),
                        onTap: () {
                          _spinDecisionWheel();
                          setState(() {
                            _isOverlayMenuOpen = false;
                          });
                        },
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.edit, color: Colors.indigo, size: 20),
                        title: const Text('Scratchpad Memo', style: TextStyle(fontSize: 12)),
                        onTap: () {
                          setState(() {
                            _isOverlayMenuOpen = false;
                            _currentTabIndex = 0;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
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
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Floating Dock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy),
            label: 'Snippets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stars),
            label: 'Decisions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Overlay Studio',
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating Dock & Quick Scratchpad Hub
  Widget _buildFloatingDockHubTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Status
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.indigo,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.flash_on, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'Floating Overlay Active',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your dynamic assistant bubble is ready on screen. Drag it anywhere or tap it for micro-utilities while using other apps.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Floating Scratchpad Memory
          const Text(
            'Floating Scratchpad & Sticky Note',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _scratchController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Type fast notes, addresses, temporary codes...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      _floatingScratchText = val;
                    },
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.content_copy, size: 16),
                        label: const Text('Copy Note'),
                        onPressed: () {
                          _copyToClipboard(_scratchController.text, 'Scratchpad Note');
                        },
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.delete, size: 16),
                        label: const Text('Clear'),
                        onPressed: () {
                          setState(() {
                            _scratchController.clear();
                            _floatingScratchText = '';
                          });
                          _triggerFloatingToast('Scratchpad Cleared');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Quick Access Snippets Grid
          const Text(
            'Quick Floating Launchers',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildLauncherChip(
                icon: Icons.shield,
                label: 'Display Over Apps',
                color: Colors.teal,
                onTap: () {
                  _triggerFloatingToast('Overlay Display Status: Active & Permitted');
                },
              ),
              _buildLauncherChip(
                icon: Icons.bolt,
                label: 'Quick Copy Top Snippet',
                color: Colors.indigo,
                onTap: () {
                  if (_snippets.isNotEmpty) {
                    _copyToClipboard(_snippets.first.content, _snippets.first.title);
                  }
                },
              ),
              _buildLauncherChip(
                icon: Icons.refresh,
                label: 'Spin Choice',
                color: Colors.orange,
                onTap: _spinDecisionWheel,
              ),
              _buildLauncherChip(
                icon: Icons.notifications,
                label: 'Test Toast Alert',
                color: Colors.purple,
                onTap: () {
                  _triggerFloatingToast('✨ Dynamic Smart Notification Triggered!');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLauncherChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ActionChip(
      avatar: Icon(icon, color: Colors.white, size: 16),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      backgroundColor: color,
      onPressed: onTap,
    );
  }

  // TAB 2: Snippet & Clipboard Vault
  Widget _buildSnippetVaultTab() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedCategory = 'Personal';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Clipboard Snippet Vault',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add New'),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                          top: 16,
                          left: 16,
                          right: 16,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Add Quick Vault Snippet',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                  labelText: 'Title (e.g. Wi-Fi Pass, Email Template)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: contentController,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  labelText: 'Snippet Content',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (titleController.text.isNotEmpty &&
                                        contentController.text.isNotEmpty) {
                                      setState(() {
                                        _snippets.add(
                                          SnippetItem(
                                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                                            title: titleController.text,
                                            content: contentController.text,
                                            category: selectedCategory,
                                          ),
                                        );
                                      });
                                      Navigator.pop(context);
                                      _triggerFloatingToast('Snippet added to Floating Vault!');
                                    }
                                  },
                                  child: const Text('Save Snippet'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (_snippets.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No snippets added yet. Tap Add New above!'),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _snippets.length,
              itemBuilder: (context, index) {
                final item = _snippets[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        item.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.content_copy, color: Colors.indigo),
                          tooltip: 'Copy to Clipboard',
                          onPressed: () {
                            _copyToClipboard(item.content, item.title);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.grey),
                          tooltip: 'Delete Snippet',
                          onPressed: () {
                            setState(() {
                              _snippets.removeAt(index);
                            });
                            _triggerFloatingToast('Snippet removed');
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

  // TAB 3: Micro-Decision Matrix & Choice Wheel
  Widget _buildDecisionEngineTab() {
    final choiceController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Decision Picker Engine',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Stuck on daily dilemmas? Add options and let ContextBubble pick instantly!',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Decision Spinner Display Card
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.white,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Icon(Icons.stars, color: Colors.indigo, size: 48),
                  const SizedBox(height: 12),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _spinResult,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _isSpinning ? Colors.orange : Colors.indigo,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    icon: Icon(_isSpinning ? Icons.refresh : Icons.play_arrow),
                    label: Text(_isSpinning ? 'Selecting...' : 'Spin Decision Wheel'),
                    onPressed: _isSpinning ? null : _spinDecisionWheel,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Choice Management
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Options List',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                '${_decisionChoices.length} items',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: choiceController,
                  decoration: const InputDecoration(
                    hintText: 'Add new option (e.g. Take Walk)',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onPressed: () {
                  if (choiceController.text.isNotEmpty) {
                    setState(() {
                      _decisionChoices.add(MicroChoice(title: choiceController.text));
                    });
                    choiceController.clear();
                    _triggerFloatingToast('Option added to Decision Engine');
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _decisionChoices.length,
            itemBuilder: (context, index) {
              final choice = _decisionChoices[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.withOpacity(0.1),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.indigo, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(choice.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey, size: 18),
                    onPressed: () {
                      setState(() {
                        _decisionChoices.removeAt(index);
                      });
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

  // TAB 4: Floating Overlay Settings & Notification Studio
  Widget _buildOverlaySettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating System & Overlay Studio',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Customize phone overlay interaction behavior and floating alerts.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          Card(
            child: Column(
              children: [
                SwitchListTile(
                  activeColor: Colors.indigo,
                  title: const Text('Enable Floating Assistant Bubble', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Keeps bubble active over all screens', style: TextStyle(fontSize: 12)),
                  value: _isBubbleEnabled,
                  onChanged: (val) {
                    setState(() {
                      _isBubbleEnabled = val;
                    });
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.shield, color: Colors.indigo),
                  title: const Text('Display Over Other Apps Permission', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('System permission active', style: TextStyle(fontSize: 12)),
                  trailing: const Chip(
                    label: Text('Granted', style: TextStyle(color: Colors.white, fontSize: 10)),
                    backgroundColor: Colors.teal,
                  ),
                  onTap: () {
                    _triggerFloatingToast('Permission Status: Granted and verified.');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.indigo),
                  title: const Text('Heads-Up Floating Alerts', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Display smart top banners for copy actions', style: TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.check_circle, color: Colors.teal),
                  onTap: () {
                    _triggerFloatingToast('Floating alerts are enabled globally.');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Daily Engagement Stats',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Snippets Saved', '${_snippets.length}', Colors.indigo),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard('Decisions Made', '${_decisionChoices.length}', Colors.purple),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}