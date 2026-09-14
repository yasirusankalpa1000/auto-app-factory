import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const PantryCraftApp());
}

class PantryCraftApp extends StatelessWidget {
  const PantryCraftApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PantryCraft',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F9FA),
      ),
      home: const MainScreen(),
    );
  }
}

class PantryItem {
  final String id;
  final String name;
  final String category;
  bool isAvailable;

  PantryItem({
    required this.id,
    required this.name,
    required this.category,
    this.isAvailable = true,
  });
}

class CookingStep {
  final String title;
  final String description;
  final int durationSeconds;

  CookingStep({
    required this.title,
    required this.description,
    required this.durationSeconds,
  });
}

class Recipe {
  final String id;
  final String title;
  final String category;
  final int prepTimeMinutes;
  final double estimatedSavings;
  final List<String> requiredIngredients;
  final List<CookingStep> steps;

  Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.prepTimeMinutes,
    required this.estimatedSavings,
    required this.requiredIngredients,
    required this.steps,
  });
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Master Pantry State
  final List<PantryItem> _pantryItems = [
    PantryItem(id: '1', name: 'Eggs', category: 'Protein', isAvailable: true),
    PantryItem(id: '2', name: 'Rice', category: 'Grains', isAvailable: true),
    PantryItem(id: '3', name: 'Garlic', category: 'Produce', isAvailable: true),
    PantryItem(id: '4', name: 'Onion', category: 'Produce', isAvailable: true),
    PantryItem(id: '5', name: 'Tomatoes', category: 'Produce', isAvailable: true),
    PantryItem(id: '6', name: 'Pasta', category: 'Grains', isAvailable: true),
    PantryItem(id: '7', name: 'Cheese', category: 'Dairy', isAvailable: true),
    PantryItem(id: '8', name: 'Chicken Breast', category: 'Protein', isAvailable: false),
    PantryItem(id: '9', name: 'Bread', category: 'Bakery', isAvailable: true),
    PantryItem(id: '10', name: 'Butter', category: 'Dairy', isAvailable: true),
    PantryItem(id: '11', name: 'Soy Sauce', category: 'Condiments', isAvailable: true),
    PantryItem(id: '12', name: 'Potatoes', category: 'Produce', isAvailable: true),
  ];

  // Master Recipes List
  late List<Recipe> _recipes;

  // Active Cooking Session State
  Recipe? _activeRecipe;
  int _activeStepIndex = 0;
  int _stepTimerSeconds = 0;
  bool _isTimerActive = false;
  Timer? _timer;

  // Savings & Engagement Metrics
  double _totalDollarsSaved = 64.50;
  int _mealsCookedCount = 5;
  int _streakDays = 4;
  final List<String> _recentActivityLog = [
    "Cooked Golden Garlic Fried Rice - Saved \$12.50",
    "Cooked Cheesy Omelet Toast - Saved \$8.00",
    "Cooked One-Pot Tomato Pasta - Saved \$14.00",
    "Cooked Rustic Crispy Skillet - Saved \$10.00",
  ];

  @override
  void initState() {
    super.initState();
    _initRecipes();
  }

  void _initRecipes() {
    _recipes = [
      Recipe(
        id: 'r1',
        title: 'Golden Garlic Fried Rice',
        category: 'Quick Comfort',
        prepTimeMinutes: 12,
        estimatedSavings: 12.50,
        requiredIngredients: ['Rice', 'Eggs', 'Garlic', 'Soy Sauce', 'Butter'],
        steps: [
          CookingStep(
            title: 'Prep Garlic & Eggs',
            description: 'Mince 3 garlic cloves and beat 2 eggs in a small bowl with a pinch of salt.',
            durationSeconds: 120,
          ),
          CookingStep(
            title: 'Sauté Garlic',
            description: 'Melt 1 tbsp butter in pan over medium heat. Sauté minced garlic until golden brown.',
            durationSeconds: 180,
          ),
          CookingStep(
            title: 'Scramble Eggs & Fry Rice',
            description: 'Push garlic to side, scramble eggs, then toss in cooked rice and soy sauce on high heat.',
            durationSeconds: 300,
          ),
          CookingStep(
            title: 'Garnish & Plate',
            description: 'Toss thoroughly for 1 minute until fragrant. Serve piping hot!',
            durationSeconds: 60,
          ),
        ],
      ),
      Recipe(
        id: 'r2',
        title: 'Cheesy Garlic Omelet Toast',
        category: 'Breakfast / Snack',
        prepTimeMinutes: 10,
        estimatedSavings: 8.50,
        requiredIngredients: ['Bread', 'Eggs', 'Cheese', 'Butter', 'Garlic'],
        steps: [
          CookingStep(
            title: 'Toast & Garlic Rub',
            description: 'Toast bread slices in skillet with butter. Gently rub a raw garlic clove over warm toast.',
            durationSeconds: 180,
          ),
          CookingStep(
            title: 'Whisk & Pour Eggs',
            description: 'Beat 2 eggs with salt/pepper. Pour into buttered pan over medium-low heat.',
            durationSeconds: 120,
          ),
          CookingStep(
            title: 'Melt Cheese & Fold',
            description: 'Add shredded cheese to egg center just before setting. Fold sides into a tender pocket.',
            durationSeconds: 180,
          ),
          CookingStep(
            title: 'Assemble',
            description: 'Place warm cheesy omelet over garlic toast and slice diagonally.',
            durationSeconds: 60,
          ),
        ],
      ),
      Recipe(
        id: 'r3',
        title: 'One-Pot Creamy Tomato Pasta',
        category: 'Hearty Dinner',
        prepTimeMinutes: 18,
        estimatedSavings: 15.00,
        requiredIngredients: ['Pasta', 'Tomatoes', 'Garlic', 'Onion', 'Cheese', 'Butter'],
        steps: [
          CookingStep(
            title: 'Dice & Sauté Base',
            description: 'Finely dice onions, tomatoes, and garlic. Sauté in butter until soft and aromatic.',
            durationSeconds: 300,
          ),
          CookingStep(
            title: 'Boil Pasta in Sauce',
            description: 'Add dry pasta directly into pan with 2 cups salted water and tomatoes. Simmer.',
            durationSeconds: 600,
          ),
          CookingStep(
            title: 'Melt Cheese & Reduce',
            description: 'Stir in cheese until rich sauce forms and coats pasta evenly.',
            durationSeconds: 180,
          ),
        ],
      ),
      Recipe(
        id: 'r4',
        title: 'Rustic Crispy Potato Skillet',
        category: 'Comfort Snack',
        prepTimeMinutes: 15,
        estimatedSavings: 9.50,
        requiredIngredients: ['Potatoes', 'Onion', 'Butter', 'Cheese'],
        steps: [
          CookingStep(
            title: 'Thinly Slice Potatoes',
            description: 'Slice potatoes thinly for faster, crisper cooking. Chop onions.',
            durationSeconds: 240,
          ),
          CookingStep(
            title: 'Pan-Fry Potatoes',
            description: 'Cook potato slices in hot butter undisturbed for 5 mins to form a crispy golden crust.',
            durationSeconds: 420,
          ),
          CookingStep(
            title: 'Add Onions & Melt Cheese',
            description: 'Flip potatoes, add onions and sprinkle cheese on top. Cover pan for 3 minutes.',
            durationSeconds: 240,
          ),
        ],
      ),
    ];
  }

  void _startCookingRecipe(Recipe recipe) {
    setState(() {
      _activeRecipe = recipe;
      _activeStepIndex = 0;
      _stepTimerSeconds = recipe.steps[0].durationSeconds;
      _currentIndex = 2; // Switch to Cooking Timer tab
    });
  }

  void _toggleStepTimer() {
    if (_isTimerActive) {
      _timer?.cancel();
      setState(() {
        _isTimerActive = false;
      });
    } else {
      setState(() {
        _isTimerActive = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_stepTimerSeconds > 0) {
          setState(() {
            _stepTimerSeconds--;
          });
        } else {
          timer.cancel();
          setState(() {
            _isTimerActive = false;
          });
        }
      });
    }
  }

  void _nextStep() {
    if (_activeRecipe == null) return;
    _timer?.cancel();
    if (_activeStepIndex < _activeRecipe!.steps.length - 1) {
      setState(() {
        _activeStepIndex++;
        _stepTimerSeconds = _activeRecipe!.steps[_activeStepIndex].durationSeconds;
        _isTimerActive = false;
      });
    } else {
      _finishMeal();
    }
  }

  void _previousStep() {
    if (_activeRecipe == null || _activeStepIndex == 0) return;
    _timer?.cancel();
    setState(() {
      _activeStepIndex--;
      _stepTimerSeconds = _activeRecipe!.steps[_activeStepIndex].durationSeconds;
      _isTimerActive = false;
    });
  }

  void _finishMeal() {
    _timer?.cancel();
    if (_activeRecipe != null) {
      final savedAmount = _activeRecipe!.estimatedSavings;
      setState(() {
        _totalDollarsSaved += savedAmount;
        _mealsCookedCount += 1;
        _recentActivityLog.insert(
          0,
          "Cooked ${_activeRecipe!.title} - Saved \$${savedAmount.toStringAsFixed(2)}",
        );
        _isTimerActive = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.stars, color: Colors.amber, size: 28),
              SizedBox(width: 8),
              Text('Bon Appétit!'),
            ],
          ),
          content: Text(
            'You completed "${_activeRecipe!.title}" and saved estimated \$${savedAmount.toStringAsFixed(2)} over takeout!',
            style: const TextStyle(fontSize: 15),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _activeRecipe = null;
                  _currentIndex = 3; // Go to Savings screen
                });
              },
              child: const Text('View Savings'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.kitchen, color: Colors.teal),
            SizedBox(width: 8),
            Text(
              'PantryCraft',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
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
                const Icon(Icons.monetization_on, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '\$${_totalDollarsSaved.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildPantryTab(),
          _buildMealCrafterTab(),
          _buildActiveCookTab(),
          _buildSavingsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'My Pantry',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Meal Crafter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Live Chef',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Savings Log',
          ),
        ],
      ),
    );
  }

  // TAB 1: PANTRY INVENTORY MANAGEMENT
  Widget _buildPantryTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.teal.shade700,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 24,
                        child: Icon(Icons.add_shopping_cart, color: Colors.teal),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Pantry Status Engine',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Toggle items you have right now. Recipes auto-update!',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Available Ingredients',
                    style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showAddIngredientDialog,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add Item'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _pantryItems.length,
                itemBuilder: (context, index) {
                  final item = _pantryItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: SwitchListTile(
                      activeColor: Colors.teal,
                      title: Text(
                        item.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          decoration: item.isAvailable ? TextDecoration.none : TextDecoration.lineThrough,
                          color: item.isAvailable ? Colors.black87 : Colors.grey,
                        ),
                      ),
                      subtitle: Text(
                        'Category: ${item.category}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      value: item.isAvailable,
                      onChanged: (val) {
                        setState(() {
                          item.isAvailable = val;
                        });
                      },
                      secondary: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            _pantryItems.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddIngredientDialog() {
    final controller = TextEditingController();
    String category = 'Produce';

    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Pantry Item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Ingredient Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Produce', 'Protein', 'Grains', 'Dairy', 'Bakery', 'Condiments']
                        .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() {
                          category = val;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      setState(() {
                        _pantryItems.add(PantryItem(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: controller.text.trim(),
                          category: category,
                          isAvailable: true,
                        ));
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // TAB 2: MEAL CRAFTER ENGINE
  Widget _buildMealCrafterTab() {
    final availableNames = _pantryItems.where((i) => i.isAvailable).map((i) => i.name.toLowerCase()).toSet();

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Smart Recipe Matcher',
                style: TextStyle(fontSize: 20, FontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Recipes generated based strictly on your active pantry ingredients.',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  final recipe = _recipes[index];
                  final reqCount = recipe.requiredIngredients.length;
                  final matchCount = recipe.requiredIngredients
                      .where((ing) => availableNames.contains(ing.toLowerCase()))
                      .length;

                  final bool canCookNow = matchCount == reqCount;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  recipe.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    FontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: canCookNow ? Colors.green.shade100 : Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  canCookNow ? 'Ready to Cook!' : '$matchCount/$reqCount ingredients',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: canCookNow ? Colors.green.shade900 : Colors.orange.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.schedule, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text('${recipe.prepTimeMinutes} mins prep', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(width: 16),
                              const Icon(Icons.monetization_on_outlined, size: 16, color: Colors.green),
                              const SizedBox(width: 4),
                              Text('Saves ~\$${recipe.estimatedSavings.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: recipe.requiredIngredients.map((ing) {
                              final hasIng = availableNames.contains(ing.toLowerCase());
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: hasIng ? Colors.teal.shade50 : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: hasIng ? Colors.teal.shade300 : Colors.grey.shade400,
                                  ),
                                ),
                                child: Text(
                                  ing,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: hasIng ? Colors.teal.shade900 : Colors.grey.shade700,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _startCookingRecipe(recipe),
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Start Cook Session'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: canCookNow ? Colors.teal : Colors.blueGrey,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TAB 3: LIVE ACTIVE COOKING ASSISTANT & TIMER
  Widget _buildActiveCookTab() {
    if (_activeRecipe == null) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.soup_kitchen, size: 72, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text(
                  'No Active Cooking Session',
                  style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Go to the Meal Crafter tab and select a recipe to start cooking step-by-step with live timers!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Browse Pantry Recipes'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentStep = _activeRecipe!.steps[_activeStepIndex];
    final totalSteps = _activeRecipe!.steps.length;

    final minutes = (_stepTimerSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_stepTimerSeconds % 60).toString().padLeft(2, '0');

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.teal.shade800,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'COOKING NOW: ${_activeRecipe!.title}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (_activeStepIndex + 1) / totalSteps,
                        backgroundColor: Colors.teal.shade900,
                        color: Colors.amber,
                        minHeight: 8,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Step ${_activeStepIndex + 1} of $totalSteps',
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        currentStep.title,
                        style: const TextStyle(fontSize: 20, FontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        currentStep.description,
                        style: const TextStyle(fontSize: 15, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.teal.shade200),
                        ),
                        child: Text(
                          '$minutes:$seconds',
                          style: TextStyle(
                            fontSize: 48,
                            FontWeight: FontWeight.bold,
                            color: Colors.teal.shade900,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _toggleStepTimer,
                            icon: Icon(_isTimerActive ? Icons.pause : Icons.play_arrow),
                            label: Text(_isTimerActive ? 'Pause Timer' : 'Start Timer'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isTimerActive ? Colors.orange : Colors.teal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () {
                              _timer?.cancel();
                              setState(() {
                                _isTimerActive = false;
                                _stepTimerSeconds = currentStep.durationSeconds;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: _activeStepIndex > 0 ? _previousStep : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _nextStep,
                    icon: Icon(_activeStepIndex == totalSteps - 1 ? Icons.check_circle : Icons.arrow_forward),
                    label: Text(_activeStepIndex == totalSteps - 1 ? 'Finish Cooking!' : 'Next Step'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _activeStepIndex == totalSteps - 1 ? Colors.green : Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TAB 4: SAVINGS & STREAK DASHBOARD
  Widget _buildSavingsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Financial & Food Waste Impact',
                style: TextStyle(fontSize: 20, FontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Real-time stats on takeout money saved by cooking at home.',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.teal.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Icon(Icons.monetization_on, color: Colors.teal, size: 32),
                            const SizedBox(height: 8),
                            Text(
                              '\$${_totalDollarsSaved.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                FontWeight: FontWeight.bold,
                                color: Colors.teal.shade900,
                              ),
                            ),
                            const Text(
                              'Total Saved',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      color: Colors.amber.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Icon(Icons.local_fire_department, color: Colors.amber, size: 32),
                            const SizedBox(height: 8),
                            Text(
                              '$_streakDays Days',
                              style: TextStyle(
                                fontSize: 20,
                                FontWeight: FontWeight.bold,
                                color: Colors.amber.shade900,
                              ),
                            ),
                            const Text(
                              'Cooking Streak',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.restaurant, color: Colors.white),
                  ),
                  title: const Text('Meals Prepared at Home'),
                  subtitle: Text('$_mealsCookedCount zero-waste home cooked meals'),
                  trailing: const Icon(Icons.verified, color: Colors.teal),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Recent Cooking Activity',
                style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _recentActivityLog.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                      title: Text(
                        _recentActivityLog[index],
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}