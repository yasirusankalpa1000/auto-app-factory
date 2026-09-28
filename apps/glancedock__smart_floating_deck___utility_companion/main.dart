import 'package:flutter/material.dart';

void main() {
  runApp(const GlanceDockApp());
}

class GlanceDockApp extends StatelessWidget {
  const GlanceDockApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlanceDock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF12181F),
        cardTheme: CardTheme(
          color: const Color(0xFF1E2631),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      home: const MainDockScreen(),
    );
  }
}

class MainDockScreen extends StatefulWidget {
  const MainDockScreen({Key? key}) : super(key: key);

  @override
  State<MainDockScreen> createState() => _MainDockScreenState();
}

class _MainDockScreenState extends State<MainDockScreen> {
  int _currentIndex = 0;

  // Floating Overlay System State Simulation
  bool _overlayEnabled = true;
  bool _notificationBarEnabled = true;
  bool _autoCleanClipboard = false;
  double _bubblePositionX = 20.0;
  double _bubblePositionY = 220.0;
  bool _isFloatingExpanded = false;

  // Saved Snippets
  final List<Map<String, String>> _snippets = [
    {
      'title': 'Bank Transfer Info',
      'category': 'Finance',
      'content': 'Bank: Commercial Bank\nAccount: 8001234567\nName: A. B. C. Perera\nBranch: Colombo Main',
    },
    {
      'title': 'Delivery Address',
      'category': 'Personal',
      'content': 'No. 45, Main Street, Nugegoda, Western Province, Sri Lanka. Landmark: Near Supermarket',
    },
    {
      'title': 'Quick WhatsApp Reply',
      'category': 'Work',
      'content': 'Hi! I am currently in a meeting. Will get back to you in 30 minutes. Thanks!',
    },
    {
      'title': 'USDT Wallet Address',
      'category': 'Finance',
      'content': 'TRC20: T9xY1zA8bC7dE6fG5hI4jK3lM2nO1pQ0rS',
    },
  ];

  // Sticky Screen Notes
  final List<Map<String, dynamic>> _stickyNotes = [
    {'title': 'Groceries', 'body': 'Milk, Bread, Eggs, Coffee powder', 'pinned': true, 'color': Colors.amber},
    {'title': 'Call Architect', 'body': 'Ask about plan review fee \$250', 'pinned': true, 'color': Colors.teal},
    {'title': 'Meeting Agenda', 'body': '1. Q3 Sales\n2. AdMob integration\n3. Release date', 'pinned': false, 'color': Colors.indigo},
  ];

  // Bank Formatter Inputs
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accNameController = TextEditingController();
  final TextEditingController _accNumController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();

  // Text Cleaner Input/Output
  final TextEditingController _rawTextController = TextEditingController();
  String _cleanedResult = '';

  // Micro Decision Engine State
  final List<String> _decisionOptions = ['Option A', 'Option B', 'Option C'];
  final TextEditingController _newOptionController = TextEditingController();
  String _decisionWinner = '';

  @override
  void dispose() {
    _bankNameController.dispose();
    _accNameController.dispose();
    _accNumController.dispose();
    _branchController.dispose();
    _rawTextController.dispose();
    _newOptionController.dispose();
    super.dispose();
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _cleanInputText() {
    String raw = _rawTextController.text;
    if (raw.isEmpty) {
      setState(() => _cleanedResult = '');
      return;
    }
    // Remove tracking params like utm_*, fbclid, etc.
    String cleaned = raw.replaceAll(RegExp(r'(\?|&)(utm_[^&]+|fbclid=[^&]+|gclid=[^&]+)'), '');
    // Remove extra trailing white spaces and duplicate newlines
    cleaned = cleaned.replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
    setState(() {
      _cleanedResult = cleaned;
    });
    _showToast('Text & Links cleaned successfully!');
  }

  void _pickRandomDecision() {
    if (_decisionOptions.isEmpty) return;
    final list = List<String>.from(_decisionOptions);
    list.shuffle();
    setState(() {
      _decisionWinner = list.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.widgets, color: Colors.teal),
            SizedBox(width: 8),
            Text(
              'GlanceDock',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _overlayEnabled ? Icons.layers : Icons.layers_clear,
              color: _overlayEnabled ? Colors.teal : Colors.grey,
            ),
            tooltip: 'Toggle Overlay HUD',
            onPressed: () {
              setState(() {
                _overlayEnabled = !_overlayEnabled;
              });
              _showToast(
                _overlayEnabled
                    ? 'Floating Overlay Dock Activated!'
                    : 'Floating Overlay Dock Suspended.',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showSystemPermissionDialog(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28.0),
          child: Container(
            color: Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Icon(
                  _overlayEnabled ? Icons.circle : Icons.circle_outlined,
                  size: 10,
                  color: _overlayEnabled ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 6),
                Text(
                  _overlayEnabled ? 'Floating HUD Active (Display over Apps)' : 'HUD Paused',
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                ),
                const Spacer(),
                const Text(
                  'v2.4 Smart Companion',
                  style: TextStyle(fontSize: 10, color: Colors.teal),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Navigation View
            IndexedStack(
              index: _currentIndex,
              children: [
                _buildFloatingDeckHomeTab(),
                _buildSnippetsAndBankTab(),
                _buildTextCleanerTab(),
                _buildStickyNotesAndToolsTab(),
              ],
            ),

            // Simulated Floating System Overlay Interactive Widget
            if (_overlayEnabled) _buildSimulatedFloatingWidget(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF161D26),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Floating Deck',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Quick Snippets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: 'Link Cleaner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt),
            label: 'Sticky Notes',
          ),
        ],
      ),
    );
  }

  // Floating Overlay System Simulator
  Widget _buildSimulatedFloatingWidget() {
    return Positioned(
      left: _bubblePositionX,
      top: _bubblePositionY,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubblePositionX += details.delta.dx;
            _bubblePositionY += details.delta.dy;
          });
        },
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(_isFloatingExpanded ? 20 : 30),
          color: const Color(0xFF0F2B38).withOpacity(0.95),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_isFloatingExpanded ? 20 : 30),
              border: Border.all(color: Colors.teal.shade300, width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isFloatingExpanded = !_isFloatingExpanded;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.teal,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.flash_on, color: Colors.white, size: 20),
                      ),
                      if (_isFloatingExpanded) ...[
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'GlanceDock HUD',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                            ),
                            Text(
                              'Drag anywhere on screen',
                              style: TextStyle(fontSize: 9, color: Colors.white70),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                          onPressed: () => setState(() => _isFloatingExpanded = false),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ],
                  ),
                ),
                if (_isFloatingExpanded) ...[
                  const Divider(color: Colors.white70, height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFloatingActionButtonChip(
                        icon: Icons.copy,
                        label: 'Copy Bank',
                        onTap: () {
                          _showToast('Copied Bank Transfer Info to Clipboard!');
                        },
                      ),
                      _buildFloatingActionButtonChip(
                        icon: Icons.link_off,
                        label: 'Clean Link',
                        onTap: () {
                          _showToast('Clipboard Link stripped of tracking params!');
                        },
                      ),
                      _buildFloatingActionButtonChip(
                        icon: Icons.add_comment,
                        label: 'Quick Note',
                        onTap: () => _showAddQuickNoteDialog(),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtonChip({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.teal.shade900.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.teal.shade400, width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.tealAccent),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: Floating Deck & Settings HUD
  Widget _buildFloatingDeckHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner / System Permissions Status
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.layers, color: Colors.teal, size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Floating System Dock',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'GlanceDock operates above your apps so you never need to switch windows while chatting, browsing, or shopping.',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  const Divider(height: 20),
                  SwitchListTile(
                    title: const Text('Display Over Other Apps', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Required to show floating mini companion HUD', style: TextStyle(fontSize: 11)),
                    value: _overlayEnabled,
                    activeColor: Colors.teal,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      setState(() => _overlayEnabled = val);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Floating Action Notification Bar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Keep quick action buttons pinned in status bar', style: TextStyle(fontSize: 11)),
                    value: _notificationBarEnabled,
                    activeColor: Colors.teal,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      setState(() => _notificationBarEnabled = val);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Auto-Clean Copied Links', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Automatically strip UTM tracking tags when copying', style: TextStyle(fontSize: 11)),
                    value: _autoCleanClipboard,
                    activeColor: Colors.teal,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      setState(() => _autoCleanClipboard = val);
                      _showToast(val ? 'Auto-Clean enabled!' : 'Auto-Clean disabled.');
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Active Floating Deck Highlights',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Pinned Quick Access Cards
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Saved Snippets',
                  count: '${_snippets.length}',
                  icon: Icons.copy,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: 'Sticky Pins',
                  count: '${_stickyNotes.where((element) => element['pinned'] == true).length}',
                  icon: Icons.push_pin,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Quick Simulation Screen Interactive Preview
          Card(
            color: const Color(0xFF1B2430),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Floating Deck Drag Sandbox',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.tealAccent),
                      ),
                      Icon(Icons.touch_app, size: 18, color: Colors.tealAccent),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Try dragging the teal floating bubble on this screen to reposition your custom overlay HUD.',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _bubblePositionX = 20.0;
                        _bubblePositionY = 220.0;
                        _isFloatingExpanded = true;
                      });
                      _showToast('Floating HUD reset to screen center!');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Reset Bubble Position'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({required String title, required String count, required IconData icon, required Color color}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: Smart Snippets & Bank Transfer Formatter
  Widget _buildSnippetsAndBankTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Fast Bank Transfer Formatter Generator
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.account_balance, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(
                        '1-Tap Bank Transfer Formatter',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Generate clean, error-free bank account strings to send via SMS or WhatsApp.',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _bankNameController,
                    decoration: const InputDecoration(
                      labelText: 'Bank Name (e.g. Commercial Bank)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _accNameController,
                    decoration: const InputDecoration(
                      labelText: 'Account Holder Name',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _accNumController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Account Number',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _branchController,
                          decoration: const InputDecoration(
                            labelText: 'Branch Name',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _generateAndSaveBankSnippet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Generate & Save Snippet', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Section 2: Saved Micro Snippets List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Saved Quick Snippets',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.teal),
                onPressed: () => _showAddSnippetDialog(),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _snippets.length,
            itemBuilder: (context, index) {
              final snippet = _snippets[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              snippet['title'] ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.tealAccent),
                              softWrap: true,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade900,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              snippet['category'] ?? 'General',
                              style: const TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        snippet['content'] ?? '',
                        style: const TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                            onPressed: () {
                              setState(() {
                                _snippets.removeAt(index);
                              });
                              _showToast('Snippet deleted');
                            },
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              _showToast('Copied "${snippet['title']}" to clipboard!');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            ),
                            icon: const Icon(Icons.copy, size: 14),
                            label: const Text('Copy', style: TextStyle(fontSize: 12)),
                          ),
                        ],
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

  void _generateAndSaveBankSnippet() {
    if (_bankNameController.text.isEmpty || _accNumController.text.isEmpty) {
      _showToast('Please fill at least Bank Name & Account Number.');
      return;
    }
    String content = 'Bank: ${_bankNameController.text.trim()}\n'
        'Account: ${_accNumController.text.trim()}\n'
        'Name: ${_accNameController.text.trim()}\n'
        'Branch: ${_branchController.text.trim()}';

    setState(() {
      _snippets.insert(0, {
        'title': '${_bankNameController.text.trim()} Transfer Info',
        'category': 'Finance',
        'content': content,
      });
      _bankNameController.clear();
      _accNameController.clear();
      _accNumController.clear();
      _branchController.clear();
    });
    _showToast('Bank details saved to Quick Snippets!');
  }

  // TAB 3: Tracking Link Stripper & Text Cleaner
  Widget _buildTextCleanerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.cleaning_services, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(
                        'Tracking Link & Text Cleaner',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Paste messy tracking URLs (UTM tags, Facebook/Google tracking) or text with bloated formatting to strip clutter instantly.',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _rawTextController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Paste raw link or messy text here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _rawTextController.clear();
                            setState(() => _cleanedResult = '');
                          },
                          icon: const Icon(Icons.clear, size: 16),
                          label: const Text('Clear'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _cleanInputText,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.bolt, size: 16),
                          label: const Text('Clean Text', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (_cleanedResult.isNotEmpty) ...[
            const Text(
              'Cleaned Output',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.tealAccent),
            ),
            const SizedBox(height: 8),
            Card(
              color: const Color(0xFF132029),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      _cleanedResult,
                      style: const TextStyle(fontSize: 13, height: 1.4),
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            _showToast('Copied cleaned text!');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.copy, size: 14),
                          label: const Text('Copy Cleaned Text'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 20),
          const Text(
            'Quick Utility Shortcuts',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildShortcutChip('Format Phone (+94)', Icons.phone, () {
                String t = _rawTextController.text.replaceAll(RegExp(r'[^\d+]'), '');
                if (t.startsWith('0')) t = '+94${t.substring(1)}';
                setState(() => _cleanedResult = t);
                _showToast('Formatted phone number!');
              }),
              _buildShortcutChip('Remove Line Breaks', Icons.wrap_text, () {
                String t = _rawTextController.text.replaceAll('\n', ' ');
                setState(() => _cleanedResult = t);
                _showToast('Line breaks removed!');
              }),
              _buildShortcutChip('UPPERCASE ALL', Icons.text_fields, () {
                setState(() => _cleanedResult = _rawTextController.text.toUpperCase());
              }),
              _buildShortcutChip('lowercase all', Icons.text_fields, () {
                setState(() => _cleanedResult = _rawTextController.text.toLowerCase());
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutChip(String label, IconData icon, VoidCallback onTap) {
    return ActionChip(
      avatar: Icon(icon, size: 14, color: Colors.tealAccent),
      label: Text(label, style: const TextStyle(fontSize: 11)),
      backgroundColor: const Color(0xFF1E2631),
      onPressed: onTap,
    );
  }

  // TAB 4: Sticky Notes & Micro Decision Tool
  Widget _buildStickyNotesAndToolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Interactive Screen Sticky Notes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.push_pin, color: Colors.amber),
                  SizedBox(width: 8),
                  Text(
                    'Screen Sticky Notes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.teal),
                onPressed: () => _showAddQuickNoteDialog(),
              ),
            ],
          ),
          const SizedBox(height: 8),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.1,
            ),
            itemCount: _stickyNotes.length,
            itemBuilder: (context, index) {
              final note = _stickyNotes[index];
              final Color cardColor = note['color'] as Color? ?? Colors.teal;
              return Card(
                color: const Color(0xFF1B2430),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: note['pinned'] == true ? cardColor : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              note['title'] ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: cardColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                note['pinned'] = !(note['pinned'] == true);
                              });
                              _showToast(note['pinned'] ? 'Note pinned to overlay HUD' : 'Note unpinned');
                            },
                            child: Icon(
                              note['pinned'] == true ? Icons.push_pin : Icons.push_pin_outlined,
                              size: 16,
                              color: note['pinned'] == true ? Colors.amber : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Text(
                          note['body'] ?? '',
                          style: const TextStyle(fontSize: 11, color: Colors.white70),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete, size: 14, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _stickyNotes.removeAt(index);
                              });
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Section 2: Daily Micro Decision Engine
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.casino, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'Micro Decision Engine',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Can\'t decide lunch menu, task priorities, or quick choices? Spin the Glance decision deck.',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _newOptionController,
                          decoration: const InputDecoration(
                            hintText: 'Add option (e.g. Fried Rice)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.teal, size: 30),
                        onPressed: () {
                          if (_newOptionController.text.trim().isNotEmpty) {
                            setState(() {
                              _decisionOptions.add(_newOptionController.text.trim());
                              _newOptionController.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _decisionOptions.map((opt) {
                      return Chip(
                        label: Text(opt, style: const TextStyle(fontSize: 11)),
                        backgroundColor: const Color(0xFF132029),
                        onDeleted: () {
                          setState(() {
                            _decisionOptions.remove(opt);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  if (_decisionWinner.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade900.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.teal),
                      ),
                      child: Column(
                        children: [
                          const Text('Glance Choice:', style: TextStyle(fontSize: 10, color: Colors.white70)),
                          const SizedBox(height: 4),
                          Text(
                            _decisionWinner,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _pickRandomDecision,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade700,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      icon: const Icon(Icons.play_arrow, size: 18),
                      label: const Text('Pick For Me!', style: TextStyle(fontWeight: FontWeight.bold)),
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

  // Dialogs
  void _showAddSnippetDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String category = 'General';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Quick Snippet'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title (e.g. Home Address)'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: contentController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Content text'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                  setState(() {
                    _snippets.add({
                      'title': titleController.text.trim(),
                      'category': category,
                      'content': contentController.text.trim(),
                    });
                  });
                  Navigator.pop(context);
                  _showToast('New snippet saved!');
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAddQuickNoteDialog() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Sticky Screen Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Note Title'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: bodyController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Note Content'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    _stickyNotes.add({
                      'title': titleController.text.trim(),
                      'body': bodyController.text.trim(),
                      'pinned': true,
                      'color': Colors.teal,
                    });
                  });
                  Navigator.pop(context);
                  _showToast('Sticky note pinned!');
                }
              },
              child: const Text('Pin Note'),
            ),
          ],
        );
      },
    );
  }

  void _showSystemPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.verified_user, color: Colors.teal),
              SizedBox(width: 8),
              Text('Glance Permissions'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'To use GlanceDock over other apps:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                SizedBox(height: 8),
                Text('1. Grant "Display Over Other Apps" in system settings.', style: TextStyle(fontSize: 12)),
                SizedBox(height: 4),
                Text('2. Enable Notification Quick-Actions permission for status bar widgets.', style: TextStyle(fontSize: 12)),
                SizedBox(height: 4),
                Text('3. Enable Clipboard Access for instant link tracking cleaning.', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got It'),
            ),
          ],
        );
      },
    );
  }
}