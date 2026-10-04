import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const OmniHUDApp());
}

class OmniHUDApp extends StatelessWidget {
  const OmniHUDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniHUD Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
          primary: Colors.indigoAccent,
          secondary: Colors.amber,
          surface: const Color(0xFF1E1E2C),
        ),
        scaffoldBackgroundColor: const Color(0xFF12121D),
      ),
      home: const MainHUDOverlayScreen(),
    );
  }
}

class MainHUDOverlayScreen extends StatefulWidget {
  const MainHUDOverlayScreen({super.key});

  @override
  State<MainHUDOverlayScreen> createState() => _MainHUDOverlayScreenState();
}

class _MainHUDOverlayScreenState extends State<MainHUDOverlayScreen> {
  int _selectedTab = 0;
  
  // Floating HUD Bubble Position
  Offset _bubbleOffset = const Offset(20, 150);
  bool _isHUDExpanded = false;
  bool _isFloatingEnabled = true;

  // Savings Tracker State
  double _totalSavedToday = 14.50;
  int _smartDecisionsCount = 8;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main App Content Views
            IndexedStack(
              index: _selectedTab,
              children: [
                DealRadarTab(onDealSaved: _registerSavedDeal),
                BillSplitterTab(),
                TextVaultTab(),
                HUDControlTab(
                  isFloatingEnabled: _isFloatingEnabled,
                  onToggleFloating: (val) {
                    setState(() {
                      _isFloatingEnabled = val;
                    });
                  },
                  totalSaved: _totalSavedToday,
                  decisionsCount: _smartDecisionsCount,
                ),
              ],
            ),

            // Draggable Floating HUD Bubble (Simulated Overlay Permission Feature)
            if (_isFloatingEnabled)
              Positioned(
                left: _bubbleOffset.dx,
                top: _bubbleOffset.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      double newX = _bubbleOffset.dx + details.delta.dx;
                      double newY = _bubbleOffset.dy + details.delta.dy;
                      
                      // Keep within screen bounds
                      newX = newX.clamp(10.0, mediaQuery.size.width - 70.0);
                      newY = newY.clamp(10.0, mediaQuery.size.height - 120.0);
                      
                      _bubbleOffset = Offset(newX, newY);
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Bubble Trigger Button
                      FloatingActionButton.small(
                        heroTag: 'hud_bubble',
                        backgroundColor: _isHUDExpanded ? Colors.amber : Colors.indigoAccent,
                        onPressed: () {
                          setState(() {
                            _isHUDExpanded = !_isHUDExpanded;
                          });
                        },
                        child: Icon(
                          _isHUDExpanded ? Icons.close : Icons.widgets,
                          color: Colors.black,
                        ),
                      ),
                      
                      // Expanded Mini Quick Menu
                      if (_isHUDExpanded)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(12),
                          width: 220,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A3D),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.indigoAccent.withOpacity(0.5)),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black87,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.bolt, color: Colors.amber, size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    'OmniHUD Dock',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(color: Colors.grey, height: 12),
                              _buildMiniHUDAction('Quick Paste Code', Icons.content_copy, () {
                                Clipboard.setData(const ClipboardData(text: 'ACC-9982-3341-PAY'));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Bank Acc copied via Floating Dock!')),
                                );
                              }),
                              _buildMiniHUDAction('Instant Split \$50', Icons.calculate, () {
                                _showQuickSplitDialog(context);
                              }),
                              _buildMiniHUDAction('Copy Daily Note', Icons.edit_note, () {
                                Clipboard.setData(const ClipboardData(text: 'Buy milk 1L, split lunch bill, pay electric bill'));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Daily note copied to clipboard!')),
                                );
                              }),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E1E2C),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Deal Radar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Bill Splitter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.copy_all),
            label: 'Text Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'HUD Controls',
          ),
        ],
      ),
    );
  }

  void _registerSavedDeal(double amount) {
    setState(() {
      _totalSavedToday += amount;
      _smartDecisionsCount += 1;
    });
  }

  Widget _buildMiniHUDAction(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.amber),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickSplitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A3D),
        title: const Text('Quick Split \$50 with Tip', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Subtotal: \$50.00', style: TextStyle(color: Colors.white70)),
            Text('10% Service Charge + 15% Tip', style: TextStyle(color: Colors.amber)),
            SizedBox(height: 10),
            Text('2 People: \$31.25 / person', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
            Text('3 People: \$20.83 / person', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
            Text('4 People: \$15.62 / person', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: Colors.amber)),
          )
        ],
      ),
    );
  }
}

// TAB 1: DEAL & SHRINKFLATION RADAR
class DealRadarTab extends StatefulWidget {
  final Function(double) onDealSaved;
  const DealRadarTab({super.key, required this.onDealSaved});

  @override
  State<DealRadarTab> createState() => _DealRadarTabState();
}

class _DealRadarTabState extends State<DealRadarTab> {
  final _priceAController = TextEditingController(text: '4.50');
  final _qtyAController = TextEditingController(text: '250');
  final _discountAController = TextEditingController(text: '10');

  final _priceBController = TextEditingController(text: '6.20');
  final _qtyBController = TextEditingController(text: '380');
  final _discountBController = TextEditingController(text: '0');

  String _resultText = '';
  double _savingsAmount = 0.0;
  int _bestOption = 0; // 1 for A, 2 for B

  @override
  void initState() {
    super.initState();
    _calculateValue();
  }

  void _calculateValue() {
    final pA = double.tryParse(_priceAController.text) ?? 0.0;
    final qA = double.tryParse(_qtyAController.text) ?? 1.0;
    final dA = double.tryParse(_discountAController.text) ?? 0.0;

    final pB = double.tryParse(_priceBController.text) ?? 0.0;
    final qB = double.tryParse(_qtyBController.text) ?? 1.0;
    final dB = double.tryParse(_discountBController.text) ?? 0.0;

    if (qA <= 0 || qB <= 0) return;

    final finalPA = pA * (1 - (dA / 100));
    final finalPB = pB * (1 - (dB / 100));

    final unitCostA = (finalPA / qA) * 100; // cost per 100g/ml
    final unitCostB = (finalPB / qB) * 100;

    setState(() {
      if (unitCostA < unitCostB) {
        _bestOption = 1;
        double diffPercent = ((unitCostB - unitCostA) / unitCostB) * 100;
        _savingsAmount = (unitCostB - unitCostA) * (qA / 100);
        _resultText = 'Option A is ${diffPercent.toStringAsFixed(1)}% CHEAPER!\nCost per 100g: \$${unitCostA.toStringAsFixed(2)} vs \$${unitCostB.toStringAsFixed(2)}';
      } else if (unitCostB < unitCostA) {
        _bestOption = 2;
        double diffPercent = ((unitCostA - unitCostB) / unitCostA) * 100;
        _savingsAmount = (unitCostA - unitCostB) * (qB / 100);
        _resultText = 'Option B is ${diffPercent.toStringAsFixed(1)}% CHEAPER!\nCost per 100g: \$${unitCostB.toStringAsFixed(2)} vs \$${unitCostA.toStringAsFixed(2)}';
      } else {
        _bestOption = 0;
        _savingsAmount = 0.0;
        _resultText = 'Both options offer EXACTLY identical value per unit!';
      }
    });
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
              Icon(Icons.radar, color: Colors.amber, size: 28),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Deal & Shrinkflation Radar',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  softWrap: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Bypass marketing tricks! Compare real unit price per 100g/ml after discounts.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Option A Card
          _buildItemCard(
            title: 'Option A (e.g. Small Pack)',
            cardColor: _bestOption == 1 ? Colors.green.withOpacity(0.2) : const Color(0xFF2A2A3D),
            borderColor: _bestOption == 1 ? Colors.green : Colors.transparent,
            priceController: _priceAController,
            qtyController: _qtyAController,
            discountController: _discountAController,
            onChanged: _calculateValue,
            isBest: _bestOption == 1,
          ),

          const SizedBox(height: 16),

          // Option B Card
          _buildItemCard(
            title: 'Option B (e.g. Family / Bulk Pack)',
            cardColor: _bestOption == 2 ? Colors.green.withOpacity(0.2) : const Color(0xFF2A2A3D),
            borderColor: _bestOption == 2 ? Colors.green : Colors.transparent,
            priceController: _priceBController,
            qtyController: _qtyBController,
            discountController: _discountBController,
            onChanged: _calculateValue,
            isBest: _bestOption == 2,
          ),

          const SizedBox(height: 20),

          // Result Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigoAccent),
            ),
            child: Column(
              children: [
                const Text(
                  'SMART VALUE ANALYSIS',
                  style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  _resultText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                ),
                if (_savingsAmount > 0) ...[
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      widget.onDealSaved(_savingsAmount);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Logged \$${_savingsAmount.toStringAsFixed(2)} saved to daily tracker!')),
                      );
                    },
                    icon: const Icon(Icons.bookmark_add),
                    label: Text('Log \$${_savingsAmount.toStringAsFixed(2)} Saved Today'),
                  )
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard({
    required String title,
    required Color cardColor,
    required Color borderColor,
    required TextEditingController priceController,
    required TextEditingController qtyController,
    required TextEditingController discountController,
    required VoidCallback onChanged,
    required bool isBest,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
              if (isBest)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.star, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text('BEST VALUE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => onChanged(),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Price (\$)',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => onChanged(),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Weight/Vol (g/ml)',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: discountController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => onChanged(),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Discount %',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// TAB 2: SMART BILL & TAX SPLITTER
class BillSplitterTab extends StatefulWidget {
  const BillSplitterTab({super.key});

  @override
  State<BillSplitterTab> createState() => _BillSplitterTabState();
}

class _BillSplitterTabState extends State<BillSplitterTab> {
  final _subtotalController = TextEditingController(text: '85.00');
  final _taxController = TextEditingController(text: '10'); // Service Charge / Tax
  final _tipController = TextEditingController(text: '5.00'); // Raw tip
  int _personCount = 3;

  double _totalAmount = 0.0;
  double _perPersonAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _recalculateBill();
  }

  void _recalculateBill() {
    final subtotal = double.tryParse(_subtotalController.text) ?? 0.0;
    final taxPercent = double.tryParse(_taxController.text) ?? 0.0;
    final tip = double.tryParse(_tipController.text) ?? 0.0;

    final taxAmount = subtotal * (taxPercent / 100);
    final total = subtotal + taxAmount + tip;
    final split = _personCount > 0 ? total / _personCount : total;

    setState(() {
      _totalAmount = total;
      _perPersonAmount = split;
    });
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
              Icon(Icons.receipt_long, color: Colors.amber, size: 28),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Smart Bill & Tax Splitter',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  softWrap: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Calculate taxes, service charge, tip, and split fairly among friends with WhatsApp export.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A3D),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _subtotalController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _recalculateBill(),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Subtotal Bill (\$)',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _taxController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _recalculateBill(),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Tax / Service Charge %',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _tipController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _recalculateBill(),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Extra Tip (\$)',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // People Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Split Between:', style: TextStyle(color: Colors.white, fontSize: 15)),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (_personCount > 1) {
                              setState(() {
                                _personCount--;
                                _recalculateBill();
                              });
                            }
                          },
                          icon: const Icon(Icons.remove_circle, color: Colors.amber),
                        ),
                        Text(
                          '$_personCount People',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _personCount++;
                              _recalculateBill();
                            });
                          },
                          icon: const Icon(Icons.add_circle, color: Colors.amber),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Total Display Card
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3F51B5), Color(0xFF1A237E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Grand Total (incl. Tax/Tip):', style: TextStyle(color: Colors.white70)),
                    Text(
                      '\$${_totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                const Divider(color: Colors.white70, height: 20),
                const Text('EACH PERSON PAYS', style: TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 1)),
                const SizedBox(height: 6),
                Text(
                  '\$${_perPersonAmount.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 34),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      final summaryText = 'Hey! The total bill is \$${_totalAmount.toStringAsFixed(2)} (Subtotal: \$${_subtotalController.text} + Tax/Tip).\nSplit between $_personCount people: \$${_perPersonAmount.toStringAsFixed(2)} each.\nSent via OmniHUD App.';
                      Clipboard.setData(ClipboardData(text: summaryText));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Bill summary copied to Clipboard for WhatsApp!')),
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Copy WhatsApp Split Message', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// TAB 3: QUICK-REPLY TEXT VAULT
class TextVaultTab extends StatefulWidget {
  const TextVaultTab({super.key});

  @override
  State<TextVaultTab> createState() => _TextVaultTabState();
}

class _TextVaultTabState extends State<TextVaultTab> {
  final List<Map<String, String>> _snippets = [
    {
      'title': 'Bank Account Wire Details',
      'category': 'Finance',
      'text': 'Bank: Commercial Bank | Acc: 8009123441 | Name: J. Doe | Branch: Central',
    },
    {
      'title': 'Home Delivery Address',
      'category': 'Address',
      'text': 'No. 42, Sunrise Gardens, 2nd Lane, High Level Road, Colombo 06.',
    },
    {
      'title': 'Quick Busy Response',
      'category': 'Chat',
      'text': 'In a meeting right now. Will call you back in 30 minutes!',
    },
    {
      'title': 'Standard Discount Promo Code',
      'category': 'Shopping',
      'text': 'SAVE20NOW - 20% off selected store items.',
    },
  ];

  final _titleController = TextEditingController();
  final _textController = TextEditingController();

  void _addNewSnippet() {
    if (_titleController.text.isNotEmpty && _textController.text.isNotEmpty) {
      setState(() {
        _snippets.insert(0, {
          'title': _titleController.text,
          'category': 'Custom',
          'text': _textController.text,
        });
        _titleController.clear();
        _textController.clear();
      });
      Navigator.pop(context);
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.copy_all, color: Colors.amber, size: 28),
                  SizedBox(width: 10),
                  Text(
                    'Quick Text Vault',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => _showAddSnippetDialog(context),
                icon: const Icon(Icons.add_circle, color: Colors.amber, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Keep frequent texts, bank numbers, addresses, and promos ready for 1-tap copy!',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _snippets.length,
            itemBuilder: (ctx, index) {
              final snippet = _snippets[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A3D),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white70),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.indigoAccent.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            snippet['category']!,
                            style: const TextStyle(color: Colors.indigoAccent, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.content_copy, color: Colors.amber, size: 20),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: snippet['text']!));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Copied "${snippet['title']}" to clipboard!')),
                            );
                          },
                        ),
                      ],
                    ),
                    Text(
                      snippet['title']!,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      snippet['text']!,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                      softWrap: true,
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void _showAddSnippetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A3D),
        title: const Text('Add New Snippet', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Snippet Title',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _textController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Text Content to Copy',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
            onPressed: _addNewSnippet,
            child: const Text('Save Snippet'),
          )
        ],
      ),
    );
  }
}

// TAB 4: HUD CONTROLS & DAILY SAVINGS STREAK
class HUDControlTab extends StatelessWidget {
  final bool isFloatingEnabled;
  final ValueChanged<bool> onToggleFloating;
  final double totalSaved;
  final int decisionsCount;

  const HUDControlTab({
    super.key,
    required this.isFloatingEnabled,
    required this.onToggleFloating,
    required this.totalSaved,
    required this.decisionsCount,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.tune, color: Colors.amber, size: 28),
              SizedBox(width: 10),
              Text(
                'HUD Settings & Impact',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Control floating screen assistant permissions and track total daily value.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Floating Overlay Switcher Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A3D),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigoAccent.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Floating Screen Bubble Dock',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Simulates display over apps to provide quick split & text macros anywhere.',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isFloatingEnabled,
                  activeColor: Colors.amber,
                  onChanged: onToggleFloating,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Savings Impact Dashboard Card
          Container(
            padding: const EdgeInsets.all(18),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.stars, color: Colors.amber, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'DAILY SAVINGS DASHBOARD',
                      style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '\$${totalSaved.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 26),
                        ),
                        const SizedBox(height: 4),
                        const Text('Total Money Saved', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    Container(height: 40, width: 1, color: Colors.white70),
                    Column(
                      children: [
                        Text(
                          '$decisionsCount',
                          style: const TextStyle(color: Colors.indigoAccent, fontWeight: FontWeight.bold, fontSize: 26),
                        ),
                        const SizedBox(height: 4),
                        const Text('Smart Micro Decisions', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAxisAlignment.center,
                  children: [
                    Chip(
                      backgroundColor: Colors.amber.withOpacity(0.2),
                      label: const Text('🏆 Deal Ninja Grade A', style: TextStyle(color: Colors.amber, fontSize: 11)),
                    ),
                    Chip(
                      backgroundColor: Colors.indigo.withOpacity(0.3),
                      label: const Text('🔥 5 Day Streak Active', style: TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}