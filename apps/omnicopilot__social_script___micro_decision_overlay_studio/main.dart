import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const OmniCopilotApp());
}

class OmniCopilotApp extends StatelessWidget {
  const OmniCopilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniCopilot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121218),
        primaryColor: Colors.indigoAccent,
        useMaterial3: true,
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

  final List<Widget> _pages = const [
    ScriptStudioTab(),
    ImpulseGuardTab(),
    DilemmaMatrixTab(),
    FloatingHudSimTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1A1A24),
        indicatorColor: Colors.indigoAccent,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline, color: Colors.white70),
            selectedIcon: Icon(Icons.chat_bubble, color: Colors.white),
            label: 'Script Studio',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.account_balance_wallet, color: Colors.white),
            label: 'Impulse Guard',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.psychology, color: Colors.white),
            label: 'Dilemma Solver',
          ),
          NavigationDestination(
            icon: Icon(Icons.layers_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.layers, color: Colors.white),
            label: 'Floating HUD',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 1. SOCIAL SCRIPT STUDIO TAB
// -----------------------------------------------------------------------------
class ScriptStudioTab extends StatefulWidget {
  const ScriptStudioTab({super.key});

  @override
  State<ScriptStudioTab> createState() => _ScriptStudioTabState();
}

class _ScriptStudioTabState extends State<ScriptStudioTab> {
  String _selectedCategory = 'Declining Plans';
  double _assertiveness = 0.5; // 0 = Gentle, 1 = Firm
  double _formality = 0.5; // 0 = Casual, 1 = Professional

  final Map<String, List<String>> _scenarios = {
    'Declining Plans': [
      "I appreciate the invite so much! I'm completely drained this week, so I need to take a raincheck. Have an amazing time!",
      "Thanks for thinking of me! I won't be able to make it this time due to prior commitments. Let's touch base next week.",
      "I'm laid low today and need some quiet downtime. I'll have to pass today, but thanks for asking!"
    ],
    'Asking for Pay Rise': [
      "I'd love to schedule a brief chat this week to review my recent project accomplishments and discuss aligning my compensation with my current responsibilities.",
      "Given my added responsibilities over the past year, I believe it's time to re-evaluate my baseline compensation. Can we discuss this on Tuesday?",
      "I have consistently delivered strong results recently. I would like to review my overall salary scale in our upcoming performance check."
    ],
    'Boundary Setting': [
      "I'm currently focused on high-priority tasks and won't be able to take on extra requests right now. Thanks for understanding!",
      "I need to log off after 6 PM today to attend to personal matters. I will follow up on this first thing tomorrow morning.",
      "I prefer to keep our discussion focused on work deliverables. Let's stick to the current agenda items."
    ],
    'Late Reply Apology': [
      "Thanks for your patience! Things got quite crazy over here, but I wanted to make sure I gave your message proper attention.",
      "Apologies for the delay in getting back to you. Here is the information you requested!",
      "Hey! Sorry for keeping you hanging—just catching up on my inbox now. Let's resolve this right away."
    ],
  };

  String _generatedScript = "";

  @override
  void initState() {
    super.initState();
    _updateScript();
  }

  void _updateScript() {
    final list = _scenarios[_selectedCategory] ?? [];
    if (list.isEmpty) return;

    if (_assertiveness < 0.4) {
      _generatedScript = list[0];
    } else if (_assertiveness > 0.7) {
      _generatedScript = list[1];
    } else {
      _generatedScript = list[2];
    }

    if (_formality > 0.7) {
      _generatedScript = "[Formal Tone] $_generatedScript";
    } else if (_formality < 0.3) {
      _generatedScript = "[Casual Tone] $_generatedScript";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.chat_bubble, color: Colors.indigoAccent, size: 28),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Social Script Studio',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Craft perfect text messages for awkward situations in seconds.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Category Chips
          const Text('Select Situation:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _scenarios.keys.map((cat) {
              final isSelected = cat == _selectedCategory;
              return ChoiceChip(
                label: Text(cat, style: TextStyle(color: isSelected ? Colors.white : Colors.grey)),
                selected: isSelected,
                selectedColor: Colors.indigoAccent,
                backgroundColor: const Color(0xFF1E1E2C),
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      _selectedCategory = cat;
                      _updateScript();
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Tone Adjusters
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Directness / Firmness', style: TextStyle(fontSize: 13, color: Colors.white)),
                    Text(_assertiveness > 0.6 ? 'Firm' : 'Gentle', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: _assertiveness,
                  activeColor: Colors.indigoAccent,
                  onChanged: (v) {
                    setState(() {
                      _assertiveness = v;
                      _updateScript();
                    });
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Formality', style: TextStyle(fontSize: 13, color: Colors.white)),
                    Text(_formality > 0.6 ? 'Formal' : 'Casual', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: _formality,
                  activeColor: Colors.teal,
                  onChanged: (v) {
                    setState(() {
                      _formality = v;
                      _updateScript();
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Generated Output Card
          const Text('Generated Script:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF252538),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.indigoAccent.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _generatedScript,
                  style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.white),
                  softWrap: true,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _generatedScript));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Script copied to clipboard!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.content_copy, size: 16),
                    label: const Text('Copy Response'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 2. IMPULSE PURCHASE REALITY GUARD TAB
// -----------------------------------------------------------------------------
class ImpulseGuardTab extends StatefulWidget {
  const ImpulseGuardTab({super.key});

  @override
  State<ImpulseGuardTab> createState() => _ImpulseGuardTabState();
}

class _ImpulseGuardTabState extends State<ImpulseGuardTab> {
  final TextEditingController _itemController = TextEditingController(text: 'Wireless Headphones');
  final TextEditingController _priceController = TextEditingController(text: '125.00');

  double _hourlyWage = 18.0;
  double _hoursPerDay = 8.0;

  @override
  void dispose() {
    _itemController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double price = double.tryParse(_priceController.text) ?? 0.0;
    double workHoursNeeded = price / (_hourlyWage > 0 ? _hourlyWage : 1);
    double workDaysNeeded = workHoursNeeded / (_hoursPerDay > 0 ? _hoursPerDay : 1);
    int coffeesEquivalent = (price / 4.5).round();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.shield, color: Colors.orangeAccent, size: 28),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Impulse Purchase Guard',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Calculate the true life-work price of impulse items before buying.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Inputs
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _itemController,
                  decoration: const InputDecoration(
                    labelText: 'Item / Want Description',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.shopping_bag_outlined),
                  ),
                  onChanged: (v) => setState(() {}),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price (\$)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  onChanged: (v) => setState(() {}),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Your Hourly Wage: \$${_hourlyWage.toStringAsFixed(0)}/hr',
                        style: const TextStyle(fontSize: 13, color: Colors.white)),
                  ],
                ),
                Slider(
                  value: _hourlyWage,
                  min: 5,
                  max: 150,
                  activeColor: Colors.orangeAccent,
                  onChanged: (v) => setState(() => _hourlyWage = v),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Reality Breakdown Card
          const Text('Life Cost Trade-off:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E1C2B), Color(0xFF1E1E2C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orangeAccent.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _itemController.text.isEmpty ? 'This Item' : _itemController.text,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildStatCard('Hours of Work', '${workHoursNeeded.toStringAsFixed(1)} hrs', Icons.access_time),
                    _buildStatCard('Full Work Days', '${workDaysNeeded.toStringAsFixed(1)} days', Icons.calendar_today),
                    _buildStatCard('Coffee Trade-off', '$coffeesEquivalent cups', Icons.local_cafe),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          workHoursNeeded > 10
                              ? 'High Impulse Risk! Consider waiting 48 hours before purchasing.'
                              : 'Moderate cost. Fits within standard discretionary buffer.',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String val, IconData icon) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF121218),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orangeAccent, size: 18),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 2),
          Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. DILEMMA MATRIX SOLVER TAB
// -----------------------------------------------------------------------------
class DilemmaMatrixTab extends StatefulWidget {
  const DilemmaMatrixTab({super.key});

  @override
  State<DilemmaMatrixTab> createState() => _DilemmaMatrixTabState();
}

class _DilemmaMatrixTabState extends State<DilemmaMatrixTab> {
  final TextEditingController _dilemmaController =
      TextEditingController(text: 'Should I attend tonight\'s networking party?');

  double _excitement = 0.6;
  double _energyCost = 0.7;
  double _futureBenefit = 0.8;
  double _regretIfMissed = 0.4;

  @override
  void dispose() {
    _dilemmaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Decision Score Formula
    double totalScore = (_excitement * 25) + (_futureBenefit * 35) + (_regretIfMissed * 20) - (_energyCost * 30);
    String decision = "Proceed / Do It!";
    Color decisionColor = Colors.green;

    if (totalScore < 15) {
      decision = "Skip / Say No";
      decisionColor = Colors.redAccent;
    } else if (totalScore < 35) {
      decision = "Sleep On It / Delay 24h";
      decisionColor = Colors.amber;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.psychology, color: Colors.tealAccent, size: 28),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Micro-Dilemma Matrix',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Objective 30-second scoring matrix to eliminate overthinking.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Dilemma Text
          TextField(
            controller: _dilemmaController,
            decoration: const InputDecoration(
              labelText: 'What is your dilemma?',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.help_outline),
            ),
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 16),

          // Sliders
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              children: [
                _buildSliderRow('Genuine Excitement / Want', _excitement, Colors.pinkAccent, (v) => setState(() => _excitement = v)),
                _buildSliderRow('Energy / Stress Cost', _energyCost, Colors.deepOrangeAccent, (v) => setState(() => _energyCost = v)),
                _buildSliderRow('Long-Term Value / Benefit', _futureBenefit, Colors.tealAccent, (v) => setState(() => _futureBenefit = v)),
                _buildSliderRow('Regret If You Pass', _regretIfMissed, Colors.purpleAccent, (v) => setState(() => _regretIfMissed = v)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Output Decision Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: decisionColor),
            ),
            child: Column(
              children: [
                const Text('Matrix Recommendation:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 6),
                Text(
                  decision,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: decisionColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Calculated Clarity Index: ${totalScore.toStringAsFixed(0)} / 100',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSliderRow(String label, double val, Color color, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
            Text('${(val * 10).round()}/10', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
        Slider(
          value: val,
          activeColor: color,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 4. FLOATING HUD & NOTIFICATION OVERLAY SIMULATOR TAB
// -----------------------------------------------------------------------------
class FloatingHudSimTab extends StatefulWidget {
  const FloatingHudSimTab({super.key});

  @override
  State<FloatingHudSimTab> createState() => _FloatingHudSimTabState();
}

class _FloatingHudSimTabState extends State<FloatingHudSimTab> {
  Offset _bubblePosition = const Offset(20, 150);
  bool _isExpanded = false;
  String _activeBannerText = "OmniCopilot Guard: Active in background";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // Simulated Screen Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.layers, color: Colors.blueAccent, size: 28),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Floating Overlay HUD',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Preview and test system floating widgets & quick-action popups.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 20),

                // Control panel
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2C),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white70),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Overlay Permission Status:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(Icons.check_circle, color: Colors.green, size: 18),
                          SizedBox(width: 6),
                          Text('Display over other apps: SIMULATED ACTIVE', style: TextStyle(color: Colors.green, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                            onPressed: () {
                              setState(() {
                                _activeBannerText = "Quick Copilot: Shopping Guard Triggered!";
                              });
                            },
                            child: const Text('Trigger Guard Alert', style: TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _bubblePosition = const Offset(20, 150);
                              });
                            },
                            child: const Text('Reset HUD Position', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Context simulator banner box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A24),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Live Notification Preview', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.notifications_active, color: Colors.amber, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _activeBannerText,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Drag the floating bubble below anywhere on screen to test system responsiveness.',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Draggable Floating Bubble Overlay
          Positioned(
            left: _bubblePosition.dx,
            top: _bubblePosition.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _bubblePosition += details.delta;
                });
              },
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(_isExpanded ? 12 : 8),
                decoration: BoxDecoration(
                  color: Colors.indigoAccent,
                  borderRadius: BorderRadius.circular(_isExpanded ? 16 : 30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: _isExpanded
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.widgets, color: Colors.white, size: 18),
                              SizedBox(width: 6),
                              Text('Omni HUD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.indigo,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            ),
                            onPressed: () {
                              setState(() => _isExpanded = false);
                            },
                            icon: const Icon(Icons.flash_on, size: 14),
                            label: const Text('Quick Action', style: TextStyle(fontSize: 11)),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.touch_app, color: Colors.white, size: 22),
                          SizedBox(width: 4),
                          Text('Drag Me', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}