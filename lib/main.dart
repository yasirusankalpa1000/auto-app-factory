import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const OmniHUDApp());
}

class OmniHUDApp extends StatelessWidget {
  const OmniHUDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniHUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0E15),
      ),
      home: const HUDMainScreen(),
    );
  }
}

class HUDMainScreen extends StatefulWidget {
  const HUDMainScreen({super.key});

  @override
  State<HUDMainScreen> createState() => _HUDMainScreenState();
}

class _HUDMainScreenState extends State<HUDMainScreen>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  bool _isFloatingPanelOpen = false;

  // Desk HUD State
  late Timer _clockTimer;
  late Timer _visualizerTimer;
  String _timeString = '';
  String _dateString = '';
  final List<double> _visualizerHeights = List.generate(12, (_) => 20.0);
  bool _isPlayingAmbient = false;
  String _selectedSound = 'Rain & Waves';
  final TextEditingController _scratchpadController = TextEditingController(
    text: 'Quick micro note: Remember to review daily goals...',
  );

  // Text Scrubber State
  final TextEditingController _scrubberController = TextEditingController();
  String _scrubberResult = '';
  int _wordCount = 0;
  int _charCount = 0;

  // Decision Wheel State
  final List<String> _decisionItems = [
    'Order Pizza',
    'Cook at Home',
    'Eat Tacos',
    'Healthy Salad',
    'Sushi Night',
  ];
  final TextEditingController _newItemController = TextEditingController();
  double _wheelAngle = 0.0;
  bool _isSpinning = false;
  String _spinResult = 'Tap Spin to Decide!';

  // Splitter & Micro-Calc State
  final TextEditingController _billController = TextEditingController(text: '45.00');
  double _tipPercent = 15.0;
  int _peopleCount = 2;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
    _visualizerTimer = Timer.periodic(const Duration(milliseconds: 150), (_) {
      if (_isPlayingAmbient) {
        _randomizeVisualizer();
      }
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _visualizerTimer.cancel();
    _scratchpadController.dispose();
    _scrubberController.dispose();
    _newItemController.dispose();
    _billController.dispose();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _timeString =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
      _dateString = '${_weekdayName(now.weekday)}, ${_monthName(now.month)} ${now.day}';
    });
  }

  void _randomizeVisualizer() {
    final rand = Random();
    setState(() {
      for (int i = 0; i < _visualizerHeights.length; i++) {
        _visualizerHeights[i] = 10.0 + rand.nextDouble() * 50.0;
      }
    });
  }

  String _weekdayName(int day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[(day - 1) % 7];
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[(month - 1) % 12];
  }

  void _processText(String type) {
    String text = _scrubberController.text;
    if (text.isEmpty) return;

    setState(() {
      switch (type) {
        case 'trim':
          _scrubberResult = text.replaceAll(RegExp(r'\s+'), ' ').trim();
          break;
        case 'lines':
          _scrubberResult = text.replaceAll(RegExp(r'\n+'), ' ').trim();
          break;
        case 'upper':
          _scrubberResult = text.toUpperCase();
          break;
        case 'lower':
          _scrubberResult = text.toLowerCase();
          break;
        case 'extract_emails':
          final emailReg = RegExp(r'[a-zA-Z0-9.\-_]+@[a-zA-Z0-9.\-_]+\.[a-zA-Z]+');
          final matches = emailReg.allMatches(text).map((m) => m.group(0)).toList();
          _scrubberResult = matches.isEmpty
              ? 'No emails detected.'
              : matches.join('\n');
          break;
      }
      _charCount = _scrubberResult.length;
      _wordCount = _scrubberResult.trim().isEmpty
          ? 0
          : _scrubberResult.trim().split(RegExp(r'\s+')).length;
    });
  }

  void _spinDecisionWheel() {
    if (_decisionItems.isEmpty || _isSpinning) return;
    setState(() {
      _isSpinning = true;
      _spinResult = 'Selecting...';
    });

    final rand = Random();
    final double targetRotation = _wheelAngle + (pi * 4) + (rand.nextDouble() * pi * 2);
    int step = 0;
    const totalSteps = 30;

    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      step++;
      setState(() {
        _wheelAngle += (targetRotation - _wheelAngle) * 0.15;
      });

      if (step >= totalSteps) {
        timer.cancel();
        final selectedIndex = rand.nextInt(_decisionItems.length);
        setState(() {
          _isSpinning = false;
          _spinResult = 'Result: ${_decisionItems[selectedIndex]}!';
        });
      }
    });
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard!'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildFloatingTopHUD(),
            Expanded(
              child: IndexedStack(
                index: _selectedTab,
                children: [
                  _buildDeskHUDTab(),
                  _buildTextScrubberTab(),
                  _buildDecisionTab(),
                  _buildSplitterTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) => setState(() => _selectedTab = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF161824),
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Desk HUD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: 'Text Clean',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.casino),
            label: 'DecideIt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Splitter',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingTopHUD() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2030),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.4), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_active, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'OmniHUD Active • Screen Companion Mode',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  _isFloatingPanelOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.deepPurpleAccent,
                ),
                onPressed: () {
                  setState(() {
                    _isFloatingPanelOpen = !_isFloatingPanelOpen;
                  });
                },
              ),
            ],
          ),
          if (_isFloatingPanelOpen) ...[
            const Divider(color: Colors.white70, height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAxisAlignment.center,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.music_note, size: 14, color: Colors.teal),
                  label: Text(_isPlayingAmbient ? 'Pause Sound' : 'Play Ambient',
                      style: const TextStyle(fontSize: 11)),
                  backgroundColor: const Color(0xFF26293D),
                  onPressed: () {
                    setState(() {
                      _isPlayingAmbient = !_isPlayingAmbient;
                    });
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.content_copy, size: 14, color: Colors.orange),
                  label: const Text('Copy Scratchpad', style: TextStyle(fontSize: 11)),
                  backgroundColor: const Color(0xFF26293D),
                  onPressed: () => _copyToClipboard(
                      _scratchpadController.text, 'Scratchpad'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.refresh, size: 14, color: Colors.blue),
                  label: const Text('Spin Quick Wheel', style: TextStyle(fontSize: 11)),
                  backgroundColor: const Color(0xFF26293D),
                  onPressed: () {
                    setState(() => _selectedTab = 2);
                    _spinDecisionWheel();
                  },
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildDeskHUDTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dynamic Clock Display
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF241442), Color(0xFF16182C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _timeString.isEmpty ? '00:00:00' : _timeString,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _dateString,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Visualizer & Ambient Audio Companion
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF181A26),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ambient Audio Companion',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isPlayingAmbient
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: Colors.tealAccent,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPlayingAmbient = !_isPlayingAmbient;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: _visualizerHeights.map((h) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        width: 12,
                        height: _isPlayingAmbient ? h : 8.0,
                        decoration: BoxDecoration(
                          color: _isPlayingAmbient
                              ? Colors.tealAccent
                              : Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    'Rain & Waves',
                    'Coffee Shop',
                    'Deep Focus Noise',
                    'Night Forest'
                  ].map((sound) {
                    final isSelected = _selectedSound == sound;
                    return ChoiceChip(
                      label: Text(sound, style: const TextStyle(fontSize: 12)),
                      selected: isSelected,
                      selectedColor: Colors.deepPurple,
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            _selectedSound = sound;
                            _isPlayingAmbient = true;
                          });
                        }
                      },
                    );
                  }).toList(),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Desk Scratchpad Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF181A26),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Floating Desk Scratchpad',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20, color: Colors.grey),
                      onPressed: () => _copyToClipboard(
                        _scratchpadController.text,
                        'Scratchpad text',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _scratchpadController,
                  maxLines: 4,
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                  decoration: const InputDecoration(
                    hintText: 'Type fast temporary notes here...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextScrubberTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Smart Text Scrubber & Format Cleaner',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Paste messy text, messages, or emails to quickly strip bad formatting, double spaces, and extract data.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _scrubberController,
            maxLines: 5,
            style: const TextStyle(fontSize: 13),
            decoration: const InputDecoration(
              hintText: 'Paste messy text here...',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.space_bar, size: 16),
                label: const Text('Trim Spaces', style: TextStyle(fontSize: 12)),
                onPressed: () => _processText('trim'),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.format_line_spacing, size: 16),
                label: const Text('Remove Linebreaks', style: TextStyle(fontSize: 12)),
                onPressed: () => _processText('lines'),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.email, size: 16),
                label: const Text('Extract Emails', style: TextStyle(fontSize: 12)),
                onPressed: () => _processText('extract_emails'),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.text_fields, size: 16),
                label: const Text('UPPERCASE', style: TextStyle(fontSize: 12)),
                onPressed: () => _processText('upper'),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.text_format, size: 16),
                label: const Text('lowercase', style: TextStyle(fontSize: 12)),
                onPressed: () => _processText('lower'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Output Container
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF181A26),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Stats: $_wordCount Words | $_charCount Chars',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.tealAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 18, color: Colors.white70),
                      onPressed: () {
                        if (_scrubberResult.isNotEmpty) {
                          _copyToClipboard(_scrubberResult, 'Cleaned text');
                        }
                      },
                    )
                  ],
                ),
                const Divider(color: Colors.white70),
                const SizedBox(height: 6),
                Text(
                  _scrubberResult.isEmpty
                      ? 'Cleaned output will appear here...'
                      : _scrubberResult,
                  style: TextStyle(
                    fontSize: 13,
                    color: _scrubberResult.isEmpty ? Colors.grey : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecisionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'DecideIt • Micro-Decision Wheel',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Stuck on micro choices? Let the wheel eliminate decision fatigue instantly.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Spin Wheel Animation Display
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: _wheelAngle,
                    child: CustomPaint(
                      size: const Size(200, 200),
                      painter: WheelPainter(items: _decisionItems),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black87, blurRadius: 6),
                      ],
                    ),
                    child: const Icon(Icons.star, color: Colors.deepPurple, size: 24),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Result Display
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2030),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.5)),
            ),
            child: Text(
              _spinResult,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.tealAccent,
              ),
            ),
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            icon: const Icon(Icons.rotate_right, color: Colors.white),
            label: const Text(
              'SPIN DECISION WHEEL',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            onPressed: _isSpinning ? null : _spinDecisionWheel,
          ),
          const SizedBox(height: 20),

          const Text(
            'Wheel Options:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _decisionItems.map((item) {
              return Chip(
                label: Text(item, style: const TextStyle(fontSize: 12)),
                backgroundColor: const Color(0xFF1E2030),
                deleteIcon: const Icon(Icons.close, size: 14),
                onDeleted: () {
                  setState(() {
                    _decisionItems.remove(item);
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _newItemController,
                  style: const TextStyle(fontSize: 13),
                  decoration: const InputDecoration(
                    hintText: 'Add new choice...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.deepPurpleAccent, size: 36),
                onPressed: () {
                  if (_newItemController.text.trim().isNotEmpty) {
                    setState(() {
                      _decisionItems.add(_newItemController.text.trim());
                      _newItemController.clear();
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSplitterTab() {
    final double billVal = double.tryParse(_billController.text) ?? 0.0;
    final double tipVal = billVal * (_tipPercent / 100);
    final double totalVal = billVal + tipVal;
    final double perPersonVal = _peopleCount > 0 ? totalVal / _peopleCount : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Smart Bill & Tip Micro-Splitter',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Calculate tips instantly and split expenses accurately between friends.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Total Per Person Highlight Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.deepPurple, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'TOTAL PER PERSON',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '\$${perPersonVal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Total: \$${totalVal.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    Text('Tip: \$${tipVal.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Bill Amount Input
          TextField(
            controller: _billController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (v) => setState(() {}),
            style: const TextStyle(fontSize: 14),
            decoration: const InputDecoration(
              labelText: 'Bill Amount (\$)',
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Tip Slider
          Text(
            'Tip Percentage: ${_tipPercent.round()}%',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70),
          ),
          Slider(
            value: _tipPercent,
            min: 0,
            max: 30,
            divisions: 30,
            activeColor: Colors.deepPurpleAccent,
            onChanged: (val) {
              setState(() => _tipPercent = val);
            },
          ),
          const SizedBox(height: 12),

          // People Split Slider
          Text(
            'Split between: $_peopleCount people',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70),
          ),
          Slider(
            value: _peopleCount.toDouble(),
            min: 1,
            max: 12,
            divisions: 11,
            activeColor: Colors.tealAccent,
            onChanged: (val) {
              setState(() => _peopleCount = val.round());
            },
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E2030),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            icon: const Icon(Icons.share, color: Colors.white),
            label: const Text(
              'Copy Calculation Summary',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              final summary =
                  'Bill Split: \$${totalVal.toStringAsFixed(2)} total (\$${perPersonVal.toStringAsFixed(2)} per person for $_peopleCount people).';
              _copyToClipboard(summary, 'Bill Summary');
            },
          )
        ],
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  final List<String> items;

  WheelPainter({required this.items});

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final arcAngle = (2 * pi) / items.length;

    final List<Color> sliceColors = [
      Colors.deepPurple,
      Colors.teal,
      Colors.indigo,
      Colors.orange,
      Colors.blue,
      Colors.amber,
      Colors.purple,
    ];

    for (int i = 0; i < items.length; i++) {
      final paint = Paint()
        ..color = sliceColors[i % sliceColors.length]
        ..style = PaintingStyle.fill;

      final startAngle = i * arcAngle;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        arcAngle,
        true,
        paint,
      );

      final linePaint = Paint()
        ..color = Colors.white70
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        arcAngle,
        true,
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WheelPainter oldDelegate) => true;
}