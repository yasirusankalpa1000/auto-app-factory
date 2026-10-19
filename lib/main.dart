import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const FloatDeckApp());
}

class FloatDeckApp extends StatelessWidget {
  const FloatDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatDeck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FE),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class StashItem {
  final String id;
  final String title;
  final String content;
  final String category;
  final IconData icon;

  StashItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.icon,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  bool _overlayEnabled = true;
  bool _notificationPermission = true;

  // Initial Stash Items
  final List<StashItem> _stashList = [
    StashItem(
      id: '1',
      title: 'Bank Account Swift Code',
      content: '7010-4829-1920-5831 (Commercial Vault)',
      category: 'Banking',
      icon: Icons.monetization_on,
    ),
    StashItem(
      id: '2',
      title: 'Home Delivery Address',
      content: '42 Lotus Ridge Ave, Suite 3B, Downtown Metro',
      category: 'Addresses',
      icon: Icons.home,
    ),
    StashItem(
      id: '3',
      title: 'WiFi Guest Password',
      content: 'GuestVault#2025!',
      category: 'Passwords',
      icon: Icons.security,
    ),
    StashItem(
      id: '4',
      title: 'Canned WhatsApp Reply',
      content: 'Thanks for reaching out! I am currently away, will reply shortly.',
      category: 'Messages',
      icon: Icons.share,
    ),
  ];

  // Floating Heads Screen Coordinates
  double _headX = 30.0;
  double _headY = 180.0;
  String _activeModal = ''; // '' | 'clip' | 'calc' | 'bargain'

  // Calculator State
  final TextEditingController _priceController = TextEditingController(text: "85.00");
  final TextEditingController _discountController = TextEditingController(text: "15");
  final TextEditingController _peopleController = TextEditingController(text: "2");
  double _calcFinal = 72.25;
  double _calcPerPerson = 36.12;

  // Bargain Compare State
  final TextEditingController _itemAPrice = TextEditingController(text: "12.50");
  final TextEditingController _itemAQty = TextEditingController(text: "500");
  final TextEditingController _itemBPrice = TextEditingController(text: "22.00");
  final TextEditingController _itemBQty = TextEditingController(text: "1000");
  String _bargainResult = "Item B is 12% cheaper per unit!";

  void _recalculateDiscount() {
    double price = double.tryParse(_priceController.text) ?? 0.0;
    double discount = double.tryParse(_discountController.text) ?? 0.0;
    int people = int.tryParse(_peopleController.text) ?? 1;
    if (people < 1) people = 1;

    double discounted = price - (price * (discount / 100.0));
    if (discounted < 0) discounted = 0;

    setState(() {
      _calcFinal = discounted;
      _calcPerPerson = discounted / people;
    });
  }

  void _calculateBargain() {
    double pA = double.tryParse(_itemAPrice.text) ?? 0;
    double qA = double.tryParse(_itemAQty.text) ?? 1;
    double pB = double.tryParse(_itemBPrice.text) ?? 0;
    double qB = double.tryParse(_itemBQty.text) ?? 1;

    if (qA <= 0 || qB <= 0 || pA <= 0 || pB <= 0) {
      setState(() {
        _bargainResult = "Please enter valid non-zero values.";
      });
      return;
    }

    double unitA = pA / qA;
    double unitB = pB / qB;

    if (unitA < unitB) {
      double diff = ((unitB - unitA) / unitB) * 100;
      setState(() {
        _bargainResult = "Option A is ${diff.toStringAsFixed(1)}% better deal!";
      });
    } else if (unitB < unitA) {
      double diff = ((unitA - unitB) / unitA) * 100;
      setState(() {
        _bargainResult = "Option B is ${diff.toStringAsFixed(1)}% better deal!";
      });
    } else {
      setState(() {
        _bargainResult = "Both options have equal cost per unit!";
      });
    }
  }

  void _copyToClipboard(String text, String title) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Copied "$title" to clipboard!',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAddStashDialog() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    String category = 'General';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Floating Stash Item',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Title / Reference Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Text Content / Number / Snippet',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () {
                  if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                    setState(() {
                      _stashList.insert(
                        0,
                        StashItem(
                          id: DateTime.now().toString(),
                          title: titleCtrl.text,
                          content: contentCtrl.text,
                          category: category,
                          icon: Icons.bolt,
                        ),
                      );
                    });
                    Navigator.pop(ctx);
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Save to Quick Stash'),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.layers, color: Colors.indigo),
            SizedBox(width: 8),
            Text(
              'FloatDeck',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: FilterChip(
              avatar: Icon(
                _overlayEnabled ? Icons.bolt : Icons.power_settings_new,
                color: _overlayEnabled ? Colors.indigo : Colors.grey,
              ),
              label: Text(_overlayEnabled ? 'Overlay Active' : 'Overlay Off'),
              selected: _overlayEnabled,
              onSelected: (val) {
                setState(() {
                  _overlayEnabled = val;
                });
              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildInteractiveCanvasTab(),
            _buildQuickVaultTab(),
            _buildBargainCompareTab(),
            _buildSettingsTab(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Floating Deck',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy),
            label: 'Quick Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Deal Compare',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Overlay Setup',
          ),
        ],
      ),
    );
  }

  // TAB 1: Live Floating Canvas (Interactive Bubble Simulation)
  Widget _buildInteractiveCanvasTab() {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.indigo, Colors.blueAccent],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.stars, color: Colors.amber),
                        SizedBox(width: 8),
                        Text(
                          'Simulated Floating Overlay Deck',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Drag the floating bubble around your screen! Tap icons to launch micro-tools while browsing other apps.',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Quick Launch Floating Heads',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Cards grid for triggers
              Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAxisAlignment.start,
                children: [
                  _buildDeckTriggerCard(
                    title: 'Smart Stash Vault',
                    subtitle: '4 Saved Snippets',
                    icon: Icons.content_copy,
                    color: Colors.indigo,
                    onTap: () => setState(() => _activeModal = 'clip'),
                  ),
                  _buildDeckTriggerCard(
                    title: 'Instant Discount Calc',
                    subtitle: 'Quick floating Math',
                    icon: Icons.monetization_on,
                    color: Colors.teal,
                    onTap: () => setState(() => _activeModal = 'calc'),
                  ),
                  _buildDeckTriggerCard(
                    title: 'Price Deal Finder',
                    subtitle: 'Compare per unit',
                    icon: Icons.compare_arrows,
                    color: Colors.orange,
                    onTap: () => setState(() => _activeModal = 'bargain'),
                  ),
                  _buildDeckTriggerCard(
                    title: 'Quick Scratchpad',
                    subtitle: 'Temporary Note',
                    icon: Icons.note_alt,
                    color: Colors.purple,
                    onTap: () {
                      _copyToClipboard("Delivery Code #8841", "Scratchpad");
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigo.withOpacity(0.2)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Why Keep FloatDeck Active?',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '• Copy account numbers directly while in banking apps.\n'
                      '• Calculate 20% discounts off shopping carts live.\n'
                      '• Compare product sizes without leaving Chrome or Instagram.',
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100), // Spacing for floating bubble
            ],
          ),
        ),

        // Simulated Draggable Floating Head Bubble
        if (_overlayEnabled)
          Positioned(
            left: _headX,
            top: _headY,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _headX += details.delta.dx;
                  _headY += details.delta.dy;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (_activeModal.isEmpty) {
                          _activeModal = 'clip';
                        } else {
                          _activeModal = '';
                        }
                      });
                    },
                    child: const Icon(
                      Icons.layers,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),

        // Floating Micro Overlay Window Simulation
        if (_overlayEnabled && _activeModal.isNotEmpty)
          Positioned(
            left: 20,
            right: 20,
            top: 100,
            child: Material(
              elevation: 12,
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.indigo.withOpacity(0.3)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.bolt, color: Colors.amber),
                            const SizedBox(width: 6),
                            Text(
                              _activeModal == 'clip'
                                  ? 'Floating Quick Stash'
                                  : (_activeModal == 'calc'
                                      ? 'Floating Discount Calc'
                                      : 'Floating Deal Compare'),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () => setState(() => _activeModal = ''),
                        )
                      ],
                    ),
                    const Divider(),

                    if (_activeModal == 'clip') ...[
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          itemCount: _stashList.length,
                          itemBuilder: (context, idx) {
                            final item = _stashList[idx];
                            return ListTile(
                              dense: true,
                              leading: Icon(item.icon, color: Colors.indigo, size: 20),
                              title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Text(
                                item.content,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.content_copy, size: 18, color: Colors.teal),
                                onPressed: () => _copyToClipboard(item.content, item.title),
                              ),
                            );
                          },
                        ),
                      )
                    ] else if (_activeModal == 'calc') ...[
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Price (\$)',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              onChanged: (_) => _recalculateDiscount(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _discountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Disc %',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              onChanged: (_) => _recalculateDiscount(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.indigo.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pay: \$${_calcFinal.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                            ),
                            Text(
                              'Split: \$${_calcPerPerson.toStringAsFixed(2)}/ea',
                              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.teal),
                            ),
                          ],
                        ),
                      )
                    ] else ...[
                      const Text(
                        'Compare Price per Unit instantly:',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _itemAPrice,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'A Price (\$)',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              onChanged: (_) => _calculateBargain(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _itemAQty,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'A Qty (g/ml)',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              onChanged: (_) => _calculateBargain(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _bargainResult,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }

  Widget _buildDeckTriggerCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    double width = (MediaQuery.of(context).size.width - 42) / 2;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: width > 140 ? width : 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.12),
              radius: 18,
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: Quick Vault & Stash Manager
  Widget _buildQuickVaultTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
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
                    'Quick Vault Stash',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Tap any item to instantly copy to clipboard',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                onPressed: _showAddStashDialog,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
              )
            ],
          ),
          const SizedBox(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _stashList.length,
            itemBuilder: (context, index) {
              final item = _stashList[index];
              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.withOpacity(0.1),
                    child: Icon(item.icon, color: Colors.indigo),
                  ),
                  title: Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    item.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.content_copy, color: Colors.teal),
                        onPressed: () => _copyToClipboard(item.content, item.title),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _stashList.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  // TAB 3: Bargain & Price Compare Tool
  Widget _buildBargainCompareTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bargain & Unit Value Calculator',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Never get tricked by grocery or e-commerce package sizes.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Option A Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.indigo.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.shopping_bag, color: Colors.indigo),
                    SizedBox(width: 8),
                    Text(
                      'Option A (First Package)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _itemAPrice,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Price (\$)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => _calculateBargain(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _itemAQty,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Qty (grams/ml/pcs)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => _calculateBargain(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Option B Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.shopping_cart, color: Colors.orange),
                    SizedBox(width: 8),
                    Text(
                      'Option B (Second Package)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _itemBPrice,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Price (\$)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => _calculateBargain(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _itemBQty,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Qty (grams/ml/pcs)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => _calculateBargain(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Result Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal),
            ),
            child: Column(
              children: [
                const Icon(Icons.check_circle, color: Colors.teal, size: 28),
                const SizedBox(height: 6),
                Text(
                  _bargainResult,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 4: Overlay & Notification Permission Settings
  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overlay Permissions & Configs',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Ensure FloatDeck stays ready over banking, shopping, and social apps.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.layers, color: Colors.indigo),
              title: const Text('Display Above Other Apps'),
              subtitle: const Text('Draw floating bubble deck over Android/iOS windows'),
              value: _overlayEnabled,
              onChanged: (val) {
                setState(() {
                  _overlayEnabled = val;
                });
              },
            ),
          ),

          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications_active, color: Colors.amber),
              title: const Text('Floating Heads Quick Alert'),
              subtitle: const Text('Keep active persistent badge in notification tray'),
              value: _notificationPermission,
              onChanged: (val) {
                setState(() {
                  _notificationPermission = val;
                });
              },
            ),
          ),

          const SizedBox(height: 16),
          const Text(
            'How FloatDeck Solves Daily Tasks',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          _buildGuideItem(
            icon: Icons.monetization_on,
            title: 'Online Shopping Math',
            desc: 'Calculate flash sales, 15% promo codes, and shipping splits without context switching.',
          ),
          _buildGuideItem(
            icon: Icons.content_copy,
            title: 'Instant Bank & Form Autofill',
            desc: 'Store IBANs, passport numbers, and long delivery addresses in your floating clip deck.',
          ),
          _buildGuideItem(
            icon: Icons.share,
            title: 'Quick Canned Replies',
            desc: 'Send fast responses to buyers or friends while gaming or watching videos.',
          ),
        ],
      ),
    );
  }

  Widget _buildGuideItem({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.indigo.withOpacity(0.1),
            child: Icon(icon, size: 18, color: Colors.indigo),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  softWrap: true,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}