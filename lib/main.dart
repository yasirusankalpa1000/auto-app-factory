import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const LifeHUDApp());
}

class LifeHUDApp extends StatelessWidget {
  const LifeHUDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeHUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0E17),
      ),
      home: const MainHUDDashboard(),
    );
  }
}

class MainHUDDashboard extends StatefulWidget {
  const MainHUDDashboard({super.key});

  @override
  State<MainHUDDashboard> createState() => _MainHUDDashboardState();
}

class _MainHUDDashboardState extends State<MainHUDDashboard> {
  int _selectedTabIndex = 0;
  
  // Floating Bubble Overlay State
  Offset _bubblePosition = const Offset(20, 160);
  bool _isFloatingHudExpanded = false;
  
  // Active Context State
  String _activeContext = 'Deep Focus';
  final List<String> _contexts = ['Deep Focus', 'Rapid Execution', 'Creative Vibe', 'Rest & Reset'];
  
  // Quick Notes in HUD
  final List<String> _hudNotes = [
    'Drink 500ml water before 2 PM',
    'Send daily summary report',
    'Take 5 min deep breathing break'
  ];
  final TextEditingController _noteController = TextEditingController();

  // Micro-Decision Resolver State
  final List<String> _decisionOptions = ['Work on Priority Project', 'Take 10 Min Walk', 'Clean Workspace'];
  final TextEditingController _decisionInputController = TextEditingController();
  String? _resolvedDecision;

  // Friction Resolver State
  final TextEditingController _frictionController = TextEditingController();
  List<Map<String, dynamic>> _frictionSteps = [];
  bool _isAnalyzingFriction = false;

  // Ambient Engine State
  bool _isPulseActive = true;
  double _pulseSpeed = 1.5;
  String _activeVibeMode = 'Alpha Focus Waves (10 Hz)';

  @override
  void dispose() {
    _noteController.dispose();
    _decisionInputController.dispose();
    _frictionController.dispose();
    super.dispose();
  }

  void _addQuickNote() {
    if (_noteController.text.trim().isNotEmpty) {
      setState(() {
        _hudNotes.insert(0, _noteController.text.trim());
        _noteController.clear();
      });
    }
  }

  void _resolveDecision() {
    if (_decisionOptions.isEmpty) return;
    final random = Random();
    setState(() {
      _resolvedDecision = _decisionOptions[random.nextInt(_decisionOptions.length)];
    });
  }

  void _addDecisionOption() {
    if (_decisionInputController.text.trim().isNotEmpty) {
      setState(() {
        _decisionOptions.add(_decisionInputController.text.trim());
        _decisionInputController.clear();
      });
    }
  }

  void _analyzeFriction() {
    if (_frictionController.text.trim().isEmpty) return;
    setState(() {
      _isAnalyzingFriction = true;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      final task = _frictionController.text.trim();
      setState(() {
        _isAnalyzingFriction = false;
        _frictionSteps = [
          {'step': 'Micro Step 1: Clear desk & open "$task" in 30 sec', 'done': false},
          {'step': 'Micro Step 2: Work on "$task" for strictly 2 minutes', 'done': false},
          {'step': 'Micro Step 3: Evaluate friction rate (1-10) and continue', 'done': false},
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Body Pages
            Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedTabIndex,
                    children: [
                      _buildAmbientHUDTab(),
                      _buildDecisionResolverTab(),
                      _buildFrictionDeconstructorTab(),
                      _buildFloatingDeckSettingsTab(),
                    ],
                  ),
                ),
              ],
            ),

            // Draggable Floating Overlay Bubble Assistant
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
                    _isFloatingHudExpanded = !_isFloatingHudExpanded;
                  });
                },
                child: _buildFloatingBubbleWidget(),
              ),
            ),

            // Expanded Floating Dock Modal Overlay
            if (_isFloatingHudExpanded) _buildFloatingDockModal(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTabIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        backgroundColor: const Color(0xFF161524),
        indicatorColor: Colors.deepPurple,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.space_dashboard),
            label: 'Live HUD',
          ),
          NavigationDestination(
            icon: Icon(Icons.alt_route),
            label: 'Decide',
          ),
          NavigationDestination(
            icon: Icon(Icons.bolt),
            label: 'Friction',
          ),
          NavigationDestination(
            icon: Icon(Icons.layers),
            label: 'Deck & Float',
          ),
        ],
      ),
    );
  }

  // APP BAR
  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF161524),
        border: Border(bottom: BorderSide(color: Colors.white70)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.widgets, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LifeHUD Assist Deck',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Active Mode: $_activeContext',
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 14),
                SizedBox(width: 4),
                Text(
                  'HUD Active',
                  style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 1: AMBIENT HUD & PULSE ENGINE
  Widget _buildAmbientHUDTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Context Selector Chips
            const Text(
              'DYNAMIC CONTEXT MATRIX',
              style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _contexts.map((ctx) {
                  final isSelected = _activeContext == ctx;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(ctx),
                      selected: isSelected,
                      selectedColor: Colors.deepPurple,
                      backgroundColor: const Color(0xFF222035),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            _activeContext = ctx;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Live Visualizer Pulse Deck Widget
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF261F42), Color(0xFF161524)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ambient Brainwave Pulse',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              _activeVibeMode,
                              style: const TextStyle(color: Colors.teal, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isPulseActive = !_isPulseActive;
                          });
                        },
                        icon: Icon(
                          _isPulseActive ? Icons.pause_circle_filled : Icons.play_circle_fill,
                          color: Colors.deepPurpleAccent,
                          size: 36,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Animated Visual Waves Engine Simulation
                  SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(12, (index) {
                        double height = _isPulseActive
                            ? (20 + (index % 5) * 8 * _pulseSpeed).clamp(12.0, 56.0)
                            : 8.0;
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300 + (index * 40)),
                          width: 8,
                          height: height,
                          decoration: BoxDecoration(
                            color: isEvenIndex(index) ? Colors.deepPurpleAccent : Colors.tealAccent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.tune, color: Colors.grey, size: 16),
                      const SizedBox(width: 8),
                      const Text('Pulse Speed:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Expanded(
                        child: Slider(
                          value: _pulseSpeed,
                          min: 0.5,
                          max: 3.0,
                          activeColor: Colors.deepPurple,
                          onChanged: (val) {
                            setState(() {
                              _pulseSpeed = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Live Micro-Stats Board (Increases dwell time)
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Focus Dwell Time',
                    value: '42 mins',
                    icon: Icons.timer,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: 'Micro-Frictions Solved',
                    value: '8 Today',
                    icon: Icons.check_circle,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Quick Floating Scratchpad Deck
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1C2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.push_pin, color: Colors.amber, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Quick HUD Sticky Deck',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                      Text(
                        '${_hudNotes.length} pinned',
                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _noteController,
                          decoration: const InputDecoration(
                            hintText: 'Add quick pin note...',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _addQuickNote,
                        icon: const Icon(Icons.add_circle, color: Colors.deepPurple, size: 32),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._hudNotes.map((note) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF28253B),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.fiber_manual_record, color: Colors.teal, size: 8),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                note,
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                                softWrap: true,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _hudNotes.remove(note);
                                });
                              },
                              child: const Icon(Icons.close, color: Colors.grey, size: 16),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isEvenIndex(int i) => i % 2 == 0;

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1C2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: MICRO-DECISION RESOLVER MATRIX
  Widget _buildDecisionResolverTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MICRO-DECISION MATRIX',
              style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1),
            ),
            const SizedBox(height: 6),
            const Text(
              'Stuck on what to do next? Let HUD resolve your micro-paralysis.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 20),

            // Result Display Card
            if (_resolvedDecision != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.teal, Colors.deepPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.amber, size: 36),
                    const SizedBox(height: 10),
                    const Text(
                      'YOUR NEXT IMMEDIATE ACTION:',
                      style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _resolvedDecision!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                      softWrap: true,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _resolveDecision,
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Re-Spin Choice'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // Options Builder
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1C2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Active Decision Pool',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _decisionInputController,
                          decoration: const InputDecoration(
                            hintText: 'Add option (e.g., Eat Salad, Study, Nap)',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addDecisionOption,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _decisionOptions.map((option) {
                      return Chip(
                        label: Text(option),
                        backgroundColor: const Color(0xFF28253B),
                        labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                        deleteIcon: const Icon(Icons.cancel, size: 14, color: Colors.grey),
                        onDeleted: () {
                          setState(() {
                            _decisionOptions.remove(option);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _decisionOptions.isEmpty ? null : _resolveDecision,
                      icon: const Icon(Icons.bolt, color: Colors.amber),
                      label: const Text(
                        'RESOLVE DECISION NOW',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
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
          ],
        ),
      ),
    );
  }

  // TAB 3: TASK FRICTION DECONSTRUCTOR
  Widget _buildFrictionDeconstructorTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FRICTION DECONSTRUCTOR',
              style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1),
            ),
            const SizedBox(height: 6),
            const Text(
              'Type what you are resisting right now (e.g., "Doing taxes", "Starting workout").',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1C2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _frictionController,
                    decoration: const InputDecoration(
                      labelText: 'What task feels overwhelming?',
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      hintText: 'e.g. Write essay draft',
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isAnalyzingFriction ? null : _analyzeFriction,
                      icon: _isAnalyzingFriction
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.psychology),
                      label: Text(_isAnalyzingFriction ? 'Deconstructing Friction...' : 'Break Down Friction'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (_frictionSteps.isNotEmpty) ...[
              const Text(
                'YOUR 2-MINUTE FRICTION BREAKDOWN:',
                style: TextStyle(color: Colors.teal, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...List.generate(_frictionSteps.length, (index) {
                final item = _frictionSteps[index];
                final bool isDone = item['done'];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDone ? const Color(0xFF162521) : const Color(0xFF222035),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDone ? Colors.teal : Colors.white70),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: isDone,
                        activeColor: Colors.teal,
                        onChanged: (val) {
                          setState(() {
                            _frictionSteps[index]['done'] = val ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          item['step'],
                          style: TextStyle(
                            color: isDone ? Colors.grey : Colors.white,
                            decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                            fontSize: 13,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  // TAB 4: FLOATING DECK & PERMISSION CONTROL
  Widget _buildFloatingDeckSettingsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FLOATING OVERLAY & SYSTEM DECK CONTROL',
              style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1),
            ),
            const SizedBox(height: 16),

            // Permission & Active Float Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1C2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.layers, color: Colors.deepPurpleAccent),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Display Over Other Apps Permission',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Allows LifeHUD to stay active as a floating bubble assistant while you browse, study, or work on other apps.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Overlay Assistant Active', style: TextStyle(color: Colors.white, fontSize: 13)),
                      Switch(
                        value: true,
                        activeColor: Colors.teal,
                        onChanged: (val) {},
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white70, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Floating HUD Quick Bubble', style: TextStyle(color: Colors.white, fontSize: 13)),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Floating HUD position reset to top left.')),
                          );
                          setState(() {
                            _bubblePosition = const Offset(20, 160);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Reset Bubble'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Simulated Notification Launcher Test
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1C2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Floating Quick Notification Triggers',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Test how HUD dynamic alerts keep you aware during daily routines.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.notifications_active, size: 16, color: Colors.amber),
                        label: const Text('Test Hydration Alert'),
                        backgroundColor: const Color(0xFF28253B),
                        labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('HUD Alert: Drink 250ml water now to maintain mental clarity!'),
                              backgroundColor: Colors.deepPurple,
                            ),
                          );
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.bolt, size: 16, color: Colors.teal),
                        label: const Text('Test Context Shift Alert'),
                        backgroundColor: const Color(0xFF28253B),
                        labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('HUD Context: Time to shift from Deep Focus to Rest Mode.'),
                              backgroundColor: Colors.teal,
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FLOATING BUBBLE ASSISTANT (DRAGGABLE OVERLAY SIMULATION)
  Widget _buildFloatingBubbleWidget() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Colors.deepPurpleAccent, Colors.tealAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.5),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.touch_app,
          color: Colors.black87,
          size: 28,
        ),
      ),
    );
  }

  // EXPANDED FLOATING DOCK MODAL (WHEN BUBBLE IS TAPPED)
  Widget _buildFloatingDockModal() {
    return Positioned(
      left: (_bubblePosition.dx + 60).clamp(10.0, MediaQuery.of(context).size.width - 240),
      top: (_bubblePosition.dy).clamp(50.0, MediaQuery.of(context).size.height - 300),
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1D33),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.tealAccent.withOpacity(0.5)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black87,
                blurRadius: 16,
                spreadRadius: 4,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'HUD Floating Dock',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFloatingHudExpanded = false;
                      });
                    },
                    child: const Icon(Icons.close, color: Colors.grey, size: 16),
                  ),
                ],
              ),
              const Divider(color: Colors.white70),
              const SizedBox(height: 4),
              _buildFloatingDockItem(
                icon: Icons.lightbulb,
                label: 'Quick Decision Spin',
                onTap: () {
                  setState(() {
                    _isFloatingHudExpanded = false;
                    _selectedTabIndex = 1;
                  });
                },
              ),
              _buildFloatingDockItem(
                icon: Icons.bolt,
                label: 'Solve Task Friction',
                onTap: () {
                  setState(() {
                    _isFloatingHudExpanded = false;
                    _selectedTabIndex = 2;
                  });
                },
              ),
              _buildFloatingDockItem(
                icon: Icons.push_pin,
                label: 'View Sticky Deck (${_hudNotes.length})',
                onTap: () {
                  setState(() {
                    _isFloatingHudExpanded = false;
                    _selectedTabIndex = 0;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingDockItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.tealAccent, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}