import 'package:flutter/material.dart';

void main() {
  runApp(const ClipPulseApp());
}

class ClipPulseApp extends StatelessWidget {
  const ClipPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClipPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
          surface: const Color(0xFF12181F),
        ),
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E2630),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const ClipPulseMainScreen(),
    );
  }
}

class SnippetItem {
  final String id;
  final String title;
  final String content;
  final String category;
  int copyCount;
  bool isPinned;

  SnippetItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.copyCount = 0,
    this.isPinned = false,
  });
}

class ClipPulseMainScreen extends StatefulWidget {
  const ClipPulseMainScreen({super.key});

  @override
  State<ClipPulseMainScreen> createState() => _ClipPulseMainScreenState();
}

class _ClipPulseMainScreenState extends State<ClipPulseMainScreen> {
  int _selectedTabIndex = 0;

  // Floating Overlay Pill State
  bool _isOverlayActive = true;
  bool _isMiniDrawerOpen = false;
  Offset _overlayPosition = const Offset(20, 120);

  // Floating Notification Banner
  String? _toastMessage;

  // Text Workbench Controllers
  final TextEditingController _workbenchController = TextEditingController(
    text: "Hey! Can you send me \$45 for lunch, \$15 for taxi, and \$20 for coffee? My phone is +1-555-019-2834 and email is alex.dev@example.com. Check this link: https://example.com/pay",
  );

  // Extractor Input Controller
  final TextEditingController _extractorController = TextEditingController(
    text: "Meeting notes: Contact Sarah at sarah.m@work.org or call +1 800 555 0199. Payment invoice #4021 total is \$120.50 plus extra fee \$15.25. Portal: https://service.portal.io/invoice",
  );

  // Template Form Fields
  final TextEditingController _templateNameController = TextEditingController(text: "Alex Jay");
  final TextEditingController _templateBankController = TextEditingController(text: "Global Bank (Acc: 9876-5432-10)");
  final TextEditingController _templateAmountController = TextEditingController(text: "150.00");

  // Snippets Memory Storage
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: '1',
      title: 'Primary Bank Details',
      content: 'Bank: Apex City Bank | Acc: 4091-2283-9910 | IFSC: APCB00012',
      category: 'Finance',
      copyCount: 14,
      isPinned: true,
    ),
    SnippetItem(
      id: '2',
      title: 'Home Address Format',
      content: '742 Evergreen Terrace, Sector 4, Springfield, OR 97477',
      category: 'Address',
      copyCount: 8,
      isPinned: true,
    ),
    SnippetItem(
      id: '3',
      title: 'Quick Reschedule Reply',
      content: 'Hi! I am currently in a meeting. Will get back to you in 30 minutes. Thanks!',
      category: 'Replies',
      copyCount: 22,
      isPinned: false,
    ),
  ];

  String _snippetFilter = 'All';

  void _showFloatingToast(String msg) {
    setState(() {
      _toastMessage = msg;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          if (_toastMessage == msg) {
            _toastMessage = null;
          }
        });
      }
    });
  }

  // Text Manipulations
  void _cleanSpaces() {
    String text = _workbenchController.text;
    text = text.replaceAll(RegExp(r'[ \t]+'), ' ');
    text = text.replaceAll(RegExp(r'\n\s*\n'), '\n\n');
    _workbenchController.text = text.trim();
    _showFloatingToast('Cleaned extra spaces & line breaks!');
  }

  void _maskSensitiveData() {
    String text = _workbenchController.text;
    // Mask emails
    text = text.replaceAllMapped(
      RegExp(r'([a-zA-Z0-9._%+-]+)@([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})'),
      (match) => '${match.group(1)![0]}***@${match.group(2)}',
    );
    // Mask phone numbers
    text = text.replaceAll(RegExp(r'\+?\d[\d\s-]{7,}\d'), '[PHONE MASKED]');
    _workbenchController.text = text;
    _showFloatingToast('Privacy Shield: Masked sensitive data!');
  }

  void _formatWhatsAppStyle() {
    String text = _workbenchController.text;
    List<String> lines = text.split('\n');
    List<String> formatted = lines.map((l) => l.trim().isNotEmpty ? '* $l' : '').toList();
    _workbenchController.text = formatted.join('\n');
    _showFloatingToast('Formatted into WhatsApp bullet list!');
  }

  double _calculateTextMath(String text) {
    RegExp numRegex = RegExp(r'\$?\b\d+(\.\d{1,2})?\b');
    Iterable<Match> matches = numRegex.matches(text);
    double sum = 0.0;
    for (var m in matches) {
      String cleanStr = m.group(0)!.replaceAll('\$', '');
      sum += double.tryParse(cleanStr) ?? 0.0;
    }
    return sum;
  }

  void _copyToClipboard(String text, String label) {
    // Simulated clipboard copy with interactive alert
    _showFloatingToast('Copied "$label" to clipboard!');
  }

  @override
  void dispose() {
    _workbenchController.dispose();
    _extractorController.dispose();
    _templateNameController.dispose();
    _templateBankController.dispose();
    _templateAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeaderBar(),
                Expanded(
                  child: _buildBodyTab(),
                ),
              ],
            ),

            // Floating Toast Notification Simulation
            if (_toastMessage != null)
              Positioned(
                top: 16,
                left: 20,
                right: 20,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.teal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.flash_on, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _toastMessage!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Simulated Draggable Floating Overlay Pill
            if (_isOverlayActive)
              Positioned(
                left: _overlayPosition.dx,
                top: _overlayPosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      double newX = _overlayPosition.dx + details.delta.dx;
                      double newY = _overlayPosition.dy + details.delta.dy;
                      // Clamp to screen bounds
                      newX = newX.clamp(10.0, screenSize.width - 70.0);
                      newY = newY.clamp(10.0, screenSize.height - 120.0);
                      _overlayPosition = Offset(newX, newY);
                    });
                  },
                  onTap: () {
                    setState(() {
                      _isMiniDrawerOpen = !_isMiniDrawerOpen;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _isMiniDrawerOpen ? Colors.teal : Colors.indigo,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black87,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                      border: Border.all(color: Colors.white70, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.widgets,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "ClipPulse",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "${_snippets.length}",
                            style: const TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

            // Floating Mini Micro-Workbench Drawer (Opened from Pill)
            if (_isOverlayActive && _isMiniDrawerOpen)
              Positioned(
                left: (_overlayPosition.dx > screenSize.width / 2) ? null : 20,
                right: (_overlayPosition.dx > screenSize.width / 2) ? 20 : null,
                top: (_overlayPosition.dy + 50).clamp(60.0, screenSize.height - 250.0),
                child: Material(
                  elevation: 12,
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFF252E3A),
                  child: Container(
                    width: 280,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.teal.shade300, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Quick Overlay Assist",
                              style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            InkWell(
                              onTap: () => setState(() => _isMiniDrawerOpen = false),
                              child: const Icon(Icons.clear, color: Colors.grey, size: 18),
                            )
                          ],
                        ),
                        const Divider(color: Colors.white70, height: 16),
                        const Text(
                          "Active Text Quick Tools:",
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAxisAlignment.center,
                          children: [
                            ActionChip(
                              avatar: const Icon(Icons.auto_fix_high, size: 14, color: Colors.amber),
                              label: const Text("Clean Text", style: TextStyle(fontSize: 11, color: Colors.white)),
                              backgroundColor: const Color(0xFF1A222D),
                              onPressed: () {
                                _cleanSpaces();
                                setState(() => _isMiniDrawerOpen = false);
                              },
                            ),
                            ActionChip(
                              avatar: const Icon(Icons.security, size: 14, color: Colors.teal),
                              label: const Text("Mask Privacy", style: TextStyle(fontSize: 11, color: Colors.white)),
                              backgroundColor: const Color(0xFF1A222D),
                              onPressed: () {
                                _maskSensitiveData();
                                setState(() => _isMiniDrawerOpen = false);
                              },
                            ),
                            ActionChip(
                              avatar: const Icon(Icons.calculate, size: 14, color: Colors.lightBlue),
                              label: const Text("Sum Text \$", style: TextStyle(fontSize: 11, color: Colors.white)),
                              backgroundColor: const Color(0xFF1A222D),
                              onPressed: () {
                                double sum = _calculateTextMath(_workbenchController.text);
                                _showFloatingToast("Calculated Total: \$${sum.toStringAsFixed(2)}");
                                setState(() => _isMiniDrawerOpen = false);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Top Pinned Snippet:",
                                style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _snippets.first.content,
                                style: const TextStyle(color: Colors.white, fontSize: 11),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(50, 20),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    _copyToClipboard(_snippets.first.content, _snippets.first.title);
                                    setState(() => _isMiniDrawerOpen = false);
                                  },
                                  child: const Text("Copy Snippet", style: TextStyle(fontSize: 11, color: Colors.teal)),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        backgroundColor: const Color(0xFF12181F),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Transformer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_alt),
            label: 'Extractor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Vault Stack',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_button),
            label: 'Templates',
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF12181F),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.flash_on, color: Colors.teal, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "ClipPulse Assist",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Smart Contextual Screen & Text Utility",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: "Toggle Overlay Pill",
            icon: Icon(
              _isOverlayActive ? Icons.visibility : Icons.visibility_off,
              color: _isOverlayActive ? Colors.teal : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isOverlayActive = !_isOverlayActive;
              });
              _showFloatingToast(
                _isOverlayActive ? "Floating Screen Overlay Pill Enabled!" : "Overlay Pill Hidden",
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildBodyTab() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildTransformerTab();
      case 1:
        return _buildExtractorTab();
      case 2:
        return _buildVaultTab();
      case 3:
        return _buildTemplatesTab();
      default:
        return _buildTransformerTab();
    }
  }

  // TAB 1: Text Transformer & Math Engine
  Widget _buildTransformerTab() {
    double calculatedSum = _calculateTextMath(_workbenchController.text);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  "Text Workbench",
                  style: TextStyle(color: Colors.white, fontSize: 16, FontWeight: FontWeight.bold),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: () {
                  _copyToClipboard(_workbenchController.text, "Cleaned Workbench Text");
                },
                icon: const Icon(Icons.content_copy, size: 16),
                label: const Text("Copy All", style: TextStyle(fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 12),

          // Main Text Area
          TextField(
            controller: _workbenchController,
            maxLines: 5,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: "Paste text containing numbers, messy spaces, emails or phones...",
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
              filled: true,
              fillColor: const Color(0xFF1E2630),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white70),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.teal),
              ),
            ),
            onChanged: (val) => setState(() {}),
          ),
          const SizedBox(height: 14),

          // Inline Math Total Live Card
          Card(
            color: const Color(0xFF16222F),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.calculate, color: Colors.amber, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Inline Text Number Sum",
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                        Text(
                          "\$${calculatedSum.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.amber),
                    ),
                    onPressed: () {
                      _workbenchController.text = "${_workbenchController.text}\n\nTotal Sum: \$${calculatedSum.toStringAsFixed(2)}";
                      _showFloatingToast("Appended calculated total to text!");
                    },
                    child: const Text("Append Total", style: TextStyle(color: Colors.amber, fontSize: 11)),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            "Instant Single-Tap Tools",
            style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          // Tools Grid / Wrap
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              _buildToolButton(
                icon: Icons.cleaning_services,
                label: "Clean Spaces",
                color: Colors.teal,
                onTap: _cleanSpaces,
              ),
              _buildToolButton(
                icon: Icons.security,
                label: "Mask Phone/Email",
                color: Colors.deepOrange,
                onTap: _maskSensitiveData,
              ),
              _buildToolButton(
                icon: Icons.format_list_bulleted,
                label: "WhatsApp Bullets",
                color: Colors.green,
                onTap: _formatWhatsAppStyle,
              ),
              _buildToolButton(
                icon: Icons.text_fields,
                label: "UPPERCASE",
                color: Colors.blue,
                onTap: () {
                  _workbenchController.text = _workbenchController.text.toUpperCase();
                  _showFloatingToast("Converted text to UPPERCASE");
                },
              ),
              _buildToolButton(
                icon: Icons.text_format,
                label: "lowercase",
                color: Colors.purple,
                onTap: () {
                  _workbenchController.text = _workbenchController.text.toLowerCase();
                  _showFloatingToast("Converted text to lowercase");
                },
              ),
              _buildToolButton(
                icon: Icons.clear_all,
                label: "Clear Text",
                color: Colors.grey,
                onTap: () {
                  _workbenchController.clear();
                  _showFloatingToast("Workbench cleared");
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Active Overlay Guide Card
          Card(
            color: const Color(0xFF1E2630),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.teal, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Floating Screen Pill Active!",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Drag the floating pill anywhere on screen. Tap it while using other features to trigger instant text operations.",
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                          softWrap: true,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          border: Border.all(color: color.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: Smart Extractor
  Widget _buildExtractorTab() {
    String raw = _extractorController.text;

    // Regex Extractions
    Iterable<Match> emailMatches = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}').allMatches(raw);
    List<String> emails = emailMatches.map((m) => m.group(0)!).toSet().toList();

    Iterable<Match> phoneMatches = RegExp(r'\+?\d[\d\s-]{8,}\d').allMatches(raw);
    List<String> phones = phoneMatches.map((m) => m.group(0)!).toSet().toList();

    Iterable<Match> urlMatches = RegExp(r'https?://[^\s]+').allMatches(raw);
    List<String> urls = urlMatches.map((m) => m.group(0)!).toSet().toList();

    double extractedSum = _calculateTextMath(raw);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Smart Information Extractor",
            style: TextStyle(color: Colors.white, fontSize: 16, FontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Paste any wall of text to extract emails, phone numbers, URLs & prices automatically.",
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _extractorController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            decoration: InputDecoration(
              hintText: "Dump unstructured text here...",
              filled: true,
              fillColor: const Color(0xFF1E2630),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white70),
              ),
            ),
            onChanged: (val) => setState(() {}),
          ),
          const SizedBox(height: 16),

          // Extracted Price Total Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.monetization_on, color: Colors.teal, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Extracted Price Sum:",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
                Text(
                  "\$${extractedSum.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.teal, fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Extracted Categories
          _buildExtractorCategorySection(
            title: "Emails Found (${emails.length})",
            icon: Icons.email,
            color: Colors.blue,
            items: emails,
          ),
          const SizedBox(height: 12),

          _buildExtractorCategorySection(
            title: "Phone Numbers Found (${phones.length})",
            icon: Icons.phone,
            color: Colors.green,
            items: phones,
          ),
          const SizedBox(height: 12),

          _buildExtractorCategorySection(
            title: "URLs & Links Found (${urls.length})",
            icon: Icons.link,
            color: Colors.amber,
            items: urls,
          ),
        ],
      ),
    );
  }

  Widget _buildExtractorCategorySection({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> items,
  }) {
    return Card(
      color: const Color(0xFF1A222D),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const Text(
                "None detected in current text.",
                style: TextStyle(color: Colors.grey, fontSize: 11, fontStyle: FontStyle.italic),
              )
            else
              Column(
                children: items.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF12181F),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.copy, color: Colors.teal, size: 16),
                          onPressed: () => _copyToClipboard(item, item),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  // TAB 3: Snippet Stack Vault
  Widget _buildVaultTab() {
    List<SnippetItem> filtered = _snippets.where((s) {
      if (_snippetFilter == 'All') return true;
      return s.category == _snippetFilter;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  "Clipboard Vault Stack",
                  style: TextStyle(color: Colors.white, fontSize: 16, FontWeight: FontWeight.bold),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.teal, size: 26),
                onPressed: _showAddSnippetDialog,
              )
            ],
          ),
          const SizedBox(height: 8),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Finance', 'Address', 'Replies'].map((cat) {
                final isSelected = _snippetFilter == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(cat, style: TextStyle(fontSize: 11, color: isSelected ? Colors.black : Colors.white)),
                    selected: isSelected,
                    selectedColor: Colors.teal,
                    backgroundColor: const Color(0xFF1E2630),
                    onSelected: (val) {
                      setState(() {
                        _snippetFilter = cat;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      "No snippets in this category.",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        if (item.isPinned)
                                          const Padding(
                                            padding: EdgeInsets.only(right: 6),
                                            child: Icon(Icons.push_pin, color: Colors.amber, size: 14),
                                          ),
                                        Expanded(
                                          child: Text(
                                            item.title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      item.category,
                                      style: const TextStyle(color: Colors.teal, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.content,
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Used ${item.copyCount} times",
                                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        constraints: const BoxConstraints(),
                                        padding: const EdgeInsets.all(4),
                                        icon: Icon(
                                          item.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                                          color: item.isPinned ? Colors.amber : Colors.grey,
                                          size: 18,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            item.isPinned = !item.isPinned;
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.teal,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          minimumSize: const Size(60, 28),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            item.copyCount++;
                                          });
                                          _copyToClipboard(item.content, item.title);
                                        },
                                        icon: const Icon(Icons.copy, size: 12),
                                        label: const Text("Copy", style: TextStyle(fontSize: 11)),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }

  void _showAddSnippetDialog() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    String category = 'Finance';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E2630),
              title: const Text("Add Snippet to Vault", style: TextStyle(color: Colors.white, fontSize: 15)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleCtrl,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      decoration: const InputDecoration(
                        labelText: "Snippet Title",
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: contentCtrl,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      decoration: const InputDecoration(
                        labelText: "Content Text",
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: category,
                      dropdownColor: const Color(0xFF1E2630),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      decoration: const InputDecoration(
                        labelText: "Category",
                        border: OutlineInputBorder(),
                      ),
                      items: ['Finance', 'Address', 'Replies', 'General']
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => category = val);
                        }
                      },
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () {
                    if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                      setState(() {
                        _snippets.add(
                          SnippetItem(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            title: titleCtrl.text,
                            content: contentCtrl.text,
                            category: category,
                            isPinned: false,
                          ),
                        );
                      });
                      _showFloatingToast("Added new snippet to Vault!");
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text("Save Snippet", style: TextStyle(color: Colors.white)),
                )
              ],
            );
          },
        );
      },
    );
  }

  // TAB 4: Smart Response Templates
  Widget _buildTemplatesTab() {
    String generatedBankMessage =
        "Hi! Please transfer \$${_templateAmountController.text} to my account.\n\nAccount Details:\nHolder: ${_templateNameController.text}\nBank Info: ${_templateBankController.text}\n\nThank you!";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Smart Dynamic Templates",
            style: TextStyle(color: Colors.white, fontSize: 16, FontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Quickly build formatted payment requests, meeting updates, or local chat templates.",
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 14),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Payment Request Generator",
                        style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _templateNameController,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: const InputDecoration(
                      labelText: "Your Full Name",
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => setState(() {}),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _templateBankController,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: const InputDecoration(
                      labelText: "Bank Account Details",
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => setState(() {}),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _templateAmountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: const InputDecoration(
                      labelText: "Amount Required (\$)",
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => setState(() {}),
                  ),
                  const SizedBox(height: 14),

                  const Text(
                    "Live Generated Text Preview:",
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  const SizedBox(height: 6),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF12181F),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white70),
                    ),
                    child: Text(
                      generatedBankMessage,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        _copyToClipboard(generatedBankMessage, "Payment Request Template");
                      },
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text("Copy Formatted Request"),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}