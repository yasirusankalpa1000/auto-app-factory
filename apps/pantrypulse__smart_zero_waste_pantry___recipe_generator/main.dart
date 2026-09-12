import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const PantryPulseApp());
}

class PantryPulseApp extends StatelessWidget {
  const PantryPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PantryPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7F6),
      ),
      home: const MainHomeScreen(),
    );
  }
}

// Data Models
class PantryItem {
  final String id;
  String name;
  String category;
  int daysLeft;
  double estimatedValue;

  PantryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.daysLeft,
    required this.estimatedValue,
  });
}

class Recipe {
  final String id;
  final String title;
  final int prepMinutes;
  final List<String> requiredIngredients;
  final List<String> steps;
  final double savedCost;
  final String category;

  Recipe({
    required this.id,
    required this.title,
    required this.prepMinutes,
    required this.requiredIngredients,
    required this.steps,
    required this.savedCost,
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

  // App Metrics State
  double _totalMoneySaved = 42.50;
  int _mealsSavedCount = 5;
  int _streakDays = 4;

  // Active Pantry Items
  final List<PantryItem> _pantryItems = [
    PantryItem(id: '1', name: 'Fresh Eggs', category: 'Dairy & Eggs', daysLeft: 2, estimatedValue: 4.50),
    PantryItem(id: '2', name: 'Cheddar Cheese', category: 'Dairy & Eggs', daysLeft: 1, estimatedValue: 5.00),
    PantryItem(id: '3', name: 'Ripe Tomatoes', category: 'Produce', daysLeft: 2, estimatedValue: 3.20),
    PantryItem(id: '4', name: 'Whole Wheat Bread', category: 'Bakery', daysLeft: 3, estimatedValue: 3.80),
    PantryItem(id: '5', name: 'Penne Pasta', category: 'Pantry', daysLeft: 25, estimatedValue: 2.50),
    PantryItem(id: '6', name: 'Extra Virgin Olive Oil', category: 'Pantry', daysLeft: 60, estimatedValue: 9.00),
  ];

  // Recipe Database
  final List<Recipe> _recipeDatabase = [
    Recipe(
      id: 'r1',
      title: 'Cheesy Tomato Omelet',
      prepMinutes: 10,
      requiredIngredients: ['Fresh Eggs', 'Cheddar Cheese', 'Ripe Tomatoes', 'Extra Virgin Olive Oil'],
      steps: [
        'Crack 3 eggs into a bowl and whisk thoroughly with a pinch of salt.',
        'Dice 1 ripe tomato and shred 50g of cheddar cheese.',
        'Heat 1 tbsp of olive oil in a non-stick skillet over medium heat.',
        'Pour beaten eggs into skillet. Cook for 2 minutes until set near edges.',
        'Add diced tomatoes and cheese on one half, fold over, and cook for 1 minute more.'
      ],
      savedCost: 8.50,
      category: 'Breakfast',
    ),
    Recipe(
      id: 'r2',
      title: 'Crispy Garlic Cheese Toast',
      prepMinutes: 7,
      requiredIngredients: ['Whole Wheat Bread', 'Cheddar Cheese', 'Extra Virgin Olive Oil'],
      steps: [
        'Preheat skillet or toaster oven to medium high heat.',
        'Brush bread slices with olive oil lightly.',
        'Top with generous layer of cheddar cheese.',
        'Toast for 4-5 minutes until cheese is melted and bubbling.'
      ],
      savedCost: 5.00,
      category: 'Snack',
    ),
    Recipe(
      id: 'r3',
      title: 'Rustic Fresh Tomato Pasta',
      prepMinutes: 15,
      requiredIngredients: ['Penne Pasta', 'Ripe Tomatoes', 'Extra Virgin Olive Oil', 'Cheddar Cheese'],
      steps: [
        'Boil pasta in salted water for 10 minutes until al dente.',
        'Heat olive oil in a pan, add chopped tomatoes and saute until soft.',
        'Toss boiled pasta directly into tomato reduction.',
        'Top with grated cheddar cheese before serving hot.'
      ],
      savedCost: 12.00,
      category: 'Dinner',
    ),
  ];

  // Active Cooking Session State
  Recipe? _activeRecipe;
  int _currentCookingStep = 0;
  Timer? _cookingTimer;
  int _timerSecondsRemaining = 0;
  bool _isTimerActive = false;

  @override
  void dispose() {
    _cookingTimer?.cancel();
    super.dispose();
  }

  void _startCookingSession(Recipe recipe) {
    setState(() {
      _activeRecipe = recipe;
      _currentCookingStep = 0;
      _timerSecondsRemaining = recipe.prepMinutes * 60;
      _isTimerActive = false;
      _currentIndex = 2; // Switch to Cooking Station Tab
    });
  }

  void _toggleTimer() {
    if (_isTimerActive) {
      _cookingTimer?.cancel();
      setState(() => _isTimerActive = false);
    } else {
      if (_timerSecondsRemaining <= 0) return;
      setState(() => _isTimerActive = true);
      _cookingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timerSecondsRemaining > 0) {
          setState(() {
            _timerSecondsRemaining--;
          });
        } else {
          timer.cancel();
          setState(() => _isTimerActive = false);
        }
      });
    }
  }

  void _completeRecipeCooking() {
    _cookingTimer?.cancel();
    if (_activeRecipe != null) {
      final savedAmount = _activeRecipe!.savedCost;
      setState(() {
        _totalMoneySaved += savedAmount;
        _mealsSavedCount += 1;
        _isTimerActive = false;
        _activeRecipe = null;
        _currentIndex = 3; // Switch to Impact/Savings screen
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Recipe Completed! Saved \$${savedAmount.toStringAsFixed(2)} from waste!'),
          backgroundColor: Colors.teal,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _addNewItemDialog() {
    final nameController = TextEditingController();
    final valueController = TextEditingController(text: '4.00');
    int daysLeft = 3;
    String selectedCat = 'Produce';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Pantry Item', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Item Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCat,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Produce', 'Dairy & Eggs', 'Bakery', 'Pantry', 'Meat']
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => selectedCat = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text('Spoils in: $daysLeft days', style: const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            if (daysLeft > 1) setDialogState(() => daysLeft--);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => setDialogState(() => daysLeft++),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: valueController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Est. Value (\$)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.trim().isNotEmpty) {
                      final val = double.tryParse(valueController.text.trim()) ?? 3.50;
                      setState(() {
                        _pantryItems.add(PantryItem(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: nameController.text.trim(),
                          category: selectedCat,
                          daysLeft: daysLeft,
                          estimatedValue: val,
                        ));
                      });
                      Navigator.of(ctx).pop();
                    }
                  },
                  child: const Text('Add Item'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildPantryTab(),
      _buildRecipeFinderTab(),
      _buildLiveCookingTab(),
      _buildSavingsTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.kitchen, color: Colors.teal),
            const SizedBox(width: 8),
            const Text(
              'PantryPulse',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '\$$ freedom ${_totalMoneySaved.toStringAsFixed(0)} Saved',
                  style: TextStyle(
                    color: Colors.amber.shade900,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: pages[_currentIndex],
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _addNewItemDialog,
              backgroundColor: Colors.teal,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Pantry Item', style: TextStyle(color: Colors.white)),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.kitchen), label: 'Pantry'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Recipes'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Cook Mode'),
          BottomNavigationBarItem(icon: Icon(Icons.savings), label: 'Impact'),
        ],
      ),
    );
  }

  // --- TAB 1: PANTRY INVENTORY ---
  Widget _buildPantryTab() {
    final urgentItemsCount = _pantryItems.where((i) => i.daysLeft <= 2).length;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header Cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Items', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('${_pantryItems.length}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: urgentItemsCount > 0 ? Colors.red.shade50 : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: urgentItemsCount > 0 ? Colors.red.shade200 : Colors.green.shade200,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Spoiling Soon',
                          style: TextStyle(
                            color: urgentItemsCount > 0 ? Colors.red.shade700 : Colors.green.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$urgentItemsCount items',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: urgentItemsCount > 0 ? Colors.red.shade900 : Colors.green.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              'Current Inventory',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            if (_pantryItems.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                child: const Text('Your pantry is empty! Tap + to add items.', style: TextStyle(color: Colors.grey)),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _pantryItems.length,
                itemBuilder: (context, index) {
                  final item = _pantryItems[index];
                  Color badgeColor = Colors.green;
                  String badgeText = '${item.daysLeft}d left';

                  if (item.daysLeft <= 1) {
                    badgeColor = Colors.red;
                    badgeText = 'Spoils Today!';
                  } else if (item.daysLeft <= 3) {
                    badgeColor = Colors.orange;
                    badgeText = '${item.daysLeft}d urgency';
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                    color: Colors.white,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.shade50,
                        child: Icon(_getCategoryIcon(item.category), color: Colors.teal),
                      ),
                      title: Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text('${item.category} • Est value: \$${item.estimatedValue.toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: badgeColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              badgeText,
                              style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                            onPressed: () {
                              setState(() {
                                _pantryItems.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  // --- TAB 2: SMART RECIPE FINDER ---
  Widget _buildRecipeFinderTab() {
    final availableNames = _pantryItems.map((i) => i.name.toLowerCase()).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade700, Colors.teal.shade500],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.amber, size: 32),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Zero-Waste Engine matches recipes using ingredients you ALREADY own!',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Matched Meals from Pantry',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recipeDatabase.length,
              itemBuilder: (context, index) {
                final recipe = _recipeDatabase[index];

                // Calculate ingredient match percentage
                int matchedCount = 0;
                for (var req in recipe.requiredIngredients) {
                  if (availableNames.any((p) => p.contains(req.toLowerCase()) || req.toLowerCase().contains(p))) {
                    matchedCount++;
                  }
                }
                final matchPercent = ((matchedCount / recipe.requiredIngredients.length) * 100).round();

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 1,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                recipe.title,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: matchPercent >= 75 ? Colors.green.shade100 : Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$matchPercent% Match',
                                style: TextStyle(
                                  color: matchPercent >= 75 ? Colors.green.shade900 : Colors.orange.shade900,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text('${recipe.prepMinutes} mins prep', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                            const SizedBox(width: 16),
                            const Icon(Icons.savings_outlined, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text('Saves \$${recipe.savedCost.toStringAsFixed(2)}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text('Required:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAxisAlignment.center,
                          children: recipe.requiredIngredients.map((ing) {
                            final hasIt = availableNames.any((p) => p.contains(ing.toLowerCase()) || ing.toLowerCase().contains(p));
                            return Chip(
                              padding: EdgeInsets.zero,
                              labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                              backgroundColor: hasIt ? Colors.teal.shade50 : Colors.grey.shade100,
                              avatar: Icon(
                                hasIt ? Icons.check_circle : Icons.error_outline,
                                size: 14,
                                color: hasIt ? Colors.teal : Colors.grey,
                              ),
                              label: Text(
                                ing,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: hasIt ? Colors.teal.shade900 : Colors.grey.shade700,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () => _startCookingSession(recipe),
                            icon: const Icon(Icons.play_arrow, color: Colors.white),
                            label: const Text('Start Live Cooking Session', style: TextStyle(color: Colors.white)),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 3: LIVE COOKING STATION ---
  Widget _buildLiveCookingTab() {
    if (_activeRecipe == null) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No Active Cooking Session',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Select a recipe from the Recipes tab to initiate guided step-by-step cooking & timer mode.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () => setState(() => _currentIndex = 1),
                  child: const Text('Browse Pantry Recipes', style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        ),
      );
    }

    final recipe = _activeRecipe!;
    final minutes = (_timerSecondsRemaining / 60).floor();
    final seconds = _timerSecondsRemaining % 60;
    final timerString = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.restaurant, color: Colors.teal),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          recipe.title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Big Interactive Timer
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          timerString,
                          style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _toggleTimer,
                              icon: Icon(_isTimerActive ? Icons.pause : Icons.play_arrow),
                              label: Text(_isTimerActive ? 'Pause Timer' : 'Start Timer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _timerSecondsRemaining = recipe.prepMinutes * 60;
                                  _isTimerActive = false;
                                  _cookingTimer?.cancel();
                                });
                              },
                              child: const Text('Reset'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Step-by-Step Instructions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recipe.steps.length,
              itemBuilder: (context, index) {
                final isCurrent = index == _currentCookingStep;
                return GestureDetector(
                  onTap: () => setState(() => _currentCookingStep = index),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    color: isCurrent ? Colors.teal.shade50 : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isCurrent ? Colors.teal : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: isCurrent ? Colors.teal : Colors.grey.shade300,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: isCurrent ? Colors.white : Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              recipe.steps[index],
                              style: TextStyle(
                                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                color: isCurrent ? Colors.teal.shade900 : Colors.black87,
                              ),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _completeRecipeCooking,
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text(
                  'Finish Meal & Save Waste!',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- TAB 4: SAVINGS & IMPACT DASHBOARD ---
  Widget _buildSavingsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Waste Prevention Impact',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Main Stat Cards Grid
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade700,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.monetization_on, color: Colors.amber, size: 28),
                        const SizedBox(height: 8),
                        const Text('Total Money Saved', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(
                          '\$$ freedom ${_totalMoneySaved.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.eco, color: Colors.green, size: 28),
                        const SizedBox(height: 8),
                        const Text('Meals Rescued', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(
                          '$_mealsSavedCount meals',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Streak & Goal Progress Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.local_fire_department, color: Colors.orange),
                          const SizedBox(width: 6),
                          Text('$_streakDays Day Zero-Waste Streak!', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Text('Monthly Goal: \$100', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: (_totalMoneySaved / 100).clamp(0.0, 1.0),
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.teal,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You are ${((_totalMoneySaved / 100) * 100).round()}% towards your monthly food waste reduction budget target!',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Pantry Efficiency Tips',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _buildTipCard(
              'Store Herbs Properly',
              'Keep fresh cilantro and parsley in a small glass of water in fridge to double their lifespan.',
            ),
            _buildTipCard(
              'First In, First Out (FIFO)',
              'Always move older groceries to the front shelf when adding fresh items.',
            ),
            _buildTipCard(
              'Freeze Expiring Bread',
              'Sliced bread freezes exceptionally well and can be toasted directly from frozen.',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(String title, String desc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        leading: const Icon(Icons.lightbulb_outline, color: Colors.teal),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(desc, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Produce':
        return Icons.eco;
      case 'Dairy & Eggs':
        return Icons.egg_outlined;
      case 'Bakery':
        return Icons.bakery_dining;
      case 'Pantry':
        return Icons.kitchen;
      case 'Meat':
        return Icons.set_meal;
      default:
        return Icons.shopping_bag;
    }
  }
}