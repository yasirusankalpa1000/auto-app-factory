import 'package:flutter/material.dart';

void main() {
  runApp(const SnapDeckApp());
}

class SnapDeckApp extends StatelessWidget {
  const SnapDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapDeck Assist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      home: const MainDeckScreen(),
    );
  }
}

class DealItem {
  final String id;
  final String name;
  final double price;
  final double quantity;
  final String unit;

  DealItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.unit,
  });

  double get unitPrice => quantity > 0 ? price / quantity : 0;
}

class StashClip {
  final String id;
  final String title;
  final String content;
  final DateTime timestamp;

  StashClip({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
  });
}

class PinnedNote {
  final String id;
  final String text;
  final Color color;

  PinnedNote({
    required this.id,
    required this.text,
    required this.color,
  });
}

class MainDeckScreen extends StatefulWidget {
  const MainDeckScreen({super.key});

  @override
  State<MainDeckScreen> createState() => _MainDeckScreenState();
}

class _MainDeckScreenState extends State<MainDeckScreen> {
  int _currentTabIndex = 0;

  // Floating Overlay State
  Offset _floatingOffset = const Offset(16, 120);
  bool _isOverlayExpanded = false;
  bool _isOverlayEnabled = true;
  bool _notificationsEnabled = true;

  // Deal Battle State
  final List<DealItem> _dealItems = [
    DealItem(
      id: '1',
      name: 'Brand A (Standard Box)',
      price: 12.50,
      quantity: 450,
      unit: 'g',
    ),
    DealItem(
      id: '2',
      name: 'Brand B (Mega Pack)',
      price: 18.90,
      quantity: 800,
      unit: 'g',
    ),
  ];

  final TextEditingController _dealNameController = TextEditingController();
  final TextEditingController _dealPriceController = TextEditingController();
  final TextEditingController _dealQtyController = TextEditingController();
  String _selectedUnit = 'g';

  // Impulse Calculator State
  final TextEditingController _hourlyWageController = TextEditingController(text: '22.50');
  final TextEditingController _itemPriceController = TextEditingController(text: '149.99');
  final TextEditingController _itemNameController = TextEditingController(text: 'Wireless Headphones');

  // Clipboard & Stash State
  final TextEditingController _rawTextController = TextEditingController();
  final List<StashClip> _stashList = [];

  // Floating Pinned Notes
  final List<PinnedNote> _pinnedNotes = [
    PinnedNote(
      id: 'n1',
      text: 'Milk & Eggs store coupon: SAVE10',
      color: Colors.amber,
    ),
    PinnedNote(
      id: 'n2',
      text: 'Wi-Fi Password: Guest2025#Connect',
      color: Colors.teal,
    ),
  ];
  final TextEditingController _newNoteController = TextEditingController();

  @override
  void dispose() {
    _dealNameController.dispose();
    _dealPriceController.dispose();
    _dealQtyController.dispose();
    _hourlyWageController.dispose();
    _itemPriceController.dispose();
    _itemNameController.dispose();
    _rawTextController.dispose();
    _newNoteController.dispose();
    super.dispose();
  }

  void _addDealItem() {
    final name = _dealNameController.text.trim();
    final price = double.tryParse(_dealPriceController.text) ?? 0.0;
    final qty = double.tryParse(_dealQtyController.text) ?? 0.0;

    if (name.isNotEmpty && price > 0 && qty > 0) {
      setState(() {
        _dealItems.add(
          DealItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: name,
            price: price,
            quantity: qty,
            unit: _selectedUnit,
          ),
        );
        _dealNameController.clear();
        _dealPriceController.clear();
        _dealQtyController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added to comparison matrix!')),
      );
    }
  }

  void _removeDealItem(String id) {
    setState(() {
      _dealItems.removeWhere((item) => item.id == id);
    });
  }

  void _cleanUrls() {
    String text = _rawTextController.text;
    if (text.isEmpty) return;
    text = text.replaceAll(RegExp(r'\?utm_[^&\s]+(&utm_[^&\s]+)*'), '');
    text = text.replaceAll(RegExp(r'&utm_[^&\s]+'), '');
    text = text.replaceAll(RegExp(r'\?fbclid=[^&\s]+'), '');
    setState(() {
      _rawTextController.text = text.trim();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tracking parameters stripped!')),
    );
  }

  void _extractPhones() {
    String text = _rawTextController.text;
    if (text.isEmpty) return;
    final regExp = RegExp(r'(\+?\d{1,3}[\s-]?)?\(?\d{2,4}\)?[\s-]?\d{3,4}[\s-]?\d{3,4}');
    final matches = regExp.allMatches(text).map((m) => m.group(0)).where((e) => e != null).join('\n');
    if (matches.isNotEmpty) {
      setState(() {
        _rawTextController.text = matches;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone numbers extracted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No valid phone numbers found in text.')),
      );
    }
  }

  void _stashCurrentText() {
    final text = _rawTextController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _stashList.insert(
          0,
          StashClip(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: text.length > 25 ? '${text.substring(0, 25)}...' : text,
            content: text,
            timestamp: DateTime.now(),
          ),
        );
        _rawTextController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Text stashed to quick deck!')),
      );
    }
  }

  void _addPinnedNote() {
    final text = _newNoteController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _pinnedNotes.add(
          PinnedNote(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: text,
            color: Colors.amber,
          ),
        );
        _newNoteController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.layers, color: Colors.amber),
            SizedBox(width: 8),
            Text(
              'SnapDeck Assist',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isOverlayEnabled ? Icons.widgets : Icons.widgets_outlined,
              color: _isOverlayEnabled ? Colors.amber : Colors.white70,
            ),
            tooltip: 'Toggle Draggable Floating Assist Overlay',
            onPressed: () {
              setState(() {
                _isOverlayEnabled = !_isOverlayEnabled;
              });
            },
          ),
          IconButton(
            icon: Icon(
              _notificationsEnabled ? Icons.notifications_active : Icons.notifications_off,
              color: _notificationsEnabled ? Colors.greenAccent : Colors.white70,
            ),
            tooltip: 'Toggle Active Overlay Status',
            onPressed: () {
              setState(() {
                _notificationsEnabled = !_notificationsEnabled;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main Body Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopStatusBar(),
                  const SizedBox(height: 16),
                  _buildTabBar(),
                  const SizedBox(height: 16),
                  _buildActiveTabContent(),
                  const SizedBox(height: 80), // Padding for floating overlay space
                ],
              ),
            ),
          ),

          // Floating System Assist Widget (Draggable Floating Overlay Simulator)
          if (_isOverlayEnabled)
            Positioned(
              left: _floatingOffset.dx,
              top: _floatingOffset.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    double newX = _floatingOffset.dx + details.delta.dx;
                    double newY = _floatingOffset.dy + details.delta.dy;
                    // Keep floating overlay within screen bounds
                    newX = newX.clamp(0.0, size.width - (_isOverlayExpanded ? 290 : 64));
                    newY = newY.clamp(0.0, size.height - (_isOverlayExpanded ? 360 : 120));
                    _floatingOffset = Offset(newX, newY);
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _isOverlayExpanded ? 280 : 60,
                  height: _isOverlayExpanded ? 340 : 60,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade900,
                    borderRadius: BorderRadius.circular(_isOverlayExpanded ? 20 : 30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black87,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: _isOverlayExpanded
                        ? _buildExpandedOverlayContent()
                        : InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {
                              setState(() {
                                _isOverlayExpanded = true;
                              });
                            },
                            child: const Center(
                              child: Icon(
                                Icons.open_with,
                                color: Colors.amber,
                                size: 28,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        selectedItemColor: Colors.indigo.shade900,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Deal Battle',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Impulse Check',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: 'Stash & Clean',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.push_pin),
            label: 'Floating Pins',
          ),
        ],
      ),
    );
  }

  Widget _buildTopStatusBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.indigo.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.bolt, color: Colors.indigo.shade900),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isOverlayEnabled
                      ? 'Draggable Overlay Active (Drag widget anywhere on screen)'
                      : 'Draggable Overlay Paused',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade900,
                    fontSize: 13,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Quickly access pinned notes & tools over other tasks',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 11),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final titles = [
      'Deal Matcher',
      'Impulse Reality',
      'Text Sanitizer',
      'Pinned Deck',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(titles.length, (index) {
          final isSelected = _currentTabIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(titles[index]),
              selected: isSelected,
              selectedColor: Colors.indigo.shade900,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _currentTabIndex = index;
                  });
                }
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActiveTabContent() {
    switch (_currentTabIndex) {
      case 0:
        return _buildDealBattleTab();
      case 1:
        return _buildImpulseCheckTab();
      case 2:
        return _buildTextCleanerTab();
      case 3:
        return _buildPinnedDeckTab();
      default:
        return _buildDealBattleTab();
    }
  }

  // --- TAB 1: DEAL BATTLE ---
  Widget _buildDealBattleTab() {
    // Find best deal item
    DealItem? bestDeal;
    if (_dealItems.isNotEmpty) {
      bestDeal = _dealItems.reduce(
        (curr, next) => (curr.unitPrice < next.unitPrice) ? curr : next,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.shopping_bag, color: Colors.indigo),
                    SizedBox(width: 8),
                    Text(
                      'Add Product to Unit Comparison',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _dealNameController,
                  decoration: const InputDecoration(
                    labelText: 'Product / Brand Name',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _dealPriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Price (\$)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _dealQtyController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Quantity/Weight',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        value: _selectedUnit,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                        ),
                        items: ['g', 'kg', 'ml', 'L', 'pcs', 'units']
                            .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedUnit = val;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(