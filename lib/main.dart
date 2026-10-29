import 'package:flutter/material.dart';

void main() {
  runApp(const BubbleStackApp());
}

class BubbleStackApp extends StatefulWidget {
  const BubbleStackApp({Key? key}) : super(key: key);

  @override
  State<BubbleStackApp> createState() => _BubbleStackAppState();
}

class _BubbleStackAppState extends State<BubbleStackApp> {
  bool _isDarkMode = true;

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'BubbleStack',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF12151E),
        useMaterial3: true,
      ),
      home: MainScreen(
        isDarkMode: _isDarkMode,
        onToggleTheme: () {
          setState(() {
            _isDarkMode = !_isDarkMode;
          });
        },
      ),
    );
  }
}

class SnippetItem {
  String id;
  String trigger;
  String fullContent;
  String category;

  SnippetItem({
    required this.id,
    required this.trigger,
    required this.fullContent,
    required this.category,
  });
}

class MainScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const MainScreen({
    Key? key,
    required this.isDarkMode,
    required this.onToggleTheme,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedTabIndex = 0;

  // Global Interactive Floating Bubble State
  bool _overlayEnabled = true;
  bool _floatingMenuOpen = false;
  Offset _bubblePosition = const Offset(20.0, 180.0);

  // Text Workbench States
  final TextEditingController _rawTextController = TextEditingController(
    text: "Hey! Check out this product link https://store.example.com/item?id=8823&utm_source=facebook&fbclid=IwAR29384931! Send payment of \$45.50 and \$12.99 to account. Call 555-0192 or email support@service.org for details.",
  );

  String _cleanedText = "";
  List<String> _extractedPhones = [];
  List<String> _extractedEmails = [];
  List<double> _extractedPrices = [];
  double _totalSum = 0.0;

  // Quick Snippets
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: "1",
      trigger: "!addr",
      fullContent: "742 Evergreen Terrace, Springfield, OR 97477",
      category: "Personal",
    ),
    SnippetItem(
      id: "2",
      trigger: "!bank",
      fullContent: "Global Bank - Account: 4920-1129-8831 | Swift: GBLUS33",
      category: "Finance",
    ),
    SnippetItem(
      id: "3",
      trigger: "!meet",
      fullContent: "Let's catch up via Google Meet: https://meet.google.com/xyz-abc-def",
      category: "Work",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _processInputText();
  }

  void _processInputText() {
    final text = _rawTextController.text;

    // 1. Scrub URLs
    String cleaned = text.replaceAll(RegExp(r'(\?|&)(utm_[^&]+|fbclid=[^&]+|igshid=[^&]+)'), '');

    // 2. Extract Phone numbers (simple matcher)
    final phoneRegExp = RegExp(r'\b\d{3}[-.\s]?\d{3}[-.\s]?\d{4}\b');
    final phones = phoneRegExp.allMatches(text).map((m) => m.group(0)!).toList();

    // 3. Extract Emails
    final emailRegExp = RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
    final emails = emailRegExp.allMatches(text).map((m) => m.group(0)!).toList();

    // 4. Extract Prices with $
    final priceRegExp = RegExp(r'\$\s*(\d+(\.\d{1,2})?)');
    final matches = priceRegExp.allMatches(text);
    List<double> prices = [];
    double sum = 0.0;
    for (var match in matches) {
      final valStr = match.group(1);
      if (valStr != null) {
        final val = double.tryParse(valStr) ?? 0.0;
        prices.add(val);
        sum += val;
      }
    }

    setState(() {
      _cleanedText = cleaned;
      _extractedPhones = phones;
      _extractedEmails = emails;
      _extractedPrices = prices;
      _totalSum = sum;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                _buildTopTabBar(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedTabIndex,
                    children: [
                      _buildOverlayStudioTab(),
                      _buildTextScrubberTab(),
                      _buildSnippetsTab(),
                      _buildContextToolsTab(),
                    ],
                  ),
                ),
              ],
            ),

            // Simulated Floating Draggable Overlay Bubble
            if (_overlayEnabled) _buildDraggableFloatingBubble(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? const Color(0xFF1B1F2D) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Icon(Icons.layers, color: Colors.indigo, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "BubbleStack",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Context Helper & Floating Overlay",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _overlayEnabled ? Icons.motion_photos_on : Icons.motion_photos_off,
              color: _overlayEnabled ? Colors.green : Colors.grey,
            ),
            tooltip: "Toggle Floating Dock",
            onPressed: () {
              setState(() {
                _overlayEnabled = !_overlayEnabled;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _overlayEnabled ? "Floating Dock Overlay Activated!" : "Floating Overlay Disabled",
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: Colors.orangeAccent,
            ),
            tooltip: "Toggle Theme",
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
    );
  }

  Widget _buildTopTabBar() {
    final tabs = [
      {"icon": Icons.widgets, "label": "Dock Studio"},
      {"icon": Icons.cleaning_services, "label": "Scrub & Extract"},
      {"icon": Icons.bolt, "label": "Snippets"},
      {"icon": Icons.tune, "label": "Context Tools"},
    ];

    return Container(
      color: widget.isDarkMode ? const Color(0xFF161925) : const Color(0xFFEFEFF4),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = _selectedTabIndex == index;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                showCheckmark: false,
                avatar: Icon(
                  tabs[index]["icon"] as IconData,
                  size: 18,
                  color: isSelected ? Colors.white : Colors.indigo,
                ),
                label: Text(
                  tabs[index]["label"] as String,
                  style: TextStyle(
                    color: isSelected ? Colors.white : (widget.isDarkMode ? Colors.white70 : Colors.black87),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                selectedColor: Colors.indigo,
                backgroundColor: widget.isDarkMode ? const Color(0xFF222738) : Colors.white,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  }
                },
              ),
            );
          }),
        ),
      ),
    );
  }

  // TAB 1: Floating Overlay Studio & Permissions Simulation
  Widget _buildOverlayStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.display_settings, color: Colors.indigo),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Display Above Apps System",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "BubbleStack sits on top of your screen as a persistent launcher bubble. Clean URLs, paste snippets, or extract phone numbers without leaving WhatsApp, Instagram, or Chrome.",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Switch(
                          value: _overlayEnabled,
                          activeColor: Colors.indigo,
                          onChanged: (val) {
                            setState(() {
                              _overlayEnabled = val;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _overlayEnabled ? "Overlay Active" : "Overlay Disabled",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const Text(
                                "Drag the floating bubble anywhere on screen!",
                                style: TextStyle(fontSize: 11, color: Colors.grey),
                              ),
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
          const SizedBox(height: 16),
          const Text(
            "Quick Dock Settings & Shortcuts",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildFeatureToggleTile(
            title: "Smart Notification Status Bar Helper",
            subtitle: "Keep dynamic clipboard listener in notification tray",
            icon: Icons.notifications_active,
            value: true,
          ),
          _buildFeatureToggleTile(
            title: "Auto URL Scrubbing on Copy",
            subtitle: "Automatically clean tracking tags when copying links",
            icon: Icons.cleaning_services,
            value: true,
          ),
          _buildFeatureToggleTile(
            title: "Instant Price Summation",
            subtitle: "Detect money values in unstructured copied text",
            icon: Icons.calculate,
            value: true,
          ),
          _buildFeatureToggleTile(
            title: "Haptic Overlay Vibration",
            subtitle: "Vibrate when expanding floating bubble dock",
            icon: Icons.vibration,
            value: false,
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.indigo,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.bolt, color: Colors.amber, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Pro Tip for Daily Use",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Tap and hold the floating bubble to quickly perform a live scrub on whatever text is currently in your clipboard!",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
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

  Widget _buildFeatureToggleTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        trailing: Switch(
          value: value,
          activeColor: Colors.indigo,
          onChanged: (v) {},
        ),
      ),
    );
  }

  // TAB 2: Text & Link Scrubbing Workbench
  Widget _buildTextScrubberTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Unstructured Text Studio",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.cleaning_services, size: 16),
                label: const Text("Run Scrub"),
                onPressed: () {
                  _processInputText();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Text Scrubbed & Parsed Successfully!"),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _rawTextController,
            maxLines: 4,
            onChanged: (_) => _processInputText(),
            decoration: InputDecoration(
              labelText: "Paste Messy Text / Links Here",
              alignLabelWithHint: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () {
                  _rawTextController.clear();
                  _processInputText();
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Cleaned Output Section
          _buildSectionHeader("Sanitized Text & Clean Links", Icons.check_circle_outline),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.isDarkMode ? const Color(0xFF1E2333) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.indigo.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  _cleanedText.isEmpty ? "No text provided" : _cleanedText,
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.copy, size: 16, color: Colors.indigo),
                    label: const Text("Copy Sanitized Text", style: TextStyle(color: Colors.indigo, fontSize: 12)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Sanitized text copied to clipboard!")),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Extracted Key Information
          _buildSectionHeader("Extracted Data & Financial Totals", Icons.analytics),
          const SizedBox(height: 10),

          // Price Calculation Card
          Card(
            color: Colors.teal.withOpacity(0.12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.monetization_on, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Detected Money Values",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          _extractedPrices.isEmpty
                              ? "No prices found"
                              : _extractedPrices.map((p) => "\$${p.toStringAsFixed(2)}").join(" + "),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("Calculated Total", style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text(
                        "\$${_totalSum.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Phone Numbers & Emails Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._extractedPhones.map((phone) => Chip(
                    avatar: const Icon(Icons.phone, size: 14, color: Colors.blue),
                    label: Text(phone, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.blue.withOpacity(0.1),
                  )),
              ..._extractedEmails.map((email) => Chip(
                    avatar: const Icon(Icons.email, size: 14, color: Colors.purple),
                    label: Text(email, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.purple.withOpacity(0.1),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.indigo),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // TAB 3: Auto-Expander & Quick Snippets
  Widget _buildSnippetsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Quick Snippets Studio",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Assign shorthand triggers for quick floating copy",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.indigo, size: 30),
                tooltip: "Add Snippet",
                onPressed: _showAddSnippetDialog,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _snippets.length,
              itemBuilder: (context, index) {
                final snippet = _snippets[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        snippet.trigger,
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    title: Text(
                      snippet.fullContent,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        "Category: ${snippet.category}",
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18, color: Colors.teal),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Copied '${snippet.trigger}' snippet!"),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                          onPressed: () {
                            setState(() {
                              _snippets.removeAt(index);
                            });
                          },
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

  void _showAddSnippetDialog() {
    final triggerController = TextEditingController();
    final contentController = TextEditingController();
    String category = "General";

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text("Add Quick Snippet"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: triggerController,
              decoration: const InputDecoration(
                labelText: "Trigger (e.g. !myemail)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Full Expanded Content",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            onPressed: () {
              if (triggerController.text.isNotEmpty && contentController.text.isNotEmpty) {
                setState(() {
                  _snippets.add(
                    SnippetItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      trigger: triggerController.text,
                      fullContent: contentController.text,
                      category: category,
                    ),
                  );
                });
                Navigator.pop(dialogCtx);
              }
            },
            child: const Text("Save Snippet", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // TAB 4: Context Tools & Privacy Sanitizer
  Widget _buildContextToolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Privacy & Text Formatting Tools",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildToolCard(
                title: "Mask Confidential",
                subtitle: "Hide emails & sensitive info",
                icon: Icons.privacy_tip,
                color: Colors.deepOrange,
                onTap: () {
                  setState(() {
                    _rawTextController.text = _rawTextController.text.replaceAll(
                      RegExp(r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}'),
                      "***@hidden.com",
                    );
                    _processInputText();
                  });
                },
              ),
              _buildToolCard(
                title: "UPPERCASE",
                subtitle: "Convert text to capitals",
                icon: Icons.text_fields,
                color: Colors.blue,
                onTap: () {
                  setState(() {
                    _rawTextController.text = _rawTextController.text.toUpperCase();
                    _processInputText();
                  });
                },
              ),
              _buildToolCard(
                title: "Strip Whitespace",
                subtitle: "Clean extra double lines",
                icon: Icons.format_line_spacing,
                color: Colors.teal,
                onTap: () {
                  setState(() {
                    _rawTextController.text = _rawTextController.text.replaceAll(RegExp(r'\s+'), ' ');
                    _processInputText();
                  });
                },
              ),
              _buildToolCard(
                title: "Text Analytics",
                subtitle: "Count words, chars & reading time",
                icon: Icons.analytics,
                color: Colors.purple,
                onTap: _showAnalyticsDialog,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: widget.isDarkMode ? Colors.white : Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showAnalyticsDialog() {
    final text = _rawTextController.text;
    final words = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
    final chars = text.length;
    final readTimeSec = (words / 3.5).ceil();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Text Analytics"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Word Count: $words words"),
            const SizedBox(height: 6),
            Text("Character Count: $chars characters"),
            const SizedBox(height: 6),
            Text("Est. Reading Time: ~$readTimeSec seconds"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  // Interactive Draggable Floating Bubble Simulator
  Widget _buildDraggableFloatingBubble() {
    return Positioned(
      left: _bubblePosition.dx,
      top: _bubblePosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubblePosition += details.delta;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _floatingMenuOpen = !_floatingMenuOpen;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.layers,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
            if (_floatingMenuOpen) ...[
              const SizedBox(height: 8),
              Container(
                width: 200,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.isDarkMode ? const Color(0xFF1F2436) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
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
                        const Text(
                          "Floating Quick Dock",
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        InkWell(
                          onTap: () => setState(() => _floatingMenuOpen = false),
                          child: const Icon(Icons.close, size: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    const Divider(),
                    _buildOverlayActionItem(
                      icon: Icons.cleaning_services,
                      label: "Instant Scrub Link",
                      color: Colors.teal,
                      onTap: () {
                        _processInputText();
                        setState(() => _floatingMenuOpen = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Link scrubbed via Floating Dock!")),
                        );
                      },
                    ),
                    _buildOverlayActionItem(
                      icon: Icons.bolt,
                      label: "Paste Shorthand",
                      color: Colors.amber,
                      onTap: () {
                        setState(() => _floatingMenuOpen = false);
                        if (_snippets.isNotEmpty) {
                          _rawTextController.text += " ${_snippets.first.fullContent}";
                          _processInputText();
                        }
                      },
                    ),
                    _buildOverlayActionItem(
                      icon: Icons.calculate,
                      label: "Calc Text Prices",
                      color: Colors.green,
                      onTap: () {
                        setState(() => _floatingMenuOpen = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Detected total: \$${_totalSum.toStringAsFixed(2)}")),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOverlayActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}