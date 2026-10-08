import 'package:flutter/material.dart';

void main() {
  runApp(const SnapHudApp());
}

class SnapHudApp extends StatelessWidget {
  const SnapHudApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapHUD',
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
      themeMode: ThemeMode.system,
      home: const SnapHudHomeScreen(),
    );
  }
}

class SnapHudHomeScreen extends StatefulWidget {
  const SnapHudHomeScreen({Key? key}) : super(key: key);

  @override
  State<SnapHudHomeScreen> createState() => _SnapHudHomeScreenState();
}

class _SnapHudHomeScreenState extends State<SnapHudHomeScreen> {
  int _currentIndex = 0;
  
  // Floating HUD state
  bool _isOverlayEnabled = true;
  bool _isNotificationTrayActive = true;
  Offset _bubblePosition = const Offset(20, 200);
  bool _isBubbleExpanded = false;
  
  // Text Purifier state
  final TextEditingController _rawTextController = TextEditingController();
  String _purifiedText = '';
  String _extractedNumbers = '';
  
  // Shopper Micro-Calc state
  final TextEditingController _priceController = TextEditingController(text: '49.99');
  final TextEditingController _discountController = TextEditingController(text: '20');
  final TextEditingController _taxController = TextEditingController(text: '8');
  final TextEditingController _peopleController = TextEditingController(text: '2');
  double _finalPrice = 0.0;
  double _savedAmount = 0.0;
  double _perPersonShare = 0.0;

  // Sticky Notes State
  final List<Map<String, String>> _notes = [
    {
      'title': 'Wi-Fi Code for Café',
      'body': 'Pass: Express8842',
      'tag': 'Important',
      'time': 'Just now'
    },
    {
      'title': 'Promo Code',
      'body': 'SAVE20OFF - valid till midnight',
      'tag': 'Shopping',
      'time': '10 mins ago'
    },
  ];
  final TextEditingController _newNoteTitle = TextEditingController();
  final TextEditingController _newNoteBody = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rawTextController.text = 'https://shop.example.com/product/102?utm_source=facebook&utm_medium=cpc&fbclid=IwAR2938491023&ref=share +1-800-555-0199';
    _purifyText();
    _calculateDiscount();
  }

  void _purifyText() {
    String input = _rawTextController.text;
    
    // Clean tracking parameters from URLs
    String cleaned = input.replaceAll(RegExp(r'(\?|&)(utm_[^&=]+|fbclid|gclid|ref|gbraid|wbraid)=[^&]*'), '');
    if (cleaned.endsWith('?') || cleaned.endsWith('&')) {
      cleaned = cleaned.substring(0, cleaned.length - 1);
    }
    
    // Extract potential phone numbers
    final phoneRegex = RegExp(r'\+?\d[\d\-\s\(\)]{8,}\d');
    Iterable<Match> matches = phoneRegex.allMatches(input);
    List<String> foundNumbers = matches.map((m) => m.group(0) ?? '').toList();

    setState(() {
      _purifiedText = cleaned.trim();
      _extractedNumbers = foundNumbers.isNotEmpty ? foundNumbers.join(', ') : 'No phone numbers detected';
    });
  }

  void _calculateDiscount() {
    double price = double.tryParse(_priceController.text) ?? 0.0;
    double discountPercent = double.tryParse(_discountController.text) ?? 0.0;
    double taxPercent = double.tryParse(_taxController.text) ?? 0.0;
    int people = int.tryParse(_peopleController.text) ?? 1;
    if (people < 1) people = 1;

    double discountAmount = price * (discountPercent / 100.0);
    double discountedPrice = price - discountAmount;
    double taxAmount = discountedPrice * (taxPercent / 100.0);
    double total = discountedPrice + taxAmount;

    setState(() {
      _savedAmount = discountAmount;
      _finalPrice = total;
      _perPersonShare = total / people;
    });
  }

  void _addStickyNote() {
    if (_newNoteTitle.text.trim().isEmpty) return;
    setState(() {
      _notes.insert(0, {
        'title': _newNoteTitle.text.trim(),
        'body': _newNoteBody.text.trim(),
        'tag': 'Quick Clip',
        'time': 'Just now'
      });
      _newNoteTitle.clear();
      _newNoteBody.clear();
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.layers, color: theme.colorScheme.primary, size: 22),
            ),
            const SizedBox(width: 10),
            const Text('SnapHUD Assistant', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isOverlayEnabled ? Icons.visibility : Icons.visibility_off,
              color: _isOverlayEnabled ? Colors.green : Colors.grey,
            ),
            tooltip: 'Toggle Overlay Mode',
            onPressed: () {
              setState(() {
                _isOverlayEnabled = !_isOverlayEnabled;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isOverlayEnabled 
                    ? 'Floating Assist Overlay Activated!' 
                    : 'Floating Assist Overlay Paused.'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Navigation Screens
            IndexedStack(
              index: _currentIndex,
              children: [
                _buildHudControlTab(theme),
                _buildTextPurifierTab(theme),
                _buildShopperCalcTab(theme),
                _buildStickyNotesTab(theme),
              ],
            ),

            // Interactive Simulated Floating Bubble Assistant Overlay
            if (_isOverlayEnabled)
              Positioned(
                left: _bubblePosition.dx,
                top: _bubblePosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _bubblePosition += details.delta;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    width: _isBubbleExpanded ? 260 : 58,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(_isBubbleExpanded ? 18 : 30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    child: _isBubbleExpanded
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.touch_app, color: Colors.white, size: 18),
                                      SizedBox(width: 6),
                                      Text(
                                        'SnapHUD Dock',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () => setState(() => _isBubbleExpanded = false),
                                    child: const Icon(Icons.close, color: Colors.white, size: 18),
                                  ),
                                ],
                              ),
                              const Divider(color: Colors.white70, height: 12),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: [
                                  ActionChip(
                                    avatar: const Icon(Icons.cleaning_services, size: 14),
                                    label: const Text('Purify Clip', style: TextStyle(fontSize: 11)),
                                    onPressed: () {
                                      setState(() {
                                        _currentIndex = 1;
                                        _isBubbleExpanded = false;
                                      });
                                    },
                                  ),
                                  ActionChip(
                                    avatar: const Icon(Icons.discount, size: 14),
                                    label: const Text('Shopper Calc', style: TextStyle(fontSize: 11)),
                                    onPressed: () {
                                      setState(() {
                                        _currentIndex = 2;
                                        _isBubbleExpanded = false;
                                      });
                                    },
                                  ),
                                  ActionChip(
                                    avatar: const Icon(Icons.note_add, size: 14),
                                    label: const Text('Quick Note', style: TextStyle(fontSize: 11)),
                                    onPressed: () {
                                      setState(() {
                                        _currentIndex = 3;
                                        _isBubbleExpanded = false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          )
                        : InkWell(
                            onTap: () => setState(() => _isBubbleExpanded = true),
                            child: const Center(
                              child: Icon(
                                Icons.bubble_chart,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() => _currentIndex = idx);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'HUD Control',
          ),
          NavigationDestination(
            icon: Icon(Icons.cleaning_services_outlined),
            selectedIcon: Icon(Icons.cleaning_services),
            label: 'Text Purifier',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Shopper Calc',
          ),
          NavigationDestination(
            icon: Icon(Icons.sticky_note_2_outlined),
            selectedIcon: Icon(Icons.sticky_note_2),
            label: 'Scratchpad',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: HUD CONTROL CENTER ---
  Widget _buildHudControlTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.flash_on, color: Colors.amber, size: 28),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _isOverlayEnabled ? 'Overlay Active Above Apps' : 'Overlay Hibernating',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'SnapHUD stays floating on top of your browser, social apps, and video player for zero-friction daily utility.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  softWrap: true,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: theme.colorScheme.primary,
                      ),
                      icon: Icon(_isOverlayEnabled ? Icons.pause : Icons.play_arrow, size: 18),
                      label: Text(_isOverlayEnabled ? 'Pause Assist' : 'Activate Assist'),
                      onPressed: () {
                        setState(() {
                          _isOverlayEnabled = !_isOverlayEnabled;
                        });
                      },
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white70),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Reset Bubble Position'),
                      onPressed: () {
                        setState(() {
                          _bubblePosition = const Offset(20, 200);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Toggles & Permissions HUD
          const Text('Overlay & Assistant Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Display Above Other Apps Permission'),
                  subtitle: const Text('Allows floating bubble to remain on screen during multitasking'),
                  secondary: const Icon(Icons.layers),
                  value: _isOverlayEnabled,
                  onChanged: (val) {
                    setState(() {
                      _isOverlayEnabled = val;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Floating Quick Notification Shelf'),
                  subtitle: const Text('Show live floating HUD drawer in notification panel'),
                  secondary: const Icon(Icons.notifications_active),
                  value: _isNotificationTrayActive,
                  onChanged: (val) {
                    setState(() {
                      _isNotificationTrayActive = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // How to drag guide
          Card(
            color: theme.colorScheme.surfaceVariant,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Row(
                children: [
                  Icon(Icons.touch_app, size: 28, color: Colors.indigo),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Interactive Demo Ready', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        SizedBox(height: 2),
                        Text(
                          'Try dragging the purple floating bubble anywhere on this screen! Tap it to open quick actions.',
                          style: TextStyle(fontSize: 12),
                          softWrap: true,
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

  // --- TAB 2: TEXT & LINK PURIFIER ---
  Widget _buildTextPurifierTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Smart Link & Text Purifier', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            'Paste copied texts or shared links to strip tracking scripts (utm_source, fbclid) and extract contacts.',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          // Input Box
          TextField(
            controller: _rawTextController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Raw Copied Text / Shared URL',
              alignLabelWithHint: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _rawTextController.clear();
                  _purifyText();
                },
              ),
            ),
            onChanged: (val) => _purifyText(),
          ),
          const SizedBox(height: 12),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.cleaning_services),
            label: const Text('Clean & Purify Text Now'),
            onPressed: _purifyText,
          ),
          const SizedBox(height: 20),

          // Output Section: Clean Text
          const Text('Cleaned Output:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
            ),
            child: SelectableText(
              _purifiedText.isEmpty ? 'No text processed yet.' : _purifiedText,
              style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('Copy Clean Link'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cleaned text copied to clipboard!')),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Extracted Phone Numbers / Info
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(Icons.phone_android, color: Colors.teal),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Detected Contacts / Numbers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(_extractedNumbers, style: const TextStyle(fontSize: 13), softWrap: true),
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

  // --- TAB 3: SHOPPER MICRO-CALC ---
  Widget _buildShopperCalcTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Shopper Instant Discount & Split', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            'Calculate exact discount savings, sales tax, and multi-person bill splits in seconds.',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Original Price (\$)',
                    prefixText: '\$',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => _calculateDiscount(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _discountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Discount (%)',
                    suffixText: '%',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => _calculateDiscount(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _taxController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Tax (%)',
                    suffixText: '%',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => _calculateDiscount(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _peopleController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Split People',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => _calculateDiscount(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Calculation Summary Card
          Card(
            color: theme.colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('You Save:', style: TextStyle(fontSize: 15)),
                      Text(
                        '\$${_savedAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Final Total Price:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        '\$${_finalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Per Person Share:', style: TextStyle(fontSize: 14)),
                      Text(
                        '\$${_perPersonShare.toStringAsFixed(2)} / person',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: FLOATING STICKY SCRATCHPAD ---
  Widget _buildStickyNotesTab(ThemeData theme) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Micro Scratchpad Cards', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(
                        'Keep temporary pins, coupon codes, and addresses ready for quick copy.',
                        style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                FloatingActionButton.small(
                  onPressed: () => _showAddNoteDialog(theme),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: _notes.isEmpty
                ? const Center(
                    child: Text('No scratchpad items yet. Tap + to add one!'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      final item = _notes[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item['title'] ?? '',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      softWrap: true,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.secondaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      item['tag'] ?? '',
                                      style: TextStyle(fontSize: 11, color: theme.colorScheme.onSecondaryContainer),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              SelectableText(
                                item['body'] ?? '',
                                style: const TextStyle(fontSize: 13),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item['time'] ?? '', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.copy, size: 18),
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Copied: "${item['body']}"')),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            _notes.removeAt(index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Scratchpad Card'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _newNoteTitle,
                  decoration: const InputDecoration(
                    labelText: 'Title / Label',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _newNoteBody,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Snippet / Code / Text',
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
              onPressed: _addStickyNote,
              child: const Text('Save Card'),
            ),
          ],
        );
      },
    );
  }
}