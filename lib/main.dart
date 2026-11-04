import 'package:flutter/material.dart';

void main() {
  runApp(const OverlayHUDApp());
}

class OverlayHUDApp extends StatelessWidget {
  const OverlayHUDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlayHUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
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
    HUDStudioTab(),
    ShoppingHUDTab(),
    ClipboardVaultTab(),
    CustomizerTab(),
    EngagementStatsTab(),
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
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.blueGrey, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF1E293B),
          selectedItemColor: Colors.tealAccent,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              label: 'HUD Studio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Shopping',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.content_copy),
              label: 'Vault',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tune),
              label: 'Widget Hub',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bolt),
              label: 'Activity',
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// TAB 1: HUD Studio (Interactive Drag Preview & Controls)
// -------------------------------------------------------------
class HUDStudioTab extends StatefulWidget {
  const HUDStudioTab({super.key});

  @override
  State<HUDStudioTab> createState() => _HUDStudioTabState();
}

class _HUDStudioTabState extends State<HUDStudioTab> {
  bool _overlayServiceEnabled = true;
  bool _floatingNotificationActive = true;
  String _activeWidgetMode = 'Shopping Helper';
  Offset _bubblePosition = const Offset(140, 160);
  bool _isBubbleExpanded = false;

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.indigo, Colors.teal],
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
                  child: Icon(Icons.layers, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'OverlayHUD Active',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Floating micro-widgets over all apps',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 12,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _overlayServiceEnabled,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() {
                      _overlayServiceEnabled = val;
                    });
                    _showToast(
                      val
                          ? 'Floating Overlay Service Activated'
                          : 'Overlay Service Paused',
                    );
                  },
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Quick Preset Selector Chips
          const Text(
            'Active Floating Utility Preset',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Shopping Helper',
              'Quick Clipboard',
              'Speed Calculator',
              'Address Vault'
            ].map((preset) {
              final isSelected = _activeWidgetMode == preset;
              return ChoiceChip(
                label: Text(preset),
                selected: isSelected,
                selectedColor: Colors.teal,
                backgroundColor: const Color(0xFF1E293B),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _activeWidgetMode = preset;
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Interactive Screen Preview Sandbox
          const Text(
            'Interactive Sandbox Preview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Drag the floating bubble around the phone mockup below to test floating interaction!',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          Container(
            height: 320,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.teal.withOpacity(0.4), width: 2),
            ),
            child: Stack(
              children: [
                // Simulated Background App UI
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 14,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const Icon(Icons.wifi,
                                color: Colors.white70, size: 16),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 70,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'Simulated Dynamic Background App',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                // Draggable Floating Bubble Simulation
                Positioned(
                  left: _bubblePosition.dx,
                  top: _bubblePosition.dy,
                  child: GestureDetect(
                    onDragUpdate: (details) {
                      setState(() {
                        double newX = _bubblePosition.dx + details.delta.dx;
                        double newY = _bubblePosition.dy + details.delta.dy;
                        newX = newX.clamp(10.0, 260.0);
                        newY = newY.clamp(10.0, 240.0);
                        _bubblePosition = Offset(newX, newY);
                      });
                    },
                    onTap: () {
                      setState(() {
                        _isBubbleExpanded = !_isBubbleExpanded;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: _isBubbleExpanded ? 200 : 64,
                      height: _isBubbleExpanded ? 130 : 64,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _overlayServiceEnabled
                            ? Colors.teal
                            : Colors.grey,
                        borderRadius:
                            BorderRadius.circular(_isBubbleExpanded ? 16 : 32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.5),
                            blurRadius: 12,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: _isBubbleExpanded
                          ? SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _activeWidgetMode,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Icon(Icons.close,
                                          size: 14, color: Colors.white),
                                    ],
                                  ),
                                  const Divider(color: Colors.white70),
                                  Text(
                                    _activeWidgetMode == 'Shopping Helper'
                                        ? 'Quick Discount: \$49.99 (-20% = \$39.99)'
                                        : _activeWidgetMode == 'Quick Clipboard'
                                            ? 'Pinned OTP: 849201'
                                            : 'Floating Math Tool Ready',
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.white),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _activeWidgetMode == 'Shopping Helper'
                                      ? Icons.shopping_bag
                                      : _activeWidgetMode == 'Quick Clipboard'
                                          ? Icons.copy
                                          : Icons.calculate,
                                  color: Colors.white,
                                  size: 26,
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Tap HUD',
                                  style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // System Permission Status Card
          Card(
            color: const Color(0xFF1E293B),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'System Permissions & Overlay Status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Display Over Other Apps Permission',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'GRANTED',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Floating Notification Banner',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                      Switch(
                        value: _floatingNotificationActive,
                        activeColor: Colors.tealAccent,
                        onChanged: (val) {
                          setState(() {
                            _floatingNotificationActive = val;
                          });
                        },
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
}

// Wrapper for gesture recognizer without conflict
class GestureDetect extends StatelessWidget {
  final Widget child;
  final Function(DragUpdateDetails) onDragUpdate;
  final VoidCallback onTap;

  const GestureDetect({
    super.key,
    required this.child,
    required this.onDragUpdate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onDragUpdate,
      onTap: onTap,
      child: child,
    );
  }
}

// -------------------------------------------------------------
// TAB 2: Shopping & Dynamic Discount Micro-HUD
// -------------------------------------------------------------
class ShoppingHUDTab extends StatefulWidget {
  const ShoppingHUDTab({super.key});

  @override
  State<ShoppingHUDTab> createState() => _ShoppingHUDTabState();
}

class _ShoppingHUDTabState extends State<ShoppingHUDTab> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();

  double _originalPrice = 0.0;
  double _discountPercent = 0.0;
  double _taxPercent = 0.0;
  double _finalPrice = 0.0;
  double _savedAmount = 0.0;

  final List<Map<String, String>> _shoppingCartHistory = [
    {'title': 'Wireless Headphones', 'price': '\$79.99', 'saved': '\$16.00'},
    {'title': 'Running Shoes', 'price': '\$119.50', 'saved': '\$23.90'},
  ];

  void _calculate() {
    setState(() {
      _originalPrice = double.tryParse(_priceController.text) ?? 0.0;
      _discountPercent = double.tryParse(_discountController.text) ?? 0.0;
      _taxPercent = double.tryParse(_taxController.text) ?? 0.0;

      double discountVal = _originalPrice * (_discountPercent / 100.0);
      double priceAfterDiscount = _originalPrice - discountVal;
      double taxVal = priceAfterDiscount * (_taxPercent / 100.0);

      _finalPrice = priceAfterDiscount + taxVal;
      _savedAmount = discountVal;
    });
  }

  void _saveToCart() {
    if (_originalPrice > 0) {
      setState(() {
        _shoppingCartHistory.insert(0, {
          'title': 'Item @ \$${_originalPrice.toStringAsFixed(2)}',
          'price': '\$${_finalPrice.toStringAsFixed(2)}',
          'saved': '\$${_savedAmount.toStringAsFixed(2)}',
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Calculated Item Saved to Floating Cart'),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.shopping_bag, color: Colors.tealAccent, size: 28),
              SizedBox(width: 10),
              Text(
                'Shopping & Discount HUD',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Calculate live discounts and taxes instantly while browsing store apps.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Calculator Input Form Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blueGrey.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculate(),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Original Price (\$)',
                    labelStyle: TextStyle(color: Colors.tealAccent),
                    prefixIcon:
                        Icon(Icons.monetization_on, color: Colors.tealAccent),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _discountController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _calculate(),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Discount %',
                          labelStyle: TextStyle(color: Colors.orangeAccent),
                          prefixIcon: Icon(Icons.percent,
                              color: Colors.orangeAccent),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _taxController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _calculate(),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Sales Tax %',
                          labelStyle: TextStyle(color: Colors.lightBlueAccent),
                          prefixIcon: Icon(Icons.account_balance_wallet,
                              color: Colors.lightBlueAccent),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Final Price',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          Text(
                            '\$${_finalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.tealAccent,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'You Save',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          Text(
                            '\$${_savedAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.add_shopping_cart,
                        color: Colors.white),
                    label: const Text(
                      'Pin to Quick Shopping List',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Floating Cart History Section
          const Text(
            'Pinned Shopping Items',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _shoppingCartHistory.length,
            itemBuilder: (context, index) {
              final item = _shoppingCartHistory[index];
              return Card(
                color: const Color(0xFF1E293B),
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile,
              );
            },
          ),
        ],
      ),
    );
  }
}

// Helper Widget extension to keep ListTile concise & clean
extension CustomListTile on ListTile {
  static Widget buildItem(
      Map<String, String> item, VoidCallback onDelete) {
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.teal,
              radius: 18,
              child: Icon(Icons.check, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Saved: ${item['saved']}',
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              item['price'] ?? '',
              style: const TextStyle(
                color: Colors.tealAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// TAB 3: Clipboard Vault & Micro-Notes Floating Pin
// -------------------------------------------------------------
class ClipboardVaultTab extends StatefulWidget {
  const ClipboardVaultTab({super.key});

  @override
  State<ClipboardVaultTab> createState() => _ClipboardVaultTabState();
}

class _ClipboardVaultTabState extends State<ClipboardVaultTab> {
  final TextEditingController _snippetController = TextEditingController();

  final List<Map<String, String>> _clipboardVault = [
    {
      'title': 'Delivery Address',
      'content': '742 Evergreen Terrace, Springfield, OR'
    },
    {'title': 'Banking Verification Code', 'content': 'OTP: 948201'},
    {'title': 'Support Email Template', 'content': 'hello@overlayhud.app'},
  ];

  void _addSnippet() {
    if (_snippetController.text.trim().isNotEmpty) {
      setState(() {
        _clipboardVault.insert(0, {
          'title': 'Pinned Snippet #${_clipboardVault.length + 1}',
          'content': _snippetController.text.trim(),
        });
        _snippetController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Snippet Pinned to Floating Vault'),
          backgroundColor: Colors.indigo,
        ),
      );
    }
  }

  void _copyToClipboard(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: "$content"'),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.content_paste, color: Colors.tealAccent, size: 28),
              SizedBox(width: 10),
              Text(
                'Clipboard Vault & Pins',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Keep verification codes, addresses, and quick snippets floating for 1-tap paste anywhere.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Snippet Quick Add Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _snippetController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText:
                        'Type or paste text/OTP to float over other apps...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.edit, color: Colors.tealAccent),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addSnippet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.pin_drop, color: Colors.white),
                    label: const Text(
                      'Pin Snippet to Floating HUD',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Saved Vault Items
          const Text(
            'Floating Quick-Copy Vault',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _clipboardVault.length,
            itemBuilder: (context, index) {
              final item = _clipboardVault[index];
              return Card(
                color: const Color(0xFF1E293B),
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.indigo,
                        child: Icon(Icons.note_alt,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['content'] ?? '',
                              style: const TextStyle(
                                color: Colors.tealAccent,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.content_copy,
                            color: Colors.amberAccent),
                        onPressed: () =>
                            _copyToClipboard(item['content'] ?? ''),
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
}

// -------------------------------------------------------------
// TAB 4: Widget Hub & Overlay Customizer
// -------------------------------------------------------------
class CustomizerTab extends StatefulWidget {
  const CustomizerTab({super.key});

  @override
  State<CustomizerTab> createState() => _CustomizerTabState();
}

class _CustomizerTabState extends State<CustomizerTab> {
  double _bubbleOpacity = 0.85;
  double _bubbleSize = 56.0;
  bool _hapticFeedback = true;
  bool _autoExpandOnCopy = true;
  Color _selectedThemeColor = Colors.teal;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.tune, color: Colors.tealAccent, size: 28),
              SizedBox(width: 10),
              Text(
                'HUD Customizer Studio',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Personalize transparency, size, and floating behavior.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Opacity Slider Card
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Overlay Transparency / Opacity',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${(_bubbleOpacity * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.tealAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _bubbleOpacity,
                    min: 0.3,
                    max: 1.0,
                    activeColor: Colors.teal,
                    inactiveColor: Colors.grey,
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

          // Size Slider Card
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Floating Bubble Size',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_bubbleSize.toInt()} px',
                        style: const TextStyle(
                          color: Colors.tealAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _bubbleSize,
                    min: 40.0,
                    max: 80.0,
                    activeColor: Colors.indigoAccent,
                    inactiveColor: Colors.grey,
                    onChanged: (val) {
                      setState(() {
                        _bubbleSize = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Bubble Color Theme Picker
          const Text(
            'Bubble Theme Accent',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Colors.teal,
              Colors.indigo,
              Colors.deepOrange,
              Colors.purple,
              Colors.blue
            ].map((color) {
              final isSelected = _selectedThemeColor == color;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedThemeColor = color;
                  });
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Feature Toggles
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text(
                    'Haptic Vibration Triggers',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Vibrate slightly when tapping floating overlay',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  value: _hapticFeedback,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() {
                      _hapticFeedback = val;
                    });
                  },
                ),
                const Divider(color: Colors.white70, height: 1),
                SwitchListTile(
                  title: const Text(
                    'Auto Expand on Text Copy',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Automatically open snippet vault when copying text',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  value: _autoExpandOnCopy,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() {
                      _autoExpandOnCopy = val;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// TAB 5: Engagement Activity & Micro-Stats
// -------------------------------------------------------------
class EngagementStatsTab extends StatelessWidget {
  const EngagementStatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.bolt, color: Colors.amberAccent, size: 28),
              SizedBox(width: 10),
              Text(
                'Activity & Productivity Stats',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'See how much time OverlayHUD saved you today.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Summary Stats Cards Grid
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.3,
            children: [
              _buildStatCard(
                title: 'HUD Active Time',
                value: '4h 12m',
                subtitle: '+18% today',
                icon: Icons.schedule,
                color: Colors.teal,
              ),
              _buildStatCard(
                title: 'App Switches Saved',
                value: '64 Times',
                subtitle: 'No back & forth',
                icon: Icons.swap_horiz,
                color: Colors.indigo,
              ),
              _buildStatCard(
                title: 'Shopping Discounts',
                value: '\$42.80',
                subtitle: 'Saved this week',
                icon: Icons.monetization_on,
                color: Colors.green,
              ),
              _buildStatCard(
                title: 'Snippets Pinned',
                value: '29 Codes',
                subtitle: 'Quick accessed',
                icon: Icons.pin,
                color: Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Daily Productivity Score Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amberAccent.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.amber,
                  radius: 24,
                  child: Icon(Icons.star, color: Colors.black, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Efficiency Score: 94%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Top 5% OverlayHUD power user today!',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(color: color, fontSize: 10),
          ),
        ],
      ),
    );
  }
}