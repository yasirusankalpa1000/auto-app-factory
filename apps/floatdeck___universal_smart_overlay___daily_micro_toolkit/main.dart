import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const FloatDeckApp());
}

class FloatDeckApp extends StatelessWidget {
  const FloatDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatDeck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7F6),
      ),
      home: const MainDashboardScreen(),
    );
  }
}

class StickyPin {
  final String id;
  final String title;
  final String content;
  final Color categoryColor;
  bool isPinned;

  StickyPin({
    required this.id,
    required this.title,
    required this.content,
    required this.categoryColor,
    this.isPinned = true,
  });
}

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _currentTabIndex = 0;

  // Floating Overlay State Simulation
  bool _isOverlayEnabled = true;
  bool _isFloatingPillExpanded = false;
  Offset _pillPosition = const Offset(20, 180);

  // Sticky Pins Data
  final List<StickyPin> _stickyPins = [
    StickyPin(
      id: '1',
      title: 'Home Wi-Fi Password',
      content: 'Fiber_Guest_8832@Pass',
      categoryColor: Colors.teal,
    ),
    StickyPin(
      id: '2',
      title: 'Courier Track ID',
      content: 'PKG-99201-SL-2025',
      categoryColor: Colors.indigo,
    ),
    StickyPin(
      id: '3',
      title: 'Office Address Format',
      content: '3rd Floor, Tech Tower, Main Rd',
      categoryColor: Colors.deepOrange,
    ),
  ];

  // Clipboard Scrubber State
  final TextEditingController _clipboardTextController =
      TextEditingController(text: '  Contact us at support@example.com or call +1 800-555-0199 for order #88291. Visit https://example.com/item?ref=123  ');
  String _scrubbedResult = '';

  // Micro Ruler State
  double _rulerLengthMm = 80.0;
  String _selectedRulerUnit = 'mm';
  double _aspectWidth = 16;
  double _aspectHeight = 9;

  // Currency & Unit State
  double _baseUSD = 10.0;
  final Map<String, double> _rates = {
    'USD': 1.0,
    'EUR': 0.92,
    'GBP': 0.79,
    'LKR': 305.50,
    'INR': 86.40,
    'JPY': 152.20,
  };

  // Decision Wheel State
  final List<String> _wheelChoices = [
    'Coffee Break',
    'Task A First',
    'Task B First',
    'Quick Walk',
    'Reply Emails',
    'Call Team'
  ];
  int _selectedDecisionIndex = 0;
  bool _isSpinning = false;

  @override
  void initState() {
    super.initState();
    _processTextClean();
  }

  void _processTextClean() {
    setState(() {
      _scrubbedResult = _clipboardTextController.text.trim();
    });
  }

  void _stripExtraSpaces() {
    setState(() {
      _scrubbedResult = _clipboardTextController.text.replaceAll(RegExp(r'\s+'), ' ').trim();
    });
  }

  void _extractLinks() {
    final reg = RegExp(r'https?://[^\s]+');
    final matches = reg.allMatches(_clipboardTextController.text).map((m) => m.group(0)).join('\n');
    setState(() {
      _scrubbedResult = matches.isNotEmpty ? matches : 'No URLs found in input text.';
    });
  }

  void _extractPhones() {
    final reg = RegExp(r'\+?[0-9\-\s\(\)]{7,15}');
    final matches = reg.allMatches(_clipboardTextController.text)
        .map((m) => m.group(0)?.trim())
        .where((element) => element != null && element.length >= 7)
        .join('\n');
    setState(() {
      _scrubbedResult = matches.isNotEmpty ? matches : 'No phone numbers detected.';
    });
  }

  void _spinDecisionWheel() {
    if (_isSpinning) return;
    setState(() {
      _isSpinning = true;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      final random = Random();
      setState(() {
        _selectedDecisionIndex = random.nextInt(_wheelChoices.length);
        _isSpinning = false;
      });
    });
  }

  void _addStickyPinDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Floating Sticky Pin', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Pin Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Content or Snippet',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                  setState(() {
                    _stickyPins.add(
                      StickyPin(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text,
                        content: contentController.text,
                        categoryColor: Colors.teal,
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Pin It', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top Status Header
                _buildSystemHeaderBar(),

                // Main Dynamic Tab Content
                Expanded(
                  child: IndexedStack(
                    index: _currentTabIndex,
                    children: [
                      _buildFloatingDockStudioTab(),
                      _buildSmartClipboardTab(),
                      _buildMicroRulerTab(),
                      _buildCurrencyMatrixTab(),
                      _buildDecisionWheelTab(),
                    ],
                  ),
                ),
              ],
            ),

            // Simulated Draggable Screen Overlay Floating Pill Widget
            if (_isOverlayEnabled) _buildDraggableFloatingPillOverlay(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarTypeItem(
            icon: Icon(Icons.widgets),
            label: 'Dock',
          ),
          BottomNavigationBarTypeItem(
            icon: Icon(Icons.cleaning_services),
            label: 'Scrub',
          ),
          BottomNavigationBarTypeItem(
            icon: Icon(Icons.straighten),
            label: 'Ruler',
          ),
          BottomNavigationBarTypeItem(
            icon: Icon(Icons.monetization_on),
            label: 'Matrix',
          ),
          BottomNavigationBarTypeItem(
            icon: Icon(Icons.casino),
            label: 'Decide',
          ),
        ],
      ),
    );
  }

  Widget _buildSystemHeaderBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.teal.shade700,
      child: Row(
        children: [
          const Icon(Icons.layers, color: Colors.white, size: 24),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'FloatDeck Overlay Active',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _isOverlayEnabled ? Colors.green.shade400 : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isOverlayEnabled ? Icons.check_circle : Icons.pause_circle,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  _isOverlayEnabled ? 'Overlay ON' : 'Paused',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: _isOverlayEnabled,
            activeColor: Colors.amber,
            onChanged: (val) {
              setState(() {
                _isOverlayEnabled = val;
              });
            },
          ),
        ],
      ),
    );
  }

  // Floating Overlay Draggable Widget Component
  Widget _buildDraggableFloatingPillOverlay() {
    return Positioned(
      left: _pillPosition.dx,
      top: _pillPosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _pillPosition += details.delta;
          });
        },
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(30),
          color: Colors.teal.shade900,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.teal.shade200, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _isFloatingPillExpanded = !_isFloatingPillExpanded;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.flash_on, color: Colors.white, size: 20),
                  ),
                ),
                if (_isFloatingPillExpanded) ...[
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Quick Scrubbed Clipboard!')),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(Icons.cleaning_services, color: Colors.white, size: 20),
                    ),
                  ),
                  InkWell(
                    onTap: _addStickyPinDialog,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(Icons.push_pin, color: Colors.white, size: 20),
                    ),
                  ),
                  InkWell(
                    onTap: _spinDecisionWheel,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(Icons.casino, color: Colors.white, size: 20),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 18),
                    onPressed: () {
                      setState(() {
                        _isFloatingPillExpanded = false;
                      });
                    },
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  // TAB 1: FLOATING DOCK & STICKY PINS
  Widget _buildFloatingDockStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.drag_indicator, color: Colors.teal),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Floating System Overlay Control',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'The floating pill stays accessible above all daily apps. Drag it anywhere or tap to expand quick action tools.',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _pillPosition = const Offset(30, 200);
                          });
                        },
                        icon: const Icon(Icons.center_focus_strong, size: 16),
                        label: const Text('Reset Position'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Simulated floating heads updated!')),
                          );
                        },
                        icon: const Icon(Icons.notifications_active, size: 16),
                        label: const Text('Test Float Heads'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Sticky Pin Stack Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.push_pin, color: Colors.deepOrange),
                  SizedBox(width: 8),
                  Text(
                    'Floating Sticky Pin Board',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                onPressed: _addStickyPinDialog,
                icon: const Icon(Icons.add_circle, color: Colors.teal, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (_stickyPins.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              child: const Text('No sticky pins saved. Tap + to pin quick text/codes.'),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _stickyPins.length,
              itemBuilder: (context, index) {
                final pin = _stickyPins[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: pin.categoryColor.withAlpha(120), width: 1.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 40,
                          decoration: BoxDecoration(
                            color: pin.categoryColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pin.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                softWrap: true,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                pin.content,
                                style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, color: Colors.teal, size: 20),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Copied "${pin.content}" to clipboard')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                          onPressed: () {
                            setState(() {
                              _stickyPins.removeAt(index);
                            });
                          },
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

  // TAB 2: SMART CLIPBOARD SCRUBBER
  Widget _buildSmartClipboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.cleaning_services, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(
                        'Dirty Text & Queue Scrubber',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _clipboardTextController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Raw Copied Text Input',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => _processTextClean(),
                  ),
                  const SizedBox(height: 12),
                  const Text('Quick Sanitization Filters:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.space_bar, size: 16),
                        label: const Text('Strip Extra Spaces'),
                        onPressed: _stripExtraSpaces,
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.link, size: 16),
                        label: const Text('Extract Links'),
                        onPressed: _extractLinks,
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.phone, size: 16),
                        label: const Text('Extract Phones'),
                        onPressed: _extractPhones,
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.text_fields, size: 16),
                        label: const Text('UPPERCASE'),
                        onPressed: () {
                          setState(() {
                            _scrubbedResult = _clipboardTextController.text.toUpperCase();
                          });
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.text_format, size: 16),
                        label: const Text('lowercase'),
                        onPressed: () {
                          setState(() {
                            _scrubbedResult = _clipboardTextController.text.toLowerCase();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Output Card
          Card(
            color: Colors.teal.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.teal.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Cleaned Output Snippet',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.teal),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cleaned text copied to clipboard!')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    _scrubbedResult.isEmpty ? 'Result will appear here.' : _scrubbedResult,
                    style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    onPressed: () {
                      if (_scrubbedResult.isNotEmpty) {
                        setState(() {
                          _stickyPins.add(
                            StickyPin(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              title: 'Scrubbed Snippet',
                              content: _scrubbedResult,
                              categoryColor: Colors.teal,
                            ),
                          );
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Pinned directly to Sticky Board!')),
                        );
                      }
                    },
                    icon: const Icon(Icons.push_pin, color: Colors.white, size: 16),
                    label: const Text('Pin to Deck Board', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 3: MICRO RULER & ASPECT RATIO GAUGE
  Widget _buildMicroRulerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.straighten, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(
                        'Screen Calibrated Micro-Ruler',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Place small real-world objects or measure on-screen visual elements directly.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Ruler Visual Container
                  Container(
                    height: 90,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade800, width: 2),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 8,
                          left: 12,
                          child: Text(
                            'Visual Measurement Scale (${_rulerLengthMm.toStringAsFixed(0)} $_selectedRulerUnit)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade900,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 45,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(15, (index) {
                                final isMajor = index % 5 == 0;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (isMajor)
                                      Text(
                                        '${(index * (_rulerLengthMm / 14)).toStringAsFixed(0)}',
                                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                                      ),
                                    Container(
                                      width: isMajor ? 2.5 : 1,
                                      height: isMajor ? 24 : 12,
                                      color: Colors.black87,
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Scale Width: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Slider(
                          value: _rulerLengthMm,
                          min: 20,
                          max: 150,
                          activeColor: Colors.teal,
                          onChanged: (val) {
                            setState(() {
                              _rulerLengthMm = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: const Text('Millimeters (mm)'),
                        selected: _selectedRulerUnit == 'mm',
                        onSelected: (sel) {
                          if (sel) setState(() => _selectedRulerUnit = 'mm');
                        },
                      ),
                      const SizedBox(width: 12),
                      ChoiceChip(
                        label: const Text('Pixels (px)'),
                        selected: _selectedRulerUnit == 'px',
                        onSelected: (sel) {
                          if (sel) setState(() => _selectedRulerUnit = 'px');
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Aspect Ratio Gauge Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.aspect_ratio, color: Colors.indigo),
                      SizedBox(width: 8),
                      Text(
                        'Aspect Ratio Inspector',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 160,
                      height: 160 * (_aspectHeight / _aspectWidth),
                      constraints: const BoxConstraints(maxHeight: 120),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        border: Border.all(color: Colors.indigo, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${_aspectWidth.toInt()}:${_aspectHeight.toInt()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      ChoiceChip(
                        label: const Text('16:9'),
                        selected: _aspectWidth == 16 && _aspectHeight == 9,
                        onSelected: (s) => setState(() {
                          _aspectWidth = 16;
                          _aspectHeight = 9;
                        }),
                      ),
                      ChoiceChip(
                        label: const Text('4:3'),
                        selected: _aspectWidth == 4 && _aspectHeight == 3,
                        onSelected: (s) => setState(() {
                          _aspectWidth = 4;
                          _aspectHeight = 3;
                        }),
                      ),
                      ChoiceChip(
                        label: const Text('1:1'),
                        selected: _aspectWidth == 1 && _aspectHeight == 1,
                        onSelected: (s) => setState(() {
                          _aspectWidth = 1;
                          _aspectHeight = 1;
                        }),
                      ),
                      ChoiceChip(
                        label: const Text('9:16'),
                        selected: _aspectWidth == 9 && _aspectHeight == 16,
                        onSelected: (s) => setState(() {
                          _aspectWidth = 9;
                          _aspectHeight = 16;
                        }),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // TAB 4: CURRENCY & REAL-WORLD MATRIX
  Widget _buildCurrencyMatrixTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.monetization_on, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(
                        'Instant Multi-Currency Matrix',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Base Amount (\$) : ', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            hintText: 'Enter USD',
                          ),
                          onChanged: (val) {
                            final parsed = double.tryParse(val);
                            if (parsed != null) {
                              setState(() {
                                _baseUSD = parsed;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: _rates.entries.map((entry) {
                      final calculated = _baseUSD * entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.teal.shade100,
                                  child: Text(
                                    entry.key.substring(0, 2),
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.teal),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  entry.key,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                ),
                              ],
                            ),
                            Text(
                              '${entry.key == "USD" ? "\$" : ""}${calculated.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Real World Object Matrix
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.scale, color: Colors.deepOrange),
                      SizedBox(width: 8),
                      Text(
                        'Real-World Scale Comparer',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Quickly understand weights and measures in ordinary daily terms:',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  _buildScaleComparisonTile('500 g', 'Approx 1 standard loaf of bread'),
                  _buildScaleComparisonTile('1 Liter', '1000 cm³ of water = 1.0 kg mass'),
                  _buildScaleComparisonTile('1 Inch', '2.54 centimeters (~1 thumb knuckle)'),
                  _buildScaleComparisonTile('1 Cup', '240 ml of liquid volume'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScaleComparisonTile(String value, String equivalent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.deepOrange.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                equivalent,
                style: const TextStyle(fontSize: 13),
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 5: DECISION WHEEL & QUICK UTILITY
  Widget _buildDecisionWheelTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.casino, color: Colors.purple),
                      SizedBox(width: 8),
                      Text(
                        'Daily Micro Decision Picker',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Solve quick daily indecisions on what to do next in one tap.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  // Spinner Display Box
                  Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _isSpinning ? Colors.purple.shade100 : Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.purple, width: 2),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _isSpinning ? Icons.refresh : Icons.stars,
                            size: 36,
                            color: Colors.purple,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _isSpinning ? 'Choosing for you...' : _wheelChoices[_selectedDecisionIndex],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: _spinDecisionWheel,
                      icon: const Icon(Icons.play_arrow, color: Colors.white),
                      label: const Text(
                        'Pick For Me Now',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Options List Builder
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Active Decision Pool Options:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _wheelChoices.map((choice) {
                      return Chip(
                        backgroundColor: Colors.purple.shade50,
                        label: Text(choice),
                        avatar: const Icon(Icons.check_circle, size: 16, color: Colors.purple),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}