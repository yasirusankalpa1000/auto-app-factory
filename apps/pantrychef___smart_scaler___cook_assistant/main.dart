import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const PantryChefApp());
}

class Ingredient {
  final String name;
  final double baseAmount;
  final String unit;

  const Ingredient({
    required this.name,
    required this.baseAmount,
    required this.unit,
  });
}

class CookingStep {
  final int stepNumber;
  final String title;
  final String description;
  final int timerSeconds;

  const CookingStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    this.timerSeconds = 0,
  });
}

class Recipe {
  final String id;
  final String title;
  final String category;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final String baseIngredientName;
  final double defaultBaseAmount;
  final String baseUnit;
  final List<Ingredient> ingredients;
  final List<CookingStep> steps;
  final double estimatedTakeoutCost;
  final List<String> requiredTags;

  const Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.baseIngredientName,
    required this.defaultBaseAmount,
    required this.baseUnit,
    required this.ingredients,
    required this.steps,
    required this.estimatedTakeoutCost,
    required this.requiredTags,
  });
}

class CookLog {
  final String recipeTitle;
  final double moneySaved;
  final DateTime timestamp;

  CookLog({
    required this.recipeTitle,
    required this.moneySaved,
    required this.timestamp,
  });
}

class PantryChefApp extends StatelessWidget {
  const PantryChefApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PantryChef',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          primary: Colors.deepOrange,
          secondary: Colors.teal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
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
  int _selectedTabIndex = 0;

  // Master Recipe Database
  final List<Recipe> _recipes = const [
    Recipe(
      id: '1',
      title: 'Fluffy Pantry Pancakes',
      category: 'Breakfast',
      prepTimeMinutes: 5,
      cookTimeMinutes: 10,
      baseIngredientName: 'Flour',
      defaultBaseAmount: 100.0,
      baseUnit: 'g',
      ingredients: [
        Ingredient(name: 'Flour', baseAmount: 100.0, unit: 'g'),
        Ingredient(name: 'Milk', baseAmount: 150.0, unit: 'ml'),
        Ingredient(name: 'Egg', baseAmount: 1.0, unit: 'pcs'),
        Ingredient(name: 'Sugar', baseAmount: 15.0, unit: 'g'),
        Ingredient(name: 'Butter', baseAmount: 15.0, unit: 'g'),
        Ingredient(name: 'Baking Powder', baseAmount: 5.0, unit: 'g'),
      ],
      steps: [
        CookingStep(
          stepNumber: 1,
          title: 'Mix Dry Ingredients',
          description: 'In a medium bowl, whisk together the flour, sugar, and baking powder.',
          timerSeconds: 60,
        ),
        CookingStep(
          stepNumber: 2,
          title: 'Whisk Batter',
          description: 'Add milk, egg, and melted butter. Whisk until smooth without overmixing.',
          timerSeconds: 120,
        ),
        CookingStep(
          stepNumber: 3,
          title: 'Heat Skillet',
          description: 'Preheat a non-stick pan over medium heat and melt a knob of butter.',
          timerSeconds: 90,
        ),
        CookingStep(
          stepNumber: 4,
          title: 'Cook & Flip',
          description: 'Pour batter into small circles. Cook until bubbles form, flip, and cook golden brown.',
          timerSeconds: 180,
        ),
      ],
      estimatedTakeoutCost: 12.50,
      requiredTags: ['Flour', 'Milk', 'Egg', 'Butter'],
    ),
    Recipe(
      id: '2',
      title: 'Garlic Butter Pantry Pasta',
      category: 'Dinner',
      prepTimeMinutes: 5,
      cookTimeMinutes: 12,
      baseIngredientName: 'Pasta',
      defaultBaseAmount: 100.0,
      baseUnit: 'g',
      ingredients: [
        Ingredient(name: 'Pasta', baseAmount: 100.0, unit: 'g'),
        Ingredient(name: 'Garlic', baseAmount: 2.0, unit: 'cloves'),
        Ingredient(name: 'Butter', baseAmount: 25.0, unit: 'g'),
        Ingredient(name: 'Cheese', baseAmount: 30.0, unit: 'g'),
        Ingredient(name: 'Salt & Pepper', baseAmount: 2.0, unit: 'g'),
      ],
      steps: [
        CookingStep(
          stepNumber: 1,
          title: 'Boil Water',
          description: 'Bring a pot of generously salted water to a rolling boil.',
          timerSeconds: 300,
        ),
        CookingStep(
          stepNumber: 2,
          title: 'Cook Pasta',
          description: 'Add pasta and boil until al dente stirring occasionally.',
          timerSeconds: 480,
        ),
        CookingStep(
          stepNumber: 3,
          title: 'Sauté Garlic',
          description: 'Melt butter in skillet, sauté minced garlic until aromatic and soft.',
          timerSeconds: 120,
        ),
        CookingStep(
          stepNumber: 4,
          title: 'Combine & Serve',
          description: 'Toss hot pasta directly into garlic butter with grated cheese and pepper.',
          timerSeconds: 90,
        ),
      ],
      estimatedTakeoutCost: 16.00,
      requiredTags: ['Pasta', 'Garlic', 'Butter', 'Cheese'],
    ),
    Recipe(
      id: '3',
      title: 'Quick Mug Omelette',
      category: 'Snack',
      prepTimeMinutes: 2,
      cookTimeMinutes: 3,
      baseIngredientName: 'Eggs',
      defaultBaseAmount: 2.0,
      baseUnit: 'pcs',
      ingredients: [
        Ingredient(name: 'Eggs', baseAmount: 2.0, unit: 'pcs'),
        Ingredient(name: 'Cheese', baseAmount: 20.0, unit: 'g'),
        Ingredient(name: 'Milk', baseAmount: 15.0, unit: 'ml'),
        Ingredient(name: 'Tomato', baseAmount: 0.5, unit: 'pcs'),
        Ingredient(name: 'Salt', baseAmount: 1.0, unit: 'g'),
      ],
      steps: [
        CookingStep(
          stepNumber: 1,
          title: 'Whisk in Mug',
          description: 'Crack eggs into a microwave-safe mug, add milk and salt, and whisk well.',
          timerSeconds: 45,
        ),
        CookingStep(
          stepNumber: 2,
          title: 'Add Toppings',
          description: 'Fold in diced tomatoes and shredded cheese.',
          timerSeconds: 30,
        ),
        CookingStep(
          stepNumber: 3,
          title: 'Microwave Cooking',
          description: 'Microwave on High for 60 seconds, stir, then microwave for another 45 seconds.',
          timerSeconds: 105,
        ),
      ],
      estimatedTakeoutCost: 9.00,
      requiredTags: ['Egg', 'Milk', 'Cheese', 'Tomato'],
    ),
    Recipe(
      id: '4',
      title: 'Crispy Garlic Hash Potatoes',
      category: 'Lunch',
      prepTimeMinutes: 5,
      cookTimeMinutes: 15,
      baseIngredientName: 'Potatoes',
      defaultBaseAmount: 200.0,
      baseUnit: 'g',
      ingredients: [
        Ingredient(name: 'Potatoes', baseAmount: 200.0, unit: 'g'),
        Ingredient(name: 'Butter', baseAmount: 20.0, unit: 'g'),
        Ingredient(name: 'Garlic', baseAmount: 2.0, unit: 'cloves'),
        Ingredient(name: 'Salt & Pepper', baseAmount: 3.0, unit: 'g'),
      ],
      steps: [
        CookingStep(
          stepNumber: 1,
          title: 'Dice Potatoes',
          description: 'Dice potatoes into small 1cm cubes for fast uniform cooking.',
          timerSeconds: 180,
        ),
        CookingStep(
          stepNumber: 2,
          title: 'Heat Skillet',
          description: 'Melt butter in a large skillet over medium-high heat.',
          timerSeconds: 60,
        ),
        CookingStep(
          stepNumber: 3,
          title: 'Sear Potatoes',
          description: 'Add potatoes and garlic in a single layer. Sear without moving to form a crisp crust.',
          timerSeconds: 360,
        ),
        CookingStep(
          stepNumber: 4,
          title: 'Flip & Finish',
          description: 'Toss, season with salt and pepper, and cook until tender inside.',
          timerSeconds: 300,
        ),
      ],
      estimatedTakeoutCost: 11.50,
      requiredTags: ['Potatoes', 'Butter', 'Garlic'],
    ),
  ];

  // Pantry State
  final Set<String> _selectedPantryItems = {'Flour', 'Milk', 'Egg', 'Butter', 'Pasta', 'Garlic', 'Cheese', 'Potatoes', 'Tomato'};
  final List<String> _allAvailablePantryTags = ['Flour', 'Milk', 'Egg', 'Butter', 'Pasta', 'Garlic', 'Cheese', 'Potatoes', 'Tomato'];

  // Active Cooking Session State
  Recipe? _activeRecipe;
  double _userBaseQuantity = 100.0;
  int _currentStepIndex = 0;
  Timer? _stepTimer;
  int _remainingSeconds = 0;
  bool _isTimerRunning = false;

  // History & Savings State
  double _totalMoneySaved = 48.50;
  int _mealsCookedCount = 4;
  final List<CookLog> _cookHistory = [
    CookLog(recipeTitle: 'Fluffy Pantry Pancakes', moneySaved: 12.50, timestamp: DateTime.now().subtract(const Duration(days: 1))),
    CookLog(recipeTitle: 'Garlic Butter Pantry Pasta', moneySaved: 16.00, timestamp: DateTime.now().subtract(const Duration(days: 2))),
    CookLog(recipeTitle: 'Quick Mug Omelette', moneySaved: 8.50, timestamp: DateTime.now().subtract(const Duration(days: 3))),
    CookLog(recipeTitle: 'Crispy Garlic Hash Potatoes', moneySaved: 11.50, timestamp: DateTime.now().subtract(const Duration(days: 4))),
  ];

  @override
  void dispose() {
    _stepTimer?.cancel();
    super.dispose();
  }

  void _startCookSession(Recipe recipe) {
    setState(() {
      _activeRecipe = recipe;
      _userBaseQuantity = recipe.defaultBaseAmount;
      _currentStepIndex = 0;
      _selectedTabIndex = 1; // Switch to Guided Cook tab
      _resetTimerForCurrentStep();
    });
  }

  void _resetTimerForCurrentStep() {
    _stepTimer?.cancel();
    if (_activeRecipe != null && _currentStepIndex < _activeRecipe!.steps.length) {
      final step = _activeRecipe!.steps[_currentStepIndex];
      setState(() {
        _remainingSeconds = step.timerSeconds;
        _isTimerRunning = false;
      });
    }
  }

  void _toggleTimer() {
    if (_isTimerRunning) {
      _stepTimer?.cancel();
      setState(() {
        _isTimerRunning = false;
      });
    } else {
      if (_remainingSeconds <= 0) return;
      setState(() {
        _isTimerRunning = true;
      });
      _stepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          timer.cancel();
          setState(() {
            _isTimerRunning = false;
          });
        }
      });
    }
  }

  void _finishRecipe() {
    if (_activeRecipe == null) return;

    final double scaledSavings = _activeRecipe!.estimatedTakeoutCost * (_userBaseQuantity / _activeRecipe!.defaultBaseAmount);

    setState(() {
      _totalMoneySaved += scaledSavings;
      _mealsCookedCount += 1;
      _cookHistory.insert(
        0,
        CookLog(
          recipeTitle: _activeRecipe!.title,
          moneySaved: scaledSavings,
          timestamp: DateTime.now(),
        ),
      );
      _activeRecipe = null;
      _stepTimer?.cancel();
      _isTimerRunning = false;
      _selectedTabIndex = 2; // Move to savings tab
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.stars, color: Colors.amber),
            SizedBox(width: 8),
            Text('Meal Completed!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Great job cooking at home! You just saved:'),
            const SizedBox(height: 8),
            Text(
              '\$${scaledSavings.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Your budget and pantry health are thriving.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.restaurant, color: Colors.white),
            SizedBox(width: 8),
            Text('PantryChef', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.deepOrange,
        elevation: 2,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '\$${_totalMoneySaved.toStringAsFixed(2)} Saved',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          )
        ],
      ),
      body: IndexedStack(
        index: _selectedTabIndex,
        children: [
          _buildPantryScalerTab(),
          _buildGuidedCookTab(),
          _buildSavingsTrackerTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) => setState(() => _selectedTabIndex = index),
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.kitchen),
            label: 'Pantry Scaler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Cook Studio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Savings',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: PANTRY MATCH & RATIO SCALER ---
  Widget _buildPantryScalerTab() {
    final filteredRecipes = _recipes.where((recipe) {
      return recipe.requiredTags.any((tag) => _selectedPantryItems.contains(tag));
    }).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pantry Ingredient Selector Banner
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.tune, color: Colors.deepOrange),
                        SizedBox(width: 8),
                        Text(
                          'What is in your pantry right now?',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 4.0,
                      crossAxisAlignment: WrapCrossAxisAlignment.center,
                      children: _allAvailablePantryTags.map((tag) {
                        final isSelected = _selectedPantryItems.contains(tag);
                        return FilterChip(
                          label: Text(tag),
                          selected: isSelected,
                          selectedColor: Colors.deepOrange.shade100,
                          checkmarkColor: Colors.deepOrange,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedPantryItems.add(tag);
                              } else {
                                _selectedPantryItems.remove(tag);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Matched Smart Recipes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const Text(
              'Tap any recipe to scale ingredient ratios based on what you have left.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            if (filteredRecipes.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.search_off, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'No recipes match your selected ingredients.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = filteredRecipes[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                                  recipe.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  recipe.category,
                                  style: TextStyle(color: Colors.teal.shade800, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text('${recipe.prepTimeMinutes + recipe.cookTimeMinutes} mins total', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(width: 16),
                              const Icon(Icons.monetization_on, size: 16, color: Colors.green),
                              const SizedBox(width: 4),
                              Text('Saves ~\$${recipe.estimatedTakeoutCost.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Base: ${recipe.baseIngredientName} (${recipe.defaultBaseAmount.toStringAsFixed(0)} ${recipe.baseUnit})',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
                                    ),
                                    Text(
                                      '${recipe.ingredients.length} ingredients needed',
                                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _startCookSession(recipe),
                                icon: const Icon(Icons.play_arrow, size: 18),
                                label: const Text('Scale & Cook'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
          ],
        ),
      ),
    );
  }

  // --- TAB 2: INTERACTIVE GUIDED COOK STUDIO ---
  Widget _buildGuidedCookTab() {
    if (_activeRecipe == null) {
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Icon(Icons.restaurant_menu, size: 80, color: Colors.deepOrange.shade200),
                const SizedBox(height: 16),
                const Text(
                  'No Active Cooking Session',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose a recipe from the Pantry Scaler tab to unlock exact portion calculations and step-by-step cook timers!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => setState(() => _selectedTabIndex = 0),
                  icon: const Icon(Icons.search),
                  label: const Text('Find a Recipe'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final recipe = _activeRecipe!;
    final scaleRatio = _userBaseQuantity / recipe.defaultBaseAmount;

    final currentStep = recipe.steps[_currentStepIndex];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Header & Scale Slider
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            recipe.title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => setState(() => _activeRecipe = null),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Icon(Icons.scale, color: Colors.deepOrange, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Available ${recipe.baseIngredientName}:',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        const Spacer(),
                        Text(
                          '${_userBaseQuantity.toStringAsFixed(0)} ${recipe.baseUnit}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.deepOrange),
                        ),
                      ],
                    ),
                    Slider(
                      value: _userBaseQuantity,
                      min: (recipe.defaultBaseAmount * 0.5).clamp(1.0, 500.0),
                      max: (recipe.defaultBaseAmount * 3.0).clamp(10.0, 1000.0),
                      divisions: 10,
                      activeColor: Colors.deepOrange,
                      onChanged: (value) {
                        setState(() {
                          _userBaseQuantity = value;
                        });
                      },
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Scaled Ingredient Portions:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: recipe.ingredients.map((ing) {
                        final scaledAmount = ing.baseAmount * scaleRatio;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            '${ing.name}: ${scaledAmount.toStringAsFixed(scaledAmount >= 10 ? 0 : 1)} ${ing.unit}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Step Progress Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Step ${_currentStepIndex + 1} of ${recipe.steps.length}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                Text(
                  '${((_currentStepIndex + 1) / recipe.steps.length * 100).toInt()}% Completed',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
              ],
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: (_currentStepIndex + 1) / recipe.steps.length,
              backgroundColor: Colors.grey.shade200,
              color: Colors.teal,
              minHeight: 6,
            ),

            const SizedBox(height: 16),

            // Active Step Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        currentStep.title,
                        style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      currentStep.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, height: 1.4, color: Colors.black87),
                    ),
                    const SizedBox(height: 20),

                    // Embedded Timer Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.timer, color: Colors.amber, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'ACTIVE STEP TIMER',
                                style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          FittedBox(
                            child: Text(
                              _formatTime(_remainingSeconds),
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _toggleTimer,
                                icon: Icon(_isTimerRunning ? Icons.pause : Icons.play_arrow),
                                label: Text(_isTimerRunning ? 'Pause' : 'Start Timer'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isTimerRunning ? Colors.amber : Colors.deepOrange,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton.icon(
                                onPressed: _resetTimerForCurrentStep,
                                icon: const Icon(Icons.refresh, color: Colors.white),
                                label: const Text('Reset', style: TextStyle(color: Colors.white)),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white70),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Step Navigation Buttons
            Row(
              children: [
                if (_currentStepIndex > 0)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _currentStepIndex--;
                          _resetTimerForCurrentStep();
                        });
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous Step'),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                    ),
                  ),
                if (_currentStepIndex > 0) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_currentStepIndex < recipe.steps.length - 1) {
                        setState(() {
                          _currentStepIndex++;
                          _resetTimerForCurrentStep();
                        });
                      } else {
                        _finishRecipe();
                      }
                    },
                    icon: Icon(_currentStepIndex < recipe.steps.length - 1 ? Icons.arrow_forward : Icons.check_circle),
                    label: Text(_currentStepIndex < recipe.steps.length - 1 ? 'Next Step' : 'Finish Meal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 3: SAVINGS & IMPACT TRACKER ---
  Widget _buildSavingsTrackerTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Impact Cards
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.deepOrange,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'TOTAL TAKEOUT SAVINGS',
                      style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      child: Text(
                        '\$${_totalMoneySaved.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text('$_mealsCookedCount', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            const Text('Home Meals', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                        Container(height: 24, width: 1, color: Colors.white70),
                        Column(
                          children: [
                            Text('~${_mealsCookedCount * 15}m', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            const Text('Time Cooked', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Meal History & Savings Log',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            if (_cookHistory.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.history, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('No cooked meals logged yet.', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _cookHistory.length,
                itemBuilder: (context, index) {
                  final log = _cookHistory[index];
                  final formattedDate = '${log.timestamp.day}/${log.timestamp.month}/${log.timestamp.year}';
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.check, color: Colors.white),
                      ),
                      title: Text(log.recipeTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text('Cooked on $formattedDate', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      trailing: Text(
                        '+\$${log.moneySaved.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 20),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _cookHistory.clear();
                    _totalMoneySaved = 0.0;
                    _mealsCookedCount = 0;
                  });
                },
                icon: const Icon(Icons.delete, color: Colors.grey, size: 18),
                label: const Text('Reset Savings History', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}