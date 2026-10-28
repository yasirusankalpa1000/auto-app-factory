import 'package:flutter/material.dart';

void main() {
  runApp(const DynamicBarApp());
}

class DynamicBarApp extends StatelessWidget {
  const DynamicBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DynamicBar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        cardTheme: CardTheme(
          color: const Color(0xFF1E293B),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
  int _currentTabIndex = 0;

  // Floating Overlay Dock State
  bool _isFloatingEnabled = true;
  bool _isDockExpanded = false;
  Offset _dockPosition = const Offset(20, 200);

  // Dynamic Top Banner Alert State
  String? _activeNotification;

  // Clipboard & Text Sanitizer State
  final TextEditingController _clipboardController = TextEditingController();
  String _sanitizedResult = "";
  List<String> _extractedLinks = [];
  List<String> _extractedEmails = [];

  // Sticky Shelf Notes
  final List<Map<String, String>> _stickyNotes = [
    {
      "title": "Wi-Fi Passcode",
      "content": "GuestNet_2025!#9",
      "tag": "Urgent",
      "color": "amber",
    },
    {
      "title": "Delivery Code",
      "content": "Locker #4810 - OTP: 9921",
      "tag": "Personal",
      "color": "teal",
    },
  ];

  // Micro Tools State
  double _billAmount = 45.0;
  double _tipPercentage = 15.0;
  int _splitCount = 2;

  final TextEditingController _quickTextAnalyzerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _clipboardController.text =
        "Check this out: https://example.com/product?item=99&utm_source=facebook&fbclid=XYZ123 Email contact@service.org or call +1 800 555 0199 for help!";
    _sanitizeInputText();
  }

  void _triggerDynamicAlert(String message) {
    setState(() {
      _activeNotification = message;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _activeNotification = null;
        });
      }
    });
  }

  void _sanitizeInputText() {
    final raw = _clipboardController.text;
    if (raw.isEmpty) {
      setState(() {
        _sanitizedResult = "";
        _extractedLinks.clear();
        _extractedEmails.clear();
      });
      return;
    }

    // Remove tracking query params (utm_*, fbclid, gclid)
    String cleaned = raw.replaceAll(
      RegExp(r'(\?|&)(utm_[^&]+|fbclid=[^&]+|gclid=[^&]+)'),
      '',
    );

    // Extract emails
    final emailMatches =
        RegExp(r'[\w\.-]+@[\w\.-]+\.\w+').allMatches(raw);
    List<String> emails = emailMatches.map((m) => m.group(0)!).toList();

    // Extract Links
    final linkMatches =
        RegExp(r'https?://[^\s]+').allMatches(cleaned);
    List<String> links = linkMatches.map((m) => m.group(0)!).toList();

    setState(() {
      _sanitizedResult = cleaned;
      _extractedEmails = emails;
      _extractedLinks = links;
    });
  }

  void _addNewStickyNote(String title, String content, String tag) {
    setState(() {
      _stickyNotes.insert(0, {
        "title": title.isEmpty ? "Quick Note" : title,
        "content": content,
        "tag": tag,
        "color": "indigo",
      });
    });
    _triggerDynamicAlert("New micro-note pinned to HUD shelf!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildHeaderBar(),
                Expanded(
                  child: IndexedStack(
                    index: _currentTabIndex,
                    children: [
                      _buildDockStudioTab(),
                      _buildClipboardSanitizerTab(),
                      _buildStickyShelfTab(),
                      _buildQuickToolsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Dynamic Top Banner Notification Simulation
          if (_activeNotification != null)
            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(24),
                color: Colors.indigo,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.cyan, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.notifications_active,
                        color: Colors.cyan,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _activeNotification!,
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

          // Simulated Interactive Floating Dock Bubble
          if (_isFloatingEnabled)
            Positioned(
              left: _dockPosition.dx,
              top: _dockPosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _dockPosition += details.delta;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isDockExpanded = !_isDockExpanded;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black87,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.cyan,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          _isDockExpanded
                              ? Icons.close
                              : Icons.widgets,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                    if (_isDockExpanded) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: 220,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black87,
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "HUD Quick Access",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.cyan,
                                fontSize: 13,
                              ),
                            ),
                            const Divider(color: Colors.grey),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(
                                Icons.cleaning_services,
                                color: Colors.amber,
                                size: 18,
                              ),
                              title: const Text(
                                "Sanitize Clipboard",
                                style: TextStyle(fontSize: 12),
                              ),
                              onTap: () {
                                setState(() {
                                  _currentTabIndex = 1;
                                  _isDockExpanded = false;
                                });
                                _sanitizeInputText();
                                _triggerDynamicAlert(
                                  "Clipboard sanitized automatically!",
                                );
                              },
                            ),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(
                                Icons.note_add,
                                color: Colors.teal,
                                size: 18,
                              ),
                              title: const Text(
                                "Quick Micro Note",
                                style: TextStyle(fontSize: 12),
                              ),
                              onTap: () {
                                setState(() {
                                  _currentTabIndex = 2;
                                  _isDockExpanded = false;
                                });
                              },
                            ),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(
                                Icons.calculate,
                                color: Colors.orange,
                                size: 18,
                              ),
                              title: const Text(
                                "Tip & Split Calculator",
                                style: TextStyle(fontSize: 12),
                              ),
                              onTap: () {
                                setState(() {
                                  _currentTabIndex = 3;
                                  _isDockExpanded = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF0F172A),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'HUD Dock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: 'Sanitizer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sticky_note_2),
            label: 'Sticky Shelf',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Quick Tools',
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBar() {
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
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.widgets,
              color: Colors.cyan,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "DynamicBar HUD",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "On-Screen Micro-Utility Workspace",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _isFloatingEnabled
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: _isFloatingEnabled ? Colors.cyan : Colors.grey,
            ),
            tooltip: "Toggle Floating HUD",
            onPressed: () {
              setState(() {
                _isFloatingEnabled = !_isFloatingEnabled;
              });
              _triggerDynamicAlert(
                _isFloatingEnabled
                    ? "Floating Assistive Dock Activated"
                    : "Floating Dock Hidden",
              );
            },
          ),
        ],
      ),
    );
  }

  // --- TAB 1: DOCK STUDIO & HUD OVERLAY CONTROLLER ---
  Widget _buildDockStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          "Active Assistant Status",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _isFloatingEnabled
                              ? Colors.green
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _isFloatingEnabled ? "ACTIVE" : "STANDBY",
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "DynamicBar sits softly over your daily smartphone routines. Drag the floating bubble anywhere on screen to trigger context actions without closing your active apps.",
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          _triggerDynamicAlert(
                            "DynamicBar Notification Test Triggered!",
                          );
                        },
                        icon: const Icon(Icons.notifications_active, size: 16),
                        label: const Text(
                          "Test Alert HUD",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.cyan,
                          side: const BorderSide(color: Colors.cyan),
                        ),
                        onPressed: () {
                          setState(() {
                            _dockPosition = const Offset(20, 200);
                          });
                          _triggerDynamicAlert("Dock position reset to top left.");
                        },
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text(
                          "Reset Position",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Quick Active Shelf Banners",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.cyan,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _stickyNotes.length,
            itemBuilder: (context, index) {
              final note = _stickyNotes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.push_pin, color: Colors.teal),
                  title: Text(
                    note["title"] ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: Text(
                    note["content"] ?? "",
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      note["tag"] ?? "General",
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- TAB 2: SMART CLIPBOARD SANITIZER & LINK EXTRACTOR ---
  Widget _buildClipboardSanitizerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.cleaning_services,
                          color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          "Clipboard Sanitizer & Link Stripper",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Paste messy web links or emails. DynamicBar automatically removes tracking parameters (utm_source, fbclid) and extracts data.",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _clipboardController,
                    maxLines: 4,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      hintText: "Paste text or raw link here...",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                    onChanged: (val) => _sanitizeInputText(),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          _sanitizeInputText();
                          _triggerDynamicAlert("Sanitized text updated!");
                        },
                        icon: const Icon(Icons.check, size: 16),
                        label: const Text("Clean Text", style: TextStyle(fontSize: 12)),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey,
                        ),
                        onPressed: () {
                          _clipboardController.clear();
                          _sanitizeInputText();
                        },
                        icon: const Icon(Icons.delete, size: 16),
                        label: const Text("Clear", style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Sanitized Output & Extracted Data",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.cyan,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: const Color(0xFF0F172A),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Cleaned Result",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 16, color: Colors.cyan),
                        onPressed: () {
                          _triggerDynamicAlert("Cleaned text copied to clipboard!");
                        },
                      ),
                    ],
                  ),
                  Text(
                    _sanitizedResult.isEmpty
                        ? "No output generated yet."
                        : _sanitizedResult,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  const Divider(color: Colors.grey, height: 24),
                  const Text(
                    "Extracted Links:",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                    ),
                  ),
                  if (_extractedLinks.isEmpty)
                    const Text(
                      "None found",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    )
                  else
                    ..._extractedLinks.map(
                      (link) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          link,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.lightBlueAccent,,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  const Text(
                    "Extracted Emails:",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                    ),
                  ),
                  if (_extractedEmails.isEmpty)
                    const Text(
                      "None found",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    )
                  else
                    ..._extractedEmails.map(
                      (email) => Text(
                        email,
                        style: const TextStyle(fontSize: 11, color: Colors.tealAccent),
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

  // --- TAB 3: STICKY SHELF (FLOATING MEMO BOARD) ---
  Widget _buildStickyShelfTab() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final tagController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pin Micro-Note to HUD Shelf",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "Note Title (e.g., Gate Code, Item ID)",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: contentController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: "Note Snippet / Info",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(10),
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: tagController,
                    decoration: const InputDecoration(
                      labelText: "Tag (e.g., Urgent, Work, Personal)",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (contentController.text.isNotEmpty) {
                          _addNewStickyNote(
                            titleController.text,
                            contentController.text,
                            tagController.text.isEmpty
                                ? "General"
                                : tagController.text,
                          );
                          titleController.clear();
                          contentController.clear();
                          tagController.clear();
                        }
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text(
                        "Pin to Shelf HUD",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Pinned Micro-Notes",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                ),
              ),
              Text(
                "${_stickyNotes.length} Items",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _stickyNotes.length,
            itemBuilder: (context, index) {
              final note = _stickyNotes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 40,
                        color: Colors.cyan,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    note["title"] ?? "Note",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    note["tag"] ?? "General",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.tealAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              note["content"] ?? "",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            size: 18, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _stickyNotes.removeAt(index);
                          });
                          _triggerDynamicAlert("Note removed from shelf.");
                        },
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

  // --- TAB 4: QUICK ON-SCREEN TOOLS (TIP & SPLIT & TEXT METRICS) ---
  Widget _buildQuickToolsTab() {
    double totalTip = (_billAmount * _tipPercentage) / 100;
    double totalBill = _billAmount + totalTip;
    double perPerson = totalBill / (_splitCount > 0 ? _splitCount : 1);

    int wordCount = _quickTextAnalyzerController.text.trim().isEmpty
        ? 0
        : _quickTextAnalyzerController.text.trim().split(RegExp(r'\s+')).length;
    int charCount = _quickTextAnalyzerController.text.length;
    double readTimeMinutes = wordCount / 200.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tool 1: Fast Bill Splitter
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.calculate, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Instant Tip & Bill Splitter",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text(
                        "Bill Amount: \$",
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Slider(
                          value: _billAmount,
                          min: 5.0,
                          max: 300.0,
                          divisions: 59,
                          activeColor: Colors.cyan,
                          label: "\$${_billAmount.toStringAsFixed(1)}",
                          onChanged: (val) {
                            setState(() {
                              _billAmount = val;
                            });
                          },
                        ),
                      ),
                      Text(
                        "\$${_billAmount.toStringAsFixed(1)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Tip: ",
                        style: TextStyle(fontSize: 12),
                      ),
                      Expanded(
                        child: Slider(
                          value: _tipPercentage,
                          min: 0.0,
                          max: 30.0,
                          divisions: 6,
                          activeColor: Colors.teal,
                          label: "${_tipPercentage.toInt()}%",
                          onChanged: (val) {
                            setState(() {
                              _tipPercentage = val;
                            });
                          },
                        ),
                      ),
                      Text(
                        "${_tipPercentage.toInt()}%",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Split Between: ",
                        style: TextStyle(fontSize: 12),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.grey),
                        onPressed: () {
                          if (_splitCount > 1) {
                            setState(() {
                              _splitCount--;
                            });
                          }
                        },
                      ),
                      Text(
                        "$_splitCount people",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.cyan),
                        onPressed: () {
                          setState(() {
                            _splitCount++;
                          });
                        },
                      ),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Total Bill",
                              style: TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                            Text(
                              "\$${totalBill.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              "Per Person",
                              style: TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                            Text(
                              "\$${perPerson.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.tealAccent,
                              ),
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
          const SizedBox(height: 16),

          // Tool 2: Instant Text Analyzer & Reading Time
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.analytics, color: Colors.cyan, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Speed Read & Text Analytics HUD",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _quickTextAnalyzerController,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      hintText: "Type or paste paragraph to inspect metrics...",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(10),
                    ),
                    onChanged: (v) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricChip("Words", "$wordCount"),
                      _buildMetricChip("Characters", "$charCount"),
                      _buildMetricChip(
                        "Est. Read Time",
                        "${readTimeMinutes.toStringAsFixed(1)} min",
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

  Widget _buildMetricChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.indigo.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}