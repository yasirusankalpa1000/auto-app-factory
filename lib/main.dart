import 'package:flutter/material.dart';

void main() {
  runApp(const OverlaySnapApp());
}

class OverlaySnapApp extends StatelessWidget {
  const OverlaySnapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlaySnap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFA5F6F8),
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
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    FloatingHUDTab(),
    SideBySideCompareTab(),
    SnippetExtractorTab(),
    OverlaySettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: const [
            Icon(Icons.layers, size: 26),
            SizedBox(width: 10),
            Text(
              'OverlaySnap',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.stars),
            tooltip: 'Pro Floating Assistant',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Floating HUD Assistant Active & Ready!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.widgets),
            label: 'Floating HUD',
          ),
          NavigationDestination(
            icon: Icon(Icons.compare),
            label: 'Compare',
          ),
          NavigationDestination(
            icon: Icon(Icons.copy),
            label: 'Extractor',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune),
            label: 'Overlay Dock',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// TAB 1: FLOATING HUD & LIVE ASSISTANT CANVAS
// ---------------------------------------------------------
class FloatingHUDTab extends StatefulWidget {
  const FloatingHUDTab({super.key});

  @override
  State<FloatingHUDTab> createState() => _FloatingHUDTabState();
}

class _FloatingHUDTabState extends State<FloatingHUDTab> {
  bool _isFloatingActive = true;
  bool _showStickyNote = true;
  bool _showSplitter = false;
  bool _showImagePin = true;
  
  // Interactive Floating Note Content
  final TextEditingController _noteController = TextEditingController(
    text: 'Pin: Code 8492 | Specs: 6.7" OLED, 5000mAh | Price: \$499.00',
  );

  // Splitter state
  double _totalBill = 145.50;
  int _peopleCount = 3;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double perPerson = _peopleCount > 0 ? _totalBill / _peopleCount : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Banner / Permission Status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isFloatingActive ? Colors.indigo.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isFloatingActive ? Colors.indigo : Colors.red.shade300,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: _isFloatingActive ? Colors.indigo : Colors.red,
                  child: Icon(
                    _isFloatingActive ? Icons.open_in_new : Icons.lock,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isFloatingActive
                            ? 'Floating System HUD Active'
                            : 'Overlay Permission Disabled',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isFloatingActive ? Colors.indigo.shade900 : Colors.red.shade900,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isFloatingActive
                            ? 'Tools stay on top of all apps for quick cross-checking.'
                            : 'Enable overlay to view tools above shopping & bank apps.',
                        style: const TextStyle(fontSize: 12, color: Colors.black87),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isFloatingActive,
                  activeColor: Colors.indigo,
                  onChanged: (val) {
                    setState(() {
                      _isFloatingActive = val;
                    });
                  },
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Quick Floating Tool Toggles',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 10),

          // Toggles Wrap
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              FilterChip(
                selected: _showStickyNote,
                label: const Text('Floating Sticky Pad'),
                avatar: const Icon(Icons.edit, size: 18),
                onSelected: (val) => setState(() => _showStickyNote = val),
              ),
              FilterChip(
                selected: _showSplitter,
                label: const Text('Quick Splitter Pad'),
                avatar: const Icon(Icons.calculate, size: 18),
                onSelected: (val) => setState(() => _showSplitter = val),
              ),
              FilterChip(
                selected: _showImagePin,
                label: const Text('Visual Image Reference'),
                avatar: const Icon(Icons.pin, size: 18),
                onSelected: (val) => setState(() => _showImagePin = val),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Interactive HUD Preview Screen Frame
          const Text(
            'Live Screen Overlay Preview',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          const Text(
            'Drag and interact with widgets below as they appear over other apps.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          Container(
            height: 420,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.indigo.shade300, width: 2),
            ),
            child: Stack(
              children: [
                // Simulated Background App
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      color: const Color(0xFF1E1E2C),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'SIMULATED BACKGROUND APP',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              Icon(Icons.wifi, color: Colors.white70, size: 14),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                '[ Shopping / Banking / Browser App Screen ]',
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Floating Widget 1: Sticky Note
                if (_showStickyNote && _isFloatingActive)
                  Positioned(
                    top: 40,
                    left: 16,
                    right: 16,
                    child: Card(
                      color: Colors.amber.shade100,
                      elevation: 6,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.push_pin, size: 16, color: Colors.brown),
                                const SizedBox(width: 6),
                                const Expanded(
                                  child: Text(
                                    'Floating Quick Note',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => setState(() => _showStickyNote = false),
                                  child: const Icon(Icons.close, size: 18, color: Colors.brown),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _noteController,
                              maxLines: 2,
                              style: const TextStyle(fontSize: 12, color: Colors.black87),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Floating Widget 2: Receipt Splitter
                if (_showSplitter && _isFloatingActive)
                  Positioned(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    child: Card(
                      color: Colors.teal.shade900,
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.monetization_on, color: Colors.tealAccent, size: 18),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    'Instant Bill Cross-Checker',
                                    style: TextStyle(
                                      color: Colors.tealAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => setState(() => _showSplitter = false),
                                  child: const Icon(Icons.close, color: Colors.white70, size: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'TOTAL BILL',
                                        style: TextStyle(color: Colors.white70, fontSize: 9),
                                      ),
                                      Text(
                                        '\$${_totalBill.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 28,
                                  width: 1,
                                  color: Colors.white70,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'PER PERSON (${_peopleCount}x)',
                                        style: const TextStyle(color: Colors.tealAccent, fontSize: 9),
                                      ),
                                      Text(
                                        '\$${perPerson.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.tealAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal.shade700,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _peopleCount = (_peopleCount % 8) + 1;
                                      });
                                    },
                                    icon: const Icon(Icons.person, size: 14),
                                    label: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text('Split: $_peopleCount'),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal.shade700,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _totalBill += 10.0;
                                      });
                                    },
                                    icon: const Icon(Icons.add, size: 14),
                                    label: const FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text('+\$10'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Floating Widget 3: Visual Image Pin Badge
                if (_showImagePin && _isFloatingActive)
                  Positioned(
                    top: 150,
                    right: 20,
                    child: Container(
                      width: 110,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(color: Colors.black87, blurRadius: 8, offset: Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Pin Ref',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => _showImagePin = false),
                                child: const Icon(Icons.close, size: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 65,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt, color: Colors.indigo, size: 24),
                                SizedBox(height: 2),
                                Text(
                                  'Receipt Snippet',
                                  style: TextStyle(fontSize: 9, color: Colors.indigo),
                                ),
                              ],
                            ),
                          ),
                        ],
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
}

// ---------------------------------------------------------
// TAB 2: SIDE-BY-SIDE VISUAL COMPARISON STUDIO
// ---------------------------------------------------------
class SideBySideCompareTab extends StatefulWidget {
  const SideBySideCompareTab({super.key});

  @override
  State<SideBySideCompareTab> createState() => _SideBySideCompareTabState();
}

class _SideBySideCompareTabState extends State<SideBySideCompareTab> {
  // Option A
  String _nameA = 'Brand X Wireless Headphones';
  double _priceA = 89.99;
  String _specA = 'Battery: 24 hrs | Noise Cancel: Active | Weight: 220g';

  // Option B
  String _nameB = 'Brand Y Sound Studio';
  double _priceB = 119.50;
  String _specB = 'Battery: 40 hrs | Noise Cancel: Hybrid | Weight: 250g';

  double _zoomLevel = 1.0;

  @override
  Widget build(BuildContext context) {
    double priceDiff = (_priceA - _priceB).abs();
    String cheaperOption = _priceA < _priceB ? 'Option A' : 'Option B';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Side-by-Side Product & Price Comparison',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 4),
          const Text(
            'Cross-check 2 items live before buying to avoid overpaying.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Difference Alert Badge
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade700),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.amber.shade900),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '$cheaperOption is cheaper by \$${priceDiff.toStringAsFixed(2)}!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                      fontSize: 13,
                    ),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Zoom slider
          Row(
            children: [
              const Text('Inspector Zoom:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              Expanded(
                child: Slider(
                  value: _zoomLevel,
                  min: 0.8,
                  max: 1.5,
                  activeColor: Colors.indigo,
                  onChanged: (val) {
                    setState(() {
                      _zoomLevel = val;
                    });
                  },
                ),
              ),
              Text('${(_zoomLevel * 100).toInt()}%', style: const TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),

          // Side-by-Side Cards
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ITEM A
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('OPTION A', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _nameA,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          softWrap: true,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '\$${_priceA.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        const Divider(height: 16),
                        Transform.scale(
                          scale: _zoomLevel,
                          alignment: Alignment.topLeft,
                          child: Text(
                            _specA,
                            style: const TextStyle(fontSize: 11, color: Colors.black87),
                            softWrap: true,
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          ),
                          onPressed: () {
                            _editOptionDialog(context, isOptionA: true);
                          },
                          icon: const Icon(Icons.edit, size: 14),
                          label: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('Edit A'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // ITEM B
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('OPTION B', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.purple)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _nameB,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          softWrap: true,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '\$${_priceB.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        const Divider(height: 16),
                        Transform.scale(
                          scale: _zoomLevel,
                          alignment: Alignment.topLeft,
                          child: Text(
                            _specB,
                            style: const TextStyle(fontSize: 11, color: Colors.black87),
                            softWrap: true,
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          ),
                          onPressed: () {
                            _editOptionDialog(context, isOptionA: false);
                          },
                          icon: const Icon(Icons.edit, size: 14),
                          label: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('Edit B'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Decision Helper Quick Checklist
          Card(
            color: Colors.grey.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Smart Buying Checklist',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  CheckItemRow(text: 'Does lower price option meet essential specs?'),
                  CheckItemRow(text: 'Check hidden shipping fees before finalizing payment.'),
                  CheckItemRow(text: 'Verify return policy & warranty duration.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editOptionDialog(BuildContext context, {required bool isOptionA}) {
    final nameCtrl = TextEditingController(text: isOptionA ? _nameA : _nameB);
    final priceCtrl = TextEditingController(text: (isOptionA ? _priceA : _priceB).toString());
    final specCtrl = TextEditingController(text: isOptionA ? _specA : _specB);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(isOptionA ? 'Edit Option A' : 'Edit Option B'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price (\$) \',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: specCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Specs / Notes',
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
              onPressed: () {
                setState(() {
                  double parsedPrice = double.tryParse(priceCtrl.text) ?? 0.0;
                  if (isOptionA) {
                    _nameA = nameCtrl.text;
                    _priceA = parsedPrice;
                    _specA = specCtrl.text;
                  } else {
                    _nameB = nameCtrl.text;
                    _priceB = parsedPrice;
                    _specB = specCtrl.text;
                  }
                });
                Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class CheckItemRow extends StatefulWidget {
  final String text;
  const CheckItemRow({super.key, required this.text});

  @override
  State<CheckItemRow> createState() => _CheckItemRowState();
}

class _CheckItemRowState extends State<CheckItemRow> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => _checked = !_checked),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Icon(
              _checked ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 18,
              color: _checked ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 12,
                  decoration: _checked ? TextDecoration.lineThrough : null,
                  color: _checked ? Colors.grey : Colors.black87,
                ),
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// TAB 3: SNIPPET EXTRACTOR & TEXT CLEANER
// ---------------------------------------------------------
class SnippetExtractorTab extends StatefulWidget {
  const SnippetExtractorTab({super.key});

  @override
  State<SnippetExtractorTab> createState() => _SnippetExtractorTabState();
}

class _SnippetExtractorTabState extends State<SnippetExtractorTab> {
  final TextEditingController _rawTextController = TextEditingController(
    text: 'Receipt #98421\nMerchant: SuperMart Store #14\nTotal Amount: \$184.75\nPhone: +1 800 555 0199\nDate: 2025-05-18\nOrder status: CONFIRMED',
  );

  String _extractedNumbers = '';
  String _extractedEmailsPhone = '';
  bool _isCleaned = false;

  void _processText() {
    String text = _rawTextController.text;
    
    // Extract numbers/prices
    RegExp numReg = RegExp(r'\$?\d+(\.\d{1,2})?');
    Iterable<Match> numMatches = numReg.allMatches(text);
    List<String> nums = numMatches.map((m) => m.group(0)!).toList();

    // Extract phones/ids
    RegExp phoneReg = RegExp(r'(\+?\d[\d\s\-]{7,}\d)');
    Iterable<Match> phoneMatches = phoneReg.allMatches(text);
    List<String> phones = phoneMatches.map((m) => m.group(0)!).toList();

    setState(() {
      _extractedNumbers = nums.isNotEmpty ? nums.join(' | ') : 'No amounts detected';
      _extractedEmailsPhone = phones.isNotEmpty ? phones.join(' | ') : 'No phones detected';
      _isCleaned = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Text & Data Snippet Cleaner',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 4),
          const Text(
            'Paste unformatted text from screenshots or chat messages to extract prices & numbers instantly.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Input Box
          TextField(
            controller: _rawTextController,
            maxLines: 5,
            style: const TextStyle(fontSize: 13),
            decoration: const InputDecoration(
              labelText: 'Paste Raw Screen / Screenshot Text',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _processText,
                  icon: const Icon(Icons.build, size: 18),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Extract Data Snippets'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                ),
                onPressed: () {
                  _rawTextController.clear();
                  setState(() {
                    _extractedNumbers = '';
                    _extractedEmailsPhone = '';
                    _isCleaned = false;
                  });
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Clear'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (_isCleaned) ...[
            const Text(
              'Extracted Smart Snippets',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),

            // Card 1: Prices & Numbers
            Card(
              color: Colors.green.shade50,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.monetization_on, color: Colors.white, size: 20),
                ),
                title: const Text('Detected Amounts & Values', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                subtitle: Text(_extractedNumbers, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                trailing: IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Amounts copied to clipboard!')),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Card 2: Contacts & IDs
            Card(
              color: Colors.blue.shade50,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
                title: const Text('Detected Contacts & Phone IDs', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                subtitle: Text(_extractedEmailsPhone, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                trailing: IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contacts copied to clipboard!')),
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// TAB 4: OVERLAY SYSTEM SETTINGS & DOCK CUSTOMIZER
// ---------------------------------------------------------
class OverlaySettingsTab extends StatefulWidget {
  const OverlaySettingsTab({super.key});

  @override
  State<OverlaySettingsTab> createState() => _OverlaySettingsTabState();
}

class _OverlaySettingsTabState extends State<OverlaySettingsTab> {
  double _bubbleOpacity = 0.9;
  String _dockPosition = 'Right Edge';
  bool _autoDismiss = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating HUD & Dock Preferences',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 4),
          const Text(
            'Customize how your assistant floating heads behave on top of other mobile apps.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Opacity Slider
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Floating Bubble Transparency',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text('${(_bubbleOpacity * 100).toInt()}%'),
                    ],
                  ),
                  Slider(
                    value: _bubbleOpacity,
                    min: 0.3,
                    max: 1.0,
                    activeColor: Colors.indigo,
                    onChanged: (val) {
                      setState(() {
                        _bubbleOpacity = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Dock Edge Selector
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Screen Dock Magnet Edge',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Right Edge', 'Left Edge', 'Bottom Bar'].map((pos) {
                      bool selected = _dockPosition == pos;
                      return ChoiceChip(
                        label: Text(pos),
                        selected: selected,
                        selectedColor: Colors.indigo.shade100,
                        onSelected: (val) {
                          if (val) {
                            setState(() {
                              _dockPosition = pos;
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
          const SizedBox(height: 12),

          // Auto Dismiss Switch
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              title: const Text('Auto-minimize Floating HUD on Tap Outside', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              subtitle: const Text('Keeps workspace clean while typing passwords.', style: TextStyle(fontSize: 11)),
              value: _autoDismiss,
              activeColor: Colors.indigo,
              onChanged: (val) {
                setState(() {
                  _autoDismiss = val;
                });
              },
            ),
          ),
          const SizedBox(height: 20),

          // Quick Action Tip Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(Icons.stars, color: Colors.indigo, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'AdMob Session Booster Tip',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo, fontSize: 13),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  'Because OverlaySnap stays active while users shop online or analyze bank statements, app session length remains high—offering prime placement for non-intrusive floating banner ads.',
                  style: TextStyle(fontSize: 11, color: Colors.black87),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}