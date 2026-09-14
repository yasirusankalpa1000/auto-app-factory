import 'package:flutter/material.dart';

void main() {
  runApp(const ImpulseGuardApp());
}

class ImpulseGuardApp extends StatelessWidget {
  const ImpulseGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImpulseGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const MainScreen(),
    );
  }
}

class PurchaseItem {
  final String id;
  final String name;
  final double price;
  final String category;
  final double hoursRequired;
  final int needScore;
  final DateTime addedDate;
  final int cooldownHours;
  String status; // 'pending', 'saved', 'bought'
  final String notes;

  PurchaseItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.hoursRequired,
    required this.needScore,
    required this.addedDate,
    required this.cooldownHours,
    this.status = 'pending',
    required this.notes,
  });
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  double _hourlyWage = 22.50;
  double _totalSaved = 340.00;

  final List<PurchaseItem> _items = [
    PurchaseItem(
      id: '1',
      name: 'Wireless Noise-Canceling Headphones',
      price: 180.00,
      category: 'Electronics',
      hoursRequired: 8.0,
      needScore: 42,
      addedDate: DateTime.now().subtract(const Duration(hours: 18)),
      cooldownHours: 48,
      status: 'pending',
      notes: 'Current ones still work, just wanted blue color.',
    ),
    PurchaseItem(
      id: '2',
      name: 'Designer Sneakers',
      price: 120.00,
      category: 'Fashion',
      hoursRequired: 5.3,
      needScore: 28,
      addedDate: DateTime.now().subtract(const Duration(hours: 50)),
      cooldownHours: 48,
      status: 'saved',
      notes: 'Decided to wear my existing white sneakers.',
    ),
  ];

  void _addPurchaseItem(PurchaseItem item) {
    setState(() {
      _items.insert(0, item);
      _currentIndex = 0; // Return to vault tab
    });
  }

  void _updateItemStatus(String id, String newStatus) {
    setState(() {
      final index = _items.indexWhere((i) => i.id == id);
      if (index != -1) {
        final item = _items[index];
        item.status = newStatus;
        if (newStatus == 'saved') {
          _totalSaved += item.price;
        }
      }
    });
  }

  void _updateWage(double wage) {
    setState(() {
      _hourlyWage = wage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      VaultTab(
        items: _items,
        hourlyWage: _hourlyWage,
        totalSaved: _totalSaved,
        onStatusChange: _updateItemStatus,
      ),
      EvaluateTab(
        hourlyWage: _hourlyWage,
        onSave: _addPurchaseItem,
      ),
      CompoundVisualizerTab(
        hourlyWage: _hourlyWage,
        totalSaved: _totalSaved,
      ),
      ProfileTab(
        hourlyWage: _hourlyWage,
        onWageUpdated: _updateWage,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
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
            icon: Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield),
            label: 'Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_chart),
            selectedIcon: Icon(Icons.add_chart_sharp),
            label: 'Evaluate',
          ),
          NavigationDestination(
            icon: Icon(Icons.trending_up),
            label: 'Compound',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 1: COOL-DOWN VAULT
// ============================================================================
class VaultTab extends StatefulWidget {
  final List<PurchaseItem> items;
  final double hourlyWage;
  final double totalSaved;
  final Function(String, String) onStatusChange;

  const VaultTab({
    super.key,
    required this.items,
    required this.hourlyWage,
    required this.totalSaved,
    required this.onStatusChange,
  });

  @override
  State<VaultTab> createState() => _VaultTabState();
}

class _VaultTabState extends State<VaultTab> {
  String _filter = 'pending';

  @override
  Widget build(BuildContext context) {
    final filteredItems = widget.items.where((i) => i.status == _filter).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Summary Card
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.teal, Colors.tealDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.savings, color: Colors.white, size: 28),
                    SizedBox(width: 8),
                    Text(
                      'Total Impulse Money Saved',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '\$${widget.totalSaved.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Equivalent to ${(widget.totalSaved / (widget.hourlyWage > 0 ? widget.hourlyWage : 1)).toStringAsFixed(1)} Hours of Work Reclaimed!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Vault Filter Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Impulse Vault',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Wrap(
                spacing: 6,
                children: [
                  _filterChip('pending', 'Cooling Down'),
                  _filterChip('saved', 'Saved'),
                  _filterChip('bought', 'Bought'),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (filteredItems.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Icon(Icons.shield_moon_outlined, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    'No items in "$_filter"',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Evaluate a purchase before buying to start cooling down!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return _buildItemCard(item);
              },
            ),
        ],
      ),
    );
  }

  Widget _filterChip(String key, String label) {
    final isSelected = _filter == key;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedColor: Colors.teal,
      backgroundColor: Colors.grey.shade200,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _filter = key;
          });
        }
      },
    );
  }

  Widget _buildItemCard(PurchaseItem item) {
    final elapsedHours = DateTime.now().difference(item.addedDate).inHours;
    final remainingHours = (item.cooldownHours - elapsedHours).clamp(0, item.cooldownHours);
    final progress = (elapsedHours / item.cooldownHours).clamp(0.0, 1.0);
    final isCoolingDone = remainingHours == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isCoolingDone && item.status == 'pending'
              ? Colors.orange.shade300
              : Colors.grey.shade200,
        ),
      ),
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
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      softWrap: true,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Category: ${item.category}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.teal,
                    ),
                  ),
                  Text(
                    '≈ ${item.hoursRequired.toStringAsFixed(1)} labor hrs',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (item.notes.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Note: "${item.notes}"',
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (item.status == 'pending') ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isCoolingDone ? Icons.check_circle : Icons.timer,
                      size: 16,
                      color: isCoolingDone ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isCoolingDone
                          ? 'Cool-down Complete!'
                          : '${remainingHours}h remaining in lock',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isCoolingDone ? Colors.green : Colors.orange.shade800,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Need Score: ${item.needScore}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: item.needScore < 50 ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: isCoolingDone ? Colors.green : Colors.teal,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => widget.onStatusChange(item.id, 'saved'),
                    icon: const Icon(Icons.savings, size: 16),
                    label: const Text('Pass & Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => widget.onStatusChange(item.id, 'bought'),
                    icon: const Icon(Icons.shopping_cart, size: 16),
                    label: const Text('Bought It'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: item.status == 'saved' ? Colors.green.shade50 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                item.status == 'saved'
                    ? '✓ Avoided Impulse Purchase (Money Saved!)'
                    : 'Purchased After Reflection',
                style: TextStyle(
                  fontSize: 12,
                  color: item.status == 'saved' ? Colors.green.shade800 : Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 2: INTERACTIVE EVALUATE PURCHASE ENGINE
// ============================================================================
class EvaluateTab extends StatefulWidget {
  final double hourlyWage;
  final Function(PurchaseItem) onSave;

  const EvaluateTab({
    super.key,
    required this.hourlyWage,
    required this.onSave,
  });

  @override
  State<EvaluateTab> createState() => _EvaluateTabState();
}

class _EvaluateTabState extends State<EvaluateTab> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();

  String _category = 'General';
  double _q1Urgency = 3; // 1 to 5
  double _q2Frequency = 3; // 1 to 5
  bool _canAffordTwice = false;
  bool _replacingExisting = false;
  int _cooldownHours = 24;

  final List<String> _categories = [
    'General',
    'Electronics',
    'Fashion',
    'Gaming & Entertainment',
    'Home & Kitchen',
    'Gadgets & Toys',
  ];

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final hoursLabor = widget.hourlyWage > 0 ? (price / widget.hourlyWage) : 0.0;
    final calculatedScore = _calculateNeedScore();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Purchase Reality Check',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Calculate the real life-cost before spending your hard-earned money.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Price & Name Input
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Item Name',
                      hintText: 'e.g. Smart Watch, Running Shoes',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.shopping_bag_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _priceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            labelText: 'Price (\$)',
                            hintText: '0.00',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _category,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          items: _categories.map((c) {
                            return DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12)));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _category = val);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Live Life-Hour Conversion Banner
          if (price > 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.access_time_filled, color: Colors.deepOrange),
                      SizedBox(width: 8),
                      Text(
                        'Life-Hour Labor Cost',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black87, fontSize: 14),
                      children: [
                        const TextSpan(text: 'To buy this, you must trade '),
                        TextSpan(
                          text: '${hoursLabor.toStringAsFixed(1)} hours ',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange, fontSize: 16),
                        ),
                        TextSpan(
                          text: 'of raw work at your rate of \$${widget.hourlyWage.toStringAsFixed(2)}/hr.',
                        ),
                      ],
                    ),
                  ),
                  if (hoursLabor > 8) ...[
                    const SizedBox(height: 6),
                    Text(
                      '⚠️ That is equivalent to ${(hoursLabor / 8).toStringAsFixed(1)} full 8-hour workday(s) of labor!',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),

          const SizedBox(height: 16),

          // Interactive Decision Quiz
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mindfulness Evaluation Quiz',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),

                  // Q1: Urgency Slider
                  Text('1. How urgently do you need this right now? (${_q1Urgency.toInt()}/5)'),
                  Slider(
                    value: _q1Urgency,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _q1Urgency.toInt().toString(),
                    activeColor: Colors.teal,
                    onChanged: (val) => setState(() => _q1Urgency = val),
                  ),

                  // Q2: Frequency Slider
                  Text('2. How often will you realistically use this? (${_q2Frequency.toInt()}/5)'),
                  Slider(
                    value: _q2Frequency,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _q2Frequency.toInt().toString(),
                    activeColor: Colors.teal,
                    onChanged: (val) => setState(() => _q2Frequency = val),
                  ),

                  // Checkbox Q3
                  SwitchListTile(
                    title: const Text('Could you afford to buy 2 of these in cash right now without debt?'),
                    value: _canAffordTwice,
                    activeColor: Colors.teal,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _canAffordTwice = val),
                  ),

                  // Checkbox Q4
                  SwitchListTile(
                    title: const Text('Are you replacing a broken item (vs. upgrading a working one)?'),
                    value: _replacingExisting,
                    activeColor: Colors.teal,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _replacingExisting = val),
                  ),

                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Why do you want this? (Self-Reflection)',
                      hintText: 'e.g. Saw an ad, feeling bored, sale ending soon...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Cooldown Selection & Score Display
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.shade200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Calculated Necessity Score:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: calculatedScore > 60 ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$calculatedScore / 100',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Cool-Down Lock Period: ', style: TextStyle(fontSize: 13)),
                    const Spacer(),
                    DropdownButton<int>(
                      value: _cooldownHours,
                      items: const [
                        DropdownMenuItem(value: 12, child: Text('12 Hours')),
                        DropdownMenuItem(value: 24, child: Text('24 Hours')),
                        DropdownMenuItem(value: 48, child: Text('48 Hours')),
                        DropdownMenuItem(value: 72, child: Text('72 Hours')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _cooldownHours = val);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                if (_nameController.text.isEmpty || price <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid item name and price.')),
                  );
                  return;
                }

                final newItem = PurchaseItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _nameController.text,
                  price: price,
                  category: _category,
                  hoursRequired: hoursLabor,
                  needScore: calculatedScore,
                  addedDate: DateTime.now(),
                  cooldownHours: _cooldownHours,
                  notes: _notesController.text,
                );

                widget.onSave(newItem);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Item added to Impulse Vault! Let the cool-down begin.'),
                    backgroundColor: Colors.teal,
                  ),
                );
              },
              icon: const Icon(Icons.lock_clock),
              label: const Text(
                'Lock in Cool-Down Vault',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateNeedScore() {
    double score = 0;
    score += (_q1Urgency / 5) * 30; // Max 30
    score += (_q2Frequency / 5) * 30; // Max 30
    if (_canAffordTwice) score += 20;
    if (_replacingExisting) score += 20;
    return score.toInt().clamp(0, 100);
  }
}

// ============================================================================
// TAB 3: COMPOUND WEALTH & LIFE-HOUR VISUALIZER
// ============================================================================
class CompoundVisualizerTab extends StatefulWidget {
  final double hourlyWage;
  final double totalSaved;

  const CompoundVisualizerTab({
    super.key,
    required this.hourlyWage,
    required this.totalSaved,
  });

  @override
  State<CompoundVisualizerTab> createState() => _CompoundVisualizerTabState();
}

class _CompoundVisualizerTabState extends State<CompoundVisualizerTab> {
  double _monthlySavedSim = 150.0;
  double _returnRate = 7.0; // 7% annual return
  int _years = 10;

  @override
  Widget build(BuildContext context) {
    final futureValue = _calculateCompound(_monthlySavedSim, _returnRate, _years);
    final totalInvested = _monthlySavedSim * 12 * _years;
    final totalInterest = futureValue - totalInvested;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Impulse Compound Engine',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'See how tiny impulse decisions saved today build real freedom over time.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Total Future Wealth Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.indigo, Colors.indigoAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Potential Future Wealth',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${futureValue.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Actual Saved: \$${totalInvested.toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      'Compound Interest: +\$${totalInterest.toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Interactive Sliders
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'If you divert \$${_monthlySavedSim.toInt()} / month from impulse buys:',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _monthlySavedSim,
                    min: 20,
                    max: 1000,
                    divisions: 49,
                    label: '\$${_monthlySavedSim.toInt()}',
                    activeColor: Colors.indigo,
                    onChanged: (val) => setState(() => _monthlySavedSim = val),
                  ),

                  const SizedBox(height: 12),

                  Text('Investment Timeline: ${_years} Years'),
                  Slider(
                    value: _years.toDouble(),
                    min: 1,
                    max: 30,
                    divisions: 29,
                    label: '$_years yrs',
                    activeColor: Colors.indigo,
                    onChanged: (val) => setState(() => _years = val.toInt()),
                  ),

                  const SizedBox(height: 12),

                  Text('Estimated Annual Return: ${_returnRate.toStringAsFixed(1)}%'),
                  Slider(
                    value: _returnRate,
                    min: 2,
                    max: 12,
                    divisions: 20,
                    label: '${_returnRate.toStringAsFixed(1)}%',
                    activeColor: Colors.indigo,
                    onChanged: (val) => setState(() => _returnRate = val),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Everyday Comparison Micro-Cards
          const Text(
            'What Your Saved Money Buys Instead',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),

          _buildComparisonTile(
            Icons.flight_takeoff,
            'Vacations Reclaimed',
            '${(widget.totalSaved / 600.0).toStringAsFixed(1)} Full Weekend Trips',
            Colors.blue,
          ),
          _buildComparisonTile(
            Icons.directions_car,
            'Car Fuel / Mobility',
            '${(widget.totalSaved / 50.0).toStringAsFixed(1)} Tank Refills',
            Colors.orange,
          ),
          _buildComparisonTile(
            Icons.free_breakfast,
            'Coffee & Lunches',
            '${(widget.totalSaved / 12.0).toStringAsFixed(0)} Daily Lunches',
            Colors.brown,
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTile(IconData icon, String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateCompound(double monthly, double rate, int yrs) {
    final r = rate / 100 / 12;
    final n = yrs * 12;
    if (r == 0) return monthly * n;
    return monthly * ((num.parse((1 + r).toString()) as double) * (num.parse(BigInt.from(1).toString()).toDouble()));
  }
}

// ============================================================================
// TAB 4: PROFILE & WAGE SETTINGS
// ============================================================================
class ProfileTab extends StatefulWidget {
  final double hourlyWage;
  final Function(double) onWageUpdated;

  const ProfileTab({
    super.key,
    required this.hourlyWage,
    required this.onWageUpdated,
  });

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late TextEditingController _wageController;
  late TextEditingController _monthlyIncomeController;

  @override
  void initState() {
    super.initState();
    _wageController = TextEditingController(text: widget.hourlyWage.toStringAsFixed(2));
    _monthlyIncomeController = TextEditingController(
      text: (widget.hourlyWage * 160).toStringAsFixed(0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Labor & Rate Settings',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Configure your real hourly rate to power the life-hour conversion engine.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Direct Hourly Rate',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _wageController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Net Hourly Wage (\$ / hr)',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text(
                    'Or Calculate from Monthly Take-Home Pay',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _monthlyIncomeController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Monthly Net Income (\$)',
                      hintText: 'e.g. 3600',
                      prefixIcon: Icon(Icons.account_balance_wallet),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        final monthly = double.tryParse(_monthlyIncomeController.text) ?? 0.0;
                        if (monthly > 0) {
                          final hourly = monthly / 160.0; // standard 160h/month
                          _wageController.text = hourly.toStringAsFixed(2);
                          setState(() {});
                        }
                      },
                      child: const Text('Calculate Wage from Monthly Income (160 hrs)'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        final newWage = double.tryParse(_wageController.text) ?? 0.0;
                        if (newWage > 0) {
                          widget.onWageUpdated(newWage);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Hourly rate updated to \$${newWage.toStringAsFixed(2)}/hr!'),
                              backgroundColor: Colors.teal,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Save Hourly Rate'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Tips Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blueGrey.shade200),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.blueGrey),
                    SizedBox(width: 8),
                    Text(
                      'Smart Shopping Rule of Thumb',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Before making any non-essential purchase over \$50, force yourself to wait at least 24 hours. Over 70% of impulse purchase desires completely disappear after a 24-hour cool-down period!',
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}