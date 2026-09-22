import 'package:flutter/material.dart';

void main() {
  runApp(const SmartOverlayApp());
}

class SmartOverlayApp extends StatelessWidget {
  const SmartOverlayApp({super.key});

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'SmartOverlay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F111A),
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

  final List<Widget> _pages = const [
    HudDashboardTab(),
    ClipboardParserTab(),
    ImpulseDecisionTab(),
    QuickToolsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        backgroundColor: const Color(0xFF161925),
        indicatorColor: Colors.indigo.withOpacity(0.5),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.layers),
            selectedIcon: Icon(Icons.layers, color: Colors.white),
            label: 'Floating HUD',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_copy),
            selectedIcon: Icon(Icons.content_copy, color: Colors.white),
            label: 'Smart Clip',
          ),
          NavigationDestination(
            icon: Icon(Icons.monetization_on),
            selectedIcon: Icon(Icons.monetization_on, color: Colors.white),
            label: 'Decision Matrix',
          ),
          NavigationDestination(
            icon: Icon(Icons.widgets),
            selectedIcon: Icon(Icons.widgets, color: Colors.white),
            label: 'Quick Tools',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TAB 1: FLOATING HUD DASHBOARD & SIMULATION
// ==========================================
class HudDashboardTab extends StatefulWidget {
  const HudDashboardTab({super.key});

  @override
  State<HudDashboardTab> createState() => _HudDashboardTabState();
}

class _HudDashboardTabState extends State<HudDashboardTab> {
  bool _isFloatingHudEnabled = true;
  bool _showClipboardWatcher = true;
  bool _showPriceCalculator = true;
  bool _showQuickNotes = false;
  String _hudPosition = 'Top Right';
  double _hudOpacity = 0.9;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Smart HUD Control Center',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF161925),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Floating Service status: Active & Monitoring'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // System Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo.shade800, Colors.purple.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Text(
                            'Display Above Apps Active',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Switch(
                          value: _isFloatingHudEnabled,
                          activeColor: Colors.tealAccent,
                          onChanged: (val) {
                            setState(() {
                              _isFloatingHudEnabled = val;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isFloatingHudEnabled
                          ? 'Floating bubble is listening for copied text, micro-decisions, and instant conversions.'
                          : 'Floating HUD is currently paused.',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Simulated Interactive Screen Overlay Preview
              const Text(
                'Live Overlay HUD Preview',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2235),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white70),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.phonelink_setup, size: 40, color: Colors.white70),
                          SizedBox(height: 8),
                          Text(
                            'Simulated Background Screen',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            'Open TikTok, Daraz, WhatsApp or Browser',
                            style: TextStyle(color: Colors.white70, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    if (_isFloatingHudEnabled)
                      Positioned(
                        top: _hudPosition == 'Top Right' || _hudPosition == 'Top Left' ? 20 : null,
                        bottom: _hudPosition == 'Bottom Right' || _hudPosition == 'Bottom Left' ? 20 : null,
                        right: _hudPosition == 'Top Right' || _hudPosition == 'Bottom Right' ? 20 : null,
                        left: _hudPosition == 'Top Left' || _hudPosition == 'Bottom Left' ? 20 : null,
                        child: Opacity(
                          opacity: _hudOpacity,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade900,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.tealAccent, width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.bolt, color: Colors.tealAccent, size: 18),
                                const SizedBox(width: 6),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      'SmartHUD Ready',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Copy text to inspect',
                                      style: TextStyle(color: Colors.white70, fontSize: 9),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Simulated Quick Floating Menu Opened!'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  child: const CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.tealAccent,
                                    child: Icon(Icons.add, size: 14, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // HUD Customization Controls
              const Text(
                'HUD Settings & Micro-Modules',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF161925),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Smart Clipboard Auto-Detect', style: TextStyle(color: Colors.white, fontSize: 14)),
                      subtitle: const Text('Auto-parse prices, tracking IDs & numbers when copied', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      value: _showClipboardWatcher,
                      activeColor: Colors.indigoAccent,
                      onChanged: (val) => setState(() => _showClipboardWatcher = val),
                    ),
                    const Divider(color: Colors.white70),
                    SwitchListTile(
                      title: const Text('Impulse Buying Detector HUD', style: TextStyle(color: Colors.white, fontSize: 14)),
                      subtitle: const Text('Show quick buy/skip score widget over shopping apps', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      value: _showPriceCalculator,
                      activeColor: Colors.indigoAccent,
                      onChanged: (val) => setState(() => _showPriceCalculator = val),
                    ),
                    const Divider(color: Colors.white70),
                    SwitchListTile(
                      title: const Text('Floating Scratchpad Note', style: TextStyle(color: Colors.white, fontSize: 14)),
                      subtitle: const Text('Keep temporary dynamic note pinned to screen', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      value: _showQuickNotes,
                      activeColor: Colors.indigoAccent,
                      onChanged: (val) => setState(() => _showQuickNotes = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              // Position & Opacity Sliders
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF161925),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Bubble Position On Screen', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['Top Right', 'Top Left', 'Bottom Right', 'Bottom Left'].map((pos) {
                        final isSelected = _hudPosition == pos;
                        return ChoiceChip(
                          label: Text(pos),
                          selected: isSelected,
                          selectedColor: Colors.indigoAccent,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _hudPosition = pos);
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('HUD Opacity', style: TextStyle(color: Colors.white, fontSize: 13)),
                        Text('${(_hudOpacity * 100).round()}%', style: const TextStyle(color: Colors.tealAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                      value: _hudOpacity,
                      min: 0.3,
                      max: 1.0,
                      activeColor: Colors.tealAccent,
                      onChanged: (val) => setState(() => _hudOpacity = val),
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

// ==========================================
// TAB 2: SMART CLIPBOARD PARSER & CONTEXT
// ==========================================
class ClipboardParserTab extends StatefulWidget {
  const ClipboardParserTab({super.key});

  @override
  State<ClipboardParserTab> createState() => _ClipboardParserTabState();
}

class _ClipboardParserTabState extends State<ClipboardParserTab> {
  final TextEditingController _textController = TextEditingController(
    text: "Check out this item! Price is \$49.99 with 15% off discount. Contact seller at 0771234567 or email info@store.com for deal details.",
  );

  double _discountPercent = 15.0;
  double _shippingFee = 5.0;

  // Parsed outputs
  List<String> _extractedPhones = [];
  List<String> _extractedEmails = [];
  List<double> _extractedPrices = [];

  @override
  void initState() {
    super.initState();
    _analyzeText();
  }

  void _analyzeText() {
    final text = _textController.text;

    // Phone Regex
    final phoneReg = RegExp(r'(?:\+?\d{1,3}[- ]?)?\(?\d{2,4}\)?[- ]?\d{3,4}[- ]?\d{3,4}');
    final phones = phoneReg.allMatches(text).map((m) => m.group(0)!).where((p) => p.length >= 7).toList();

    // Email Regex
    final emailReg = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    final emails = emailReg.allMatches(text).map((m) => m.group(0)!).toList();

    // Price Regex
    final priceReg = RegExp(r'\$?\d+(?:\.\d{1,2})?');
    final prices = <double>[];
    for (var match in priceReg.allMatches(text)) {
      final str = match.group(0)!.replaceAll('\$', '');
      final val = double.tryParse(str);
      if (val != null && val > 0 && val < 100000) {
        prices.add(val);
      }
    }

    setState(() {
      _extractedPhones = phones;
      _extractedEmails = emails;
      _extractedPrices = prices;
    });
  }

  double _calculateFinalPrice(double basePrice) {
    double discounted = basePrice - (basePrice * (_discountPercent / 100));
    return discounted + _shippingFee;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Clipboard Context Parser', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF161925),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _textController.clear();
              _analyzeText();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF161925),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.indigo.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Copied Text / Message Content',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            _textController.text =
                                "Order confirmed! Total cost \$120.00. Special promo coupon gives 20% discount. Delivery fee is \$8. Call manager at +94779876543 or help@deliver.com";
                            _analyzeText();
                          },
                          icon: const Icon(Icons.content_copy, size: 14),
                          label: const Text('Sample Paste', style: TextStyle(fontSize: 11)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _textController,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      onChanged: (_) => _analyzeText(),
                      decoration: const InputDecoration(
                        hintText: 'Paste any long text, product description, or chat message here...',
                        hintStyle: TextStyle(color: Colors.white70, fontSize: 12),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.tealAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Auto-Extracted Entities Section
              const Text('Extracted Micro-Data', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildDataBadge(
                    icon: Icons.monetization_on,
                    label: 'Detected Prices',
                    count: '${_extractedPrices.length}',
                    color: Colors.amber,
                  ),
                  _buildDataBadge(
                    icon: Icons.search,
                    label: 'Phone Numbers',
                    count: '${_extractedPhones.length}',
                    color: Colors.tealAccent,
                  ),
                  _buildDataBadge(
                    icon: Icons.info,
                    label: 'Emails',
                    count: '${_extractedEmails.length}',
                    color: Colors.lightBlueAccent,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Extracted Contacts / Details
              if (_extractedPhones.isNotEmpty || _extractedEmails.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2235),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Quick Actions & Contacts', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 8),
                      ..._extractedPhones.map((p) => ListTile(
                            dense: true,
                            leading: const Icon(Icons.check, color: Colors.tealAccent, size: 18),
                            title: Text(p, style: const TextStyle(color: Colors.white, fontSize: 13)),
                            trailing: IconButton(
                              icon: const Icon(Icons.content_copy, color: Colors.white70, size: 16),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied: $p')));
                              },
                            ),
                          )),
                      ..._extractedEmails.map((e) => ListTile(
                            dense: true,
                            leading: const Icon(Icons.check, color: Colors.lightBlueAccent, size: 18),
                            title: Text(e, style: const TextStyle(color: Colors.white, fontSize: 13)),
                            trailing: IconButton(
                              icon: const Icon(Icons.content_copy, color: Colors.white70, size: 16),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied: $e')));
                              },
                            ),
                          )),
                    ],
                  ),
                ),

              // Instant Price True-Cost Calculator
              if (_extractedPrices.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161925),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.calculate, color: Colors.tealAccent),
                          SizedBox(width: 8),
                          Text('True-Cost Instant Calculator', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Base Price Detected:', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          Text(
                            '\$${_extractedPrices.first.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Apply Discount (${_discountPercent.round()}%):', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          Expanded(
                            child: Slider(
                              value: _discountPercent,
                              min: 0,
                              max: 75,
                              divisions: 15,
                              activeColor: Colors.tealAccent,
                              onChanged: (val) => setState(() => _discountPercent = val),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Estimated Delivery/Tax: \$${_shippingFee.round()}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          Expanded(
                            child: Slider(
                              value: _shippingFee,
                              min: 0,
                              max: 30,
                              divisions: 30,
                              activeColor: Colors.indigoAccent,
                              onChanged: (val) => setState(() => _shippingFee = val),
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white70),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Actual Final Payable:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(
                            '\$${_calculateFinalPrice(_extractedPrices.first).toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
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

  Widget _buildDataBadge({
    required IconData icon,
    required String label,
    required String count,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF161925),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
              Text(count, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TAB 3: IMPULSE BUYING & MICRO-DECISION EVALUATOR
// ==========================================
class ImpulseDecisionTab extends StatefulWidget {
  const ImpulseDecisionTab({super.key});

  @override
  State<ImpulseDecisionTab> createState() => _ImpulseDecisionTabState();
}

class _ImpulseDecisionTabState extends State<ImpulseDecisionTab> {
  String _itemTitle = "New Wireless Earbuds";
  double _price = 85.0;
  double _necessityRating = 3.0; // 1 to 5
  double _usageFrequency = 2.0; // 1 to 5 (1 = rarely, 5 = daily)
  double _impulseUrgency = 4.0; // 1 to 5 (high = emotional buy)
  bool _canAffordWithoutDebt = true;

  double _calculateDecisionScore() {
    // Score out of 100
    double score = 50.0;
    score += (_necessityRating * 10);
    score += (_usageFrequency * 8);
    score -= (_impulseUrgency * 10);
    if (!_canAffordWithoutDebt) score -= 25;
    if (_price > 150) score -= 10;
    return score.clamp(5, 98);
  }

  Color _getScoreColor(double score) {
    if (score >= 70) return Colors.greenAccent;
    if (score >= 45) return Colors.amberAccent;
    return Colors.redAccent;
  }

  String _getVerdictText(double score) {
    if (score >= 70) return "GREAT BUY: High utility & justifiable value!";
    if (score >= 45) return "WAIT 24 HOURS: Mild impulse detected. Sleep on it!";
    return "SKIP IT: High impulse risk or poor value-to-cost ratio.";
  }

  @override
  Widget build(BuildContext context) {
    final score = _calculateDecisionScore();
    final scoreColor = _getScoreColor(score);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Impulse Buying Decision Engine', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF161925),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Result Score Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF161925),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: scoreColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: scoreColor.withOpacity(0.15),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text('DECISION CONFIDENCE SCORE', style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1.2)),
                    const SizedBox(height: 6),
                    Text(
                      '${score.round()} / 100',
                      style: TextStyle(color: scoreColor, fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getVerdictText(score),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: scoreColor, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text('Item & Financial Check', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 10),

              // Item details
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF161925),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    TextField(
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: const InputDecoration(
                        labelText: 'Item Name / Decision Title',
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) => setState(() => _itemTitle = val),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text('Price Tag: \$${_price.round()}', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 2,
                          child: Slider(
                            value: _price,
                            min: 5,
                            max: 500,
                            divisions: 99,
                            activeColor: Colors.amberAccent,
                            onChanged: (val) => setState(() => _price = val),
                          ),
                        ),
                      ],
                    ),
                    SwitchListTile(
                      title: const Text('Can afford without using high-interest credit card?', style: TextStyle(color: Colors.white, fontSize: 12)),
                      value: _canAffordWithoutDebt,
                      activeColor: Colors.tealAccent,
                      onChanged: (val) => setState(() => _canAffordWithoutDebt = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const Text('Emotional & Practical Matrix', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF161925),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _buildMatrixSlider(
                      title: 'How real is the need?',
                      value: _necessityRating,
                      label: _necessityRating <= 2 ? 'Want, Not Need' : (_necessityRating >= 4 ? 'Essential' : 'Moderate'),
                      onChanged: (v) => setState(() => _necessityRating = v),
                    ),
                    const Divider(color: Colors.white70),
                    _buildMatrixSlider(
                      title: 'Expected daily usage?',
                      value: _usageFrequency,
                      label: _usageFrequency <= 2 ? 'Rarely / Once a week' : (_usageFrequency >= 4 ? 'Every day' : 'Sometimes'),
                      onChanged: (v) => setState(() => _usageFrequency = v),
                    ),
                    const Divider(color: Colors.white70),
                    _buildMatrixSlider(
                      title: 'Urgency feeling right now?',
                      value: _impulseUrgency,
                      label: _impulseUrgency >= 4 ? 'Must buy NOW!' : 'Can wait comfortably',
                      onChanged: (v) => setState(() => _impulseUrgency = v),
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

  Widget _buildMatrixSlider({
    required String title,
    required double value,
    required String label,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 13), overflow: TextOverflow.ellipsis)),
            Text(label, style: const TextStyle(color: Colors.tealAccent, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value,
          min: 1,
          max: 5,
          divisions: 4,
          activeColor: Colors.indigoAccent,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// ==========================================
// TAB 4: QUICK MULTI-TOOL OVERLAY HUB
// ==========================================
class QuickToolsTab extends StatefulWidget {
  const QuickToolsTab({super.key});

  @override
  State<QuickToolsTab> createState() => _QuickToolsTabState();
}

class _QuickToolsTabState extends State<QuickToolsTab> {
  // Split bill tool state
  double _totalBill = 84.0;
  int _peopleCount = 3;
  double _tipPercentage = 10.0;

  // Floating scratchpad
  final TextEditingController _scratchpadController = TextEditingController(
    text: "Quick note pinned: Call landlord at 5 PM. Buy milk & batteries.",
  );

  @override
  Widget build(BuildContext context) {
    double totalWithTip = _totalBill + (_totalBill * (_tipPercentage / 100));
    double perPerson = totalWithTip / _peopleCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Floating Multi-Tools', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF161925),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instant Split Bill & Tip Overlay Tool
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF161925),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.indigo.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.monetization_on, color: Colors.tealAccent),
                        SizedBox(width: 8),
                        Text('Instant Bill Splitter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Bill Amount:', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        Text('\$${_totalBill.round()}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    Slider(
                      value: _totalBill,
                      min: 10,
                      max: 500,
                      divisions: 98,
                      activeColor: Colors.amber,
                      onChanged: (val) => setState(() => _totalBill = val),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Split Between: $_peopleCount People', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.tealAccent),
                              onPressed: () {
                                if (_peopleCount > 1) setState(() => _peopleCount--);
                              },
                            ),
                            Text('$_peopleCount', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: Colors.tealAccent),
                              onPressed: () => setState(() => _peopleCount++),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tip: ${_tipPercentage.round()}%', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        Expanded(
                          child: Slider(
                            value: _tipPercentage,
                            min: 0,
                            max: 30,
                            divisions: 6,
                            activeColor: Colors.indigoAccent,
                            onChanged: (val) => setState(() => _tipPercentage = val),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white70),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade900.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Each Person Pays:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(
                            '\$${perPerson.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Floating Scratchpad Memory Tool
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF161925),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.edit, color: Colors.amberAccent),
                            SizedBox(width: 8),
                            Text('Floating HUD Scratchpad', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.white70, size: 18),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Scratchpad copied to clipboard!')),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _scratchpadController,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Type temporary notes here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Active Floating HUD Quick Status
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade900, Colors.indigo.shade900],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt, color: Colors.tealAccent, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('SmartOverlay Floating Active', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          SizedBox(height: 2),
                          Text('Ready to assist across all apps & shopping sites.', style: TextStyle(color: Colors.white70, fontSize: 11)),
                        ],
                      ),
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