import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const ContextMateApp());
}

class ContextMateApp extends StatelessWidget {
  const ContextMateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'ContextMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: const MainStudioScreen(),
    );
  }
}

class MainStudioScreen extends StatefulWidget {
  const MainStudioScreen({Key? key}) : super(key: key);

  @override
  State<MainStudioScreen> createState() => _MainStudioScreenState();
}

class _MainStudioScreenState extends State<MainStudioScreen> {
  int _selectedIndex = 0;
  bool _isOverlayActive = true;
  bool _drawOverPermission = true;
  bool _notificationPermission = true;

  // Snippets State
  final List<Map<String, String>> _snippets = [
    {
      'title': 'Work Email Signature',
      'content': 'Best regards,\nAlex Silva | Product Lead\nalex@company.com'
    },
    {
      'title': 'Delivery Address',
      'content': '124 Palm Avenue, Apt 4B, Westside District, NY 10001'
    },
    {
      'title': 'Quick Decline Reply',
      'content': 'Thanks for reaching out! I am fully booked right now, but let us connect next month.'
    },
    {
      'title': 'Payment Details',
      'content': 'Paypal: alex@pay.me | Venmo: @AlexSilva-99 | Price: \$45.00'
    },
  ];

  // Speed Reader State
  final TextEditingController _readerTextController = TextEditingController(
    text: 'ContextMate allows you to read content at lightning speeds directly over any app. By focusing your vision on a single dynamic focal point, your reading efficiency increases dramatically without losing comprehension.',
  );
  int _targetWpm = 350;
  bool _isPlayingReader = false;
  List<String> _readerWords = [];
  int _currentWordIndex = 0;
  Timer? _readerTimer;

  // Floating Overlay Simulator position
  Offset _bubblePosition = const Offset(40, 120);
  bool _isExpandedBubble = false;
  String _activeBubbleMode = 'snippets'; // snippets, speed, stamp, calc

  // Mini Calc state
  String _calcDisplay = '0';
  double _calcFirstOperand = 0;
  String _calcOperator = '';
  bool _calcShouldReset = false;

  @override
  void initState() {
    super.initState();
    _prepareSpeedReaderText();
  }

  @override
  void dispose() {
    _readerTimer?.cancel();
    _readerTextController.dispose();
    super.dispose();
  }

  void _prepareSpeedReaderText() {
    _readerWords = _readerTextController.text
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (_readerWords.isEmpty) _readerWords = ['No', 'text', 'provided'];
    _currentWordIndex = 0;
  }

  void _toggleSpeedReader() {
    if (_isPlayingReader) {
      _readerTimer?.cancel();
      setState(() {
        _isPlayingReader = false;
      });
    } else {
      _prepareSpeedReaderText();
      setState(() {
        _isPlayingReader = true;
      });
      final intervalMs = (60000 / _targetWpm).round();
      _readerTimer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
        setState(() {
          if (_currentWordIndex < _readerWords.length - 1) {
            _currentWordIndex++;
          } else {
            _currentWordIndex = 0;
            _isPlayingReader = false;
            _readerTimer?.cancel();
          }
        });
      });
    }
  }

  void _onCalcPress(String val) {
    setState(() {
      if (val == 'C') {
        _calcDisplay = '0';
        _calcFirstOperand = 0;
        _calcOperator = '';
        _calcShouldReset = false;
      } else if (['+', '-', '*', '/'].contains(val)) {
        _calcFirstOperand = double.tryParse(_calcDisplay) ?? 0;
        _calcOperator = val;
        _calcShouldReset = true;
      } else if (val == '=') {
        final second = double.tryParse(_calcDisplay) ?? 0;
        double res = 0;
        if (_calcOperator == '+') res = _calcFirstOperand + second;
        if (_calcOperator == '-') res = _calcFirstOperand - second;
        if (_calcOperator == '*') res = _calcFirstOperand * second;
        if (_calcOperator == '/') res = second != 0 ? _calcFirstOperand / second : 0;
        _calcDisplay = res.toStringAsFixed(res.truncateToDouble() == res ? 0 : 2);
        _calcOperator = '';
        _calcShouldReset = true;
      } else {
        if (_calcDisplay == '0' || _calcShouldReset) {
          _calcDisplay = val;
          _calcShouldReset = false;
        } else {
          _calcDisplay += val;
        }
      }
    });
  }

  void _addNewSnippetDialog() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Floating Snippet'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Snippet Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Text Content / Template',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                setState(() {
                  _snippets.add({
                    'title': titleCtrl.text.trim(),
                    'content': contentCtrl.text.trim(),
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Snippet added to floating vault!')),
                );
              }
            },
            child: const Text('Save Snippet'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.widgets, color: Colors.indigo),
            SizedBox(width: 8),
            Text('ContextMate', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isOverlayActive ? Icons.sensors_active : Icons.sensors_off,
              color: _isOverlayActive ? Colors.green : Colors.grey,
            ),
            tooltip: 'Toggle Overlay Service',
            onPressed: () {
              setState(() {
                _isOverlayActive = !_isOverlayActive;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isOverlayActive
                      ? 'Floating Assistant Active'
                      : 'Floating Assistant Disabled'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Floating Status Control Bar
            Container(
              color: Theme.of(context).colorScheme.surfaceVariant,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      selected: _drawOverPermission,
                      label: const Text('Display Above Apps: Active'),
                      avatar: const Icon(Icons.layers, size: 16),
                      onSelected: (val) {
                        setState(() => _drawOverPermission = val);
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      selected: _notificationPermission,
                      label: const Text('Notifications: Ready'),
                      avatar: const Icon(Icons.notifications_active, size: 16),
                      onSelected: (val) {
                        setState(() => _notificationPermission = val);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  _buildSnippetsTab(),
                  _buildSpeedReaderTab(),
                  _buildOverlaySimulatorTab(),
                  _buildSettingsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _selectedIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.content_paste),
            label: 'Snippets',
          ),
          NavigationDestination(
            icon: Icon(Icons.speed),
            label: 'Speed Reader',
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_button),
            label: 'Live Canvas',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune),
            label: 'Controls',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: SNIPPETS VAULT ---
  Widget _buildSnippetsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Floating Text Vault',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Tap copy or launch bubble to insert into any app without switching',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: _addNewSnippetDialog,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
              )
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _snippets.length,
            itemBuilder: (ctx, idx) {
              final snip = _snippets[idx];
              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.bookmark_border, color: Colors.indigo, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              snip['title'] ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 18),
                            tooltip: 'Copy text',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Copied: "${snip['title']}"'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _snippets.removeAt(idx);
                              });
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          snip['content'] ?? '',
                          style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
                          softWrap: true,
                        ),
                      ),
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

  // --- TAB 2: SPEED READER STUDIO ---
  Widget _buildSpeedReaderTab() {
    final currentWord = (_readerWords.isNotEmpty && _currentWordIndex < _readerWords.length)
        ? _readerWords[_currentWordIndex]
        : 'Ready';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Speed Reader Overlay',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Digest articles 3x faster using Rapid Serial Visual Presentation overlay',
            style: TextStyle(color: Colors.grey, fontSize: 13),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          // RSVP Display Box
          Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Visual focal guidelines
                Positioned(
                  top: 10,
                  bottom: 10,
                  child: Container(width: 2, color: Colors.red.withOpacity(0.4)),
                ),
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        currentWord,
                        style: const TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 14,
                  child: Text(
                    '${_currentWordIndex + 1} / ${_readerWords.length}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Playback Controls & WPM Slider
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filled(
                        iconSize: 32,
                        icon: Icon(_isPlayingReader ? Icons.pause : Icons.play_arrow),
                        onPressed: () {
                          _prepareSpeedReaderText();
                          _toggleSpeedReader();
                        },
                      ),
                      const SizedBox(width: 16),
                      IconButton.outlined(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          setState(() {
                            _readerTimer?.cancel();
                            _isPlayingReader = false;
                            _currentWordIndex = 0;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.speed, color: Colors.indigo),
                      const SizedBox(width: 8),
                      Text('Speed: $_targetWpm WPM',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: _targetWpm.toDouble(),
                    min: 150,
                    max: 700,
                    divisions: 11,
                    label: '$_targetWpm WPM',
                    onChanged: (val) {
                      setState(() {
                        _targetWpm = val.round();
                      });
                      if (_isPlayingReader) {
                        _toggleSpeedReader();
                        _toggleSpeedReader();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Source Text Input
          TextField(
            controller: _readerTextController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Paste Article or Reading Material',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            onChanged: (_) => _prepareSpeedReaderText(),
          ),
        ],
      ),
    );
  }

  // --- TAB 3: LIVE OVERLAY CANVAS & FLOATING BUBBLE DEMO ---
  Widget _buildOverlaySimulatorTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Interactive Floating Overlay Sandbox',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Drag the floating assistant widget anywhere on screen. Tap to expand floating quick-tools.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                  softWrap: true,
                ),
              ],
            ),
          ),
          Container(
            height: 480,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.indigo.withOpacity(0.3), width: 2),
            ),
            child: Stack(
              children: [
                // Simulated Background App UI
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 140,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: const Text(
                            'Simulated External App Background\n\nContextMate floats dynamically above messaging apps, browsers, PDF readers, and social feeds.',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ActionChip(
                              label: const Text('Mode: Snippets'),
                              avatar: const Icon(Icons.content_paste, size: 14),
                              onPressed: () => setState(() => _activeBubbleMode = 'snippets'),
                            ),
                            ActionChip(
                              label: const Text('Mode: Speed Read'),
                              avatar: const Icon(Icons.speed, size: 14),
                              onPressed: () => setState(() => _activeBubbleMode = 'speed'),
                            ),
                            ActionChip(
                              label: const Text('Mode: Mini Calc'),
                              avatar: const Icon(Icons.calculate, size: 14),
                              onPressed: () => setState(() => _activeBubbleMode = 'calc'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                // Interactive Draggable Floating Bubble
                Positioned(
                  left: _bubblePosition.dx,
                  top: _bubblePosition.dy,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        _bubblePosition += details.delta;
                        // Keep within bounds
                        _bubblePosition = Offset(
                          _bubblePosition.dx.clamp(10.0, 260.0),
                          _bubblePosition.dy.clamp(10.0, 360.0),
                        );
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: _isExpandedBubble ? 260 : 56,
                      height: _isExpandedBubble ? 240 : 56,
                      decoration: BoxDecoration(
                        color: _isExpandedBubble
                            ? Theme.of(context).colorScheme.surface
                            : Colors.indigo,
                        borderRadius: BorderRadius.circular(_isExpandedBubble ? 16 : 28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ],
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: _isExpandedBubble
                          ? _buildExpandedBubbleContent()
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  _isExpandedBubble = true;
                                });
                              },
                              child: const Center(
                                child: Icon(
                                  Icons.smart_button,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildExpandedBubbleContent() {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: const BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.widgets, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'ContextMate Hub (${_activeBubbleMode.toUpperCase()})',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: () => setState(() => _isExpandedBubble = false),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              )
            ],
          ),
        ),

        // Expanded Body View based on active mode
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildBubbleModeBody(),
          ),
        ),
      ],
    );
  }

  Widget _buildBubbleModeBody() {
    if (_activeBubbleMode == 'snippets') {
      return Column(
        children: [
          const Text('Tap snippet to instant-insert:',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Expanded(
            child: ListView.builder(
              itemCount: _snippets.length,
              itemBuilder: (ctx, idx) {
                final s = _snippets[idx];
                return InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Inserted: "${s['title']}"'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                    setState(() => _isExpandedBubble = false);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      s['title'] ?? '',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else if (_activeBubbleMode == 'calc') {
      return Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _calcDisplay,
              style: const TextStyle(color: Colors.greenAccent, fontSize: 18, fontFamily: 'monospace'),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: ['7','8','9','/','4','5','6','*','1','2','3','-','C','0','=','+'].map((btn) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  onPressed: () => _onCalcPress(btn),
                  child: Text(btn, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                );
              }).toList(),
            ),
          )
        ],
      );
    } else {
      // Speed Mode
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.speed, color: Colors.indigo, size: 30),
          const SizedBox(height: 6),
          Text(
            'Target: $_targetWpm WPM',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _selectedIndex = 1;
                _isExpandedBubble = false;
              });
            },
            icon: const Icon(Icons.play_arrow, size: 16),
            label: const Text('Open Reader', style: TextStyle(fontSize: 11)),
          )
        ],
      );
    }
  }

  // --- TAB 4: CONTROLS & ASSISTANT SETTINGS ---
  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Assistant Settings & Trigger Keys',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Configure overlay behavior, system permissions, and dynamic shortcuts',
            style: TextStyle(color: Colors.grey, fontSize: 13),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Persistent Floating Bubble'),
                  subtitle: const Text('Keep bubble visible over home screen and apps'),
                  value: _isOverlayActive,
                  onChanged: (val) {
                    setState(() => _isOverlayActive = val);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Display Above Other Apps Permission'),
                  subtitle: const Text('Required for contextual overlay rendering'),
                  value: _drawOverPermission,
                  onChanged: (val) {
                    setState(() => _drawOverPermission = val);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Quick Notification Drawer Controls'),
                  subtitle: const Text('Access snippets & speed reader from status bar'),
                  value: _notificationPermission,
                  onChanged: (val) {
                    setState(() => _notificationPermission = val);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.security, color: Colors.indigo),
                      SizedBox(width: 8),
                      Text('Privacy & Local Storage',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'ContextMate processes all snippet data and reading content 100% locally on your device. Zero internet transmission guarantees privacy.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                    softWrap: true,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Local Snippet Cache Cleared!')),
                      );
                    },
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('Clear Snippet Cache'),
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