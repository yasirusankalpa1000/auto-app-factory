import 'package:flutter/material.dart';

void main() {
  runApp(const FloatDeckApp());
}

class FloatDeckApp extends StatelessWidget {
  const FloatDeckApp({super.key});

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'FloatDeck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: const MainDeckScreen(),
    );
  }
}

class MainDeckScreen extends StatefulWidget {
  const MainDeckScreen({super.key});

  @override
  State<MainDeckScreen> createState() => _MainDeckScreenState();
}

class _MainDeckScreenState extends State<MainDeckScreen> {
  int _selectedTabIndex = 0;
  
  // Floating Widget Overlay State
  bool _overlayEnabled = true;
  Offset _bubblePosition = const Offset(20, 200);
  bool _isMenuExpanded = false;

  // Pulse & Dynamic Notification Banner State
  String _activeNotificationText = "FloatDeck dynamic companion active in background";
  bool _notificationActive = true;

  // Shared Data Vault
  final List<Map<String, String>> _clipboardVault = [
    {"title": "Home Address", "content": "124 Grand View Avenue, Suite 4B, New York, NY", "category": "Address"},
    {"title": "Bank Account Details", "content": "Routing: 021000021 | Acc: 9876543210 (USD)", "category": "Finance"},
    {"title": "WiFi Access Code", "content": "Guest_Pass_2025!#Secure", "category": "Quick Info"},
    {"title": "Standard Tagline", "content": "Building viral micro-apps for everyday productivity!", "category": "Work"},
  ];

  void _addClipboardSnippet(String title, String content, String category) {
    setState(() {
      _clipboardVault.insert(0, {
        "title": title,
        "content": content,
        "category": category,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main App Content Body
            Column(
              children: [
                // Top Custom Header HUD
                _buildTopHUDHeader(),

                // Active Tab Screen Body
                Expanded(
                  child: _selectedTabIndex == 0
                      ? ImpulseAnalyzerTab(onSaveSnippet: _addClipboardSnippet)
                      : _selectedTabIndex == 1
                          ? ToneTransformerTab(onSaveSnippet: _addClipboardSnippet)
                          : _selectedTabIndex == 2
                              ? ClipboardVaultTab(snippets: _clipboardVault, onAdd: _addClipboardSnippet)
                              : FloatingSettingsTab(
                                  overlayEnabled: _overlayEnabled,
                                  notificationActive: _notificationActive,
                                  activeNotificationText: _activeNotificationText,
                                  onToggleOverlay: (val) {
                                    setState(() => _overlayEnabled = val);
                                  },
                                  onToggleNotification: (val) {
                                    setState(() => _notificationActive = val);
                                  },
                                  onUpdateNotificationText: (txt) {
                                    setState(() => _activeNotificationText = txt);
                                  },
                                ),
                ),
              ],
            ),

            // Sticky Persistent Notification Simulator (Top Toast)
            if (_notificationActive)
              Positioned(
                top: 70,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.indigo[900],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_active, color: Colors.amber, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _activeNotificationText,
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        InkWell(
                          onTap: () => setState(() => _notificationActive = false),
                          child: const Icon(Icons.close, color: Colors.white70, size: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Simulated Floating Bubble Overlay HUD Menu
            if (_overlayEnabled)
              Positioned(
                left: _bubblePosition.dx,
                top: _bubblePosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      double newX = _bubblePosition.dx + details.delta.dx;
                      double newY = _bubblePosition.dy + details.delta.dy;
                      
                      // Keep within boundaries
                      newX = newX.clamp(0.0, screenSize.width - 60);
                      newY = newY.clamp(0.0, screenSize.height - 120);

                      _bubblePosition = Offset(newX, newY);
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (_isMenuExpanded) _buildExpandedFloatingMenu(),
                      const SizedBox(height: 6),
                      FloatingActionButton.small(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            _isMenuExpanded = !_isMenuExpanded;
                          });
                        },
                        child: Icon(_isMenuExpanded ? Icons.close : Icons.layers),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) => setState(() => _selectedTabIndex = index),
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarColorItem(
            icon: Icon(Icons.monetization_on),
            label: "Impulse Check",
          ),
          BottomNavigationBarColorItem(
            icon: Icon(Icons.chat),
            label: "Tone Switch",
          ),
          BottomNavigationBarColorItem(
            icon: Icon(Icons.content_copy),
            label: "Pin Vault",
          ),
          BottomNavigationBarColorItem(
            icon: Icon(Icons.widgets),
            label: "HUD Overlay",
          ),
        ],
      ),
    );
  }

  Widget _buildTopHUDHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.layers, color: Colors.indigo),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "FloatDeck HUD",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  _overlayEnabled ? "Floating Companion Active" : "Overlay Standard Mode",
                  style: TextStyle(
                    fontSize: 12,
                    color: _overlayEnabled ? Colors.green[700] : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _overlayEnabled ? Colors.green[100] : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 4,
                  backgroundColor: _overlayEnabled ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  _overlayEnabled ? "OVERLAY ON" : "OFF",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _overlayEnabled ? Colors.green[900] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedFloatingMenu() {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: Colors.indigo.shade100),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Quick Floating HUD",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.indigo),
          ),
          const Divider(height: 12),
          _buildMenuQuickAction(Icons.monetization_on, "Impulse Check", () {
            setState(() {
              _selectedTabIndex = 0;
              _isMenuExpanded = false;
            });
          }),
          _buildMenuQuickAction(Icons.chat, "Tone Transformer", () {
            setState(() {
              _selectedTabIndex = 1;
              _isMenuExpanded = false;
            });
          }),
          _buildMenuQuickAction(Icons.content_copy, "Quick Snippets", () {
            setState(() {
              _selectedTabIndex = 2;
              _isMenuExpanded = false;
            });
          }),
          _buildMenuQuickAction(Icons.notifications_active, "Trigger Sticky Notification", () {
            setState(() {
              _notificationActive = true;
              _activeNotificationText = "HUD Active: 1-Tap Copy & Quick Calc Ready!";
              _isMenuExpanded = false;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildMenuQuickAction(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.indigo[700]),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// BottomNavigationBarItem helper for crisp typing
class BottomNavigationBarColorItem extends BottomNavigationBarItem {
  const BottomNavigationBarColorItem({
    required Widget icon,
    required String label,
  }) : super(icon: icon, label: label);
}

// TAB 1: IMPULSE PURCHASE & WORK-HOUR REALITY CHECKER
class ImpulseAnalyzerTab extends StatefulWidget {
  final Function(String title, String content, String category) onSaveSnippet;

  const ImpulseAnalyzerTab({super.key, required me, required this.onSaveSnippet});

  @override
  State<ImpulseAnalyzerTab> meState() => _ImpulseAnalyzerTabState();

  @override
  State<ImpulseAnalyzerTab> createState() => _ImpulseAnalyzerTabState();
}

class _ImpulseAnalyzerTabState extends State<ImpulseAnalyzerTab> {
  final TextEditingController _itemController = TextEditingController(text: "Wireless Headphones");
  final TextEditingController _priceController = TextEditingController(text: "120");
  final TextEditingController _hourlyRateController = TextEditingController(text: "15");

  double _regretScore = 0.65; // 0.0 to 1.0

  @override
  Widget build(BuildContext context) {
    double itemPrice = double.tryParse(_priceController.text) ?? 0.0;
    double hourlyWage = double.tryParse(_hourlyRateController.text) ?? 1.0;
    if (hourlyWage <= 0) hourlyWage = 1.0;

    double requiredWorkHours = itemPrice / hourlyWage;
    double workingDays = requiredWorkHours / 8.0;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(
              "Impulse Buy Reality Check",
              "Before tapping 'Buy Now' in shopping apps, test how many actual life hours this purchase costs!",
              Icons.monetization_on,
              Colors.amber[800]!,
            ),
            const SizedBox(height: 16),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _itemController,
                      decoration: const InputDecoration(
                        labelText: "Item Name / Product Title",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.shopping_bag),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              labelText: "Price (\$) ",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.attach_money),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _hourlyRateController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              labelText: "Your Hourly Earn (\$) ",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.work),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Reality Calculation Result Card
            Card(
              elevation: 3,
              color: Colors.indigo[900],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      "LIFE COST BREAKDOWN",
                      style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 12),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "${requiredWorkHours.toStringAsFixed(1)} Work Hours",
                        style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Equivalent to ~${workingDays.toStringAsFixed(1)} full 8-hour work days",
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const Divider(color: Colors.white70, height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMiniStatCard("Price", "\$${itemPrice.toStringAsFixed(2)}"),
                        _buildMiniStatCard("Opportunity", "\$${(itemPrice * 1.08).toStringAsFixed(2)} / yr"),
                        _buildMiniStatCard("Regret Risk", "${(_regretScore * 100).toInt()}%"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Regret Index & Decision Helper
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Regret Risk Gauge",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          _regretScore > 0.7
                              ? "High Risk Buy!"
                              : _regretScore > 0.4
                                  ? "Moderate Consideration"
                                  : "Safe Purchase",
                          style: TextStyle(
                            color: _regretScore > 0.7
                                ? Colors.red
                                : _regretScore > 0.4
                                    ? Colors.orange[800]
                                    : Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _regretScore,
                      backgroundColor: Colors.grey[200],
                      color: _regretScore > 0.7
                          ? Colors.red
                          : _regretScore > 0.4
                              ? Colors.orange
                              : Colors.green,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Impulse Rule: Wait 24 hours before buying '${_itemController.text.isEmpty ? "this item" : _itemController.text}'. If you still feel it brings genuine daily value, complete the purchase.",
                      style: TextStyle(fontSize: 12, color: Colors.grey[700], height: 1.3),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          final title = "Impulse Check: ${_itemController.text}";
                          final content = "Cost: \$${itemPrice.toStringAsFixed(2)} = ${requiredWorkHours.toStringAsFixed(1)} work hrs (~${workingDays.toStringAsFixed(1)} days)";
                          widget.onSaveSnippet(title, content, "Shopping");

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Reality calculation pinned to Pin Vault!")),
                          );
                        },
                        icon: const Icon(Icons.bookmark_add),
                        label: const Text("Pin Calculation to Float Vault"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStatCard(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}

// TAB 2: SMART MESSAGE TONE TRANSFORMER
class ToneTransformerTab extends StatefulWidget {
  final Function(String title, String content, String category) onSaveSnippet;

  const ToneTransformerTab({super.key, required this.onSaveSnippet});

  @override
  State<ToneTransformerTab> createState() => _ToneTransformerTabState();
}

class _ToneTransformerTabState extends State<ToneTransformerTab> {
  final TextEditingController _draftController = TextEditingController(
    text: "i need this document done by today do not delay it again",
  );

  String _executiveTone = "";
  String _politeTone = "";
  String _friendlyTone = "";

  @override
  void initState() {
    super.initState();
    _transformText();
  }

  void _transformText() {
    final raw = _draftController.text.trim();
    if (raw.isEmpty) {
      _executiveTone = "Please enter raw message text above.";
      _politeTone = "Please enter raw message text above.";
      _friendlyTone = "Please enter raw message text above.";
      return;
    }

    setState(() {
      _executiveTone = "Hi team, please prioritize finalizing this document by end-of-day today. Let me know if any blockers arise. Thank you!";
      _politeTone = "Hello! Whenever you get a chance today, could you please review and finish this document? I would truly appreciate your help.";
      _friendlyTone = "Hey there! Hope your day is going well. Just checking in on this document—let me know if you can complete it today! Thanks a bunch!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(
              "Instant Tone Transformer",
              "Paste any fast draft, voice note, or direct reply—instantly refine it into executive, polite, or friendly tones before sending!",
              Icons.chat,
              Colors.teal,
            ),
            const SizedBox(height: 16),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Raw Draft Message",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _draftController,
                      maxLines: 3,
                      onChanged: (_) => _transformText(),
                      decoration: const InputDecoration(
                        hintText: "Type or paste quick messy message draft...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Polished Variants (1-Tap Copy)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),

            _buildToneCard("Executive / Professional", _executiveTone, Colors.indigo, Icons.business_center),
            const SizedBox(height: 10),
            _buildToneCard("Polite & Courteous", _politeTone, Colors.teal, Icons.favorite),
            const SizedBox(height: 10),
            _buildToneCard("Friendly & Casual", _friendlyTone, Colors.orange[800]!, Icons.emoji_emotions),
          ],
        ),
      ),
    );
  }

  Widget _buildToneCard(String title, String text, Color accentColor, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: accentColor.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: accentColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, color: accentColor, fontSize: 13),
                  ),
                ),
                InkWell(
                  onTap: () {
                    widget.onSaveSnippet("Tone: $title", text, "Tone Copy");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("$title tone copied & saved to Pin Vault!")),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.content_copy, size: 12, color: accentColor),
                        const SizedBox(width: 4),
                        Text(
                          "Copy & Pin",
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: accentColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: const TextStyle(fontSize: 13, height: 1.35, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

// TAB 3: SMART CLIPBOARD & PIN VAULT
class ClipboardVaultTab extends StatefulWidget {
  final List<Map<String, String>> snippets;
  final Function(String title, String content, String category) onAdd;

  const ClipboardVaultTab({super.key, required this.snippets, required this.onAdd});

  @override
  State<ClipboardVaultTab> createState() => _ClipboardVaultTabState();
}

class _ClipboardVaultTabState extends State<ClipboardVaultTab> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _contentCtrl = TextEditingController();
  String _selectedCat = "Work";

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("New Pin Snippet"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: "Snippet Title", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contentCtrl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Snippet Content / Text", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCat,
                items: ["Work", "Address", "Finance", "Quick Info", "Shopping"]
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCat = val);
                },
                decoration: const InputDecoration(labelText: "Category", border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (_titleCtrl.text.isNotEmpty && _contentCtrl.text.isNotEmpty) {
                widget.onAdd(_titleCtrl.text.trim(), _contentCtrl.text.trim(), _selectedCat);
                _titleCtrl.clear();
                _contentCtrl.clear();
                Navigator.pop(ctx);
              }
            },
            child: const Text("Pin Snippet"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Pin Vault & Floating Clips", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 2),
                      Text("Keep frequent addresses, bank info & templates accessible anytime.", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _showAddDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("Add"),
                ),
              ],
            ),
          ),
          Expanded(
            child: widget.snippets.isEmpty
                ? const Center(child: Text("No snippets saved in vault."))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: widget.snippets.length,
                    itemBuilder: (ctx, idx) {
                      final item = widget.snippets[idx];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo[50],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      item["category"] ?? "General",
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.indigo[800]),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item["title"] ?? "",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.content_copy, size: 18, color: Colors.indigo),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Copied '${item["title"]}' to clipboard!")),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              SelectableText(
                                item["content"] ?? "",
                                style: TextStyle(fontSize: 13, color: Colors.grey[800]),
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
}

// TAB 4: FLOATING HUD & NOTIFICATION PERMISSION SETTINGS
class FloatingSettingsTab extends StatelessWidget {
  final bool overlayEnabled;
  final bool notificationActive;
  final String activeNotificationText;
  final Function(bool) onToggleOverlay;
  final Function(bool) onToggleNotification;
  final Function(String) onUpdateNotificationText;

  const FloatingSettingsTab({
    super.key,
    required this.overlayEnabled,
    required this.notificationActive,
    required this.activeNotificationText,
    required this.onToggleOverlay,
    required this.onToggleNotification,
    required this.onUpdateNotificationText,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(
              "FloatDeck Companion Control",
              "Manage persistent overlay permissions, floating HUD shortcuts, and sticky background notification bars.",
              Icons.widgets,
              Colors.indigo,
            ),
            const SizedBox(height: 16),

            // Floating Overlay Switch
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: SwitchListTile(
                title: const Text("Enable Floating HUD Bubble", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text("Simulates system display-over-apps bubble overlay for instant 1-tap micro tools.", style: TextStyle(fontSize: 12)),
                value: overlayEnabled,
                activeColor: Colors.indigo,
                onChanged: onToggleOverlay,
              ),
            ),
            const SizedBox(height: 10),

            // Persistent Notification Switch
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: SwitchListTile(
                title: const Text("Sticky Notification Banner Bar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text("Keep FloatDeck quick launcher pinned in your phone notification drawer.", style: TextStyle(fontSize: 12)),
                value: notificationActive,
                activeColor: Colors.indigo,
                onChanged: onToggleNotification,
              ),
            ),

            const SizedBox(height: 16),

            // Custom Notification Text Setup
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Active Notification Drawer Text", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter banner text...",
                      ),
                      controller: TextEditingController(text: activeNotificationText),
                      onSubmitted: onUpdateNotificationText,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Press Enter to update sticky status notification bar above.",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Quick Info & Virality Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo[50],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.stars, color: Colors.indigo, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Daily Usage & Retention", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.indigo)),
                        SizedBox(height: 2),
                        Text(
                          "FloatDeck keeps users engaged continuously while shopping, typing messages, and managing notes across all daily smartphone activities.",
                          style: TextStyle(fontSize: 11, color: Colors.black87),
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
    );
  }
}

// UI Shared Helper Card Header
Widget _buildCardHeader(String title, String subtitle, IconData icon, Color iconColor) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 11, color: Colors.grey[700], height: 1.25),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}