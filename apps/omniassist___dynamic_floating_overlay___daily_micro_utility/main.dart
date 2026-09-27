import 'package:flutter/material.dart';

void main() {
  runApp(const OmniAssistApp());
}

class OmniAssistApp extends StatelessWidget {
  const OmniAssistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniAssist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const OmniAssistHomeScreen(),
    );
  }
}

class OmniAssistHomeScreen extends StatefulWidget {
  const OmniAssistHomeScreen({super.key});

  @override
  State<OmniAssistHomeScreen> createState() => _OmniAssistHomeScreenState();
}

class _OmniAssistHomeScreenState extends State<OmniAssistHomeScreen> {
  int _currentIndex = 0;

  // Floating Bubble state
  bool _isOverlayEnabled = true;
  bool _isBubbleExpanded = false;
  double _bubbleX = 20.0;
  double _bubbleY = 120.0;
  double _screenTintOpacity = 0.0;

  // Unit Optimizer State
  final TextEditingController _itemANameController = TextEditingController(text: 'Brand A Pack');
  final TextEditingController _itemAPriceController = TextEditingController(text: '12.50');
  final TextEditingController _itemAQtyController = TextEditingController(text: '450');

  final TextEditingController _itemBNameController = TextEditingController(text: 'Brand B Pack');
  final TextEditingController _itemBPriceController = TextEditingController(text: '18.00');
  final TextEditingController _itemBQtyController = TextEditingController(text: '700');

  // Decision Matrix State
  final TextEditingController _optionAController = TextEditingController(text: 'Option A: Buy New');
  final TextEditingController _optionBController = TextEditingController(text: 'Option B: Rent/Used');
  final List<Map<String, dynamic>> _decisionFactors = [
    {'name': 'Affordability', 'weight': 4, 'scoreA': 6, 'scoreB': 9},
    {'name': 'Quality & Durability', 'weight': 5, 'scoreA': 9, 'scoreB': 5},
    {'name': 'Convenience', 'weight': 3, 'scoreA': 8, 'scoreB': 6},
  ];

  // Clipboard Snippets State
  final List<Map<String, String>> _snippets = [
    {'title': 'Home Address', 'content': '742 Evergreen Terrace, Sector 4', 'cat': 'Personal'},
    {'title': 'Work Tax ID', 'content': 'TX-99810239-X', 'cat': 'Work'},
    {'title': 'WiFi Guest Key', 'content': 'SecurePass#2025!', 'cat': 'Codes'},
  ];
  final TextEditingController _snippetTitleController = TextEditingController();
  final TextEditingController _snippetContentController = TextEditingController();
  String _selectedCat = 'Personal';

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Main Body Screen
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildOverlayHubTab(),
                _buildUnitCostOptimizerTab(),
                _buildDecisionMatrixTab(),
                _buildClipboardVaultTab(),
              ],
            ),
          ),

          // Screen Tint Overlay Filter Simulation
          if (_screenTintOpacity > 0.01)
            IgnorePointer(
              child: Container(
                color: Colors.amber.withOpacity(_screenTintOpacity),
              ),
            ),

          // Dynamic Floating Screen Overlay Dock
          if (_isOverlayEnabled)
            Positioned(
              left: _bubbleX.clamp(0.0, screenSize.width - 70.0),
              top: _bubbleY.clamp(0.0, screenSize.height - 150.0),
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubbleX += details.delta.dx;
                    _bubbleY += details.delta.dy;
                  });
                },
                child: Material(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  color: Colors.indigo,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(8.0),
                    width: _isBubbleExpanded ? 240 : 56,
                    height: _isBubbleExpanded ? 260 : 56,
                    child: _isBubbleExpanded
                        ? SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.widgets, color: Colors.white, size: 20),
                                        SizedBox(width: 6),
                                        Text(
                                          'OmniDock',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close, color: Colors.white, size: 18),
                                      onPressed: () {
                                        setState(() {
                                          _isBubbleExpanded = false;
                                        });
                                      },
                                    )
                                  ],
                                ),
                                const Divider(color: Colors.white70),
                                ListTile(
                                  dense: true,
                                  leading: const Icon(Icons.content_copy, color: Colors.white),
                                  title: Text(
                                    '${_snippets.length} Snippets Ready',
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _currentIndex = 3;
                                      _isBubbleExpanded = false;
                                    });
                                  },
                                ),
                                ListTile(
                                  dense: true,
                                  leading: const Icon(Icons.calculate, color: Colors.white),
                                  title: const Text(
                                    'Bargain Inspector',
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _currentIndex = 1;
                                      _isBubbleExpanded = false;
                                    });
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    'Screen Comfort Tint',
                                    style: TextStyle(color: Colors.white70, fontSize: 10),
                                  ),
                                ),
                                Slider(
                                  value: _screenTintOpacity,
                                  min: 0.0,
                                  max: 0.35,
                                  activeColor: Colors.amber,
                                  onChanged: (val) {
                                    setState(() {
                                      _screenTintOpacity = val;
                                    });
                                  },
                                ),
                              ],
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.layers, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _isBubbleExpanded = true;
                              });
                            },
                          ),
                  ),
                ),
              ),
            ),
        ],
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
            icon: Icon(Icons.tune),
            label: 'Overlay Deck',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart),
            label: 'Bargain Inspector',
          ),
          NavigationDestination(
            icon: Icon(Icons.balance),
            label: 'Decision Helper',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_paste),
            label: 'Snippets',
          ),
        ],
      ),
    );
  }

  // TAB 1: OVERLAY DOCK CONTROLS
  Widget _buildOverlayHubTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.indigo,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white70,
                    radius: 28,
                    child: Icon(Icons.widgets, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'OmniAssist Active Companion',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Floating screen helper, bargain calculator & micro decision engine.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Floating System Assistant',
            style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Show Floating Overlay Bubble'),
                  subtitle: const Text('Keeps quick tools accessible on top of screen'),
                  value: _isOverlayEnabled,
                  onChanged: (val) {
                    setState(() {
                      _isOverlayEnabled = val;
                    });
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.opacity, color: Colors.amber),
                  title: const Text('Night Screen Tint Overlay'),
                  subtitle: Text('Current tint intensity: ${(_screenTintOpacity * 100).toInt()}%'),
                  trailing: SizedBox(
                    width: 120,
                    child: Slider(
                      value: _screenTintOpacity,
                      min: 0.0,
                      max: 0.35,
                      activeColor: Colors.amber,
                      onChanged: (val) {
                        setState(() {
                          _screenTintOpacity = val;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Daily Micro Tools',
            style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAxisAlignment.start,
            children: [
              _buildFeatureCard(
                icon: Icons.shopping_cart,
                color: Colors.teal,
                title: 'Bargain Inspector',
                desc: 'Compare product price per 100g/ml to find real value.',
                onTap: () => setState(() => _currentIndex = 1),
              ),
              _buildFeatureCard(
                icon: Icons.balance,
                color: Colors.deepOrange,
                title: 'Decision Matrix',
                desc: 'Resolve choice paralysis with weighted scoring.',
                onTap: () => setState(() => _currentIndex = 2),
              ),
              _buildFeatureCard(
                icon: Icons.content_paste,
                color: Colors.purple,
                title: 'Snippet Clipboard',
                desc: 'Store phone numbers, tax IDs & codes for 1-tap copy.',
                onTap: () => setState(() => _currentIndex = 3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 165,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.15),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // TAB 2: BARGAIN & UNIT COST OPTIMIZER
  Widget _buildUnitCostOptimizerTab() {
    final double priceA = double.tryParse(_itemAPriceController.text) ?? 0.0;
    final double qtyA = double.tryParse(_itemAQtyController.text) ?? 1.0;
    final double unitCostA = qtyA > 0 ? (priceA / qtyA) * 100 : 0.0; // per 100 units

    final double priceB = double.tryParse(_itemBPriceController.text) ?? 0.0;
    final double qtyB = double.tryParse(_itemBQtyController.text) ?? 1.0;
    final double unitCostB = qtyB > 0 ? (priceB / qtyB) * 100 : 0.0; // per 100 units

    bool isABetter = unitCostA < unitCostB && priceA > 0 && priceB > 0;
    bool isBBetter = unitCostB < unitCostA && priceA > 0 && priceB > 0;
    bool isEqual = (unitCostA == unitCostB) && priceA > 0;

    double diffPercent = 0.0;
    if (unitCostA > 0 && unitCostB > 0) {
      final maxVal = unitCostA > unitCostB ? unitCostA : unitCostB;
      final minVal = unitCostA < unitCostB ? unitCostA : unitCostB;
      diffPercent = ((maxVal - minVal) / maxVal) * 100;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.shopping_cart, color: Colors.teal),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Bargain & Unit-Cost Inspector',
                  style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Compare two store packages to see which one gives true value per 100g/ml.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Item A Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isABetter ? Colors.green : Colors.grey.shade300,
                width: isABetter ? 2 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Product A',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isABetter ? Colors.green : Colors.indigo,
                        ),
                      ),
                      if (isABetter)
                        const Chip(
                          label: Text('BEST VALUE', style: TextStyle(color: Colors.white, fontSize: 10)),
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.zero,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _itemANameController,
                    decoration: const InputDecoration(
                      labelText: 'Package Name',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _itemAPriceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price (\$)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _itemAQtyController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Weight/Qty (g/ml)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unit Cost: \$${unitCostA.toStringAsFixed(2)} per 100g/ml',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Item B Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isBBetter ? Colors.green : Colors.grey.shade300,
                width: isBBetter ? 2 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Product B',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isBBetter ? Colors.green : Colors.indigo,
                        ),
                      ),
                      if (isBBetter)
                        const Chip(
                          label: Text('BEST VALUE', style: TextStyle(color: Colors.white, fontSize: 10)),
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.zero,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _itemBNameController,
                    decoration: const InputDecoration(
                      labelText: 'Package Name',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _itemBPriceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price (\$)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _itemBQtyController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Weight/Qty (g/ml)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unit Cost: \$${unitCostB.toStringAsFixed(2)} per 100g/ml',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Verdict Summary Banner
          Card(
            color: isABetter || isBBetter
                ? Colors.green.shade50
                : (isEqual ? Colors.blue.shade50 : Colors.grey.shade100),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Value Verdict',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  if (isABetter)
                    Text(
                      '${_itemANameController.text} is ${diffPercent.toStringAsFixed(1)}% CHEAPER per unit!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    )
                  else if (isBBetter)
                    Text(
                      '${_itemBNameController.text} is ${diffPercent.toStringAsFixed(1)}% CHEAPER per unit!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    )
                  else if (isEqual)
                    const Text(
                      'Both packages offer exact equal unit value!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    )
                  else
                    const Text(
                      'Enter valid pricing and quantity to view instant savings.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 3: MICRO-DECISION MATRIX
  Widget _buildDecisionMatrixTab() {
    double totalScoreA = 0;
    double totalScoreB = 0;
    double maxPossibleScore = 0;

    for (var factor in _decisionFactors) {
      int weight = factor['weight'] as int;
      int sA = factor['scoreA'] as int;
      int sB = factor['scoreB'] as int;

      totalScoreA += (sA * weight);
      totalScoreB += (sB * weight);
      maxPossibleScore += (10 * weight);
    }

    double ratioA = maxPossibleScore > 0 ? (totalScoreA / maxPossibleScore) : 0;
    double ratioB = maxPossibleScore > 0 ? (totalScoreB / maxPossibleScore) : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.balance, color: Colors.deepOrange),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Micro-Decision Engine',
                  style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Weigh important factors to overcome daily choice paralysis.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Option Inputs
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _optionAController,
                  decoration: const InputDecoration(
                    labelText: 'Option 1',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _optionBController,
                  decoration: const InputDecoration(
                    labelText: 'Option 2',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Decision Factors',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              TextButton.icon(
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Factor'),
                onPressed: _addNewDecisionFactor,
              ),
            ],
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _decisionFactors.length,
            itemBuilder: (context, idx) {
              final factor = _decisionFactors[idx];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              factor['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.grey, size: 18),
                            onPressed: () {
                              setState(() {
                                _decisionFactors.removeAt(idx);
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Importance: ', style: TextStyle(fontSize: 12)),
                          Expanded(
                            child: Slider(
                              value: (factor['weight'] as int).toDouble(),
                              min: 1,
                              max: 5,
                              divisions: 4,
                              label: '${factor['weight']}x',
                              onChanged: (val) {
                                setState(() {
                                  factor['weight'] = val.toInt();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Opt 1 Score: ${factor['scoreA']}/10', style: const TextStyle(fontSize: 11)),
                                Slider(
                                  value: (factor['scoreA'] as int).toDouble(),
                                  min: 1,
                                  max: 10,
                                  divisions: 9,
                                  activeColor: Colors.indigo,
                                  onChanged: (val) {
                                    setState(() {
                                      factor['scoreA'] = val.toInt();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Opt 2 Score: ${factor['scoreB']}/10', style: const TextStyle(fontSize: 11)),
                                Slider(
                                  value: (factor['scoreB'] as int).toDouble(),
                                  min: 1,
                                  max: 10,
                                  divisions: 9,
                                  activeColor: Colors.deepOrange,
                                  onChanged: (val) {
                                    setState(() {
                                      factor['scoreB'] = val.toInt();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Winner Score Gauge Banner
          Card(
            color: Colors.indigo.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Calculated Choice Winner',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              _optionAController.text,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: ratioA,
                              color: Colors.indigo,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            const SizedBox(height: 4),
                            Text('${(ratioA * 100).toStringAsFixed(0)}% Score', style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              _optionBController.text,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: ratioB,
                              color: Colors.deepOrange,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            const SizedBox(height: 4),
                            Text('${(ratioB * 100).toStringAsFixed(0)}% Score', style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (totalScoreA > totalScoreB)
                    Text(
                      'Recommended: ${_optionAController.text}!',
                      style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 15),
                      textAlign: TextAlign.center,
                    )
                  else if (totalScoreB > totalScoreA)
                    Text(
                      'Recommended: ${_optionBController.text}!',
                      style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 15),
                      textAlign: TextAlign.center,
                    )
                  else
                    const Text(
                      'Both options are tied in weighted decision value!',
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addNewDecisionFactor() {
    final TextEditingController factorTitleController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Decision Factor'),
        content: TextField(
          controller: factorTitleController,
          decoration: const InputDecoration(
            labelText: 'Factor Name (e.g. Warranty, Distance)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            child: const Text('Add'),
            onPressed: () {
              if (factorTitleController.text.trim().isNotEmpty) {
                setState(() {
                  _decisionFactors.add({
                    'name': factorTitleController.text.trim(),
                    'weight': 3,
                    'scoreA': 5,
                    'scoreB': 5,
                  });
                });
              }
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  // TAB 4: FLOATING CLIPBOARD VAULT
  Widget _buildClipboardVaultTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Snippet & Clipboard Vault',
                      style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Tap any item to copy instant text snippets.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.indigo, size: 32),
                onPressed: _showAddSnippetDialog,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _snippets.isEmpty
                ? const Center(
                    child: Text('No snippets stored yet. Tap + to add.'),
                  )
                : ListView.builder(
                    itemCount: _snippets.length,
                    itemBuilder: (context, idx) {
                      final item = _snippets[idx];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getCategoryColor(item['cat'] ?? 'Personal').withOpacity(0.2),
                            child: Icon(
                              _getCategoryIcon(item['cat'] ?? 'Personal'),
                              color: _getCategoryColor(item['cat'] ?? 'Personal'),
                              size: 20,
                            ),
                          ),
                          title: Text(
                            item['title'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            item['content'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.content_copy, color: Colors.indigo, size: 20),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Copied "${item['title']}" to clipboard!'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.grey, size: 20),
                                onPressed: () {
                                  setState(() {
                                    _snippets.removeAt(idx);
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
      ),
    );
  }

  void _showAddSnippetDialog() {
    _snippetTitleController.clear();
    _snippetContentController.clear();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Fast Snippet'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _snippetTitleController,
                decoration: const InputDecoration(
                  labelText: 'Snippet Title (e.g. Bank Account)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _snippetContentController,
                decoration: const InputDecoration(
                  labelText: 'Snippet Text Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCat,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Personal', child: Text('Personal')),
                  DropdownMenuItem(value: 'Work', child: Text('Work')),
                  DropdownMenuItem(value: 'Codes', child: Text('Codes & Passwords')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    _selectedCat = val;
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            child: const Text('Save Snippet'),
            onPressed: () {
              if (_snippetTitleController.text.trim().isNotEmpty &&
                  _snippetContentController.text.trim().isNotEmpty) {
                setState(() {
                  _snippets.add({
                    'title': _snippetTitleController.text.trim(),
                    'content': _snippetContentController.text.trim(),
                    'cat': _selectedCat,
                  });
                });
              }
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String cat) {
    switch (cat) {
      case 'Work':
        return Colors.blue;
      case 'Codes':
        return Colors.purple;
      default:
        return Colors.teal;
    }
  }

  IconData _getCategoryIcon(String cat) {
    switch (cat) {
      case 'Work':
        return Icons.info;
      case 'Codes':
        return Icons.star;
      default:
        return Icons.person;
    }
  }
}