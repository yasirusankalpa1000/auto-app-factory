import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const ShiftWiseApp());
}

class ShiftWiseApp extends StatelessWidget {
  const ShiftWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShiftWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121420),
        cardTheme: CardTheme(
          color: const Color(0xFF1E2235),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Global State across tabs
  double _hourlyWage = 22.50;
  double _totalSavedMoney = 185.00;

  // Vault Items
  final List<VaultItem> _vaultItems = [
    VaultItem(
      id: '1',
      title: 'Wireless Earbuds',
      price: 89.99,
      hoursRequired: 4.0,
      addedTime: DateTime.now().subtract(const Duration(hours: 14)),
    ),
    VaultItem(
      id: '2',
      title: 'Designer Sneakers',
      price: 140.00,
      hoursRequired: 6.2,
      addedTime: DateTime.now().subtract(const Duration(hours: 22)),
    ),
  ];

  // Pantry Items
  final List<PantryItem> _pantryItems = [
    PantryItem(name: 'Fresh Milk', daysLeft: 2, category: 'Dairy'),
    PantryItem(name: 'Avocados', daysLeft: 1, category: 'Produce'),
    PantryItem(name: 'Artisan Bread', daysLeft: 3, category: 'Bakery'),
  ];

  void _addVaultItem(String name, double price) {
    setState(() {
      final hours = _hourlyWage > 0 ? price / _hourlyWage : 0.0;
      _vaultItems.add(
        VaultItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: name,
          price: price,
          hoursRequired: hours,
          addedTime: DateTime.now(),
        ),
      );
    });
  }

  void _resolveVaultItem(VaultItem item, bool savedMoney) {
    setState(() {
      _vaultItems.removeWhere((element) => element.id == item.id);
      if (savedMoney) {
        _totalSavedMoney += item.price;
      }
    });
  }

  void _addPantryItem(String name, int days, String cat) {
    setState(() {
      _pantryItems.add(PantryItem(name: name, daysLeft: days, category: cat));
    });
  }

  void _removePantryItem(int index) {
    setState(() {
      _pantryItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ImpulseGuardPage(
        hourlyWage: _hourlyWage,
        totalSaved: _totalSavedMoney,
        vaultItems: _vaultItems,
        onWageChanged: (newWage) => setState(() => _hourlyWage = newWage),
        onAddItem: _addVaultItem,
        onResolveItem: _resolveVaultItem,
      ),
      const FocusFlowPage(),
      PantryRadarPage(
        items: _pantryItems,
        onAddItem: _addPantryItem,
        onRemoveItem: _removePantryItem,
      ),
      const MicroDecisionPage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white70, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (idx) => setState(() => _currentIndex = idx),
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF181B2A),
          selectedItemColor: Colors.indigoAccent,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.savings),
              label: 'Impulse Guard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              label: 'Focus Flow',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.kitchen),
              label: 'Expiry Radar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.psychology),
              label: 'Decision Studio',
            ),
          ],
        ),
      ),
    );
  }
}

// ================= TAB 1: IMPULSE GUARD =================
class ImpulseGuardPage extends StatefulWidget {
  final double hourlyWage;
  final double totalSaved;
  final List<VaultItem> vaultItems;
  final ValueChanged<double> onWageChanged;
  final Function(String, double) onAddItem;
  final Function(VaultItem, bool) onResolveItem;

  const ImpulseGuardPage({
    super.key,
    required this.hourlyWage,
    required this.totalSaved,
    required this.vaultItems,
    required this.onWageChanged,
    required this.onAddItem,
    required this.onResolveItem,
  });

  @override
  State<ImpulseGuardPage> createState() => _ImpulseGuardPageState();
}

class _ImpulseGuardPageState extends State<ImpulseGuardPage> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _wageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _wageController.text = widget.hourlyWage.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _itemController.dispose();
    _priceController.dispose();
    _wageController.dispose();
    super.dispose();
  }

  void _showAddModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E2235),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            top: 24,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Evaluate Impulse Purchase',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _itemController,
                decoration: const InputDecoration(
                  labelText: 'Item Name (e.g., Coffee Maker)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Price (\$)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    final name = _itemController.text.trim();
                    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
                    if (name.isNotEmpty && price > 0) {
                      widget.onAddItem(name, price);
                      _itemController.clear();
                      _priceController.clear();
                      Navigator.pop(ctx);
                    }
                  },
                  icon: const Icon(Icons.lock_clock, color: Colors.white),
                  label: const Text(
                    'Put into 24h Cool-Down',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Stats Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Impulse Shield',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Think before you buy',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.teal),
                          ),
                          child: Text(
                            'Saved: \$${widget.totalSaved.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.tealAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24, color: Colors.white70),
                    Row(
                      children: [
                        const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Hourly Wage Rate (\$):',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ),
                        SizedBox(
                          width: 90,
                          height: 36,
                          child: TextField(
                            controller: _wageController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 13, color: Colors.white),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (val) {
                              final w = double.tryParse(val) ?? 0.0;
                              widget.onWageChanged(w);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quick Wage Cost Estimator
            const Text(
              'Quick Work-Hour Calculator',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enter Item Cost to see Life Cost:',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          FittedBox(
                            child: Text(
                              widget.hourlyWage > 0
                                  ? '100 \$ Purchase = ${(100 / widget.hourlyWage).toStringAsFixed(1)} Work Hours'
                                  : 'Please set hourly wage above',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.amberAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _showAddModal,
                      child: const Text('Add Item', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Cool-Down Vault Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '24-Hour Cool-Down Vault',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  '${widget.vaultItems.length} active',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (widget.vaultItems.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2235),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.tealAccent, size: 40),
                    SizedBox(height: 8),
                    Text(
                      'Vault is empty! You are keeping impulse buys at zero.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.vaultItems.length,
                itemBuilder: (ctx, idx) {
                  final item = widget.vaultItems[idx];
                  final hoursElapsed = DateTime.now().difference(item.addedTime).inHours;
                  final hoursLeft = max(0, 24 - hoursElapsed);
                  final progress = (hoursElapsed / 24.0).clamp(0.0, 1.0);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
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
                                  item.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amberAccent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                'Costs ${item.hoursRequired.toStringAsFixed(1)} hrs of your labor',
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                              const Spacer(),
                              Text(
                                hoursLeft > 0 ? '$hoursLeft hrs cooldown left' : 'Cooldown finished!',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: hoursLeft > 0 ? Colors.orangeAccent : Colors.greenAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white70,
                            color: hoursLeft > 0 ? Colors.indigoAccent : Colors.tealAccent,
                            minHeight: 6,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.redAccent),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                onPressed: () => widget.onResolveItem(item, false),
                                child: const Text(
                                  'Bought It anyway',
                                  style: TextStyle(color: Colors.redAccent, fontSize: 11),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                onPressed: () => widget.onResolveItem(item, true),
                                child: const Text(
                                  'Saved \$ Money!',
                                  style: TextStyle(color: Colors.white, fontSize: 11),
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
}

class VaultItem {
  final String id;
  final String title;
  final double price;
  final double hoursRequired;
  final DateTime addedTime;

  VaultItem({
    required this.id,
    required this.title,
    required this.price,
    required this.hoursRequired,
    required this.addedTime,
  });
}

// ================= TAB 2: FOCUS FLOW =================
class FocusFlowPage extends StatefulWidget {
  const FocusFlowPage({super.key});

  @override
  State<FocusFlowPage> createState() => _FocusFlowPageState();
}

class _FocusFlowPageState extends State<FocusFlowPage> with SingleTickerProviderStateMixin {
  int _secondsRemaining = 25 * 60;
  int _totalDuration = 25 * 60;
  bool _isRunning = false;
  Timer? _timer;
  String _selectedPreset = 'Rainstorm Focus';

  late AnimationController _animController;

  final Map<String, IconData> _soundPresets = {
    'Rainstorm Focus': Icons.water_drop,
    'Cozy Cafe': Icons.coffee,
    'Deep Forest': Icons.park,
    'Lo-Fi Space': Icons.stars,
  };

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_secondsRemaining > 0) {
          setState(() => _secondsRemaining--);
        } else {
          _timer?.cancel();
          setState(() => _isRunning = false);
        }
      });
    }
  }

  void _resetTimer(int minutes) {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _totalDuration = minutes * 60;
      _secondsRemaining = minutes * 60;
    });
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _totalDuration > 0 ? _secondsRemaining / _totalDuration : 0.0;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Header
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Focus Soundscape & Timer',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'Keep open while working or studying',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Icon(Icons.volume_up, color: Colors.indigoAccent),
              ],
            ),
            const SizedBox(height: 24),

            // Soundscape Selector Wrap
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAxisAlignment.center,
              children: _soundPresets.keys.map((preset) {
                final isSelected = _selectedPreset == preset;
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_soundPresets[preset], size: 16, color: isSelected ? Colors.white : Colors.grey),
                      const SizedBox(width: 6),
                      Text(preset),
                    ],
                  ),
                  selected: isSelected,
                  selectedColor: Colors.indigoAccent,
                  backgroundColor: const Color(0xFF1E2235),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedPreset = preset);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 30),

            // Animated Focus Visualizer Circle
            AnimatedBuilder(
              animation: _animController,
              builder: (ctx, child) {
                final pulse = _isRunning ? _animController.value * 12.0 : 0.0;
                return Container(
                  width: 220 + pulse,
                  height: 220 + pulse,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.indigoAccent.withOpacity(0.3),
                        Colors.indigo.withOpacity(0.05),
                      ],
                    ),
                    boxShadow: _isRunning
                        ? [
                            BoxShadow(
                              color: Colors.indigoAccent.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _soundPresets[_selectedPreset],
                          size: 32,
                          color: _isRunning ? Colors.amberAccent : Colors.grey,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatTime(_secondsRemaining),
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isRunning ? 'AUDIO FLOW ACTIVE' : 'PAUSED',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _isRunning ? Colors.tealAccent : Colors.grey,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.white70,
                  color: Colors.indigoAccent,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Timer Preset Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPresetButton('15m', 15),
                const SizedBox(width: 8),
                _buildPresetButton('25m', 25),
                const SizedBox(width: 8),
                _buildPresetButton('45m', 45),
                const SizedBox(width: 8),
                _buildPresetButton('60m', 60),
              ],
            ),
            const SizedBox(height: 24),

            // Start / Stop Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isRunning ? Colors.orangeAccent : Colors.teal,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: _toggleTimer,
              icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow, color: Colors.white),
              label: Text(
                _isRunning ? 'Pause Session' : 'Start Focus Audio',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),

            // Ambient Quote
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  children: const [
                    Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '"Deep work is the ability to focus without distraction on a demanding task."',
                        style: TextStyle(fontSize: 12, color: Colors.white70, fontStyle: FontStyle.italic),
                      ),
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

  Widget _buildPresetButton(String label, int mins) {
    final isCurrent = _totalDuration == mins * 60;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: isCurrent ? Colors.indigoAccent : Colors.white70),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onPressed: () => _resetTimer(mins),
      child: Text(
        label,
        style: TextStyle(color: isCurrent ? Colors.indigoAccent : Colors.white70, fontSize: 12),
      ),
    );
  }
}

// ================= TAB 3: PANTRY & RESOURCE EXPIRY RADAR =================
class PantryRadarPage extends StatefulWidget {
  final List<PantryItem> items;
  final Function(String, int, String) onAddItem;
  final Function(int) onRemoveItem;

  const PantryRadarPage({
    super.key,
    required this.items,
    required this.onAddItem,
    required this.onRemoveItem,
  });

  @override
  State<PantryRadarPage> createState() => _PantryRadarPageState();
}

class _PantryRadarPageState extends State<PantryRadarPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  String _selectedCat = 'Produce';

  @override
  void dispose() {
    _nameController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  void _showAddModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E2235),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            top: 24,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Track Micro-Expiry Item',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name (e.g., Organic Eggs)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _daysController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Days Left Until Expiry',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    final name = _nameController.text.trim();
                    final days = int.tryParse(_daysController.text.trim()) ?? 1;
                    if (name.isNotEmpty) {
                      widget.onAddItem(name, days, _selectedCat);
                      _nameController.clear();
                      _daysController.clear();
                      Navigator.pop(ctx);
                    }
                  },
                  icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                  label: const Text(
                    'Add to Expiry Radar',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expiry Radar',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'Stop food & subscription waste before it happens',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                FloatingActionButton.small(
                  backgroundColor: Colors.indigoAccent,
                  onPressed: _showAddModal,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Summary Chip
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2235),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: Colors.tealAccent, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${widget.items.where((e) => e.daysLeft <= 2).length} items require urgent consumption!',
                      style: const TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (widget.items.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2235),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.kitchen, color: Colors.grey, size: 40),
                    SizedBox(height: 8),
                    Text(
                      'No items being tracked. Tap + to add items!',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.items.length,
                itemBuilder: (ctx, idx) {
                  final item = widget.items[idx];
                  Color statusColor = Colors.teal;
                  if (item.daysLeft <= 1) {
                    statusColor = Colors.redAccent;
                  } else if (item.daysLeft <= 3) {
                    statusColor = Colors.orangeAccent;
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: statusColor.withOpacity(0.2),
                        child: Icon(
                          item.daysLeft <= 1 ? Icons.warning : Icons.fastfood,
                          color: statusColor,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      subtitle: Text(
                        'Category: ${item.category}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: statusColor),
                            ),
                            child: Text(
                              '${item.daysLeft}d left',
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.tealAccent, size: 20),
                            onPressed: () => widget.onRemoveItem(idx),
                            tooltip: 'Mark Consumed',
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
}

class PantryItem {
  final String name;
  final int daysLeft;
  final String category;

  PantryItem({required this.name, required this.daysLeft, required this.category});
}

// ================= TAB 4: MICRO-DECISION STUDIO =================
class MicroDecisionPage extends StatefulWidget {
  const MicroDecisionPage({super.key});

  @override
  State<MicroDecisionPage> createState() => _MicroDecisionPageState();
}

class _MicroDecisionPageState extends State<MicroDecisionPage> {
  final List<String> _options = [
    'Cook Leftovers at Home',
    'Order Healthy Salad',
    'Quick 20-Min Workout',
    'Power Nap (15 Mins)',
  ];

  final TextEditingController _optionController = TextEditingController();
  String? _selectedResult;
  bool _isSpinning = false;

  @override
  void dispose() {
    _optionController.dispose();
    super.dispose();
  }

  void _addOption() {
    final text = _optionController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _options.add(text);
        _optionController.clear();
      });
    }
  }

  void _spinDecision() {
    if (_options.isEmpty) return;
    setState(() {
      _isSpinning = true;
      _selectedResult = null;
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      final rand = Random();
      setState(() {
        _selectedResult = _options[rand.nextInt(_options.length)];
        _isSpinning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Micro-Decision Studio',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  'Eliminate daily option fatigue instantly',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Decision Spinner Result Box
            Card(
              color: const Color(0xFF181B2A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.indigoAccent, width: 1),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      'DECISION RESOLVER',
                      style: TextStyle(
                        color: Colors.indigoAccent,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isSpinning)
                      const CircularProgressIndicator(color: Colors.indigoAccent)
                    else
                      Text(
                        _selectedResult ?? 'Tap below to resolve options!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _selectedResult != null ? 20 : 14,
                          fontWeight: FontWeight.bold,
                          color: _selectedResult != null ? Colors.amberAccent : Colors.grey,
                        ),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: _spinDecision,
                      icon: const Icon(Icons.casino, color: Colors.white),
                      label: const Text('Resolve For Me', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Options Input Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _optionController,
                    decoration: const InputDecoration(
                      hintText: 'Add dilemma choice...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _addOption,
                  child: const Text('Add', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Active Choices Chips
            const Text(
              'Current Dilemma Options:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAxisAlignment.center,
              children: _options.asMap().entries.map((entry) {
                final idx = entry.key;
                final opt = entry.value;
                return Chip(
                  backgroundColor: const Color(0xFF1E2235),
                  label: Text(opt, style: const TextStyle(color: Colors.white, fontSize: 12)),
                  deleteIcon: const Icon(Icons.close, size: 14, color: Colors.grey),
                  onDeleted: () {
                    setState(() {
                      _options.removeAt(idx);
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}