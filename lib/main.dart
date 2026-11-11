import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const BubbleDeckApp());
}

class BubbleDeckApp extends StatelessWidget {
  const BubbleDeckApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BubbleDeck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0E15),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _isFloatingActive = true;
  bool _overlayPermission = true;
  bool _notificationAlerts = true;

  // Floating bubble position state
  Offset _bubbleOffset = const Offset(280, 350);
  bool _isBubbleMenuOpen = false;

  // Impulse Sanity Engine Controllers
  final TextEditingController _wageController = TextEditingController(text: "20.00");
  final TextEditingController _itemCostController = TextEditingController(text: "150.00");
  final TextEditingController _hoursPerDayController = TextEditingController(text: "8");

  // Snippets Data
  final List<Map<String, String>> _snippets = [
    {
      "title": "Home Delivery Address",
      "content": "No. 45/2 Lotus Gardens, Apartment 3B, Downtown Avenue",
      "category": "Address"
    },
    {
      "title": "Main Bank IBAN",
      "content": "US89 3704 0044 0532 0130 00",
      "category": "Finance"
    },
    {
      "title": "Quick Busy Reply",
      "content": "Hey! I'm currently in a meeting. I'll get back to you in an hour.",
      "category": "Text"
    },
    {
      "title": "Tax Identification ID",
      "content": "TX-9948201-X",
      "category": "ID"
    },
  ];

  // Quick Decision Items
  final List<String> _quickDecisions = [
    "Order food delivery",
    "Cook home meal",
    "Go for a 15-min walk",
    "Power nap for 20 mins",
    "Focus on high-priority task",
  ];
  String _selectedDecisionResult = "";

  @override
  void dispose() {
    _wageController.dispose();
    _itemCostController.dispose();
    _hoursPerDayController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String title) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Copied '$title' to clipboard!"),
        backgroundColor: Colors.deepPurple,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addNewSnippet() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1F2C),
        title: const Text("Add New Quick Snippet", style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Title (e.g. WiFi Password)",
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Text Content to copy",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            onPressed: () {
              if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                setState(() {
                  _snippets.add({
                    "title": titleController.text,
                    "content": contentController.text,
                    "category": "Custom"
                  });
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text("Save Snippet", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _spinRandomDecision() {
    if (_quickDecisions.isEmpty) return;
    final randomIdx = DateTime.now().millisecondsSinceEpoch % _quickDecisions.length;
    setState(() {
      _selectedDecisionResult = _quickDecisions[randomIdx];
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Main Body Tabs
          SafeArea(
            child: Column(
              children: [
                _buildHeaderBar(),
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      _buildFloatingDockTab(),
                      _buildImpulseSanityTab(),
                      _buildQuickStashTab(),
                      _buildDecisionMatrixTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Interactive Draggable Floating Bubble Overlay Simulation
          if (_isFloatingActive)
            Positioned(
              left: _bubbleOffset.dx.clamp(10.0, screenSize.width - 70.0),
              top: _bubbleOffset.dy.clamp(50.0, screenSize.height - 120.0),
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubbleOffset += details.delta;
                  });
                },
                onTap: () {
                  setState(() {
                    _isBubbleMenuOpen = !_isBubbleMenuOpen;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_isBubbleMenuOpen) _buildBubbleQuickActions(),
                    const SizedBox(height: 8),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.deepPurple, Colors.indigo],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.5),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isBubbleMenuOpen ? Icons.close : Icons.widgets,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF141522),
        selectedItemColor: Colors.purpleAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Floating Dock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Impulse Check',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy),
            label: 'Quick Stash',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Decision Deck',
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF141522),
        border: Border(bottom: BorderSide(color: Colors.white70, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.bolt, color: Colors.purpleAccent, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "BubbleDeck Assistant",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Live Multi-Task Utility & Instant Helper",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Switch(
            value: _isFloatingActive,
            activeColor: Colors.purpleAccent,
            onChanged: (val) {
              setState(() {
                _isFloatingActive = val;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBubbleQuickActions() {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1F2C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purpleAccent.withOpacity(0.3)),
        boxShadow: const [
          BoxShadow(color: Colors.black87, blurRadius: 10, spreadRadius: 2)
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Quick Dock Controls",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
          ),
          const Divider(color: Colors.white70),
          ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            leading: const Icon(Icons.content_copy, color: Colors.cyan, size: 18),
            title: const Text("Copy Home Address", style: TextStyle(fontSize: 12, color: Colors.white)),
            onTap: () {
              _copyToClipboard(_snippets[0]["content"]!, _snippets[0]["title"]!);
              setState(() => _isBubbleMenuOpen = false);
            },
          ),
          ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            leading: const Icon(Icons.monetization_on, color: Colors.amber, size: 18),
            title: const Text("Check Impulse Cost", style: TextStyle(fontSize: 12, color: Colors.white)),
            onTap: () {
              setState(() {
                _currentIndex = 1;
                _isBubbleMenuOpen = false;
              });
            },
          ),
          ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            leading: const Icon(Icons.shuffle, color: Colors.green, size: 18),
            title: const Text("Spin Quick Decision", style: TextStyle(fontSize: 12, color: Colors.white)),
            onTap: () {
              _spinRandomDecision();
              setState(() {
                _currentIndex = 3;
                _isBubbleMenuOpen = false;
              });
            },
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating Dock & Controls
  Widget _buildFloatingDockTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusBanner(),
          const SizedBox(height: 20),
          const Text(
            "System & Overlay Permissions",
            style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Card(
            color: const Color(0xFF1A1B28),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("Display Over Other Apps", style: TextStyle(color: Colors.white)),
                  subtitle: const Text("Allows the floating bubble to stay accessible anywhere", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  value: _overlayPermission,
                  activeColor: Colors.teal,
                  onChanged: (val) => setState(() => _overlayPermission = val),
                ),
                const Divider(color: Colors.white70, height: 1),
                SwitchListTile(
                  title: const Text("Floating Notifications Alert", style: TextStyle(color: Colors.white)),
                  subtitle: const Text("Instant heads-up popups for macro shortcuts", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  value: _notificationAlerts,
                  activeColor: Colors.teal,
                  onChanged: (val) => setState(() => _notificationAlerts = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Interactive Floating Dock Features",
            style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildFeatureCard(
                icon: Icons.content_paste_go,
                title: "1-Tap Copy",
                desc: "Instant access to text templates",
                color: Colors.purpleAccent,
              ),
              _buildFeatureCard(
                icon: Icons.calculate_outlined,
                title: "Impulse Radar",
                desc: "Real-time buying regret engine",
                color: Colors.amber,
              ),
              _buildFeatureCard(
                icon: Icons.touch_app,
                title: "Draggable Deck",
                desc: "Move bubble to any screen edge",
                color: Colors.cyan,
              ),
              _buildFeatureCard(
                icon: Icons.notifications_active_outlined,
                title: "Smart Overlay",
                desc: "Non-intrusive float assistant",
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade900, Colors.indigo.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purpleAccent.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _isFloatingActive ? Icons.check_circle : Icons.pause_circle_filled,
                color: _isFloatingActive ? Colors.greenAccent : Colors.orangeAccent,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _isFloatingActive ? "Bubble Dock is ACTIVE" : "Bubble Dock is PAUSED",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Drag the floating purple bubble anywhere on the screen! Tap it to reveal instant copy actions and quick utility tools without leaving your current app.",
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String desc,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B28),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // TAB 2: Impulse Sanity Engine
  Widget _buildImpulseSanityTab() {
    final double hourlyWage = double.tryParse(_wageController.text) ?? 20.0;
    final double itemCost = double.tryParse(_itemCostController.text) ?? 150.0;
    final double hoursPerDay = double.tryParse(_hoursPerDayController.text) ?? 8.0;

    final double totalHoursNeeded = hourlyWage > 0 ? (itemCost / hourlyWage) : 0;
    final double daysOfWorkNeeded = hoursPerDay > 0 ? (totalHoursNeeded / hoursPerDay) : 0;

    // Investment potential (5 years at 7% return)
    final double potentialGrowth = itemCost * 1.4025;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Impulse Sanity & Price Converter",
            style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            "Before buying, convert price tag into actual hours of your life spent working!",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1B28),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _itemCostController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: "Product Price (\$)",
                    prefixIcon: Icon(Icons.shopping_bag, color: Colors.amber),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _wageController,
                        keyboardType: TextInputType.number,
                        onChanged: (val) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: "Your Hourly Wage (\$)",
                          prefixIcon: Icon(Icons.attach_money, color: Colors.green),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _hoursPerDayController,
                        keyboardType: TextInputType.number,
                        onChanged: (val) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: "Work Hours/Day",
                          prefixIcon: Icon(Icons.schedule, color: Colors.cyan),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.shade900.withOpacity(0.6), Colors.deepOrange.shade900.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                const Text(
                  "THIS PRODUCT COSTS YOU",
                  style: TextStyle(letterSpacing: 1.2, fontWeight: FontWeight.bold, color: Colors.amberAccent, fontSize: 12),
                ),
                const SizedBox(height: 10),
                FittedBox(
                  child: Text(
                    "${totalHoursNeeded.toStringAsFixed(1)} HOURS",
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Text(
                  "Equal to approx ${daysOfWorkNeeded.toStringAsFixed(1)} full working days",
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const Divider(color: Colors.white70, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text("Price Tag", style: TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 4),
                        Text("\$${itemCost.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("5-Yr Growth Loss", style: TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 4),
                        Text(
                          "\$${potentialGrowth.toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent),
                        ),
                      ],
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

  // TAB 3: Quick Stash
  Widget _buildQuickStashTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Quick Copy Stash",
                      style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      "Tap any snippet to instant-copy",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _addNewSnippet,
                icon: const Icon(Icons.add, color: Colors.white, size: 18),
                label: const Text("Add New", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _snippets.length,
            itemBuilder: (context, index) {
              final item = _snippets[index];
              return Card(
                color: const Color(0xFF1A1B28),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item["title"]!,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item["category"]!,
                          style: const TextStyle(fontSize: 10, color: Colors.purpleAccent),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      item["content"]!,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy, color: Colors.cyan),
                    onPressed: () => _copyToClipboard(item["content"]!, item["title"]!),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // TAB 4: Decision Matrix Deck
  Widget _buildDecisionMatrixTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Micro-Decision Deck",
            style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            "Stuck in micro-hesitation? Spin the deck or pick priority!",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1B28),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.purpleAccent.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Icon(Icons.casino, color: Colors.purpleAccent, size: 40),
                const SizedBox(height: 12),
                Text(
                  _selectedDecisionResult.isEmpty
                      ? "Tap Spin to pick instant action"
                      : _selectedDecisionResult,
                  style: TextStyle(
                    fontSize: _selectedDecisionResult.isEmpty ? 15 : 20,
                    fontWeight: FontWeight.bold,
                    color: _selectedDecisionResult.isEmpty ? Colors.grey : Colors.greenAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _spinRandomDecision,
                  icon: const Icon(Icons.refresh, color: Colors.black),
                  label: const Text(
                    "Spin Quick Decider",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Current Micro-Option Deck",
            style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _quickDecisions.length,
            itemBuilder: (context, idx) {
              return Card(
                color: const Color(0xFF141522),
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple.shade800,
                    radius: 14,
                    child: Text("${idx + 1}", style: const TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                  title: Text(_quickDecisions[idx], style: const TextStyle(color: Colors.white, fontSize: 14)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                    onPressed: () {
                      setState(() {
                        _quickDecisions.removeAt(idx);
                      });
                    },
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