import 'package:flutter/material.dart';

void main() {
  runApp(const BubbleLensApp());
}

class BubbleLensApp extends StatelessWidget {
  const BubbleLensApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BubbleLens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.teal,
          secondary: Colors.tealAccent,
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentTab = 0;
  bool _isFloatingWidgetActive = true;
  bool _hasNotificationPermission = true;
  
  // Floating bubble simulated position
  Offset _bubbleOffset = const Offset(20, 180);

  // Active Context Snippet Data
  String _activeText = "Check out this product for \$49.99 on sale! Contact seller at support@shop.com or call +1 800 555 0199. #deal #shopping";
  String _detectedCategory = "Price & Deal";
  double _parsedPrice = 49.99;
  double _discountRate = 15.0;
  
  // History & Vault Data
  final List<Map<String, String>> _clipHistory = [
    {
      "text": "Check out this product for \$49.99 on sale! Contact seller at support@shop.com",
      "type": "Deal & Contact",
      "time": "Just now"
    },
    {
      "text": "https://flutter.dev - Build apps for any screen",
      "type": "Web Link",
      "time": "12 mins ago"
    },
    {
      "text": "Delivery Address: 742 Evergreen Terrace, Sector 7G",
      "type": "Address",
      "time": "1 hour ago"
    },
  ];

  final List<Map<String, String>> _vaultCards = [
    {
      "title": "Home Delivery Address",
      "content": "No. 45, Park Avenue, West District, NY 10001",
      "tag": "Address"
    },
    {
      "title": "Instagram Hashtag Pack",
      "content": "#TechTrends #SmartTools #ProductivityHack #MobileApp #Flutter",
      "tag": "Social"
    },
    {
      "title": "Quick Professional Bio",
      "content": "Creative App Developer & Digital Product Creator. Building high-impact utilities.",
      "tag": "Bio"
    },
    {
      "title": "Work WiFi Password",
      "content": "WIFI-Guest-Pass: SafeKey#2025!",
      "tag": "Credential"
    },
  ];

  int _speedChallengeScore = 0;

  void _analyzeText(String text) {
    setState(() {
      _activeText = text;
      if (text.contains('\$') || text.toLowerCase().contains('rs') || text.toLowerCase().contains('off')) {
        _detectedCategory = "Price & Deal";
        // Extract basic dollar value
        RegExp regExp = RegExp(r'\$(\d+(\.\d+)?)');
        Match? match = regExp.firstMatch(text);
        if (match != null) {
          _parsedPrice = double.tryParse(match.group(1) ?? "49.99") ?? 49.99;
        } else {
          _parsedPrice = 49.99;
        }
      } else if (text.contains('http://') || text.contains('https://') || text.contains('www.')) {
        _detectedCategory = "Web Link";
      } else if (text.contains('@') || text.contains('+') || text.contains('phone')) {
        _detectedCategory = "Contact & Email";
      } else {
        _detectedCategory = "General Snippet";
      }
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeaderBar(),
                _buildPermissionStatusBanner(),
                Expanded(
                  child: IndexedStack(
                    index: _currentTab,
                    children: [
                      _buildSmartStudioTab(),
                      _buildVaultTab(),
                      _buildFloatingWidgetSettingsTab(),
                      _buildDwellGameTab(),
                    ],
                  ),
                ),
              ],
            ),
            if (_isFloatingWidgetActive) _buildDraggableFloatingBubble(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (index) => setState(() => _currentTab = index),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1E293B),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: "Smart Studio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_special),
            label: "Vault",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: "Floating Hub",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt),
            label: "Speed Lab",
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
        border: Border(bottom: BorderSide(color: Colors.white70)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.center_focus_strong, color: Colors.tealAccent),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "BubbleLens",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Context & Clipboard Assistant",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _isFloatingWidgetActive ? Icons.visibility : Icons.visibility_off,
                  color: _isFloatingWidgetActive ? Colors.tealAccent : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isFloatingWidgetActive = !_isFloatingWidgetActive;
                  });
                  _showSnackBar(
                    _isFloatingWidgetActive
                        ? "Floating Bubble Overlay Activated!"
                        : "Floating Bubble Overlay Hidden",
                  );
                },
                tooltip: "Toggle Floating Widget",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionStatusBanner() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.teal.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: Colors.tealAccent, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Display Above Apps & Floating Notifications: Active",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  softWrap: true,
                ),
                Text(
                  "BubbleLens is monitoring context to offer quick tools instantly.",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                  softWrap: true,
                ),
              ],
            ),
          ),
          Switch(
            value: _hasNotificationPermission,
            activeColor: Colors.tealAccent,
            onChanged: (val) {
              setState(() {
                _hasNotificationPermission = val;
              });
            },
          ),
        ],
      ),
    );
  }

  // --- TAB 1: SMART STUDIO ---
  Widget _buildSmartStudioTab() {
    double finalPrice = _parsedPrice * (1 - (_discountRate / 100));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Active Text Context Analyzer",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.loyalty, size: 14, color: Colors.tealAccent),
                      label: Text(
                        _detectedCategory,
                        style: const TextStyle(fontSize: 11, color: Colors.white),
                      ),
                      backgroundColor: Colors.teal.withOpacity(0.2),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        _showSnackBar("Copied active text to clipboard!");
                      },
                      icon: const Icon(Icons.copy, size: 16, color: Colors.tealAccent),
                      label: const Text("Copy", style: TextStyle(color: Colors.tealAccent)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _activeText,
                  style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.4),
                  softWrap: true,
                ),
                const Divider(height: 24, color: Colors.white70),
                const Text(
                  "Quick Paste Input Tester:",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                TextField(
                  onChanged: (val) => _analyzeText(val),
                  decoration: InputDecoration(
                    hintText: "Paste text, web links, or prices here to test...",
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (_detectedCategory == "Price & Deal") ...[
            const Text(
              "Instant Price & Discount Calculator",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.tealAccent),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Base Price: \$${_parsedPrice.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 14, color: Colors.white)),
                      Text(
                        "Final: \$${finalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text("Discount (${_discountRate.toInt()}%): ", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      Expanded(
                        child: Slider(
                          value: _discountRate,
                          min: 0,
                          max: 90,
                          divisions: 18,
                          activeColor: Colors.tealAccent,
                          onChanged: (val) {
                            setState(() => _discountRate = val);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
          const Text(
            "Instant Text Actions & Transformers",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              _buildActionButton(
                icon: Icons.title,
                label: "UPPERCASE",
                onTap: () => setState(() => _activeText = _activeText.toUpperCase()),
              ),
              _buildActionButton(
                icon: Icons.text_fields,
                label: "lowercase",
                onTap: () => setState(() => _activeText = _activeText.toLowerCase()),
              ),
              _buildActionButton(
                icon: Icons.cleaning_services,
                label: "Clean Emojis",
                onTap: () {
                  setState(() {
                    _activeText = _activeText.replaceAll(RegExp(r'[^\w\s\d.,!@#$%^&*()\-+=]'), '');
                  });
                  _showSnackBar("Cleaned Emojis & Symbols");
                },
              ),
              _buildActionButton(
                icon: Icons.format_list_bulleted,
                label: "Bulletize Lines",
                onTap: () {
                  setState(() {
                    List<String> parts = _activeText.split('. ');
                    _activeText = parts.map((p) => "• $p").join('\n');
                  });
                },
              ),
              _buildActionButton(
                icon: Icons.chat_bubble_outline,
                label: "Gen Quick Reply",
                onTap: () {
                  setState(() {
                    _activeText = "Thanks for the info! Regarding this: \"$_activeText\" - I'll review and reply shortly.";
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            "Recent Context Clipboard History",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _clipHistory.length,
            itemBuilder: (context, index) {
              final item = _clipHistory[index];
              return Card(
                color: const Color(0xFF1E293B),
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    item["text"]!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  subtitle: Text(
                    "${item["type"]} • ${item["time"]}",
                    style: const TextStyle(fontSize: 11, color: Colors.tealAccent),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.content_paste_go, size: 18, color: Colors.grey),
                    onPressed: () {
                      _analyzeText(item["text"]!);
                      _showSnackBar("Loaded snippet into Smart Studio!");
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- TAB 2: VAULT ---
  Widget _buildVaultTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
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
                    "Quick Access Snippet Vault",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    "Tap to copy instantly or launch in floating widget",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              IconButton(
                onPressed: _addNewVaultDialog,
                icon: const Icon(Icons.add_circle, color: Colors.tealAccent, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _vaultCards.length,
            itemBuilder: (context, index) {
              final card = _vaultCards[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white70),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          card["title"]!,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            card["tag"]!,
                            style: const TextStyle(fontSize: 10, color: Colors.tealAccent),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      card["content"]!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      softWrap: true,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            _showSnackBar("Copied \"${card['title']}\" to clipboard!");
                          },
                          icon: const Icon(Icons.copy, size: 14, color: Colors.tealAccent),
                          label: const Text("Copy Now", style: TextStyle(fontSize: 11, color: Colors.tealAccent)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.tealAccent),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            _analyzeText(card["content"]!);
                            setState(() => _currentTab = 0);
                            _showSnackBar("Sent to Smart Studio!");
                          },
                          icon: const Icon(Icons.auto_awesome, size: 14, color: Colors.black),
                          label: const Text("Analyze", style: TextStyle(fontSize: 11, color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.tealAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
    );
  }

  void _addNewVaultDialog() {
    String title = "";
    String content = "";
    String tag = "General";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text("New Vault Card", style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (v) => title = v,
                  decoration: const InputDecoration(
                    labelText: "Card Title (e.g. Work Address)",
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (v) => content = v,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Content Snippet",
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (v) => tag = v,
                  decoration: const InputDecoration(
                    labelText: "Tag / Category",
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                if (title.isNotEmpty && content.isNotEmpty) {
                  setState(() {
                    _vaultCards.add({"title": title, "content": content, "tag": tag.isEmpty ? "General" : tag});
                  });
                  Navigator.pop(context);
                  _showSnackBar("Added new card to Vault!");
                }
              },
              child: const Text("Save Snippet", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // --- TAB 3: FLOATING HUB SETTINGS ---
  Widget _buildFloatingWidgetSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Floating Overlay & Service Manager",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            "Configure real-time screen overlays and quick floating widgets that work on top of other apps.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("Floating Screen Lens Bubble", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: const Text("Display dynamic helper bubble on screen", style: TextStyle(color: Colors.grey, fontSize: 11)),
                  value: _isFloatingWidgetActive,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() => _isFloatingWidgetActive = val);
                  },
                ),
                const Divider(color: Colors.white70),
                SwitchListTile(
                  title: const Text("Floating Notifications & Quick Paste Bar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: const Text("Show persistent notification dock for one-tap clip processing", style: TextStyle(color: Colors.grey, fontSize: 11)),
                  value: _hasNotificationPermission,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() => _hasNotificationPermission = val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Simulated Notification Dock Preview",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.tealAccent.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.center_focus_weak, color: Colors.tealAccent, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("BubbleLens Active - Snippet Ready", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text("Active: \"${_activeText.length > 35 ? _activeText.substring(0, 35) + '...' : _activeText}\"", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                  onPressed: () {
                    _showSnackBar("Simulated Floating Notification Clicked!");
                  },
                  child: const Text("Process", style: TextStyle(fontSize: 10, color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Floating Overlay Shortcuts",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Card(
            color: const Color(0xFF1E293B),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _buildShortcutSettingRow(Icons.calculate, "Auto-calculate currency & discounts when copied"),
                  const SizedBox(height: 8),
                  _buildShortcutSettingRow(Icons.link, "Auto-expand shortened web URLs in bubble"),
                  const SizedBox(height: 8),
                  _buildShortcutSettingRow(Icons.spellcheck, "Auto-correct typos and trailing spaces"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildShortcutSettingRow(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.tealAccent),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
            softWrap: true,
          ),
        ),
        const Icon(Icons.check_circle, size: 18, color: Colors.teal),
      ],
    );
  }

  // --- TAB 4: SPEED LAB (INTERACTIVE RETENTION / GAME MODULE) ---
  Widget _buildDwellGameTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade800, const Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Text Transformer Speed Lab",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.tealAccent, borderRadius: BorderRadius.circular(12)),
                      child: Text("Score: $_speedChallengeScore", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Practice rapid text transformations to unlock custom floating overlay themes and power shortcuts!",
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Challenge: Convert to Bullet Points!",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Target Input Text:", style: TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 4),
                const Text("Buy apples. Pay electricity bill. Call team manager.", style: TextStyle(fontSize: 13, color: Colors.tealAccent)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      onPressed: () {
                        setState(() {
                          _speedChallengeScore += 10;
                        });
                        _showSnackBar("+10 Points! Perfect Transformation!");
                      },
                      child: const Text("Format as Bullets", style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.tealAccent)),
                      onPressed: () {
                        _showSnackBar("Try formatting as bullets for points!");
                      },
                      child: const Text("Uppercase", style: TextStyle(color: Colors.tealAccent, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Unlocked Floating Badges",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildBadgeChip("Speed Master", Icons.bolt, true),
              _buildBadgeChip("Vault Keeper", Icons.folder_special, true),
              _buildBadgeChip("Context Ninja", Icons.auto_awesome, _speedChallengeScore >= 20),
              _buildBadgeChip("Overlay Pro", Icons.layers, _speedChallengeScore >= 50),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeChip(String label, IconData icon, bool unlocked) {
    return Chip(
      avatar: Icon(icon, size: 14, color: unlocked ? Colors.black : Colors.grey),
      label: Text(
        label,
        style: TextStyle(fontSize: 11, color: unlocked ? Colors.black : Colors.grey),
      ),
      backgroundColor: unlocked ? Colors.tealAccent : const Color(0xFF1E293B),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.teal.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.tealAccent),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // --- FLOATING DRAGGABLE OVERLAY BUBBLE SIMULATOR ---
  Widget _buildDraggableFloatingBubble() {
    return Positioned(
      left: _bubbleOffset.dx,
      top: _bubbleOffset.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubbleOffset += details.delta;
          });
        },
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.tealAccent.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.center_focus_strong, color: Colors.black, size: 28),
              backgroundColor: const Color(0xFF1E293B),
              onSelected: (value) {
                if (value == 'studio') {
                  setState(() => _currentTab = 0);
                } else if (value == 'vault') {
                  setState(() => _currentTab = 1);
                } else if (value == 'copy') {
                  _showSnackBar("Quick Copied Active Snippet!");
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'studio',
                  child: Row(
                    children: const [
                      Icon(Icons.auto_awesome, color: Colors.tealAccent, size: 18),
                      SizedBox(width: 8),
                      Text("Open Smart Studio", style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'vault',
                  child: Row(
                    children: const [
                      Icon(Icons.folder_special, color: Colors.tealAccent, size: 18),
                      SizedBox(width: 8),
                      Text("Quick Vault Cards", style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'copy',
                  child: Row(
                    children: const [
                      Icon(Icons.copy, color: Colors.tealAccent, size: 18),
                      SizedBox(width: 8),
                      Text("Quick Copy Active", style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}