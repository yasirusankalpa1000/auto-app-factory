import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const GlanceHudApp());
}

class GlanceHudApp extends StatelessWidget {
  const GlanceHudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlanceHUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.indigoAccent,
          secondary: Colors.tealAccent,
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class SnippetPin {
  String id;
  String title;
  String content;
  Color tagColor;
  bool isPinned;

  SnippetPin({
    required this.id,
    required this.title,
    required this.content,
    required this.tagColor,
    this.isPinned = true,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentTabIndex = 0;

  // Floating Overlay State Simulation
  bool _isOverlayActive = true;
  double _overlayOpacity = 0.85;
  Offset _bubblePosition = const Offset(20, 150);
  bool _showFloatingCard = false;

  // Snippet Pins State
  final List<SnippetPin> _snippets = [
    SnippetPin(
      id: '1',
      title: 'Tracking Code',
      content: 'TRK-8940291-LK',
      tagColor: Colors.teal,
    ),
    SnippetPin(
      id: '2',
      title: 'Delivery Address Note',
      content: 'Gate 4, Green Tower, Apt 12B',
      tagColor: Colors.amber,
    ),
    SnippetPin(
      id: '3',
      title: 'Discount Coupon',
      content: 'SAVE20NOW',
      tagColor: Colors.indigo,
    ),
  ];

  // Comparator State
  final TextEditingController _itemAWeightController = TextEditingController(text: '250');
  final TextEditingController _itemAPriceController = TextEditingController(text: '12.50');
  final TextEditingController _itemBWeightController = TextEditingController(text: '500');
  final TextEditingController _itemBPriceController = TextEditingController(text: '22.00');

  // Decision Matrix State
  final TextEditingController _choiceController = TextEditingController();
  final List<String> _decisions = ['Sushi', 'Pizza', 'Home Cooked Meal', 'Salad Bowl'];
  String _selectedDecision = '';
  bool _isSpinning = false;

  // Floating Notification Banner Simulation
  bool _floatingNotifyEnabled = true;

  @override
  void dispose() {
    _itemAWeightController.dispose();
    _itemAPriceController.dispose();
    _itemBWeightController.dispose();
    _itemBPriceController.dispose();
    _choiceController.dispose();
    super.dispose();
  }

  void _addNewSnippet(String title, String content, Color color) {
    if (title.trim().isEmpty || content.trim().isEmpty) return;
    setState(() {
      _snippets.insert(
        0,
        SnippetPin(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          content: content,
          tagColor: color,
        ),
      );
    });
  }

  void _pickRandomDecision() {
    if (_decisions.isEmpty) return;
    setState(() {
      _isSpinning = true;
      _selectedDecision = '';
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      final random = Random();
      setState(() {
        _selectedDecision = _decisions[random.nextInt(_decisions.length)];
        _isSpinning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 2,
        title: Row(
          children: [
            const Icon(Icons.widgets, color: Colors.indigoAccent),
            const SizedBox(width: 8),
            const Text(
              'GlanceHUD',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _isOverlayActive ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isOverlayActive ? Colors.green : Colors.red,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: _isOverlayActive ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isOverlayActive ? 'HUD ACTIVE' : 'HUD OFF',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _isOverlayActive ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Tab Views
            IndexedStack(
              index: _currentTabIndex,
              children: [
                _buildFloatingDockTab(),
                _buildComparatorTab(),
                _buildDecisionEngineTab(),
                _buildToolsAndSettingsTab(),
              ],
            ),

            // Simulated Draggable Floating Overlay Widget Bubble
            if (_isOverlayActive)
              Positioned(
                left: _bubblePosition.dx,
                top: _bubblePosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _bubblePosition = Offset(
                        (_bubblePosition.dx + details.delta.dx).clamp(0, MediaQuery.of(context).size.width - 70),
                        (_bubblePosition.dy + details.delta.dy).clamp(0, MediaQuery.of(context).size.height - 200),
                      );
                    });
                  },
                  onTap: () {
                    setState(() {
                      _showFloatingCard = !_showFloatingCard;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.indigoAccent.withOpacity(_overlayOpacity),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigoAccent.withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        )
                      ],
                      border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.layers, color: Colors.white, size: 24),
                        Text(
                          'HUD',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Floating Interactive Overlay Quick Card (Simulates Display Above Apps feature)
            if (_isOverlayActive && _showFloatingCard)
              Positioned(
                left: (_bubblePosition.dx - 100).clamp(10, MediaQuery.of(context).size.width - 290).toDouble(),
                top: (_bubblePosition.dy + 65).clamp(10, MediaQuery.of(context).size.height - 350).toDouble(),
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFF1E293B).withOpacity(_overlayOpacity),
                  child: Container(
                    width: 280,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.indigoAccent.withOpacity(0.5)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.flash_on, color: Colors.amber, size: 18),
                            const SizedBox(width: 6),
                            const Text(
                              'Floating HUD Pinboard',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showFloatingCard = false;
                                });
                              },
                              child: const Icon(Icons.close, size: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                        const Divider(height: 16, color: Colors.white70),
                        if (_snippets.isEmpty)
                          const Text(
                            'No sticky pins saved.',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          )
                        else
                          Column(
                            children: _snippets.take(2).map((snippet) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: snippet.tagColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: snippet.tagColor.withOpacity(0.4)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snippet.title,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                              color: snippet.tagColor,
                                            ),
                                          ),
                                          Text(
                                            snippet.content,
                                            style: const TextStyle(fontSize: 12, color: Colors.white),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.copy, size: 16, color: Colors.white70),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Copied: ${snippet.content}'),
                                            duration: const Duration(seconds: 1),
                                            backgroundColor: Colors.indigo,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigoAccent,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                            ),
                            onPressed: () {
                              _showAddSnippetDialog();
                            },
                            icon: const Icon(Icons.add, size: 16, color: Colors.white),
                            label: const Text('Quick Pin', style: TextStyle(fontSize: 12, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
        selectedItemColor: Colors.indigoAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1E293B),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Overlay Dock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Comparator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.touch_app),
            label: 'Decision Wheel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Tools & HUD',
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating Overlay Dock & Pinboard
  Widget _buildFloatingDockTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.indigo, Color(0xFF312E81)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.notifications_active, color: Colors.amber, size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Active Screen Overlay HUD',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            'Keep micro references & tools floating while using other apps.',
                            style: TextStyle(fontSize: 12, color: Colors.white70),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SwitchListTile(
                        value: _isOverlayActive,
                        activeColor: Colors.tealAccent,
                        title: const Text('Toggle Overlay Bubble', style: TextStyle(fontSize: 13, color: Colors.white)),
                        contentPadding: EdgeInsets.zero,
                        onChanged: (val) {
                          setState(() {
                            _isOverlayActive = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Snippet Control Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sticky Clipboard Pins',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _showAddSnippetDialog,
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: const Text('New Pin', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (_snippets.isEmpty)
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.push_pin, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('No floating pins saved yet.', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _snippets.length,
              itemBuilder: (context, index) {
                final snippet = _snippets[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: snippet.tagColor.withOpacity(0.5), width: 1.5),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: snippet.tagColor.withOpacity(0.2),
                      child: Icon(Icons.push_pin, color: snippet.tagColor, size: 20),
                    ),
                    title: Text(
                      snippet.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        snippet.content,
                        style: const TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.content_copy, color: Colors.tealAccent),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Copied: ${snippet.content}'),
                                duration: const Duration(seconds: 1),
                                backgroundColor: Colors.teal,
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            setState(() {
                              _snippets.removeAt(index);
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

  // TAB 2: Smart Side-by-Side Unit Price & Savings Comparator
  Widget _buildComparatorTab() {
    double itemAWeight = double.tryParse(_itemAWeightController.text) ?? 1.0;
    double itemAPrice = double.tryParse(_itemAPriceController.text) ?? 0.0;
    double itemBWeight = double.tryParse(_itemBWeightController.text) ?? 1.0;
    double itemBPrice = double.tryParse(_itemBPriceController.text) ?? 0.0;

    double unitPriceA = itemAWeight > 0 ? (itemAPrice / itemAWeight) : 0;
    double unitPriceB = itemBWeight > 0 ? (itemBPrice / itemBWeight) : 0;

    bool isABetter = unitPriceA > 0 && unitPriceB > 0 && unitPriceA < unitPriceB;
    bool isBBetter = unitPriceA > 0 && unitPriceB > 0 && unitPriceB < unitPriceA;

    double savingsPercent = 0.0;
    if (isABetter && unitPriceB > 0) {
      savingsPercent = ((unitPriceB - unitPriceA) / unitPriceB) * 100;
    } else if (isBBetter && unitPriceA > 0) {
      savingsPercent = ((unitPriceA - unitPriceB) / unitPriceA) * 100;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Deal & Price Comparator',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Compare cost per unit (grams, ml, pieces) to find the real best deal instantly.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Option A and Option B Side by Side
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Option A Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isABetter ? Colors.teal.withOpacity(0.15) : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isABetter ? Colors.tealAccent : Colors.white70,
                      width: isABetter ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'OPTION A',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isABetter ? Colors.tealAccent : Colors.white,
                            ),
                          ),
                          if (isABetter) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.check_circle, color: Colors.tealAccent, size: 16),
                          ]
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _itemAWeightController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'Quantity/Weight',
                          labelStyle: TextStyle(fontSize: 11, color: Colors.grey),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _itemAPriceController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'Price (\$)',
                          labelStyle: TextStyle(fontSize: 11, color: Colors.grey),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FittedBox(
                        child: Text(
                          'Unit Cost: \$${unitPriceA.toStringAsFixed(4)}/unit',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isABetter ? Colors.tealAccent : Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Option B Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isBBetter ? Colors.teal.withOpacity(0.15) : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isBBetter ? Colors.tealAccent : Colors.white70,
                      width: isBBetter ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'OPTION B',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isBBetter ? Colors.tealAccent : Colors.white,
                            ),
                          ),
                          if (isBBetter) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.check_circle, color: Colors.tealAccent, size: 16),
                          ]
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _itemBWeightController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'Quantity/Weight',
                          labelStyle: TextStyle(fontSize: 11, color: Colors.grey),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _itemBPriceController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'Price (\$)',
                          labelStyle: TextStyle(fontSize: 11, color: Colors.grey),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FittedBox(
                        child: Text(
                          'Unit Cost: \$${unitPriceB.toStringAsFixed(4)}/unit',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isBBetter ? Colors.tealAccent : Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Savings Verdict Card
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.indigoAccent.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                const Text(
                  'SAVINGS VERDICT',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                if (!isABetter && !isBBetter)
                  const Text(
                    'Both options offer identical unit value!',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.amber),
                  )
                else
                  Wrap(
                    crossAxisAlignment: WrapCrossAxisAlignment.center,
                    alignment: WrapAlignment.center,
                    spacing: 6,
                    children: [
                      Text(
                        isABetter ? 'Option A' : 'Option B',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                      ),
                      const Text(
                        'saves you',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${savingsPercent.toStringAsFixed(1)}%',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                        ),
                      ),
                      const Text(
                        'more money!',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 3: Interactive Micro-Decision Engine
  Widget _buildDecisionEngineTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Decision Matrix & Choice Spinner',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Stuck on what to eat, buy, or do first? Let the matrix solve daily indecisions.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Add New Choice Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _choiceController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Add new choice (e.g. Tacos)...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: () {
                  if (_choiceController.text.trim().isNotEmpty) {
                    setState(() {
                      _decisions.add(_choiceController.text.trim());
                      _choiceController.clear();
                    });
                  }
                },
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Active Choices Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _decisions.map((decision) {
              return Chip(
                backgroundColor: const Color(0xFF1E293B),
                side: const BorderSide(color: Colors.indigoAccent),
                label: Text(decision, style: const TextStyle(color: Colors.white, fontSize: 12)),
                deleteIcon: const Icon(Icons.close, size: 14, color: Colors.grey),
                onDeleted: () {
                  setState(() {
                    _decisions.remove(decision);
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Visual Pick Wheel / Generator Box
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF1E293B), const Color(0xFF0F172A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.indigoAccent.withOpacity(0.6), width: 2),
            ),
            child: Column(
              children: [
                const Icon(Icons.stars, size: 48, color: Colors.amber),
                const SizedBox(height: 12),
                if (_isSpinning)
                  const Column(
                    children: [
                      CircularProgressIndicator(color: Colors.tealAccent),
                      SizedBox(height: 12),
                      Text('Evaluating Probability Matrix...', style: TextStyle(color: Colors.tealAccent, fontSize: 12)),
                    ],
                  )
                else if (_selectedDecision.isNotEmpty)
                  Column(
                    children: [
                      const Text('THE MATRIX HAS DECIDED:', style: TextStyle(fontSize: 11, color: Colors.grey, letterSpacing: 1.2)),
                      const SizedBox(height: 6),
                      Text(
                        _selectedDecision,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                else
                  const Text(
                    'Tap Spin to resolve your decision',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _decisions.isEmpty ? null : _pickRandomDecision,
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text('SPIN CHOICE ENGINE', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 4: Overlay Tools & Permission Console
  Widget _buildToolsAndSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'HUD Settings & Micro-Tools',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Customize overlay opacity, floating notifications, and precision tools.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Opacity Slider Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.opacity, color: Colors.indigoAccent),
                    const SizedBox(width: 8),
                    Text(
                      'Floating HUD Opacity: ${(_overlayOpacity * 100).toInt()}%',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                Slider(
                  value: _overlayOpacity,
                  min: 0.3,
                  max: 1.0,
                  activeColor: Colors.indigoAccent,
                  inactiveColor: Colors.white70,
                  onChanged: (val) {
                    setState(() {
                      _overlayOpacity = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Notification Alert Bar Toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              title: const Text('Floating Quick Alerts', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
              subtitle: const Text('Show top notification alerts for quick snippet copies', style: TextStyle(fontSize: 11, color: Colors.grey)),
              value: _floatingNotifyEnabled,
              activeColor: Colors.tealAccent,
              onChanged: (val) {
                setState(() {
                  _floatingNotifyEnabled = val;
                });
              },
            ),
          ),
          const SizedBox(height: 16),

          // Permission Simulator Console
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'System Overlay Permissions Status',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 12),
                _buildPermissionRow('Display Over Other Apps', true),
                const Divider(height: 16, color: Colors.white70),
                _buildPermissionRow('Floating Notifications', _floatingNotifyEnabled),
                const Divider(height: 16, color: Colors.white70),
                _buildPermissionRow('Clipboard Auto-Sync', true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRow(String title, bool isGranted) {
    return Row(
      children: [
        Icon(
          isGranted ? Icons.check_circle : Icons.warning,
          color: isGranted ? Colors.green : Colors.amber,
          size: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: isGranted ? Colors.green.withOpacity(0.2) : Colors.amber.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            isGranted ? 'GRANTED' : 'PENDING',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isGranted ? Colors.green : Colors.amber,
            ),
          ),
        ),
      ],
    );
  }

  void _showAddSnippetDialog() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    Color selectedColor = Colors.teal;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E293B),
              title: const Text('New Sticky Pin', style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Pin Title (e.g. Order ID)',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: contentCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Content to Quick-Copy',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [Colors.teal, Colors.amber, Colors.indigo, Colors.purple, Colors.orange].map((color) {
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            selectedColor = color;
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: color,
                          radius: 14,
                          child: selectedColor == color
                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigoAccent),
                  onPressed: () {
                    _addNewSnippet(titleCtrl.text, contentCtrl.text, selectedColor);
                    Navigator.pop(context);
                  },
                  child: const Text('Save Pin', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}