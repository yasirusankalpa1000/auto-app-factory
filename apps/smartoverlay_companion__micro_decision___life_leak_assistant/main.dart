import 'package:flutter/material.dart';

void main() {
  runApp(const SmartOverlayApp());
}

class SmartOverlayApp extends StatelessWidget {
  const SmartOverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartOverlay Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const SmartOverlayHomePage(),
    );
  }
}

class SmartOverlayHomePage extends StatefulWidget {
  const SmartOverlayHomePage({super.key});

  @override
  State<SmartOverlayHomePage> createState() => _SmartOverlayHomePageState();
}

class _SmartOverlayHomePageState extends State<SmartOverlayHomePage> {
  int _currentIndex = 0;

  // Floating overlay position & state
  bool _isFloatingWidgetEnabled = true;
  double _floatingX = 20.0;
  double _floatingY = 120.0;

  // Impulse Analyzer State
  final TextEditingController _itemPriceController = TextEditingController(text: "35");
  final TextEditingController _hourlyWageController = TextEditingController(text: "15");
  final TextEditingController _itemNameController = TextEditingController(text: "Fancy Sneakers");

  // Reclaimed Stats
  double _totalMoneySaved = 145.0;
  double _hoursSaved = 9.6;
  int _decisionsMade = 12;
  int _streakDays = 5;

  // Cool down quest state
  bool _isQuestActive = false;
  int _questTapsCount = 0;

  // Decision Engine State
  final List<String> _decisionOptions = [
    "Option A: Cook at home",
    "Option B: Order Food Delivery",
    "Option C: Quick Meal Prep"
  ];
  int _selectedDecisionIndex = 0;

  @override
  void dispose() {
    _itemPriceController.dispose();
    _hourlyWageController.dispose();
    _itemNameController.dispose();
    super.dispose();
  }

  void _startCoolDownQuest() {
    setState(() {
      _isQuestActive = true;
      _questTapsCount = 0;
    });
  }

  void _onQuestTap() {
    if (_isQuestActive) {
      setState(() {
        _questTapsCount++;
        if (_questTapsCount >= 5) {
          _isQuestActive = false;
          double price = double.tryParse(_itemPriceController.text) ?? 20.0;
          double wage = double.tryParse(_hourlyWageController.text) ?? 15.0;
          if (wage <= 0) wage = 1.0;
          _totalMoneySaved += price;
          _hoursSaved += (price / wage);
          _decisionsMade++;
          _showSavedDialog(price);
        }
      });
    }
  }

  void _showSavedDialog(double amount) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.stars, color: Colors.amber),
            SizedBox(width: 8),
            Text("Impulse Avoided!"),
          ],
        ),
        content: Text(
          "Awesome job! You just saved \$${amount.toStringAsFixed(2)} and re-invested your personal life energy into true priorities.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Awesome"),
          )
        ],
      ),
    );
  }

  void _showQuickModal() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Smart Overlay Actions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.attach_money, color: Colors.green),
                  title: const Text("Analyze Micro-Expense"),
                  subtitle: const Text("Calculate real work cost before buying"),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _currentIndex = 0);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.lightbulb, color: Colors.amber),
                  title: const Text("Solve Quick Choice Dilemma"),
                  subtitle: const Text("Food, transport, impulse items"),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _currentIndex = 1);
                  },
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
        title: const Text("SmartOverlay Companion"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isFloatingWidgetEnabled ? Icons.widgets : Icons.widgets_outlined),
            onPressed: () {
              setState(() {
                _isFloatingWidgetEnabled = !_isFloatingWidgetEnabled;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isFloatingWidgetEnabled ? "Floating Assistant Enabled" : "Floating Assistant Hidden"),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            tooltip: "Toggle Floating Assistant",
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: _buildCurrentTab(),
          ),
          if (_isFloatingWidgetEnabled)
            Positioned(
              left: _floatingX,
              top: _floatingY,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _floatingX += details.delta.dx;
                    _floatingY += details.delta.dy;
                  });
                },
                child: _buildFloatingWidgetBubble(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Leak Shield',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Decision IQ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Overlay Hub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Scoreboard',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingWidgetBubble() {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(28),
      color: Colors.indigo,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.smart_toy, color: Colors.amber, size: 22),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Smart Bubble",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
                Text(
                  "\$${_totalMoneySaved.toStringAsFixed(0)} Saved",
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _showQuickModal,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.bolt, color: Colors.black, size: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentIndex) {
      case 0:
        return _buildImpulseLeakAnalyzer();
      case 1:
        return _buildDecisionEngine();
      case 2:
        return _buildOverlayHub();
      case 3:
        return _buildScoreboard();
      default:
        return _buildImpulseLeakAnalyzer();
    }
  }

  // --- TAB 1: IMPULSE & MICRO-LEAK ANALYZER ---
  Widget _buildImpulseLeakAnalyzer() {
    double price = double.tryParse(_itemPriceController.text) ?? 0.0;
    double wage = double.tryParse(_hourlyWageController.text) ?? 1.0;
    if (wage <= 0) wage = 1.0;

    double hoursNeeded = price / wage;
    double compound5Yr = price * 1.40;
    int coffeeCount = (price / 4.50).floor();
    int bookCount = (price / 15.00).floor();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.indigo,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.notifications, color: Colors.amber, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Impulse Spend Analyzer",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Calculate the actual work-life cost before spending \$1!",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text("Micro-Expense Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),

          TextField(
            controller: _itemNameController,
            decoration: const InputDecoration(
              labelText: "What do you want to buy?",
              prefixIcon: Icon(Icons.shopping_bag),
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => setState(() {}),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _itemPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Price (\$)",
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _hourlyWageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Hourly Wage (\$)",
                    prefixIcon: Icon(Icons.schedule),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Real Life Trade-Off for '${_itemNameController.text.isEmpty ? "Item" : _itemNameController.text}'",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const Divider(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.schedule, color: Colors.deepOrange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Work Required: ${hoursNeeded.toStringAsFixed(1)} Hours of your labor",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "5-Year Opportunity Cost: \$${compound5Yr.toStringAsFixed(2)} if invested",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text("Equals approximately:", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.local_cafe, size: 16),
                        label: Text("$coffeeCount Gourmet Coffees"),
                      ),
                      Chip(
                        avatar: const Icon(Icons.menu_book, size: 16),
                        label: Text("$bookCount Books"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Card(
            color: Colors.amber.shade50,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.amber, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    "60-Second Impulse Cool Down Quest",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Tap the pulse shield 5 times before buying to re-center your brain!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  if (!_isQuestActive)
                    ElevatedButton.icon(
                      onPressed: _startCoolDownQuest,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text("Start Cool Down Challenge"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                    )
                  else
                    Column(
                      children: [
                        LinearProgressIndicator(
                          value: _questTapsCount / 5.0,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.green,
                          minHeight: 10,
                        ),
                        const SizedBox(height: 12),
                        IconButton(
                          iconSize: 50,
                          icon: const Icon(Icons.touch_app, color: Colors.indigo),
                          onPressed: _onQuestTap,
                        ),
                        Text(
                          "Tap Shield: $_questTapsCount / 5",
                          style: const TextStyle(fontWeight: FontWeight.bold),
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

  // --- TAB 2: DECISION IQ ENGINE ---
  Widget _buildDecisionEngine() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Micro-Decision Resolver",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Stuck in choice paralysis? Compare micro-decisions with instant weighted scoring.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          const Text("Select Choice Dilemma:", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                label: const Text("What to Eat?"),
                avatar: const Icon(Icons.restaurant, size: 16),
                onPressed: () {},
              ),
              ActionChip(
                label: const Text("Transport Mode"),
                avatar: const Icon(Icons.directions_car, size: 16),
                onPressed: () {},
              ),
              ActionChip(
                label: const Text("Buy vs Wait"),
                avatar: const Icon(Icons.shopping_cart, size: 16),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Current Options:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _decisionOptions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Radio<int>(
                          value: index,
                          groupValue: _selectedDecisionIndex,
                          onChanged: (val) {
                            setState(() {
                              _selectedDecisionIndex = val!;
                            });
                          },
                        ),
                        title: Text(_decisionOptions[index]),
                        trailing: Text(
                          index == 0 ? "Score: 92/100" : index == 1 ? "Score: 54/100" : "Score: 78/100",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: index == 0 ? Colors.green : Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Selected: ${_decisionOptions[_selectedDecisionIndex]} - Optimal Choice!"),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check),
                    label: const Text("Confirm & Resolve Decision"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 44),
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

  // --- TAB 3: OVERLAY HUB ---
  Widget _buildOverlayHub() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Floating Assistant Overlay Settings",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Configure how the simulated floating overlay widget acts on your device screen for instant micro-decisions.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          SwitchListTile(
            title: const Text("Show Floating Assistant Bubble"),
            subtitle: const Text("Keep smart companion draggable on screen"),
            value: _isFloatingWidgetEnabled,
            onChanged: (val) {
              setState(() {
                _isFloatingWidgetEnabled = val;
              });
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.notifications_active, color: Colors.indigo),
            title: const Text("Floating Notifications & Smart Ticker"),
            subtitle: const Text("Show active savings counter on overlay"),
            trailing: Switch(value: true, onChanged: (v) {}),
          ),
          ListTile(
            leading: const Icon(Icons.vibration, color: Colors.indigo),
            title: const Text("Haptic Feedback on Impulse Warning"),
            subtitle: const Text("Vibrate when spending high amounts"),
            trailing: Switch(value: true, onChanged: (v) {}),
          ),
          const SizedBox(height: 16),

          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.info, color: Colors.blue, size: 30),
                  const SizedBox(height: 8),
                  const Text(
                    "Simulated Floating Widget Controls",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Drag the blue bubble anywhere around the screen to position your assistant!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _floatingX = 20.0;
                        _floatingY = 120.0;
                      });
                    },
                    child: const Text("Reset Floating Bubble Position"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: SCOREBOARD ---
  Widget _buildScoreboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Reclaimed Life Scoreboard",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Card(
                  color: Colors.indigo,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text("Total Money Saved", style: TextStyle(color: Colors.white, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(
                          "\$${_totalMoneySaved.toStringAsFixed(2)}",
                          style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  color: Colors.teal,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text("Hours of Life Saved", style: TextStyle(color: Colors.white, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(
                          "${_hoursSaved.toStringAsFixed(1)} hrs",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Active Streaks & Badges", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.star, color: Colors.white),
                    ),
                    title: Text("$_streakDays Day Savings Streak"),
                    subtitle: const Text("Avoided at least 1 impulse purchase daily"),
                  ),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: Icon(Icons.check, color: Colors.white),
                    ),
                    title: Text("$_decisionsMade Micro-Decisions Resolved"),
                    subtitle: const Text("Zero decision fatigue this week"),
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