import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OverlayXApp());
}

class OverlayXApp extends StatelessWidget {
  const OverlayXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlayX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E293B),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const OverlayHomeScreen(),
    );
  }
}

class OverlayHomeScreen extends StatefulWidget {
  const OverlayHomeScreen({super.key});

  @override
  State<OverlayHomeScreen> createState() => _OverlayHomeScreenState();
}

class _OverlayHomeScreenState extends State<OverlayHomeScreen> {
  int _selectedTabIndex = 0;

  // Floating HUD State
  bool _showPrivacyTint = false;
  double _privacyOpacity = 0.35;
  bool _showGridOverlay = false;
  bool _showFloatingBubble = true;
  String _floatingBubbleText = "⚡ Quick Note: Order #9021";
  Offset _bubblePosition = const Offset(20, 120);

  // Active Floating Notification Simulation
  String? _activeNotificationTitle;
  String? _activeNotificationMessage;

  // Multi-Clipboard Vault State
  String _selectedCategory = "All";
  final List<String> _categories = [
    "All",
    "Banking",
    "Addresses",
    "Quick Replies",
    "Links"
  ];

  final List<Map<String, dynamic>> _clipboardItems = [
    {
      "id": "1",
      "title": "Bank Account Details",
      "content": "ACC: 8820-1102-4491 | IFSC: GLBL000182",
      "category": "Banking",
      "isPinned": true,
    },
    {
      "id": "2",
      "title": "Home Delivery Address",
      "content": "Building 4B, Apt 302, West Park Avenue, Sector 5",
      "category": "Addresses",
      "isPinned": true,
    },
    {
      "id": "3",
      "title": "Meeting Availability Reply",
      "content":
          "Hi! I am available today between 2:00 PM and 5:00 PM. Let me know what works best for you.",
      "category": "Quick Replies",
      "isPinned": false,
    },
    {
      "id": "4",
      "title": "Portfolio Web Link",
      "content": "https://myportfolio.example.com/project-showcase",
      "category": "Links",
      "isPinned": false,
    },
  ];

  // Micro-Decision Engine State
  final List<String> _decisionOptions = [
    "Healthy Salad",
    "Gourmet Burger",
    "Sushi Bowl",
    "Pasta Primavera"
  ];
  String? _decisionWinner;
  final TextEditingController _decisionInputController =
      TextEditingController();

  // Impulse Buy Evaluator State
  double _itemPrice = 49.99;
  double _hourlyWage = 15.0;

  @override
  void dispose() {
    _decisionInputController.dispose();
    super.dispose();
  }

  void _triggerFloatingNotification(String title, String message) {
    setState(() {
      _activeNotificationTitle = title;
      _activeNotificationMessage = message;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Floating Alert Triggered: $title"),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  void _copyToClipboard(String content) {
    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text("Copied to clipboard!"),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addNewClip(String title, String content, String category) {
    setState(() {
      _clipboardItems.insert(0, {
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
        "title": title.isEmpty ? "Saved Snippet" : title,
        "content": content,
        "category": category,
        "isPinned": false,
      });
    });
  }

  void _runDecisionDuel() {
    if (_decisionOptions.isEmpty) return;
    final list = List<String>.from(_decisionOptions)..shuffle();
    setState(() {
      _decisionWinner = list.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedTabIndex,
                    children: [
                      _buildFloatingHUDTab(),
                      _buildClipboardVaultTab(),
                      _buildMicroDecisionTab(),
                      _buildAlertsBuilderTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Optional Screen Privacy Overlay Tint Simulator
          if (_showPrivacyTint)
            IgnorePointer(
              ignoring: true,
              child: Container(
                color: Colors.black.withOpacity(_privacyOpacity),
              ),
            ),

          // Optional Screen Alignment Grid Simulator
          if (_showGridOverlay)
            IgnorePointer(
              ignoring: true,
              child: CustomPaint(
                size: Size.infinite,
                painter: AlignmentGridPainter(),
              ),
            ),

          // Floating Draggable Quick Sticky Note Simulator
          if (_showFloatingBubble)
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubblePosition += details.delta;
                  });
                },
                child: Material(
                  elevation: 8,
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    constraints: const BoxConstraints(maxWidth: 220),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(2, 4),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.drag_indicator,
                            color: Colors.black87, size: 18),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _floatingBubbleText,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _showFloatingBubble = false;
                            });
                          },
                          child: const Icon(Icons.close,
                              color: Colors.black87, size: 16),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Active Top Dynamic Floating Notification Pill
          if (_activeNotificationTitle != null)
            Positioned(
              top: 45,
              left: 16,
              right: 16,
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(24),
                color: const Color(0xFF1E293B),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.indigoAccent, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.indigo,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.bolt,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _activeNotificationTitle!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _activeNotificationMessage!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.grey, size: 18),
                        onPressed: () {
                          setState(() {
                            _activeNotificationTitle = null;
                            _activeNotificationMessage = null;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0F172A),
        selectedItemColor: Colors.indigoAccent,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Floating HUD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy),
            label: 'Clip Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Decision Duel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alerts Hub',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(
          bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.widgets, color: Colors.indigoAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "OverlayX",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Everyday Floating Assistant & Clip Vault",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.grey),
            onPressed: _showAppInfoDialog,
          ),
        ],
      ),
    );
  }

  // ---------------- TAB 1: FLOATING HUD CONTROLS ----------------
  Widget _buildFloatingHUDTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Floating Screen Controls", Icons.touch_app),
          const SizedBox(height: 12),

          // Floating Sticky Note Toggle Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.push_pin, color: Colors.amber),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Draggable Floating Sticky Note",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              "On-screen sticky note stays active above apps",
                              style:
                                  TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _showFloatingBubble,
                        activeColor: Colors.indigoAccent,
                        onChanged: (val) {
                          setState(() {
                            _showFloatingBubble = val;
                          });
                        },
                      ),
                    ],
                  ),
                  if (_showFloatingBubble) ...[
                    const Divider(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: "Enter quick sticky text...",
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            style: const TextStyle(fontSize: 12),
                            onChanged: (val) {
                              setState(() {
                                _floatingBubbleText = val.isEmpty
                                    ? "⚡ Quick Floating Note"
                                    : val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ]
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Privacy Overlay Tint Control
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.visibility_off,
                          color: Colors.tealAccent),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Screen Privacy Tint Overlay",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              "Dims screen context when reading in public",
                              style:
                                  TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _showPrivacyTint,
                        activeColor: Colors.teal,
                        onChanged: (val) {
                          setState(() {
                            _showPrivacyTint = val;
                          });
                        },
                      ),
                    ],
                  ),
                  if (_showPrivacyTint) ...[
                    const SizedBox(height: 8),
                    Text(
                      "Tint Darkness Level: ${(_privacyOpacity * 100).toInt()}%",
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    Slider(
                      value: _privacyOpacity,
                      min: 0.1,
                      max: 0.8,
                      activeColor: Colors.teal,
                      onChanged: (val) {
                        setState(() {
                          _privacyOpacity = val;
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Screen Grid Overlay Simulator
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.grid_on, color: Colors.lightBlueAccent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Visual Alignment Grid Overlay",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          "Helpful for UI design checks, photography & text lining",
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _showGridOverlay,
                    activeColor: Colors.lightBlueAccent,
                    onChanged: (val) {
                      setState(() {
                        _showGridOverlay = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          _buildSectionHeader("Quick Action Docks", Icons.flash_on),
          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              _buildActionButton(
                "Copy Home Address",
                Icons.home,
                Colors.orange,
                () => _copyToClipboard(
                    "Building 4B, Apt 302, West Park Avenue, Sector 5"),
              ),
              _buildActionButton(
                "Copy Bank Details",
                Icons.account_balance,
                Colors.green,
                () => _copyToClipboard("ACC: 8820-1102-4491 | IFSC: GLBL000182"),
              ),
              _buildActionButton(
                "Trigger Water Alert",
                Icons.water_drop,
                Colors.blue,
                () => _triggerFloatingNotification(
                    "Hydration Reminder", "Time to drink 250ml of water!"),
              ),
              _buildActionButton(
                "Trigger Code Snippet Alert",
                Icons.code,
                Colors.purple,
                () => _triggerFloatingNotification(
                    "Quick OTP Code", "Your authorization code is: 981204"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- TAB 2: MULTI-CLIPBOARD VAULT ----------------
  Widget _buildClipboardVaultTab() {
    final filteredItems = _selectedCategory == "All"
        ? _clipboardItems
        : _clipboardItems
            .where((item) => item['category'] == _selectedCategory)
            .toList();

    return Column(
      children: [
        // Category Chips Row
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: const Color(0xFF0F172A),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: Colors.indigo,
                    backgroundColor: const Color(0xFF1E293B),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontSize: 12,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Clip Vault List
        Expanded(
          child: filteredItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.assignment_outlined,
                          size: 48, color: Colors.grey),
                      SizedBox(height: 12),
                      Text("No snippets in this category",
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.indigo.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item['category'],
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.indigoAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item['title'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    item['isPinned']
                                        ? Icons.push_pin
                                        : Icons.push_pin_outlined,
                                    color: item['isPinned']
                                        ? Colors.amber
                                        : Colors.grey,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      item['isPinned'] = !item['isPinned'];
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item['content'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                  fontFamily: 'monospace',
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.cleaning_services,
                                      size: 14),
                                  label: const TextStyle(fontSize: 11) == null
                                      ? const Text("Format")
                                      : const Text("Format Text",
                                          style: TextStyle(fontSize: 11)),
                                  onPressed: () =>
                                      _showFormatTextDialog(item['content']),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                  ),
                                  icon: const Icon(Icons.copy, size: 14),
                                  label: const Text("Copy Clip",
                                      style: TextStyle(fontSize: 11)),
                                  onPressed: () =>
                                      _copyToClipboard(item['content']),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),

        // FAB to add new snippet
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigoAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Save New Clipboard Snippet",
                style:
                    TextStyle(color: Colors.white, FontWeight: FontWeight.bold),
              ),
              onPressed: _showAddClipDialog,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- TAB 3: MICRO-DECISION DUEL ENGINE ----------------
  Widget _buildMicroDecisionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              "Daily Micro-Decision Duel Engine", Icons.psychology),
          const SizedBox(height: 8),
          const Text(
            "Eliminate daily decision paralysis (what to eat, which task to start, buy vs wait).",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Choice Battle Wheel Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Quick Choice Battle",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _decisionInputController,
                          decoration: const InputDecoration(
                            hintText: "Add option (e.g. Tacos)",
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.indigo,
                        ),
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          if (_decisionInputController.text.trim().isNotEmpty) {
                            setState(() {
                              _decisionOptions.add(
                                  _decisionInputController.text.trim());
                              _decisionInputController.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAxisAlignment.center,
                    children: _decisionOptions.map((opt) {
                      return Chip(
                        label: Text(opt, style: const TextStyle(fontSize: 11)),
                        backgroundColor: const Color(0xFF0F172A),
                        deleteIcon:
                            const Icon(Icons.close, size: 14, color: Colors.redAccent),
                        onDeleted: () {
                          setState(() {
                            _decisionOptions.remove(opt);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  if (_decisionWinner != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "🎯 WINNING CHOICE SELECTED:",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),