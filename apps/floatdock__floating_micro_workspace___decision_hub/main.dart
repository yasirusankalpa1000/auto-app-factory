import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const FloatDockApp());
}

class FloatDockApp extends StatelessWidget {
  const FloatDockApp({super.key});

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'FloatDock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF121418),
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.amber,
          surface: Color(0xFF1E222A),
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class ImpulseItem {
  final String id;
  final String name;
  final double price;
  final double hoursRequired;
  final DateTime addedTime;
  bool isResisted;

  ImpulseItem({
    required this.id,
    required this.name,
    required this.price,
    required this.hoursRequired,
    required this.addedTime,
    this.isResisted = false,
  });
}

class ClipSnip {
  final String id;
  final String title;
  final String content;
  final String category;

  ClipSnip({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  // Floating Overlay Bubble Settings
  bool _isFloatingDockEnabled = true;
  bool _isOverlayExpanded = false;
  Offset _dockPosition = const Offset(20, 180);

  // User Profile Financial Settings
  double _monthlyIncome = 1500.0;
  double _monthlyHours = 160.0;

  // Impulse Items List
  final List<ImpulseItem> _impulseItems = [];

  // Quick Snips List
  final List<ClipSnip> _snips = [
    ClipSnip(
      id: '1',
      title: 'Delivery Address',
      content: 'No 45, Flower Road, Colombo 07',
      category: 'Address',
    ),
    ClipSnip(
      id: '2',
      title: 'Bank Account ID',
      content: '8001293842 - Commercial Bank',
      category: 'Finance',
    ),
    ClipSnip(
      id: '3',
      title: 'Standard Quick Reply',
      content: 'Thanks for reaching out! I will check this and get back to you shortly.',
      category: 'Work',
    ),
  ];

  // Calculated Stats
  double get _hourlyWage => _monthlyHours > 0 ? _monthlyIncome / _monthlyHours : 1.0;

  double get _totalMoneySaved {
    double sum = 0.0;
    for (var item in _impulseItems) {
      if (item.isResisted) {
        sum += item.price;
      }
    }
    return sum;
  }

  double get _totalHoursSaved {
    double sum = 0.0;
    for (var item in _impulseItems) {
      if (item.isResisted) {
        sum += item.hoursRequired;
      }
    }
    return sum;
  }

  void _addImpulseItem(String name, double price) {
    double hoursNeeded = price / _hourlyWage;
    setState(() {
      _impulseItems.insert(
        0,
        ImpulseItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          price: price,
          hoursRequired: hoursNeeded,
          addedTime: DateTime.now(),
        ),
      );
    });
  }

  void _addClipSnip(String title, String content, String category) {
    setState(() {
      _snips.insert(
        0,
        ClipSnip(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          content: content,
          category: category,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildFloatingDockTab(),
                _buildLifeCostCalculatorTab(),
                _buildCooldownTankTab(),
                _buildSnipVaultTab(),
              ],
            ),
          ),
          if (_isFloatingDockEnabled) _buildSimulatedFloatingWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E222A),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Overlay Dock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Life Cost',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: 'Impulse Tank',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: 'Snip Vault',
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 1: FLOATING DOCK CONTROL & OVERLAY SIMULATOR
  // ---------------------------------------------------------------------------
  Widget _buildFloatingDockTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FloatDock Smart Workspace',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Keep high-frequency tools, floating calculations & context snips ready on top of every app.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFF1E222A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.layers, color: Colors.tealAccent, size: 28),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Floating System Overlay Bubble',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                      Switch(
                        value: _isFloatingDockEnabled,
                        onChanged: (val) {
                          setState(() {
                            _isFloatingDockEnabled = val;
                          });
                        },
                        activeColor: Colors.tealAccent,
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white70, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Overlay Status:',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _isFloatingDockEnabled ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _isFloatingDockEnabled ? Colors.green : Colors.red,
                          ),
                        ),
                        child: Text(
                          _isFloatingDockEnabled ? 'ACTIVE ON SCREEN' : 'DISABLED',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _isFloatingDockEnabled ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildQuickStatsCard(),
          const SizedBox(height: 16),
          const Text(
            'Overlay Settings & Income Baseline',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Card(
            color: const Color(0xFF1E222A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Monthly Income (\$)'),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          controller: TextEditingController(text: _monthlyIncome.toStringAsFixed(0)),
                          onSubmitted: (val) {
                            double? parsed = double.tryParse(val);
                            if (parsed != null && parsed > 0) {
                              setState(() {
                                _monthlyIncome = parsed;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Work Hours / Month'),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          controller: TextEditingController(text: _monthlyHours.toStringAsFixed(0)),
                          onSubmitted: (val) {
                            double? parsed = double.tryParse(val);
                            if (parsed != null && parsed > 0) {
                              setState(() {
                                _monthlyHours = parsed;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white70, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Your Hourly Wage Value:'),
                      Text(
                        '\$${_hourlyWage.toStringAsFixed(2)} / hour',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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

  Widget _buildQuickStatsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade900, const Color(0xFF1E222A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text('Money Saved', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    '\$${_totalMoneySaved.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                  ),
                ],
              ),
              Container(width: 1, height: 40, color: Colors.white70),
              Column(
                children: [
                  const Text('Life Hours Saved', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    '${_totalHoursSaved.toStringAsFixed(1)} hrs',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amberAccent),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 2: LIFE-COST IMPULSE CALCULATOR
  // ---------------------------------------------------------------------------
  Widget _buildLifeCostCalculatorTab() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Life-Cost Calculator',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'Before buying online, convert item prices into actual hours of your life worked.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFF1E222A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Item Name (e.g. Wireless Earbuds)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: priceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Price (\$)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.flash_on),
                      label: const Text('Calculate Life-Cost & Cool Down', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        String name = nameController.text.trim();
                        double price = double.tryParse(priceController.text) ?? 0.0;
                        if (name.isNotEmpty && price > 0) {
                          _addImpulseItem(name, price);
                          nameController.clear();
                          priceController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('"$name" added to Impulse Cooldown Tank!'),
                              backgroundColor: Colors.teal,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Instant Life Cost Reference Table',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          _buildReferenceTile('Coffee / Snack', 15.0),
          _buildReferenceTile('New Jacket / Shoes', 120.0),
          _buildReferenceTile('Latest Smartphone', 999.0),
          _buildReferenceTile('Weekend Trip', 450.0),
        ],
      ),
    );
  }

  Widget _buildReferenceTile(String title, double samplePrice) {
    double hoursNeeded = samplePrice / _hourlyWage;
    return Card(
      color: const Color(0xFF1E222A),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('\$${samplePrice.toStringAsFixed(2)}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber.withOpacity(0.5)),
          ),
          child: Text(
            '${hoursNeeded.toStringAsFixed(1)} Work Hours',
            style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 3: IMPULSE COOLDOWN TANK
  // ---------------------------------------------------------------------------
  Widget _buildCooldownTankTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Impulse Cooldown Tank',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Wait 24 hours before buying. Decide whether to resist or purchase.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _impulseItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.shield_outlined, size: 60, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'No items in your cooldown tank.\nCalculate an item life-cost to add one!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _impulseItems.length,
                    itemBuilder: (context, index) {
                      final item = _impulseItems[index];
                      return Card(
                        color: const Color(0xFF1E222A),
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: item.isResisted ? Colors.green.withOpacity(0.5) : Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '\$${item.price.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 16, color: Colors.amber.shade300),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Costs ${item.hoursRequired.toStringAsFixed(1)} hours of work',
                                    style: TextStyle(color: Colors.amber.shade300, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const Divider(color: Colors.white70, height: 20),
                              if (item.isResisted)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.greenAccent, size: 18),
                                      SizedBox(width: 6),
                                      Text(
                                        'Purchase Resisted! Money Saved.',
                                        style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.redAccent,
                                          side: const BorderSide(color: Colors.redAccent),
                                        ),
                                        icon: const Icon(Icons.shopping_cart_checkout, size: 16),
                                        label: const Text('Bought It'),
                                        onPressed: () {
                                          setState(() {
                                            _impulseItems.removeAt(index);
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                        ),
                                        icon: const Icon(Icons.shield, size: 16),
                                        label: const Text('Resist & Save'),
                                        onPressed: () {
                                          setState(() {
                                            item.isResisted = true;
                                          });
                                        },
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
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 4: QUICK SNIP CLIPBOARD VAULT
  // ---------------------------------------------------------------------------
  Widget _buildSnipVaultTab() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedCategory = 'General';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Quick Snip Vault',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.tealAccent, size: 30),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: const Color(0xFF1E222A),
                      title: const Text('Add Quick Snip'),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: titleController,
                              decoration: const InputDecoration(
                                labelText: 'Title (e.g. Account Number)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: contentController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                labelText: 'Content / Text Snippet',
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
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black),
                          onPressed: () {
                            if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                              _addClipSnip(titleController.text, contentController.text, selectedCategory);
                              Navigator.pop(ctx);
                            }
                          },
                          child: const Text('Save Snip'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Keep frequently pasted addresses, IDs, & messages ready for one-tap copying.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _snips.length,
              itemBuilder: (context, index) {
                final snip = _snips[index];
                return Card(
                  color: const Color(0xFF1E222A),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(snip.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        snip.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy, color: Colors.tealAccent),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: snip.content));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Copied "${snip.title}" to clipboard!'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _snips.removeAt(index);
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

  // ---------------------------------------------------------------------------
  // FLOATING SYSTEM OVERLAY SIMULATOR WIDGET (DRAGGABLE BUBBLE)
  // ---------------------------------------------------------------------------
  Widget _buildSimulatedFloatingWidget() {
    return Positioned(
      left: _dockPosition.dx,
      top: _dockPosition.dy,
      child: GestureDetecorWidget(
        onPanUpdate: (details) {
          setState(() {
            _dockPosition += details.delta;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E222A).withOpacity(0.95),
            borderRadius: BorderRadius.circular(_isOverlayExpanded ? 16 : 30),
            border: Border.all(color: Colors.tealAccent, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black87,
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isOverlayExpanded = !_isOverlayExpanded;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.tealAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.widgets, color: Colors.black, size: 20),
                    ),
                    if (_isOverlayExpanded) ...[
                      const SizedBox(width: 8),
                      const Text(
                        'FloatDock',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _isOverlayExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                    ]
                  ],
                ),
              ),
              if (_isOverlayExpanded) ...[
                const SizedBox(height: 10),
                const Divider(color: Colors.white70, height: 1),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.calculate, color: Colors.amber, size: 22),
                      tooltip: 'Quick Life-Cost',
                      onPressed: () {
                        setState(() {
                          _currentIndex = 1;
                          _isOverlayExpanded = false;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.shield, color: Colors.greenAccent, size: 22),
                      tooltip: 'Impulse Tank',
                      onPressed: () {
                        setState(() {
                          _currentIndex = 2;
                          _isOverlayExpanded = false;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.content_paste, color: Colors.tealAccent, size: 22),
                      tooltip: 'Snip Vault',
                      onPressed: () {
                        setState(() {
                          _currentIndex = 3;
                          _isOverlayExpanded = false;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class GestureDetecorWidget extends StatelessWidget {
  final Widget child;
  final Function(DragUpdateDetails) onPanUpdate;

  const GestureDetecorWidget({
    super.key,
    required this.child,
    required this.onPanUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onPanUpdate,
      child: child,
    );
  }
}