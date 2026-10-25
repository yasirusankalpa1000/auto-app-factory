import 'package:flutter/material.dart';

void main() {
  runApp(const FloatPocketApp());
}

class FloatPocketApp extends StatelessWidget {
  const FloatPocketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatPocket HUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFAFAFAF),
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

  // Stashed snippets data
  final List<Map<String, String>> _snippets = [
    {
      'id': '1',
      'title': 'Home Delivery Address',
      'content': '42/B Lotus Grove, Lake Road, Colombo 03',
      'category': 'Address',
      'pinned': 'true',
    },
    {
      'id': '2',
      'title': 'Primary Bank IBAN / Account',
      'content': '7890-1234-5678-9012 (Commercial Bank)',
      'category': 'Financial',
      'pinned': 'true',
    },
    {
      'id': '3',
      'title': 'Office Wi-Fi Key',
      'content': 'TechHub_Guest_2025#Pass',
      'category': 'Keys',
      'pinned': 'false',
    },
    {
      'id': '4',
      'title': 'Quick Reply - On My Way',
      'content': 'Hey! I am on my way, reaching in about 15 minutes.',
      'category': 'Quick Reply',
      'pinned': 'false',
    },
  ];

  void _addSnippet(String title, String content, String category) {
    setState(() {
      _snippets.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': title,
        'content': content,
        'category': category,
        'pinned': 'false',
      });
    });
  }

  void _deleteSnippet(String id) {
    setState(() {
      _snippets.removeWhere((item) => item['id'] == id);
    });
  }

  void _togglePinSnippet(String id) {
    setState(() {
      final index = _snippets.indexWhere((item) => item['id'] == id);
      if (index != -1) {
        final isPinned = _snippets[index]['pinned'] == 'true';
        _snippets[index]['pinned'] = isPinned ? 'false' : 'true';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      FloatingHudSimulatorView(
        snippets: _snippets,
      ),
      ClipboardStashView(
        snippets: _snippets,
        onAddSnippet: _addSnippet,
        onDeleteSnippet: _deleteSnippet,
        onTogglePin: _togglePinSnippet,
      ),
      const PriceComparatorView(),
      const ImpulseDecisionView(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        title: Row(
          children: const [
            Icon(Icons.layers, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'FloatPocket HUD',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('FloatPocket Floating Service Active!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Floating HUD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: 'Clip Stash',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Deal Comparator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Buy Audit',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 1: FLOATING OVERLAY SIMULATOR
// -----------------------------------------------------------------------------
class FloatingHudSimulatorView extends StatefulWidget {
  final List<Map<String, String>> snippets;

  const FloatingHudSimulatorView({super.key, required this.snippets});

  @override
  State<FloatingHudSimulatorView> createState() => _FloatingHudSimulatorViewState();
}

class _FloatingHudSimulatorViewState extends State<FloatingHudSimulatorView> {
  bool _overlayEnabled = true;
  Offset _bubblePosition = const Offset(280, 220);
  String? _activeCardType; // 'stash', 'calc', 'decision'

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Controls
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.indigo[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.indigo[200]!),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Display Above Other Apps',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.indigo,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Simulates real floating dynamic head over phone screen.',
                                  style: TextStyle(fontSize: 12, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _overlayEnabled,
                            activeColor: Colors.indigo,
                            onChanged: (val) {
                              setState(() {
                                _overlayEnabled = val;
                                if (!val) _activeCardType = null;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _activeCardType = 'stash';
                              });
                            },
                            icon: const Icon(Icons.copy, size: 16),
                            label: const Text('Open Clips HUD'),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _activeCardType = 'calc';
                              });
                            },
                            icon: const Icon(Icons.calculate, size: 16),
                            label: const Text('Quick Math HUD'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Simulated App / Phone Canvas
                const Text(
                  'Live Mobile Screen Simulation',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 380,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[300]!, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Background Mock Phone UI
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.search, color: Colors.grey, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Shopping App / Form Screen...',
                                    style: TextStyle(color: Colors.grey, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.amber[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.amber[200]!),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Checkout - Delivery Information',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Tap the floating bubble to paste your address or compare prices instantly without closing this page!',
                                    style: TextStyle(fontSize: 12, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text('Promo Code Field', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  height: 40,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.indigo,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Overlay Modal HUD Card (if active)
                      if (_overlayEnabled && _activeCardType != null)
                        Positioned(
                          left: 16,
                          right: 16,
                          top: 50,
                          child: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.indigo[900],
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            _activeCardType == 'stash' ? Icons.copy : Icons.calculate,
                                            color: Colors.amber,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            _activeCardType == 'stash' ? 'Instant Clip Stash' : 'Quick Math HUD',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () => setState(() => _activeCardType = null),
                                        child: const Icon(Icons.close, color: Colors.white70, size: 20),
                                      ),
                                    ],
                                  ),
                                  const Divider(color: Colors.white70, height: 16),
                                  if (_activeCardType == 'stash') ...[
                                    SizedBox(
                                      height: 120,
                                      child: ListView.builder(
                                        itemCount: widget.snippets.length,
                                        itemBuilder: (ctx, i) {
                                          final snip = widget.snippets[i];
                                          return Container(
                                            margin: const EdgeInsets.only(bottom: 6),
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    snip['content'] ?? '',
                                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text('Copied: ${snip['content']}'),
                                                        duration: const Duration(seconds: 1),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.amber,
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: const Text(
                                                      'Copy',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ] else ...[
                                    const Text(
                                      'Quick Discount Calculator:',
                                      style: TextStyle(color: Colors.white70, fontSize: 12),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: const [
                                        Expanded(
                                          child: Text(
                                            'Price: \$150.00 - 25% Off',
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          'Final: \$112.50',
                                          style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),

                      // Floating Interactive Drag Bubble
                      if (_overlayEnabled)
                        Positioned(
                          left: _bubblePosition.dx,
                          top: _bubblePosition.dy,
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                double newX = _bubblePosition.dx + details.delta.dx;
                                double newY = _bubblePosition.dy + details.delta.dy;
                                // Constrain within simulated screen box
                                newX = newX.clamp(10.0, 270.0);
                                newY = newY.clamp(10.0, 310.0);
                                _bubblePosition = Offset(newX, newY);
                              });
                            },
                            onTap: () {
                              setState(() {
                                _activeCardType = _activeCardType == null ? 'stash' : null;
                              });
                            },
                            child: Material(
                              elevation: 10,
                              shape: const CircleBorder(),
                              color: Colors.indigo,
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [Colors.indigo, Colors.blueAccent],
                                  ),
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.layers,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    '💡 Drag floating indigo bubble anywhere over simulated phone screen!',
                    style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
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

// -----------------------------------------------------------------------------
// TAB 2: MULTI-SLOT CLIPBOARD & SNIPPET STASH
// -----------------------------------------------------------------------------
class ClipboardStashView extends StatefulWidget {
  final List<Map<String, String>> snippets;
  final Function(String, String, String) onAddSnippet;
  final Function(String) onDeleteSnippet;
  final Function(String) onTogglePin;

  const ClipboardStashView({
    super.key,
    required this.snippets,
    required this.onAddSnippet,
    required this.onDeleteSnippet,
    required this.onTogglePin,
  });

  @override
  State<ClipboardStashView> createState() => _ClipboardStashViewState();
}

class _ClipboardStashViewState extends State<ClipboardStashView> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedCategory = 'Address';
  String _filterCategory = 'All';

  final List<String> _categories = ['Address', 'Financial', 'Keys', 'Quick Reply', 'General'];

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
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            top: 20,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Stash New Snippet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Label / Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _contentController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Text Content / Value',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
                decoration: const InputDecoration(
                  labelText: 'Category Tag',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
                      widget.onAddSnippet(
                        _titleController.text,
                        _contentController.text,
                        _selectedCategory,
                      );
                      _titleController.clear();
                      _contentController.clear();
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Save to Float Stash', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
    final filteredList = _filterCategory == 'All'
        ? widget.snippets
        : widget.snippets.where((s) => s['category'] == _filterCategory).toList();

    return SafeArea(
      child: Column(
        children: [
          // Filter Row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', ..._categories].map((cat) {
                  final isSelected = _filterCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: Colors.indigo,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) setState(() => _filterCategory = cat);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          Expanded(
            child: filteredList.isEmpty
                ? const Center(
                    child: Text('No snippets stored in this category.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      final isPinned = item['pinned'] == 'true';
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo[50],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      item['category'] ?? 'General',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigo,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          isPinned ? Icons.star : Icons.star_border,
                                          color: isPinned ? Colors.amber : Colors.grey,
                                        ),
                                        onPressed: () => widget.onTogglePin(item['id']!),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                        onPressed: () => widget.onDeleteSnippet(item['id']!),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['title'] ?? '',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item['content'] ?? '',
                                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Copied "${item['title']}" to clipboard!'),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.copy, size: 16),
                                  label: const Text('Fast Copy'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: FloatingActionButton.extended(
                backgroundColor: Colors.indigo,
                onPressed: _showAddDialog,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Add Quick Clip Stash', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 3: SMART PRICE & UNIT VALUE COMPARATOR
// -----------------------------------------------------------------------------
class PriceComparatorView extends StatefulWidget {
  const PriceComparatorView({super.key});

  @override
  State<PriceComparatorView> createState() => _PriceComparatorViewState();
}

class _PriceComparatorViewState extends State<PriceComparatorView> {
  final _priceAController = TextEditingController(text: '12.50');
  final _qtyAController = TextEditingController(text: '400');
  final _priceBController = TextEditingController(text: '18.00');
  final _qtyBController = TextEditingController(text: '650');

  String _unitName = 'grams';

  @override
  Widget build(BuildContext context) {
    double pA = double.tryParse(_priceAController.text) ?? 0.0;
    double qA = double.tryParse(_qtyAController.text) ?? 1.0;
    double pB = double.tryParse(_priceBController.text) ?? 0.0;
    double qB = double.tryParse(_qtyBController.text) ?? 1.0;

    if (qA <= 0) qA = 1.0;
    if (qB <= 0) qB = 1.0;

    double unitCostA = pA / qA;
    double unitCostB = pB / qB;

    bool isABetter = unitCostA < unitCostB;
    bool isEqual = (unitCostA - unitCostB).abs() < 0.0001;

    double diffPercent = 0.0;
    if (unitCostA > 0 && unitCostB > 0) {
      if (isABetter) {
        diffPercent = ((unitCostB - unitCostA) / unitCostB) * 100;
      } else {
        diffPercent = ((unitCostA - unitCostB) / unitCostA) * 100;
      }
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Smart Unit Deal Comparator',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 4),
            const Text(
              'Instantly calculate which package gives you maximum value per unit.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Unit Selector
            Row(
              children: [
                const Text('Unit Measure: ', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _unitName,
                  items: const [
                    DropdownMenuItem(value: 'grams', child: Text('grams (g)')),
                    DropdownMenuItem(value: 'ml', child: Text('milliliters (ml)')),
                    DropdownMenuItem(value: 'pcs', child: Text('pieces / count')),
                    DropdownMenuItem(value: 'kg', child: Text('kilograms (kg)')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _unitName = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Option A & Option B Inputs
            Row(
              children: [
                // Option A Card
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (!isEqual && isABetter) ? Colors.green[50] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: (!isEqual && isABetter) ? Colors.green : Colors.grey[300]!,
                        width: (!isEqual && isABetter) ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Option A', style: TextStyle(fontWeight: FontWeight.bold)),
                            if (!isEqual && isABetter)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('BEST VALUE', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _priceAController,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            labelText: 'Price (\$) =',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _qtyAController,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            labelText: 'Qty ($_unitName)',
                            isDense: true,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Per Unit: \$${unitCostA.toStringAsFixed(4)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: (!isEqual && isABetter) ? Colors.green[800] : Colors.black87,
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
                      color: (!isEqual && !isABetter) ? Colors.green[50] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: (!isEqual && !isABetter) ? Colors.green : Colors.grey[300]!,
                        width: (!isEqual && !isABetter) ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Option B', style: TextStyle(fontWeight: FontWeight.bold)),
                            if (!isEqual && !isABetter)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('BEST VALUE', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _priceBController,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            labelText: 'Price (\$) =',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _qtyBController,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            labelText: 'Qty ($_unitName)',
                            isDense: true,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Per Unit: \$${unitCostB.toStringAsFixed(4)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: (!isEqual && !isABetter) ? Colors.green[800] : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Summary Verdict Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'COMPARISON VERDICT',
                    style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isEqual
                        ? 'Both options offer identical value per unit!'
                        : '${isABetter ? "Option A" : "Option B"} is cheaper by ${diffPercent.toStringAsFixed(1)}% per $_unitName!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 4: IMPULSE BUY DECISION AUDIT
// -----------------------------------------------------------------------------
class ImpulseDecisionView extends StatefulWidget {
  const ImpulseDecisionView({super.key});

  @override
  State<ImpulseDecisionView> createState() => _ImpulseDecisionViewState();
}

class _ImpulseDecisionViewState extends State<ImpulseDecisionView> {
  final _itemController = TextEditingController(text: 'Smart Headphones');
  final _costController = TextEditingController(text: '89.00');

  double _necessityScore = 2.0; // 1 to 5
  bool _useNextMonth = true;
  bool _canAffordDouble = true;
  bool _isLuxuryImpulse = true;

  @override
  Widget build(BuildContext context) {
    // Calculate Buy Recommendation Index
    int score = 0;
    if (_necessityScore >= 4) score += 40;
    else if (_necessityScore >= 3) score += 20;

    if (_useNextMonth) score += 25;
    if (_canAffordDouble) score += 25;
    if (!_isLuxuryImpulse) score += 10;

    String recommendation;
    Color recColor;

    if (score >= 75) {
      recommendation = 'GREEN LIGHT: Safe Purchase!';
      recColor = Colors.green;
    } else if (score >= 45) {
      recommendation = 'AMBER LIGHT: Wait 48 Hours Before Buying!';
      recColor = Colors.orange;
    } else {
      recommendation = 'RED LIGHT: Skip / Impulse Trap!';
      recColor = Colors.red;
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Impulse Buy Decision Audit',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 4),
            const Text(
              'Run a quick 30-second psychological check before making unexpected purchases.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Item Name & Cost Inputs
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(
                      labelText: 'Item Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _costController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cost (\$) =',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Question 1: Necessity Slider
            Card(
              elevation: 0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1. Necessity Level (1 = Impulse Want, 5 = Absolute Need): ${_necessityScore.round()}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Slider(
                      value: _necessityScore,
                      min: 1.0,
                      max: 5.0,
                      divisions: 4,
                      activeColor: Colors.indigo,
                      onChanged: (val) => setState(() => _necessityScore = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Question 2: Will you use it next month?
            SwitchListTile(
              title: const Text('2. Will you realistically use this weekly next month?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              value: _useNextMonth,
              activeColor: Colors.indigo,
              onChanged: (val) => setState(() => _useNextMonth = val),
            ),

            // Question 3: Can afford double?
            SwitchListTile(
              title: const Text('3. Could you afford to buy 2 of these right now without stress?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              value: _canAffordDouble,
              activeColor: Colors.indigo,
              onChanged: (val) => setState(() => _canAffordDouble = val),
            ),

            // Question 4: Is luxury impulse?
            SwitchListTile(
              title: const Text('4. Is this purchase prompted by a limited-time sales deal?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              value: _isLuxuryImpulse,
              activeColor: Colors.indigo,
              onChanged: (val) => setState(() => _isLuxuryImpulse = val),
            ),

            const SizedBox(height: 16),

            // Recommendation Display Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: recColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: recColor, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    'AUDIT SCORE: $score / 100',
                    style: TextStyle(fontWeight: FontWeight.bold, color: recColor, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    recommendation,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: recColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
}