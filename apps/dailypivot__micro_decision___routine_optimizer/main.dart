import 'package:flutter/material.dart';

void main() {
  runApp(const DailyPivotApp());
}

class DailyPivotApp extends StatelessWidget {
  const DailyPivotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DailyPivot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // State: Decision Solver
  final TextEditingController _decisionInputController = TextEditingController();
  final List<String> _decisionOptions = ['Healthy Salad', 'Quick Pasta', 'Homemade Sandwich'];
  String _selectedDecision = '';
  String _decisionRationale = '';

  // State: Impulse Shield
  final TextEditingController _hourlyWageController = TextEditingController(text: '20.00');
  final TextEditingController _itemTitleController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final List<Map<String, dynamic>> _coolOffItems = [
    {
      'title': 'Wireless Earbuds',
      'price': 49.99,
      'hours': 2.5,
      'status': 'Cooling Off',
      'saved': false
    },
    {
      'title': 'Gaming Mouse',
      'price': 75.00,
      'hours': 3.75,
      'status': 'Skipped & Saved',
      'saved': true
    },
  ];

  // State: Pantry Chef
  final List<String> _allIngredients = [
    'Eggs', 'Rice', 'Tomatoes', 'Pasta', 'Potatoes',
    'Cheese', 'Bread', 'Chicken', 'Milk', 'Garlic', 'Onion', 'Beans'
  ];
  final Set<String> _selectedIngredients = {'Eggs', 'Bread', 'Cheese'};

  // State: Micro-Pacer Timer
  int _pacerSecondsLeft = 900; // 15 mins
  bool _isPacerRunning = false;
  int _sprintsCompletedToday = 3;
  final List<Map<String, dynamic>> _pacerTasks = [
    {'title': 'Clear Desk & Workstation', 'done': true},
    {'title': 'Process Urgent Inboxes', 'done': true},
    {'title': 'Organize Daily Priorities', 'done': false},
    {'title': 'Drink 500ml Water', 'done': false},
  ];

  void _solveDecision() {
    if (_decisionOptions.isEmpty) return;
    final random = DateTime.now().millisecondsSinceEpoch % _decisionOptions.length;
    setState(() {
      _selectedDecision = _decisionOptions[random];
      final rationales = [
        "Optimal energy-to-friction ratio for right now.",
        "Reduces stress and clears mental space for your next activity.",
        "High efficiency choice based on minimal setup time.",
        "Best balance of daily utility and personal enjoyment."
      ];
      _decisionRationale = rationales[random % rationales.length];
    });
  }

  void _addDecisionOption() {
    final text = _decisionInputController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _decisionOptions.add(text);
        _decisionInputController.clear();
      });
    }
  }

  void _addImpulseItem() {
    final title = _itemTitleController.text.trim();
    final price = double.tryParse(_itemPriceController.text.trim()) ?? 0.0;
    final wage = double.tryParse(_hourlyWageController.text.trim()) ?? 20.0;

    if (title.isNotEmpty && price > 0 && wage > 0) {
      final hoursNeeded = price / wage;
      setState(() {
        _coolOffItems.insert(0, {
          'title': title,
          'price': price,
          'hours': hoursNeeded,
          'status': 'Cooling Off',
          'saved': false,
        });
        _itemTitleController.clear();
        _itemPriceController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added "$title" to Cool-Off Tank! Costs ${hoursNeeded.toStringAsFixed(1)} hrs of labor.'),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  double _calculateTotalSaved() {
    double total = 0.0;
    for (var item in _coolOffItems) {
      if (item['saved'] == true) {
        total += (item['price'] as double);
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.flash_on, color: Colors.tealAccent),
            const SizedBox(width: 8),
            const Text(
              'DailyPivot',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Chip(
              avatar: const Icon(Icons.monetization_on, color: Colors.amber, size: 18),
              label: Text(
                'Saved \$${_calculateTotalSaved().toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
              ),
              backgroundColor: const Color(0xFF334155),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildDecisionTab(),
            _buildImpulseTab(),
            _buildPantryTab(),
            _buildPacerTab(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Decide',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Impulse Shield',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Pantry Chef',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Micro-Pacer',
          ),
        ],
      ),
    );
  }

  // TAB 1: DECISION SOLVER
  Widget _buildDecisionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Decision Fatigue Resolver',
            style: TextStyle(fontSize: 22, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Stuck choosing? Add your options and let DailyPivot calculate the ideal action.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _decisionInputController,
                          decoration: const InputDecoration(
                            labelText: 'Add Option (e.g. Order Salad)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onSubmitted: (_) => _addDecisionOption(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addDecisionOption,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Current Options Pool:',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: _decisionOptions.map((opt) {
                      return Chip(
                        label: Text(opt),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setState(() {
                            _decisionOptions.remove(opt);
                          });
                        },
                        backgroundColor: const Color(0xFF334155),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _decisionOptions.isNotEmpty ? _solveDecision : null,
                      icon: const Icon(Icons.flash_on, color: Colors.black),
                      label: const Text(
                        'PIVOT & CHOOSE NOW',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (_selectedDecision.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A).withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blueAccent, width: 1.5),
              ),
              child: Column(
                children: [
                  const Text(
                    'RECOMMENDED ACTION',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedDecision,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      FontWeight: FontWeight.bold,
                      color: Colors.tealAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _decisionRationale,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // TAB 2: IMPULSE SHIELD & LABOR CONVERTER
  Widget _buildImpulseTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Impulse Purchase Shield',
            style: TextStyle(fontSize: 22, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Convert prices into actual hours of work needed, then cool-off before buying.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _hourlyWageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Your Hourly Net Wage (\$)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _itemTitleController,
                          decoration: const InputDecoration(
                            labelText: 'Item Name',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: _itemPriceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price (\$)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _addImpulseItem,
                      icon: const Icon(Icons.shield, color: Colors.white),
                      label: const Text(
                        'Calculate Work-Hours & Cool Off',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Cool-Off Tank & Savings Log',
            style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _coolOffItems.length,
            itemBuilder: (context, index) {
              final item = _coolOffItems[index];
              final isSaved = item['saved'] == true;
              return Card(
                color: isSaved ? const Color(0xFF14532D) : const Color(0xFF1E293B),
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSaved ? Colors.green.shade800 : Colors.teal.shade900,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isSaved ? Icons.check_circle : Icons.schedule,
                          color: isSaved ? Colors.greenAccent : Colors.tealAccent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Cost: \$${(item['price'] as double).toStringAsFixed(2)} = ${(item['hours'] as double).toStringAsFixed(1)} Hours Labor',
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (!isSaved)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              item['saved'] = true;
                              item['status'] = 'Skipped & Saved';
                            });
                          },
                          child: const Text(
                            'Skip & Save',
                            style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
                          ),
                        )
                      else
                        const Chip(
                          label: Text(
                            'Saved!',
                            style: TextStyle(color: Colors.greenAccent, fontSize: 12),
                          ),
                          backgroundColor: Color(0xFF064E3B),
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

  // TAB 3: PANTRY CHEF
  Widget _buildPantryTab() {
    final availableRecipes = [
      {
        'name': 'Scrambled Egg Toast Bake',
        'time': '8 mins',
        'saved': '\$12.50 vs takeout',
        'req': ['Eggs', 'Bread', 'Cheese'],
        'steps': 'Whisk eggs, toast bread slice, top with cheese & scramble on pan for 4 mins.'
      },
      {
        'name': 'Crispy Garlic Rice Bowl',
        'time': '10 mins',
        'saved': '\$14.00 vs takeout',
        'req': ['Rice', 'Garlic', 'Eggs'],
        'steps': 'Sauté garlic, add cooked rice, fried egg on top with dash of soy sauce.'
      },
      {
        'name': 'Cheesy Potato Hash',
        'time': '12 mins',
        'saved': '\$10.00 vs takeout',
        'req': ['Potatoes', 'Cheese', 'Onion'],
        'steps': 'Dice potatoes thin, fry with onions till crispy, melt cheese over top.'
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Zero-Waste Pantry Chef',
            style: TextStyle(fontSize: 22, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Select ingredients sitting in your kitchen right now to cook instant low-cost meals.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tap Available Ingredients:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 6.0,
            children: _allIngredients.map((ing) {
              final isSelected = _selectedIngredients.contains(ing);
              return FilterChip(
                label: Text(ing),
                selected: isSelected,
                selectedColor: Colors.teal,
                checkmarkColor: Colors.white,
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      _selectedIngredients.add(ing);
                    } else {
                      _selectedIngredients.remove(ing);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            'Matching Instant Meals:',
            style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: availableRecipes.length,
            itemBuilder: (context, index) {
              final recipe = availableRecipes[index];
              final reqList = recipe['req'] as List<String>;
              final matchCount = reqList.where((r) => _selectedIngredients.contains(r)).length;

              return Card(
                color: const Color(0xFF1E293B),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                              recipe['name'] as String,
                              style: const TextStyle(
                                fontSize: 17,
                                FontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade900,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Save ${recipe['saved']}',
                              style: const TextStyle(
                                color: Colors.tealAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            recipe['time'] as String,
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.check_circle_outline, size: 14, color: Colors.tealAccent),
                          const SizedBox(width: 4),
                          Text(
                            '$matchCount / ${reqList.length} Ingredients Ready',
                            style: const TextStyle(color: Colors.tealAccent, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Steps: ${recipe['steps']}',
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
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

  // TAB 4: MICRO-PACER
  Widget _buildPacerTab() {
    final minutes = (_pacerSecondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_pacerSecondsLeft % 60).toString().padLeft(2, '0');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '15-Minute Micro-Pacer',
            style: TextStyle(fontSize: 22, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Beat procrastination with micro-burst focus sprints. Execute fast, then move on.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.teal.withOpacity(0.5), width: 1),
            ),
            child: Column(
              children: [
                Text(
                  '$minutes:$seconds',
                  style: const TextStyle(
                    fontSize: 54,
                    FontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 42,
                      icon: Icon(
                        _isPacerRunning ? Icons.pause_circle_filled : Icons.play_circle_filled,
                        color: Colors.tealAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPacerRunning = !_isPacerRunning;
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      iconSize: 32,
                      icon: const Icon(Icons.refresh, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _pacerSecondsLeft = 900;
                          _isPacerRunning = false;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sprint Micro-Tasks:',
                style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.white),
              ),
              Chip(
                label: Text('Streak: $_sprintsCompletedToday Sprints Done'),
                backgroundColor: const Color(0xFF334155),
                labelStyle: const TextStyle(fontSize: 12, color: Colors.amber, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _pacerTasks.length,
            itemBuilder: (context, index) {
              final task = _pacerTasks[index];
              return Card(
                color: const Color(0xFF1E293B),
                margin: const EdgeInsets.only(bottom: 8),
                child: CheckboxListTile(
                  activeColor: Colors.teal,
                  value: task['done'] as bool,
                  title: Text(
                    task['title'] as String,
                    style: TextStyle(
                      color: (task['done'] as bool) ? Colors.grey : Colors.white,
                      decoration: (task['done'] as bool) ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      task['done'] = val;
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}