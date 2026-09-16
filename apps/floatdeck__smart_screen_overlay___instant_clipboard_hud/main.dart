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
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0E17),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentTabIndex = 0;

  // Floating HUD State
  bool _isOverlayActive = true;
  double _bubbleOpacity = 0.9;
  Color _bubbleThemeColor = Colors.deepPurple;
  Offset _bubblePosition = const Offset(120, 150);
  bool _isBubbleExpanded = false;

  // Clipboard Stash Data
  final List<Map<String, dynamic>> _stashList = [
    {
      'id': '1',
      'title': 'Shopping Discount Code',
      'content': 'SAVE50NOW - Apply at checkout for \$50 off',
      'category': 'Promo',
      'pinned': true,
      'date': 'Just now'
    },
    {
      'id': '2',
      'title': 'Client Phone & Wire info',
      'content': '+1 (555) 019-2834 | Account: 883920192',
      'category': 'Contact',
      'pinned': true,
      'date': '10 mins ago'
    },
    {
      'id': '3',
      'title': 'Reference Article Link',
      'content': 'https://flutter.dev/docs/development/ui/widgets',
      'category': 'URL',
      'pinned': false,
      'date': '1 hr ago'
    },
    {
      'id': '4',
      'title': 'Meeting Key Points',
      'content': '1. Review Q3 budget\n2. Approve marketing banner\n3. Launch overlay updates',
      'category': 'Note',
      'pinned': false,
      'date': 'Yesterday'
    },
  ];

  // Micro Tool Logic States
  double _baseAmount = 100.0;
  double _taxPercent = 15.0;
  double _discountPercent = 10.0;
  
  double _prompterSpeed = 2.0;
  bool _isPrompterRunning = false;
  final TextEditingController _prompterTextController = TextEditingController(
    text: "Welcome to FloatDeck! Keeping your essential tools floating right above all apps makes workflow 10x faster and context switching zero...",
  );

  // Permission States
  bool _permDisplayOverApps = true;
  bool _permNotificationAccess = true;
  bool _permAutoCopyDetect = true;

  @override
  void dispose() {
    _prompterTextController.dispose();
    super.dispose();
  }

  void _addNewStashItem(String title, String content, String category) {
    setState(() {
      _stashList.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': title.isEmpty ? 'Quick Clip' : title,
        'content': content,
        'category': category,
        'pinned': false,
        'date': 'Just now',
      });
    });
  }

  void _togglePin(String id) {
    setState(() {
      final index = _stashList.indexWhere((item) => item['id'] == id);
      if (index != -1) {
        _stashList[index]['pinned'] = !(_stashList[index]['pinned'] as bool);
      }
    });
  }

  void _deleteStashItem(String id) {
    setState(() {
      _stashList.removeWhere((item) => item['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161524),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.layers, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'FloatDeck HUD',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: FilterChip(
              selected: _isOverlayActive,
              label: Text(_isOverlayActive ? 'HUD Active' : 'HUD Off'),
              avatar: Icon(
                _isOverlayActive ? Icons.check_circle : Icons.pause_circle_filled,
                color: _isOverlayActive ? Colors.green : Colors.grey,
                size: 16,
              ),
              onSelected: (val) {
                setState(() {
                  _isOverlayActive = val;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _isOverlayActive
                          ? 'Floating Overlay Engine Activated!'
                          : 'Overlay Service Suspended.',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentTabIndex,
          children: [
            _buildFloatingHudTab(),
            _buildSmartStashTab(),
            _buildMicroToolsTab(),
            _buildPermissionsTab(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTabIndex,
        backgroundColor: const Color(0xFF161524),
        indicatorColor: Colors.deepPurple,
        onDestinationSelected: (idx) {
          setState(() {
            _currentTabIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.widgets_outlined),
            selectedIcon: Icon(Icons.widgets, color: Colors.white),
            label: 'HUD Simulator',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_paste_go_outlined),
            selectedIcon: Icon(Icons.content_paste_go, color: Colors.white),
            label: 'Clip Stash',
          ),
          NavigationDestination(
            icon: Icon(Icons.speed_outlined),
            selectedIcon: Icon(Icons.speed, color: Colors.white),
            label: 'Micro Tools',
          ),
          NavigationDestination(
            icon: Icon(Icons.security_outlined),
            selectedIcon: Icon(Icons.security, color: Colors.white),
            label: 'Permissions',
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating Overlay HUD Live Playground
  Widget _buildFloatingHudTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Interactive Phone Screen Overlay Simulator',
            'Drag the floating bubble around to test overlay responsiveness',
          ),
          const SizedBox(height: 12),
          // Interactive Phone Canvas Area
          Container(
            height: 340,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1D1B2A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.deepPurple.withOpacity(0.4), width: 2),
            ),
            child: Stack(
              children: [
                // Background Apps Simulation Artwork
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              radius: 14,
                              child: Icon(Icons.public, size: 16, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'Simulated Browser / Social Media App',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                // Active Interactive Draggable Bubble Simulation
                if (_isOverlayActive)
                  Positioned(
                    left: _bubblePosition.dx,
                    top: _bubblePosition.dy,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          double newX = _bubblePosition.dx + details.delta.dx;
                          double newY = _bubblePosition.dy + details.delta.dy;
                          // Constrain inside bounds
                          newX = newX.clamp(10.0, 260.0);
                          newY = newY.clamp(10.0, 260.0);
                          _bubblePosition = Offset(newX, newY);
                        });
                      },
                      onTap: () {
                        setState(() {
                          _isBubbleExpanded = !_isBubbleExpanded;
                        });
                      },
                      child: Opacity(
                        opacity: _bubbleOpacity,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(10),
                          width: _isBubbleExpanded ? 200 : 54,
                          height: _isBubbleExpanded ? 160 : 54,
                          decoration: BoxDecoration(
                            color: _bubbleThemeColor,
                            borderRadius: BorderRadius.circular(_isBubbleExpanded ? 16 : 27),
                            boxShadow: [
                              BoxShadow(
                                color: _bubbleThemeColor.withOpacity(0.6),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: _isBubbleExpanded
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'FloatDeck HUD',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isBubbleExpanded = false;
                                            });
                                          },
                                          child: const Icon(Icons.close, size: 16, color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                    const Divider(color: Colors.white70, height: 12),
                                    const Text(
                                      'Pinned Quick Note:',
                                      style: TextStyle(fontSize: 10, color: Colors.white70),
                                    ),
                                    const Text(
                                      'SAVE50NOW (\$50 Discount)',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildMiniIconButton(Icons.copy, 'Copy'),
                                        _buildMiniIconButton(Icons.calculate, 'Calc'),
                                        _buildMiniIconButton(Icons.play_arrow, 'Script'),
                                      ],
                                    )
                                  ],
                                )
                              : const Center(
                                  child: Icon(Icons.layers, color: Colors.white, size: 24),
                                ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          _buildSectionHeader('Floating Controls & Appearance', 'Customize how your HUD behaves on top of apps'),
          const SizedBox(height: 12),

          // HUD Customizer Deck Card
          Card(
            color: const Color(0xFF161524),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Bubble Opacity', style: TextStyle(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text('${(_bubbleOpacity * 100).toInt()}%', style: const TextStyle(color: Colors.deepPurpleAccent)),
                    ],
                  ),
                  Slider(
                    value: _bubbleOpacity,
                    min: 0.3,
                    max: 1.0,
                    activeColor: Colors.deepPurpleAccent,
                    onChanged: (val) {
                      setState(() {
                        _bubbleOpacity = val;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Bubble Theme Color', style: TextStyle(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildColorSelector(Colors.deepPurple),
                          _buildColorSelector(Colors.teal),
                          _buildColorSelector(Colors.deepOrange),
                          _buildColorSelector(Colors.indigo),
                        ],
                      )
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

  // TAB 2: Smart Clipboard Stash & Content Parser
  Widget _buildSmartStashTab() {
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
                  const Text(
                    'Smart Clipboard Stash',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _showAddClipDialog(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Clip'),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Auto-organized text clips ready to float on screen',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _stashList.length,
            itemBuilder: (context, index) {
              final item = _stashList[index];
              final isPinned = item['pinned'] as bool;
              return Card(
                color: const Color(0xFF161524),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: isPinned
                      ? const BorderSide(color: Colors.deepPurpleAccent, width: 1.5)
                      : BorderSide.none,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(item['category'] as String).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item['category'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _getCategoryColor(item['category'] as String),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item['title'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                              color: isPinned ? Colors.amber : Colors.grey,
                              size: 18,
                            ),
                            onPressed: () => _togglePin(item['id'] as String),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 18),
                            onPressed: () => _deleteStashItem(item['id'] as String),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['content'] as String,
                          style: const TextStyle(fontSize: 13, color: Colors.white70),
                          softWrap: true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['date'] as String,
                            style: const TextStyle(fontSize: 10, color: Colors.white70),
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              foregroundColor: Colors.deepPurpleAccent,
                              side: const BorderSide(color: Colors.deepPurpleAccent),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Pinned "${item['title']}" to Floating HUD!'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            icon: const Icon(Icons.layers, size: 14),
                            label: const Text('Float This', style: TextStyle(fontSize: 11)),
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

  // TAB 3: Floating Micro Tools (Price/Tax Math HUD & Prompter Deck)
  Widget _buildMicroToolsTab() {
    double totalTax = _baseAmount * (_taxPercent / 100);
    double totalDiscount = _baseAmount * (_discountPercent / 100);
    double finalPrice = _baseAmount + totalTax - totalDiscount;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Floating Quick Math & Tax Calculator HUD', 'Calculate net prices & tips instantly while browsing online stores'),
          const SizedBox(height: 12),

          Card(
            color: const Color(0xFF161524),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Base Item Price:', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(
                        width: 120,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent),
                          decoration: const InputDecoration(
                            prefixText: '\$',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            setState(() {
                              _baseAmount = double.tryParse(val) ?? 0.0;
                            });
                          },
                          controller: TextEditingController(text: _baseAmount.toStringAsFixed(0)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('Tax Rate (${_taxPercent.toInt()}%)'),
                      Expanded(
                        child: Slider(
                          value: _taxPercent,
                          min: 0,
                          max: 30,
                          activeColor: Colors.deepOrangeAccent,
                          onChanged: (val) {
                            setState(() {
                              _taxPercent = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Discount (${_discountPercent.toInt()}%)'),
                      Expanded(
                        child: Slider(
                          value: _discountPercent,
                          min: 0,
                          max: 50,
                          activeColor: Colors.tealAccent,
                          onChanged: (val) {
                            setState(() {
                              _discountPercent = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white70, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Estimated Final Cost:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      Text(
                        '\$${finalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.amberAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          _buildSectionHeader('Floating Script Reader & Prompter', 'Read script cards in a mini transparent card while recording videos'),
          const SizedBox(height: 12),

          Card(
            color: const Color(0xFF161524),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _prompterTextController,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Enter text to script prompt...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Scroll Speed', style: TextStyle(fontSize: 12)),
                      Expanded(
                        child: Slider(
                          value: _prompterSpeed,
                          min: 1.0,
                          max: 5.0,
                          onChanged: (val) {
                            setState(() {
                              _prompterSpeed = val;
                            });
                          },
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isPrompterRunning ? Colors.redAccent : Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPrompterRunning = !_isPrompterRunning;
                          });
                        },
                        icon: Icon(_isPrompterRunning ? Icons.pause : Icons.play_arrow),
                        label: Text(_isPrompterRunning ? 'Pause' : 'Start Prompt'),
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

  // TAB 4: System Permissions & Overlay Settings
  Widget _buildPermissionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('System Permissions & Overlay Access', 'FloatDeck requires background overlay access to render widgets over other apps'),
          const SizedBox(height: 16),

          Card(
            color: const Color(0xFF161524),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.picture_in_picture, color: Colors.deepPurpleAccent),
                  title: const Text('Display Over Other Apps'),
                  subtitle: const Text('Allows floating bubble to remain visible on home screen and apps'),
                  value: _permDisplayOverApps,
                  activeColor: Colors.deepPurpleAccent,
                  onChanged: (val) {
                    setState(() {
                      _permDisplayOverApps = val;
                    });
                  },
                ),
                const Divider(color: Colors.white70, height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_active, color: Colors.tealAccent),
                  title: const Text('Smart Notification Listener'),
                  subtitle: const Text('Auto-detects copied codes & tracking links from notifications'),
                  value: _permNotificationAccess,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() {
                      _permNotificationAccess = val;
                    });
                  },
                ),
                const Divider(color: Colors.white70, height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.content_paste, color: Colors.amberAccent),
                  title: const Text('Auto Copy Detection'),
                  subtitle: const Text('Automatically prompts clip stash when text is copied to clipboard'),
                  value: _permAutoCopyDetect,
                  activeColor: Colors.amberAccent,
                  onChanged: (val) {
                    setState(() {
                      _permAutoCopyDetect = val;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Card(
            color: const Color(0xFF1D1B2A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blueAccent, size: 28),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'All clipboard data and overlay configurations are processed locally on your phone for 100% privacy.',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
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

  // Helper Widget Builders
  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildColorSelector(Color color) {
    bool isSelected = _bubbleThemeColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          _bubbleThemeColor = color;
        });
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
      ),
    );
  }

  Widget _buildMiniIconButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: Colors.white70,
          child: Icon(icon, size: 14, color: Colors.white),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 9, color: Colors.white70),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Promo':
        return Colors.amber;
      case 'Contact':
        return Colors.tealAccent;
      case 'URL':
        return Colors.blueAccent;
      default:
        return Colors.purpleAccent;
    }
  }

  void _showAddClipDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedCategory = 'Note';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF161524),
          title: const Text('Add New Clip to Stash'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Clip Label / Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Text Content',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  dropdownColor: const Color(0xFF161524),
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Note', 'Promo', 'Contact', 'URL']
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) selectedCategory = val;
                  },
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              onPressed: () {
                if (contentController.text.isNotEmpty) {
                  _addNewStashItem(titleController.text, contentController.text, selectedCategory);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Save Clip', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}