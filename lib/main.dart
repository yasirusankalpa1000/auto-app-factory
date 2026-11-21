import 'package:flutter/material.dart';

void main() {
  runApp(const QuickDeckApp());
}

class QuickDeckApp extends StatelessWidget {
  const QuickDeckApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'QuickDeck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const MainDeckScreen(),
    );
  }
}

class SnippetItem {
  final String id;
  final String title;
  final String content;
  final String category;
  final IconData icon;

  SnippetItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.icon,
  });
}

class MainDeckScreen extends StatefulWidget {
  const MainDeckScreen({Key? key}) : super(key: key);

  @override
  State<MainDeckScreen> createState() => _MainDeckScreenState();
}

class _MainDeckScreenState extends State<MainDeckScreen> {
  int _currentIndex = 0;
  bool _isFloatingHudEnabled = true;
  double _totalSavedMoney = 145.50;
  int _streakDays = 5;

  // Impulse Guard state
  final TextEditingController _itemPriceController = TextEditingController(text: "45.00");
  final TextEditingController _hourlyWageController = TextEditingController(text: "15.00");
  double _calculatedHours = 3.0;
  String _regretLevel = "Moderate Risk";

  // Splitter state
  final TextEditingController _totalAmountController = TextEditingController(text: "120.00");
  int _peopleCount = 4;
  double _tipPercentage = 10.0;

  // Snippets state
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: "1",
      title: "Bank Account Details",
      content: "Bank of Ceylon\nAcc: 8492019482\nBranch: Colombo Central",
      category: "Finance",
      icon: Icons.monetization_on,
    ),
    SnippetItem(
      id: "2",
      title: "Delivery Address",
      content: "No. 45/2, Main Street, Nugegoda, Sri Lanka (Zip: 10250)",
      category: "Personal",
      icon: Icons.home,
    ),
    SnippetItem(
      id: "3",
      title: "Quick Polite Reply",
      content: "Thank you for reaching out! I've received your request and will get back to you shortly.",
      category: "Work",
      icon: Icons.chat_bubble_outline,
    ),
    SnippetItem(
      id: "4",
      title: "Home Wi-Fi Key",
      content: "Network: Fiber_Home_Guest | Key: SecurePass2025!",
      category: "Tech",
      icon: Icons.wifi,
    ),
  ];

  String _snippetSearchQuery = "";
  String _selectedCategory = "All";

  // Decision Maker state
  final List<String> _foodOptions = ["Rice & Curry", "Kottu", "Burger", "Pasta", "Salad", "Fried Rice"];
  String _selectedDecision = "Tap button to decide!";

  @override
  void dispose() {
    _itemPriceController.dispose();
    _hourlyWageController.dispose();
    _totalAmountController.dispose();
    super.dispose();
  }

  void _recalculateImpulse() {
    final double price = double.tryParse(_itemPriceController.text) ?? 0.0;
    final double wage = double.tryParse(_hourlyWageController.text) ?? 1.0;
    setState(() {
      _calculatedHours = wage > 0 ? price / wage : 0.0;
      if (_calculatedHours > 10) {
        _regretLevel = "HIGH REGRET RISK (Think 48 hrs!)";
      } else if (_calculatedHours > 3) {
        _regretLevel = "Moderate Risk (Sleep on it)";
      } else {
        _regretLevel = "Safe / Low Risk";
      }
    });
  }

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _addNewSnippetModal() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    String category = "Personal";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
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
                  "Add New Quick Snippet",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: "Title (e.g. NIC Number)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contentCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Snippet Content / Text",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                        setState(() {
                          _snippets.insert(
                            0,
                            SnippetItem(
                              id: DateTime.now().toString(),
                              title: titleCtrl.text,
                              content: contentCtrl.text,
                              category: category,
                              icon: Icons.star,
                            ),
                          );
                        });
                        Navigator.pop(ctx);
                        _showNotification("Snippet saved to QuickDeck Vault!");
                      }
                    },
                    child: const Text("Save Snippet", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.bolt, color: Colors.amber),
            SizedBox(width: 8),
            Text('QuickDeck Companion', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_isFloatingHudEnabled ? Icons.widgets : Icons.widgets_outlined),
            tooltip: 'Toggle Floating HUD',
            onPressed: () {
              setState(() {
                _isFloatingHudEnabled = !_isFloatingHudEnabled;
              });
              _showNotification(
                _isFloatingHudEnabled
                    ? "Floating Assistant Overlay active!"
                    : "Floating Assistant Overlay hidden.",
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: [
                _buildDashboardTab(),
                _buildSnippetVaultTab(),
                _buildImpulseGuardTab(),
                _buildSplitterAndToolsTab(),
              ],
            ),
            if (_isFloatingHudEnabled) _buildFloatingHudOverlay(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarThemeData(
            data: BottomNavigationBarThemeData(),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Deck'),
          BottomNavigationBarItem(icon: Icon(Icons.content_copy), label: 'Vault'),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: 'Guard'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Tools'),
        ],
      ),
    );
  }

  // --- FLOATING HUD SIMULATION OVERLAY ---
  Widget _buildFloatingHudOverlay() {
    return Positioned(
      bottom: 20,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(30),
        color: Colors.indigo,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            _showQuickFloatingMenu();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt, color: Colors.amber, size: 20),
                SizedBox(width: 6),
                Text(
                  "Quick HUD",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showQuickFloatingMenu() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.bolt, color: Colors.indigo),
            SizedBox(width: 8),
            Text("Floating Quick HUD"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy, color: Colors.indigo),
              title: const Text("Copy Bank Account"),
              onTap: () {
                Navigator.pop(ctx);
                _showNotification("Copied: Bank of Ceylon - 8492019482");
              },
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.teal),
              title: const Text("Copy Delivery Address"),
              onTap: () {
                Navigator.pop(ctx);
                _showNotification("Copied: No. 45/2, Main Street, Nugegoda");
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined, color: Colors.deepOrange),
              title: const Text("Quick Impulse Check"),
              onTap: () {
                Navigator.pop(ctx);
                setState(() => _currentIndex = 2);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  // --- TAB 1: DASHBOARD ---
  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.indigo, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.stars, color: Colors.amber, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Impulse Savings Guard",
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          Text(
                            "\$${_totalSavedMoney.toStringAsFixed(2)} Saved",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Chip(
                      label: Text("🔥 $_streakDays Day Streak"),
                      backgroundColor: Colors.amber,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  "You avoided 3 impulse purchases this week! Keep your companion floating for fast daily shortcuts.",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "Quick Launch Utility Deck",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Quick Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _buildQuickCard(
                title: "Text Vault",
                subtitle: "4 Saved Snippets",
                icon: Icons.content_copy,
                color: Colors.indigo,
                onTap: () => setState(() => _currentIndex = 1),
              ),
              _buildQuickCard(
                title: "Work-Hour Cost",
                subtitle: "Impulse Evaluator",
                icon: Icons.monetization_on,
                color: Colors.teal,
                onTap: () => setState(() => _currentIndex = 2),
              ),
              _buildQuickCard(
                title: "Bill Splitter",
                subtitle: "Group Cost Tally",
                icon: Icons.calculate,
                color: Colors.orange,
                onTap: () => setState(() => _currentIndex = 3),
              ),
              _buildQuickCard(
                title: "Meal Picker",
                subtitle: "Random Decider",
                icon: Icons.lightbulb,
                color: Colors.blueGrey,
                onTap: () => setState(() => _currentIndex = 3),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Text(
            "Pinned Frequent Snippets",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _snippets.length > 2 ? 2 : _snippets.length,
            itemBuilder: (context, index) {
              final item = _snippets[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.withOpacity(0.1),
                    child: Icon(item.icon, color: Colors.indigo),
                  ),
                  title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    item.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy, color: Colors.indigo),
                    onPressed: () => _showNotification("Copied '${item.title}' to Clipboard!"),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- TAB 2: SMART SNIPPET VAULT ---
  Widget _buildSnippetVaultTab() {
    final filteredSnippets = _snippets.where((item) {
      final matchesSearch = item.title.toLowerCase().contains(_snippetSearchQuery.toLowerCase()) ||
          item.content.toLowerCase().contains(_snippetSearchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == "All" || item.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).cardColor,
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "Search addresses, accounts, text...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
                onChanged: (val) => setState(() => _snippetSearchQuery = val),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ["All", "Finance", "Personal", "Work", "Tech"].map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(cat),
                        onSelected: (bool selected) {
                          setState(() => _selectedCategory = cat);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: filteredSnippets.isEmpty
              ? const Center(
                  child: Text("No snippets found. Tap '+' to create one!"),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredSnippets.length,
                  itemBuilder: (context, index) {
                    final item = filteredSnippets[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(item.icon, color: Colors.indigo, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    item.category,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                            const Divider(),
                            Text(
                              item.content,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.share, size: 16),
                                  label: const Text("Share"),
                                  onPressed: () => _showNotification("Sharing snippet..."),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.copy, size: 16),
                                  label: const Text("1-Tap Copy"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () => _showNotification("Copied content to clipboard!"),
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Add New Quick Snippet"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: _addNewSnippetModal,
          ),
        ),
      ],
    );
  }

  // --- TAB 3: IMPULSE BUY GUARD ---
  Widget _buildImpulseGuardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.amber.shade100,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.black87),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Impulse Guard evaluates item prices into the exact HOURS of your life required to pay for it.",
                      style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Impulse Purchase Calculator",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _itemPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Item Price (\$)",
                      prefixIcon: Icon(Icons.shopping_cart),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _recalculateImpulse(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _hourlyWageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Your Hourly Income (\$/hr)",
                      prefixIcon: Icon(Icons.monetization_on),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _recalculateImpulse(),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "This item costs you:",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(height: 6),
                        FittedBox(
                          child: Text(
                            "${_calculatedHours.toStringAsFixed(1)} HOURS",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                        ),
                        const Text(
                          "of real hard work!",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        Chip(
                          label: Text(_regretLevel),
                          backgroundColor: _calculatedHours > 5 ? Colors.red.shade100 : Colors.green.shade100,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _calculatedHours > 5 ? Colors.red.shade900 : Colors.green.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _totalSavedMoney += double.tryParse(_itemPriceController.text) ?? 0.0;
                            });
                            _showNotification("Awesome! Added to your saved money score!");
                          },
                          child: const Text("I Skipped Buying!"),
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

  // --- TAB 4: QUICK SPLITTER & TOOLS ---
  Widget _buildSplitterAndToolsTab() {
    final double total = double.tryParse(_totalAmountController.text) ?? 0.0;
    final double tip = (total * _tipPercentage) / 100;
    final double grandTotal = total + tip;
    final double perPerson = _peopleCount > 0 ? grandTotal / _peopleCount : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bill Splitter Card
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.calculate, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        "Group Expense & Bill Splitter",
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _totalAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Total Bill Amount (\$)",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Text("People: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (_peopleCount > 1) setState(() => _peopleCount--);
                        },
                      ),
                      Text("$_peopleCount", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => setState(() => _peopleCount++),
                      ),
                      const Spacer(),
                      Text("Tip: ${_tipPercentage.toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: _tipPercentage,
                    min: 0,
                    max: 30,
                    divisions: 6,
                    label: "${_tipPercentage.toInt()}%",
                    onChanged: (val) => setState(() => _tipPercentage = val),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Each Person Pays:"),
                            Text(
                              "\$${perPerson.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Bill incl. tip (${_tipPercentage.toInt()}%):", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            Text("\$${grandTotal.toStringAsFixed(2)}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.share),
                      label: const Text("Copy Bill Summary Text"),
                      onPressed: () {
                        _showNotification("Copied: 'Total: \$${grandTotal.toStringAsFixed(2)} | \$${perPerson.toStringAsFixed(2)} per person'");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Micro Decision Wheel Card
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(
                        "Micro Decision Resolver",
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Stuck deciding what to eat or do? Let QuickDeck pick instantly!",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        _selectedDecision,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text("Pick Meal For Me!"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                      onPressed: () {
                        setState(() {
                          _selectedDecision = (_foodOptions..shuffle()).first;
                        });
                      },
                    ),
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