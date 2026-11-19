import 'package:flutter/material.dart';

void main() {
  runApp(const SmartFloatApp());
}

class SmartFloatApp extends StatelessWidget {
  const SmartFloatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartFloat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF12121D),
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
  final bool isPinned;

  SnippetItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.isPinned = false,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  
  // App State Variables
  bool _isOverlayEnabled = true;
  bool _isPrivacyShadeActive = false;
  double _privacyOpacity = 0.65;
  int _snippetsCopiedCount = 14;
  int _activeHoursCount = 3;

  // Floating HUD Sandbox position & state
  Offset _hudOffset = const Offset(20, 150);
  bool _isHudExpanded = false;
  String _activeHudTab = 'clips';

  // Quick Calculator state
  double _calcAmount = 1500.0;
  int _calcPeople = 3;
  double _calcTipPercent = 10.0;

  // Quick Sticky Note State
  final TextEditingController _quickNoteController = TextEditingController(
    text: 'Pay electricity bill before 5 PM! Account #984210',
  );

  // Snippet Vault List
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: '1',
      title: 'Bank Account Details',
      content: 'Bank: Commercial Bank\nAcc: 800-4592-110\nBranch: Main Metro',
      category: 'Banking',
      isPinned: true,
    ),
    SnippetItem(
      id: '2',
      title: 'Standard Work Reply',
      content: 'Hello! Thanks for reaching out. I am currently reviewing your request and will get back to you shortly.',
      category: 'Work',
      isPinned: true,
    ),
    SnippetItem(
      id: '3',
      title: 'Delivery Address',
      content: 'No. 42, St. Peters Lane, Apt 4B, Central District, Zip 10250',
      category: 'Personal',
      isPinned: false,
    ),
    SnippetItem(
      id: '4',
      title: 'Tax Identification ID',
      content: 'TIN-9948201-X9',
      category: 'Banking',
      isPinned: false,
    ),
  ];

  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _quickNoteController.dispose();
    super.dispose();
  }

  void _addSnippet(String title, String content, String category) {
    setState(() {
      _snippets.insert(
        0,
        SnippetItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          content: content,
          category: category,
        ),
      );
    });
  }

  void _copyToClipboard(String content) {
    setState(() {
      _snippetsCopiedCount++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard: "$content"'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.teal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Body Screens
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildSandboxTab(),
                _buildSnippetVaultTab(),
                _buildQuickToolsTab(),
                _buildOverlaySettingsTab(),
              ],
            ),
          ),

          // Privacy Screen Shelter Overlay Simulation
          if (_isPrivacyShadeActive)
            IgnorePointer(
              ignoring: false,
              child: Container(
                color: Colors.black.withOpacity(_privacyOpacity),
                child: SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.shield, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          const Text(
                            'Privacy Shade Active',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPrivacyShadeActive = false;
                              });
                            },
                            child: const Icon(Icons.close, color: Colors.white, size: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Simulated Interactive Floating Bubble HUD
          if (_isOverlayEnabled) _buildDraggableFloatingHud(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        backgroundColor: const Color(0xFF1B1B2B),
        indicatorColor: Colors.deepPurple.shade400,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.widgets),
            label: 'HUD Demo',
          ),
          NavigationDestination(
            icon: Icon(Icons.layers),
            label: 'Clip Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.build),
            label: 'Tools & Guard',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Overlay Control',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: HUD SANDBOX & INTERACTIVE PREVIEW ---
  Widget _buildSandboxTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(
            title: 'Floating Screen HUD',
            subtitle: 'Drag the dynamic bubble anywhere. Multi-task over any app seamlessly!',
            icon: Icons.stars,
            color: Colors.deepPurple,
          ),
          const SizedBox(height: 16),

          // Live Quick Stats Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.flash_on,
                  title: 'Clips Used',
                  value: '$_snippetsCopiedCount',
                  color: Colors.amber,
                ),
                _buildStatItem(
                  icon: Icons.schedule,
                  title: 'Active Time',
                  value: '${_activeHoursCount}h Today',
                  color: Colors.teal,
                ),
                _buildStatItem(
                  icon: Icons.shield,
                  title: 'Guard State',
                  value: _isPrivacyShadeActive ? 'ON' : 'Ready',
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Quick Actions & HUD Floating Deck',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade200,
            ),
          ),
          const SizedBox(height: 10),

          // Action Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _buildFeatureTile(
                title: 'Toggle Floating Bubble',
                subtitle: _isOverlayEnabled ? 'HUD Bubble Visible' : 'HUD Hidden',
                icon: Icons.phone_android,
                color: Colors.teal,
                onTap: () {
                  setState(() {
                    _isOverlayEnabled = !_isOverlayEnabled;
                  });
                },
              ),
              _buildFeatureTile(
                title: 'Privacy Screen Shade',
                subtitle: _isPrivacyShadeActive ? 'Active' : 'Tap to Activate',
                icon: Icons.visibility,
                color: Colors.amber,
                onTap: () {
                  setState(() {
                    _isPrivacyShadeActive = !_isPrivacyShadeActive;
                  });
                },
              ),
              _buildFeatureTile(
                title: 'Instant Calc Card',
                subtitle: 'Split Bills On-The-Go',
                icon: Icons.calculate,
                color: Colors.purple,
                onTap: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
              ),
              _buildFeatureTile(
                title: 'Quick Snippet Bank',
                subtitle: '${_snippets.length} Saved Items',
                icon: Icons.content_copy,
                color: Colors.blue,
                onTap: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Tutorial Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade900.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.deepPurple.shade400),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Why Users Love SmartFloat HUD:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Never switch apps while chatting or buying online to find account numbers.\n'
                  '• Use the floating shade to hide sensitive messages on buses or trains.\n'
                  '• Quick bill splitter overlay available on top of any shopping screen.',
                  style: TextStyle(fontSize: 13, height: 1.4, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: MULTI-CLIP & SNIPPET VAULT ---
  Widget _buildSnippetVaultTab() {
    final categories = ['All', 'Banking', 'Work', 'Personal'];
    final filteredSnippets = _snippets.where((item) {
      final matchesCat = _selectedCategory == 'All' || item.category == _selectedCategory;
      final matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.content.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCat && matchesSearch;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Snippet & Clip Vault',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Tap any item to copy instantly to clipboard',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton.filled(
                onPressed: () => _showAddSnippetDialog(),
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(backgroundColor: Colors.deepPurple),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Search Box
          TextField(
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search stored snippets...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF1E1E2E),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    selectedColor: Colors.deepPurple,
                    backgroundColor: const Color(0xFF1E1E2E),
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade300,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Snippet List
          Expanded(
            child: filteredSnippets.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.content_copy, size: 48, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'No snippets found',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredSnippets.length,
                    itemBuilder: (context, index) {
                      final item = filteredSnippets[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2E),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: item.isPinned ? Colors.deepPurple.shade400 : Colors.transparent,
                          ),
                        ),
                        child: ListTile,
                        contentPadding: const EdgeInsets.all(12),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item.category,
                                style: const TextStyle(fontSize: 10, color: Colors.deepPurpleAccent),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            item.content,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.share, color: Colors.teal, size: 20),
                              onPressed: () => _copyToClipboard(item.content),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                              onPressed: () {
                                setState(() {
                                  _snippets.removeWhere((s) => s.id == item.id);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // --- TAB 3: QUICK TOOLS & PRIVACY GUARD ---
  Widget _buildQuickToolsTab() {
    double perPerson = (_calcAmount + (_calcAmount * (_calcTipPercent / 100))) / _calcPeople;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(
            title: 'Floating Screen Tools',
            subtitle: 'On-demand utilities ready to overlay on any phone task.',
            icon: Icons.build,
            color: Colors.teal,
          ),
          const SizedBox(height: 20),

          // Split Bill & Tip Floating Tool
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.monetization_on, color: Colors.teal),
                    SizedBox(width: 8),
                    Text(
                      'Floating Split Bill & Tip Calc',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Amount (\$)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(10),
                            ),
                            controller: TextEditingController(text: _calcAmount.toStringAsFixed(0)),
                            onChanged: (val) {
                              final d = double.tryParse(val);
                              if (d != null) {
                                setState(() {
                                  _calcAmount = d;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('People: $_calcPeople', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          Slider(
                            value: _calcPeople.toDouble(),
                            min: 1,
                            max: 10,
                            divisions: 9,
                            activeColor: Colors.teal,
                            onChanged: (val) {
                              setState(() {
                                _calcPeople = val.toInt();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Each Person Pays:',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      Text(
                        '\$${perPerson.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.tealAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Privacy Guard Shade Controller
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.shield, color: Colors.amber),
                        SizedBox(width: 8),
                        Text(
                          'Screen Privacy Guard Shade',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    Switch(
                      value: _isPrivacyShadeActive,
                      activeColor: Colors.amber,
                      onChanged: (val) {
                        setState(() {
                          _isPrivacyShadeActive = val;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Adjust privacy opacity tint level:',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                ),
                Slider(
                  value: _privacyOpacity,
                  min: 0.2,
                  max: 0.95,
                  activeColor: Colors.amber,
                  onChanged: (val) {
                    setState(() {
                      _privacyOpacity = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Persistent Quick Note Field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.edit, color: Colors.deepPurpleAccent),
                    SizedBox(width: 8),
                    Text(
                      'Floating Scratchpad Note',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _quickNoteController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Type temporary notes here...',
                    filled: true,
                    fillColor: Color(0xFF12121D),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _copyToClipboard(_quickNoteController.text);
                    },
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Copy Note'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: OVERLAY PERMISSIONS & SYSTEM STATS ---
  Widget _buildOverlaySettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(
            title: 'System & Overlay Permissions',
            subtitle: 'Configure background floating widget capabilities',
            icon: Icons.settings,
            color: Colors.blue,
          ),
          const SizedBox(height: 20),

          // Status Badges
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildPermissionSwitch(
                  title: 'Display Over Other Apps',
                  description: 'Allows floating HUD bubble to stay visible on screen',
                  value: _isOverlayEnabled,
                  onChanged: (v) {
                    setState(() {
                      _isOverlayEnabled = v;
                    });
                  },
                ),
                const Divider(color: Colors.white70, height: 24),
                _buildPermissionSwitch(
                  title: 'Clipboard Quick Capture',
                  description: 'Auto-detect multi-clip items when copied',
                  value: true,
                  onChanged: (v) {},
                ),
                const Divider(color: Colors.white70, height: 24),
                _buildPermissionSwitch(
                  title: 'Background Service Persistent HUD',
                  description: 'Keep floating deck ready after app minimize',
                  value: true,
                  onChanged: (v) {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // User Engagement & Ad Retention Stats Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.shade900.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.shade400),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.stars, color: Colors.tealAccent),
                    SizedBox(width: 8),
                    Text(
                      'SmartFloat Productivity Pass',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your floating assistant is active! You saved an estimated 18 minutes today by avoiding app-switching context loss.',
                  style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.4),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: 0.75,
                  backgroundColor: Colors.black87,
                  color: Colors.tealAccent,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Daily Retention Level: High', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text('75% Goal Reached', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- INTERACTIVE DRAGGABLE FLOATING HUD WIDGET ---
  Widget _buildDraggableFloatingHud() {
    return Positioned(
      left: _hudOffset.dx,
      top: _hudOffset.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            final size = MediaQuery.of(context).size;
            double newX = _hudOffset.dx + details.delta.dx;
            double newY = _hudOffset.dy + details.delta.dy;
            // Clamp within screen boundaries
            newX = newX.clamp(10.0, size.width - 70.0);
            newY = newY.clamp(40.0, size.height - 120.0);
            _hudOffset = Offset(newX, newY);
          });
        },
        child: Material(
          elevation: 12,
          borderRadius: BorderRadius.circular(_isHudExpanded ? 20 : 30),
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: _isHudExpanded ? 280 : 56,
            height: _isHudExpanded ? 320 : 56,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E).withOpacity(0.95),
              borderRadius: BorderRadius.circular(_isHudExpanded ? 20 : 30),
              border: Border.all(color: Colors.deepPurpleAccent, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.5),
                  blurRadius: 12,
                  spreadRadius: 2,
                )
              ],
            ),
            child: _isHudExpanded ? _buildExpandedHudContent() : _buildCollapsedHudBubble(),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedHudBubble() {
    return InkWell(
      onTap: () {
        setState(() {
          _isHudExpanded = true;
        });
      },
      borderRadius: BorderRadius.circular(30),
      child: const Center(
        child: Icon(
          Icons.widgets,
          color: Colors.deepPurpleAccent,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildExpandedHudContent() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.widgets, color: Colors.deepPurpleAccent, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'SmartFloat Deck',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isHudExpanded = false;
                  });
                },
                child: const Icon(Icons.close, color: Colors.grey, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Mini Tab Selector
          Row(
            children: [
              _buildMiniHudTab('clips', 'Clips'),
              _buildMiniHudTab('calc', 'Calc'),
              _buildMiniHudTab('notes', 'Note'),
            ],
          ),
          const SizedBox(height: 8),

          // Mini Content Body
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF12121D),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _buildHudTabBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniHudTab(String id, String label) {
    final isSelected = _activeHudTab == id;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeHudTab = id;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: isSelected ? Colors.deepPurple : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHudTabBody() {
    if (_activeHudTab == 'clips') {
      return ListView.builder(
        itemCount: _snippets.length,
        itemBuilder: (context, i) {
          final item = _snippets[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 6),
            child: InkWell(
              onTap: () => _copyToClipboard(item.content),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  children: [
                    const Icon(Icons.content_copy, size: 14, color: Colors.tealAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else if (_activeHudTab == 'calc') {
      double quickSplit = _calcAmount / _calcPeople;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Quick Bill Splitter', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            '\$${quickSplit.toStringAsFixed(2)} / person',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.tealAccent),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 18),
                onPressed: () {
                  if (_calcPeople > 1) {
                    setState(() {
                      _calcPeople--;
                    });
                  }
                },
              ),
              Text('People: $_calcPeople', style: const TextStyle(fontSize: 12)),
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                onPressed: () {
                  setState(() {
                    _calcPeople++;
                  });
                },
              ),
            ],
          )
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Live Floating Note:', style: TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 4),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                _quickNoteController.text.isEmpty ? 'No notes added.' : _quickNoteController.text,
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      );
    }
  }

  // --- HELPER WIDGETS ---
  Widget _buildHeaderCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.7), color.withOpacity(0.3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white70,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildFeatureTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionSwitch({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                softWrap: true,
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          activeColor: Colors.deepPurpleAccent,
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _showAddSnippetDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String category = 'Banking';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E2E),
              title: const Text('Add Quick Snippet'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title (e.g. Bank Account)',
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
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Banking', 'Work', 'Personal'].map((c) {
                        return DropdownMenuItem(value: c, child: Text(c));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            category = val;
                          });
                        }
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
                  onPressed: () {
                    if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                      _addSnippet(titleController.text, contentController.text, category);
                      Navigator.pop(ctx);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                  child: const Text('Save Snippet', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}