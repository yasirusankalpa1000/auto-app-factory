import 'package:flutter/material.dart';

void main() {
  runApp(const LifeHUDApp());
}

class LifeHUDApp extends StatelessWidget {
  const LifeHUDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeHUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        cardColor: const Color(0xFF1E293B),
        colorScheme: const ColorScheme.dark(
          primary: Colors.indigo,
          secondary: Colors.teal,
          surface: Color(0xFF1E293B),
        ),
        useMaterial3: true,
      ),
      home: const MainHUDNavigationScreen(),
    );
  }
}

class MainHUDNavigationScreen extends StatefulWidget {
  const MainHUDNavigationScreen({super.key});

  @override
  State<MainHUDNavigationScreen> createState() => _MainHUDNavigationScreenState();
}

class _MainHUDNavigationScreenState extends State<MainHUDNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HUDControlTab(),
    DecisionMatrixTab(),
    SnipVaultTab(),
    ActivityDeckTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF0F172A),
        indicatorColor: Colors.indigo,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.widgets, color: Colors.white70),
            selectedIcon: Icon(Icons.widgets, color: Colors.white),
            label: 'Floating HUD',
          ),
          NavigationDestination(
            icon: Icon(Icons.compare_arrows, color: Colors.white70),
            selectedIcon: Icon(Icons.compare_arrows, color: Colors.white),
            label: 'Decider',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_copy, color: Colors.white70),
            selectedIcon: Icon(Icons.content_copy, color: Colors.white),
            label: 'Snip Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard, color: Colors.white70),
            selectedIcon: Icon(Icons.dashboard, color: Colors.white),
            label: 'Active Deck',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 1: FLOATING HUD OVERLAY & SIMULATOR
// -----------------------------------------------------------------------------
class HUDControlTab extends StatefulWidget {
  const HUDControlTab({super.key});

  @override
  State<HUDControlTab> createState() => _HUDControlTabState();
}

class _HUDControlTabState extends State<HUDControlTab> {
  bool _isOverlayEnabled = true;
  bool _showNotificationBanner = true;
  double _overlayOpacity = 0.85;
  Offset _bubblePosition = const Offset(120, 180);
  String _activeTool = 'Quick Snips';

  final List<String> _tools = [
    'Quick Snips',
    'Decision Matrix',
    'Instant Tally',
    'Emergency Alert',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'LifeHUD Overlay Engine',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'System-wide Floating Quick Assistant',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _isOverlayEnabled ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isOverlayEnabled ? Colors.green : Colors.red,
                  ),
                ),
                child: Text(
                  _isOverlayEnabled ? 'ACTIVE' : 'OFFLINE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _isOverlayEnabled ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Master Switch Card
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text(
                      'Display Floating Bubble Over Apps',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Grant overlay & notification permission for instant background access',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    value: _isOverlayEnabled,
                    activeColor: Colors.teal,
                    onChanged: (val) {
                      setState(() {
                        _isOverlayEnabled = val;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(val ? 'Floating Overlay Activated!' : 'Floating Overlay Disabled'),
                          backgroundColor: val ? Colors.teal : Colors.grey,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  const Divider(color: Colors.white70),
                  SwitchListTile(
                    title: const Text(
                      'Persistent Floating Notification Bar',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Quick action triggers pinned to status bar',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    value: _showNotificationBanner,
                    activeColor: Colors.indigo,
                    onChanged: (val) {
                      setState(() {
                        _showNotificationBanner = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'Interactive HUD Live Screen Simulator',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'Drag the floating HUD bubble around the simulated phone screen below:',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          // Simulated Phone Viewport
          Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF020617),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.indigo.withOpacity(0.5), width: 2),
            ),
            child: Stack(
              children: [
                // Simulated Background Wallpaper / Apps
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone_android, size: 48, color: Colors.indigo.withOpacity(0.3)),
                      const SizedBox(height: 8),
                      Text(
                        'Simulated Screen Surface\nActive Tool: $_activeTool',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildMiniAppIcon(Icons.chat, 'Messages', Colors.blue),
                          _buildMiniAppIcon(Icons.shopping_cart, 'Store', Colors.orange),
                          _buildMiniAppIcon(Icons.camera_alt, 'Camera', Colors.purple),
                          _buildMiniAppIcon(Icons.map, 'Maps', Colors.green),
                        ],
                      ),
                    ],
                  ),
                ),

                // Simulated Dynamic Floating Notification Popup
                if (_showNotificationBanner)
                  Positioned(
                    top: 10,
                    left: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.notifications_active, size: 16, color: Colors.amber),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'LifeHUD Active: Ready for quick screen capture & snips',
                              style: TextStyle(fontSize: 11, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Draggable Floating HUD Bubble Component
                if (_isOverlayEnabled)
                  Positioned(
                    left: _bubblePosition.dx,
                    top: _bubblePosition.dy,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          double newX = _bubblePosition.dx + details.delta.dx;
                          double newY = _bubblePosition.dy + details.delta.dy;
                          // Keep inside viewport bounds
                          newX = newX.clamp(10.0, 260.0);
                          newY = newY.clamp(40.0, 210.0);
                          _bubblePosition = Offset(newX, newY);
                        });
                      },
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('HUD Bubble Pressed! Quick Tool Launcher Opened: $_activeTool'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Opacity(
                        opacity: _overlayOpacity,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.teal.withOpacity(0.5),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.flash_on, color: Colors.white, size: 28),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Customization Controls
          const Text(
            'HUD Floating Options',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          Card(
            color: const Color(0xFF1E293B),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Bubble Transparency:', style: TextStyle(color: Colors.white)),
                      Text('${(_overlayOpacity * 100).round()}%', style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: _overlayOpacity,
                    min: 0.3,
                    max: 1.0,
                    activeColor: Colors.teal,
                    onChanged: (val) {
                      setState(() {
                        _overlayOpacity = val;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text('Default Floating Tool:', style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _tools.map((tool) {
                      final isSelected = tool == _activeTool;
                      return ChoiceChip(
                        label: Text(tool),
                        selected: isSelected,
                        selectedColor: Colors.indigo,
                        backgroundColor: const Color(0xFF0F172A),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _activeTool = tool;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniAppIcon(IconData icon, String name, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 2: SMART DECISION MATRIX COMPARATOR ENGINE
// -----------------------------------------------------------------------------
class DecisionMatrixTab extends StatefulWidget {
  const DecisionMatrixTab({super.key});

  @override
  State<DecisionMatrixTab> createState() => _DecisionMatrixTabState();
}

class _DecisionMatrixTabState extends State<DecisionMatrixTab> {
  final TextEditingController _item1Controller = TextEditingController(text: 'Option A (e.g. Phone A)');
  final TextEditingController _item2Controller = TextEditingController(text: 'Option B (e.g. Phone B)');

  // Item 1 ratings (1-10)
  double _item1PriceScore = 7;
  double _item1NeedScore = 8;
  double _item1QualityScore = 6;

  // Item 2 ratings (1-10)
  double _item2PriceScore = 5;
  double _item2NeedScore = 6;
  double _item2QualityScore = 9;

  @override
  void dispose() {
    _item1Controller.dispose();
    _item2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Math calculation for best recommendation
    double score1 = (_item1PriceScore * 0.3) + (_item1NeedScore * 0.4) + (_item1QualityScore * 0.3);
    double score2 = (_item2PriceScore * 0.3) + (_item2NeedScore * 0.4) + (_item2QualityScore * 0.3);

    String winnerName = 'Equal Choice';
    double totalCombined = score1 + score2;
    double percentage1 = totalCombined > 0 ? (score1 / totalCombined) * 100 : 50;
    double percentage2 = totalCombined > 0 ? (score2 / totalCombined) * 100 : 50;

    if (score1 > score2) {
      winnerName = _item1Controller.text.isNotEmpty ? _item1Controller.text : 'Option A';
    } else if (score2 > score1) {
      winnerName = _item2Controller.text.isNotEmpty ? _item2Controller.text : 'Option B';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Decision Matrix',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Stuck between two daily options or purchases? Score them objectively:',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Decision Recommendation Result Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade900, const Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 28),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'AI Recommendation: $winnerName',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${percentage1.toStringAsFixed(1)}%',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                          Text(
                            _item1Controller.text.isEmpty ? 'Option A' : _item1Controller.text,
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Text('VS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${percentage2.toStringAsFixed(1)}%',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigoAccent),
                          ),
                          Text(
                            _item2Controller.text.isEmpty ? 'Option B' : _item2Controller.text,
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Input for Option A
          _buildOptionCard(
            title: 'Option A Configuration',
            color: Colors.teal,
            controller: _item1Controller,
            priceScore: _item1PriceScore,
            needScore: _item1NeedScore,
            qualityScore: _item1QualityScore,
            onPriceChanged: (v) => setState(() => _item1PriceScore = v),
            onNeedChanged: (v) => setState(() => _item1NeedScore = v),
            onQualityChanged: (v) => setState(() => _item1QualityScore = v),
          ),

          const SizedBox(height: 16),

          // Input for Option B
          _buildOptionCard(
            title: 'Option B Configuration',
            color: Colors.indigoAccent,
            controller: _item2Controller,
            priceScore: _item2PriceScore,
            needScore: _item2NeedScore,
            qualityScore: _item2QualityScore,
            onPriceChanged: (v) => setState(() => _item2PriceScore = v),
            onNeedChanged: (v) => setState(() => _item2NeedScore = v),
            onQualityChanged: (v) => setState(() => _item2QualityScore = v),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required Color color,
    required TextEditingController controller,
    required double priceScore,
    required double needScore,
    required double qualityScore,
    required ValueChanged<double> onPriceChanged,
    required ValueChanged<double> onNeedChanged,
    required ValueChanged<double> onQualityChanged,
  }) {
    return Card(
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                labelText: 'Option Name',
                labelStyle: const TextStyle(color: Colors.grey),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color)),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),

            // Price/Value slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Price Value (Affordability):', style: TextStyle(fontSize: 12, color: Colors.white70)),
                Text('${priceScore.round()}/10', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
              ],
            ),
            Slider(
              value: priceScore,
              min: 1,
              max: 10,
              divisions: 9,
              activeColor: color,
              onChanged: onPriceChanged,
            ),

            // Practical Need slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Urgency & Necessity:', style: TextStyle(fontSize: 12, color: Colors.white70)),
                Text('${needScore.round()}/10', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
              ],
            ),
            Slider(
              value: needScore,
              min: 1,
              max: 10,
              divisions: 9,
              activeColor: color,
              onChanged: onNeedChanged,
            ),

            // Quality/Long-term slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Long-term Quality:', style: TextStyle(fontSize: 12, color: Colors.white70)),
                Text('${qualityScore.round()}/10', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
              ],
            ),
            Slider(
              value: qualityScore,
              min: 1,
              max: 10,
              divisions: 9,
              activeColor: color,
              onChanged: onQualityChanged,
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 3: 1-TAP TEXT SNIPPET & VAULT
// -----------------------------------------------------------------------------
class SnipVaultTab extends StatefulWidget {
  const SnipVaultTab({super.key});

  @override
  State<SnipVaultTab> createState() => _SnipVaultTabState();
}

class _SnipVaultTabState extends State<SnipVaultTab> {
  final List<Map<String, String>> _snippets = [
    {
      'title': 'Bank Transfer Account',
      'category': 'Finance',
      'text': 'Account: 1234-5678-9012\nBank: Commercial Bank\nName: John Doe\nBranch: Main City'
    },
    {
      'title': 'Home Address & Note',
      'category': 'Location',
      'text': 'No 45, Green Park Avenue, Block B, Flat 3B. Call on arrival.'
    },
    {
      'title': 'Quick Business Intro',
      'category': 'Work',
      'text': 'Hi! I am reaching out regarding our discussion. Please review our service packages starting at \$99/mo.'
    },
    {
      'title': 'Quick Busy Response',
      'category': 'General',
      'text': 'Currently in a meeting or driving. I will get back to you shortly!'
    },
  ];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  String _selectedCategory = 'General';

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _addNewSnippet() {
    if (_titleController.text.trim().isEmpty || _textController.text.trim().isEmpty) return;

    setState(() {
      _snippets.insert(0, {
        'title': _titleController.text.trim(),
        'category': _selectedCategory,
        'text': _textController.text.trim(),
      });
      _titleController.clear();
      _textController.clear();
    });
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New Quick Snip Saved to Vault!')),
    );
  }

  void _showAddDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add New Fast Snip',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Snippet Title (e.g. Work Email)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _textController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Snippet Text Content',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addNewSnippet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Save Snip', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Snip', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '1-Tap Text Snip Vault',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Icon(Icons.flash_on, color: Colors.amber),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Copy frequently requested texts in 1 tap directly to your system clipboard.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _snippets.length,
              itemBuilder: (context, index) {
                final item = _snippets[index];
                return Card(
                  color: const Color(0xFF1E293B),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['title'] ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.indigo.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item['category'] ?? 'General',
                                style: const TextStyle(fontSize: 10, color: Colors.indigoAccent, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item['text'] ?? '',
                            style: const TextStyle(fontSize: 12, color: Colors.white70),
                            softWrap: true,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  _snippets.removeAt(index);
                                });
                              },
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Copied "${item['title']}" to Clipboard!'),
                                    backgroundColor: Colors.teal,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              icon: const Icon(Icons.content_copy, size: 16, color: Colors.white),
                              label: const Text('1-Tap Copy', style: TextStyle(color: Colors.white, fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 60), // FAB clearance
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 4: ACTIVE DECK & ENGAGEMENT HUB
// -----------------------------------------------------------------------------
class ActivityDeckTab extends StatefulWidget {
  const ActivityDeckTab({super.key});

  @override
  State<ActivityDeckTab> createState() => _ActivityDeckTabState();
}

class _ActivityDeckTabState extends State<ActivityDeckTab> {
  int _quickCounter = 0;
  int _interactionSessionTime = 14; // simulated session interactive score
  bool _quickLogActive = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Active Utility Deck',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Micro-interaction hub for daily counters, quick stats, & engagement logs',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Daily Interaction Stats Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.around,
              children: [
                _buildStatMetric('Overlay Triggers', '48', Icons.touch_app, Colors.teal),
                Container(height: 40, width: 1, color: Colors.white70),
                _buildStatMetric('Snips Copied', '19', Icons.content_copy, Colors.amber),
                Container(height: 40, width: 1, color: Colors.white70),
                _buildStatMetric('Active Streak', '5 Days', Icons.local_fire_department, Colors.orange),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'Micro Quick Tally Helper',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),

          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Instant Multi-Purpose Count Logger',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$_quickCounter',
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (_quickCounter > 0) _quickCounter--;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.2),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                        ),
                        child: const Icon(Icons.remove, color: Colors.red),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _quickCounter++;
                            _interactionSessionTime++;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _quickCounter = 0;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'Dynamic HUD Custom Badges',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildBadgeChip('Power User Lvl 3', Icons.military_tech, Colors.amber),
              _buildBadgeChip('Snip Master', Icons.bolt, Colors.teal),
              _buildBadgeChip('Overlay Active', Icons.layers, Colors.indigoAccent),
              _buildBadgeChip('Matrix Decider', Icons.calculate, Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatMetric(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildBadgeChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}