import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const OmniDockApp());
}

class OmniDockApp extends StatelessWidget {
  const OmniDockApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniDock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const OmniDockHomeScreen(),
    );
  }
}

class OmniDockHomeScreen extends StatefulWidget {
  const OmniDockHomeScreen({Key? key}) : super(key: key);

  @override
  State<OmniDockHomeScreen> createState() => _OmniDockHomeScreenState();
}

class _OmniDockHomeScreenState extends State<OmniDockHomeScreen> {
  int _currentIndex = 0;

  // Floating Overlay State Simulation
  bool _isOverlayEnabled = true;
  bool _showFloatingCalc = false;
  bool _showFloatingNotes = true;
  double _stickyX = 20.0;
  double _stickyY = 120.0;
  String _floatingNoteContent = "Remember to buy milk & check price per 100g!";

  // Clipboard Stack State
  final List<Map<String, String>> _clipboardStack = [
    {
      'title': 'Delivery Address',
      'text': '124 Main Street, Suite 4B, New York',
      'category': 'Address'
    },
    {
      'title': 'Promo Code',
      'text': 'SAVE20NOW',
      'category': 'Coupon'
    },
    {
      'title': 'Meeting Link',
      'text': 'https://meet.example.com/xyz-abc-123',
      'category': 'Link'
    },
  ];

  final TextEditingController _clipInputController = TextEditingController();
  final TextEditingController _textTransformController = TextEditingController();

  // Price Comparer State
  final TextEditingController _priceAController = TextEditingController(text: "12.50");
  final TextEditingController _qtyAController = TextEditingController(text: "250");
  final TextEditingController _priceBController = TextEditingController(text: "42.00");
  final TextEditingController _qtyBController = TextEditingController(text: "1000");

  // Decision Spinner State
  final List<String> _decisionOptions = ["Order Pizza", "Cook Dinner", "Eat Salad", "Sushi Night"];
  final TextEditingController _newOptionController = TextEditingController();
  String _selectedDecision = "Tap button to decide!";

  @override
  void dispose() {
    _clipInputController.dispose();
    _textTransformController.dispose();
    _priceAController.dispose();
    _qtyAController.dispose();
    _priceBController.dispose();
    _qtyBController.dispose();
    _newOptionController.dispose();
    super.dispose();
  }

  void _addNewClip(String text, String category) {
    if (text.trim().isEmpty) return;
    setState(() {
      _clipboardStack.insert(0, {
        'title': text.length > 20 ? '${text.substring(0, 20)}...' : text,
        'text': text,
        'category': category,
      });
      _clipInputController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved to Floating Clipboard!')),
    );
  }

  void _makeMicroDecision() {
    if (_decisionOptions.isEmpty) return;
    final random = Random();
    setState(() {
      _selectedDecision = _decisionOptions[random.nextInt(_decisionOptions.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildFloatingOverlayHubTab(),
      _buildClipboardWorkbenchTab(),
      _buildPriceComparerTab(),
      _buildDecisionMakerTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.widgets, color: Colors.indigo),
            SizedBox(width: 8),
            Text('OmniDock Utility Hub', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_isOverlayEnabled ? Icons.bolt : Icons.flash_off,
                color: _isOverlayEnabled ? Colors.amber : Colors.grey),
            onPressed: () {
              setState(() {
                _isOverlayEnabled = !_isOverlayEnabled;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isOverlayEnabled
                      ? 'System Floating Overlay Active!'
                      : 'Floating Overlay Suspended.'),
                ),
              );
            },
            tooltip: 'Toggle Floating System Dock',
          ),
        ],
      ),
      body: SafeArea(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.layers), label: 'Float Dock'),
          BottomNavigationBarItem(icon: Icon(Icons.content_copy), label: 'Smart Clip'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Price Compare'),
          BottomNavigationBarItem(icon: Icon(Icons.casino), label: 'Decision Wheel'),
        ],
      ),
    );
  }

  // TAB 1: Floating Overlay Hub & Interactive Simulator
  Widget _buildFloatingOverlayHubTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Status
          Card(
            elevation: 2,
            color: Colors.indigo.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        _isOverlayEnabled ? Icons.check_circle : Icons.warning_amber,
                        color: _isOverlayEnabled ? Colors.green : Colors.orange,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isOverlayEnabled
                                  ? 'Display Over Apps Enabled'
                                  : 'Overlay Permission Required',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              _isOverlayEnabled
                                  ? 'Dock is live. You can copy clips, read sticky notes, and compare prices on top of any app.'
                                  : 'Enable permission to allow OmniDock floating HUD buttons while using other apps.',
                              style: const TextStyle(fontSize: 12, color: Colors.black87),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('Floating Notes Sticky'),
                        selected: _showFloatingNotes,
                        onSelected: (val) => setState(() => _showFloatingNotes = val),
                        avatar: const Icon(Icons.sticky_note_2, size: 16),
                      ),
                      FilterChip(
                        label: const Text('Floating Calc Dock'),
                        selected: _showFloatingCalc,
                        onSelected: (val) => setState(() => _showFloatingCalc = val),
                        avatar: const Icon(Icons.calculate, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Interactive Drag & Drop Dock Preview Simulator
          const Text(
            'Live Screen Overlay Canvas Simulator',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          const Text(
            'Drag the yellow floating note widget anywhere around the screen preview box below:',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          Container(
            height: 340,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo.shade300, width: 2),
            ),
            child: Stack(
              children: [
                // Background Simulated App Content
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Simulated Active App (e.g. Browser / Video)',
                                style: TextStyle(color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(height: 12, width: 180, color: Colors.white70),
                        const SizedBox(height: 8),
                        Container(height: 12, width: 260, color: Colors.white70),
                        const SizedBox(height: 8),
                        Container(height: 12, width: 220, color: Colors.white70),
                        const Spacer(),
                        const Center(
                          child: Text(
                            'OmniDock System Overlay Widget Layer Active',
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),

                // Interactive Draggable Floating Sticky Note Widget
                if (_showFloatingNotes && _isOverlayEnabled)
                  Positioned(
                    left: _stickyX,
                    top: _stickyY,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          _stickyX = (_stickyX + details.delta.dx).clamp(0.0, 220.0);
                          _stickyY = (_stickyY + details.delta.dy).clamp(0.0, 220.0);
                        });
                      },
                      child: Container(
                        width: 170,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black87,
                              blurRadius: 8,
                              offset: Offset(2, 4),
                            ),
                          ],
                          border: Border.all(color: Colors.amber.shade600, width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.drag_indicator, size: 16, color: Colors.black87),
                                Text(
                                  'FLOAT NOTE',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Icon(Icons.push_pin, size: 14, color: Colors.indigo),
                              ],
                            ),
                            const Divider(height: 8, color: Colors.black87),
                            Text(
                              _floatingNoteContent,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Floating Action Trigger Dock Bubble
                if (_isOverlayEnabled)
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: FloatingActionButton.small(
                      heroTag: 'dock_fab',
                      backgroundColor: Colors.indigo,
                      onPressed: () {
                        _showQuickDockModal(context);
                      },
                      child: const Icon(Icons.widgets, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          // Edit Note Quick Action
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Floating Note Content Edit',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Type text to stay pinned on screen overlay...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _floatingNoteContent = val.isEmpty ? 'Type your float note...' : val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: Clipboard & Smart Text Workbench
  Widget _buildClipboardWorkbenchTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Text & Quick Clip Extraction',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          const Text(
            'Paste long text below to clean spaces, extract links, or save to your persistent clip stack.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          // Text Transformer Input Box
          TextField(
            controller: _textTransformController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Paste raw article, message, or numbers here...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          // Quick Action Tools
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  final raw = _textTransformController.text;
                  final uppercase = raw.toUpperCase();
                  _textTransformController.text = uppercase;
                },
                icon: const Icon(Icons.text_fields, size: 16),
                label: const Text('UPPERCASE'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  final raw = _textTransformController.text;
                  final cleaned = raw.replaceAll(RegExp(r'\s+'), ' ').trim();
                  _textTransformController.text = cleaned;
                },
                icon: const Icon(Icons.cleaning_services, size: 16),
                label: const Text('Trim Spaces'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  final raw = _textTransformController.text;
                  final reg = RegExp(r'(https?://[^\s]+)');
                  final matches = reg.allMatches(raw).map((m) => m.group(0)).join('\n');
                  if (matches.isNotEmpty) {
                    _textTransformController.text = matches;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Extracted Web Links!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No URLs detected in text.')),
                    );
                  }
                },
                icon: const Icon(Icons.link, size: 16),
                label: const Text('Extract Links'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _addNewClip(_textTransformController.text, 'Quick Note');
                },
                icon: const Icon(Icons.add_to_photos, size: 16),
                label: const Text('Save to Clip Stack'),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 8),

          const Text(
            'Saved Floating Clipboard Stack',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _clipboardStack.length,
            itemBuilder: (context, index) {
              final clip = _clipboardStack[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.shade100,
                    child: const Icon(Icons.copy, color: Colors.indigo, size: 18),
                  ),
                  title: Text(
                    clip['title'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    clip['text'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.content_copy, size: 18),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Copied: "${clip['title']}"')),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _clipboardStack.removeAt(index);
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

  // TAB 3: Price Comparer & Micro Bargain Tool
  Widget _buildPriceComparerTab() {
    final double pA = double.tryParse(_priceAController.text) ?? 0.0;
    final double qA = double.tryParse(_qtyAController.text) ?? 1.0;
    final double pB = double.tryParse(_priceBController.text) ?? 0.0;
    final double qB = double.tryParse(_qtyBController.text) ?? 1.0;

    final double unitPriceA = (qA > 0) ? (pA / qA) * 100 : 0.0; // Price per 100 units
    final double unitPriceB = (qB > 0) ? (pB / qB) * 100 : 0.0;

    String recommendation = "Enter prices above to calculate bargain winner.";
    Color winnerColor = Colors.grey;

    if (unitPriceA > 0 && unitPriceB > 0) {
      if (unitPriceA < unitPriceB) {
        final diff = ((unitPriceB - unitPriceA) / unitPriceB) * 100;
        recommendation = 'Option A is ${diff.toStringAsFixed(1)}% CHEAPER per 100g/unit!';
        winnerColor = Colors.green;
      } else if (unitPriceB < unitPriceA) {
        final diff = ((unitPriceA - unitPriceB) / unitPriceA) * 100;
        recommendation = 'Option B is ${diff.toStringAsFixed(1)}% CHEAPER per 100g/unit!';
        winnerColor = Colors.green;
      } else {
        recommendation = 'Both options have equal value per unit!';
        winnerColor = Colors.blue;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Shopping Unit Price Comparator',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          const Text(
            'Avoid trick packaging sizes in supermarkets. Instantly see true unit prices.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Option A Card
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Option A (e.g. Small Pack)',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _priceAController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price (\$)',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _qtyAController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Quantity (g/ml)',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Unit Cost: \$${unitPriceA.toStringAsFixed(2)} per 100g/ml',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Option B Card
          Card(
            color: Colors.purple.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Option B (e.g. Bulk Pack)',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _priceBController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price (\$)',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _qtyBController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Quantity (g/ml)',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Unit Cost: \$${unitPriceB.toStringAsFixed(2)} per 100g/ml',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Recommendation Card
          Card(
            elevation: 3,
            color: Colors.grey.shade900,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'BARGAIN VERDICT',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recommendation,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: winnerColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 4: Micro Decision Maker
  Widget _buildDecisionMakerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Decision Instant Picker',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          const Text(
            'Stop spending 15 minutes deciding what to eat, watch, or buy. Let OmniDock pick for you.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Wheel / Verdict Display Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.indigo, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.casino, color: Colors.amber, size: 48),
                const SizedBox(height: 12),
                const Text(
                  'CURRENT SELECTION',
                  style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  _selectedDecision,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: _makeMicroDecision,
                  child: const Text(
                    'TAP TO DECIDE NOW',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'Decision Pool Options',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),

          // Options Wrap Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _decisionOptions.map((opt) {
              return Chip(
                label: Text(opt),
                deleteIcon: const Icon(Icons.close, size: 14),
                onDeleted: () {
                  setState(() {
                    _decisionOptions.remove(opt);
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _newOptionController,
                  decoration: const InputDecoration(
                    hintText: 'Add new choice (e.g. Tacos)...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: () {
                  if (_newOptionController.text.trim().isNotEmpty) {
                    setState(() {
                      _decisionOptions.add(_newOptionController.text.trim());
                      _newOptionController.clear();
                    });
                  }
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Quick Overlay Dock Modal Bottom Sheet
  void _showQuickDockModal(BuildContext context) {
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
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'OmniDock Floating Dock Quick Actions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildDockIconButton(
                      icon: Icons.copy,
                      label: 'Paste Clip',
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pop(context);
                        setState(() => _currentIndex = 1);
                      },
                    ),
                    _buildDockIconButton(
                      icon: Icons.add_comment,
                      label: 'New Float Note',
                      color: Colors.amber,
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _showFloatingNotes = true;
                          _floatingNoteContent = "Quick desktop note captured!";
                        });
                      },
                    ),
                    _buildDockIconButton(
                      icon: Icons.calculate,
                      label: 'Unit Compare',
                      color: Colors.teal,
                      onTap: () {
                        Navigator.pop(context);
                        setState(() => _currentIndex = 2);
                      },
                    ),
                    _buildDockIconButton(
                      icon: Icons.casino,
                      label: 'Random Pick',
                      color: Colors.purple,
                      onTap: () {
                        Navigator.pop(context);
                        _makeMicroDecision();
                        setState(() => _currentIndex = 3);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDockIconButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}