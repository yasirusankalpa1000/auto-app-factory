import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ClipDockApp());
}

class ClipDockApp extends StatelessWidget {
  const ClipDockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClipDock HUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F111A),
        cardTheme: const CardTheme(
          color: Color(0xFF1E2230),
          elevation: 2,
        ),
      ),
      home: const ClipDockHomeScreen(),
    );
  }
}

class ClipItem {
  final String id;
  final String rawText;
  final String type; // Link, Phone, Bank Account, Email, Price, Text
  final DateTime timestamp;
  bool isFavorite;

  ClipItem({
    required this.id,
    required this.rawText,
    required this.type,
    required this.timestamp,
    this.isFavorite = false,
  });
}

class QuickSnippet {
  final String id;
  final String title;
  final String content;
  final String category;
  final IconData icon;

  QuickSnippet({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.icon,
  });
}

class ScratchNote {
  final String id;
  final String title;
  final String content;
  final Color color;

  ScratchNote({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
  });
}

class ClipDockHomeScreen extends StatefulWidget {
  const ClipDockHomeScreen({super.key});

  @override
  State<ClipDockHomeScreen> createState() => _ClipDockHomeScreenState();
}

class _ClipDockHomeScreenState extends State<ClipDockHomeScreen> {
  int _currentBottomNavIndex = 0;

  // App Settings Toggles
  bool _isFloatingOverlayEnabled = true;
  bool _isNotificationDockActive = true;
  bool _isAutoParseEnabled = true;
  bool _isPrivacyBlurEnabled = false;

  // Floating HUD State
  bool _isHudExpanded = false;
  Offset _hudPosition = const Offset(20, 200);

  // Manual Input Controllers
  final TextEditingController _inputParserController = TextEditingController();
  final TextEditingController _transformInputController = TextEditingController();
  final TextEditingController _snippetTitleController = TextEditingController();
  final TextEditingController _snippetContentController = TextEditingController();
  final TextEditingController _scratchTitleController = TextEditingController();
  final TextEditingController _scratchContentController = TextEditingController();

  // Transformed output
  String _transformedOutput = "";

  // Data Collections
  final List<ClipItem> _clipHistory = [
    ClipItem(
      id: '1',
      rawText: 'https://example.com/checkout?item=992&track=xyz_9981273918237',
      type: 'Link',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isFavorite: true,
    ),
    ClipItem(
      id: '2',
      rawText: 'Commercial Bank Acc: 8009124561 (Branch: Colombo Fort)',
      type: 'Bank Account',
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    ClipItem(
      id: '3',
      rawText: 'Contact support team at help@clipdock.app or +1 800 555 0199',
      type: 'Phone / Email',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ClipItem(
      id: '4',
      rawText: 'Total invoice price for project renewal is \$149.99 USD',
      type: 'Price',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];

  final List<QuickSnippet> _snippets = [
    QuickSnippet(
      id: 's1',
      title: 'My Bank Details',
      content: 'Account: 1092-3341-9982\nBank: National Trust\nName: John Doe',
      category: 'Finance',
      icon: Icons.monetization_on,
    ),
    QuickSnippet(
      id: 's2',
      title: 'Office Address',
      content: 'Suite 404, Tech Park Tower B, Silicon Avenue, NY 10001',
      category: 'Work',
      icon: Icons.home,
    ),
    QuickSnippet(
      id: 's3',
      title: 'Quick WhatsApp Template',
      content: 'Hi! I received your request. Let me review and get back to you in 10 mins.',
      category: 'Social',
      icon: Icons.share,
    ),
  ];

  final List<ScratchNote> _scratchNotes = [
    ScratchNote(
      id: 'n1',
      title: 'Meeting Pins',
      content: 'Discuss quarterly goals & dynamic HUD widget features',
      color: Colors.amber,
    ),
    ScratchNote(
      id: 'n2',
      title: 'Grocery Codes',
      content: 'Milk, Oats, Coffee, Coupon Code: SAVE20NOW',
      color: Colors.teal,
    ),
  ];

  @override
  void dispose() {
    _inputParserController.dispose();
    _transformInputController.dispose();
    _snippetTitleController.dispose();
    _snippetContentController.dispose();
    _scratchTitleController.dispose();
    _scratchContentController.dispose();
    super.dispose();
  }

  // --- LOGIC METHODS ---

  void _parseAndAddText(String text) {
    if (text.trim().isEmpty) return;
    String detectedType = 'Text';
    if (text.contains('http://') || text.contains('https://')) {
      detectedType = 'Link';
    } else if (text.contains('@') && text.contains('.')) {
      detectedType = 'Email';
    } else if (text.contains('\$') || text.toLowerCase().contains('usd') || text.toLowerCase().contains('rs.')) {
      detectedType = 'Price';
    } else if (RegExp(r'\b\d{9,16}\b').hasMatch(text)) {
      detectedType = 'Bank Account';
    } else if (RegExp(r'\+?\d[\d -]{7,}\d').hasMatch(text)) {
      detectedType = 'Phone';
    }

    setState(() {
      _clipHistory.insert(
        0,
        ClipItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          rawText: text,
          type: detectedType,
          timestamp: DateTime.now(),
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Auto-Parsed & Added to ClipDock as [$detectedType]'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to system clipboard!'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _cleanUrl(String url) {
    if (url.contains('?')) {
      return url.split('?')[0];
    }
    return url;
  }

  String _maskSensitiveText(String text) {
    return text.replaceAll(RegExp(r'\d(?=\d{4})'), '*');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Navigation Screen Body
            Column(
              children: [
                _buildTopAppBar(),
                _buildFloatingPermissionBanner(),
                Expanded(
                  child: _buildActiveTabBody(),
                ),
              ],
            ),

            // Simulated Floating Dynamic HUD Widget Overlay
            if (_isFloatingOverlayEnabled) _buildInteractiveFloatingHud(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
        },
        selectedItemColor: Colors.indigoAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF161925),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'HUD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'Extractor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Dock',
          ),
        ],
      ),
    );
  }

  // --- APP BAR & BANNERS ---

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF161925),
        border: Border(bottom: BorderSide(color: Colors.white70)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.layers, color: Colors.indigoAccent),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ClipDock HUD',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Universal Dynamic Overlay Assistant',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _isNotificationDockActive ? Icons.notifications_active : Icons.notifications_off,
              color: _isNotificationDockActive ? Colors.greenAccent : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isNotificationDockActive = !_isNotificationDockActive;
              });
            },
            tooltip: 'Toggle Dynamic Notification Dock',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingPermissionBanner() {
    return Container(
      width: double.infinity,
      color: Colors.indigo.withOpacity(0.15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.widgets, size: 18, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _isFloatingOverlayEnabled
                  ? 'Display Above Apps Active • Floating Bubble Enabled'
                  : 'Floating Bubble Hidden • Tap to enable dynamic HUD',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Switch(
            value: _isFloatingOverlayEnabled,
            activeColor: Colors.indigoAccent,
            onChanged: (val) {
              setState(() {
                _isFloatingOverlayEnabled = val;
              });
            },
          ),
        ],
      ),
    );
  }

  // --- ACTIVE SCREEN ROUTER ---

  Widget _buildActiveTabBody() {
    switch (_currentBottomNavIndex) {
      case 0:
        return _buildHudDashboard();
      case 1:
        return _buildSmartExtractorTab();
      case 2:
        return _buildSnippetVaultTab();
      case 3:
        return _buildTextToolsTab();
      case 4:
        return _buildDockSettingsTab();
      default:
        return _buildHudDashboard();
    }
  }

  // --- TAB 1: HUD DASHBOARD ---

  Widget _buildHudDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickInputBox(),
          const SizedBox(height: 20),
          _buildSectionHeader('Live Clipboard Feed', Icons.history, '${_clipHistory.length} items'),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _clipHistory.length,
            itemBuilder: (context, index) {
              final item = _clipHistory[index];
              return _buildClipCard(item);
            },
          ),
          const SizedBox(height: 20),
          _buildSectionHeader('Floating Micro Scratchpad', Icons.edit_note, '${_scratchNotes.length} notes'),
          const SizedBox(height: 12),
          _buildScratchpadGrid(),
        ],
      ),
    );
  }

  Widget _buildQuickInputBox() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Instant Clip Parser',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _inputParserController,
              maxLines: 2,
              style: const TextStyle(fontSize: 13, color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Paste any text, raw link, bank info, or phone number here...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    final data = await Clipboard.getData('text/plain');
                    if (data != null && data.text != null) {
                      _inputParserController.text = data.text!;
                    }
                  },
                  icon: const Icon(Icons.paste, size: 16, color: Colors.indigoAccent),
                  label: const Text('Paste System Clipboard', style: TextStyle(color: Colors.indigoAccent, fontSize: 12)),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                  onPressed: () {
                    _parseAndAddText(_inputParserController.text);
                    _inputParserController.clear();
                  },
                  icon: const Icon(Icons.add, size: 16, color: Colors.white),
                  label: const Text('Parse & Save', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClipCard(ClipItem item) {
    Color badgeColor = Colors.indigoAccent;
    IconData typeIcon = Icons.text_snippet;

    if (item.type == 'Link') {
      badgeColor = Colors.blue;
      typeIcon = Icons.link;
    } else if (item.type == 'Bank Account') {
      badgeColor = Colors.teal;
      typeIcon = Icons.monetization_on;
    } else if (item.type == 'Phone' || item.type == 'Phone / Email') {
      badgeColor = Colors.orange;
      typeIcon = Icons.phone;
    } else if (item.type == 'Price') {
      badgeColor = Colors.green;
      typeIcon = Icons.monetization_on;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(typeIcon, size: 14, color: badgeColor),
                      const SizedBox(width: 4),
                      Text(
                        item.type,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: badgeColor),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    item.isFavorite ? Icons.star : Icons.star_border,
                    size: 18,
                    color: item.isFavorite ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      item.isFavorite = !item.isFavorite;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _clipHistory.removeWhere((i) => i.id == item.id);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _isPrivacyBlurEnabled && item.type == 'Bank Account'
                  ? _maskSensitiveText(item.rawText)
                  : item.rawText,
              style: const TextStyle(fontSize: 13, color: Colors.white70),
              softWrap: true,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white70),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                    ),
                    onPressed: () => _copyToClipboard(item.rawText),
                    icon: const Icon(Icons.content_copy, size: 14, color: Colors.indigoAccent),
                    label: const Text('1-Tap Copy', style: TextStyle(fontSize: 11, color: Colors.indigoAccent)),
                  ),
                ),
                if (item.type == 'Link') ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.blueAccent),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                      ),
                      onPressed: () {
                        final cleaned = _cleanUrl(item.rawText);
                        _copyToClipboard(cleaned);
                      },
                      icon: const Icon(Icons.cleaning_services, size: 14, color: Colors.blueAccent),
                      label: const Text('Clean URL & Copy', style: TextStyle(fontSize: 11, color: Colors.blueAccent)),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScratchpadGrid() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Floating Sticky Pins', style: TextStyle(fontSize: 13, color: Colors.white70)),
            TextButton.icon(
              onPressed: _showAddScratchNoteDialog,
              icon: const Icon(Icons.add, size: 16, color: Colors.indigoAccent),
              label: const Text('New Scratch Note', style: TextStyle(color: Colors.indigoAccent, fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _scratchNotes.map((note) {
            return Container(
              width: (MediaQuery.of(context).size.width - 42) / 2,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: note.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: note.color.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.push_pin, size: 14, color: note.color),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          note.title,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: note.color),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _scratchNotes.removeWhere((n) => n.id == note.id);
                          });
                        },
                        child: const Icon(Icons.close, size: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    note.content,
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _copyToClipboard(note.content),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Copy Note', style: TextStyle(fontSize: 10, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- TAB 2: SMART EXTRACTOR ---

  Widget _buildSmartExtractorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Smart Context Parser', Icons.auto_awesome, 'Auto-Detect Patterns'),
          const SizedBox(height: 12),
          const Text(
            'Paste unformatted text block, long messages, or emails below. ClipDock will instantly parse links, IBANs, prices, and contacts into discrete 1-tap copy blocks.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          TextField(
            maxLines: 4,
            style: const TextStyle(fontSize: 13, color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Paste large snippet or raw email block here...',
              border: OutlineInputBorder(),
            ),
            onChanged: (text) {
              // Realtime parse trigger
            },
          ),
          const SizedBox(height: 16),
          const Text('Extracted Micro-Elements:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
          const SizedBox(height: 10),
          _buildExtractorResultCard(
            'Detected Price',
            '\$149.99',
            Icons.monetization_on,
            Colors.green,
          ),
          _buildExtractorResultCard(
            'Cleaned URL (Tracking Removed)',
            'https://example.com/checkout',
            Icons.link,
            Colors.blue,
          ),
          _buildExtractorResultCard(
            'Formatted Contact Phone',
            '+1 (800) 555-0199',
            Icons.phone,
            Colors.orange,
          ),
          _buildExtractorResultCard(
            'Bank Account Snippet',
            '8009124561',
            Icons.monetization_on,
            Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildExtractorResultCard(String label, String value, IconData icon, Color accentColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile,
      // Replacing ListTile with explicit responsive Row to guarantee no overflow
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.content_copy, size: 18, color: Colors.indigoAccent),
              onPressed: () => _copyToClipboard(value),
              tooltip: 'Copy',
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 3: SNIPPET VAULT ---

  Widget _buildSnippetVaultTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader('Quick Snippet Vault', Icons.star, 'High-Frequency Templates'),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.indigoAccent, size: 28),
                onPressed: _showAddSnippetDialog,
                tooltip: 'Add Snippet',
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Keep high-frequency address pins, bank details, standard replies, and hashtags ready for immediate floating insertion.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _snippets.length,
            itemBuilder: (context, index) {
              final snippet = _snippets[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(snippet.icon, size: 18, color: Colors.indigoAccent),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              snippet.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              snippet.category,
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        snippet.content,
                        style: const TextStyle(fontSize: 12, color: Colors.white70),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                          onPressed: () => _copyToClipboard(snippet.content),
                          icon: const Icon(Icons.copy, size: 14, color: Colors.white),
                          label: const Text('1-Tap Copy', style: TextStyle(fontSize: 11, color: Colors.white)),
                        ),
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

  // --- TAB 4: TEXT TOOLS ---

  Widget _buildTextToolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Text Sanitizer & Transformer', Icons.build, 'Micro Utilities'),
          const SizedBox(height: 12),
          TextField(
            controller: _transformInputController,
            maxLines: 3,
            style: const TextStyle(fontSize: 13, color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter or paste raw text to sanitize or transform...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                avatar: const Icon(Icons.cleaning_services, size: 14, color: Colors.blue),
                label: const Text('Clean URL Tracking', style: TextStyle(fontSize: 11)),
                onPressed: () {
                  setState(() {
                    _transformedOutput = _cleanUrl(_transformInputController.text);
                  });
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.lock, size: 14, color: Colors.redAccent),
                label: const Text('Mask Account/Card Numbers', style: TextStyle(fontSize: 11)),
                onPressed: () {
                  setState(() {
                    _transformedOutput = _maskSensitiveText(_transformInputController.text);
                  });
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.text_fields, size: 14, color: Colors.amber),
                label: const Text('UPPERCASE', style: TextStyle(fontSize: 11)),
                onPressed: () {
                  setState(() {
                    _transformedOutput = _transformInputController.text.toUpperCase();
                  });
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.text_fields, size: 14, color: Colors.teal),
                label: const Text('lowercase', style: TextStyle(fontSize: 11)),
                onPressed: () {
                  setState(() {
                    _transformedOutput = _transformInputController.text.toLowerCase();
                  });
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.space_bar, size: 14, color: Colors.purpleAccent),
                label: const Text('Remove Extra Spaces', style: TextStyle(fontSize: 11)),
                onPressed: () {
                  setState(() {
                    _transformedOutput = _transformInputController.text.replaceAll(RegExp(r'\s+'), ' ').trim();
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_transformedOutput.isNotEmpty) ...[
            const Text('Transformed Output:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2230),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.indigoAccent.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_transformedOutput, style: const TextStyle(fontSize: 13, color: Colors.greenAccent)),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                      onPressed: () => _copyToClipboard(_transformedOutput),
                      icon: const Icon(Icons.content_copy, size: 14, color: Colors.white),
                      label: const Text('Copy Clean Text', style: TextStyle(fontSize: 11, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --- TAB 5: DOCK SETTINGS ---

  Widget _buildDockSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Floating Dock & Overlay Settings', Icons.settings, 'Permissions & Controls'),
          const SizedBox(height: 14),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Floating Overlay Assistant Widget', style: TextStyle(fontSize: 13, color: Colors.white)),
                  subtitle: const Text('Simulates "Display Over Other Apps" floating action bubble', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  value: _isFloatingOverlayEnabled,
                  activeColor: Colors.indigoAccent,
                  onChanged: (val) {
                    setState(() {
                      _isFloatingOverlayEnabled = val;
                    });
                  },
                ),
                const Divider(height: 1, color: Colors.white70),
                SwitchListTile(
                  title: const Text('System Notification Quick Dock', style: TextStyle(fontSize: 13, color: Colors.white)),
                  subtitle: const Text('Persistent notification bar for 1-tap clipboard access', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  value: _isNotificationDockActive,
                  activeColor: Colors.indigoAccent,
                  onChanged: (val) {
                    setState(() {
                      _isNotificationDockActive = val;
                    });
                  },
                ),
                const Divider(height: 1, color: Colors.white70),
                SwitchListTile(
                  title: const Text('Auto-Parse Background Listener', style: TextStyle(fontSize: 13, color: Colors.white)),
                  subtitle: const Text('Auto-detect links, phone numbers, and bank accounts when copied', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  value: _isAutoParseEnabled,
                  activeColor: Colors.indigoAccent,
                  onChanged: (val) {
                    setState(() {
                      _isAutoParseEnabled = val;
                    });
                  },
                ),
                const Divider(height: 1, color: Colors.white70),
                SwitchListTile(
                  title: const Text('Privacy Blur Mode', style: TextStyle(fontSize: 13, color: Colors.white)),
                  subtitle: const Text('Mask bank account and sensitive text snippets by default', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  value: _isPrivacyBlurEnabled,
                  activeColor: Colors.indigoAccent,
                  onChanged: (val) {
                    setState(() {
                      _isPrivacyBlurEnabled = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            color: Colors.indigo.withOpacity(0.15),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info, color: Colors.indigoAccent, size: 18),
                      SizedBox(width: 8),
                      Text('System Overlays & Permissions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'To enable true background dynamic floating bubbles on Android/iOS, grant "Display over other apps" and "Notification Listener" in system settings. ClipDock runs locally on device with zero cloud tracking.',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- INTERACTIVE FLOATING OVERLAY HUD SIMULATOR ---

  Widget _buildInteractiveFloatingHud() {
    return Positioned(
      left: _hudPosition.dx,
      top: _hudPosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _hudPosition = Offset(
              (_hudPosition.dx + details.delta.dx).clamp(0.0, MediaQuery.of(context).size.width - 70),
              (_hudPosition.dy + details.delta.dy).clamp(0.0, MediaQuery.of(context).size.height - 200),
            );
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _isHudExpanded ? 240 : 56,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2230).withOpacity(0.95),
            borderRadius: BorderRadius.circular(_isHudExpanded ? 16 : 28),
            border: Border.all(color: Colors.indigoAccent, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isHudExpanded = !_isHudExpanded;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.indigo,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.layers,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  if (_isHudExpanded) ...[
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'ClipDock HUD',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isHudExpanded = false;
                        });
                      },
                      child: const Icon(Icons.close, size: 16, color: Colors.grey),
                    ),
                  ],
                ],
              ),
              if (_isHudExpanded) ...[
                const SizedBox(height: 10),
                const Divider(height: 1, color: Colors.white70),
                const SizedBox(height: 8),
                _buildHudQuickActionButton(
                  'Last Clip: Commercial Bank',
                  Icons.content_copy,
                  Colors.indigoAccent,
                  () => _copyToClipboard('Commercial Bank Acc: 8009124561'),
                ),
                const SizedBox(height: 6),
                _buildHudQuickActionButton(
                  'Quick Bank Vault',
                  Icons.monetization_on,
                  Colors.teal,
                  () => _copyToClipboard('1092-3341-9982'),
                ),
                const SizedBox(height: 6),
                _buildHudQuickActionButton(
                  'Quick Address Pin',
                  Icons.home,
                  Colors.amber,
                  () => _copyToClipboard('Suite 404, Tech Park Tower B'),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.touch_app, size: 12, color: Colors.indigoAccent),
                      SizedBox(width: 4),
                      Text('Drag anywhere on screen', style: TextStyle(fontSize: 10, color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHudQuickActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 11, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPERS & DIALOGS ---

  Widget _buildSectionHeader(String title, IconData icon, String badgeText) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.indigoAccent),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.indigo.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            badgeText,
            style: const TextStyle(fontSize: 10, color: Colors.indigoAccent, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _showAddSnippetDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E2230),
          title: const Text('Add Quick Vault Snippet', style: TextStyle(color: Colors.white, fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _snippetTitleController,
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Snippet Title (e.g. My GST Number)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _snippetContentController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Snippet Text Content',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              onPressed: () {
                if (_snippetTitleController.text.isNotEmpty && _snippetContentController.text.isNotEmpty) {
                  setState(() {
                    _snippets.add(
                      QuickSnippet(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: _snippetTitleController.text,
                        content: _snippetContentController.text,
                        category: 'Custom',
                        icon: Icons.star,
                      ),
                    );
                  });
                  _snippetTitleController.clear();
                  _snippetContentController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Snippet', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showAddScratchNoteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E2230),
          title: const Text('Add Sticky Scratch Note', style: TextStyle(color: Colors.white, fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _scratchTitleController,
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Note Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _scratchContentController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Micro Note Content',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              onPressed: () {
                if (_scratchTitleController.text.isNotEmpty && _scratchContentController.text.isNotEmpty) {
                  setState(() {
                    _scratchNotes.add(
                      ScratchNote(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: _scratchTitleController.text,
                        content: _scratchContentController.text,
                        color: Colors.deepOrange,
                      ),
                    );
                  });
                  _scratchTitleController.clear();
                  _scratchContentController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Pin Note', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}