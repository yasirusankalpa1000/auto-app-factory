import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const OmniClipApp());
}

class OmniClipApp extends StatelessWidget {
  const OmniClipApp({super.key});

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'OmniClip',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
          primary: Colors.indigo,
          secondary: Colors.teal,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FE),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> meState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _isOverlayActive = true;
  String _activeDockStatus = "Live Clip Engine Running";

  final List<Widget> _pages = const [
    ContextSuiteTab(),
    ImpulseEngineTab(),
    FloatingHudTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.bolt, color: Colors.amber),
            SizedBox(width: 8),
            Text(
              'OmniClip Utility Hub',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isOverlayActive
                  ? Icons.notifications_active
                  : Icons.notifications_off,
              color: _isOverlayActive ? Colors.teal : Colors.grey,
            ),
            tooltip: 'Toggle Active Overlay Dock',
            onPressed: () {
              setState(() {
                _isOverlayActive = !_isOverlayActive;
                _activeDockStatus = _isOverlayActive
                    ? "Live Clip Engine Running"
                    : "Overlay Suspended";
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isOverlayActive
                      ? "Persistent Screen Overlay Enabled!"
                      : "Screen Overlay Disabled"),
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
            // Top Persistent Simulation Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: _isOverlayActive
                  ? Colors.indigo.withOpacity(0.08)
                  : Colors.grey.withOpacity(0.1),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isOverlayActive ? Colors.green : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'System Dock: $_activeDockStatus',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'ACTIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _pages[_currentIndex],
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.content_paste),
            selectedIcon: Icon(Icons.content_paste_go, color: Colors.indigo),
            label: 'Smart Clip',
          ),
          NavigationDestination(
            icon: Icon(Icons.attach_money),
            selectedIcon: Icon(Icons.monetization_on, color: Colors.indigo),
            label: 'Value Check',
          ),
          NavigationDestination(
            icon: Icon(Icons.widgets),
            selectedIcon: Icon(Icons.layers, color: Colors.indigo),
            label: 'Floating Dock',
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 1: SMART CONTEXT SUITE & TEXT TRANSFORMER
// ============================================================================
class ContextSuiteTab extends StatefulWidget {
  const ContextSuiteTab({super.key});

  @override
  State<ContextSuiteTab> createState() => _ContextSuiteTabState();
}

class _ContextSuiteTabState extends State<ContextSuiteTab> {
  final TextEditingController _inputController = TextEditingController();
  String _outputText = "";
  String _detectedType = "Empty";
  int _wordCount = 0;
  int _charCount = 0;
  int _readTimeSeconds = 0;

  // Speed reader state
  bool _isSpeedReading = false;
  List<String> _speedWords = [];
  int _currentWordIndex = 0;
  Timer? _speedTimer;
  int _wpm = 250;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_analyzeText);
    _inputController.text =
        "Check out this link: https://www.example.com/item?id=99283&utm_source=twitter&utm_medium=social & call support at +1-800-555-0199 for total \$49.99 deal!";
  }

  @override
  void dispose() {
    _inputController.dispose();
    _speedTimer?.cancel();
    super.dispose();
  }

  void _analyzeText() {
    final text = _inputController.text;
    setState(() {
      _charCount = text.length;
      final words = text.trim().split(RegExp(r'\s+'));
      _wordCount = text.trim().isEmpty ? 0 : words.length;
      _readTimeSeconds = ((_wordCount / 200) * 60).round();

      if (text.contains("http://") || text.contains("https://")) {
        _detectedType = "URL / Link Detected";
      } else if (text.contains(RegExp(r'\+?\d[\d\s-]{7,}\d'))) {
        _detectedType = "Phone / Contact Info";
      } else if (text.contains("\$") || text.contains("USD")) {
        _detectedType = "Price / Quote Detected";
      } else if (text.isNotEmpty) {
        _detectedType = "Plain Text Snippet";
      } else {
        _detectedType = "Empty";
      }
    });
  }

  void _cleanUrlParameters() {
    final text = _inputController.text;
    final urlRegex = RegExp(r'https?://[^\s]+');
    final matches = urlRegex.allMatches(text);

    if (matches.isEmpty) {
      setState(() {
        _outputText = "No URL found to clean!";
      });
      return;
    }

    String result = text;
    for (final match in matches) {
      final originalUrl = match.group(0)!;
      final uri = Uri.tryParse(originalUrl);
      if (uri != null && uri.hasQuery) {
        final cleanUri = uri.replace(queryParameters: {});
        result = result.replaceAll(originalUrl, cleanUri.toString());
      }
    }

    setState(() {
      _outputText = result;
    });
  }

  void _formatForWhatsApp() {
    final text = _inputController.text;
    if (text.isEmpty) return;

    final sb = StringBuffer();
    final lines = text.split('\n');
    sb.writeln('*--- OMNICLIP FORMATTED MESSAGE ---*');
    for (var line in lines) {
      if (line.trim().isNotEmpty) {
        sb.writeln('• ${line.trim()}');
      }
    }
    sb.writeln('\n_Sent via OmniClip Assistant_');

    setState(() {
      _outputText = sb.toString();
    });
  }

  void _extractEntities() {
    final text = _inputController.text;
    final sb = StringBuffer();

    // URLs
    final urlRegex = RegExp(r'https?://[^\s]+');
    final urls = urlRegex.allMatches(text).map((m) => m.group(0)).toList();

    // Numbers / Prices
    final priceRegex = RegExp(r'\$\d+(\.\d{1,2})?');
    final prices = priceRegex.allMatches(text).map((m) => m.group(0)).toList();

    // Phone numbers
    final phoneRegex = RegExp(r'\+?\d[\d\s-]{7,}\d');
    final phones = phoneRegex.allMatches(text).map((m) => m.group(0)).toList();

    sb.writeln('=== EXTRACTED DATA METRICS ===');
    sb.writeln('🔗 Links (${urls.length}): ${urls.join(", ")}');
    sb.writeln('💰 Prices (${prices.length}): ${prices.join(", ")}');
    sb.writeln('📞 Contacts (${phones.length}): ${phones.join(", ")}');

    setState(() {
      _outputText = sb.toString();
    });
  }

  void _transformCase(String type) {
    final text = _inputController.text;
    if (text.isEmpty) return;

    if (type == 'UPPER') {
      _outputText = text.toUpperCase();
    } else if (type == 'lower') {
      _outputText = text.toLowerCase();
    } else if (type == 'Title') {
      _outputText = text.split(' ').map((word) {
        if (word.isEmpty) return '';
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join(' ');
    }
    setState(() {});
  }

  void _startSpeedReader() {
    if (_inputController.text.trim().isEmpty) return;
    _speedWords = _inputController.text.trim().split(RegExp(r'\s+'));
    _currentWordIndex = 0;
    _isSpeedReading = true;

    final intervalMs = ((60 / _wpm) * 1000).round();
    _speedTimer?.cancel();
    _speedTimer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      if (_currentWordIndex < _speedWords.length - 1) {
        setState(() {
          _currentWordIndex++;
        });
      } else {
        timer.cancel();
        setState(() {
          _isSpeedReading = false;
        });
      }
    });
    setState(() {});
  }

  void _stopSpeedReader() {
    _speedTimer?.cancel();
    setState(() {
      _isSpeedReading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dynamic Header Card
          Card(
            color: Colors.indigo.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.cleaning_services, color: Colors.indigo),
                      SizedBox(width: 8),
                      Text(
                        'Live Clipboard & Context Engine',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Paste or type any raw snippet, URL, or chat message to clean, format, extract data, or speed read in real-time.',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Input Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Input Workspace',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Wrap(
                        spacing: 8,
                        children: [
                          InkWell(
                            onTap: () async {
                              final data =
                                  await Clipboard.getData(Clipboard.kTextPlain);
                              if (data != null && data.text != null) {
                                _inputController.text = data.text!;
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.content_paste,
                                      size: 14, color: Colors.indigo),
                                  SizedBox(width: 4),
                                  Text(
                                    'Paste',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _inputController.clear();
                              setState(() {
                                _outputText = "";
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.clear,
                                      size: 14, color: Colors.red),
                                  SizedBox(width: 4),
                                  Text(
                                    'Clear',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _inputController,
                    maxLines: 4,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Type or paste content here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Realtime Metrics Badges
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        avatar:
                            const Icon(Icons.find_in_page, size: 14),
                        label: Text(_detectedType,
                            style: const TextStyle(fontSize: 11)),
                        backgroundColor: Colors.teal.shade50,
                      ),
                      Chip(
                        avatar: const Icon(Icons.short_text, size: 14),
                        label: Text('$_wordCount Words | $_charCount Chars',
                            style: const TextStyle(fontSize: 11)),
                        backgroundColor: Colors.blue.shade50,
                      ),
                      Chip(
                        avatar: const Icon(Icons.timer_outlined, size: 14),
                        label: Text('~${_readTimeSeconds}s Read',
                            style: const TextStyle(fontSize: 11)),
                        backgroundColor: Colors.amber.shade50,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Speed Reader Dynamic Section
          if (_isSpeedReading)
            Card(
              color: Colors.black87,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'SPEED READER HUD',
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _speedWords.isNotEmpty
                          ? _speedWords[_currentWordIndex]
                          : '',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Word ${_currentWordIndex + 1} of ${_speedWords.length}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _stopSpeedReader,
                          icon: const Icon(Icons.stop, size: 16),
                          label: const Text('Stop HUD'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 8),

          // Action Grid
          const Text(
            'Context Transformations & Actions',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                avatar: const Icon(Icons.link_off, size: 16, color: Colors.indigo),
                label: const Text('Strip URL Parameters'),
                onPressed: _cleanUrlParameters,
              ),
              ActionChip(
                avatar: const Icon(Icons.chat, size: 16, color: Colors.teal),
                label: const Text('WhatsApp Format'),
                onPressed: _formatForWhatsApp,
              ),
              ActionChip(
                avatar: const Icon(Icons.search, size: 16, color: Colors.blue),
                label: const Text('Extract Entities'),
                onPressed: _extractEntities,
              ),
              ActionChip(
                avatar:
                    const Icon(Icons.speed, size: 16, color: Colors.amber),
                label: const Text('Speed Reader HUD'),
                onPressed: _startSpeedReader,
              ),
              ActionChip(
                avatar: const Icon(Icons.text_fields,
                    size: 16, color: Colors.purple),
                label: const Text('UPPERCASE'),
                onPressed: () => _transformCase('UPPER'),
              ),
              ActionChip(
                avatar: const Icon(Icons.text_format,
                    size: 16, color: Colors.orange),
                label: const Text('lowercase'),
                onPressed: () => _transformCase('lower'),
              ),
              ActionChip(
                avatar: const Icon(Icons.title, size: 16, color: Colors.green),
                label: const Text('Title Case'),
                onPressed: () => _transformCase('Title'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Output Display Card
          if (_outputText.isNotEmpty)
            Card(
              color: Colors.grey.shade900,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Transformed Output',
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy,
                              color: Colors.white, size: 18),
                          tooltip: 'Copy Output',
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: _outputText));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Copied output to clipboard!'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white70),
                    const SizedBox(height: 4),
                    Text(
                      _outputText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'monospace',
                      ),
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

// ============================================================================
// TAB 2: IMPULSE BUY & MICRO-VALUE CALCULATOR
// ============================================================================
class ImpulseEngineTab extends StatefulWidget {
  const ImpulseEngineTab({super.key});

  @override
  State<ImpulseEngineTab> createState() => _ImpulseEngineTabState();
}

class _ImpulseEngineTabState extends State<ImpulseEngineTab> {
  double _itemPrice = 85.0;
  double _hourlyWage = 22.0;

  @override
  Widget build(BuildContext context) {
    final double hoursNeeded =
        _hourlyWage > 0 ? _itemPrice / _hourlyWage : 0;
    final double daysNeeded = hoursNeeded / 8.0;
    final double coffeeEquivalent = _itemPrice / 4.50; // \$4.50 coffee
    final double streamingMonths = _itemPrice / 15.0; // \$15 subscription

    String verdict;
    Color verdictColor;
    if (hoursNeeded > 20) {
      verdict = "High Financial Impact — Sleep on this for 48 Hours!";
      verdictColor = Colors.red.shade700;
    } else if (hoursNeeded > 8) {
      verdict = "Significant Spend — Weigh carefully against your goals.";
      verdictColor = Colors.orange.shade800;
    } else {
      verdict = "Low Friction Buy — Fits comfortably into micro budget.";
      verdictColor = Colors.green.shade700;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: Colors.teal.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.shopping_bag_outlined, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(
                        'Impulse Buy & Work-Hour Reality Check',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Before hitting "Buy Now", calculate how many actual hours of your life and labor this item costs.',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Sliders Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Item Price: \$${_itemPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Slider(
                    value: _itemPrice,
                    min: 5,
                    max: 1000,
                    divisions: 199,
                    activeColor: Colors.indigo,
                    label: '\$${_itemPrice.round()}',
                    onChanged: (val) {
                      setState(() {
                        _itemPrice = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your Hourly Wage: \$${_hourlyWage.toStringAsFixed(2)}/hr',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Slider(
                    value: _hourlyWage,
                    min: 5,
                    max: 150,
                    divisions: 145,
                    activeColor: Colors.teal,
                    label: '\$${_hourlyWage.round()}/hr',
                    onChanged: (val) {
                      setState(() {
                        _hourlyWage = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Real Cost Metrics Grid
          Card(
            color: Colors.indigo.shade900,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'TRUE COST IN WORK HOURS',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${hoursNeeded.toStringAsFixed(1)} Work Hours',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '≈ ${daysNeeded.toStringAsFixed(1)} Full Work Days (8h/day)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  const Divider(color: Colors.white70, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: Column(
                          children: [
                            const Text('☕ Coffees',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 11)),
                            const SizedBox(height: 4),
                            Text(
                              coffeeEquivalent.toStringAsFixed(0),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Column(
                          children: [
                            const Text('📺 Subscriptions',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 11)),
                            const SizedBox(height: 4),
                            Text(
                              '${streamingMonths.toStringAsFixed(1)} Months',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Decision Verdict Card
          Card(
            color: verdictColor.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: verdictColor, width: 1.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.info, color: verdictColor, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Decision Verdict',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: verdictColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          verdict,
                          style: TextStyle(
                            color: Colors.grey.shade900,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
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

// ============================================================================
// TAB 3: FLOATING HUD & OVERLAY SIMULATOR
// ============================================================================
class FloatingHudTab extends StatefulWidget {
  const FloatingHudTab({super.key});

  @override
  State<FloatingHudTab> createState() => _FloatingHudTabState();
}

class _FloatingHudTabState extends State<FloatingHudTab> {
  String _hudMessage = "Ready for continuous micro-tasks!";
  int _counterAction = 0;
  String _microDecision = "Tap decision wheel below";

  final List<String> _decisions = [
    "✅ Do it right now!",
    "⏳ Wait 15 minutes first",
    "❌ Skip it for today",
    "☕ Take a 2-minute breath",
    "💬 Reply later with focus"
  ];

  void _rollDecision() {
    setState(() {
      _microDecision = (_decisions..shuffle()).first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: Colors.purple.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.layers, color: Colors.purple),
                      SizedBox(width: 8),
                      Text(
                        'Interactive Dynamic Overlay HUD',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Simulates a persistent floating dock that stays accessible over other app workflows to run continuous micro-decisions and quick transformations.',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Interactive Overlay Floating Widget Box
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.purple, width: 2),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.purple.shade900, Colors.indigo.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.drag_handle, color: Colors.white70),
                          SizedBox(width: 8),
                          Text(
                            'FLOATING ASSISTANT DOCK',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'ON TOP',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text(
                    _hudMessage,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _counterAction++;
                            _hudMessage =
                                "Quick Click Recorded! Count: $_counterAction";
                          });
                        },
                        icon: const Icon(Icons.touch_app, size: 14),
                        label: const Text('Quick Tally'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final clip =
                              await Clipboard.getData(Clipboard.kTextPlain);
                          if (clip != null && clip.text != null) {
                            setState(() {
                              _hudMessage = "Clip Captured: ${clip.text}";
                            });
                          }
                        },
                        icon: const Icon(Icons.paste, size: 14),
                        label: const Text('Grab Clipboard'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Micro Decision Matrix Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Micro-Decision Matrix ("Should I do this now?")',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Eliminate hesitation fatigue for quick daily choices.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      _microDecision,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _rollDecision,
                      icon: const Icon(Icons.shuffle),
                      label: const Text('Spin Micro-Decision Engine'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
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