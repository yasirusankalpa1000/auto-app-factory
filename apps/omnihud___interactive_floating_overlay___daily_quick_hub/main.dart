import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const OmniHUDApp());
}

class OmniHUDApp extends StatelessWidget {
  const OmniHUDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniHUD Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainHUDOverlayScreen(),
    );
  }
}

class SoundItem {
  final String name;
  final IconData icon;
  bool isPlaying;
  double volume;

  SoundItem({
    required this.name,
    required this.icon,
    this.isPlaying = false,
    this.volume = 0.5,
  });
}

class CanvasBubble {
  final String id;
  final String title;
  final IconData icon;
  Offset position;
  final Color color;

  CanvasBubble({
    required this.id,
    required this.title,
    required this.icon,
    required this.position,
    required this.color,
  });
}

class MainHUDOverlayScreen extends StatefulWidget {
  const MainHUDOverlayScreen({super.key});

  @override
  State<MainHUDOverlayScreen> createState() => _MainHUDOverlayScreenState();
}

class _MainHUDOverlayScreenState extends State<MainHUDOverlayScreen> {
  int _selectedIndex = 0;
  Timer? _sessionTimer;
  int _sessionSeconds = 0;
  bool _overlayPermissionEnabled = true;
  bool _floatingNotificationActive = true;
  double _hudOpacity = 0.9;

  // Soundscape State
  final List<SoundItem> _sounds = [
    SoundItem(name: 'Gentle Rain', icon: Icons.widgets, isPlaying: true, volume: 0.6),
    SoundItem(name: 'Ocean Waves', icon: Icons.waves, isPlaying: false, volume: 0.4),
    SoundItem(name: 'Cafe Ambience', icon: Icons.local_cafe, isPlaying: false, volume: 0.5),
    SoundItem(name: 'Night Crickets', icon: Icons.nights_stay, isPlaying: false, volume: 0.3),
    SoundItem(name: 'Cosmic Drone', icon: Icons.stars, isPlaying: false, volume: 0.7),
  ];

  // Draggable HUD Canvas Bubbles
  final List<CanvasBubble> _bubbles = [
    CanvasBubble(id: 'note', title: 'Sticky Note', icon: Icons.note, position: const Offset(30, 40), color: Colors.amber),
    CanvasBubble(id: 'calc', title: 'Quick Calc', icon: Icons.calculate, position: const Offset(200, 70), color: Colors.teal),
    CanvasBubble(id: 'decision', title: 'Choice Spinner', icon: Icons.touch_app, position: const Offset(40, 260), color: Colors.purple),
    CanvasBubble(id: 'sound', title: 'Audio Mixer', icon: Icons.volume_up, position: const Offset(200, 290), color: Colors.indigo),
  ];

  // Micro Notes
  final List<String> _stickyNotes = [
    'Buy groceries on the way home',
    'Meeting at 3:00 PM with design team',
    'Review project budget report \$250'
  ];
  final TextEditingController _noteController = TextEditingController();

  // Quick Math Split
  double _totalAmount = 50.0;
  int _splitCount = 2;
  double _tipPercentage = 15.0;

  // Decision Chooser
  final List<String> _decisionOptions = ['Pizza', 'Tacos', 'Sushi', 'Salad', 'Burger'];
  String _selectedDecision = 'Tap spin to choose!';
  final TextEditingController _optionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startSessionTimer();
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _noteController.dispose();
    _optionController.dispose();
    super.dispose();
  }

  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _sessionSeconds++;
        });
      }
    });
  }

  String _formatSessionTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _spinDecision() {
    if (_decisionOptions.isEmpty) return;
    final random = Random();
    setState(() {
      _selectedDecision = _decisionOptions[random.nextInt(_decisionOptions.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top HUD Bar Header
            _buildTopHUDHeader(),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  _buildInteractiveCanvasTab(),
                  _buildMicroToolsTab(),
                  _buildSoundscapeMixerTab(),
                  _buildSettingsAndStatsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          border: Border(top: BorderSide(color: Colors.indigo.withOpacity(0.3))),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: const Color(0xFF1E293B),
          selectedItemColor: Colors.cyan,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'HUD Canvas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              label: 'Micro Tools',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.volume_up),
              label: 'Soundscapes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'HUD Control',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHUDHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(Icons.layers, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'OmniHUD Floating Hub',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    _overlayPermissionEnabled ? 'Active Floating Mode' : 'Overlay Paused',
                    style: TextStyle(
                      fontSize: 11,
                      color: _overlayPermissionEnabled ? Colors.green : Colors.amber,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.cyan.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.cyan),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.schedule, size: 14, color: Colors.cyan),
                    const SizedBox(width: 4),
                    Text(
                      _formatSessionTime(_sessionSeconds),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.cyan),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 1: INTERACTIVE FLOATING CANVAS
  // ---------------------------------------------------------------------------
  Widget _buildInteractiveCanvasTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Colors.indigo),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Drag the floating HUD bubbles to customize your quick desktop interface. Tap any bubble to trigger instant actions.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade300),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Simulated Phone Screen Canvas
            Container(
              height: 420,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF020617),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blueGrey.withOpacity(0.5), width: 2),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10),
                ],
              ),
              child: Stack(
                children: [
                  // Canvas Grid Background Lines
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.1,
                      child: GridPaper(
                        color: Colors.cyan,
                        divisions: 2,
                        subDivisions: 2,
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 12,
                    left: 16,
                    child: Text(
                      'Floating Desktop Simulation Mode',
                      style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                  // Draggable Bubbles
                  ..._bubbles.map((bubble) {
                    return Positioned(
                      left: bubble.position.dx,
                      top: bubble.position.dy,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            double newX = (bubble.position.dx + details.delta.dx).clamp(10.0, 240.0);
                            double newY = (bubble.position.dy + details.delta.dy).clamp(30.0, 340.0);
                            bubble.position = Offset(newX, newY);
                          });
                        },
                        onTap: () {
                          _showBubbleDetailsDialog(bubble);
                        },
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _hudOpacity,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: bubble.color.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: bubble.color.withOpacity(0.4),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                              border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(bubble.icon, color: Colors.white, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  bubble.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.drag_handle, color: Colors.white70, size: 14),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Quick HUD Action Shortcuts',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickActionButton(
                    icon: Icons.note_add,
                    label: 'Add Sticky',
                    color: Colors.amber,
                    onTap: () => setState(() => _selectedIndex = 1),
                  ),
                  const SizedBox(width: 8),
                  _buildQuickActionButton(
                    icon: Icons.calculate,
                    label: 'Split Bill',
                    color: Colors.teal,
                    onTap: () => setState(() => _selectedIndex = 1),
                  ),
                  const SizedBox(width: 8),
                  _buildQuickActionButton(
                    icon: Icons.play_arrow,
                    label: 'Audio Focus',
                    color: Colors.indigo,
                    onTap: () => setState(() => _selectedIndex = 2),
                  ),
                  const SizedBox(width: 8),
                  _buildQuickActionButton(
                    icon: Icons.refresh,
                    label: 'Reset Positions',
                    color: Colors.red,
                    onTap: () {
                      setState(() {
                        _bubbles[0].position = const Offset(30, 40);
                        _bubbles[1].position = const Offset(200, 70);
                        _bubbles[2].position = const Offset(40, 260);
                        _bubbles[3].position = const Offset(200, 290);
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.2),
        foregroundColor: Colors.white,
        side: BorderSide(color: color.withOpacity(0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
      icon: Icon(icon, size: 16, color: color),
      label: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  void _showBubbleDetailsDialog(CanvasBubble bubble) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Row(
          children: [
            Icon(bubble.icon, color: bubble.color),
            const SizedBox(width: 8),
            Text(bubble.title, style: const TextStyle(color: Colors.white)),
          ],
        ),
        content: Text(
          'This is a active floating overlay widget for ${bubble.title}. You can interact with it on top of any active screen.',
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.cyan)),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 2: MICRO-TOOLS SUITE
  // ---------------------------------------------------------------------------
  Widget _buildMicroToolsTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Floating Sticky Notes Widget
            _buildStickyNotesSection(),
            const SizedBox(height: 20),
            // Quick Math & Tip Splitter
            _buildQuickMathSection(),
            const SizedBox(height: 20),
            // Decision Chooser Wheel
            _buildDecisionMatrixSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyNotesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.note, color: Colors.amber),
                  SizedBox(width: 8),
                  Text('Floating Sticky Bubbles', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: Text('${_stickyNotes.length} Saved', style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _noteController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(
                    hintText: 'Type quick floating note...',
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  if (_noteController.text.trim().isNotEmpty) {
                    setState(() {
                      _stickyNotes.add(_noteController.text.trim());
                      _noteController.clear();
                    });
                  }
                },
                icon: const Icon(Icons.add, color: Colors.amber),
                style: IconButton.styleFrom(backgroundColor: Colors.amber.withOpacity(0.2)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ..._stickyNotes.asMap().entries.map((entry) {
            int idx = entry.key;
            String note = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      note,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                    onPressed: () => setState(() => _stickyNotes.removeAt(idx)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuickMathSection() {
    double tipAmount = (_totalAmount * _tipPercentage) / 100;
    double grandTotal = _totalAmount + tipAmount;
    double perPerson = grandTotal / (_splitCount > 0 ? _splitCount : 1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calculate, color: Colors.teal),
              SizedBox(width: 8),
              Text('Instant Bill & Tip Splitter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Amount:', style: TextStyle(color: Colors.grey, fontSize: 13)),
              Text('\$${_totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 16)),
            ],
          ),
          Slider(
            value: _totalAmount,
            min: 5.0,
            max: 300.0,
            activeColor: Colors.teal,
            onChanged: (val) => setState(() => _totalAmount = val),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tip: ${_tipPercentage.toInt()}% (\$"${tipAmount.toStringAsFixed(2)}")', style: const TextStyle(color: Colors.grey, fontSize: 13)),
              Text('People: $_splitCount', style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _tipPercentage,
                  min: 0,
                  max: 30,
                  activeColor: Colors.cyan,
                  onChanged: (val) => setState(() => _tipPercentage = val),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.white),
                    onPressed: () {
                      if (_splitCount > 1) setState(() => _splitCount--);
                    },
                  ),
                  Text('$_splitCount', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () => setState(() => _splitCount++),
                  ),
                ],
              ),
            ],
          ),
          const Divider(color: Colors.blueGrey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Each Person Pays:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14)),
              Text(
                '\$${perPerson.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDecisionMatrixSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.touch_app, color: Colors.purple),
              SizedBox(width: 8),
              Text('Micro Decision Chooser', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                const Text('Selected Choice:', style: TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 4),
                Text(
                  _selectedDecision,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.purpleAccent),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _optionController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(
                    hintText: 'Add option (e.g. Work out)...',
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  if (_optionController.text.trim().isNotEmpty) {
                    setState(() {
                      _decisionOptions.add(_optionController.text.trim());
                      _optionController.clear();
                    });
                  }
                },
                icon: const Icon(Icons.add, color: Colors.purpleAccent),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _decisionOptions.map((opt) {
              return Chip(
                label: Text(opt, style: const TextStyle(fontSize: 11, color: Colors.white)),
                backgroundColor: const Color(0xFF0F172A),
                deleteIcon: const Icon(Icons.close, size: 12, color: Colors.grey),
                onDeleted: () {
                  setState(() {
                    _decisionOptions.remove(opt);
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _spinDecision,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Random Choice Spin'),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 3: SOUNDSCAPE MIXER & AUDIO VISUALIZER
  // ---------------------------------------------------------------------------
  Widget _buildSoundscapeMixerTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.indigo.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.volume_up, size: 32, color: Colors.indigoAccent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ambient Background Soundscape',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          'Mix multi-layer relaxing audio loops to maintain deep focus while keeping HUD overlay active.',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade300),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Active Audio Channels', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
            const SizedBox(height: 12),
            ..._sounds.map((sound) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: sound.isPlaying ? Colors.indigoAccent.withOpacity(0.6) : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        sound.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                        color: sound.isPlaying ? Colors.cyan : Colors.grey,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          sound.isPlaying = !sound.isPlaying;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(sound.icon, size: 14, color: Colors.indigoAccent),
                              const SizedBox(width: 6),
                              Text(
                                sound.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
                              ),
                            ],
                          ),
                          Slider(
                            value: sound.volume,
                            min: 0.0,
                            max: 1.0,
                            activeColor: Colors.indigoAccent,
                            onChanged: (val) {
                              setState(() {
                                sound.volume = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${(sound.volume * 100).toInt()}%',
                      style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 4: HUD CONTROL & STATS
  // ---------------------------------------------------------------------------
  Widget _buildSettingsAndStatsTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HUD Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.cyan.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.shield, color: Colors.cyan),
                      SizedBox(width: 8),
                      Text('System Overlay Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Display Above Other Apps', style: TextStyle(color: Colors.white, fontSize: 13)),
                    subtitle: const Text('Allows floating HUD bubbles to hover globally', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    value: _overlayPermissionEnabled,
                    activeColor: Colors.cyan,
                    onChanged: (val) => setState(() => _overlayPermissionEnabled = val),
                  ),
                  SwitchListTile(
                    title: const Text('Floating Banner Notifications', style: TextStyle(color: Colors.white, fontSize: 13)),
                    subtitle: const Text('Show instant context popups over dynamic apps', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    value: _floatingNotificationActive,
                    activeColor: Colors.cyan,
                    onChanged: (val) => setState(() => _floatingNotificationActive = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Opacity & Style Customizer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blueGrey.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.palette, color: Colors.amber),
                      SizedBox(width: 8),
                      Text('HUD Transparency & Appearance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Bubble Opacity:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('${(_hudOpacity * 100).toInt()}%', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: _hudOpacity,
                    min: 0.3,
                    max: 1.0,
                    activeColor: Colors.amber,
                    onChanged: (val) => setState(() => _hudOpacity = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // User Session Engagement Stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.indigo.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.stars, color: Colors.indigoAccent),
                      SizedBox(width: 8),
                      Text('HUD User Loyalty & Engagement Metrics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatMetric('Active Session', _formatSessionTime(_sessionSeconds), Colors.cyan),
                      _buildStatMetric('Saved Notes', '${_stickyNotes.length}', Colors.amber),
                      _buildStatMetric('HUD Power', 'Level 4', Colors.purpleAccent),
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

  Widget _buildStatMetric(String title, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}