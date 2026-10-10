import 'package:flutter/material.dart';

void main() {
  runApp(const OverDeckApp());
}

class OverDeckApp extends StatelessWidget {
  const OverDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverDeck Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
          surface: const Color(0xFF1E293B),
        ),
        cardTheme: const CardTheme(
          color: Color(0xFF1E293B),
          elevation: 4,
        ),
      ),
      home: const MainDeckScreen(),
    );
  }
}

class MainDeckScreen extends StatefulWidget {
  const MainDeckScreen({super.key});

  @override
  State<MainDeckScreen> createState() => _MainDeckScreenState();
}

class _MainDeckScreenState extends State<MainDeckScreen> {
  int _currentIndex = 0;
  
  // Floating overlay bubble state
  Offset _bubblePosition = const Offset(20, 120);
  bool _isBubbleExpanded = false;
  String _activeContext = 'Focus Work';
  String _notificationBanner = 'Smart Companion Ready';

  // State for Decision Engine
  final TextEditingController _optionAController = TextEditingController(text: 'Buy New Tech Gadget');
  final TextEditingController _optionBController = TextEditingController(text: 'Save for Vacation');
  int _scoreA = 3;
  int _scoreB = 4;
  String _decisionResult = 'Tap Analyze to compare options';

  // State for Price-to-Life-Hours Calculator
  double _hourlyIncome = 25.0;
  double _productCost = 120.0;

  // State for Stash Clips
  final List<String> _quickClips = [
    'Wi-Fi Key: FlowDeck_Guest_99',
    'Meeting Note: Review Q3 UI designs on Friday',
    'Shopping item: Ergonomic Desk Mat',
  ];
  final TextEditingController _newClipController = TextEditingController();

  // State for Ambient Visualizer
  bool _isPlayingAmbient = false;
  String _currentSound = 'Rain & Thunder';

  void _showNotification(String msg) {
    setState(() {
      _notificationBanner = msg;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Tab View
            IndexedStack(
              index: _currentIndex,
              children: [
                _buildDashboardTab(),
                _buildDecisionTab(),
                _buildValueCalcTab(),
                _buildClipStashTab(),
                _buildAmbientTab(),
              ],
            ),

            // Simulated Floating Banner Notification
            Positioned(
              top: 10,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black87,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt, color: Colors.amber, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _notificationBanner,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      onTap: () => _showNotification('Context updated to $_activeContext'),
                      child: const Icon(Icons.refresh, color: Colors.white70, size: 18),
                    )
                  ],
                ),
              ),
            ),

            // Interactive Dragable Floating Overlay Assistant
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubblePosition += details.delta;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _isBubbleExpanded ? 240 : 56,
                  height: _isBubbleExpanded ? 180 : 56,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(_isBubbleExpanded ? 20 : 28),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black87,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: _isBubbleExpanded
                      ? SingleChildScrollView(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Deck Overlay',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.close, color: Colors.white, size: 18),
                                    onPressed: () {
                                      setState(() {
                                        _isBubbleExpanded = false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const Divider(color: Colors.white70, height: 12),
                              Text(
                                'Mode: $_activeContext',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: [
                                  ChoiceChip(
                                    label: const Text('Focus', style: TextStyle(fontSize: 10)),
                                    selected: _activeContext == 'Focus Work',
                                    onSelected: (val) {
                                      setState(() {
                                        _activeContext = 'Focus Work';
                                        _showNotification('Switched to Focus Mode');
                                      });
                                    },
                                  ),
                                  ChoiceChip(
                                    label: const Text('Chill', style: TextStyle(fontSize: 10)),
                                    selected: _activeContext == 'Relaxing',
                                    onSelected: (val) {
                                      setState(() {
                                        _activeContext = 'Relaxing';
                                        _showNotification('Switched to Relax Mode');
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo,
                                  minimumSize: const Size(double.infinity, 30),
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  _showNotification('Quick Stash copied to overlay clipboard');
                                },
                                child: const Text('Quick Copy Last Clip', style: TextStyle(fontSize: 11, color: Colors.white)),
                              )
                            ],
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.widgets, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _isBubbleExpanded = true;
                            });
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.shuffle), label: 'Decide'),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: 'Value Calc'),
          BottomNavigationBarItem(icon: Icon(Icons.content_paste), label: 'Stash'),
          BottomNavigationBarItem(icon: Icon(Icons.graphic_eq), label: 'Ambient'),
        ],
      ),
    );
  }

  // --- TAB 1: DASHBOARD OVERVIEW ---
  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Companion Feed',
            style: TextStyle(fontSize: 22, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Your active micro-decision & dynamic dynamic context deck.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Context Banner Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.indigo,
                    child: Icon(Icons.flash_on, color: Colors.amber),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Active Mode',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          _activeContext,
                          style: const TextStyle(fontSize: 16, FontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      _showNotification('Overlay Companion Active');
                    },
                    child: const Text('Sync Overlay', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Micro Stats Grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Quick Clips Saved', '${_quickClips.length}', Icons.content_copy, Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Ambient Status', _isPlayingAmbient ? 'Playing' : 'Paused', Icons.music_note, Colors.purple),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Practical Micro Tip Card
          Card(
            color: const Color(0xFF0F172A),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.teal, width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Micro-Decision Advice',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'When stuck on a daily dilemma, compare true cost against your hourly work wage in the Value Calc tab before buying!',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: const Size(double.infinity, 38),
                    ),
                    onPressed: () {
                      setState(() {
                        _currentIndex = 1;
                      });
                    },
                    icon: const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                    label: const Text('Open Decision Matrix', style: TextStyle(color: Colors.white, fontSize: 12)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String val, IconData icon, Color accent) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: 22),
          const SizedBox(height: 8),
          Text(val, style: const TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.white)),
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  // --- TAB 2: MICRO DECISION ENGINE ---
  Widget _buildDecisionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Decision Matrix',
            style: TextStyle(fontSize: 22, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Solve indecision with real weighted evaluation.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Option A Box
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Option A', style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _optionAController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Option Title',
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Priority Weight: ', style: TextStyle(fontSize: 12, color: Colors.white70)),
                      Expanded(
                        child: Slider(
                          value: _scoreA.toDouble(),
                          min: 1,
                          max: 5,
                          divisions: 4,
                          activeColor: Colors.teal,
                          label: '$_scoreA',
                          onChanged: (v) => setState(() => _scoreA = v.toInt()),
                        ),
                      ),
                      Text('$_scoreA / 5', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Option B Box
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Option B', style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _optionBController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Option Title',
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Priority Weight: ', style: TextStyle(fontSize: 12, color: Colors.white70)),
                      Expanded(
                        child: Slider(
                          value: _scoreB.toDouble(),
                          min: 1,
                          max: 5,
                          divisions: 4,
                          activeColor: Colors.amber,
                          label: '$_scoreB',
                          onChanged: (v) => setState(() => _scoreB = v.toInt()),
                        ),
                      ),
                      Text('$_scoreB / 5', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    setState(() {
                      if (_scoreA > _scoreB) {
                        _decisionResult = 'Recommendation: Focus on "${_optionAController.text}" (Higher weighted score)';
                      } else if (_scoreB > _scoreA) {
                        _decisionResult = 'Recommendation: Choose "${_optionBController.text}" (Higher weighted score)';
                      } else {
                        _decisionResult = 'Tied Evaluation! Flip a micro-coin or re-weight options.';
                      }
                      _showNotification('Decision Evaluated!');
                    });
                  },
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text('Evaluate Options', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                style: IconButton.styleFrom(backgroundColor: const Color(0xFF1E293B)),
                icon: const Icon(Icons.shuffle, color: Colors.tealAccent),
                onPressed: () {
                  setState(() {
                    final winner = (_scoreA >= _scoreB) ? _optionAController.text : _optionBController.text;
                    _decisionResult = 'Random Selector Picked: $winner';
                  });
                },
              )
            ],
          ),
          const SizedBox(height: 16),

          // Result Card
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.indigo.withOpacity(0.5)),
            ),
            child: Text(
              _decisionResult,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  // --- TAB 3: VALUE VS WORK HOURS CALCULATOR ---
  Widget _buildValueCalcTab() {
    double hoursNeeded = _productCost / (_hourlyIncome > 0 ? _hourlyIncome : 1.0);
    double daysNeeded = hoursNeeded / 8.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price-To-Life Cost Engine',
            style: TextStyle(fontSize: 22, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Calculate how many real working life-hours an item actually costs.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Hourly Income: \$${_hourlyIncome.toStringAsFixed(1)}/hr',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Slider(
                    value: _hourlyIncome,
                    min: 5,
                    max: 200,
                    divisions: 39,
                    activeColor: Colors.teal,
                    label: '\$${_hourlyIncome.toInt()}',
                    onChanged: (v) => setState(() => _hourlyIncome = v),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Target Purchase Price: \$${_productCost.toStringAsFixed(1)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Slider(
                    value: _productCost,
                    min: 10,
                    max: 2000,
                    divisions: 199,
                    activeColor: Colors.amber,
                    label: '\$${_productCost.toInt()}',
                    onChanged: (v) => setState(() => _productCost = v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Output Cards
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                const Text(
                  'TRUE WORKING COST',
                  style: TextStyle(fontSize: 11, color: Colors.grey, letterSpacing: 1),
                ),
                const SizedBox(height: 8),
                Text(
                  '${hoursNeeded.toStringAsFixed(1)} Working Hours',
                  style: const TextStyle(fontSize: 24, FontWeight: FontWeight.bold, color: Colors.tealAccent),
                ),
                const SizedBox(height: 4),
                Text(
                  'Equivalent to ~${daysNeeded.toStringAsFixed(1)} full work days of life energy.',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(double.infinity, 36),
                  ),
                  onPressed: () {
                    _showNotification('Saved trade-off: \$${_productCost.toInt()} = ${hoursNeeded.toStringAsFixed(1)} hrs work');
                  },
                  child: const Text('Save Trade-Off Note', style: TextStyle(color: Colors.white, fontSize: 12)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // --- TAB 4: QUICK CLIP & TEXT STASH ---
  Widget _buildClipStashTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick-Clip Stash',
            style: TextStyle(fontSize: 22, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Save temporary text, links, and snippets for dynamic fast access.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Input Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _newClipController,
                  decoration: const InputDecoration(
                    hintText: 'Type fast clip or note...',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onPressed: () {
                  if (_newClipController.text.trim().isNotEmpty) {
                    setState(() {
                      _quickClips.insert(0, _newClipController.text.trim());
                      _newClipController.clear();
                    });
                    _showNotification('New Clip Added to Stash!');
                  }
                },
                child: const Icon(Icons.add, color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 16),

          // ListView of Clips
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _quickClips.length,
            itemBuilder: (context, index) {
              final clip = _quickClips[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  dense: true,
                  title: Text(
                    clip,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.content_copy, color: Colors.tealAccent, size: 18),
                        onPressed: () {
                          _showNotification('Copied snippet to clipboard');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey, size: 18),
                        onPressed: () {
                          setState(() {
                            _quickClips.removeAt(index);
                          });
                          _showNotification('Clip Removed');
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  // --- TAB 5: AMBIENT SOUNDSCAPE & SCREEN REFRESH ---
  Widget _buildAmbientTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ambient Studio & Refresh',
            style: TextStyle(fontSize: 22, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Keep ambient focus sound running in background while working.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(
                    _isPlayingAmbient ? Icons.graphic_eq : Icons.music_note,
                    size: 48,
                    color: _isPlayingAmbient ? Colors.tealAccent : Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _currentSound,
                    style: const TextStyle(fontSize: 16, FontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isPlayingAmbient ? 'Playing Ambient Flow...' : 'Paused',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isPlayingAmbient ? Colors.deepOrange : Colors.teal,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPlayingAmbient = !_isPlayingAmbient;
                          });
                          _showNotification(_isPlayingAmbient ? 'Ambient Audio Started' : 'Ambient Audio Paused');
                        },
                        icon: Icon(_isPlayingAmbient ? Icons.pause : Icons.play_arrow, color: Colors.white),
                        label: Text(_isPlayingAmbient ? 'Pause' : 'Play Ambient', style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Soundscape Preset',
            style: TextStyle(fontSize: 14, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Rain & Thunder',
              'Deep Focus Noise',
              'Cafe Ambiance',
              'Forest Stream',
            ].map((preset) {
              final isSelected = _currentSound == preset;
              return ChoiceChip(
                label: Text(preset),
                selected: isSelected,
                selectedColor: Colors.teal,
                onSelected: (val) {
                  setState(() {
                    _currentSound = preset;
                    _isPlayingAmbient = true;
                  });
                  _showNotification('Playing Preset: $preset');
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Micro Eye-Rescue Interactive Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.visibility, color: Colors.tealAccent, size: 20),
                    SizedBox(width: 8),
                    Text(
                      '20-20-20 Screen Eye Refresh',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Look at an object 20 feet away for 20 seconds to reduce screen fatigue.',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 36),
                  ),
                  onPressed: () {
                    _showNotification('Eye Refresh Pulse Triggered! Look away for 20s');
                  },
                  child: const Text('Start 20s Eye Break', style: TextStyle(color: Colors.tealAccent, fontSize: 12)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}