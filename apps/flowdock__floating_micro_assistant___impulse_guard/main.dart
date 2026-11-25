import 'package:flutter/material.dart';

void main() {
  runApp(const FlowDockApp());
}

class FlowDockApp extends StatelessWidget {
  const FlowDockApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlowDock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyan,
          secondary: Colors.teal,
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const FlowDockHomeScreen(),
    );
  }
}

class DynamicSnippet {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime createdAt;

  DynamicSnippet({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
  });
}

class ImpulseItem {
  final String id;
  final String name;
  final double price;
  final double workHoursNeeded;
  final DateTime addedDate;
  bool isCanceled;

  ImpulseItem({
    required this.id,
    required this.name,
    required this.price,
    required this.workHoursNeeded,
    required this.addedDate,
    this.isCanceled = false,
  });
}

class FlowDockHomeScreen extends StatefulWidget {
  const FlowDockHomeScreen({Key? key}) : super(key: key);

  @override
  State<FlowDockHomeScreen> createState() => _FlowDockHomeScreenState();
}

class _FlowDockHomeScreenState extends State<FlowDockHomeScreen> {
  int _selectedTabIndex = 0;

  // Floating Overlay Bubble State
  Offset _bubblePosition = const Offset(20, 150);
  bool _isDockEnabled = true;
  bool _isBubbleExpanded = false;

  // Worth-It Calculator State
  double _monthlyIncome = 2500.0;
  double _weeklyHours = 40.0;
  final TextEditingController _itemPriceController = TextEditingController(text: "149.99");
  final TextEditingController _itemNameController = TextEditingController(text: "Wireless Earbuds");
  double _calculatedWorkHours = 0.0;
  double _calculatedWorkDays = 0.0;

  // Snippets List
  final List<DynamicSnippet> _snippets = [
    DynamicSnippet(
      id: '1',
      title: 'Delivery Address',
      content: 'No. 45, Tech Avenue, Innovation Park, Sector 4',
      category: 'Address',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    DynamicSnippet(
      id: '2',
      title: 'Project Wifi Password',
      content: 'FlowDock2025!Pass',
      category: 'Password',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  // Impulse Guard Items
  final List<ImpulseItem> _impulseList = [];

  @override
  void initState() {
    super.initState();
    _recalculateWorkTime();
  }

  void _recalculateWorkTime() {
    double price = double.tryParse(_itemPriceController.text) ?? 0.0;
    double hourlyWage = (_monthlyIncome / 4.0) / (_weeklyHours <= 0 ? 1 : _weeklyHours);
    if (hourlyWage <= 0) hourlyWage = 1.0;

    setState(() {
      _calculatedWorkHours = price / hourlyWage;
      _calculatedWorkDays = _calculatedWorkHours / 8.0;
    });
  }

  void _addSnippet(String title, String content, String category) {
    if (title.isEmpty || content.isEmpty) return;
    setState(() {
      _snippets.insert(
        0,
        DynamicSnippet(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          content: content,
          category: category,
          createdAt: DateTime.now(),
        ),
      );
    });
  }

  void _addImpulseItem() {
    String name = _itemNameController.text.trim();
    double price = double.tryParse(_itemPriceController.text) ?? 0.0;
    if (name.isEmpty || price <= 0) return;

    setState(() {
      _impulseList.insert(
        0,
        ImpulseItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          price: price,
          workHoursNeeded: _calculatedWorkHours,
          addedDate: DateTime.now(),
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "$name" to 24h Cool-Down List!'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content Area
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedTabIndex,
                    children: [
                      _buildWorthItCalculatorTab(),
                      _buildImpulseGuardTab(),
                      _buildClipManagerTab(),
                      _buildDockSettingsTab(),
                    ],
                  ),
                ),
              ],
            ),

            // Simulated Floating Micro Assistant Bubble (Dynamic Overlay)
            if (_isDockEnabled) _buildFloatingDockOverlay(),

            // Expanded Floating Hub Modal
            if (_isDockEnabled && _isBubbleExpanded) _buildExpandedDockView(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Worth-It',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Impulse Guard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy),
            label: 'Quick Clips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Dock Setup',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(
          bottom: BorderSide(color: Colors.white70, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.cyan.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.widgets, color: Colors.cyan, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'FlowDock',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Smart Micro-Assistant & Saver',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                'Dock Widget',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Switch(
                value: _isDockEnabled,
                activeColor: Colors.cyan,
                onChanged: (val) {
                  setState(() {
                    _isDockEnabled = val;
                    if (!val) _isBubbleExpanded = false;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TAB 1: Worth-It Calculator
  Widget _buildWorthItCalculatorTab() {
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
                colors: [Color(0xFF0284C7), Color(0xFF0D9488)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Real Life Cost Visualizer',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Before tap-buying, see how many actual work hours of your life this product costs.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // User Salary Context Settings
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
                  'Your Work Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monthly Income: \$${_monthlyIncome.toInt()}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Slider(
                            value: _monthlyIncome,
                            min: 500,
                            max: 10000,
                            divisions: 190,
                            activeColor: Colors.cyan,
                            onChanged: (val) {
                              setState(() {
                                _monthlyIncome = val;
                                _recalculateWorkTime();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weekly Hours: ${_weeklyHours.toInt()}h',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Slider(
                            value: _weeklyHours,
                            min: 10,
                            max: 80,
                            divisions: 14,
                            activeColor: Colors.teal,
                            onChanged: (val) {
                              setState(() {
                                _weeklyHours = val;
                                _recalculateWorkTime();
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
          const SizedBox(height: 20),

          // Item Price Input
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
                  'Evaluate Purchase Item',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _itemNameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.shopping_bag, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _itemPriceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Price (\$)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.monetization_on, color: Colors.grey),
                  ),
                  onChanged: (val) => _recalculateWorkTime(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Calculation Result Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.cyan.withOpacity(0.5), width: 1.5),
            ),
            child: Column(
              children: [
                const Text(
                  'THIS ITEM WILL COST YOU',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                FittedBox(
                  child: Text(
                    '${_calculatedWorkHours.toStringAsFixed(1)} Work Hours',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '≈ ${_calculatedWorkDays.toStringAsFixed(1)} Full Work Days of Effort',
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _addImpulseItem,
                  icon: const Icon(Icons.timer_sharp),
                  label: const Text('Add to 24h Cool-Down Guard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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

  // TAB 2: Impulse Guard
  Widget _buildImpulseGuardTab() {
    double totalSaved = _impulseList
        .where((item) => item.isCanceled)
        .fold(0.0, (sum, item) => sum + item.price);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Savings Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.savings, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Impulse Saved',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        '\$${totalSaved.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.tealAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Cool-Down Wishlist',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Items sit here for 24 hours. Most buyers change their mind after cool-down!',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          if (_impulseList.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Icon(Icons.shopping_bag_outlined, color: Colors.grey, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'No items in cool-down matrix yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Use Worth-It tab to add items before buying!',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _impulseList.length,
              itemBuilder: (context, index) {
                final item = _impulseList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: item.isCanceled ? Colors.teal.withOpacity(0.5) : Colors.white70,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.isCanceled ? Icons.check_circle : Icons.timer,
                        color: item.isCanceled ? Colors.teal : Colors.amber,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                decoration:
                                    item.isCanceled ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '\$${item.price.toStringAsFixed(2)} (${item.workHoursNeeded.toStringAsFixed(1)} hrs of work)',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      if (!item.isCanceled)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              item.isCanceled = true;
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.tealAccent,
                          ),
                          child: const Text('Saved Money'),
                        )
                      else
                        const Text(
                          'Saved!',
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // TAB 3: Dynamic Quick Clips & Snippets
  Widget _buildClipManagerTab() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedCategory = 'General';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quick Clips Stack',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: const Color(0xFF1E293B),
                        title: const Text('Add Quick Snippet'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: titleController,
                              decoration: const InputDecoration(
                                labelText: 'Title',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: contentController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                labelText: 'Text Snippet / Link / Address',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              _addSnippet(
                                titleController.text,
                                contentController.text,
                                selectedCategory,
                              );
                              Navigator.pop(context);
                            },
                            child: const Text('Save Snippet'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Clip'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _snippets.length,
            itemBuilder: (context, index) {
              final snippet = _snippets[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white70),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          snippet.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan,
                            fontSize: 15,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18, color: Colors.grey),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Copied "${snippet.title}" to clipboard!'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      snippet.content,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // TAB 4: Floating Dock Settings & Tester
  Widget _buildDockSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Assistant Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Show Dock Assistant Bubble'),
                  subtitle: const Text('Simulates persistent floating overlay head'),
                  value: _isDockEnabled,
                  activeColor: Colors.cyan,
                  onChanged: (val) {
                    setState(() {
                      _isDockEnabled = val;
                      if (!val) _isBubbleExpanded = false;
                    });
                  },
                ),
                const Divider(color: Colors.white70),
                ListTile(
                  leading: const Icon(Icons.open_in_new, color: Colors.cyan),
                  title: const Text('Simulate Floating Micro-Tools'),
                  subtitle: const Text('Tap to test overlay quick view'),
                  onTap: () {
                    setState(() {
                      _isDockEnabled = true;
                      _isBubbleExpanded = true;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(Icons.security, color: Colors.teal, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Overlay Permissions Granted',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'FlowDock is ready to serve micro-calculations and clipboard snippets on top of any active screen.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Floating Overlay Bubble Widget (Draggable Simulator)
  Widget _buildFloatingDockOverlay() {
    return Positioned(
      left: _bubblePosition.dx,
      top: _bubblePosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubblePosition += details.delta;
          });
        },
        onTap: () {
          setState(() {
            _isBubbleExpanded = !_isBubbleExpanded;
          });
        },
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Colors.cyan, Colors.teal],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyan.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.widgets,
              color: Colors.black,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }

  // Expanded Floating Dock Menu (Micro Assistant overlay popup)
  Widget _buildExpandedDockView() {
    return Positioned(
      left: 20,
      right: 20,
      top: 100,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.cyan, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black87,
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.bolt, color: Colors.cyan),
                      SizedBox(width: 8),
                      Text(
                        'FlowDock Mini Hub',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _isBubbleExpanded = false;
                      });
                    },
                  ),
                ],
              ),
              const Divider(color: Colors.white70),
              const SizedBox(height: 8),

              // Quick Micro Actions Inside Floating Dock
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  _buildDockActionButton(
                    icon: Icons.monetization_on,
                    label: 'Quick Cost',
                    onTap: () {
                      setState(() {
                        _isBubbleExpanded = false;
                        _selectedTabIndex = 0;
                      });
                    },
                  ),
                  _buildDockActionButton(
                    icon: Icons.shield,
                    label: 'Impulse List',
                    onTap: () {
                      setState(() {
                        _isBubbleExpanded = false;
                        _selectedTabIndex = 1;
                      });
                    },
                  ),
                  _buildDockActionButton(
                    icon: Icons.content_paste,
                    label: 'Fast Clip',
                    onTap: () {
                      setState(() {
                        _isBubbleExpanded = false;
                        _selectedTabIndex = 2;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Active Hourly Rate: \$${((_monthlyIncome / 4) / _weeklyHours).toStringAsFixed(2)}/hr',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.cyan),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDockActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 85,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white70),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.cyan, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}