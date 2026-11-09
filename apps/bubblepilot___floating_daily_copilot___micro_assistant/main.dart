import 'package:flutter/material.dart';

void main() {
  runApp(const BubblePilotApp());
}

class BubblePilotApp extends StatelessWidget {
  const BubblePilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BubblePilot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
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
  int _selectedIndex = 0;
  bool _isFloatingOverlayActive = true;
  Offset _bubblePosition = const Offset(20, 120);

  // App State Data
  String _activeContext = 'Work Mode';
  int _dailyDecisionsCount = 14;
  double _savedAmount = 145.50;
  int _streakDays = 5;

  // Impulse Calculator Controllers
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _hourlyWageController = TextEditingController();
  double _calculatedHours = 0.0;
  String _purchaseVerdict = '';

  // Decision Tool State
  final TextEditingController _dilemmaController = TextEditingController();
  final List<String> _dilemmaOptions = ['Option A', 'Option B'];
  final TextEditingController _newOptionController = TextEditingController();
  String _chosenOption = '';
  bool _isSpinning = false;

  // Anti-Procrastination Micro Task Generator
  final TextEditingController _bigTaskController = TextEditingController();
  List<String> _generatedMicroSteps = [];

  // Scratchpad Data
  final TextEditingController _noteInputController = TextEditingController();
  final List<Map<String, dynamic>> _notes = [
    {
      'id': '1',
      'title': 'Compare grocery unit prices',
      'category': 'Shopping Mode',
      'completed': false,
      'time': '10:30 AM'
    },
    {
      'id': '2',
      'title': 'Send 1-page update to client',
      'category': 'Work Mode',
      'completed': true,
      'time': '09:15 AM'
    },
    {
      'id': '3',
      'title': 'Check flight luggage limits',
      'category': 'Travel Mode',
      'completed': false,
      'time': 'Yesterday'
    },
  ];

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemPriceController.dispose();
    _hourlyWageController.dispose();
    _dilemmaController.dispose();
    _newOptionController.dispose();
    _bigTaskController.dispose();
    _noteInputController.dispose();
    super.dispose();
  }

  void _calculateImpulseCost() {
    final double price = double.tryParse(_itemPriceController.text) ?? 0.0;
    final double wage = double.tryParse(_hourlyWageController.text) ?? 0.0;

    if (price <= 0 || wage <= 0) {
      setState(() {
        _calculatedHours = 0.0;
        _purchaseVerdict = 'Please enter valid numbers.';
      });
      return;
    }

    final double hours = price / wage;
    String verdict = '';
    if (hours > 20) {
      verdict = '🛑 HIGH RISK: Costs over 20 hours of labor! Sleep on it for 48 hours.';
    } else if (hours > 5) {
      verdict = '⚠️ MODERATE: Costs $hours hours of work. Wait 24 hours before buying.';
    } else {
      verdict = '✅ LOW IMPACT: Costs under 5 hours of work. Fits budget safe zone.';
    }

    setState(() {
      _calculatedHours = hours;
      _purchaseVerdict = verdict;
    });
  }

  void _generateMicroSteps() {
    final task = _bigTaskController.text.trim();
    if (task.isEmpty) return;

    setState(() {
      _generatedMicroSteps = [
        '1️⃣ Spend 60 seconds gathering materials for "$task"',
        '2️⃣ Write down just 3 key outcome bullet points',
        '3️⃣ Set a 5-minute initial timer and start step 1 now',
      ];
    });
  }

  void _pickRandomDecision() {
    if (_dilemmaOptions.isEmpty) return;
    setState(() {
      _isSpinning = true;
      _chosenOption = 'Analyzing options...';
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() {
        _isSpinning = false;
        _dilemmaOptions.shuffle();
        _chosenOption = _dilemmaOptions.first;
        _dailyDecisionsCount++;
      });
    });
  }

  void _addScratchNote() {
    final text = _noteInputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _notes.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': text,
        'category': _activeContext,
        'completed': false,
        'time': 'Just now',
      });
      _noteInputController.clear();
    });
  }

  void _showOverlay QuickToolsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.bolt, color: Colors.indigo),
                          SizedBox(width: 8),
                          Text(
                            'Floating Quick Assistant',
                            style: TextStyle(
                              fontSize: 18,
                              FontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    'Active Mode Switcher',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Work Mode',
                      'Shopping Mode',
                      'Focus Mode',
                      'Travel Mode'
                    ].map((mode) {
                      final isSelected = _activeContext == mode;
                      return ChoiceChip(
                        label: Text(mode),
                        selected: isSelected,
                        selectedColor: Colors.indigo.withOpacity(0.2),
                        onSelected: (val) {
                          if (val) {
                            setState(() => _activeContext = mode);
                            Navigator.pop(ctx);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Quick Action Scratchpad',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _noteInputController,
                          decoration: const InputDecoration(
                            hintText: 'Quick memo, code, or buy item...',
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          _addScratchNote();
                          Navigator.pop(ctx);
                        },
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.widgets, color: Colors.indigo),
            SizedBox(width: 8),
            Text(
              'BubblePilot',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFloatingOverlayActive
                  ? Icons.notifications_active
                  : Icons.notifications_off,
              color: _isFloatingOverlayActive ? Colors.indigo : Colors.grey,
            ),
            tooltip: 'Toggle Floating Copilot Overlay',
            onPressed: () {
              setState(() {
                _isFloatingOverlayActive = !_isFloatingOverlayActive;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isFloatingOverlayActive
                        ? 'Floating Overlay Simulator Activated!'
                        : 'Floating Overlay Deactivated.',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main Body Tabs
          SafeArea(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildContextHubTab(),
                _buildImpulseEvaluatorTab(),
                _buildDecisionToolsTab(),
                _buildScratchpadTab(),
              ],
            ),
          ),

          // Simulated Interactive Floating Copilot Bubble Overlay
          if (_isFloatingOverlayActive)
            Positioned(
              left: _bubblePosition.dx.clamp(0, screenSize.width - 70),
              top: _bubblePosition.dy.clamp(0, screenSize.height - 180),
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubblePosition += details.delta;
                  });
                },
                onTap: _showOverlay QuickToolsModal,
                child: Material(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Colors.indigo,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bolt, color: Colors.amber, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          _activeContext.split(' ').first,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.open_in_full,
                            color: Colors.white70, size: 14),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_max),
            label: 'Hub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Impulse Check',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Decisions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: 'Scratchpad',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: CONTEXT HUB & DASHBOARD ---
  Widget _buildContextHubTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dynamic Active Mode Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.indigo, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'ACTIVE CONTEXT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.stars, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '$_streakDays Day Streak',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _activeContext,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Floating Copilot active. Micro-tools optimized for your context.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Daily Stats Quick Overview
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Decisions Simplified',
                  value: '$_dailyDecisionsCount',
                  icon: Icons.calculate,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: 'Impulse Money Saved',
                  value: '\$${_savedAmount.toStringAsFixed(2)}',
                  icon: Icons.attach_money,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const Text(
            'Context Switcher',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Context Switcher Grid
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildContextTile('Work Mode', Icons.work, Colors.blue),
              _buildContextTile(
                  'Shopping Mode', Icons.shopping_bag, Colors.orange),
              _buildContextTile(
                  'Focus Mode', Icons.center_focus_strong, Colors.purple),
              _buildContextTile('Travel Mode', Icons.explore, Colors.teal),
            ],
          ),
          const SizedBox(height: 20),

          // Quick Action Cards
          const Text(
            'Instant Micro-Tools',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading:
                  const CircleAvatar(backgroundColor: Color(0xFFE8EAF6), child: Icon(Icons.bolt, color: Colors.indigo)),
              title: const Text('Floating Overlay Status'),
              subtitle: Text(
                  _isFloatingOverlayActive ? 'Enabled & Draggable' : 'Disabled'),
              trailing: Switch(
                value: _isFloatingOverlayActive,
                onChanged: (val) {
                  setState(() => _isFloatingOverlayActive = val);
                },
              ),
            ),
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFF3E0),
                  child: Icon(Icons.monetization_on, color: Colors.orange)),
              title: const Text('Impulse Buy Time-Cost Calculator'),
              subtitle:
                  const Text('Evaluate if an item is worth your work hours'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => setState(() => _selectedIndex = 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          FittedBox(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            softWrap: true,
          ),
        ],
      ),
    );
  }

  Widget _buildContextTile(String mode, IconData icon, Color color) {
    final bool isSelected = _activeContext == mode;
    return GestureDetector(
      onTap: () => setState(() => _activeContext = mode),
      child: Container(
        width: 160,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.12) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                mode,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? color : Colors.black87,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 2: IMPULSE BUY & VALUE EVALUATOR ---
  Widget _buildImpulseEvaluatorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Impulse Buy Time-Cost Evaluator',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Stop unnecessary spending by calculating how many actual labor hours an item costs you.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Input Form
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _itemNameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    hintText: 'e.g. Wireless Headphones',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.shopping_bag),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _itemPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Item Price (\$)',
                    hintText: 'e.g. 150',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _hourlyWageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Your Net Hourly Wage (\$)',
                    hintText: 'e.g. 25',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.schedule),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _calculateImpulseCost,
                    child: const Text(
                      'Evaluate Value vs Work Hours',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Result Card
          if (_calculatedHours > 0 || _purchaseVerdict.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Evaluation Result',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.timer, color: Colors.indigo, size: 36),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_calculatedHours.toStringAsFixed(1)} Labor Hours Required',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Work hours dedicated solely to this single item.',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Text(
                    _purchaseVerdict,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.check),
                    label: const Text('Decided Not To Buy (Save Money)'),
                    onPressed: () {
                      final double saved =
                          double.tryParse(_itemPriceController.text) ?? 0.0;
                      setState(() {
                        _savedAmount += saved;
                        _itemPriceController.clear();
                        _itemNameController.clear();
                        _calculatedHours = 0.0;
                        _purchaseVerdict =
                            'Great decision! \$${saved.toStringAsFixed(2)} added to your saved score!';
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

  // --- TAB 3: DECISION TOOLS & MICRO-STEP GENERATOR ---
  Widget _buildDecisionToolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Decision Eliminator',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Stuck choosing between options? Let BubblePilot break decision fatigue.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Option Picker Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Dilemma Options',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _newOptionController,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Order Salad vs Cook Pasta',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        final val = _newOptionController.text.trim();
                        if (val.isNotEmpty) {
                          setState(() {
                            _dilemmaOptions.add(val);
                            _newOptionController.clear();
                          });
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _dilemmaOptions.map((opt) {
                    return Chip(
                      label: Text(opt),
                      onDeleted: () {
                        setState(() {
                          _dilemmaOptions.remove(opt);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    icon: _isSpinning
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.casino),
                    label: const Text('Eliminate & Decide For Me'),
                    onPressed: _isSpinning ? null : _pickRandomDecision,
                  ),
                ),
                if (_chosenOption.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Verdict: $_chosenOption',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Procrastination 1-Min Step Builder
          const Text(
            '1-Minute Anti-Procrastination Builder',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Break heavy tasks down into 3 immediate micro-steps.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _bigTaskController,
                  decoration: const InputDecoration(
                    labelText: 'What task are you delaying?',
                    hintText: 'e.g. Clean garage, write report...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.bolt),
                    label: const Text('Generate 1-Min Micro Steps'),
                    onPressed: _generateMicroSteps,
                  ),
                ),
                if (_generatedMicroSteps.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Column(
                    children: _generatedMicroSteps
                        .map((step) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle_outline,
                                      color: Colors.teal, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      step,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  )
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: QUICK SCRATCHPAD & CONTEXT LOGS ---
  Widget _buildScratchpadTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Context Scratchpad',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Quick capture micro-notes in $_activeContext mode',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 14),

          // Add Note Field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _noteInputController,
                  decoration: const InputDecoration(
                    hintText: 'Add instant note or scratch item...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(14),
                ),
                onPressed: _addScratchNote,
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Notes List
          Expanded(
            child: _notes.isEmpty
                ? const Center(
                    child: Text(
                      'No scratchpad notes yet. Add one above!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (ctx, index) {
                      final item = _notes[index];
                      final bool isDone = item['completed'] as bool;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: isDone,
                            onChanged: (val) {
                              setState(() {
                                item['completed'] = val;
                              });
                            },
                          ),
                          title: Text(
                            item['title'].toString(),
                            style: TextStyle(
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: isDone ? Colors.grey : Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            '${item['category']} • ${item['time']}',
                            style: const TextStyle(fontSize: 11),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _notes.removeAt(index);
                              });
                            },
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
}