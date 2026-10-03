import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ContextBubbleApp());
}

class ContextBubbleApp extends StatelessWidget {
  const ContextBubbleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Context Bubble',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FE),
      ),
      home: const MainStudioScreen(),
    );
  }
}

class MainStudioScreen extends StatefulWidget {
  const MainStudioScreen({super.key});

  @override
  State<MainStudioScreen> createState() => _MainStudioScreenState();
}

class _MainStudioScreenState extends State<MainStudioScreen> {
  int _currentIndex = 0;
  bool _isFloatingServiceActive = true;
  bool _isBubbleExpanded = false;
  
  // Draggable floating bubble coordinates
  double _bubbleX = 20.0;
  double _bubbleY = 180.0;

  // Global Clipboard / Vault state
  final List<Map<String, String>> _snippets = [
    {
      'title': 'Bank Account (LKR)',
      'content': 'Commercial Bank - 8009123456 (John Doe) - Branch: Colombo Main',
      'category': 'Finance',
    },
    {
      'title': 'Delivery Address',
      'content': 'No. 45/A, Galle Road, Bambalapitiya, Colombo 04, Sri Lanka',
      'category': 'Address',
    },
    {
      'title': 'Quick Greeting Reply',
      'content': 'Hi there! Thank you for contacting us. How can I help you today?',
      'category': 'Message',
    },
    {
      'title': 'WiFi Password',
      'content': 'GuestConnect2025!#',
      'category': 'Credentials',
    },
  ];

  void _addNewSnippet(String title, String content, String category) {
    setState(() {
      _snippets.insert(0, {
        'title': title,
        'content': content,
        'category': category,
      });
    });
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied "$label" to clipboard!'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final List<Widget> pages = [
      FloatingHubTab(
        isServiceActive: _isFloatingServiceActive,
        onToggleService: (val) {
          setState(() {
            _isFloatingServiceActive = val;
          });
        },
        snippets: _snippets,
        onQuickCopy: _copyToClipboard,
      ),
      SmartTransformerTab(
        onSaveToVault: (title, content, category) {
          _addNewSnippet(title, content, category);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Saved snippet directly to your Vault!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
      QuickVaultTab(
        snippets: _snippets,
        onCopy: _copyToClipboard,
        onDelete: (index) {
          setState(() {
            _snippets.removeAt(index);
          });
        },
        onAdd: _addNewSnippet,
      ),
      TextStudioTab(
        onCopy: _copyToClipboard,
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Main Body Tab Content
          IndexedStack(
            index: _currentIndex,
            children: pages,
          ),

          // Floating Assistant Simulator Overlay
          if (_isFloatingServiceActive) ...[
            // Floating Overlay Drawer Menu
            if (_isBubbleExpanded)
              Positioned(
                left: (_bubbleX > screenWidth / 2) ? null : _bubbleX + 60,
                right: (_bubbleX > screenWidth / 2) ? (screenWidth - _bubbleX) + 10 : null,
                top: (_bubbleY > screenHeight - 300) ? screenHeight - 320 : _bubbleY,
                child: Material(
                  elevation: 12,
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  child: Container(
                    width: 260,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.indigo.shade100, width: 1.5),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.bolt, color: Colors.amber, size: 20),
                                SizedBox(width: 6),
                                Text(
                                  'Bubble Dock',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () => setState(() => _isBubbleExpanded = false),
                              child: const Icon(Icons.close, size: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        const Text(
                          'QUICK SNIPPETS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 130,
                          child: ListView.builder(
                            itemCount: _snippets.length,
                            shrinkWrap: true,
                            itemBuilder: (context, idx) {
                              final item = _snippets[idx];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {
                                    _copyToClipboard(item['content']!, item['title']!);
                                    setState(() => _isBubbleExpanded = false);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.copy, size: 14, color: Colors.indigo),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item['title']!,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.indigo,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _isBubbleExpanded = false;
                                _currentIndex = 1; // Switch to Transformer
                              });
                            },
                            icon: const Icon(Icons.transform, size: 16),
                            label: const Text(
                              'Smart Extract Text',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Interactive Floating Bubble Icon
            Positioned(
              left: _bubbleX,
              top: _bubbleY,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubbleX += details.delta.dx;
                    _bubbleY += details.delta.dy;
                    // Clamp to screen
                    _bubbleX = _bubbleX.clamp(10.0, screenWidth - 70.0);
                    _bubbleY = _bubbleY.clamp(40.0, screenHeight - 120.0);
                  });
                },
                onTap: () {
                  setState(() {
                    _isBubbleExpanded = !_isBubbleExpanded;
                  });
                },
                child: Material(
                  elevation: 8,
                  shape: const CircleBorder(),
                  color: Colors.indigo,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.indigo, Colors.indigo.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.widgets,
                          color: Colors.white,
                          size: 26,
                        ),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '4',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: 'Floating Dock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.transform),
            label: 'Extractor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_special),
            label: 'Quick Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Text Studio',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TAB 1: FLOATING DOCK & OVERLAY CONTROLLER
// ==========================================
class FloatingHubTab extends StatelessWidget {
  final bool isServiceActive;
  final ValueChanged<bool> onToggleService;
  final List<Map<String, String>> snippets;
  final Function(String, String) onQuickCopy;

  const FloatingHubTab({
    super.key,
    required this.isServiceActive,
    required this.onToggleService,
    required this.snippets,
    required this.onQuickCopy,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade800, Colors.indigo.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withAlpha(80),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
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
                          'Context Overlay Assistant',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                        ),
                      ),
                      Switch(
                        value: isServiceActive,
                        onChanged: onToggleService,
                        activeColor: Colors.greenAccent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isServiceActive
                        ? 'Bubble is active! Drag icon on screen to test live overlay preview.'
                        : 'Floating service is currently paused. Toggle on to enable.',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Active Floating Notification Preview
            const Text(
              'Active Status Banner',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isServiceActive ? Colors.green.shade50 : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isServiceActive ? Icons.notifications_active : Icons.notifications_off,
                      color: isServiceActive ? Colors.green : Colors.grey,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isServiceActive ? 'Floating Assistant Running' : 'Service Stopped',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isServiceActive
                              ? 'Tap bubble to access quick copy shortcuts & text clean tools'
                              : 'Turn on above to re-activate floating overlay',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick Pinned Deck
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quick Floating Shortcuts',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${snippets.length} Pins',
                  style: const TextStyle(fontSize: 12, color: Colors.indigo, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snippets.length,
              itemBuilder: (context, index) {
                final item = snippets[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.star, color: Colors.indigo, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['content']!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 20, color: Colors.indigo),
                        onPressed: () => onQuickCopy(item['content']!, item['title']!),
                        tooltip: 'Copy',
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // How it works card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.amber, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Pro Tip: You can drag the blue floating bubble anywhere on your screen while using other features or apps!',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      softWrap: true,
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
}

// ==========================================
// TAB 2: SMART TRANSFORMER & DATA EXTRACTOR
// ==========================================
class SmartTransformerTab extends StatefulWidget {
  final Function(String title, String content, String category) onSaveToVault;

  const SmartTransformerTab({super.key, required this.onSaveToVault});

  @override
  State<SmartTransformerTab> createState() => _SmartTransformerTabState();
}

class _SmartTransformerTabState extends State<SmartTransformerTab> {
  final TextEditingController _inputController = TextEditingController();

  // Extracted elements
  List<String> _extractedPhones = [];
  List<String> _extractedEmails = [];
  List<String> _extractedUrls = [];
  List<String> _extractedNumbers = [];

  void _analyzeText(String text) {
    // Regular Expression detection logic
    final phoneRegExp = RegExp(r'(\+?\d{1,4}?[\s.-]?\(?\d{1,3}?\)?[\s.-]?\d{1,4}[\s.-]?\d{1,4}[\s.-]?\d{1,9})');
    final emailRegExp = RegExp(r'([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})');
    final urlRegExp = RegExp(r'(https?:\/\/[^\s]+)|(www\.[^\s]+)');
    final numberRegExp = RegExp(r'\b\d{6,16}\b'); // Account numbers / IDs

    setState(() {
      _extractedPhones = phoneRegExp.allMatches(text).map((m) => m.group(0)!).where((s) => s.length >= 7).toList();
      _extractedEmails = emailRegExp.allMatches(text).map((m) => m.group(0)!).toList();
      _extractedUrls = urlRegExp.allMatches(text).map((m) => m.group(0)!).toList();
      _extractedNumbers = numberRegExp.allMatches(text).map((m) => m.group(0)!).toList();
    });
  }

  void _loadSampleText() {
    const sample = '''
Hello! Please wire \$150 for order #88412 to Commercial Bank A/C 8009123456.
Contact support at info@service.com or call +94 77 123 4567.
Track status at https://express.courier.com/track?id=9921
''';
    _inputController.text = sample;
    _analyzeText(sample);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Smart Context Extractor',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Paste any messy message, social media post, or receipt text. The engine instantly extracts links, phones, and account details.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Input Box
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _inputController,
                    maxLines: 5,
                    onChanged: _analyzeText,
                    decoration: const InputDecoration(
                      hintText: 'Paste or type messy raw text here...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: _loadSampleText,
                          icon: const Icon(Icons.flash_on, size: 16, color: Colors.amber),
                          label: const Text('Try Sample Text', style: TextStyle(fontSize: 12)),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.content_paste, size: 20),
                              onPressed: () async {
                                final data = await Clipboard.getData('text/plain');
                                if (data?.text != null) {
                                  _inputController.text = data!.text!;
                                  _analyzeText(data.text!);
                                }
                              },
                              tooltip: 'Paste',
                            ),
                            IconButton(
                              icon: const Icon(Icons.clear, size: 20, color: Colors.grey),
                              onPressed: () {
                                _inputController.clear();
                                _analyzeText('');
                              },
                              tooltip: 'Clear',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Extracted Elements',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Phones
            _buildResultCategory(
              title: 'Phone Numbers',
              icon: Icons.phone,
              iconColor: Colors.green,
              items: _extractedPhones,
            ),

            // Emails
            _buildResultCategory(
              title: 'Email Addresses',
              icon: Icons.email,
              iconColor: Colors.blue,
              items: _extractedEmails,
            ),

            // URLs
            _buildResultCategory(
              title: 'Links & URLs',
              icon: Icons.link,
              iconColor: Colors.purple,
              items: _extractedUrls,
            ),

            // Bank / Account Numbers
            _buildResultCategory(
              title: 'Bank / ID / Account Numbers',
              icon: Icons.account_balance,
              iconColor: Colors.teal,
              items: _extractedNumbers,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCategory({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<String> items,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: Icon(icon, color: iconColor),
        title: Text(
          '$title (${items.length})',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        children: [
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'No matches detected',
                style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, idx) {
                final item = items[idx];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey.shade100)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          softWrap: true,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18, color: Colors.indigo),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: item));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Copied "$item"'), behavior: SnackBarBehavior.floating),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_to_photos, size: 18, color: Colors.teal),
                        onPressed: () {
                          widget.onSaveToVault(title, item, 'Extracted');
                        },
                        tooltip: 'Save to Quick Vault',
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// ==========================================
// TAB 3: QUICK VAULT & SNIPPET MANAGER
// ==========================================
class QuickVaultTab extends StatelessWidget {
  final List<Map<String, String>> snippets;
  final Function(String text, String title) onCopy;
  final Function(int index) onDelete;
  final Function(String title, String content, String category) onAdd;

  const QuickVaultTab({
    super.key,
    required this.snippets,
    required this.onCopy,
    required this.onDelete,
    required this.onAdd,
  });

  void _showAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String category = 'General';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add Quick Snippet'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Snippet Title',
                    hintText: 'e.g. My Bank Account',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Content to Copy',
                    hintText: 'e.g. 1234-5678-9012',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
              onPressed: () {
                if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                  onAdd(titleController.text, contentController.text, category);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Save Snippet'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Snippet Vault',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Instant 1-tap copyable cards for daily routine text',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _showAddDialog(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snippets.length,
              itemBuilder: (context, idx) {
                final item = snippets[idx];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(8),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item['category'] ?? 'General',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.copy, color: Colors.indigo, size: 20),
                                onPressed: () => onCopy(item['content']!, item['title']!),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                onPressed: () => onDelete(idx),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['title']!,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SelectableText(
                        item['content']!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// TAB 4: TEXT CLEANUP & FORMATTING STUDIO
// ==========================================
class TextStudioTab extends StatefulWidget {
  final Function(String text, String label) onCopy;

  const TextStudioTab({super.key, required this.onCopy});

  @override
  State<TextStudioTab> createState() => _TextStudioTabState();
}

class _TextStudioTabState extends State<TextStudioTab> {
  final TextEditingController _studioController = TextEditingController();

  void _formatUPPERCASE() {
    setState(() {
      _studioController.text = _studioController.text.toUpperCase();
    });
  }

  void _formatLowercase() {
    setState(() {
      _studioController.text = _studioController.text.toLowerCase();
    });
  }

  void _formatCleanSpaces() {
    setState(() {
      _studioController.text = _studioController.text.replaceAll(RegExp(r'\s+'), ' ').trim();
    });
  }

  void _formatBulletPoints() {
    setState(() {
      final lines = _studioController.text.split('\n');
      final bulleted = lines.where((l) => l.trim().isNotEmpty).map((l) => '• ${l.trim()}').join('\n');
      _studioController.text = bulleted;
    });
  }

  void _formatRemoveEmojis() {
    setState(() {
      final emojiRegExp = RegExp(
          r'[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{1F780}-\u{1F7FF}\u{1F800}-\u{1F8FF}\u{1F900}-\u{1F9FF}\u{1FA00}-\u{1FA6F}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]',
          unicode: true);
      _studioController.text = _studioController.text.replaceAll(emojiRegExp, '');
    });
  }

  void _formatTitleCase() {
    setState(() {
      final text = _studioController.text;
      _studioController.text = text.split(' ').map((word) {
        if (word.isEmpty) return '';
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join(' ');
    });
  }

  int get _wordCount {
    final text = _studioController.text.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).length;
  }

  int get _charCount => _studioController.text.length;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Text Clean & Format Studio',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Instantly fix spacing, remove emojis, convert case, and turn text into bullet lists with 1-tap.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Statistics Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('Words', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text('$_wordCount', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
                    ],
                  ),
                  Container(height: 24, width: 1, color: Colors.indigo.shade200),
                  Column(
                    children: [
                      const Text('Characters', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text('$_charCount', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Main Text Editor
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _studioController,
                    maxLines: 6,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Type or paste text to reformat...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => widget.onCopy(_studioController.text, 'Formatted Text'),
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('Copy Formatted Text'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              '1-Tap Format Actions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Action Buttons Wrap
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildActionButton(
                  label: 'UPPERCASE',
                  icon: Icons.text_fields,
                  onTap: _formatUPPERCASE,
                ),
                _buildActionButton(
                  label: 'lowercase',
                  icon: Icons.text_format,
                  onTap: _formatLowercase,
                ),
                _buildActionButton(
                  label: 'Title Case',
                  icon: Icons.format_size,
                  onTap: _formatTitleCase,
                ),
                _buildActionButton(
                  label: 'Clean Spaces',
                  icon: Icons.cleaning_services,
                  onTap: _formatCleanSpaces,
                ),
                _buildActionButton(
                  label: 'Make Bullet List',
                  icon: Icons.format_list_bulleted,
                  onTap: _formatBulletPoints,
                ),
                _buildActionButton(
                  label: 'Strip Emojis',
                  icon: Icons.no_photography_outlined,
                  onTap: _formatRemoveEmojis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.indigo),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}