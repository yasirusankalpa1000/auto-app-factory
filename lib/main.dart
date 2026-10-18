import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const BubbleDockApp());
}

class BubbleDockApp extends StatelessWidget {
  const BubbleDockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BubbleDock Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainDockScreen(),
    );
  }
}

class SnippetItem {
  final String id;
  final String content;
  final String category;
  final DateTime createdAt;

  SnippetItem({
    required this.id,
    required this.content,
    required this.category,
    required this.createdAt,
  });
}

class MainDockScreen extends StatefulWidget {
  const MainDockScreen({super.key});

  @override
  State<MainDockScreen> createState() => _MainDockScreenState();
}

class _MainDockScreenState extends State<MainDockScreen> with SingleTickerProviderStateMixin {
  // Floating Overlay State
  Offset _bubblePosition = const Offset(20, 150);
  bool _isBubbleExpanded = false;
  bool _showBannerNotification = false;
  String _bannerMessage = '';

  // Active Bottom Tab Navigation
  int _selectedTabIndex = 0;

  // --- Speed Reader State ---
  final TextEditingController _readerTextController = TextEditingController(
    text: "BubbleDock Pro allows you to read content up to three times faster by eliminating physical eye movement. Rapid Serial Visual Presentation displays words sequentially in a fixed focal position on your screen.",
  );
  List<String> _readerWords = [];
  int _currentWordIndex = 0;
  bool _isReaderPlaying = false;
  int _wpm = 300;
  Timer? _readerTimer;

  // --- Clipboard Snippets State ---
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: '1',
      content: 'https://example.com/product?item=99&utm_source=facebook&utm_medium=cpc',
      category: 'Links',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    SnippetItem(
      id: '2',
      content: 'SWIFT Code: CHASEUS33XXX | Account: 987654321',
      category: 'Banking',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    SnippetItem(
      id: '3',
      content: 'Meeting Notes: Focus on retention metrics & dynamic user overlays.',
      category: 'Work',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
  final TextEditingController _newSnippetController = TextEditingController();
  String _selectedCategory = 'General';

  // --- Converter & Utility State ---
  double _converterInput = 100.0;
  String _converterType = 'Currency'; // Currency, Length, Weight
  String _fromUnit = '\$ USD';
  String _toUnit = '€ EUR';
  double _conversionRate = 0.92;

  // --- Text Power Tools State ---
  final TextEditingController _textToolController = TextEditingController();
  String _processedText = '';

  // --- Micro Decision Maker State ---
  final TextEditingController _decisionInputController = TextEditingController();
  final List<String> _decisionOptions = ['Order Pizza', 'Cook Pasta', 'Eat Salad', 'Sushi Night'];
  String _decisionResult = 'Tap Spin to Decide!';
  bool _isSpinningDecision = false;

  @override
  void initState() {
    super.initState();
    _prepareSpeedReaderText();
  }

  @override
  void dispose() {
    _readerTimer?.cancel();
    _readerTextController.dispose();
    _newSnippetController.dispose();
    _textToolController.dispose();
    _decisionInputController.dispose();
    super.dispose();
  }

  void _triggerNotification(String message) {
    setState(() {
      _bannerMessage = message;
      _showBannerNotification = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showBannerNotification = false;
        });
      }
    });
  }

  void _prepareSpeedReaderText() {
    final raw = _readerTextController.text.trim();
    if (raw.isNotEmpty) {
      setState(() {
        _readerWords = raw.split(RegExp(r'\s+'));
        _currentWordIndex = 0;
      });
    }
  }

  void _toggleSpeedReader() {
    if (_isReaderPlaying) {
      _readerTimer?.cancel();
      setState(() {
        _isReaderPlaying = false;
      });
    } else {
      if (_readerWords.isEmpty) _prepareSpeedReaderText();
      if (_currentWordIndex >= _readerWords.length) {
        _currentWordIndex = 0;
      }
      setState(() {
        _isReaderPlaying = true;
      });
      final intervalMs = (60000 / _wpm).round();
      _readerTimer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
        if (_currentWordIndex < _readerWords.length - 1) {
          setState(() {
            _currentWordIndex++;
          });
        } else {
          timer.cancel();
          setState(() {
            _isReaderPlaying = false;
          });
          _triggerNotification('Speed Reader completed session!');
        }
      });
    }
  }

  String _cleanUrl(String input) {
    try {
      final uri = Uri.parse(input);
      if (uri.hasQuery) {
        final cleanUri = Uri(
          scheme: uri.scheme,
          host: uri.host,
          path: uri.path,
        );
        return cleanUri.toString();
      }
    } catch (_) {}
    return input;
  }

  void _spinDecision() {
    if (_decisionOptions.isEmpty) return;
    setState(() {
      _isSpinningDecision = true;
      _decisionResult = 'Analyzing possibilities...';
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        final randomChoice = (_decisionOptions..shuffle()).first;
        setState(() {
          _decisionResult = randomChoice;
          _isSpinningDecision = false;
        });
        _triggerNotification('Decision Locked: $randomChoice');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // --- MAIN CONTENT AREA WITH SCROLLING & RESPONSIVENESS ---
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopHeader(),
                    const SizedBox(height: 16),
                    _buildFloatingOverlaySimulatorCard(),
                    const SizedBox(height: 20),
                    _buildTabBarNavigation(),
                    const SizedBox(height: 20),
                    _buildActiveTabContent(),
                  ],
                ),
              ),
            ),

            // --- FLOATING OVERLAY NOTIFICATION BANNER ---
            if (_showBannerNotification)
              Positioned(
                top: 12,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.indigo,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Colors.indigo, Colors.blueAccent],
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_active, color: Colors.white, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _bannerMessage,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 18),
                          onPressed: () {
                            setState(() {
                              _showBannerNotification = false;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

            // --- DRAGGABLE FLOATING BUBBLE OVERLAY ---
            Positioned(
              left: _bubblePosition.dx.clamp(10, screenSize.width - 70),
              top: _bubblePosition.dy.clamp(10, screenSize.height - 120),
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubblePosition += details.delta;
                  });
                },
                onTap: () {
                  setState(() {
                    _isBubbleExpanded = !_isBubbleExpanded;
                  });
                  _triggerNotification(
                    _isBubbleExpanded ? 'Floating Quick Dock Opened' : 'Floating Dock Minimized',
                  );
                },
                child: Material(
                  elevation: 10,
                  shape: const CircleBorder(),
                  color: Colors.transparent,
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colors.blueAccent, Colors.purpleAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isBubbleExpanded ? Icons.close : Icons.widgets,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),

            // --- EXPANDED FLOATING QUICK DOCK OVERLAY PANEL ---
            if (_isBubbleExpanded)
              Positioned(
                left: 20,
                right: 20,
                top: 140,
                child: Material(
                  elevation: 16,
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF1E293B),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.indigo.withOpacity(0.5), width: 1.5),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.bolt, color: Colors.amber, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Quick Floating Assist",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                              onPressed: () {
                                setState(() {
                                  _isBubbleExpanded = false;
                                });
                              },
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white70),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ActionChip(
                              avatar: const Icon(Icons.speed, size: 16, color: Colors.tealAccent),
                              label: const Text("Speed Reader", style: TextStyle(fontSize: 12)),
                              backgroundColor: const Color(0xFF0F172A),
                              onPressed: () {
                                setState(() {
                                  _selectedTabIndex = 0;
                                  _isBubbleExpanded = false;
                                });
                              },
                            ),
                            ActionChip(
                              avatar: const Icon(Icons.content_copy, size: 16, color: Colors.amber),
                              label: const Text("Snippet Stash", style: TextStyle(fontSize: 12)),
                              backgroundColor: const Color(0xFF0F172A),
                              onPressed: () {
                                setState(() {
                                  _selectedTabIndex = 1;
                                  _isBubbleExpanded = false;
                                });
                              },
                            ),
                            ActionChip(
                              avatar: const Icon(Icons.swap_horiz, size: 16, color: Colors.lightBlueAccent),
                              label: const Text("Quick Convert", style: TextStyle(fontSize: 12)),
                              backgroundColor: const Color(0xFF0F172A),
                              onPressed: () {
                                setState(() {
                                  _selectedTabIndex = 2;
                                  _isBubbleExpanded = false;
                                });
                              },
                            ),
                            ActionChip(
                              avatar: const Icon(Icons.casino, size: 16, color: Colors.purpleAccent),
                              label: const Text("Micro Decision", style: TextStyle(fontSize: 12)),
                              backgroundColor: const Color(0xFF0F172A),
                              onPressed: () {
                                setState(() {
                                  _selectedTabIndex = 3;
                                  _isBubbleExpanded = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- HEADER WIDGET ---
  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "BubbleDock Pro",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                "Your Dynamic Floating Screen Companion",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.indigo.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.indigo.withOpacity(0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.stars, color: Colors.amber, size: 16),
              SizedBox(width: 4),
              Text(
                "PRO ACTIVE",
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- SIMULATED OVERLAY STATUS BANNER ---
  Widget _buildFloatingOverlaySimulatorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.layers, color: Colors.indigoAccent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Interactive Screen Overlay",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  "Drag the blue bubble anywhere to use tools over any app context.",
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              _triggerNotification("Floating Dock is active and draggable!");
            },
            child: const Text(
              "Test Bubble",
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB BAR NAVIGATION ---
  Widget _buildTabBarNavigation() {
    final tabs = [
      {'icon': Icons.speed, 'label': 'Speed Read'},
      {'icon': Icons.content_copy, 'label': 'Snippets'},
      {'icon': Icons.swap_horiz, 'label': 'Converter'},
      {'icon': Icons.casino, 'label': 'Decision'},
      {'icon': Icons.text_fields, 'label': 'Text Tools'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedTabIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              showCheckmark: false,
              avatar: Icon(
                tabs[index]['icon'] as IconData,
                size: 16,
                color: isSelected ? Colors.white : Colors.grey,
              ),
              label: Text(
                tabs[index]['label'] as String,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
              selected: isSelected,
              selectedColor: Colors.indigo,
              backgroundColor: const Color(0xFF1E293B),
              onSelected: (bool selected) {
                if (selected) {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                }
              },
            ),
          );
        }),
      ),
    );
  }

  // --- ACTIVE TAB ROUTER ---
  Widget _buildActiveTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildSpeedReaderTab();
      case 1:
        return _buildSnippetStashTab();
      case 2:
        return _buildConverterTab();
      case 3:
        return _buildDecisionTab();
      case 4:
        return _buildTextToolsTab();
      default:
        return _buildSpeedReaderTab();
    }
  }

  // ==========================================
  // TAB 1: INSTANT SPEED READER (RSVP ENGINE)
  // ==========================================
  Widget _buildSpeedReaderTab() {
    final currentWord = _readerWords.isNotEmpty && _currentWordIndex < _readerWords.length
        ? _readerWords[_currentWordIndex]
        : "Paste Text Below";

    final progress = _readerWords.isEmpty ? 0.0 : (_currentWordIndex + 1) / _readerWords.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.speed, color: Colors.tealAccent, size: 20),
              SizedBox(width: 8),
              Text(
                "Focal Speed Reader (RSVP)",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Eliminate eye movement & read articles 3x faster word-by-word.",
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 16),

          // Focal Display Box
          Container(
            width: double.infinity,
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.tealAccent.withOpacity(0.3), width: 1.5),
            ),
            child: Text(
              currentWord,
              style: const TextStyle(
                color: Colors.tealAccent,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),

          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white70,
            color: Colors.tealAccent,
            minHeight: 6,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Word: ${_readerWords.isEmpty ? 0 : _currentWordIndex + 1} / ${_readerWords.length}",
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
              Text(
                "Speed: $_wpm WPM",
                style: const TextStyle(color: Colors.tealAccent, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Speed Slider
          Row(
            children: [
              const Text("150 WPM", style: TextStyle(color: Colors.grey, fontSize: 10)),
              Expanded(
                child: Slider(
                  value: _wpm.toDouble(),
                  min: 150,
                  max: 700,
                  divisions: 11,
                  activeColor: Colors.tealAccent,
                  inactiveColor: Colors.white70,
                  label: "$_wpm WPM",
                  onChanged: (val) {
                    setState(() {
                      _wpm = val.round();
                    });
                  },
                ),
              ),
              const Text("700 WPM", style: TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 12),

          // Control Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isReaderPlaying ? Colors.orange : Colors.tealAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _toggleSpeedReader,
                  icon: Icon(_isReaderPlaying ? Icons.pause : Icons.play_arrow, size: 20),
                  label: Text(
                    _isReaderPlaying ? "PAUSE" : "START READING",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white70,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _currentWordIndex = 0;
                  });
                  _prepareSpeedReaderText();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Text Input Box
          TextField(
            controller: _readerTextController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: "Paste long article or text here...",
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white70),
              ),
              filled: true,
              fillColor: const Color(0xFF0F172A),
            ),
            onChanged: (_) => _prepareSpeedReaderText(),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 2: SMART CLIPBOARD & SNIPPET STASH
  // ==========================================
  Widget _buildSnippetStashTab() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.content_copy, color: Colors.amber, size: 20),
              SizedBox(width: 8),
              Text(
                "Smart Snippet Stash & Link Cleaner",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Save temporary snippets & auto-remove tracking parameters from links.",
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 16),

          // New Snippet Input Box
          TextField(
            controller: _newSnippetController,
            maxLines: 2,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: "Enter text, phone number, address or URL...",
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white70),
              ),
              filled: true,
              fillColor: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              DropdownButton<String>(
                value: _selectedCategory,
                dropdownColor: const Color(0xFF0F172A),
                style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold),
                items: ['General', 'Links', 'Banking', 'Work', 'Personal']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCategory = val;
                    });
                  }
                },
              ),
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  final text = _newSnippetController.text.trim();
                  if (text.isNotEmpty) {
                    final cleaned = _cleanUrl(text);
                    setState(() {
                      _snippets.insert(
                        0,
                        SnippetItem(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          content: cleaned,
                          category: _selectedCategory,
                          createdAt: DateTime.now(),
                        ),
                      );
                      _newSnippetController.clear();
                    });
                    _triggerNotification("Snippet saved & cleaned!");
                  }
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text("SAVE SNIPPET", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          const Text(
            "Saved Stash Items:",
            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 12),
          ),
          const SizedBox(height: 8),

          if (_snippets.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text("No snippets saved yet.", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _snippets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = _snippets[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white70),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item.category,
                                style: const TextStyle(color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.content,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cleaning_services, color: Colors.tealAccent, size: 18),
                        tooltip: "Clean Tracking Parameters",
                        onPressed: () {
                          final cleaned = _cleanUrl(item.content);
                          _triggerNotification("Cleaned URL: $cleaned");
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
                        onPressed: () {
                          setState(() {
                            _snippets.removeAt(index);
                          });
                          _triggerNotification("Snippet removed!");
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 3: CONVERTER & QUICK CALCULATOR
  // ==========================================
  Widget _buildConverterTab() {
    double convertedVal = _converterInput * _conversionRate;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.swap_horiz, color: Colors.lightBlueAccent, size: 20),
              SizedBox(width: 8),
              Text(
                "Instant Micro-Converter",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Convert dynamic values quickly while multitasking.",
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 16),

          // Value Input Box
          TextField(
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              labelText: "Enter Amount / Value",
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white70),
              ),
              filled: true,
              fillColor: const Color(0xFF0F172A),
            ),
            onChanged: (val) {
              setState(() {
                _converterInput = double.tryParse(val) ?? 0.0;
              });
            },
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("From Unit", style: TextStyle(color: Colors.grey, fontSize: 10)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: const SizedBox(),
                        value: _fromUnit,
                        dropdownColor: const Color(0xFF0F172A),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        items: ['\$ USD', '€ EUR', '£ GBP', 'Meter', 'Km', 'Kg', 'Lbs']
                            .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _fromUnit = val);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.horizontal(8.0),
                child: Icon(Icons.arrow_forward, color: Colors.indigoAccent),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("To Unit", style: TextStyle(color: Colors.grey, fontSize: 10)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: const SizedBox(),
                        value: _toUnit,
                        dropdownColor: const Color(0xFF0F172A),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        items: ['€ EUR', '\$ USD', '£ GBP', 'Feet', 'Miles', 'Lbs', 'Kg']
                            .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _toUnit = val);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Output Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.lightBlueAccent.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text(
                  "Converted Output",
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 4),
                Text(
                  "${convertedVal.toStringAsFixed(2)} $_toUnit",
                  style: const TextStyle(
                    color: Colors.lightBlueAccent,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 4: MICRO DECISION MAKER MATRIX
  // ==========================================
  Widget _buildDecisionTab() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.casino, color: Colors.purpleAccent, size: 20),
              SizedBox(width: 8),
              Text(
                "Micro Decision Matrix",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Overcome decision fatigue. Pick randomly from your custom list.",
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 16),

          // Result Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purpleAccent.withOpacity(0.4)),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _decisionResult,
                key: ValueKey(_decisionResult),
                style: const TextStyle(
                  color: Colors.purpleAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purpleAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _isSpinningDecision ? null : _spinDecision,
            icon: const Icon(Icons.flare, size: 20),
            label: Text(
              _isSpinningDecision ? "SPINNING..." : "SPIN & DECIDE",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _decisionInputController,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: InputDecoration(
                    hintText: "Add option (e.g. Call Mom)",
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 11),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white70),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.purpleAccent.withOpacity(0.2),
                ),
                icon: const Icon(Icons.add, color: Colors.purpleAccent),
                onPressed: () {
                  final text = _decisionInputController.text.trim();
                  if (text.isNotEmpty) {
                    setState(() {
                      _decisionOptions.add(text);
                      _decisionInputController.clear();
                    });
                  }
                },
              )
            ],
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _decisionOptions.map((opt) {
              return Chip(
                backgroundColor: const Color(0xFF0F172A),
                label: Text(opt, style: const TextStyle(color: Colors.white, fontSize: 11)),
                deleteIcon: const Icon(Icons.close, size: 14, color: Colors.grey),
                onDeleted: () {
                  setState(() {
                    _decisionOptions.remove(opt);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 5: INSTANT TEXT POWER TOOLS
  // ==========================================
  Widget _buildTextToolsTab() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.text_fields, color: Colors.orangeAccent, size: 20),
              SizedBox(width: 8),
              Text(
                "Instant Text Utilities",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Format, strip spaces, convert cases, or analyze character counts.",
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _textToolController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            decoration: InputDecoration(
              hintText: "Enter or paste text to transform...",
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 11),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white70),
              ),
              filled: true,
              fillColor: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A)),
                onPressed: () {
                  setState(() {
                    _processedText = _textToolController.text.toUpperCase();
                  });
                },
                child: const Text("UPPERCASE", style: TextStyle(color: Colors.orangeAccent, fontSize: 10)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A)),
                onPressed: () {
                  setState(() {
                    _processedText = _textToolController.text.toLowerCase();
                  });
                },
                child: const Text("lowercase", style: TextStyle(color: Colors.orangeAccent, fontSize: 10)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A)),
                onPressed: () {
                  setState(() {
                    _processedText = _textToolController.text.replaceAll(RegExp(r'\s+'), ' ').trim();
                  });
                },
                child: const Text("Strip Extra Spaces", style: TextStyle(color: Colors.orangeAccent, fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (_processedText.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Transformed Result:", style: TextStyle(color: Colors.grey, fontSize: 10)),
                  const SizedBox(height: 4),
                  Text(
                    _processedText,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}