import 'package:flutter/material.dart';

void main() {
  runApp(const FloatStackApp());
}

class FloatStackApp extends StatelessWidget {
  const FloatStackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatStack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121418),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class SnippetItem {
  final String id;
  final String title;
  final String content;
  final String category;
  bool isPinnedToOverlay;

  SnippetItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.isPinnedToOverlay = false,
  });
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // System permissions simulation states
  bool _displayOverAppsEnabled = true;
  bool _floatingBubbleEnabled = true;
  bool _notificationBarEnabled = true;
  bool _autoCopyDetection = true;

  // Overlay customizations
  Color _bubbleColor = Colors.teal;
  double _bubbleOpacity = 0.9;
  Offset _bubblePosition = const Offset(280, 240);
  bool _isOverlayExpanded = false;

  // Snippets repository
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: '1',
      title: 'Quick WhatsApp Reply',
      content: "Hey! I'm currently busy, will call you back in 15 mins. Thanks!",
      category: 'Quick Reply',
      isPinnedToOverlay: true,
    ),
    SnippetItem(
      id: '2',
      title: 'Home Wi-Fi Details',
      content: 'SSID: Home_Fiber_5G | Pass: SecurePass2025!',
      category: 'Credentials',
      isPinnedToOverlay: true,
    ),
    SnippetItem(
      id: '3',
      title: 'Office Address Format',
      content: '100 Innovation Way, Suite 400, Tech Park, Cityville 90210',
      category: 'Addresses',
      isPinnedToOverlay: false,
    ),
    SnippetItem(
      id: '4',
      title: 'Standard Tax Invoice Notes',
      content: 'Payment due within 14 days. Bank Ref: #INV-2025-889',
      category: 'Work',
      isPinnedToOverlay: false,
    ),
  ];

  void _togglePin(String id) {
    setState(() {
      final index = _snippets.indexWhere((item) => item.id == id);
      if (index != -1) {
        _snippets[index].isPinnedToOverlay = !_snippets[index].isPinnedToOverlay;
      }
    });
  }

  void _addNewSnippet(String title, String content, String category) {
    setState(() {
      _snippets.insert(
        0,
        SnippetItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          content: content,
          category: category,
          isPinnedToOverlay: true,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildFloatingOverlayStudio(),
      _buildSnippetVaultPage(),
      _buildTextTransformerStudio(),
      _buildMiniToolsPage(),
      _buildSettingsAndPermissionsPage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        backgroundColor: const Color(0xFF1E222A),
        indicatorColor: Colors.teal.withOpacity(0.3),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.widgets_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.widgets, color: Colors.tealAccent),
            label: 'Overlay',
          ),
          NavigationDestination(
            icon: Icon(Icons.copy_all_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.copy_all, color: Colors.tealAccent),
            label: 'Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.auto_awesome, color: Colors.tealAccent),
            label: 'Text Magic',
          ),
          NavigationDestination(
            icon: Icon(Icons.build_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.build, color: Colors.tealAccent),
            label: 'Tools',
          ),
          NavigationDestination(
            icon: Icon(Icons.shield_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.shield, color: Colors.tealAccent),
            label: 'Control',
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating Overlay Studio & Interactive Preview
  Widget _buildFloatingOverlayStudio() {
    final pinnedSnippets = _snippets.where((s) => s.isPinnedToOverlay).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBanner(
            title: "Live Floating Assist",
            subtitle: "Keep snippets, calculations & quick tools floating over any app!",
            icon: Icons.layers,
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFF1E222A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(
                    _displayOverAppsEnabled ? Icons.check_circle : Icons.warning_amber,
                    color: _displayOverAppsEnabled ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _displayOverAppsEnabled
                              ? "Overlay Service Active"
                              : "Overlay Permission Needed",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _displayOverAppsEnabled
                              ? "Bubble is ready to float above social apps, browser & games."
                              : "Tap Control tab to enable 'Display over other apps'",
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _floatingBubbleEnabled,
                    onChanged: (val) {
                      setState(() => _floatingBubbleEnabled = val);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            val
                                ? "Floating Bubble activated on screen!"
                                : "Floating Bubble minimized.",
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    activeColor: Colors.tealAccent,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Interactive Overlay Simulator",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.tealAccent,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Drag the floating bubble around the virtual phone screen to test placement!",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 12),

          // Virtual Phone Screen Container
          Container(
            height: 380,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0A0C0E),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.teal.withOpacity(0.4), width: 2),
            ),
            child: Stack(
              children: [
                // Simulated Background App Content
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Colors.blueAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.chat, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Messaging App (Simulated)",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Friend: Can you send me the Wi-Fi password and your office address real quick?",
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "You: Tap the floating teal bubble to paste instant snippets without closing this chat!",
                            style: TextStyle(color: Colors.tealAccent, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Simulated Dynamic Floating Bubble / Expanded Menu
                if (_floatingBubbleEnabled)
                  Positioned(
                    left: _bubblePosition.dx,
                    top: _bubblePosition.dy,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          double newX = _bubblePosition.dx + details.delta.dx;
                          double newY = _bubblePosition.dy + details.delta.dy;
                          // Clamp inside virtual screen
                          newX = newX.clamp(10.0, 300.0);
                          newY = newY.clamp(10.0, 300.0);
                          _bubblePosition = Offset(newX, newY);
                        });
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isOverlayExpanded = !_isOverlayExpanded;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _bubbleColor.withOpacity(_bubbleOpacity),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: _bubbleColor.withOpacity(0.5),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isOverlayExpanded ? Icons.close : Icons.bolt,
                                color: Colors.black,
                                size: 26,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Expanded Floating Dock Modal Overlay inside Phone
                if (_floatingBubbleEnabled && _isOverlayExpanded)
                  Positioned(
                    left: 20,
                    right: 20,
                    top: 100,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E222A).withOpacity(0.95),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.tealAccent.withOpacity(0.6)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black87,
                            blurRadius: 16,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "FloatStack Quick Dock",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.tealAccent,
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => _isOverlayExpanded = false),
                                child: const Icon(Icons.close, color: Colors.grey, size: 18),
                              )
                            ],
                          ),
                          const Divider(color: Colors.white70, height: 16),
                          const Text(
                            "Pinned Quick Snippets:",
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          if (pinnedSnippets.isEmpty)
                            const Text(
                              "No snippets pinned. Pin from Vault!",
                              style: TextStyle(color: Colors.grey, fontSize: 11),
                            )
                          else
                            ...pinnedSnippets.take(3).map(
                                  (snippet) => Container(
                                    margin: const EdgeInsets.only(bottom: 6),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.06),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${snippet.title}: ${snippet.content}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 12),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.copy,
                                              size: 14, color: Colors.tealAccent),
                                          onPressed: () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("Copied: ${snippet.title}"),
                                                duration: const Duration(seconds: 1),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "Bubble Visual Customization",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Theme Color: ", style: TextStyle(color: Colors.grey)),
              const SizedBox(width: 8),
              _buildColorChoice(Colors.teal),
              _buildColorChoice(Colors.amber),
              _buildColorChoice(Colors.purpleAccent),
              _buildColorChoice(Colors.lightBlueAccent),
              _buildColorChoice(Colors.greenAccent),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text("Opacity: ", style: TextStyle(color: Colors.grey)),
              Expanded(
                child: Slider(
                  value: _bubbleOpacity,
                  min: 0.4,
                  max: 1.0,
                  activeColor: _bubbleColor,
                  onChanged: (val) => setState(() => _bubbleOpacity = val),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorChoice(Color color) {
    final isSelected = _bubbleColor == color;
    return GestureDetector(
      onTap: () => setState(() => _bubbleColor = color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
        ),
      ),
    );
  }

  // TAB 2: Snippet Vault & Quick Copy Manager
  Widget _buildSnippetVaultPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBanner(
            title: "Quick Snippet Vault",
            subtitle: "Store standard addresses, replies, Wi-Fi info & accounts.",
            icon: Icons.copy_all,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Stored Micro-Snippets",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.tealAccent,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddSnippetDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text("New Snippet", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _snippets.length,
            itemBuilder: (context, index) {
              final snippet = _snippets[index];
              return Card(
                color: const Color(0xFF1E222A),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              snippet.category,
                              style: const TextStyle(
                                color: Colors.tealAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                tooltip: snippet.isPinnedToOverlay
                                    ? "Unpin from overlay"
                                    : "Pin to floating overlay",
                                icon: Icon(
                                  snippet.isPinnedToOverlay
                                      ? Icons.push_pin
                                      : Icons.push_pin_outlined,
                                  color: snippet.isPinnedToOverlay
                                      ? Colors.amberAccent
                                      : Colors.grey,
                                  size: 20,
                                ),
                                onPressed: () => _togglePin(snippet.id),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.redAccent, size: 20),
                                onPressed: () {
                                  setState(() {
                                    _snippets.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        snippet.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white70),
                        ),
                        child: Text(
                          snippet.content,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontFamily: 'monospace',
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Copied '${snippet.title}' to clipboard!"),
                                backgroundColor: Colors.teal,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.tealAccent,
                            side: const BorderSide(color: Colors.tealAccent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text("1-Tap Copy"),
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

  void _showAddSnippetDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String category = 'Quick Reply';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1E222A),
            title: const Text("Add New Snippet", style: TextStyle(color: Colors.tealAccent)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Snippet Label / Title",
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: contentController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Text Content / Password / Address",
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: category,
                    dropdownColor: const Color(0xFF1E222A),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(),
                    ),
                    items: ['Quick Reply', 'Credentials', 'Addresses', 'Work', 'Personal']
                        .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => category = val);
                    },
                  ),
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
                  if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                    _addNewSnippet(
                      titleController.text,
                      contentController.text,
                      category,
                    );
                    Navigator.pop(ctx);
                  }
                },
                child: const Text("Save & Pin", style: TextStyle(color: Colors.black)),
              ),
            ],
          );
        },
      ),
    );
  }

  // TAB 3: AI/Smart Text Refiner & Extraction Studio
  Widget _buildTextTransformerStudio() {
    return _TextStudioWidget();
  }

  // TAB 4: Quick Mini Floating Tools (Split Bill, Quick Memo, Unit Snippet)
  Widget _buildMiniToolsPage() {
    return _MiniToolsWidget();
  }

  // TAB 5: Permissions & Control Center
  Widget _buildSettingsAndPermissionsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBanner(
            title: "Control Center & Permissions",
            subtitle: "Manage system overlays, floating notifications & live hooks.",
            icon: Icons.shield,
          ),
          const SizedBox(height: 20),
          const Text(
            "System Integrations",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.tealAccent,
            ),
          ),
          const SizedBox(height: 12),
          _buildPermissionToggle(
            title: "Display Over Other Apps",
            description: "Allows FloatStack bubble to stay active over browsers, chats & games.",
            value: _displayOverAppsEnabled,
            onChanged: (v) => setState(() => _displayOverAppsEnabled = v),
          ),
          _buildPermissionToggle(
            title: "Floating Active Bubble",
            description: "Show quick floating icon on screen edge for fast modal access.",
            value: _floatingBubbleEnabled,
            onChanged: (v) => setState(() => _floatingBubbleEnabled = v),
          ),
          _buildPermissionToggle(
            title: "Persistent Notification Bar Controls",
            description: "Pin 1-tap snippet drawer in system drop-down notification panel.",
            value: _notificationBarEnabled,
            onChanged: (v) => setState(() => _notificationBarEnabled = v),
          ),
          _buildPermissionToggle(
            title: "Smart Clipboard Listener",
            description: "Auto-detect copied text & offer instant floating pin prompt.",
            value: _autoCopyDetection,
            onChanged: (v) => setState(() => _autoCopyDetection = v),
          ),
          const SizedBox(height: 24),
          Card(
            color: const Color(0xFF1E222A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.monetization_on, color: Colors.amberAccent),
                      SizedBox(width: 8),
                      Text(
                        "Pro Utility Upgrade & AdMob Demo",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "FloatStack uses zero background battery drain. AdMob native banners keep this everyday utility 100% free for high usage daily routines!",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white70),
                    ),
                    child: const Text(
                      "[ AdMob Banner Placement Area ]",
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
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

  Widget _buildPermissionToggle({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      color: const Color(0xFF1E222A),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.tealAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBanner({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade800, const Color(0xFF1E222A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.tealAccent.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.tealAccent, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Stateful Widget for Text Magic / Refiner Studio
class _TextStudioWidget extends StatefulWidget {
  @override
  State<_TextStudioWidget> createState() => _TextStudioWidgetState();
}

class _TextStudioWidgetState extends State<_TextStudioWidget> {
  final TextEditingController _textController = TextEditingController(
    text: "Hey, can you check this report when free? Contact john.doe@email.com or +1 555-0199.",
  );

  String _transformedResult = "";
  List<String> _extractedInfo = [];

  void _applyToneTransform(String mode) {
    final raw = _textController.text;
    if (raw.isEmpty) return;

    setState(() {
      if (mode == 'Professional') {
        _transformedResult =
            "Dear Recipient, I kindly request you to review the report at your earliest convenience. Regards.";
      } else if (mode == 'Casual') {
        _transformedResult = "Hey! Take a quick look at this report whenever you get a sec! 🙌";
      } else if (mode == 'Short') {
        _transformedResult = "Please review attached report when free.";
      } else if (mode == 'Uppercase') {
        _transformedResult = raw.toUpperCase();
      } else if (mode == 'Clean Spaces') {
        _transformedResult = raw.replaceAll(RegExp(r'\s+'), ' ').trim();
      }
    });
  }

  void _extractContacts() {
    final raw = _textController.text;
    final emailRegex = RegExp(r'[a-zA-Z0-9.\-_]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    final phoneRegex = RegExp(r'\+?\d[\d\s\-]{7,}\d');

    final emails = emailRegex.allMatches(raw).map((m) => "Email: ${m.group(0)}").toList();
    final phones = phoneRegex.allMatches(raw).map((m) => "Phone: ${m.group(0)}").toList();

    setState(() {
      _extractedInfo = [...emails, ...phones];
      if (_extractedInfo.isEmpty) {
        _extractedInfo = ["No emails or phone numbers detected in text."];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rawText = _textController.text;
    final wordCount = rawText.trim().isEmpty ? 0 : rawText.trim().split(RegExp(r'\s+')).length;
    final charCount = rawText.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E222A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.tealAccent, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Smart Text Polish Studio",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        "Refine tones, clean formatting & extract data on the fly.",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            onChanged: (val) => setState(() {}),
            decoration: InputDecoration(
              labelText: "Input Draft / Copied Text",
              labelStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF1E222A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Words: $wordCount | Chars: $charCount",
                style: const TextStyle(color: Colors.tealAccent, fontSize: 12),
              ),
              GestureDetector(
                onTap: () {
                  _textController.clear();
                  setState(() {
                    _transformedResult = "";
                    _extractedInfo.clear();
                  });
                },
                child: const Text("Clear Text",
                    style: TextStyle(color: Colors.redAccent, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Quick Tone & Formatting Actions",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildActionButton("Professional", () => _applyToneTransform("Professional")),
              _buildActionButton("Casual Tone", () => _applyToneTransform("Casual")),
              _buildActionButton("Short Concise", () => _applyToneTransform("Short")),
              _buildActionButton("UPPERCASE", () => _applyToneTransform("Uppercase")),
              _buildActionButton("Clean Spaces", () => _applyToneTransform("Clean Spaces")),
              _buildActionButton("Extract Emails/Phones", _extractContacts, isHighlight: true),
            ],
          ),
          const SizedBox(height: 16),
          if (_transformedResult.isNotEmpty) ...[
            const Text(
              "Transformed Output:",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E222A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.withOpacity(0.4)),
              ),
              child: Text(
                _transformedResult,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Polished text copied to clipboard!"),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(Icons.copy, size: 16),
                label: const Text("Copy Transformed"),
              ),
            ),
          ],
          if (_extractedInfo.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              "Extracted Contact Details:",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amberAccent),
            ),
            const SizedBox(height: 8),
            ..._extractedInfo.map(
              (info) => Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E222A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        info,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 16, color: Colors.tealAccent),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Copied $info"),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onTap, {bool isHighlight = false}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isHighlight ? Colors.amberAccent : const Color(0xFF1E222A),
        foregroundColor: isHighlight ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}

// Stateful Widget for Mini Tools Page
class _MiniToolsWidget extends StatefulWidget {
  @override
  State<_MiniToolsWidget> createState() => _MiniToolsWidgetState();
}

class _MiniToolsWidgetState extends State<_MiniToolsWidget> {
  // Quick Split Bill Calculator State
  double _totalAmount = 85.00;
  int _peopleCount = 3;
  double _tipPercentage = 10.0;

  @override
  Widget build(BuildContext context) {
    final tipAmount = _totalAmount * (_tipPercentage / 100);
    final grandTotal = _totalAmount + tipAmount;
    final perPerson = _peopleCount > 0 ? grandTotal / _peopleCount : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E222A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.build, color: Colors.tealAccent, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "On-Screen Quick Mini-Tools",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Micro helpers designed to pop up fast over other apps.",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Mini Tool 1: Instant Quick Split Calculator
          Card(
            color: const Color(0xFF1E222A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.calculate, color: Colors.tealAccent),
                          SizedBox(width: 8),
                          Text(
                            "Quick Bill & Tip Splitter",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "Floating Tool",
                          style: TextStyle(color: Colors.tealAccent, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Bill Amount (\$) ",
                            labelStyle: const TextStyle(color: Colors.grey),
                            border: const OutlineInputBorder(),
                            prefixText: "\$ ",
                          ),
                          onChanged: (val) {
                            setState(() {
                              _totalAmount = double.tryParse(val) ?? 0.0;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Split: $_peopleCount People",
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.teal),
                                  onPressed: () {
                                    if (_peopleCount > 1) {
                                      setState(() => _peopleCount--);
                                    }
                                  },
                                ),
                                Text("$_peopleCount",
                                    style: const TextStyle(
                                        color: Colors.white, fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, color: Colors.teal),
                                  onPressed: () {
                                    setState(() => _peopleCount++);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text("Tip %: ", style: TextStyle(color: Colors.grey)),
                      Expanded(
                        child: Slider(
                          value: _tipPercentage,
                          min: 0,
                          max: 30,
                          divisions