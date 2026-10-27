import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const ContextPulseApp());
}

class ContextPulseApp extends StatelessWidget {
  const ContextPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ContextPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF12141D),
        colorScheme: const ColorScheme.dark(
          primary: Colors.indigoAccent,
          secondary: Colors.tealAccent,
          surface: Color(0xFF1E2230),
        ),
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
  int _selectedIndex = 0;

  // Floating Overlay States
  bool _overlayActive = true;
  bool _screenTintActive = false;
  Color _tintColor = Colors.amber;
  Offset _bubblePosition = const Offset(20, 180);
  bool _isBubbleExpanded = false;

  // Clipboard & Parser State
  final TextEditingController _clipboardController = TextEditingController();
  List<String> _savedClips = [];
  List<String> _extractedLinks = [];
  List<String> _extractedPhones = [];
  List<double> _extractedPrices = [];

  // Speed Reader State
  final TextEditingController _readerTextController = TextEditingController();
  List<String> _readerWords = [];
  int _currentWordIndex = 0;
  bool _isPlayingReader = false;
  int _wpm = 350;
  Timer? _readerTimer;

  // Decision Wheel State
  final TextEditingController _decisionInputController = TextEditingController();
  List<String> _decisionOptions = ['Buy Now', 'Wait 24 Hours', 'Ask a Friend', 'Skip It'];
  String _selectedDecision = '';
  bool _isSpinningDecision = false;

  @override
  void initState() {
    super.initState();
    _clipboardController.text =
        "Hey! Check out this item at https://example.com/item priced at \$49.99 and another model for \$19.50. Call support at +18005550199 for discount code SAVE20.";
    _readerTextController.text =
        "Speed reading uses Rapid Serial Visual Presentation to present words sequentially in a fixed focal point. This dramatically reduces eye movement and allows you to read long articles, documents, and news up to three times faster without sacrificing comprehension!";
    _parseTextContent(_clipboardController.text);
    _prepareReaderWords();
  }

  @override
  void dispose() {
    _readerTimer?.cancel();
    _clipboardController.dispose();
    _readerTextController.dispose();
    _decisionInputController.dispose();
    super.dispose();
  }

  // --- LOGIC HELPER METHODS ---
  void _parseTextContent(String text) {
    setState(() {
      // Find URLs
      final urlRegExp = RegExp(r'https?://[^\s]+');
      _extractedLinks = urlRegExp.allMatches(text).map((m) => m.group(0)!).toList();

      // Find Phone Numbers
      final phoneRegExp = RegExp(r'\+?[0-9\-\s]{8,15}');
      _extractedPhones = phoneRegExp
          .allMatches(text)
          .map((m) => m.group(0)!.trim())
          .where((p) => p.length >= 8)
          .toList();

      // Find Dollar Prices
      final priceRegExp = RegExp(r'\$([0-9]+(?:\.[0-9]{1,2})?)');
      _extractedPrices = priceRegExp
          .allMatches(text)
          .map((m) => double.tryParse(m.group(1) ?? '0') ?? 0.0)
          .where((val) => val > 0)
          .toList();
    });
  }

  void _prepareReaderWords() {
    final cleanText = _readerTextController.text.replaceAll('\n', ' ').trim();
    if (cleanText.isNotEmpty) {
      setState(() {
        _readerWords = cleanText.split(RegExp(r'\s+'));
        _currentWordIndex = 0;
      });
    }
  }

  void _toggleReaderPlay() {
    if (_isPlayingReader) {
      _readerTimer?.cancel();
      setState(() {
        _isPlayingReader = false;
      });
    } else {
      if (_readerWords.isEmpty) _prepareReaderWords();
      if (_readerWords.isEmpty) return;

      setState(() {
        _isPlayingReader = true;
      });

      final intervalMs = (60000 / _wpm).round();
      _readerTimer?.cancel();
      _readerTimer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
        setState(() {
          if (_currentWordIndex < _readerWords.length - 1) {
            _currentWordIndex++;
          } else {
            _isPlayingReader = false;
            _readerTimer?.cancel();
          }
        });
      });
    }
  }

  void _makeRandomDecision() {
    if (_decisionOptions.isEmpty) return;
    setState(() {
      _isSpinningDecision = true;
      _selectedDecision = 'Thinking...';
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _decisionOptions.shuffle();
        _selectedDecision = _decisionOptions.first;
        _isSpinningDecision = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Body Screen Content
          SafeArea(
            child: Column(
              children: [
                _buildTopNavigationBar(),
                Expanded(
                  child: _buildSelectedTabContent(),
                ),
              ],
            ),
          ),

          // Optional Tint Overlay Filter (Simulated Screen Filter)
          if (_screenTintActive)
            IgnorePointer(
              child: Container(
                color: _tintColor.withOpacity(0.12),
              ),
            ),

          // Interactive Draggable Floating Overlay Hub
          if (_overlayActive) _buildDraggableFloatingHub(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF181B26),
        selectedItemColor: Colors.indigoAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.speed),
            label: 'Speed Reader',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: 'Clip Parser',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Overlay Deck',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: 'Decision Matrix',
          ),
        ],
      ),
    );
  }

  // --- TOP NAVIGATION BAR ---
  Widget _buildTopNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF181B26),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigoAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.bolt, color: Colors.indigoAccent, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ContextPulse',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Active Smart Overlay Utility',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Toggle Tint Filter',
            icon: Icon(
              Icons.remove_red_eye,
              color: _screenTintActive ? Colors.amber : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _screenTintActive = !_screenTintActive;
              });
            },
          ),
          IconButton(
            tooltip: 'Toggle Floating Bubble',
            icon: Icon(
              Icons.layers,
              color: _overlayActive ? Colors.tealAccent : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _overlayActive = !_overlayActive;
              });
            },
          ),
        ],
      ),
    );
  }

  // --- TAB CONTENT ROUTER ---
  Widget _buildSelectedTabContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildSpeedReaderTab();
      case 1:
        return _buildClipParserTab();
      case 2:
        return _buildOverlayDeckTab();
      case 3:
        return _buildDecisionMatrixTab();
      default:
        return _buildSpeedReaderTab();
    }
  }

  // --- TAB 1: RSVP SPEED READER ---
  Widget _buildSpeedReaderTab() {
    final currentWord = _readerWords.isNotEmpty && _currentWordIndex < _readerWords.length
        ? _readerWords[_currentWordIndex]
        : 'Ready';

    final progress = _readerWords.isNotEmpty ? (_currentWordIndex + 1) / _readerWords.length : 0.0;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Flash Display Card
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2230),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.indigoAccent.withOpacity(0.4), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Center Focal Guides
                  Positioned(
                    top: 15,
                    bottom: 15,
                    child: Container(
                      width: 2,
                      color: Colors.indigoAccent.withOpacity(0.2),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        currentWord,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.tealAccent,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 16,
                    right: 16,
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          backgroundColor: Colors.grey.shade800,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.indigoAccent),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Word ${_readerWords.isEmpty ? 0 : _currentWordIndex + 1} of ${_readerWords.length}',
                              style: const TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                            Text(
                              '$_wpm WPM',
                              style: const TextStyle(color: Colors.indigoAccent, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Controls Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2230),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isPlayingReader ? Colors.deepOrange : Colors.indigoAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _toggleReaderPlay,
                        icon: Icon(_isPlayingReader ? Icons.pause : Icons.play_arrow, color: Colors.white),
                        label: Text(
                          _isPlayingReader ? 'Pause' : 'Start Reading',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          setState(() {
                            _currentWordIndex = 0;
                            _isPlayingReader = false;
                            _readerTimer?.cancel();
                          });
                        },
                        icon: const Icon(Icons.refresh, color: Colors.grey),
                        label: const Text('Reset', style: TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Speed: ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      Expanded(
                        child: Slider(
                          value: _wpm.toDouble(),
                          min: 150,
                          max: 700,
                          divisions: 11,
                          activeColor: Colors.tealAccent,
                          label: '$_wpm WPM',
                          onChanged: (val) {
                            setState(() {
                              _wpm = val.round();
                              if (_isPlayingReader) {
                                _toggleReaderPlay();
                                _toggleReaderPlay();
                              }
                            });
                          },
                        ),
                      ),
                      Text('$_wpm WPM', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Source Input Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2230),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Paste Article / Text to Speed Read',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _readerTextController,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Paste article content here...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF12141D),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (_) => _prepareReaderWords(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 2: CLIPBOARD & SMART TEXT PARSER ---
  Widget _buildClipParserTab() {
    double totalSum = _extractedPrices.fold(0.0, (a, b) => a + b);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main Input Area
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2230),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Smart Content Extractor',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                        onPressed: () {
                          _clipboardController.clear();
                          _parseTextContent('');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _clipboardController,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Paste message, bill, receipt text or email contents here...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF12141D),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (text) => _parseTextContent(text),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigoAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            if (_clipboardController.text.trim().isNotEmpty) {
                              setState(() {
                                _savedClips.insert(0, _clipboardController.text.trim());
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Clip saved to history stack!')),
                              );
                            }
                          },
                          icon: const Icon(Icons.add_to_photos, color: Colors.white, size: 18),
                          label: const Text('Save Clip', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Auto-Parsed Results Display
            const Text(
              'Extracted Insights & Data',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 10),

            // Dollar Totals Chip Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2230),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.monetization_on, color: Colors.tealAccent, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Detected Prices Sum', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text(
                          '\$${totalSum.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.tealAccent, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Chip(
                    backgroundColor: Colors.tealAccent.withOpacity(0.15),
                    label: Text(
                      '${_extractedPrices.length} Items Found',
                      style: const TextStyle(color: Colors.tealAccent, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Extracted Links
            _buildParsedCategoryCard(
              title: 'Web Links',
              icon: Icons.link,
              iconColor: Colors.blueAccent,
              items: _extractedLinks,
              emptyMessage: 'No links detected in text.',
            ),
            const SizedBox(height: 12),

            // Extracted Phone Numbers
            _buildParsedCategoryCard(
              title: 'Phone Numbers',
              icon: Icons.phone,
              iconColor: Colors.greenAccent,
              items: _extractedPhones,
              emptyMessage: 'No phone numbers detected.',
            ),
            const SizedBox(height: 16),

            // Saved Clips Stack History
            if (_savedClips.isNotEmpty) ...[
              const Text(
                'Saved Clips History',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _savedClips.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color(0xFF1E2230),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      dense: true,
                      title: Text(
                        _savedClips[index],
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 18),
                        onPressed: () {
                          setState(() {
                            _savedClips.removeAt(index);
                          });
                        },
                      ),
                      onTap: () {
                        _clipboardController.text = _savedClips[index];
                        _parseTextContent(_savedClips[index]);
                      },
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildParsedCategoryCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<String> items,
    required String emptyMessage,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2230),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          if (items.isEmpty)
            Text(emptyMessage, style: const TextStyle(color: Colors.grey, fontSize: 12))
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: items
                  .map(
                    (item) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF12141D),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: iconColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              item,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Copied: $item')),
                              );
                            },
                            child: Icon(Icons.copy, color: iconColor, size: 14),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  // --- TAB 3: OVERLAY DECK CONTROLLER ---
  Widget _buildOverlayDeckTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2230),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    _overlayActive ? Icons.check_circle : Icons.pause_circle_filled,
                    color: _overlayActive ? Colors.tealAccent : Colors.grey,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _overlayActive ? 'Floating Hub Active' : 'Floating Hub Hidden',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          softWrap: true,
                        ),
                        const Text(
                          'Simulated live screen overlay mini-tools bubble',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _overlayActive,
                    activeColor: Colors.tealAccent,
                    onChanged: (val) => setState(() => _overlayActive = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tint Filter Settings
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2230),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Night Light & Eye Tint Overlay',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Switch(
                        value: _screenTintActive,
                        activeColor: Colors.amber,
                        onChanged: (val) => setState(() => _screenTintActive = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('Select Tint Shade:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTintOption(Colors.amber, 'Warm Amber'),
                      _buildTintOption(Colors.deepOrange, 'Soft Red'),
                      _buildTintOption(Colors.teal, 'Cool Teal'),
                      _buildTintOption(Colors.indigo, 'Deep Blue'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Live Floating Notification Preview Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2230),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Active Notification Bar Live Status',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF12141D),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.indigoAccent.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.indigoAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.speed, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ContextPulse Reader Running',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                                softWrap: true,
                              ),
                              Text(
                                'Speed: 350 WPM • 1 Context Clip Ready',
                                style: TextStyle(color: Colors.grey, fontSize: 11),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.tealAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('ACTIVE', style: TextStyle(color: Colors.tealAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
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

  Widget _buildTintOption(Color color, String label) {
    bool isSelected = _tintColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          _tintColor = color;
          _screenTintActive = true;
        });
      },
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  // --- TAB 4: MICRO-DECISION MATRIX ---
  Widget _buildDecisionMatrixTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2230),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.help_outline, color: Colors.tealAccent, size: 40),
                  const SizedBox(height: 8),
                  const Text(
                    'Instant Choice Generator',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Eliminate micro-decision fatigue in daily routines',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Result Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF12141D),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.indigoAccent, width: 1.5),
                    ),
                    child: Column(
                      children: [
                        const Text('RECOMMENDED ACTION', style: TextStyle(color: Colors.grey, fontSize: 11, letterSpacing: 1)),
                        const SizedBox(height: 8),
                        Text(
                          _selectedDecision.isEmpty ? 'Tap Decide Below' : _selectedDecision,
                          style: TextStyle(
                            color: _isSpinningDecision ? Colors.amber : Colors.tealAccent,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _isSpinningDecision ? null : _makeRandomDecision,
                    icon: const Icon(Icons.auto_awesome, color: Colors.white),
                    label: const Text('Decide Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Option List Editor
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2230),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Customize Decision Options', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _decisionInputController,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Add new choice option...',
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: const Color(0xFF12141D),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.tealAccent,
                        ),
                        icon: const Icon(Icons.add, color: Colors.black),
                        onPressed: () {
                          if (_decisionInputController.text.trim().isNotEmpty) {
                            setState(() {
                              _decisionOptions.add(_decisionInputController.text.trim());
                              _decisionInputController.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _decisionOptions
                        .map(
                          (opt) => Chip(
                            backgroundColor: const Color(0xFF12141D),
                            label: Text(opt, style: const TextStyle(color: Colors.white, fontSize: 12)),
                            deleteIcon: const Icon(Icons.close, size: 14, color: Colors.grey),
                            onDeleted: () {
                              setState(() {
                                _decisionOptions.remove(opt);
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- FLOATING OVERLAY HUD BUBBLE SIMULATOR ---
  Widget _buildDraggableFloatingHub() {
    return Positioned(
      left: _bubblePosition.dx,
      top: _bubblePosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubblePosition += details.delta;
          });
        },
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isBubbleExpanded = !_isBubbleExpanded;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2230),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.tealAccent, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.bolt, color: Colors.tealAccent, size: 26),
                ),
              ),
              if (_isBubbleExpanded)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(12),
                  width: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2230),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.indigoAccent),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Floating Tools',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const Divider(color: Colors.grey, height: 12),
                      ListTile(
                        dense: true,
                        padding: EdgeInsets.zero,
                        leading: const Icon(Icons.speed, color: Colors.tealAccent, size: 18),
                        title: const Text('Speed Reader', style: TextStyle(color: Colors.white, fontSize: 11)),
                        onTap: () {
                          setState(() {
                            _selectedIndex = 0;
                            _isBubbleExpanded = false;
                          });
                        },
                      ),
                      ListTile(
                        dense: true,
                        padding: EdgeInsets.zero,
                        leading: const Icon(Icons.content_paste, color: Colors.indigoAccent, size: 18),
                        title: const Text('Clip Parser', style: TextStyle(color: Colors.white, fontSize: 11)),
                        onTap: () {
                          setState(() {
                            _selectedIndex = 1;
                            _isBubbleExpanded = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}