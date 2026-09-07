import 'package:flutter/material.dart';

void main() {
  runApp(const ImpulsePauseApp());
}

class ImpulsePauseApp extends StatelessWidget {
  const ImpulsePauseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pause & Save',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const MainScreen(),
    );
  }
}

class ImpulseItem {
  final String id;
  final String title;
  final double price;
  final String category;
  final DateTime createdAt;
  final int cooldownHours;
  final double impulseScore;
  bool isSaved;
  bool isPurchased;

  ImpulseItem({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.createdAt,
    required this.cooldownHours,
    required this.impulseScore,
    this.isSaved = false,
    this.isPurchased = false,
  });

  DateTime get unlockTime => createdAt.add(Duration(hours: cooldownHours));
  bool get isUnlocked => DateTime.now().isAfter(unlockTime);

  Duration get remainingTime {
    final now = DateTime.now();
    if (now.isAfter(unlockTime)) return Duration.zero;
    return unlockTime.difference(now);
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  double _hourlyWage = 25.0; // Default hourly wage

  final List<ImpulseItem> _items = [
    ImpulseItem(
      id: '1',
      title: 'Wireless Gaming Headphones',
      price: 149.99,
      category: 'Electronics',
      createdAt: DateTime.now().subtract(const Duration(hours: 18)),
      cooldownHours: 24,
      impulseScore: 78.0,
    ),
    ImpulseItem(
      id: '2',
      title: 'Designer Leather Jacket',
      price: 280.00,
      category: 'Fashion',
      createdAt: DateTime.now().subtract(const Duration(hours: 40)),
      cooldownHours: 72,
      impulseScore: 85.0,
    ),
    ImpulseItem(
      id: '3',
      title: 'Smart Coffee Mug Warm',
      price: 65.50,
      category: 'Home',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      cooldownHours: 48,
      impulseScore: 40.0,
      isSaved: true,
    ),
  ];

  void _addItem(ImpulseItem item) {
    setState(() {
      _items.insert(0, item);
      _currentIndex = 0; // Jump back to Active Lockers tab
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Purchase paused! Cooling-off timer activated.'),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  void _markAsSaved(String id) {
    setState(() {
      final index = _items.indexWhere((item) => item.id == id);
      if (index != -1) {
        _items[index].isSaved = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Awesome job! You saved money and beat the impulse.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _markAsPurchased(String id) {
    setState(() {
      final index = _items.indexWhere((item) => item.id == id);
      if (index != -1) {
        _items[index].isPurchased = true;
      }
    });
  }

  double get _totalSavedMoney {
    return _items
        .where((item) => item.isSaved)
        .fold(0.0, (sum, item) => sum + item.price);
  }

  void _updateWage(double newWage) {
    setState(() {
      _hourlyWage = newWage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ActiveLockersPage(
        items: _items.where((i) => !i.isSaved && !i.isPurchased).toList(),
        hourlyWage: _hourlyWage,
        onMarkSaved: _markAsSaved,
        onMarkPurchased: _markAsPurchased,
      ),
      AddItemPage(
        hourlyWage: _hourlyWage,
        onSave: _addItem,
      ),
      SavedVaultPage(
        items: _items.where((i) => i.isSaved).toList(),
        totalSaved: _totalSavedMoney,
        hourlyWage: _hourlyWage,
      ),
      SettingsPage(
        hourlyWage: _hourlyWage,
        onWageChanged: _updateWage,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.timer_outlined, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Pause & Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '\$${_totalSavedMoney.toStringAsFixed(0)} Saved',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.lock_clock),
            label: 'Lockers',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            label: 'Pause Item',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Saved Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Life Cost',
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// TAB 1: ACTIVE LOCKERS
// -------------------------------------------------------------
class ActiveLockersPage extends StatelessWidget {
  final List<ImpulseItem> items;
  final double hourlyWage;
  final Function(String) onMarkSaved;
  final Function(String) onMarkPurchased;

  const ActiveLockersPage({
    super.key,
    required this.items,
    required this.hourlyWage,
    required this.onMarkSaved,
    required this.onMarkPurchased,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.check_circle_outline, size: 80, color: Colors.teal),
              SizedBox(height: 16),
              Text(
                'No Impulses Locked!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Your spending impulse locker is clean. Whenever you feel like buying something online, add it here first to cool off!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cooling-Off Lockers',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Wait until the timer expires before making a buying decision.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final hoursWork = (item.price / (hourlyWage > 0 ? hourlyWage : 1)).toStringAsFixed(1);
              final remaining = item.remainingTime;
              final isUnlocked = item.isUnlocked;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.indigo.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item.category,
                              style: const TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: item.impulseScore > 60
                                  ? Colors.red.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Impulse Risk: ${item.impulseScore.toInt()}%',
                              style: TextStyle(
                                color: item.impulseScore > 60 ? Colors.red : Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '\$${item.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.schedule, size: 16, color: Colors.blueGrey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      'Cost: $hoursWork Work Hours',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUnlocked ? Colors.green.withOpacity(0.1) : Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isUnlocked ? Colors.green : Colors.amber.shade700,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isUnlocked ? Icons.lock_open : Icons.hourglass_top,
                              color: isUnlocked ? Colors.green : Colors.amber.shade800,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isUnlocked ? 'Cooldown Complete!' : 'Cooling Down...',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isUnlocked ? Colors.green.shade900 : Colors.amber.shade900,
                                    ),
                                  ),
                                  Text(
                                    isUnlocked
                                        ? 'You can now make a clear-headed decision.'
                                        : 'Time left: ${remaining.inHours}h ${remaining.inMinutes.remainder(60)}m',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isUnlocked ? Colors.green.shade800 : Colors.amber.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => onMarkSaved(item.id),
                              icon: const Icon(Icons.shield, color: Colors.white),
                              label: const Text('Resist & Save!'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () => onMarkPurchased(item.id),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Still Buy'),
                          ),
                        ],
                      )
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
}

// -------------------------------------------------------------
// TAB 2: ADD ITEM & IMPULSE EVALUATION
// -------------------------------------------------------------
class AddItemPage extends StatefulWidget {
  final double hourlyWage;
  final Function(ImpulseItem) onSave;

  const AddItemPage({
    super.key,
    required this.hourlyWage,
    required this.onSave,
  });

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();

  String _selectedCategory = 'Electronics';
  int _cooldownHours = 24;

  // Quiz Questions state
  bool _q1IsPlanned = false;
  bool _q2InBudget = false;
  bool _q3IsEmotional = true;
  bool _q4CanWaitAWeek = false;

  final List<String> _categories = [
    'Electronics',
    'Fashion',
    'Home',
    'Gaming',
    'Hobbies',
    'Food/Treat',
    'Other'
  ];

  double _calculateImpulseScore() {
    double score = 50.0;
    if (!_q1IsPlanned) score += 20;
    if (!_q2InBudget) score += 20;
    if (_q3IsEmotional) score += 15;
    if (!_q4CanWaitAWeek) score += 10;
    return score.clamp(0.0, 100.0);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final score = _calculateImpulseScore();

      final newItem = ImpulseItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        price: price,
        category: _selectedCategory,
        createdAt: DateTime.now(),
        cooldownHours: _cooldownHours,
        impulseScore: score,
      );

      widget.onSave(newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double currentPrice = double.tryParse(_priceController.text) ?? 0.0;
    final double hoursNeeded = currentPrice / (widget.hourlyWage > 0 ? widget.hourlyWage : 1.0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pause an Impulse Purchase',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Put a cooling-off timer before you click BUY!',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Item Name / Short Description',
                prefixIcon: Icon(Icons.shopping_bag_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter item title';
                return null;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    onChanged: (val) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Price (\$)',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) {
                      if (val == null || double.tryParse(val) == null) return 'Enter valid price';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: _categories.map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (currentPrice > 0)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigo.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.work_history, color: Colors.indigo),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Life Cost Conversion:',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          Text(
                            'This costs ${hoursNeeded.toStringAsFixed(1)} hours of your hard labor.',
                            style: const TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'Cooling-Off Period',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [24, 48, 72, 168].map((hours) {
                final isSelected = _cooldownHours == hours;
                final label = hours >= 168 ? '1 Week' : '${hours}h';
                return ChoiceChip(
                  label: Text(label),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _cooldownHours = hours);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Impulse Score Diagnostic',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              color: Colors.grey.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Was this purchase planned for over a week?'),
                      value: _q1IsPlanned,
                      onChanged: (val) => setState(() => _q1IsPlanned = val),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Is this item strictly within your monthly discretionary budget?'),
                      value: _q2InBudget,
                      onChanged: (val) => setState(() => _q2InBudget = val),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Are you buying because of excitement, stress, or boredom?'),
                      value: _q3IsEmotional,
                      onChanged: (val) => setState(() => _q3IsEmotional = val),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Could you comfortably live without this for 30 days?'),
                      value: _q4CanWaitAWeek,
                      onChanged: (val) => setState(() => _q4CanWaitAWeek = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.lock_clock, color: Colors.white),
                label: const Text(
                  'LOCK THIS ITEM & PAUSE',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// TAB 3: SAVED VAULT & COMPOUND SIMULATOR
// -------------------------------------------------------------
class SavedVaultPage extends StatelessWidget {
  final List<ImpulseItem> items;
  final double totalSaved;
  final double hourlyWage;

  const SavedVaultPage({
    super.key,
    required this.items,
    required this.totalSaved,
    required this.hourlyWage,
  });

  @override
  Widget build(BuildContext context) {
    final double totalHoursSaved = totalSaved / (hourlyWage > 0 ? hourlyWage : 1.0);
    // 7% annual interest compound calculation for 5 years
    final double fiveYearInvestment = totalSaved * 1.4025;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.teal, Colors.teal, Colors.green],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Money Saved',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${totalSaved.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Saved ${totalHoursSaved.toStringAsFixed(1)} Work Hours',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.trending_up, color: Colors.indigo),
                      SizedBox(width: 8),
                      Text(
                        'Future Investment Value',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'If you invested this \$${totalSaved.toStringAsFixed(0)} in an index fund (7% annual return):',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCompoundCard('In 1 Year', '\$${(totalSaved * 1.07).toStringAsFixed(0)}'),
                      _buildCompoundCard('In 5 Years', '\$${fiveYearInvestment.toStringAsFixed(0)}'),
                      _buildCompoundCard('In 10 Years', '\$${(totalSaved * 1.967).toStringAsFixed(0)}'),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Resisted Purchases Victory Log',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: Text(
                  'No saved purchases yet. Beat your first impulse timer!',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                  title: Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(item.category),
                  trailing: Text(
                    '+\$${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCompoundCard(String label, String amount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// TAB 4: LIFE COST CALCULATOR & WAGE SETTINGS
// -------------------------------------------------------------
class SettingsPage extends StatefulWidget {
  final double hourlyWage;
  final Function(double) onWageChanged;

  const SettingsPage({
    super.key,
    required this.hourlyWage,
    required this.onWageChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _wageController;
  final TextEditingController _customItemPriceController = TextEditingController();
  double _testPrice = 100.0;

  @override
  void initState() {
    super.initState();
    _wageController = TextEditingController(text: widget.hourlyWage.toStringAsFixed(2));
    _customItemPriceController.text = _testPrice.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final double calculatedHours = _testPrice / (widget.hourlyWage > 0 ? widget.hourlyWage : 1.0);
    final double calculatedDays = calculatedHours / 8.0; // 8-hr workdays

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Life Cost Engine Settings',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Set your net hourly earnings to convert prices into actual life hours worked.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Hourly Net Income',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _wageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.monetization_on),
                            labelText: 'Hourly Rate (\$/hr)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          final newWage = double.tryParse(_wageController.text) ?? widget.hourlyWage;
                          widget.onWageChanged(newWage);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Hourly rate updated!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        ),
                        child: const Text('Update'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Instant Life Cost Simulator',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _customItemPriceController,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() {
                        _testPrice = double.tryParse(val) ?? 0.0;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Test Price Tag (\$)',
                      prefixIcon: Icon(Icons.shopping_cart),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'To pay for this item, you must work:',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${calculatedHours.toStringAsFixed(1)} Work Hours',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Equivalent to ~${calculatedDays.toStringAsFixed(1)} full 8-hour working days.',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}