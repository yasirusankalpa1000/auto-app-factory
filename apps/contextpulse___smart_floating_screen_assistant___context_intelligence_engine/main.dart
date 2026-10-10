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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
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
  int _currentTabIndex = 0;
  bool _isFloatingOverlayEnabled = true;
  bool _isOverlayMinimized = false;

  // Clipboard & Intelligence State
  final TextEditingController _inputController = TextEditingController();
  String _processedOutput = '';
  final List<String> _clipboardHistory = [
    'Check this item price \$49.99 with 15% discount contact support@app.com or call +18005550199 https://example.com/item',
    'Meeting with dev team tomorrow at 10 AM. Budget is \$1250 for phase 1.',
  ];

  // Quick Calculator State
  double _priceInput = 100.0;
  double _discountPercent = 20.0;
  double _taxPercent = 8.0;
  int _splitPeople = 2;

  // Floating Scratchpad Notes
  final List<String> _quickNotes = [
    '📌 Remember to send invoice before 5 PM',
    '💡 Idea: Add quick currency converter widget',
  ];
  final TextEditingController _noteInputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    _noteInputController.dispose();
    super.dispose();
  }

  void _analyzeAndExtractText() {
    final text = _inputController.text;
    if (text.isEmpty) return;

    final StringBuffer sb = StringBuffer();
    sb.writeln('=== CONTEXT ANALYSIS RESULT ===');

    // Email extraction
    final emailRegExp = RegExp(r'[a-zA-Z0-9.\-_]+@[a-zA-Z0-9\-]+\.[a-zA-Z]+');
    final emails = emailRegExp.allMatches(text).map((m) => m.group(0)).toList();
    if (emails.isNotEmpty) {
      sb.writeln('📧 Emails Found: ${emails.join(", ")}');
    }

    // Phone extraction
    final phoneRegExp = RegExp(r'\+?[0-9]{10,14}|\+?[0-9\-\s]{10,16}');
    final phones = phoneRegExp.allMatches(text).map((m) => m.group(0)).toList();
    if (phones.isNotEmpty) {
      sb.writeln('📞 Phone Numbers: ${phones.join(", ")}');
    }

    // Links extraction
    final urlRegExp = RegExp(r'https?://[^\s]+');
    final urls = urlRegExp.allMatches(text).map((m) => m.group(0)).toList();
    if (urls.isNotEmpty) {
      sb.writeln('🔗 Web Links: ${urls.join(", ")}');
    }

    // Currency / Numbers extraction
    final priceRegExp = RegExp(r'\$?\d+(\.\d{1,2})?');
    final prices = priceRegExp.allMatches(text).map((m) => m.group(0)).toList();
    if (prices.isNotEmpty) {
      sb.writeln('💰 Values / Prices Detected: ${prices.join(", ")}');
    }

    // Word Count & Readability
    final words = text.trim().split(RegExp(r'\s+')).length;
    sb.writeln('📊 Metrics: $words words | ${text.length} characters');

    setState(() {
      _processedOutput = sb.toString();
      if (!_clipboardHistory.contains(text)) {
        _clipboardHistory.insert(0, text);
      }
    });
  }

  void _transformText(String mode) {
    final text = _inputController.text;
    if (text.isEmpty) return;

    setState(() {
      if (mode == 'UPPER') {
        _processedOutput = text.toUpperCase();
      } else if (mode == 'LOWER') {
        _processedOutput = text.toLowerCase();
      } else if (mode == 'CLEAN_SPACES') {
        _processedOutput = text.replaceAll(RegExp(r'\s+'), ' ').trim();
      } else if (mode == 'BULLETS') {
        final lines = text.split('\n');
        _processedOutput = lines.map((l) => '• ${l.trim()}').join('\n');
      } else if (mode == 'PROFESSIONAL') {
        _processedOutput = 'Dear Team,\n\n$text\n\nBest regards,';
      }
    });
  }

  void _addQuickNote() {
    if (_noteInputController.text.trim().isNotEmpty) {
      setState(() {
        _quickNotes.insert(0, _noteInputController.text.trim());
        _noteInputController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: IndexedStack(
                    index: _currentTabIndex,
                    children: [
                      _buildClipboardIntelligenceTab(),
                      _buildFloatingToolsTab(),
                      _buildLiveDashboardTab(),
                      _buildSmartCalcTab(),
                    ],
                  ),
                ),
              ],
            ),
            if (_isFloatingOverlayEnabled) _buildSimulatedFloatingWidget(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) => setState(() => _currentTabIndex = index),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1E293B),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: 'Smart Clip',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Floating Bar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Live Desk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Quick Calc',
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(
          bottom: BorderSide(color: Color(0xFF334155), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.bolt, color: Colors.tealAccent, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ContextPulse AI',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _isFloatingOverlayEnabled
                      ? '● Floating Overlay Active'
                      : '○ Overlay Standby',
                  style: TextStyle(
                    fontSize: 11,
                    color: _isFloatingOverlayEnabled
                        ? Colors.greenAccent
                        : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _isFloatingOverlayEnabled
                  ? Icons.notifications_active
                  : Icons.notifications_off,
              color: _isFloatingOverlayEnabled
                  ? Colors.tealAccent
                  : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isFloatingOverlayEnabled = !_isFloatingOverlayEnabled;
              });
            },
            tooltip: 'Toggle Floating Bubble',
          ),
        ],
      ),
    );
  }

  // TAB 1: SMART CLIPBOARD INTELLIGENCE
  Widget _buildClipboardIntelligenceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Smart Context Clipboard', Icons.auto_awesome),
          const SizedBox(height: 10),
          TextField(
            controller: _inputController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText:
                  'Paste any copied snippet, message, email, or text here...',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.tealAccent),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: _analyzeAndExtractText,
                icon: const Icon(Icons.search, size: 16),
                label: const Text('Extract Entities'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
              ),
              OutlinedButton(
                onPressed: () => _transformText('CLEAN_SPACES'),
                child: const Text('Clean Spaces',
                    style: TextStyle(color: Colors.white)),
              ),
              OutlinedButton(
                onPressed: () => _transformText('BULLETS'),
                child: const Text('To Bullets',
                    style: TextStyle(color: Colors.white)),
              ),
              OutlinedButton(
                onPressed: () => _transformText('UPPER'),
                child: const Text('UPPERCASE',
                    style: TextStyle(color: Colors.white)),
              ),
              OutlinedButton(
                onPressed: () => _transformText('PROFESSIONAL'),
                child: const Text('Email Format',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          if (_processedOutput.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF101B2B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.tealAccent.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Extracted Intelligence',
                        style: TextStyle(
                          color: Colors.tealAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.copy, size: 18, color: Colors.grey),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Result copied to clipboard!'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                  const Divider(color: Color(0xFF334155)),
                  Text(
                    _processedOutput,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          _buildSectionHeader('Recent Clipboard Snippets', Icons.history),
          const SizedBox(height: 10),
          ..._clipboardHistory.map((item) => Card(
                color: const Color(0xFF1E293B),
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    item,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward,
                        color: Colors.tealAccent),
                    onPressed: () {
                      _inputController.text = item;
                      _analyzeAndExtractText();
                    },
                  ),
                ),
              )),
        ],
      ),
    );
  }

  // TAB 2: FLOATING MINI TOOLS BAR
  Widget _buildFloatingToolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Quick Floating Tools', Icons.widgets),
          const SizedBox(height: 12),
          Text(
            'Keep ContextPulse active in background to access these floating tools directly over any app on your phone!',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildToolCard(
                'Instant Memo',
                'Floating Sticky Note',
                Icons.edit_note,
                Colors.amber,
                () => _showAddNoteDialog(),
              ),
              _buildToolCard(
                'Text Expander',
                'Auto Fast Replies',
                Icons.flash_on,
                Colors.blueAccent,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Quick snippet copied!')),
                  );
                },
              ),
              _buildToolCard(
                'Currency Conversion',
                'Live \$ USD Rate Calc',
                Icons.monetization_on,
                Colors.green,
                () => setState(() => _currentTabIndex = 3),
              ),
              _buildToolCard(
                'Screen Reader Mode',
                'High Contrast Assist',
                Icons.visibility,
                Colors.purple,
                () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Active Scratchpad', Icons.sticky_note_2),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _noteInputController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Add floating note...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _addQuickNote,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(backgroundColor: Colors.teal),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._quickNotes.map((note) => Card(
                color: const Color(0xFF1E293B),
                child: ListTile(
                  dense: true,
                  title: Text(
                    note,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _quickNotes.remove(note);
                      });
                    },
                  ),
                ),
              )),
        ],
      ),
    );
  }

  // TAB 3: LIVE DESK DASHBOARD
  Widget _buildLiveDashboardTab() {
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'ALWAYS-ON DESK DISPLAY',
                  style: TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  timeStr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Keep this open on desk for real-time assistant mode',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionHeader('Live Currency Ticker', Icons.trending_up),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTickerChip('USD / EUR', '\$1.00 = €0.92', Colors.green),
                const SizedBox(width: 8),
                _buildTickerChip('USD / LKR', '\$1.00 = 302.50 LKR', Colors.teal),
                const SizedBox(width: 8),
                _buildTickerChip('USD / INR', '\$1.00 = ₹83.40', Colors.amber),
                const SizedBox(width: 8),
                _buildTickerChip('GBP / USD', '£1.00 = \$1.27', Colors.blue),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Context Productivity Stats', Icons.bar_chart),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildStatRow('Items Processed Today', '24 texts'),
                const Divider(color: Color(0xFF334155)),
                _buildStatRow('Active Floating Session', '1 hr 42 mins'),
                const Divider(color: Color(0xFF334155)),
                _buildStatRow('Quick Notes Saved', '${_quickNotes.length} notes'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 4: SMART QUICK CALCULATOR
  Widget _buildSmartCalcTab() {
    double discountAmount = _priceInput * (_discountPercent / 100);
    double priceAfterDiscount = _priceInput - discountAmount;
    double taxAmount = priceAfterDiscount * (_taxPercent / 100);
    double totalPrice = priceAfterDiscount + taxAmount;
    double perPersonPrice = _splitPeople > 0 ? totalPrice / _splitPeople : totalPrice;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Smart Deal & Split Calc', Icons.calculate),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Original Price (\$)');
                const SizedBox(height: 6),
                TextField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    prefixText: '\$ ',
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _priceInput = double.tryParse(val) ?? 0.0;
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
                          Text('Discount: ${_discountPercent.toInt()}%'),
                          Slider(
                            value: _discountPercent,
                            min: 0,
                            max: 90,
                            divisions: 18,
                            activeColor: Colors.tealAccent,
                            onChanged: (val) =>
                                setState(() => _discountPercent = val),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tax: ${_taxPercent.toInt()}%'),
                          Slider(
                            value: _taxPercent,
                            min: 0,
                            max: 30,
                            divisions: 30,
                            activeColor: Colors.amber,
                            onChanged: (val) =>
                                setState(() => _taxPercent = val),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Split between people:'),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline,
                              color: Colors.tealAccent),
                          onPressed: () {
                            if (_splitPeople > 1) {
                              setState(() => _splitPeople--);
                            }
                          },
                        ),
                        Text(
                          '$_splitPeople',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline,
                              color: Colors.tealAccent),
                          onPressed: () {
                            setState(() => _splitPeople++);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF065F46), Color(0xFF047857)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Final Total Cost:',
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white70, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Each Person Pays:',
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                    Text(
                      '\$${perPersonPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Saved \$${discountAmount.toStringAsFixed(2)} with discount',
                  style: const TextStyle(color: Colors.tealAccent, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // SIMULATED FLOATING BUBBLE OVERLAY WIDGET
  Widget _buildSimulatedFloatingWidget() {
    return Positioned(
      top: 90,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF1E293B),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.tealAccent, width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isOverlayMinimized = !_isOverlayMinimized;
                  });
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.indigo,
                  child: Icon(
                    _isOverlayMinimized ? Icons.bolt : Icons.close,
                    color: Colors.tealAccent,
                    size: 20,
                  ),
                ),
              ),
              if (!_isOverlayMinimized) ...[
                const SizedBox(height: 8),
                IconButton(
                  icon: const Icon(Icons.content_paste,
                      size: 20, color: Colors.white),
                  onPressed: () {
                    _analyzeAndExtractText();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Quick Context Scan Activated!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  tooltip: 'Instant Scan',
                ),
                IconButton(
                  icon: const Icon(Icons.add_comment,
                      size: 20, color: Colors.amber),
                  onPressed: () => _showAddNoteDialog(),
                  tooltip: 'Quick Memo',
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.tealAccent, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildToolCard(String title, String subtitle, IconData icon,
      Color iconColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTickerChip(String pair, String rate, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(pair,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(width: 6),
          Text(rate,
              style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        Text(value,
            style: const TextStyle(
                color: Colors.tealAccent,
                fontWeight: FontWeight.bold,
                fontSize: 13)),
      ],
    );
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('New Floating Sticky Note',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _noteInputController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Type note here...',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              _addQuickNote();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text('Save Note'),
          ),
        ],
      ),
    );
  }
}