import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OverlayDexApp());
}

class OverlayDexApp extends StatelessWidget {
  const OverlayDexApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlayDex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
          primary: Colors.indigo,
          secondary: Colors.teal,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xF3F4F6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    FloatingHudTab(),
    BargainComparatorTab(),
    SnippetStashTab(),
    BillSplitterTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
        items: const [
          BottomNavigationBarThemeData(),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            activeIcon: Icon(Icons.widgets_outlined),
            label: 'Floating HUD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Bargain Check',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Clip Stash',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Bill Splitter',
          ),
        ],
      ),
    );
  }
}

// ------------------- TAB 1: FLOATING HUD SIMULATOR -------------------
class FloatingHudTab extends StatefulWidget {
  const FloatingHudTab({Key? key}) : super(key: key);

  @override
  State<FloatingHudTab> createState() => _FloatingHudTabState();
}

class _FloatingHudTabState extends State<FloatingHudTab> {
  bool _hudEnabled = true;
  bool _floatingNotification = true;
  String _selectedStyle = 'Compact Pill';
  Offset _bubblePosition = const Offset(120, 160);
  bool _showExpandedMenu = false;

  final List<String> _hudStyles = ['Compact Pill', 'Corner Arc', 'Floating Dock'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Banner
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bolt, color: Colors.amber, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'OverlayDex HUD Engine',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Keep vital micro-tools active over any screen context.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Controls Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overlay Controls & System Permissions',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Display Above Apps (Simulated HUD)'),
                      subtitle: const Text('Allows floating bubble micro-tools overlay'),
                      value: _hudEnabled,
                      activeColor: Colors.indigo,
                      onChanged: (val) => setState(() => _hudEnabled = val),
                    ),
                    const Divider(),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Floating Notification Banner'),
                      subtitle: const Text('Sticky quick-action persistent status bar'),
                      value: _floatingNotification,
                      activeColor: Colors.teal,
                      onChanged: (val) => setState(() => _floatingNotification = val),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Select Overlay Preset Style:',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _hudStyles.map((style) {
                        final isSelected = _selectedStyle == style;
                        return ChoiceChip(
                          label: Text(style),
                          selected: isSelected,
                          selectedColor: Colors.indigo,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedStyle = style);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Live Interactive Overlay Phone Screen Preview
            const Text(
              'Live HUD Interactive Playground',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 320,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.indigo, width: 2),
              ),
              child: Stack(
                children: [
                  // Mock Phone Background
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.phone_android, color: Colors.white70, size: 64),
                        SizedBox(height: 8),
                        Text(
                          'Simulated Screen Area',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        Text(
                          'Drag or tap the floating bubble below!',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),

                  // Simulated Floating Notification Bar
                  if (_floatingNotification)
                    Positioned(
                      top: 12,
                      left: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.indigo.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.bolt, color: Colors.amber, size: 18),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'OverlayDex Active - Tap for Quick Stash',
                                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(Icons.circle, color: Colors.greenAccent, size: 10),
                          ],
                        ),
                      ),
                    ),

                  // Simulated Draggable Floating Overlay Widget
                  if (_hudEnabled)
                    Positioned(
                      left: _bubblePosition.dx,
                      top: _bubblePosition.dy,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            double newX = _bubblePosition.dx + details.delta.dx;
                            double newY = _bubblePosition.dy + details.delta.dy;
                            newX = newX.clamp(10.0, 240.0);
                            newY = newY.clamp(40.0, 250.0);
                            _bubblePosition = Offset(newX, newY);
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () => setState(() => _showExpandedMenu = !_showExpandedMenu),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _selectedStyle == 'Compact Pill'
                                      ? Colors.teal
                                      : (_selectedStyle == 'Corner Arc' ? Colors.deepPurple : Colors.indigo),
                                  shape: BoxShape.circle,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black87,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    )
                                  ],
                                ),
                                child: const Icon(Icons.widgets, color: Colors.white, size: 24),
                              ),
                            ),
                            if (_showExpandedMenu)
                              Container(
                                margin: const EdgeInsets.top(6),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(color: Colors.black87, blurRadius: 6),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    _buildHudMiniAction(Icons.calculate, 'Calc', Colors.indigo),
                                    _buildHudMiniAction(Icons.content_copy, 'Clip', Colors.teal),
                                    _buildHudMiniAction(Icons.compare_arrows, 'Bargain', Colors.amber.shade800),
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
            const SizedBox(height: 16),

            // Quick Productivity Stats Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Streak', '5 Days', Icons.star, Colors.amber),
                  _buildStatItem('HUD Snips', '18 Saved', Icons.layers, Colors.teal),
                  _buildStatItem('Bargains', '12 Done', Icons.shopping_bag, Colors.indigo),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHudMiniAction(IconData icon, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }
}

// ------------------- TAB 2: BARGAIN & UNIT PRICE COMPARATOR -------------------
class BargainComparatorTab extends StatefulWidget {
  const BargainComparatorTab({Key? key}) : super(key: key);

  @override
  State<BargainComparatorTab> createState() => _BargainComparatorTabState();
}

class _BargainComparatorTabState extends State<BargainComparatorTab> {
  final TextEditingController _priceAController = TextEditingController(text: '4.50');
  final TextEditingController _qtyAController = TextEditingController(text: '500');
  final TextEditingController _priceBController = TextEditingController(text: '6.20');
  final TextEditingController _qtyBController = TextEditingController(text: '750');
  final TextEditingController _discountController = TextEditingController(text: '0');

  String _unit = 'Grams (g)';
  final List<String> _unitOptions = ['Grams (g)', 'Kilograms (kg)', 'Milliliters (ml)', 'Liters (L)', 'Units/Packs'];

  double _costPerUnitA = 0.0;
  double _costPerUnitB = 0.0;
  String _recommendation = '';
  double _savingsPercent = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateComparison();
  }

  void _calculateComparison() {
    final priceA = double.tryParse(_priceAController.text) ?? 0.0;
    final qtyA = double.tryParse(_qtyAController.text) ?? 1.0;
    final priceB = double.tryParse(_priceBController.text) ?? 0.0;
    final qtyB = double.tryParse(_qtyBController.text) ?? 1.0;
    final discount = double.tryParse(_discountController.text) ?? 0.0;

    final netPriceA = priceA * (1 - (discount / 100));
    final netPriceB = priceB * (1 - (discount / 100));

    final unitA = qtyA > 0 ? (netPriceA / qtyA) : 0.0;
    final unitB = qtyB > 0 ? (netPriceB / qtyB) : 0.0;

    setState(() {
      _costPerUnitA = unitA;
      _costPerUnitB = unitB;

      if (unitA > 0 && unitB > 0) {
        if (unitA < unitB) {
          final diff = ((unitB - unitA) / unitB) * 100;
          _savingsPercent = diff;
          _recommendation = 'Option A is ${diff.toStringAsFixed(1)}% CHEAPER per unit!';
        } else if (unitB < unitA) {
          final diff = ((unitA - unitB) / unitA) * 100;
          _savingsPercent = diff;
          _recommendation = 'Option B is ${diff.toStringAsFixed(1)}% CHEAPER per unit!';
        } else {
          _savingsPercent = 0.0;
          _recommendation = 'Both options offer identical per-unit value!';
        }
      } else {
        _recommendation = 'Enter valid pricing & quantity above.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bargain & Smart Unit Price Comparator',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 4),
            const Text(
              'Instantly check which deal actually gives you more value.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Unit Selector & Multi Discount Input
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _unit,
                        decoration: const InputDecoration(
                          labelText: 'Measurement Unit',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        items: _unitOptions.map((u) {
                          return DropdownMenuItem(value: u, child: Text(u, style: const TextStyle(fontSize: 12)));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _unit = val);
                            _calculateComparison();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _discountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Global Discount %',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        onChanged: (_) => _calculateComparison(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Option A Input Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.shopping_bag, color: Colors.blue),
                      SizedBox(width: 6),
                      Text('Option A (Standard Pack)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _priceAController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price (\$) =',
                            border: OutlineInputBorder(),
                            prefixText: '\$ ',
                          ),
                          onChanged: (_) => _calculateComparison(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _qtyAController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Quantity / Weight',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => _calculateComparison(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unit Cost A: \$${_costPerUnitA.toStringAsFixed(4)} per unit',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Option B Input Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.shopping_bag_outlined, color: Colors.teal),
                      SizedBox(width: 6),
                      Text('Option B (Promo / Bulk Pack)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _priceBController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price (\$) =',
                            border: OutlineInputBorder(),
                            prefixText: '\$ ',
                          ),
                          onChanged: (_) => _calculateComparison(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _qtyBController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Quantity / Weight',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => _calculateComparison(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unit Cost B: \$${_costPerUnitB.toStringAsFixed(4)} per unit',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Smart Verdict Badge Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black87, blurRadius: 6, offset: Offset(0, 3)),
                ],
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.stars, color: Colors.amber, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'OverlayDex Recommendation',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _recommendation,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                    softWrap: true,
                  ),
                  if (_savingsPercent > 0) ...[
                    const SizedBox(height: 8),
                    Chip(
                      backgroundColor: Colors.amber,
                      label: Text(
                        'Save ${_savingsPercent.toStringAsFixed(1)}% on this pick!',
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------- TAB 3: CLIPBOARD & SNIPPET STASH -------------------
class SnippetStashTab extends StatefulWidget {
  const SnippetStashTab({Key? key}) : super(key: key);

  @override
  State<SnippetStashTab> createState() => _SnippetStashTabState();
}

class SnippetItem {
  final String id;
  final String title;
  final String content;
  final String category;
  bool isPinned;

  SnippetItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.isPinned = false,
  });
}

class _SnippetStashTabState extends State<SnippetStashTab> {
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: '1',
      title: 'Home Address Snippet',
      content: '742 Evergreen Terrace, Springfield, OR 97477',
      category: 'Addresses',
      isPinned: true,
    ),
    SnippetItem(
      id: '2',
      title: 'Wi-Fi Guest Password',
      content: 'OverlayDexGuest2025!',
      category: 'Codes',
      isPinned: true,
    ),
    SnippetItem(
      id: '3',
      title: 'Promo Code Discount',
      content: 'SAVE20OVERLAY',
      category: 'Promo',
    ),
  ];

  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Addresses', 'Codes', 'Promo', 'Notes'];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _newCategory = 'Notes';

  void _addSnippet() {
    if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) return;

    setState(() {
      _snippets.insert(
        0,
        SnippetItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          category: _newCategory,
        ),
      );
      _titleController.clear();
      _contentController.clear();
    });
    Navigator.of(context).pop();
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard! Ready for HUD fast paste.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showAddDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Quick Stash Snippet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title / Reference Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Snippet Content (Text, Phone, Code, Link)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _newCategory,
                decoration: const InputDecoration(
                  labelText: 'Category Tag',
                  border: OutlineInputBorder(),
                ),
                items: ['Addresses', 'Codes', 'Promo', 'Notes'].map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) {
                  if (val != null) _newCategory = val;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addSnippet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.check),
                  label: const Text('Save to HUD Stash'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredSnippets = _selectedCategory == 'All'
        ? _snippets
        : _snippets.where((s) => s.category == _selectedCategory).toList();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Clip Stash & Snippet Stack',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
                        ),
                        Text('1-Tap Copy micro notes for floating HUD', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    IconButton(
                      onPressed: _showAddDialog,
                      icon: const Icon(Icons.add_circle, color: Colors.indigo, size: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Category Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((cat) {
                      final isSel = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: FilterChip(
                          label: Text(cat),
                          selected: isSel,
                          selectedColor: Colors.indigo,
                          labelStyle: TextStyle(
                            color: isSel ? Colors.white : Colors.black,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedCategory = cat);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Snippets List
          Expanded(
            child: filteredSnippets.isEmpty
                ? const Center(
                    child: Text('No snippets stashed yet. Tap + to create one!'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredSnippets.length,
                    itemBuilder: (ctx, idx) {
                      final item = filteredSnippets[idx];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Chip(
                                    label: Text(item.category, style: const TextStyle(fontSize: 10, color: Colors.white)),
                                    backgroundColor: Colors.teal,
                                    padding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      item.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                                      color: item.isPinned ? Colors.indigo : Colors.grey,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        item.isPinned = !item.isPinned;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        _snippets.removeWhere((s) => s.id == item.id);
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item.content,
                                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                                  softWrap: true,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                  onPressed: () => _copyToClipboard(item.content),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo,
                                    foregroundColor: Colors.white,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  icon: const Icon(Icons.content_copy, size: 14),
                                  label: const Text('Copy Text'),
                                ),
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
}

// ------------------- TAB 4: QUICK BILL SPLITTER -------------------
class BillSplitterTab extends StatefulWidget {
  const BillSplitterTab({Key? key}) : super(key: key);

  @override
  State<BillSplitterTab> createState() => _BillSplitterTabState();
}

class _BillSplitterTabState extends State<BillSplitterTab> {
  final TextEditingController _totalAmountController = TextEditingController(text: '85.50');
  double _tipPercentage = 15.0;
  int _personCount = 3;

  double get _totalBill => double.tryParse(_totalAmountController.text) ?? 0.0;
  double get _tipAmount => _totalBill * (_tipPercentage / 100);
  double get _grandTotal => _totalBill + _tipAmount;
  double get _perPersonShare => _personCount > 0 ? (_grandTotal / _personCount) : 0.0;

  void _shareBreakdown() {
    final summary = 'OverlayDex Bill Breakdown:\n'
        'Total: \$${_totalBill.toStringAsFixed(2)}\n'
        'Tip (${_tipPercentage.toInt()}%): \$${_tipAmount.toStringAsFixed(2)}\n'
        'Grand Total: \$${_grandTotal.toStringAsFixed(2)}\n'
        'People: $_personCount\n'
        'Per Person Share: \$${_perPersonShare.toStringAsFixed(2)}';

    Clipboard.setData(ClipboardData(text: summary));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bill Summary copied to clipboard! Ready to send to friends.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Smart Bill & Tip Splitter',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 4),
            const Text(
              'Calculate individual shares instantly and share cleanly.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Input Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _totalAmountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Total Bill Amount (\$) =',
                        prefixText: '\$ ',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    // Tip Selection
                    Text(
                      'Tip Percentage: ${_tipPercentage.toInt()}% (\$${_tipAmount.toStringAsFixed(2)})',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Slider(
                      value: _tipPercentage,
                      min: 0,
                      max: 30,
                      divisions: 30,
                      activeColor: Colors.indigo,
                      label: '${_tipPercentage.toInt()}%',
                      onChanged: (val) => setState(() => _tipPercentage = val),
                    ),
                    Wrap(
                      spacing: 8,
                      children: [0.0, 10.0, 15.0, 18.0, 20.0].map((pct) {
                        return ChoiceChip(
                          label: Text('${pct.toInt()}%'),
                          selected: _tipPercentage == pct,
                          selectedColor: Colors.indigo,
                          labelStyle: TextStyle(
                            color: _tipPercentage == pct ? Colors.white : Colors.black,
                          ),
                          onSelected: (_) => setState(() => _tipPercentage = pct),
                        );
                      }).toList(),
                    ),
                    const Divider(height: 24),

                    // Person Counter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Split Between People:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.indigo),
                              onPressed: () {
                                if (_personCount > 1) setState(() => _personCount--);
                              },
                            ),
                            Text('$_personCount', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: Colors.indigo),
                              onPressed: () => setState(() => _personCount++),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Share Card Breakdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade700,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'EACH PERSON PAYS',
                    style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1),
                  ),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '\$${_perPersonShare.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(color: Colors.white70, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem('Total Bill', '\$${_totalBill.toStringAsFixed(2)}'),
                      _buildSummaryItem('Tip Added', '\$${_tipAmount.toStringAsFixed(2)}'),
                      _buildSummaryItem('Grand Total', '\$${_grandTotal.toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _shareBreakdown,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.teal.shade900,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.share),
                      label: const Text('Copy Bill Summary Card', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}