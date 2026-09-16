import 'package:flutter/material.dart';

void main() {
  runApp(const ClipPulseApp());
}

class ClipPulseApp extends StatelessWidget {
  const ClipPulseApp({super.key});

  @override
  Widget build(BuildContext meCtx) {
    return MaterialApp(
      title: 'ClipPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.cyanAccent,
          surface: Color(0xFF1E293B),
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
  int _selectedTabIndex = 0;
  bool _isOverlayBubbleActive = true;
  double _bubblePosX = 20.0;
  double _bubblePosY = 180.0;

  // App global interactive states
  int _dailyCleanCount = 14;
  int _copiedSnippetsCount = 8;
  
  @override
  Widget build(BuildContext meCtx) {
    final List<Widget> tabs = [
      WorkbenchTab(onActionExecuted: _incrementCleanCount),
      StickyDeckTab(),
      MicroToolsTab(),
      OverlaySettingsTab(
        isBubbleActive: _isOverlayBubbleActive,
        onToggleBubble: (val) {
          setState(() {
            _isOverlayBubbleActive = val;
          });
        },
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeaderBar(),
                Expanded(child: tabs[_selectedTabIndex]),
              ],
            ),
            if (_isOverlayBubbleActive) _buildFloatingBubbleOverlay(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1E293B),
          border: Border(top: BorderSide(color: Colors.white70, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedTabIndex,
          onTap: (index) => setState(() => _selectedTabIndex = index),
          backgroundColor: const Color(0xFF1E293B),
          selectedItemColor: Colors.tealAccent,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.cleaning_services),
              label: 'Workbench',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.layers),
              label: 'Sticky Deck',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              label: 'Micro Tools',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tune),
              label: 'Hub Control',
            ),
          ],
        ),
      ),
    );
  }

  void _incrementCleanCount() {
    setState(() {
      _dailyCleanCount++;
      _copiedSnippetsCount++;
    });
  }

  Widget _buildHeaderBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: const Color(0xFF1E293B),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.tealAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.bolt, color: Colors.tealAccent, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ClipPulse Pro',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Active Context Copilot • $_dailyCleanCount Cleaned',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _isOverlayBubbleActive
                  ? Colors.green.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isOverlayBubbleActive ? Colors.green : Colors.grey,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 8,
                  color: _isOverlayBubbleActive ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  _isOverlayBubbleActive ? 'FLOAT ON' : 'FLOAT OFF',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _isOverlayBubbleActive ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBubbleOverlay() {
    return Positioned(
      left: _bubblePosX,
      top: _bubblePosY,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubblePosX += details.delta.dx;
            _bubblePosY += details.delta.dy;
          });
        },
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('ClipPulse Floating Assistant Active! Tap tabs to use context tools.'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.teal,
            ),
          );
        },
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Colors.tealAccent, Colors.blueAccent],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.tealAccent.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 2,
              )
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.content_copy,
              color: Colors.black,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// TAB 1: WORKBENCH (SMART TEXT & LINK CLEANER)
// ==========================================
class WorkbenchTab extends StatefulWidget {
  final VoidCallback onActionExecuted;
  const WorkbenchTab({super.key, required: this.onActionExecuted});

  @override
  State<WorkbenchTab> createState() => _WorkbenchTabState();
}

class _WorkbenchTabState extends State<WorkbenchTab> {
  final TextEditingController _inputController = TextEditingController(
    text: 'Check this link: https://shop.com/item?id=492&utm_source=social&utm_medium=cpc - call me at +18005550199 or email test@example.com for discounts!',
  );

  String _cleanedResult = '';
  List<String> _extractedLinks = [];
  List<String> _extractedEmails = [];
  List<String> _extractedPhones = [];

  @override
  void initState() {
    super.initState();
    _analyzeAndCleanText();
  }

  void _analyzeAndCleanText() {
    final raw = _inputController.text;
    
    // Clean UTM parameters and tracking queries
    String cleaned = raw.replaceAll(RegExp(r'\?utm_[^&\s]+(&|$)'), '');
    cleaned = cleaned.replaceAll(RegExp(r'&utm_[^&\s]+'), '');
    
    // Extract items
    final emailRegExp = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    final phoneRegExp = RegExp(r'\+?[0-9]{8,15}');
    final urlRegExp = RegExp(r'https?://[^\s]+');

    final emails = emailRegExp.allMatches(raw).map((m) => m.group(0) ?? '').toList();
    final phones = phoneRegExp.allMatches(raw).map((m) => m.group(0) ?? '').toList();
    final urls = urlRegExp.allMatches(cleaned).map((m) => m.group(0) ?? '').toList();

    setState(() {
      _cleanedResult = cleaned;
      _extractedEmails = emails;
      _extractedPhones = phones;
      _extractedLinks = urls;
    });
  }

  @override
  Widget build(BuildContext meCtx) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Smart Clipboard Workbench', Icons.cleaning_services),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Raw Copied Content / Messy Text',
                    style: TextStyle(color: Colors.tealAccent, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _inputController,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Paste messy text, UTM links, or unformatted contacts here...',
                      hintStyle: TextStyle(color: Colors.white70),
                    ),
                    onChanged: (_) => _analyzeAndCleanText(),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          _analyzeAndCleanText();
                          widget.onActionExecuted();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Text Auto-Sanitized & Context Extracted!')),
                          );
                        },
                        icon: const Icon(Icons.auto_fix_high, size: 18),
                        label: const Text('Sanitize & Clean'),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          _inputController.clear();
                          _analyzeAndCleanText();
                        },
                        icon: const Icon(Icons.clear, size: 18),
                        label: const Text('Clear'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionHeader('Cleaned Output', Icons.check_circle),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _cleanedResult.isEmpty ? 'No cleaned text yet.' : _cleanedResult,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent.withOpacity(0.2),
                          foregroundColor: Colors.tealAccent,
                        ),
                        onPressed: () {
                          widget.onActionExecuted();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cleaned text copied to clipboard!')),
                          );
                        },
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text('Copy Clean Text'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionHeader('Extracted Micro-Context', Icons.find_in_page),
            const SizedBox(height: 8),
            _buildExtractionChips('Emails Found', _extractedEmails, Icons.email, Colors.cyanAccent),
            const SizedBox(height: 8),
            _buildExtractionChips('Phones Found', _extractedPhones, Icons.phone, Colors.greenAccent),
            const SizedBox(height: 8),
            _buildExtractionChips('Clean Links', _extractedLinks, Icons.link, Colors.amberAccent),
          ],
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

  Widget _buildExtractionChips(String label, List<String> items, IconData icon, Color badgeColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: badgeColor),
              const SizedBox(width: 6),
              Text(
                '$label (${items.length})',
                style: TextStyle(color: badgeColor, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          items.isEmpty
              ? const Text('None detected in input', style: TextStyle(color: Colors.white70, fontSize: 12))
              : Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: items.map((item) {
                    return ActionChip(
                      avatar: Icon(Icons.copy, size: 14, color: badgeColor),
                      label: Text(
                        item,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                      backgroundColor: const Color(0xFF0F172A),
                      onPressed: () {
                        widget.onActionExecuted();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Copied: $item')),
                        );
                      },
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }
}

// ==========================================
// TAB 2: STICKY DECK (FLOATING SCREEN CARDS)
// ==========================================
class StickyDeckTab extends StatefulWidget {
  const StickyDeckTab({super.key});

  @override
  State<StickyDeckTab> createState() => _StickyDeckTabState();
}

class _StickyDeckTabState extends State<StickyDeckTab> {
  final List<Map<String, dynamic>> _stickyNotes = [
    {
      'id': '1',
      'title': 'Wi-Fi Password',
      'content': 'Home_5G: SafePass2025!',
      'color': Colors.amber,
      'isPinned': true,
    },
    {
      'id': '2',
      'title': 'Shopping Micro-List',
      'content': '• Oats\n• Almond Milk\n• Dark Chocolate',
      'color': Colors.tealAccent,
      'isPinned': false,
    },
    {
      'id': '3',
      'title': 'Project Note',
      'content': 'Submit app bundle by 5:00 PM today',
      'color': Colors.cyanAccent,
      'isPinned': true,
    },
  ];

  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _contentCtrl = TextEditingController();

  void _addNewNote() {
    if (_titleCtrl.text.isEmpty) return;
    setState(() {
      _stickyNotes.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': _titleCtrl.text,
        'content': _contentCtrl.text,
        'color': Colors.purpleAccent,
        'isPinned': true,
      });
      _titleCtrl.clear();
      _contentCtrl.clear();
    });
    Navigator.pop(context);
  }

  void _showAddDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'New Floating Screen Card',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Card Title',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _contentCtrl,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Quick Text Snippet',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: _addNewNote,
                  icon: const Icon(Icons.pin_drop),
                  label: const Text('Pin Card to Deck'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext meCtx) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.tealAccent,
          foregroundColor: Colors.black,
          onPressed: _showAddDialog,
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Live Screen Cards',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${_stickyNotes.length} Cards Active',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _stickyNotes.length,
                itemBuilder: (ctx, index) {
                  final note = _stickyNotes[index];
                  final Color noteColor = note['color'] as Color;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: note['isPinned'] ? noteColor : Colors.white70,
                        width: note['isPinned'] ? 1.5 : 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 6,
                                  backgroundColor: noteColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  note['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    note['isPinned'] ? Icons.push_pin : Icons.push_pin_outlined,
                                    color: note['isPinned'] ? noteColor : Colors.white70,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      note['isPinned'] = !note['isPinned'];
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.white70, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      _stickyNotes.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          note['content'],
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Copied card content: ${note['title']}')),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.copy, size: 12, color: Colors.tealAccent),
                                    SizedBox(width: 4),
                                    Text('Quick Copy', style: TextStyle(color: Colors.tealAccent, fontSize: 10)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// TAB 3: MICRO TOOLS (CALCULATORS & REPLIES)
// ==========================================
class MicroToolsTab extends StatefulWidget {
  const MicroToolsTab({super.key});

  @override
  State<MicroToolsTab> createState() => _MicroToolsTabState();
}

class _MicroToolsTabState extends State<MicroToolsTab> {
  // Split bill calculator
  double _billAmount = 85.0;
  double _tipPercentage = 15.0;
  int _peopleCount = 3;

  // Discount calculator
  double _originalPrice = 120.0;
  double _discountPercent = 20.0;

  // Quick reply dynamic crafter
  String _replyTone = 'Professional';
  String _replyRecipient = 'Manager';

  double get _totalWithTip => _billAmount + (_billAmount * (_tipPercentage / 100));
  double get _perPersonPay => _totalWithTip / (_peopleCount > 0 ? _peopleCount : 1);

  double get _discountedPrice => _originalPrice - (_originalPrice * (_discountPercent / 100));
  double get _savingsAmount => _originalPrice * (_discountPercent / 100);

  String get _generatedReply {
    if (_replyTone == 'Professional') {
      return 'Hello $_replyRecipient, thank you for the update. I have reviewed the details and will follow up shortly.';
    } else if (_replyTone == 'Friendly') {
      return 'Hey $_replyRecipient! Thanks for sharing this. Sounds good to me, talk to you soon!';
    } else {
      return 'Hi $_replyRecipient, received. I will handle this ASAP and confirm once done.';
    }
  }

  @override
  Widget build(BuildContext meCtx) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Instant Micro-Calculators & Crafter',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            // BILL SPLITTER TOOL
            _buildToolCard(
              title: 'Instant Bill & Tip Splitter',
              icon: Icons.splitscreen,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Bill Amount: \$${_billAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
                      Text('People: $_peopleCount', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: _billAmount,
                    min: 5,
                    max: 500,
                    activeColor: Colors.tealAccent,
                    onChanged: (val) => setState(() => _billAmount = val),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tip: ${_tipPercentage.toInt()}%', style: const TextStyle(color: Colors.white70)),
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
                  Slider(
                    value: _tipPercentage,
                    min: 0,
                    max: 30,
                    activeColor: Colors.cyanAccent,
                    onChanged: (val) => setState(() => _tipPercentage = val),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('Total + Tip', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            Text('\$${_totalWithTip.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Each Pays', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            Text('\$${_perPersonPay.toStringAsFixed(2)}', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // DISCOUNT MATRIX TOOL
            _buildToolCard(
              title: 'Discount & Savings Matrix',
              icon: Icons.percent,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Original: \$${_originalPrice.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
                      Text('Discount: ${_discountPercent.toInt()}%', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: _originalPrice,
                    min: 10,
                    max: 1000,
                    activeColor: Colors.amber,
                    onChanged: (val) => setState(() => _originalPrice = val),
                  ),
                  Slider(
                    value: _discountPercent,
                    min: 5,
                    max: 90,
                    activeColor: Colors.orangeAccent,
                    onChanged: (val) => setState(() => _discountPercent = val),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('You Save', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            Text('\$${_savingsAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Final Price', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            Text('\$${_discountedPrice.toStringAsFixed(2)}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // QUICK REPLY CRAFTER TOOL
            _buildToolCard(
              title: 'Smart Context Reply Crafter',
              icon: Icons.chat_bubble_outline,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    children: ['Professional', 'Friendly', 'Urgent'].map((tone) {
                      final isSelected = _replyTone == tone;
                      return ChoiceChip(
                        label: Text(tone),
                        selected: isSelected,
                        selectedColor: Colors.tealAccent,
                        labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white),
                        onSelected: (val) {
                          if (val) setState(() => _replyTone = tone);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white70),
                    ),
                    child: Text(
                      _generatedReply,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Generated reply copied!')),
                        );
                      },
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Copy Draft'),
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

  Widget _buildToolCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.tealAccent, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ==========================================
// TAB 4: HUB CONTROL & OVERLAY PERMISSIONS
// ==========================================
class OverlaySettingsTab extends StatefulWidget {
  final bool isBubbleActive;
  final ValueChanged<bool> onToggleBubble;

  const OverlaySettingsTab({
    super.key,
    required: this.isBubbleActive,
    required: this.onToggleBubble,
  });

  @override
  State<OverlaySettingsTab> createState() => _OverlaySettingsTabState();
}

class _OverlaySettingsTabState extends State<OverlaySettingsTab> {
  bool _autoCleanUrl = true;
  bool _quickNotificationBar = true;
  bool _keepHistory = true;

  @override
  Widget build(BuildContext meCtx) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hub Control & System Permissions',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: Colors.tealAccent,
                    title: const Text('Floating Screen Bubble Simulator', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Renders on-screen draggable quick context widget', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    value: widget.isBubbleActive,
                    onChanged: widget.onToggleBubble,
                  ),
                  const Divider(color: Colors.white70),
                  SwitchListTile(
                    activeColor: Colors.tealAccent,
                    title: const Text('Auto-Strip URL UTM Tracking Tags', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Automatically clean links when pasted into workbench', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    value: _autoCleanUrl,
                    onChanged: (val) => setState(() => _autoCleanUrl = val),
                  ),
                  const Divider(color: Colors.white70),
                  SwitchListTile(
                    activeColor: Colors.tealAccent,
                    title: const Text('Persistent Quick Notification Shelf', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Keep instant snippet access in system bar', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    value: _quickNotificationBar,
                    onChanged: (val) => setState(() => _quickNotificationBar = val),
                  ),
                  const Divider(color: Colors.white70),
                  SwitchListTile(
                    activeColor: Colors.tealAccent,
                    title: const Text('Local Session Retention History', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Store extracted emails & links locally', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    value: _keepHistory,
                    onChanged: (val) => setState(() => _keepHistory = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.tealAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shield, color: Colors.tealAccent, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '100% On-Device Privacy Guaranteed',
                        style: TextStyle(color: Colors.tealAccent, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    'ClipPulse processes clipboard text, emails, and links strictly on your phone device. No personal text data is ever stored or uploaded externally.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}