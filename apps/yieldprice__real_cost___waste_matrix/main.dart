import 'package:flutter/material.dart';

void main() {
  runApp(const YieldPriceApp());
}

class YieldPriceApp extends StatelessWidget {
  const YieldPriceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YieldPrice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: const Color(0xFF00796B),
          secondary: const Color(0xFF00BFA5),
          surface: const Color(0xFFF4F7F6),
        ),
        scaffoldBackgroundColor: const Color(0xFFEFF4F3),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00796B),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
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
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ComparatorScreen(),
    RecipeCostScreen(),
    YieldGuideScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.calculate, color: Colors.amber),
            SizedBox(width: 8),
            Text(
              'YieldPrice Matrix',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.compare_arrows),
            selectedIcon: Icon(Icons.compare_arrows, color: Colors.teal),
            label: 'Offer Battle',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            selectedIcon: Icon(Icons.restaurant_menu, color: Colors.teal),
            label: 'Recipe Costing',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory),
            selectedIcon: Icon(Icons.inventory, color: Colors.teal),
            label: 'Yield Matrix',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 1: OFFER COMPARATOR
// -----------------------------------------------------------------------------
class ComparatorScreen extends StatefulWidget {
  const ComparatorScreen({super.key});

  @override
  State<ComparatorScreen> createState() => _ComparatorScreenState();
}

class _ComparatorScreenState extends State<ComparatorScreen> {
  // Option A
  final _nameAController = TextEditingController(text: 'Bone-in Chicken');
  final _priceAController = TextEditingController(text: '8.99');
  final _weightAController = TextEditingController(text: '1000');
  double _wasteA = 28.0; // % bone/trim waste
  double _discountA = 0.0;

  // Option B
  final _nameBController = TextEditingController(text: 'Boneless Cutlet');
  final _priceBController = TextEditingController(text: '11.50');
  final _weightBController = TextEditingController(text: '900');
  double _wasteB = 0.0; // % waste
  double _discountB = 10.0; // 10% coupon

  void _applyPreset(bool isItemA, String label, double waste) {
    setState(() {
      if (isItemA) {
        _wasteA = waste;
      } else {
        _wasteB = waste;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Math calculations
    final priceA = double.tryParse(_priceAController.text) ?? 0.0;
    final weightA = double.tryParse(_weightAController.text) ?? 1.0;
    final finalPriceA = priceA * (1.0 - (_discountA / 100.0));
    final netWeightA = weightA * (1.0 - (_wasteA / 100.0));
    final costPer100gA = netWeightA > 0 ? (finalPriceA / netWeightA) * 100 : 0.0;

    final priceB = double.tryParse(_priceBController.text) ?? 0.0;
    final weightB = double.tryParse(_weightBController.text) ?? 1.0;
    final finalPriceB = priceB * (1.0 - (_discountB / 100.0));
    final netWeightB = weightB * (1.0 - (_wasteB / 100.0));
    final costPer100gB = netWeightB > 0 ? (finalPriceB / netWeightB) * 100 : 0.0;

    bool isAWinner = costPer100gA > 0 && (costPer100gA < costPer100gB || costPer100gB <= 0);
    bool isBWinner = costPer100gB > 0 && (costPer100gB < costPer100gA || costPer100gA <= 0);

    double savingsPercent = 0.0;
    if (costPer100gA > 0 && costPer100gB > 0) {
      final higher = costPer100gA > costPer100gB ? costPer100gA : costPer100gB;
      final lower = costPer100gA < costPer100gB ? costPer100gA : costPer100gB;
      savingsPercent = ((higher - lower) / higher) * 100.0;
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.shade800,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info, color: Colors.amber),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Real Cost Matrix factors out non-edible weight (bones, peels, liquid loss) to reveal actual value!',
                      style: TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Item A Card
            _buildItemCard(
              title: 'Option A',
              isWinner: isAWinner,
              color: Colors.teal.shade50,
              borderColor: isAWinner ? Colors.green : Colors.grey.shade300,
              nameController: _nameAController,
              priceController: _priceAController,
              weightController: _weightAController,
              wasteValue: _wasteA,
              discountValue: _discountA,
              costPer100g: costPer100gA,
              netWeight: netWeightA,
              finalPrice: finalPriceA,
              onWasteChanged: (v) => setState(() => _wasteA = v),
              onDiscountChanged: (v) => setState(() => _discountA = v),
              onPresetSelected: (lbl, val) => _applyPreset(true, lbl, val),
            ),

            const SizedBox(height: 16),

            // Item B Card
            _buildItemCard(
              title: 'Option B',
              isWinner: isBWinner,
              color: Colors.amber.shade50,
              borderColor: isBWinner ? Colors.green : Colors.grey.shade300,
              nameController: _nameBController,
              priceController: _priceBController,
              weightController: _weightBController,
              wasteValue: _wasteB,
              discountValue: _discountB,
              costPer100g: costPer100gB,
              netWeight: netWeightB,
              finalPrice: finalPriceB,
              onWasteChanged: (v) => setState(() => _wasteB = v),
              onDiscountChanged: (v) => setState(() => _discountB = v),
              onPresetSelected: (lbl, val) => _applyPreset(false, lbl, val),
            ),

            const SizedBox(height: 16),

            // Comparison Summary Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.teal.shade900,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'VERDICT SUMMARY',
                      style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isAWinner
                          ? '${_nameAController.text.isEmpty ? "Option A" : _nameAController.text} IS THE BETTER VALUE!'
                          : isBWinner
                              ? '${_nameBController.text.isEmpty ? "Option B" : _nameBController.text} IS THE BETTER VALUE!'
                              : 'BOTH OPTIONS ARE EQUAL VALUE',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      softWrap: true,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'You save ${savingsPercent.toStringAsFixed(1)}% per edible 100g by choosing the winner!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard({
    required String title,
    required bool isWinner,
    required Color color,
    required Color borderColor,
    required TextEditingController nameController,
    required TextEditingController priceController,
    required TextEditingController weightController,
    required double wasteValue,
    required double discountValue,
    required double costPer100g,
    required double netWeight,
    required double finalPrice,
    required ValueChanged<double> onWasteChanged,
    required ValueChanged<double> onDiscountChanged,
    required Function(String, double) onPresetSelected,
  }) {
    return Card(
      elevation: isWinner ? 4 : 1,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: isWinner ? 2.5 : 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (isWinner) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.stars, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'BEST VALUE',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Store Price (\$) ',
                      prefixText: '\$ ',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Pack Weight (g)',
                      suffixText: 'g',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Sliders & Preset Pills
            Text(
              'Waste / Non-Edible Trimmings: ${wasteValue.toStringAsFixed(0)}%',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            Slider(
              value: wasteValue,
              min: 0,
              max: 60,
              divisions: 60,
              activeColor: Colors.teal.shade700,
              label: '${wasteValue.toStringAsFixed(0)}%',
              onChanged: onWasteChanged,
            ),

            // Quick Preset Chips
            Wrap(
              spacing: 6,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _buildPresetChip('Boneless (0%)', 0.0, onPresetSelected),
                _buildPresetChip('Bone-In Meat (25%)', 25.0, onPresetSelected),
                _buildPresetChip('Raw Seafood (35%)', 35.0, onPresetSelected),
                _buildPresetChip('Fresh Produce (20%)', 20.0, onPresetSelected),
              ],
            ),
            const SizedBox(height: 10),

            Text(
              'Discount / Coupon: ${discountValue.toStringAsFixed(0)}%',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            Slider(
              value: discountValue,
              min: 0,
              max: 50,
              divisions: 50,
              activeColor: Colors.amber.shade800,
              label: '${discountValue.toStringAsFixed(0)}%',
              onChanged: onDiscountChanged,
            ),

            const Divider(),

            // Computed Stats Matrix
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Net Edible Mass: ${netWeight.toStringAsFixed(0)} g',
                        style: const TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                      Text(
                        'Final Paid Price: \$${finalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.teal.shade300),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'REAL COST / 100g',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                      Text(
                        '\$${costPer100g.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isWinner ? Colors.green.shade800 : Colors.teal.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip(String label, double val, Function(String, double) onSelected) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      onPressed: () => onSelected(label, val),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 2: RECIPE BATCH & SERVING COSTING
// -----------------------------------------------------------------------------
class RecipeIngredient {
  String name;
  double purchasePrice;
  double packWeightGrams;
  double wastePercent;
  double usedWeightGrams;

  RecipeIngredient({
    required this.name,
    required this.purchasePrice,
    required this.packWeightGrams,
    required this.wastePercent,
    required this.usedWeightGrams,
  });

  double get netPackWeight => packWeightGrams * (1.0 - (wastePercent / 100.0));
  double get costPerNetGram => netPackWeight > 0 ? purchasePrice / netPackWeight : 0.0;
  double get recipeCost => costPerNetGram * usedWeightGrams;
}

class RecipeCostScreen extends StatefulWidget {
  const RecipeCostScreen({super.key});

  @override
  State<RecipeCostScreen> createState() => _RecipeCostScreenState();
}

class _RecipeCostScreenState extends State<RecipeCostScreen> {
  final List<RecipeIngredient> _ingredients = [
    RecipeIngredient(name: 'Chicken Breast (Bone-in)', purchasePrice: 12.00, packWeightGrams: 1000, wastePercent: 25, usedWeightGrams: 500),
    RecipeIngredient(name: 'Olive Oil', purchasePrice: 9.50, packWeightGrams: 500, wastePercent: 0, usedWeightGrams: 30),
    RecipeIngredient(name: 'Fresh Vegetables', purchasePrice: 4.00, packWeightGrams: 400, wastePercent: 15, usedWeightGrams: 250),
  ];

  int _servings = 4;
  double _targetMarginPercent = 70.0; // 70% profit target / 30% food cost ratio

  void _addIngredientDialog() {
    final nameCtrl = TextEditingController(text: 'Ingredient');
    final priceCtrl = TextEditingController(text: '5.00');
    final packCtrl = TextEditingController(text: '500');
    final wasteCtrl = TextEditingController(text: '10');
    final usedCtrl = TextEditingController(text: '100');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Dish Ingredient'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Purchase Price (\$)', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: packCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Pack Weight (g)', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: wasteCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Trim Waste Loss (%)', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: usedCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount Used in Recipe (g)', border: OutlineInputBorder())),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _ingredients.add(
                  RecipeIngredient(
                    name: nameCtrl.text.isEmpty ? 'Item' : nameCtrl.text,
                    purchasePrice: double.tryParse(priceCtrl.text) ?? 0.0,
                    packWeightGrams: double.tryParse(packCtrl.text) ?? 1.0,
                    wastePercent: double.tryParse(wasteCtrl.text) ?? 0.0,
                    usedWeightGrams: double.tryParse(usedCtrl.text) ?? 0.0,
                  ),
                );
              });
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalBatchCost = 0.0;
    for (var item in _ingredients) {
      totalBatchCost += item.recipeCost;
    }

    double costPerServing = _servings > 0 ? totalBatchCost / _servings : 0.0;
    double foodCostRatio = (100.0 - _targetMarginPercent) / 100.0;
    double suggestedPricePerPortion = foodCostRatio > 0 ? costPerServing / foodCostRatio : 0.0;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Controls Card
            Card(
              color: Colors.teal.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.kitchen, color: Colors.teal),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Batch Yield & Serving Matrix',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            softWrap: true,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _addIngredientDialog,
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Add Item'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Portions Made: $_servings', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                              Slider(
                                value: _servings.toDouble(),
                                min: 1,
                                max: 20,
                                divisions: 19,
                                label: '$_servings',
                                onChanged: (v) => setState(() => _servings = v.toInt()),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Target Profit Margin: ${_targetMarginPercent.toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                              Slider(
                                value: _targetMarginPercent,
                                min: 20,
                                max: 90,
                                divisions: 70,
                                activeColor: Colors.amber.shade800,
                                label: '${_targetMarginPercent.toStringAsFixed(0)}%',
                                onChanged: (v) => setState(() => _targetMarginPercent = v),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Ingredients List
            const Text(
              'Ingredient Breakdown (Yield-Adjusted)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),

            ..._ingredients.asMap().entries.map((entry) {
              int idx = entry.key;
              RecipeIngredient ing = entry.value;

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text(ing.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    'Used: ${ing.usedWeightGrams.toStringAsFixed(0)}g | Trim Waste: ${ing.wastePercent.toStringAsFixed(0)}%\nPack Price: \$${ing.purchasePrice.toStringAsFixed(2)} / ${ing.packWeightGrams.toStringAsFixed(0)}g',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Actual Cost', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          Text(
                            '\$${ing.recipeCost.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.teal),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                        onPressed: () {
                          setState(() {
                            _ingredients.removeAt(idx);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),

            // Total Calculations Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade900,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Batch Recipe Cost:', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      Text('\$${totalBatchCost.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const Divider(color: Colors.teal),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Cost Per Portion / Serving:', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      Text('\$${costPerServing.toStringAsFixed(2)}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Suggested Menu Price (${_targetMarginPercent.toStringAsFixed(0)}% margin):',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                          softWrap: true,
                        ),
                      ),
                      Text(
                        '\$${suggestedPricePerPortion.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 3: YIELD & WASTE CHEAT SHEET MATRIX
// -----------------------------------------------------------------------------
class YieldGuideItem {
  final String category;
  final String item;
  final double averageWastePercent;
  final String description;

  const YieldGuideItem({
    required this.category,
    required this.item,
    required this.averageWastePercent,
    required this.description,
  });
}

class YieldGuideScreen extends StatefulWidget {
  const YieldGuideScreen({super.key});

  @override
  State<YieldGuideScreen> createState() => _YieldGuideScreenState();
}

class _YieldGuideScreenState extends State<YieldGuideScreen> {
  String _searchQuery = '';

  final List<YieldGuideItem> _guideData = const [
    YieldGuideItem(category: 'Poultry & Meat', item: 'Bone-in Chicken Thighs / Breasts', averageWastePercent: 28.0, description: 'Bone and skin trimming loss.'),
    YieldGuideItem(category: 'Poultry & Meat', item: 'Whole Roast Turkey / Chicken', averageWastePercent: 38.0, description: 'Carcass bones, fat, and cartilage loss.'),
    YieldGuideItem(category: 'Poultry & Meat', item: 'Bone-In Pork Chops', averageWastePercent: 22.0, description: 'Bone and exterior fat cap.'),
    YieldGuideItem(category: 'Seafood', item: 'Unpeeled Raw Shrimp', averageWastePercent: 40.0, description: 'Shell and head removal weight loss.'),
    YieldGuideItem(category: 'Seafood', item: 'Whole Fish (Unfilled)', averageWastePercent: 50.0, description: 'Head, tail, guts, and spinal bone trim.'),
    YieldGuideItem(category: 'Produce', item: 'Fresh Pineapple', averageWastePercent: 45.0, description: 'Rind, crown, and hard core loss.'),
    YieldGuideItem(category: 'Produce', item: 'Unpeeled Potatoes / Carrots', averageWastePercent: 15.0, description: 'Peel loss and root trim.'),
    YieldGuideItem(category: 'Produce', item: 'Watermelon', averageWastePercent: 48.0, description: 'Thick rind and seed mass loss.'),
    YieldGuideItem(category: 'Produce', item: 'Fresh Spinach / Leafy Greens', averageWastePercent: 20.0, description: 'Stems and wilted outer leaf trim.'),
    YieldGuideItem(category: 'Beverages', item: 'Whole Coffee Beans to Brew', averageWastePercent: 12.0, description: 'Moisture loss and ground retention.'),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _guideData.where((element) {
      final q = _searchQuery.toLowerCase();
      return element.item.toLowerCase().contains(q) || element.category.toLowerCase().contains(q);
    }).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: const InputDecoration(
                hintText: 'Search yield database (e.g. Chicken, Pineapple)...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  final netEdible = 100.0 - item.averageWastePercent;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.category,
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.teal.shade900),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${item.averageWastePercent.toStringAsFixed(0)}% WASTE',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.item,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description,
                            style: const TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                          const SizedBox(height: 8),

                          // Visual Progress Bar
                          Row(
                            children: [
                              Expanded(
                                flex: netEdible.toInt(),
                                child: Container(
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.horizontal(left: Radius.circular(4)),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: item.averageWastePercent.toInt(),
                                child: Container(
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.horizontal(right: Radius.circular(4)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Edible: ${netEdible.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                              Text('Trim Loss: ${item.averageWastePercent.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 10, color: Colors.redAccent, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}