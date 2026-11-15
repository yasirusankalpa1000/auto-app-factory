import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const DockPulseApp());
}

class DockPulseApp extends StatelessWidget {
  const DockPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DockPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF12131C),
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
    FloatingOverlayTab(),
    DecisionEngineTab(),
    SnippetVaultTab(),
    PulseAnalyticsTab(),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E1E2C),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Floating Dock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Decide Hub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: 'Quick Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.speed),
            label: 'Pulse Score',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 1: FLOATING OVERLAY & QUICK UTILITY DOCK
// -----------------------------------------------------------------------------
class FloatingOverlayTab extends StatefulWidget {
  const FloatingOverlayTab({super.key});

  @override
  State<FloatingOverlayTab> createState() => _FloatingOverlayTabState();
}

class _FloatingOverlayTabState extends State<FloatingOverlayTab> {
  bool _overlayEnabled = true;
  bool _notificationAlerts = true;
  double _dockOpacity = 0.9;
  Offset _dockPosition = const Offset(20, 120);

  // Quick Calculator state
  String _calcDisplay = '0';
  double _firstNum = 0;
  String _operator = '';
  bool _shouldClear = false;

  void _onCalcBtn(String val) {
    setState(() {
      if (val == 'C') {
        _calcDisplay = '0';
        _firstNum = 0;
        _operator = '';
      } else if (val == '+' || val == '-' || val == 'x' || val == '/') {
        _firstNum = double.tryParse(_calcDisplay) ?? 0;
        _operator = val;
        _shouldClear = true;
      } else if (val == '=') {
        double secondNum = double.tryParse(_calcDisplay) ?? 0;
        double result = 0;
        if (_operator == '+') result = _firstNum + secondNum;
        if (_operator == '-') result = _firstNum - secondNum;
        if (_operator == 'x') result = _firstNum * secondNum;
        if (_operator == '/') {
          result = secondNum != 0 ? _firstNum / secondNum : 0;
        }
        _calcDisplay = result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 2);
        _operator = '';
      } else {
        if (_calcDisplay == '0' || _shouldClear) {
          _calcDisplay = val;
          _shouldClear = false;
        } else {
          _calcDisplay += val;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12131C),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildStatusCard(),
                  const SizedBox(height: 20),
                  const Text(
                    'Quick Dock Settings & Permissions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  _buildPermissionsCard(),
                  const SizedBox(height: 20),
                  const Text(
                    'Instant Screen Calculator',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  _buildMiniCalculator(),
                  const SizedBox(height: 80),
                ],
              ),
            ),

            // Simulated Floating Widget Overlay
            if (_overlayEnabled)
              Positioned(
                left: _dockPosition.dx,
                top: _dockPosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _dockPosition += details.delta;
                    });
                  },
                  child: Opacity(
                    opacity: _dockOpacity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ],
                        border: Border.all(color: Colors.tealAccent, width: 1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.drag_indicator, color: Colors.white70, size: 20),
                          const SizedBox(width: 8),
                          const Icon(Icons.flash_on, color: Colors.amber, size: 20),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Floating Pulse Bar',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Quick Dock Action Activated!'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.tealAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.touch_app, color: Colors.black, size: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'DockPulse Utility',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 4),
              Text(
                'System-Wide Floating Helper Hub',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.info, color: Colors.tealAccent),
          onPressed: () {
            showAboutDialog(
              context: context,
              applicationName: 'DockPulse',
              applicationVersion: 'v2.4.0',
              children: [
                const Text('DockPulse provides floating micro-tools and decision tools for high daily productivity.'),
              ],
            );
          },
        )
      ],
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.layers, color: Colors.tealAccent),
                  SizedBox(width: 10),
                  Text(
                    'Floating Overlay Dock',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
              Switch(
                value: _overlayEnabled,
                activeColor: Colors.tealAccent,
                onChanged: (val) {
                  setState(() {
                    _overlayEnabled = val;
                  });
                },
              ),
            ],
          ),
          const Divider(color: Colors.white70, height: 20),
          Row(
            children: [
              const Text('Opacity:', style: TextStyle(color: Colors.white70)),
              Expanded(
                child: Slider(
                  value: _dockOpacity,
                  min: 0.3,
                  max: 1.0,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() {
                      _dockOpacity = val;
                    });
                  },
                ),
              ),
              Text('${(_dockOpacity * 100).toInt()}%', style: const TextStyle(color: Colors.white)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPermissionsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Display Above Apps (System Overlay)',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
              Chip(
                label: Text(_overlayEnabled ? 'Active' : 'Disabled'),
                backgroundColor: _overlayEnabled ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                labelStyle: TextStyle(color: _overlayEnabled ? Colors.green : Colors.red, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Smart Micro Notification Alerts',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
              Switch(
                value: _notificationAlerts,
                activeColor: Colors.tealAccent,
                onChanged: (val) {
                  setState(() {
                    _notificationAlerts = val;
                  });
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCalculator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _calcDisplay,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.tealAccent),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              '7', '8', '9', '/',
              '4', '5', '6', 'x',
              '1', '2', '3', '-',
              'C', '0', '=', '+'
            ].map((btn) {
              bool isOp = ['/', 'x', '-', '+', '='].contains(btn);
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOp ? Colors.teal.withOpacity(0.3) : const Color(0xFF2A2A3D),
                  foregroundColor: isOp ? Colors.tealAccent : Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () => _onCalcBtn(btn),
                child: Text(
                  btn,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 2: MICRO-DECISION & CHOICE MATRIX ENGINE
// -----------------------------------------------------------------------------
class DecisionEngineTab extends StatefulWidget {
  const DecisionEngineTab({super.key});

  @override
  State<DecisionEngineTab> createState() => _DecisionEngineTabState();
}

class _DecisionEngineTabState extends State<DecisionEngineTab> {
  final TextEditingController _choiceInputController = TextEditingController();
  final List<String> _choices = ['Healthy Meal', 'Quick Workout', 'Power Nap', 'Deep Focus Task', 'Micro Break'];
  String _selectedResult = 'Tap below to decide your next move!';
  bool _isDeciding = false;

  void _addChoice() {
    String text = _choiceInputController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _choices.add(text);
        _choiceInputController.clear();
      });
    }
  }

  void _removeChoice(int index) {
    if (_choices.length > 2) {
      setState(() {
        _choices.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keep at least 2 choices for a decision!')),
      );
    }
  }

  void _makeRandomDecision() {
    if (_choices.isEmpty) return;
    setState(() {
      _isDeciding = true;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      final random = Random();
      final picked = _choices[random.nextInt(_choices.length)];
      setState(() {
        _selectedResult = picked;
        _isDeciding = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Decision Engine',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Eliminate daily decision fatigue instantly.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Result Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade900, Colors.teal.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.tealAccent.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                const Icon(Icons.lightbulb, color: Colors.amber, size: 40),
                const SizedBox(height: 10),
                const Text(
                  'OPTIMAL NEXT CHOICE:',
                  style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _isDeciding ? 'Analyzing parameters...' : _selectedResult,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                  ),
                  softWrap: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _isDeciding ? null : _makeRandomDecision,
                  icon: const Icon(Icons.shuffle),
                  label: const Text('DECIDE FOR ME NOW'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            'Your Active Options Pool',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          // Input Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _choiceInputController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Add new option...',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Color(0xFF1E1E2C),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _addChoice,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Options Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: List.generate(_choices.length, (index) {
              return Chip(
                label: Text(_choices[index], style: const TextStyle(color: Colors.white)),
                backgroundColor: const Color(0xFF2A2A3D),
                deleteIcon: const Icon(Icons.delete, size: 16, color: Colors.redAccent),
                onDeleted: () => _removeChoice(index),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 3: FAST TEXT & CLIPBOARD VAULT
// -----------------------------------------------------------------------------
class SnippetVaultTab extends StatefulWidget {
  const SnippetVaultTab({super.key});

  @override
  State<SnippetVaultTab> createState() => _SnippetVaultTabState();
}

class _SnippetVaultTabState extends State<SnippetVaultTab> {
  final List<Map<String, String>> _snippets = [
    {'title': 'Standard Email Sign-off', 'content': 'Best regards,\nSent from my DockPulse Assistant'},
    {'title': 'Social Hashtag Bundle', 'content': '#Productivity #DailyTech #FlutterDev #SmartUtility #LifeHack'},
    {'title': 'Quick Bank Details', 'content': 'Account: 1234-5678-9012 | Swift: PULSEUS22'},
    {'title': 'Micro-Break Reminder', 'content': 'Drink 250ml water, stretch for 2 minutes, reset posture!'},
  ];

  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _contentCtrl = TextEditingController();

  void _addSnippet() {
    if (_titleCtrl.text.isNotEmpty && _contentCtrl.text.isNotEmpty) {
      setState(() {
        _snippets.add({
          'title': _titleCtrl.text.trim(),
          'content': _contentCtrl.text.trim(),
        });
        _titleCtrl.clear();
        _contentCtrl.clear();
      });
      Navigator.pop(context);
    }
  }

  void _showAddModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Snippet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Title / Label',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contentCtrl,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Snippet Content',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addSnippet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                ),
                child: const Text('SAVE SNIPPET'),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12131C),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddModal,
        backgroundColor: Colors.tealAccent,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              'Quick Snippet Vault',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap any card to instantly copy text for daily use.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            ..._snippets.map((snip) {
              return Card(
                color: const Color(0xFF1E1E2C),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: Colors.white70),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    snip['title'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      snip['content'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.content_copy, color: Colors.tealAccent),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Copied: "${snip['title']}"'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 4: DAILY PULSE & FOCUS ENGAGEMENT ANALYTICS
// -----------------------------------------------------------------------------
class PulseAnalyticsTab extends StatefulWidget {
  const PulseAnalyticsTab({super.key});

  @override
  State<PulseAnalyticsTab> createState() => _PulseAnalyticsTabState();
}

class _PulseAnalyticsTabState extends State<PulseAnalyticsTab> {
  int _microTaskCount = 7;
  double _energyLevel = 0.8;
  double _screenBudgetHours = 4.5;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Pulse Score',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Track your daily efficiency and micro-goal performance.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Pulse Gauge Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Today\'s Pulse Rating', style: TextStyle(color: Colors.white70)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'HIGH PERFORMANCE',
                        style: TextStyle(color: Colors.tealAccent, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 130,
                      height: 130,
                      child: CircularProgressIndicator(
                        value: (_microTaskCount / 10).clamp(0.1, 1.0),
                        strokeWidth: 12,
                        backgroundColor: Colors.white70,
                        color: Colors.tealAccent,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(_microTaskCount * 12.5).toInt()}%',
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const Text('Efficiency', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMiniStat('Tasks Met', '$_microTaskCount/10', Icons.check_circle),
                    _buildMiniStat('Est. Saved', '42 min', Icons.schedule),
                    _buildMiniStat('Ad Rewards', '\$1.20', Icons.monetization_on),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'Interactive Energy & Budget Check',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),

          // Interactive Energy Controls
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Current Energy Meter:', style: TextStyle(color: Colors.white)),
                    Text('${(_energyLevel * 100).toInt()}%', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: _energyLevel,
                  min: 0.1,
                  max: 1.0,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() {
                      _energyLevel = val;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Daily Utility Hours:', style: TextStyle(color: Colors.white)),
                    Text('${_screenBudgetHours.toStringAsFixed(1)} hrs', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: _screenBudgetHours,
                  min: 0.5,
                  max: 12.0,
                  activeColor: Colors.amber,
                  onChanged: (val) {
                    setState(() {
                      _screenBudgetHours = val;
                    });
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _microTaskCount = (_microTaskCount + 1).clamp(0, 10);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pulse Score updated successfully!')),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Log Completed Micro-Goal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.tealAccent, size: 22),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}