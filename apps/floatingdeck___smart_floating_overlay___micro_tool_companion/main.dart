import 'package:flutter/material.dart';

void main() {
  runApp(const FloatingDeckApp());
}

class FloatingDeckApp extends StatelessWidget {
  const FloatingDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatingDeck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class QuickClip {
  final String id;
  final String title;
  final String content;
  final String category;

  QuickClip({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
  });
}

class MicroOption {
  String name;
  double score;

  MicroOption({required this.name, required this.score});
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;

  // Floating Overlay State Simulation
  bool _isOverlayEnabled = true;
  Offset _bubblePosition = const Offset(20, 200);
  bool _isBubbleExpanded = false;
  String _activeFloatingText = "Quick Tool Deck Active";

  // Quick Clips Data
  final List<QuickClip> _clips = [
    QuickClip(
      id: '1',
      title: 'Home Address',
      content: 'No. 45, Golden Palm Avenue, Colombo 07',
      category: 'Address',
    ),
    QuickClip(
      id: '2',
      title: 'Bank Account Number',
      content: '8004928104 - Commercial Bank (Main Branch)',
      category: 'Finance',
    ),
    QuickClip(
      id: '3',
      title: 'Standard Work Reply',
      content: 'Thanks for reaching out! I will review this and respond shortly.',
      category: 'Work',
    ),
  ];

  // Price Comparer State
  final TextEditingController _item1Price = TextEditingController(text: "450");
  final TextEditingController _item1Qty = TextEditingController(text: "500");
  final TextEditingController _item2Price = TextEditingController(text: "780");
  final TextEditingController _item2Qty = TextEditingController(text: "900");
  String _comparisonResult = "Compare item prices per unit!";
  String _bestItemLabel = "";

  // Decision Matrix State
  final List<MicroOption> _decisionOptions = [
    MicroOption(name: "Option A (Order Food)", score: 7.0),
    MicroOption(name: "Option B (Cook Home)", score: 8.5),
    MicroOption(name: "Option C (Eat Out)", score: 5.0),
  ];
  String _decisionWinner = "Tap 'Run Micro-Decision' to evaluate";

  // Add Clip Dialog Controllers
  final TextEditingController _clipTitleCtrl = TextEditingController();
  final TextEditingController _clipContentCtrl = TextEditingController();

  @override
  void dispose() {
    _item1Price.dispose();
    _item1Qty.dispose();
    _item2Price.dispose();
    _item2Qty.dispose();
    _clipTitleCtrl.dispose();
    _clipContentCtrl.dispose();
    super.dispose();
  }

  void _calculatePriceComparison() {
    double p1 = double.tryParse(_item1Price.text) ?? 0;
    double q1 = double.tryParse(_item1Qty.text) ?? 0;
    double p2 = double.tryParse(_item2Price.text) ?? 0;
    double q2 = double.tryParse(_item2Qty.text) ?? 0;

    if (p1 <= 0 || q1 <= 0 || p2 <= 0 || q2 <= 0) {
      setState(() {
        _comparisonResult = "Please enter valid prices and quantities.";
        _bestItemLabel = "";
      });
      return;
    }

    double unit1 = p1 / q1;
    double unit2 = p2 / q2;

    setState(() {
      if (unit1 < unit2) {
        double savings = ((unit2 - unit1) / unit2) * 100;
        _bestItemLabel = "Option 1 is Cheaper!";
        _comparisonResult =
            "Option 1 costs \$${unit1.toStringAsFixed(3)} per unit.\n"
            "Option 2 costs \$${unit2.toStringAsFixed(3)} per unit.\n"
            "You save ${savings.toStringAsFixed(1)}% with Option 1!";
        _activeFloatingText = "Best Deal: Option 1 (\$$p1 for ${q1.toStringAsFixed(0)}g)";
      } else if (unit2 < unit1) {
        double savings = ((unit1 - unit2) / unit1) * 100;
        _bestItemLabel = "Option 2 is Cheaper!";
        _comparisonResult =
            "Option 2 costs \$${unit2.toStringAsFixed(3)} per unit.\n"
            "Option 1 costs \$${unit1.toStringAsFixed(3)} per unit.\n"
            "You save ${savings.toStringAsFixed(1)}% with Option 2!";
        _activeFloatingText = "Best Deal: Option 2 (\$$p2 for ${q2.toStringAsFixed(0)}g)";
      } else {
        _bestItemLabel = "Both options have equal unit value!";
        _comparisonResult = "Both cost \$${unit1.toStringAsFixed(3)} per unit.";
      }
    });
  }

  void _runDecisionMatrix() {
    if (_decisionOptions.isEmpty) return;
    MicroOption winner = _decisionOptions[0];
    for (var opt in _decisionOptions) {
      if (opt.score > winner.score) {
        winner = opt;
      }
    }
    setState(() {
      _decisionWinner = "Best Pick: ${winner.name} (Score: ${winner.score.toStringAsFixed(1)})";
      _activeFloatingText = "Decision Picked: ${winner.name}";
    });
  }

  void _addNewClip() {
    if (_clipTitleCtrl.text.trim().isEmpty || _clipContentCtrl.text.trim().isEmpty) return;
    setState(() {
      _clips.add(QuickClip(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _clipTitleCtrl.text.trim(),
        content: _clipContentCtrl.text.trim(),
        category: 'Custom',
      ));
      _clipTitleCtrl.clear();
      _clipContentCtrl.clear();
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quick Clip added to tray!')),
    );
  }

  void _showAddClipDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Quick Clip'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _clipTitleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Title (e.g. Wi-Fi Password)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _clipContentCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Snippet Content',
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
            onPressed: _addNewClip,
            child: const Text('Save Clip'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: Row(
          children: const [
            Icon(Icons.layers, size: 24),
            SizedBox(width: 10),
            Text(
              'FloatingDeck Companion',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isOverlayEnabled ? Icons.notifications_active : Icons.notifications_off,
              color: Colors.amber,
            ),
            onPressed: () {
              setState(() {
                _isOverlayEnabled = !_isOverlayEnabled;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isOverlayEnabled
                      ? 'Simulated Floating HUD Widget Enabled'
                      : 'Floating HUD Disabled'),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildHUDControlTab(),
                _buildShoppingComparerTab(),
                _buildQuickClipsTab(),
                _buildDecisionMatrixTab(),
              ],
            ),
          ),

          // Simulated Interactive Floating Bubble HUD Overlay
          if (_isOverlayEnabled)
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubblePosition += details.delta;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade900,
                    borderRadius: BorderRadius.circular(_isBubbleExpanded ? 16 : 30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black87,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.widgets, color: Colors.amber, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            _isBubbleExpanded ? "Floating Deck HUD" : "HUD",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _isBubbleExpanded = !_isBubbleExpanded;
                              });
                            },
                            child: Icon(
                              _isBubbleExpanded ? Icons.close : Icons.open_in_new,
                              color: Colors.white70,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      if (_isBubbleExpanded) ...[
                        const Divider(color: Colors.white70, height: 16),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 180),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _activeFloatingText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('HUD Action Triggered! Saved to clipboard.'),
                                  ),
                                );
                              },
                              child: const Text('Copy Data', style: TextStyle(fontSize: 10)),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (idx) {
          setState(() {
            _selectedIndex = idx;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Floating HUD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Price Check',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy),
            label: 'Quick Clips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Decision Deck',
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating HUD Dashboard & System Assistant Controls
  Widget _buildHUDControlTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Banner Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.indigo, Colors.indigoAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white70,
                  radius: 26,
                  child: Icon(Icons.layers, color: Colors.amber, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Live Floating HUD Overlay',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Drag the floating bubble around your screen to keep active micro-data easily accessible!',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Floating Tool Presets',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          // Presets Grid / Wraps
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildPresetChip(
                label: 'Shopping Price Checker',
                icon: Icons.shopping_cart,
                color: Colors.teal,
                onTap: () {
                  setState(() {
                    _activeFloatingText = "Active: Unit Price Comparer Ready";
                    _selectedIndex = 1;
                  });
                },
              ),
              _buildPresetChip(
                label: 'Quick Address Clip',
                icon: Icons.home,
                color: Colors.blue,
                onTap: () {
                  setState(() {
                    _activeFloatingText = _clips[0].content;
                  });
                },
              ),
              _buildPresetChip(
                label: 'Bank Details Clip',
                icon: Icons.monetization_on,
                color: Colors.orange,
                onTap: () {
                  setState(() {
                    _activeFloatingText = _clips[1].content;
                  });
                },
              ),
              _buildPresetChip(
                label: 'Micro Decision Tool',
                icon: Icons.lightbulb,
                color: Colors.purple,
                onTap: () {
                  setState(() {
                    _activeFloatingText = "Micro Decision Evaluator Active";
                    _selectedIndex = 3;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Floating System Status & Notification Simulation Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.notifications_active, color: Colors.indigo),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Floating Notification & Overlay Service',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Switch(
                        value: _isOverlayEnabled,
                        onChanged: (val) {
                          setState(() {
                            _isOverlayEnabled = val;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Allows FloatingDeck to display dynamic price updates, clipboard clips, and micro-tools over other apps seamlessly.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Active Floating Text:',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                      Flexible(
                        child: Text(
                          _activeFloatingText,
                          style: const TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
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

  Widget _buildPresetChip({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: Shopping Unit Price Comparison Engine
  Widget _buildShoppingComparerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.shade200),
            ),
            child: Row(
              children: const [
                Icon(Icons.shopping_cart, color: Colors.teal),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Shopping Unit-Price Evaluator\nNever get tricked by misleading package sizes again!',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Option 1 Input Card
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Item Option A (e.g. Small Pack)',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _item1Price,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price (\$)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _item1Qty,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Weight/Qty (g or ml)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Option 2 Input Card
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Item Option B (e.g. Large Pack)',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _item2Price,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price (\$)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _item2Qty,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Weight/Qty (g or ml)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _calculatePriceComparison,
              icon: const Icon(Icons.compare_arrows),
              label: const Text(
                'Evaluate Best Value',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Result Display Container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.indigo.shade100, width: 2),
            ),
            child: Column(
              children: [
                if (_bestItemLabel.isNotEmpty) ...[
                  Text(
                    _bestItemLabel,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  _comparisonResult,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                if (_bestItemLabel.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isOverlayEnabled = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Result pinned to Floating Overlay HUD!')),
                      );
                    },
                    icon: const Icon(Icons.push_pin, size: 16),
                    label: const Text('Pin Result to Floating HUD'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 3: Quick Clips & Text Snippet Tray
  Widget _buildQuickClipsTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          color: Colors.indigo.shade50,
          child: Row(
            children: [
              const Icon(Icons.content_copy, color: Colors.indigo),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Quick Clips Tray\nTap any snippet to send to floating clipboard or system copy.',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                onPressed: _showAddClipDialog,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Clip'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _clips.isEmpty
              ? const Center(child: Text('No quick clips added yet.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _clips.length,
                  itemBuilder: (ctx, idx) {
                    final clip = _clips[idx];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo.shade100,
                          child: Icon(
                            clip.category == 'Address'
                                ? Icons.home
                                : clip.category == 'Finance'
                                    ? Icons.monetization_on
                                    : Icons.text_snippet,
                            color: Colors.indigo,
                          ),
                        ),
                        title: Text(
                          clip.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            clip.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.push_pin, color: Colors.amber),
                              tooltip: 'Float on Screen',
                              onPressed: () {
                                setState(() {
                                  _activeFloatingText = "${clip.title}: ${clip.content}";
                                  _isOverlayEnabled = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Pinned "${clip.title}" to Floating HUD!'),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  _clips.removeAt(idx);
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
      ],
    );
  }

  // TAB 4: Micro-Decision Matrix Builder
  Widget _buildDecisionMatrixTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.shade200),
            ),
            child: Row(
              children: const [
                Icon(Icons.psychology, color: Colors.purple),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Micro-Decision Evaluator\nCan\'t decide what to do? Weight your daily choices and let FloatingDeck compute the optimal pick!',
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Current Choices & Priority Rating:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),

          ..._decisionOptions.asMap().entries.map((entry) {
            int idx = entry.key;
            MicroOption opt = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            opt.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          'Score: ${opt.score.toStringAsFixed(1)}',
                          style: const TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: opt.score,
                      min: 1.0,
                      max: 10.0,
                      divisions: 18,
                      activeColor: Colors.purple,
                      onChanged: (val) {
                        setState(() {
                          _decisionOptions[idx].score = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _runDecisionMatrix,
              icon: const Icon(Icons.flash_on),
              label: const Text(
                'Run Micro-Decision Matrix',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.purple.shade200, width: 2),
            ),
            child: Column(
              children: [
                const Icon(Icons.stars, color: Colors.amber, size: 32),
                const SizedBox(height: 6),
                Text(
                  _decisionWinner,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.purple,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}