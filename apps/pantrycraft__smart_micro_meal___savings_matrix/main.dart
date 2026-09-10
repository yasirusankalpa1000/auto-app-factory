import 'package:flutter/material.dart';

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
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.light,
      ),
      home: const MainHomeScreen(),
    );
  }
}

class IngredientItem {
  final String name;
  final String category;
  final IconData icon;

  const IngredientItem({
    required this.name,
    required this.category,
    required this.icon,
  });
}

class RecipeIngredient {
  final String name;
  final double amount;
  final String unit;

  const RecipeIngredient({
    required this.name,
    required this.amount,
    required this.unit,
  });
}

class RecipeModel {
  final String id;
  final String title;
  final int prepMinutes;
  final double costPerServing;
  final int calories;
  final List<RecipeIngredient> ingredients;
  final List<String> steps;
  final String category;

  const RecipeModel({
    required this.id,
    required this.title,
    required this.prepMinutes,
    required this.costPerServing,
    required this.calories,
    required this.ingredients,
    required this.steps,
    required this.category,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  final Set<String> _selectedIngredients = {'Eggs', 'Bread', 'Butter', 'Garlic'};
  final Set<String> _savedRecipeIds = {'r1'};
  
  int _cookedCount = 4;
  double _totalMoneySaved = 38.50;
  int _streakDays = 3;

  final List<IngredientItem> _availableIngredients = const [
    IngredientItem(name: 'Eggs', category: 'Protein', icon: Icons.egg),
    IngredientItem(name: 'Bread', category: 'Staples', icon: Icons.bakery_dining),
    IngredientItem(name: 'Butter', category: 'Dairy', icon: Icons.breakfast_dining),
    IngredientItem(name: 'Garlic', category: 'Spices', icon: Icons.eco),
    IngredientItem(name: 'Cheese', category: 'Dairy', icon: Icons.local_pizza),
    IngredientItem(name: 'Tomato', category: 'Fresh', icon: Icons.circle),
    IngredientItem(name: 'Rice', category: 'Staples', icon: Icons.rice_bowl),
    IngredientItem(name: 'Onion', category: 'Fresh', icon: Icons.blur_on),
    IngredientItem(name: 'Potato', category: 'Fresh', icon: Icons.dns),
    IngredientItem(name: 'Pasta', category: 'Staples', icon: Icons.ramen_dining),
    IngredientItem(name: 'Milk', category: 'Dairy', icon: Icons.local_drink),
    IngredientItem(name: 'Spinach', category: 'Fresh', icon: Icons.grass),
    IngredientItem(name: 'Chicken', category: 'Protein', icon: Icons.restaurant),
    IngredientItem(name: 'Soy Sauce', category: 'Spices', icon: Icons.liquor),
  ];

  late List<RecipeModel> _recipes;

  @override
  void initState() {
    super.initState();
    _recipes = [
      const RecipeModel(
        id: 'r1',
        title: 'Crispy Garlic Butter Egg Toast',
        prepMinutes: 8,
        costPerServing: 1.40,
        calories: 310,
        category: 'Quick Breakfast',
        ingredients: [
          RecipeIngredient(name: 'Bread', amount: 2, unit: 'slices'),
          RecipeIngredient(name: 'Eggs', amount: 2, unit: 'pcs'),
          RecipeIngredient(name: 'Butter', amount: 15, unit: 'g'),
          RecipeIngredient(name: 'Garlic', amount: 1, unit: 'clove'),
        ],
        steps: [
          'Melt butter in a skillet over medium heat and stir in crushed garlic.',
          'Toast the bread slices until golden crisp on both sides.',
          'Fry or scramble the eggs in the remaining garlic butter.',
          'Assemble egg over golden toast and sprinkle with pinch of salt.',
        ],
      ),
      const RecipeModel(
        id: 'r2',
        title: '10-Minute Cheesy Rice Bowl',
        prepMinutes: 10,
        costPerServing: 1.85,
        calories: 420,
        category: 'Express Lunch',
        ingredients: [
          RecipeIngredient(name: 'Rice', amount: 150, unit: 'g'),
          RecipeIngredient(name: 'Cheese', amount: 40, unit: 'g'),
          RecipeIngredient(name: 'Butter', amount: 10, unit: 'g'),
          RecipeIngredient(name: 'Soy Sauce', amount: 1, unit: 'tsp'),
          RecipeIngredient(name: 'Eggs', amount: 1, unit: 'pcs'),
        ],
        steps: [
          'Warm up cooked rice in a pan with butter and soy sauce.',
          'Make a small well in center and crack in the fresh egg.',
          'Cover with grated cheese and put lid on low heat for 3 minutes until melted.',
          'Mix thoroughly for a velvety rich comfort rice bowl.',
        ],
      ),
      const RecipeModel(
        id: 'r3',
        title: 'Pan-Seared Garlic Tomato Pasta',
        prepMinutes: 14,
        costPerServing: 2.10,
        calories: 390,
        category: 'Simple Dinner',
        ingredients: [
          RecipeIngredient(name: 'Pasta', amount: 120, unit: 'g'),
          RecipeIngredient(name: 'Tomato', amount: 2, unit: 'medium'),
          RecipeIngredient(name: 'Garlic', amount: 3, unit: 'cloves'),
          RecipeIngredient(name: 'Butter', amount: 15, unit: 'g'),
          RecipeIngredient(name: 'Cheese', amount: 25, unit: 'g'),
        ],
        steps: [
          'Boil pasta in salted water until al dente.',
          'Sauté sliced garlic and diced tomatoes in butter until fragrant and soft.',
          'Toss pasta directly into sauce with 2 tbsp of pasta water.',
          'Top with cheese and serve warm.',
        ],
      ),
      const RecipeModel(
        id: 'r4',
        title: 'Golden Potato & Egg Hash',
        prepMinutes: 15,
        costPerServing: 1.60,
        calories: 360,
        category: 'Hearty Meal',
        ingredients: [
          RecipeIngredient(name: 'Potato', amount: 2, unit: 'medium'),
          RecipeIngredient(name: 'Eggs', amount: 2, unit: 'pcs'),
          RecipeIngredient(name: 'Onion', amount: 0.5, unit: 'pc'),
          RecipeIngredient(name: 'Butter', amount: 15, unit: 'g'),
        ],
        steps: [
          'Dice potatoes into small cubes for quick cooking.',
          'Pan-fry potatoes and chopped onion in butter until crispy brown.',
          'Create two pockets in hash and crack eggs inside.',
          'Cover pan until egg whites set.',
        ],
      ),
    ];
  }

  void _toggleIngredient(String name) {
    setState(() {
      if (_selectedIngredients.contains(name)) {
        _selectedIngredients.remove(name);
      } else {
        _selectedIngredients.add(name);
      }
    });
  }

  void _toggleSavedRecipe(String id) {
    setState(() {
      if (_savedRecipeIds.contains(id)) {
        _savedRecipeIds.remove(id);
      } else {
        _savedRecipeIds.add(id);
      }
    });
  }

  void _addCustomRecipe(RecipeModel recipe) {
    setState(() {
      _recipes.insert(0, recipe);
    });
  }

  void _recordMealCooked(RecipeModel recipe, int servings) {
    final double costSaved = (11.50 * servings) - (recipe.costPerServing * servings);
    setState(() {
      _cookedCount++;
      _totalMoneySaved += (costSaved > 0 ? costSaved : 4.00);
      _streakDays++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Meal cooked! You saved \$${costSaved.toStringAsFixed(2)} compared to takeaway!',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 3),
      ),
    );
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
        elevation: 1,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.amber[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_fire_department, color: Colors.deepOrange, size: 18),
                const SizedBox(width: 4),
                Text(
                  '$_streakDays Day Streak',
                  style: TextStyle(
                    color: Colors.deepOrange[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildPantryMatcherTab(),
            _buildSavedRecipesTab(),
            _buildImpactTrackerTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRecipeModal(context),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Recipe'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view),
            selectedIcon: Icon(Icons.grid_view_rounded, color: Colors.teal),
            label: 'Pantry Match',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark, color: Colors.teal),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights),
            selectedIcon: Icon(Icons.insights_rounded, color: Colors.teal),
            label: 'Impact & Savings',
          ),
        ],
      ),
    );
  }

  Widget _buildPantryMatcherTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal[700]!, Colors.teal[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'What is in your kitchen right now?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tap available ingredients to dynamically find non-waste micro-recipes.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Ingredient Selector Matrix
          const Text(
            'Select Your Ingredients:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: _availableIngredients.map((ing) {
              final isSelected = _selectedIngredients.contains(ing.name);
              return FilterChip(
                selected: isSelected,
                avatar: Icon(
                  ing.icon,
                  size: 16,
                  color: isSelected ? Colors.white : Colors.teal[800],
                ),
                label: Text(ing.name),
                selectedColor: Colors.teal,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (_) => _toggleIngredient(ing.name),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Matching Recipes Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Matching Recipes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Chip(
                label: Text('${_getSortedRecipes().length} available'),
                backgroundColor: Colors.teal[50],
                side: BorderSide.none,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Recipes Card List
          ..._getSortedRecipes().map((recipe) {
            final double matchRatio = _calculateMatchRatio(recipe);
            final int matchPercent = (matchRatio * 100).round();
            final bool isSaved = _savedRecipeIds.contains(recipe.id);

            return Card(
              margin: const EdgeInsets.only(bottom: 14),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => _openRecipeDetailModal(context, recipe),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  softWrap: true,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  recipe.category,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: isSaved ? Colors.teal : Colors.grey,
                            ),
                            onPressed: () => _toggleSavedRecipe(recipe.id),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Match Bar
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: matchRatio,
                              backgroundColor: Colors.grey[200],
                              color: matchPercent > 70
                                  ? Colors.green
                                  : (matchPercent > 40 ? Colors.orange : Colors.grey),
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '$matchPercent% Match',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: matchPercent > 70
                                  ? Colors.green[800]
                                  : Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Recipe Quick Badges
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        children: [
                          _buildBadge(Icons.timer, '${recipe.prepMinutes} mins'),
                          _buildBadge(
                              Icons.monetization_on, '\$${recipe.costPerServing.toStringAsFixed(2)}/serv'),
                          _buildBadge(Icons.local_fire_department, '${recipe.calories} kcal'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSavedRecipesTab() {
    final savedList = _recipes.where((r) => _savedRecipeIds.contains(r.id)).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Saved Cookbook',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 6),
          Text(
            'Quickly access your favorite micro-recipes anytime.',
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          const SizedBox(height: 16),
          if (savedList.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(Icons.bookmark_outline, size: 60, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    Text(
                      'No saved recipes yet.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          else
            ...savedList.map((recipe) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal[100],
                    child: const Icon(Icons.restaurant, color: Colors.teal),
                  ),
                  title: Text(
                    recipe.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${recipe.prepMinutes} mins • \$${recipe.costPerServing.toStringAsFixed(2)} per serving',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _toggleSavedRecipe(recipe.id),
                  ),
                  onTap: () => _openRecipeDetailModal(context, recipe),
                ),
              );
            }).toList()
        ],
      ),
    );
  }

  Widget _buildImpactTrackerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Financial & Waste Impact',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            'Real-time stats from cooking with available pantry items.',
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Impact Cards Matrix
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Total Saved',
                  '\$${_totalMoneySaved.toStringAsFixed(2)}',
                  Icons.monetization_on,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Meals Cooked',
                  '$_cookedCount',
                  Icons.soup_kitchen,
                  Colors.teal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Current Streak',
                  '$_streakDays Days',
                  Icons.local_fire_department,
                  Colors.deepOrange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Waste Avoided',
                  '~${(_cookedCount * 0.35).toStringAsFixed(1)} kg',
                  Icons.eco,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Visual Takeaway Savings Breakdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.lightbulb, color: Colors.teal),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Takeaway vs Pantry Matrix',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Average takeaway cost per meal is around \$12.50. By crafting 15-minute meals with leftover kitchen staples, you save approximately \$9.80 every single meal!',
                  style: TextStyle(fontSize: 13, height: 1.4),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.teal[700]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  double _calculateMatchRatio(RecipeModel recipe) {
    if (recipe.ingredients.isEmpty) return 0.0;
    int matches = 0;
    for (var ing in recipe.ingredients) {
      if (_selectedIngredients.contains(ing.name)) {
        matches++;
      }
    }
    return matches / recipe.ingredients.length;
  }

  List<RecipeModel> _getSortedRecipes() {
    final list = List<RecipeModel>.from(_recipes);
    list.sort((a, b) => _calculateMatchRatio(b).compareTo(_calculateMatchRatio(a)));
    return list;
  }

  void _openRecipeDetailModal(BuildContext context, RecipeModel recipe) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return _RecipeDetailSheet(
          recipe: recipe,
          onCooked: (servings) {
            Navigator.pop(ctx);
            _recordMealCooked(recipe, servings);
          },
        );
      },
    );
  }

  void _showAddRecipeModal(BuildContext context) {
    final titleController = TextEditingController();
    final minsController = TextEditingController();
    final costController = TextEditingController();
    final categoryController = TextEditingController();
    final ingredientTextController = TextEditingController();
    final stepsTextController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 20,
            left: 16,
            right: 16,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Craft New Micro-Recipe',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Recipe Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: minsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Prep Time (mins)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: costController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Cost/Serving (\$) ',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Category (e.g. Quick Snack)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: ingredientTextController,
                    decoration: const InputDecoration(
                      labelText: 'Ingredients (comma separated: Bread, Butter)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: stepsTextController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Steps (one per line)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (titleController.text.trim().isEmpty) return;

                        final rawIngs = ingredientTextController.text.split(',');
                        final parsedIngs = rawIngs.where((s) => s.trim().isNotEmpty).map((s) {
                          return RecipeIngredient(name: s.trim(), amount: 1, unit: 'portion');
                        }).toList();

                        final rawSteps = stepsTextController.text.split('\n');
                        final parsedSteps = rawSteps.where((s) => s.trim().isNotEmpty).toList();

                        final newRecipe = RecipeModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: titleController.text.trim(),
                          prepMinutes: int.tryParse(minsController.text) ?? 10,
                          costPerServing: double.tryParse(costController.text) ?? 1.50,
                          calories: 320,
                          category: categoryController.text.trim().isEmpty
                              ? 'Custom Crafter'
                              : categoryController.text.trim(),
                          ingredients: parsedIngs.isEmpty
                              ? [const RecipeIngredient(name: 'Bread', amount: 1, unit: 'pc')]
                              : parsedIngs,
                          steps: parsedSteps.isEmpty
                              ? ['Prepare ingredients and serve hot.']
                              : parsedSteps,
                        );

                        _addCustomRecipe(newRecipe);
                        Navigator.pop(ctx);
                      },
                      child: const Text('Save Recipe to App Matrix'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RecipeDetailSheet extends StatefulWidget {
  final RecipeModel recipe;
  final Function(int servings) onCooked;

  const _RecipeDetailSheet({
    Key? key,
    required this.recipe,
    required this.onCooked,
  }) : super(key: key);

  @override
  State<_RecipeDetailSheet> createState() => _RecipeDetailSheetState();
}

class _RecipeDetailSheetState extends State<_RecipeDetailSheet> {
  int _servings = 1;
  final Set<int> _completedSteps = {};

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final totalCost = recipe.costPerServing * _servings;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                recipe.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 6),
              Text(
                recipe.category,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 16),

              // Serving Scale Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Servings Multiplier:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          color: Colors.teal,
                          onPressed: _servings > 1
                              ? () {
                                  setState(() {
                                    _servings--;
                                  });
                                }
                              : null,
                        ),
                        Text(
                          '$_servings',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          color: Colors.teal,
                          onPressed: _servings < 6
                              ? () {
                                  setState(() {
                                    _servings++;
                                  });
                                }
                              : null,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Dynamic Cost Calculation Banner
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estimated Cost',
                            style: TextStyle(fontSize: 12, color: Colors.green[900]),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '\$${totalCost.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Takeaway Savings',
                            style: TextStyle(fontSize: 12, color: Colors.amber[900]),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '\$${((11.50 * _servings) - totalCost).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Scaled Ingredients List
              const Text(
                'Scaled Ingredients:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ...recipe.ingredients.map((ing) {
                final double scaledAmount = ing.amount * _servings;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check, size: 16, color: Colors.teal),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          ing.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text(
                        '${scaledAmount.toStringAsFixed(scaledAmount.truncateToDouble() == scaledAmount ? 0 : 1)} ${ing.unit}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),

              // Interactive Cooking Steps
              const Text(
                'Step-by-Step Interactive Guide:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ...recipe.steps.asMap().entries.map((entry) {
                final int idx = entry.key;
                final String stepText = entry.value;
                final bool isDone = _completedSteps.contains(idx);

                return CheckboxListTile(
                  value: isDone,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    '${idx + 1}. $stepText',
                    style: TextStyle(
                      fontSize: 13,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                      color: isDone ? Colors.grey : Colors.black87,
                    ),
                  ),
                  activeColor: Colors.teal,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _completedSteps.add(idx);
                      } else {
                        _completedSteps.remove(idx);
                      }
                    });
                  },
                );
              }).toList(),
              const SizedBox(height: 20),

              // Action Cooked Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.soup_kitchen),
                  label: const Text(
                    'I Cooked This Meal! Log Savings',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => widget.onCooked(_servings),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}