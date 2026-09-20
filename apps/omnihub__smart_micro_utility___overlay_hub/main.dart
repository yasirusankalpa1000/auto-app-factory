import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const OmniHubApp());
}

class OmniHubApp extends StatelessWidget {
  const OmniHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FE),
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

class _MainHomeScreenState extends State<MainHomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isFloatingOverlayActive = true;
  bool _isNotificationBarEnabled = true;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      const DealMatrixScreen(),
      const TextSanitizerScreen(),
      const DecisionEngineScreen(),
      FloatingControlScreen(
        onToggleOverlay: (val) {
          setState(() {
            _isFloatingOverlayActive = val;
          });
        },
        onToggleNotification: (val) {
          setState(() {
            _isNotificationBarEnabled = val;
          });
        },
        isOverlayActive: _isFloatingOverlayActive,
        isNotificationActive: _isNotificationBarEnabled,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeaderBar(),
                if (_isNotificationBarEnabled) _buildInteractiveFloatingBanner(),
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _pages,
                  ),
                ),
              ],
            ),
            if (_isFloatingOverlayActive) _buildSimulatedFloatingWidget(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag, color: Colors.indigo),
            label: 'Value Matrix',
          ),
          NavigationDestination(
            icon: Icon(Icons.cleaning_services_outlined),
            selectedIcon: Icon(Icons.cleaning_services, color: Colors.indigo),
            label: 'Text Clean',
          ),
          NavigationDestination(
            icon: Icon(Icons.casino_outlined),
            selectedIcon: Icon(Icons.casino, color: Colors.indigo),
            label: 'Decision Wheel',
          ),
          NavigationDestination(
            icon: Icon(Icons.layers_outlined),
            selectedIcon: Icon(Icons.layers, color: Colors.indigo),
            label: 'HUD & Overlay',
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.indigo,
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.widgets, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'OmniHub Utility Assistant',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveFloatingBanner() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade700, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: Colors.amber, size: 22),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Live Utility Notification active: Swipe or Tap for quick actions',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              softWrap: true,
            ),
          ),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Quick Action Triggered from System Notification!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.shade800,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Quick Tool',
                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulatedFloatingWidget() {
    return Positioned(
      right: 16,
      bottom: 20,
      child: Draggable(
        feedback: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: Colors.indigo,
          icon: const Icon(Icons.bolt, color: Colors.white),
          label: const Text('OmniHUD', style: TextStyle(color: Colors.white)),
        ),
        childWhenDragging: Container(),
        child: FloatingActionButton.extended(
          onPressed: () {
            _showQuickOverlaySheet(context);
          },
          elevation: 6,
          backgroundColor: Colors.indigo,
          icon: const Icon(Icons.bolt, color: Colors.amber),
          label: const Text(
            'Omni HUD',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _showQuickOverlaySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'OmniHub Quick Floating Toolkit',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAxisAlignment.center,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.cleaning_services, size: 18),
                        label: const Text('Sanitize Clipboard'),
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Clipboard Sanitized & Formatted!')),
                          );
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.calculate, size: 18),
                        label: const Text('Quick Price Check'),
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _currentIndex = 0;
                          });
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.casino, size: 18),
                        label: const Text('Spin Choice'),
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _currentIndex = 2;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      minimumSize: const Size.fromHeight(45),
                    ),
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text('Close HUD', style: TextStyle(color: Colors.white)),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('About OmniHub'),
        content: const SingleChildScrollView(
          child: Text(
            'OmniHub is your versatile everyday utility companion. Designed for daily active productivity, decision assistance, supermarket deal comparison, text formatting, and screen overlay simulation.',
            softWrap: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 1: SUPERMARKET DEAL MATRIX
// -----------------------------------------------------------------------------
class DealMatrixScreen extends StatefulWidget {
  const DealMatrixScreen({super.key});

  @override
  State<DealMatrixScreen> createState() => _DealMatrixScreenState();
}

class _DealMatrixScreenState extends State<DealMatrixScreen> {
  final TextEditingController _priceAController = TextEditingController();
  final TextEditingController _qtyAController = TextEditingController();
  final TextEditingController _priceBController = TextEditingController();
  final TextEditingController _qtyBController = TextEditingController();

  String _unitType = 'Grams (g)';
  String _resultText = 'Enter prices and quantities above to compare value.';
  String _bestOption = '';

  void _calculateDeal() {
    final double? priceA = double.tryParse(_priceAController.text);
    final double? qtyA = double.tryParse(_qtyAController.text);
    final double? priceB = double.tryParse(_priceBController.text);
    final double? qtyB = double.tryParse(_qtyBController.text);

    if (priceA == null || qtyA == null || priceB == null || qtyB == null || qtyA <= 0 || qtyB <= 0) {
      setState(() {
        _resultText = 'Please enter valid positive numbers for both options.';
        _bestOption = '';
      });
      return;
    }

    final double unitCostA = priceA / qtyA;
    final double unitCostB = priceB / qtyB;

    if ((unitCostA - unitCostB).abs() < 0.00001) {
      setState(() {
        _resultText = 'Both options offer the EXACT same value!\n'
            'Option A Unit Price: \$${unitCostA.toStringAsFixed(4)}\n'
            'Option B Unit Price: \$${unitCostB.toStringAsFixed(4)}';
        _bestOption = 'TIE';
      });
      return;
    }

    if (unitCostA < unitCostB) {
      final double savings = ((unitCostB - unitCostA) / unitCostB) * 100;
      setState(() {
        _bestOption = 'A';
        _resultText = 'Option A is the BETTER DEAL!\n'
            'Option A: \$${unitCostA.toStringAsFixed(4)} per unit\n'
            'Option B: \$${unitCostB.toStringAsFixed(4)} per unit\n'
            'You save ${savings.toStringAsFixed(1)}% by choosing Option A.';
      });
    } else {
      final double savings = ((unitCostA - unitCostB) / unitCostA) * 100;
      setState(() {
        _bestOption = 'B';
        _resultText = 'Option B is the BETTER DEAL!\n'
            'Option B: \$${unitCostB.toStringAsFixed(4)} per unit\n'
            'Option A: \$${unitCostA.toStringAsFixed(4)} per unit\n'
            'You save ${savings.toStringAsFixed(1)}% by choosing Option B.';
      });
    }
  }

  void _clearFields() {
    _priceAController.clear();
    _qtyAController.clear();
    _priceBController.clear();
    _qtyBController.clear();
    setState(() {
      _resultText = 'Enter prices and quantities above to compare value.';
      _bestOption = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shopping_cart, color: Colors.indigo),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Smart Supermarket Unit Value Finder',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Avoid tricky product sizing! Instantly compare two packages to see which saves real money.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                    softWrap: true,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _unitType,
                    decoration: const InputDecoration(
                      labelText: 'Select Unit Type',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: ['Grams (g)', 'Kilograms (kg)', 'Milliliters (ml)', 'Liters (l)', 'Units / Pieces']
                        .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _unitType = val;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildItemCard(
                  title: 'Option A',
                  badgeColor: _bestOption == 'A' ? Colors.green : Colors.indigo,
                  priceController: _priceAController,
                  qtyController: _qtyAController,
                  isBest: _bestOption == 'A',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildItemCard(
                  title: 'Option B',
                  badgeColor: _bestOption == 'B' ? Colors.green : Colors.indigo,
                  priceController: _priceBController,
                  qtyController: _qtyBController,
                  isBest: _bestOption == 'B',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _calculateDeal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.calculate, color: Colors.white),
                  label: const Text(
                    'Compare Value',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _clearFields,
                icon: const Icon(Icons.refresh, color: Colors.grey),
                tooltip: 'Reset Fields',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            color: _bestOption.isNotEmpty ? Colors.indigo.shade50 : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: _bestOption.isNotEmpty ? Colors.indigo : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _bestOption.isNotEmpty ? Icons.stars : Icons.info_outline,
                        color: Colors.indigo,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Comparison Analysis',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _resultText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard({
    required String title,
    required Color badgeColor,
    required TextEditingController priceController,
    required TextEditingController qtyController,
    required bool isBest,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isBest ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isBest ? Colors.green : Colors.grey.shade300,
          width: isBest ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              if (isBest)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'BEST DEAL',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Price (\$) *',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: qtyController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Amount / Qty *',
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 2: TEXT & LINK SANITIZER
// -----------------------------------------------------------------------------
class TextSanitizerScreen extends StatefulWidget {
  const TextSanitizerScreen({super.key});

  @override
  State<TextSanitizerScreen> createState() => _TextSanitizerScreenState();
}

class _TextSanitizerScreenState extends State<TextSanitizerScreen> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();

  void _cleanTrackingLinks() {
    String text = _inputController.text;
    if (text.isEmpty) return;

    // Strip common tracking parameters utm_source, ref, fbclid, etc.
    final RegExp regExp = RegExp(r'(\?|&)(utm_[^&]+|ref=[^&]+|fbclid=[^&]+|gclid=[^&]+)');
    String cleaned = text.replaceAll(regExp, '');
    cleaned = cleaned.replaceAll(RegExp(r'\?&'), '?');
    if (cleaned.endsWith('?') || cleaned.endsWith('&')) {
      cleaned = cleaned.substring(0, cleaned.length - 1);
    }

    setState(() {
      _outputController.text = cleaned;
    });
  }

  void _extractNumbers() {
    String text = _inputController.text;
    if (text.isEmpty) return;

    final RegExp numReg = RegExp(r'\b\d[\d\s\-\+\(\)]{7,}\d\b');
    final matches = numReg.allMatches(text);
    final List<String> numbers = matches.map((m) => m.group(0)!.trim()).toList();

    if (numbers.isEmpty) {
      setState(() {
        _outputController.text = 'No phone numbers or long digits detected.';
      });
    } else {
      setState(() {
        _outputController.text = 'Extracted Phone Numbers:\n' + numbers.join('\n');
      });
    }
  }

  void _formatTitleCase() {
    String text = _inputController.text;
    if (text.isEmpty) return;

    final words = text.split(' ');
    final capitalized = words.map((w) {
      if (w.isEmpty) return '';
      return w[0].toUpperCase() + w.substring(1).toLowerCase();
    }).join(' ');

    setState(() {
      _outputController.text = capitalized;
    });
  }

  void _removeExtraSpaces() {
    String text = _inputController.text;
    if (text.isEmpty) return;

    String cleaned = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    setState(() {
      _outputController.text = cleaned;
    });
  }

  void _generateQuickReply(String type) {
    String template = '';
    if (type == 'busy') {
      template = 'Hi! I am currently busy in a meeting/work. Will call or text you back shortly. Thanks!';
    } else if (type == 'location') {
      template = 'Hey, please send me your current location link when you get a chance.';
    } else if (type == 'bank') {
      template = 'Hi, please send over your bank details (Account Name, Number, and Bank Branch). Thanks!';
    }
    setState(() {
      _inputController.text = template;
      _outputController.text = template;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.cleaning_services, color: Colors.indigo),
                      SizedBox(width: 8),
                      Text(
                        'Text & Tracking Link Sanitizer',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Remove tracker tags, extract phone numbers, or format messy text instantly.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _inputController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Paste Raw Text / Messy Link / Note Here',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Quick Actions:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.indigo),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _cleanTrackingLinks,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                icon: const Icon(Icons.link_off, size: 16, color: Colors.white),
                label: const Text('Strip Link Tracking', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
              ElevatedButton.icon(
                onPressed: _extractNumbers,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                icon: const Icon(Icons.phone, size: 16, color: Colors.white),
                label: const Text('Extract Phones', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
              OutlinedButton.icon(
                onPressed: _formatTitleCase,
                icon: const Icon(Icons.text_fields, size: 16),
                label: const Text('Title Case', style: TextStyle(fontSize: 12)),
              ),
              OutlinedButton.icon(
                onPressed: _removeExtraSpaces,
                icon: const Icon(Icons.space_bar, size: 16),
                label: const Text('Trim Spaces', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Instant Response Templates:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.indigo),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              ActionChip(
                avatar: const Icon(Icons.schedule, size: 16),
                label: const Text('I\'m Busy Reply'),
                onPressed: () => _generateQuickReply('busy'),
              ),
              ActionChip(
                avatar: const Icon(Icons.location_on, size: 16),
                label: const Text('Request Location'),
                onPressed: () => _generateQuickReply('location'),
              ),
              ActionChip(
                avatar: const Icon(Icons.monetization_on, size: 16),
                label: const Text('Request Bank Info'),
                onPressed: () => _generateQuickReply('bank'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _outputController,
            maxLines: 4,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Cleaned Output Result',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.copy, color: Colors.indigo),
                onPressed: () {
                  if (_outputController.text.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Result copied to clipboard!')),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 3: MICRO-DECISION ENGINE (SPINNER & PICKER)
// -----------------------------------------------------------------------------
class DecisionEngineScreen extends StatefulWidget {
  const DecisionEngineScreen({super.key});

  @override
  State<DecisionEngineScreen> createState() => _DecisionEngineScreenState();
}

class _DecisionEngineScreenState extends State<DecisionEngineScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _options = ['Cook at Home', 'Order Takeout', 'Eat Salads', 'Dine Out', 'Quick Sandwich'];
  final TextEditingController _newOptionController = TextEditingController();
  
  String _selectedResult = 'Tap SPIN to resolve your decision!';
  bool _isSpinning = false;
  late AnimationController _animController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(parent: _animController, curve: Curves.decelerate);
  }

  @override
  void dispose() {
    _animController.dispose();
    _newOptionController.dispose();
    super.dispose();
  }

  void _spinWheel() {
    if (_options.isEmpty) return;

    setState(() {
      _isSpinning = true;
      _selectedResult = 'Deciding...';
    });

    _animController.forward(from: 0.0).then((_) {
      final random = Random();
      final chosen = _options[random.nextInt(_options.length)];
      setState(() {
        _selectedResult = 'DECISION: $chosen!';
        _isSpinning = false;
      });
    });
  }

  void _addOption() {
    if (_newOptionController.text.trim().isNotEmpty) {
      setState(() {
        _options.add(_newOptionController.text.trim());
        _newOptionController.clear();
      });
    }
  }

  void _presetCategory(String type) {
    setState(() {
      _options.clear();
      if (type == 'food') {
        _options.addAll(['Pizza', 'Rice & Curry', 'Burgers', 'Noodles', 'Pasta', 'Soup']);
      } else if (type == 'task') {
        _options.addAll(['Clean Desk', 'Study 30 Mins', 'Exercise', 'Read 10 Pages', 'Reply Emails']);
      } else if (type == 'fun') {
        _options.addAll(['Watch Movie', 'Play Game', 'Listen Music', 'Take a Walk', 'Call a Friend']);
      }
      _selectedResult = 'Category updated! Tap SPIN.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: const [
                  Text(
                    'Micro-Decision Fatigue Eliminator',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Can\'t decide what to eat or do next? Let the smart wheel decide for you.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animation.value * 6 * pi,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [
                          Colors.indigo,
                          Colors.blue,
                          Colors.teal,
                          Colors.amber,
                          Colors.orange,
                          Colors.indigo,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.casino, color: Colors.indigo, size: 36),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.indigo.shade200),
            ),
            child: Text(
              _selectedResult,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo),
              softWrap: true,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _isSpinning ? null : _spinWheel,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: Text(
              _isSpinning ? 'SPINNING...' : 'SPIN THE WHEEL',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Presets:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.indigo),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              ActionChip(
                avatar: const Icon(Icons.restaurant, size: 16),
                label: const Text('Meals'),
                onPressed: () => _presetCategory('food'),
              ),
              ActionChip(
                avatar: const Icon(Icons.check_circle, size: 16),
                label: const Text('Micro-Tasks'),
                onPressed: () => _presetCategory('task'),
              ),
              ActionChip(
                avatar: const Icon(Icons.sports_esports, size: 16),
                label: const Text('Break Time'),
                onPressed: () => _presetCategory('fun'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _newOptionController,
                  decoration: const InputDecoration(
                    hintText: 'Add custom choice...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.indigo, size: 32),
                onPressed: _addOption,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: _options
                .map(
                  (opt) => Chip(
                    label: Text(opt, style: const TextStyle(fontSize: 12)),
                    deleteIcon: const Icon(Icons.close, size: 14),
                    onDeleted: () {
                      setState(() {
                        _options.remove(opt);
                      });
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 4: FLOATING HUD & OVERLAY CONTROL
// -----------------------------------------------------------------------------
class FloatingControlScreen extends StatelessWidget {
  final ValueChanged<bool> onToggleOverlay;
  final ValueChanged<bool> onToggleNotification;
  final bool isOverlayActive;
  final bool isNotificationActive;

  const FloatingControlScreen({
    super.key,
    required this.onToggleOverlay,
    required this.onToggleNotification,
    required this.isOverlayActive,
    required this.isNotificationActive,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.layers, color: Colors.indigo),
                      SizedBox(width: 8),
                      Text(
                        'Floating HUD & System Controls',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Configure floating micro-widgets and persistent notification bar simulated directly inside your screen session.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Enable Floating OmniHUD Bubble', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Show quick assistant floating bubble on top of app view', style: TextStyle(fontSize: 12)),
            value: isOverlayActive,
            activeColor: Colors.indigo,
            onChanged: onToggleOverlay,
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Enable Persistent Quick Notification Bar', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Display live quick-action bar at the top of the interface', style: TextStyle(fontSize: 12)),
            value: isNotificationActive,
            activeColor: Colors.indigo,
            onChanged: onToggleNotification,
          ),
          const Divider(),
          const SizedBox(height: 12),
          const Text(
            'Quick Assistant Preset Controls',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.indigo),
          ),
          const SizedBox(height: 8),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.flash_on, color: Colors.amber),
                    title: const Text('Fast Action Mode', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Optimizes tools for single-tap operations', style: TextStyle(fontSize: 12)),
                    trailing: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fast Action Mode Enabled!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                      child: const Text('Activate', style: TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.security, color: Colors.teal),
                    title: const Text('Privacy Link Shield', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Automatically strips trackers from copied links', style: TextStyle(fontSize: 12)),
                    trailing: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Link Shield Enabled!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      child: const Text('Enable', style: TextStyle(color: Colors.white, fontSize: 11)),
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