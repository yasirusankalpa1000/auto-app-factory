import 'package:flutter/material.dart';

void main() {
  runApp(const PulseChoiceApp());
}

class PulseChoiceApp extends StatelessWidget {
  const PulseChoiceApp({super.key});

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'PulseChoice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const MainDashboardScreen(),
    );
  }
}

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _currentIndex = 0;

  // Shared User State
  double _hourlyWage = 25.0; // Default \$25/hr
  double _totalMoneySaved = 145.50;
  int _impulsesPrevented = 8;
  bool _isFloatingWidgetEnabled = true;

  final List<Map<String, dynamic>> _savedItems = [
    {
      'name': 'Wireless Headphones',
      'cost': 89.99,
      'hours': 3.6,
      'date': 'Yesterday',
      'status': 'Prevented'
    },
    {
      'name': 'Late Night Takeout',
      'cost': 32.50,
      'hours': 1.3,
      'date': '3 days ago',
      'status': 'Prevented'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildValueRadarTab(context),
      _buildImpulseVaultTab(context),
      _buildDecisionWizardTab(context),
      _buildOverlayControlTab(context),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.flash_on, color: Colors.amber),
            const SizedBox(width: 8),
            const Text(
              'PulseChoice',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.green, size: 18),
                const SizedBox(width: 4),
                Text(
                  '\$${_totalMoneySaved.toStringAsFixed(2)} Saved',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: pages[_currentIndex],
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
            icon: Icon(Icons.calculate),
            label: 'Wage Radar',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_esports),
            label: 'Impulse Game',
          ),
          NavigationDestination(
            icon: Icon(Icons.help_outline),
            label: 'Decision Tree',
          ),
          NavigationDestination(
            icon: Icon(Icons.widgets),
            label: 'Smart Dock',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: WORK WAGE vs IMPULSE RADAR ---
  Widget _buildValueRadarTab(BuildContext context) {
    final itemController = TextEditingController();
    final costController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Card(
            color: Colors.teal,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Work-Hours Cost Evaluator',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Convert instant purchases into real working hours of your life before tapping buy.',
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Hourly Wage: \$${_hourlyWage.toStringAsFixed(2)}/hr',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                        onPressed: () => _showWageDialog(context),
                        icon: const Icon(Icons.edit, size: 14),
                        label: const Text('Edit Wage', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Calculate Quick Impulse Cost',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: itemController,
            decoration: const InputDecoration(
              labelText: 'What do you want to buy or do?',
              hintText: 'e.g. Designer Sneakers, Coffee Combo',
              prefixIcon: Icon(Icons.shopping_cart),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: costController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Price (\$) address',
              hintText: 'e.g. 79.99',
              prefixIcon: Icon(Icons.monetization_on),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final name = itemController.text.trim();
                final cost = double.tryParse(costController.text.trim()) ?? 0.0;
                if (name.isNotEmpty && cost > 0) {
                  _showAnalysisModal(context, name, cost);
                }
              },
              icon: const Icon(Icons.search),
              label: const Text('Convert to Working Hours', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Impulse Vault Items',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${_savedItems.length} Saved',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _savedItems.length,
            itemBuilder: (ctx, idx) {
              final item = _savedItems[idx];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.withOpacity(0.2),
                    child: const Icon(Icons.check, color: Colors.teal),
                  ),
                  title: Text(
                    item['name'].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Saved \$${item['cost']} (${item['hours']} hrs of labor saved)',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item['status'].toString(),
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- TAB 2: IMPULSE VAULT & INTERACTIVE MINI-GAME HUB ---
  Widget _buildImpulseVaultTab(BuildContext context) {
    return const ImpulseCoolDownGame();
  }

  // --- TAB 3: MULTI-STEP DECISION WIZARD ---
  Widget _buildDecisionWizardTab(BuildContext context) {
    return const DecisionWizardWidget();
  }

  // --- TAB 4: SIMULATED SMART FLOATING DOCK CONTROL ---
  Widget _buildOverlayControlTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.indigo,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Screen Overlay & Quick Dock',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Keep PulseChoice ready while browsing shopping apps or social media.',
                    style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Floating Quick Bar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Display above apps for fast cost checks', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    value: _isFloatingWidgetEnabled,
                    activeColor: Colors.amber,
                    onChanged: (val) {
                      setState(() {
                        _isFloatingWidgetEnabled = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Live Floating Bar Preview',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text(
                  'Interactive Dock Preview (Simulated)',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.teal.withOpacity(0.3), blurRadius: 10, spreadRadius: 2),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.flash_on, color: Colors.amber, size: 20),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Impulse Guard',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                        onPressed: () {},
                        child: const Text('Test Cost', style: TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'Quick Statistics',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildStatCard('Total Saved', '\$${_totalMoneySaved.toStringAsFixed(2)}', Colors.green, Icons.monetization_on),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Impulses Blocked', '$_impulsesPrevented Times', Colors.orange, Icons.shield),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  // --- DIALOGS & MODALS ---
  void _showWageDialog(BuildContext context) {
    final wageController = TextEditingController(text: _hourlyWage.toStringAsFixed(2));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set Your Hourly Wage'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your net hourly earning (or total monthly salary divided by 160 hrs).',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: wageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Hourly Wage (\$/hr)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newWage = double.tryParse(wageController.text.trim()) ?? _hourlyWage;
              setState(() {
                _hourlyWage = newWage;
              });
              Navigator.pop(ctx);
            },
            child: const Text('Save Wage'),
          ),
        ],
      ),
    );
  }

  void _showAnalysisModal(BuildContext context, String item, double cost) {
    final hoursRequired = cost / _hourlyWage;
    final workDays = hoursRequired / 8.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '\$${cost.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                ],
              ),
              const Divider(height: 24),

              Text(
                'This purchase costs you:',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            hoursRequired.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                          ),
                          const Text('Work Hours', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            workDays.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                          const Text('Full Work Days', style: TextStyle(fontSize: 12)),
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
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.teal),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Is "$item" worth working ${hoursRequired.toStringAsFixed(1)} hours at your desk?',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('I Still Bought It'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _savedItems.insert(0, {
                            'name': item,
                            'cost': cost,
                            'hours': double.parse(hoursRequired.toStringAsFixed(1)),
                            'date': 'Just now',
                            'status': 'Prevented'
                          });
                          _totalMoneySaved += cost;
                          _impulsesPrevented += 1;
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Great job! \$${cost.toStringAsFixed(2)} added to your saved vault.')),
                        );
                      },
                      child: const Text('Lock in Vault'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// --- WIDGET: INTERACTIVE IMPULSE COOL-DOWN MINI GAME ---
class ImpulseCoolDownGame extends StatefulWidget {
  const ImpulseCoolDownGame({super.key});

  @override
  State<ImpulseCoolDownGame> createState() => _ImpulseCoolDownGameState();
}

class _ImpulseCoolDownGameState extends State<ImpulseCoolDownGame> {
  int _score = 0;
  int _target = 10;
  bool _gameStarted = false;
  int _tapsRemaining = 10;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.purple,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '1-Minute Impulse Cool-Down Game',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Scientific research shows waiting 60 seconds with active focus reduces impulse spending by up to 75%.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          if (!_gameStarted)
            Center(
              child: Column(
                children: [
                  const Icon(Icons.sports_esports, size: 64, color: Colors.purple),
                  const SizedBox(height: 12),
                  const Text(
                    'Feeling an urge to spend or over-eat?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Complete the quick 10-tap mindfulness challenge to pass the impulse urge.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      setState(() {
                        _gameStarted = true;
                        _score = 0;
                        _tapsRemaining = _target;
                      });
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Cool-Down Challenge'),
                  ),
                ],
              ),
            )
          else if (_tapsRemaining > 0)
            Column(
              children: [
                LinearProgressIndicator(
                  value: (_target - _tapsRemaining) / _target,
                  color: Colors.purple,
                  backgroundColor: Colors.purple.withOpacity(0.2),
                  minHeight: 10,
                ),
                const SizedBox(height: 20),
                Text(
                  'Tap the Target: $_tapsRemaining Left!',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _score += 1;
                      _tapsRemaining -= 1;
                    });
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.purple.withOpacity(0.4), blurRadius: 16, spreadRadius: 4),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.touch_app, size: 48, color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          else
            Center(
              child: Column(
                children: [
                  const Icon(Icons.stars, color: Colors.amber, size: 64),
                  const SizedBox(height: 12),
                  const Text(
                    'Urge Neutralized!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Your brain dopamine spike has leveled off. Do you still truly need that purchase?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _gameStarted = false;
                      });
                    },
                    child: const Text('Return to Radar'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// --- WIDGET: DECISION WIZARD ---
class DecisionWizardWidget extends StatefulWidget {
  const DecisionWizardWidget({super.key});

  @override
  State<DecisionWizardWidget> createState() => _DecisionWizardWidgetState();
}

class _DecisionWizardWidgetState extends State<DecisionWizardWidget> {
  int _step = 0;
  int _score = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Will you use or need this 30 days from today?',
      'options': [
        {'text': 'Yes, absolutely essential', 'pts': 2},
        {'text': 'Maybe occasionally', 'pts': 1},
        {'text': 'Probably forgotten about', 'pts': 0},
      ]
    },
    {
      'question': 'Can you pay for 3x the price of this right now without debt?',
      'options': [
        {'text': 'Yes easily', 'pts': 2},
        {'text': 'Just barely', 'pts': 1},
        {'text': 'No, it stretches my budget', 'pts': 0},
      ]
    },
    {
      'question': 'Are you currently stressed, bored, or hungry?',
      'options': [
        {'text': 'No, totally calm & clear', 'pts': 2},
        {'text': 'Slightly bored/tired', 'pts': 1},
        {'text': 'Yes, emotional spending trigger', 'pts': 0},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.blueGrey,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smart Micro-Decision Tree',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Answer 3 quick psychological checks to determine if an action is worth taking.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          if (_step < _questions.length) ...[
            Text(
              'Step ${_step + 1} of ${_questions.length}',
              style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _questions[_step]['question'].toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...(_questions[_step]['options'] as List<Map<String, dynamic>>).map((opt) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    alignment: Alignment.centerLeft,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      _score += opt['pts'] as int;
                      _step += 1;
                    });
                  },
                  child: Text(
                    opt['text'].toString(),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              );
            }).toList(),
          ] else ...[
            Center(
              child: Column(
                children: [
                  Icon(
                    _score >= 4 ? Icons.check_circle : Icons.warning,
                    color: _score >= 4 ? Colors.green : Colors.orange,
                    size: 64,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _score >= 4 ? 'Verdict: Smart Purchase / Action' : 'Verdict: Skip or Delay 24 Hours',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _score >= 4 ? Colors.green : Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _score >= 4
                        ? 'Your responses show high necessity and financial readiness.'
                        : 'Your responses suggest this is likely an emotional impulse urge.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _step = 0;
                        _score = 0;
                      });
                    },
                    child: const Text('Evaluate Another Item'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}