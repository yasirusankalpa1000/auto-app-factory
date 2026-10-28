import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const DeskDeckApp());
}

class DeskDeckApp extends StatelessWidget {
  const DeskDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeskDeck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        cardTheme: CardTheme(
          color: const Color(0xFF1E293B),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
  int _currentIndex = 0;
  bool _isFloatingOverlayVisible = false;
  Offset _overlayPosition = const Offset(20, 120);

  final List<Widget> _pages = const [
    LinkSanitizerTab(),
    ValueCalcTab(),
    DecisionWheelTab(),
    DeskCompanionTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.indigo.shade600,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.deck, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              'DeskDeck',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Toggle Floating Utility Dock',
            icon: Icon(
              _isFloatingOverlayVisible ? Icons.layers_clear : Icons.layers,
              color: _isFloatingOverlayVisible ? Colors.cyan : Colors.white70,
            ),
            onPressed: () {
              setState(() {
                _isFloatingOverlayVisible = !_isFloatingOverlayVisible;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 2),
                  content: Text(
                    _isFloatingOverlayVisible
                        ? 'Floating Dock Overlay Activated!'
                        : 'Floating Dock Hidden',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: _pages[_currentIndex],
          ),
          if (_isFloatingOverlayVisible)
            Positioned(
              left: _overlayPosition.dx,
              top: _overlayPosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _overlayPosition += details.delta;
                  });
                },
                child: Material(
                  elevation: 12,
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.indigo.shade900.withOpacity(0.95),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.cyan.shade400, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.drag_indicator, color: Colors.white70, size: 18),
                        const SizedBox(width: 6),
                        IconButton(
                          icon: const Icon(Icons.cleaning_services, color: Colors.cyan, size: 20),
                          onPressed: () {
                            setState(() => _currentIndex = 0);
                          },
                          tooltip: 'Link Cleaner',
                        ),
                        IconButton(
                          icon: const Icon(Icons.monetization_on, color: Colors.greenAccent, size: 20),
                          onPressed: () {
                            setState(() => _currentIndex = 1);
                          },
                          tooltip: 'Value Calc',
                        ),
                        IconButton(
                          icon: const Icon(Icons.casino, color: Colors.amber, size: 20),
                          onPressed: () {
                            setState(() => _currentIndex = 2);
                          },
                          tooltip: 'Decision Spinner',
                        ),
                        IconButton(
                          icon: const Icon(Icons.desktop_windows, color: Colors.purpleAccent, size: 20),
                          onPressed: () {
                            setState(() => _currentIndex = 3);
                          },
                          tooltip: 'Desk Mode',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.white70,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: 'Sanitizer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Value Split',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.casino),
            label: 'Decision',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.desktop_windows),
            label: 'Desk Dock',
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 1: LINK SANITIZER & TEXT WORKBENCH
// ============================================================================
class LinkSanitizerTab extends StatefulWidget {
  const LinkSanitizerTab({super.key});

  @override
  State<LinkSanitizerTab> createState() => _LinkSanitizerTabState();
}

class _LinkSanitizerTabState extends State<LinkSanitizerTab> {
  final TextEditingController _inputController = TextEditingController();
  String _cleanedText = '';
  List<String> _extractedLinks = [];
  List<String> _extractedEmails = [];
  List<String> _extractedHashtags = [];

  void _processText() {
    final raw = _inputController.text;
    if (raw.trim().isEmpty) {
      setState(() {
        _cleanedText = '';
        _extractedLinks = [];
        _extractedEmails = [];
        _extractedHashtags = [];
      });
      return;
    }

    // 1. Clean Tracking Parameters
    String result = raw;
    result = result.replaceAll(RegExp(r'(\?|&)(utm_[^&\s]+|igsh=[^&\s]+|si=[^&\s]+|fbclid=[^&\s]+|gclid=[^&\s]+|mc_cid=[^&\s]+)'), '');
    result = result.replaceAll(RegExp(r'\?&'), '?');
    if (result.endsWith('?') || result.endsWith('&')) {
      result = result.substring(0, result.length - 1);
    }

    // 2. Extract Elements
    final urlRegex = RegExp(r'https?://[^\s]+', caseSensitive: false);
    final emailRegex = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', caseSensitive: false);
    final hashtagRegex = RegExp(r'#[a-zA-Z0-9_]+');

    final links = urlRegex.allMatches(raw).map((m) => m.group(0) ?? '').toList();
    final emails = emailRegex.allMatches(raw).map((m) => m.group(0) ?? '').toList();
    final hashtags = hashtagRegex.allMatches(raw).map((m) => m.group(0) ?? '').toList();

    setState(() {
      _cleanedText = result;
      _extractedLinks = links;
      _extractedEmails = emails;
      _extractedHashtags = hashtags;
    });
  }

  void _loadSampleText() {
    _inputController.text =
        "Check this video https://youtube.com/watch?v=dQw4w9WgXcQ?si=abc123tracking&utm_source=copy !\n"
        "Also Instagram link: https://instagram.com/p/C12345/?igsh=XYZ987_test\n"
        "Contact me at support@deskdeck.app or #flutter #viral #tech";
    _processText();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Link Cleaner & Text Workbench',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  softWrap: true,
                ),
              ),
              TextButton.icon(
                onPressed: _loadSampleText,
                icon: const Icon(Icons.lightbulb, size: 16, color: Colors.cyan),
                label: const Text('Sample', style: TextStyle(color: Colors.cyan)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Paste messy social links or text. Removes ?igsh=, ?utm_, ?si= trackers instantly for privacy and clean sharing!',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _inputController,
            maxLines: 4,
            onChanged: (_) => _processText(),
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Paste messy links or block of text here...',
              hintStyle: TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Color(0xFF1E293B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _processText,
                  icon: const Icon(Icons.auto_fix_high, color: Colors.white),
                  label: const Text('Clean & Strip Trackers', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  padding: const EdgeInsets.all(12),
                ),
                icon: const Icon(Icons.clear, color: Colors.white70),
                onPressed: () {
                  _inputController.clear();
                  _processText();
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_cleanedText.isNotEmpty) ...[
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
                          'Cleaned Output:',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.cyan),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18, color: Colors.cyan),
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
                      _cleanedText,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (_extractedLinks.isNotEmpty || _extractedEmails.isNotEmpty || _extractedHashtags.isNotEmpty) ...[
            const Text(
              'Extracted Elements:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAxisAlignment.center,
              children: [
                ..._extractedLinks.map((url) => Chip(
                      avatar: const Icon(Icons.link, size: 16, color: Colors.cyan),
                      label: Text(url.length > 25 ? '${url.substring(0, 25)}...' : url),
                      backgroundColor: const Color(0xFF1E293B),
                      labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                    )),
                ..._extractedEmails.map((email) => Chip(
                      avatar: const Icon(Icons.email, size: 16, color: Colors.amber),
                      label: Text(email),
                      backgroundColor: const Color(0xFF1E293B),
                      labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                    )),
                ..._extractedHashtags.map((tag) => Chip(
                      avatar: const Icon(Icons.tag, size: 16, color: Colors.purpleAccent),
                      label: Text(tag),
                      backgroundColor: const Color(0xFF1E293B),
                      labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                    )),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 2: VALUE CALCULATOR & BILL SPLITTER
// ============================================================================
class ValueCalcTab extends StatefulWidget {
  const ValueCalcTab({super.key});

  @override
  State<ValueCalcTab> createState() => _ValueCalcTabState();
}

class _ValueCalcTabState extends State<ValueCalcTab> {
  // Buy or Pass state
  final TextEditingController _priceController = TextEditingController(text: '120');
  final TextEditingController _usesController = TextEditingController(text: '30');
  double _costPerUse = 4.0;
  String _verdict = 'Fair Value';
  Color _verdictColor = Colors.orange;

  // Bill Splitter state
  double _billAmount = 85.0;
  int _peopleCount = 3;
  double _tipPercentage = 15;

  void _calculatePurchaseValue() {
    final price = double.tryParse(_priceController.text) ?? 0;
    final uses = double.tryParse(_usesController.text) ?? 1;

    if (uses <= 0) return;

    final cost = price / uses;
    String verdict = 'Great Value';
    Color color = Colors.green;

    if (cost > 10) {
      verdict = 'Impulse Buy Warning!';
      color = Colors.redAccent;
    } else if (cost > 3) {
      verdict = 'Fair Daily Value';
      color = Colors.amber;
    }

    setState(() {
      _costPerUse = cost;
      _verdict = verdict;
      _verdictColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalTip = _billAmount * (_tipPercentage / 100);
    final totalBill = _billAmount + totalTip;
    final perPerson = totalBill / (_peopleCount > 0 ? _peopleCount : 1);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Should I Buy It? (Cost-Per-Use)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'Evaluate if a purchase is worth buying based on predicted usage!',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => _calculatePurchaseValue(),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Price (\$)',
                            labelStyle: TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _usesController,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => _calculatePurchaseValue(),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Expected Uses',
                            labelStyle: TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _verdictColor, width: 1.5),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Cost Per Use: \$${_costPerUse.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _verdict,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _verdictColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Equals roughly ${(_costPerUse / 4.5).toStringAsFixed(1)} cups of coffee per wear/use.',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Micro Bill & Tip Splitter',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'Quickly share lunch/dinner bills transparently with friends.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Bill Amount:', style: TextStyle(color: Colors.white70)),
                      Text('\$${_billAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.cyan)),
                    ],
                  ),
                  Slider(
                    value: _billAmount,
                    min: 5,
                    max: 500,
                    divisions: 99,
                    activeColor: Colors.cyan,
                    onChanged: (v) => setState(() => _billAmount = v),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tip Percentage (${_tipPercentage.toInt()}%):', style: const TextStyle(color: Colors.white70)),
                      Text('\$${totalTip.toStringAsFixed(2)}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: _tipPercentage,
                    min: 0,
                    max: 30,
                    divisions: 6,
                    activeColor: Colors.amber,
                    onChanged: (v) => setState(() => _tipPercentage = v),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Split Between ($_peopleCount People):', style: const TextStyle(color: Colors.white70)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.white70),
                            onPressed: _peopleCount > 1 ? () => setState(() => _peopleCount--) : null,
                          ),
                          Text('$_peopleCount', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Colors.white70),
                            onPressed: () => setState(() => _peopleCount++),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white70, height: 24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade900,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Each Person Pays:',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          '\$${perPerson.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.greenAccent),
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
// TAB 3: MICRO-DECISION WHEEL
// ============================================================================
class DecisionWheelTab extends StatefulWidget {
  const DecisionWheelTab({super.key});

  @override
  State<DecisionWheelTab> createState() => _DecisionWheelTabState();
}

class _DecisionWheelTabState extends State<DecisionWheelTab> with SingleTickerProviderStateMixin {
  final List<String> _options = ['Pizza 🍕', 'Burgers 🍔', 'Sushi 🍣', 'Tacos 🌮', 'Cook Home 🍳'];
  final TextEditingController _optionController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _animation;
  double _currentAngle = 0;
  String? _selectedOption;

  final List<Color> _sliceColors = [
    Colors.indigo,
    Colors.teal,
    Colors.amber.shade800,
    Colors.purple,
    Colors.deepOrange,
    Colors.blueGrey,
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = CurvedAnimation(parent: _animController, curve: Curves.decelerate);
    _animController.addListener(() {
      setState(() {
        _currentAngle = _animation.value;
      });
    });

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _determineWinner();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _optionController.dispose();
    super.dispose();
  }

  void _spinWheel() {
    if (_animController.isAnimating || _options.isEmpty) return;

    setState(() {
      _selectedOption = null;
    });

    final randomRounds = 4 + math.Random().nextInt(4);
    final randomOffset = math.Random().nextDouble() * math.pi * 2;
    final endAngle = _currentAngle + (randomRounds * math.pi * 2) + randomOffset;

    _animation = Tween<double>(begin: _currentAngle, end: endAngle).animate(
      CurvedAnimation(parent: _animController, curve: Curves.decelerate),
    );

    _animController.forward(from: 0);
  }

  void _determineWinner() {
    if (_options.isEmpty) return;
    final normalizedAngle = (_currentAngle % (math.pi * 2));
    final sliceAngle = (math.pi * 2) / _options.length;
    // Top pointer is at -pi/2 angle
    int index = ((math.pi * 2 - normalizedAngle) / sliceAngle).floor() % _options.length;
    setState(() {
      _selectedOption = _options[index];
    });
  }

  void _addOption() {
    if (_optionController.text.trim().isNotEmpty) {
      setState(() {
        _options.add(_optionController.text.trim());
        _optionController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Micro-Decision Wheel',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Can\'t decide what to eat or do? Spin the wheel!',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 240,
            width: 240,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: _currentAngle,
                  child: CustomPaint(
                    size: const Size(220, 220),
                    painter: WheelPainter(options: _options, colors: _sliceColors),
                  ),
                ),
                // Top Indicator Pointer
                Positioned(
                  top: 0,
                  child: Icon(Icons.arrow_drop_down, size: 40, color: Colors.cyan.shade300),
                ),
                // Center Spin Button
                GestureDetector(
                  onTap: _spinWheel,
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.cyan, width: 2),
                      boxShadow: const [BoxShadow(color: Colors.black87, blurRadius: 8)],
                    ),
                    child: const Center(
                      child: Text(
                        'SPIN',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.cyan),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedOption != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.amber.shade900.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber, width: 1.5),
              ),
              child: Text(
                'Winner: $_selectedOption!',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amberAccent),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _optionController,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: const InputDecoration(
                            hintText: 'Add custom choice...',
                            hintStyle: TextStyle(color: Colors.white70),
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                        onPressed: _addOption,
                        child: const Text('Add', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _options.asMap().entries.map((entry) {
                      return Chip(
                        label: Text(entry.value, style: const TextStyle(color: Colors.white, fontSize: 12)),
                        backgroundColor: const Color(0xFF0F172A),
                        deleteIcon: const Icon(Icons.close, size: 14, color: Colors.white70),
                        onDeleted: _options.length > 2
                            ? () {
                                setState(() {
                                  _options.removeAt(entry.key);
                                });
                              }
                            : null,
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

class WheelPainter extends CustomPainter {
  final List<String> options;
  final List<Color> colors;

  WheelPainter({required this.options, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    if (options.isEmpty) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final sweepAngle = (math.pi * 2) / options.length;

    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < options.length; i++) {
      paint.color = colors[i % colors.length];
      final startAngle = i * sweepAngle - (math.pi / 2);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Draw Text Label
      final textAngle = startAngle + (sweepAngle / 2);
      final textX = center.dx + (radius * 0.65) * math.cos(textAngle);
      final textY = center.dy + (radius * 0.65) * math.sin(textAngle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: options[i],
          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      canvas.save();
      canvas.translate(textX, textY);
      canvas.rotate(textAngle + math.pi / 2);
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ============================================================================
// TAB 4: AMBIENT DESK COMPANION
// ============================================================================
class DeskCompanionTab extends StatefulWidget {
  const DeskCompanionTab({super.key});

  @override
  State<DeskCompanionTab> createState() => _DeskCompanionTabState();
}

class _DeskCompanionTabState extends State<DeskCompanionTab> with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  bool _isSoundRain = false;
  bool _isSoundCafe = false;
  bool _isSoundWaves = false;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    final dateStr = "${_monthName(now.month)} ${now.day}, ${now.year}";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Desk Companion Dock',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Chip(
                avatar: Icon(Icons.bolt, size: 14, color: Colors.greenAccent),
                label: Text('Active Desk Mode', style: TextStyle(fontSize: 11, color: Colors.white)),
                backgroundColor: Color(0xFF1E293B),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Massive Desk Clock Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade900, const Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.indigo.shade400.withOpacity(0.4)),
              boxShadow: const [
                BoxShadow(color: Colors.black87, blurRadius: 10, offset: Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                Text(
                  timeStr,
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  dateStr,
                  style: const TextStyle(fontSize: 15, color: Colors.white70, letterSpacing: 1),
                ),
                const SizedBox(height: 16),
                // Animated Audio Visualizer Bars
                AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(12, (index) {
                        final height = 10.0 + math.sin((_waveController.value * math.pi * 2) + index) * 12 + 10;
                        final active = _isSoundRain || _isSoundCafe || _isSoundWaves;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 4,
                          height: active ? height : 6,
                          decoration: BoxDecoration(
                            color: active ? Colors.cyan : Colors.white70,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Ambient Desk Sound Generator',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildSoundTile(
                  title: 'Rain Ambient',
                  icon: Icons.grain,
                  isActive: _isSoundRain,
                  color: Colors.blue,
                  onTap: () => setState(() => _isSoundRain = !_isSoundRain),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSoundTile(
                  title: 'Cafe Buzz',
                  icon: Icons.coffee,
                  isActive: _isSoundCafe,
                  color: Colors.amber,
                  onTap: () => setState(() => _isSoundCafe = !_isSoundCafe),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSoundTile(
                  title: 'Ocean Waves',
                  icon: Icons.waves,
                  isActive: _isSoundWaves,
                  color: Colors.teal,
                  onTap: () => setState(() => _isSoundWaves = !_isSoundWaves),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.lightbulb_outline, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Daily Focus Quote',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '"Simplicity is about subtracting the obvious and adding the meaningful."',
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoundTile({
    required String title,
    required IconData icon,
    required bool isActive,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.2) : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isActive ? color : Colors.white70, size: 24),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.white : Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}