import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const OmniHUDApp());
}

class OmniHUDApp extends StatefulWidget {
  const OmniHUDApp({Key? key}) : super(key: key);

  @override
  State<OmniHUDApp> createState() => _OmniHUDAppState();
}

class _OmniHUDAppState extends State<OmniHUDApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  Color _accentColor = Colors.tealAccent;

  void _changeTheme(ThemeMode mode, Color accent) {
    setState(() {
      _themeMode = mode;
      _accentColor = accent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniHUD',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF2F4F7),
        primaryColor: Colors.teal,
        colorScheme: ColorScheme.light(
          primary: Colors.teal,
          secondary: _accentColor,
          surface: Colors.white,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0FF121620),
        primaryColor: Colors.tealAccent,
        colorScheme: ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: _accentColor,
          surface: const Color(0FF1E2430),
        ),
        useMaterial3: true,
      ),
      home: MainHUDHomeScreen(onThemeChange: _changeTheme, accentColor: _accentColor),
    );
  }
}

class SnippetItem {
  final String id;
  final String title;
  final String content;
  final String category;
  bool isPinned;

  SnippetItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.isPinned = false,
  });
}

class MainHUDHomeScreen extends StatefulWidget {
  final Function(ThemeMode, Color) onThemeChange;
  final Color accentColor;

  const MainHUDHomeScreen({
    Key? key,
    required this.onThemeChange,
    required this.accentColor,
  }) : super(key: key);

  @override
  State<MainHUDHomeScreen> createState() => _MainHUDHomeScreenState();
}

class _MainHUDHomeScreenState extends State<MainHUDHomeScreen> with SingleTickerProviderStateMixin {
  int _selectedBottomIndex = 0;
  bool _isOverlayActive = true;
  Offset _bubblePosition = const Offset(20, 200);
  bool _isBubbleExpanded = false;

  // Stats & XP Engager System
  int _userXP = 340;
  int _actionsPerformed = 18;
  int _dailyStreak = 5;

  // Snippets State
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: '1',
      title: 'Work Email Address',
      content: 'alex.dev@omnihud.io',
      category: 'Work',
      isPinned: true,
    ),
    SnippetItem(
      id: '2',
      title: 'Quick Home Wifi Password',
      content: 'SmartPass2025!',
      category: 'Personal',
      isPinned: true,
    ),
    SnippetItem(
      id: '3',
      title: 'Project Invoice Template',
      content: 'Invoice #2025-09: Total \$450.00 - Pending Approval',
      category: 'Finance',
    ),
  ];

  // Quick Math / Bill Splitter State
  final TextEditingController _billAmountController = TextEditingController(text: "85.50");
  double _tipPercentage = 15;
  int _splitPeopleCount = 3;
  double _taxPercentage = 8;

  // Micro Decision Wheel State
  final List<String> _decisionOptions = ["Option A", "Option B", "Option C", "Option D"];
  final TextEditingController _newOptionController = TextEditingController();
  String _selectedDecisionResult = "";
  bool _isSpinning = false;
  double _wheelRotationAngle = 0;

  // Quick Floating Banner Notification text
  String _activeFloatingNotification = "OmniHUD Overlay Ready • Tap floating bubble anywhere";

  @override
  void dispose() {
    _billAmountController.dispose();
    _newOptionController.dispose();
    super.dispose();
  }

  void _addXP(int points) {
    setState(() {
      _userXP += points;
      _actionsPerformed += 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("+$points XP Earned! Total: $_userXP XP", style: const TextStyle(fontWeight: FontWeight.bold)),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    _addXP(15);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Copied '$label' to Clipboard!", style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _spinDecisionWheel() {
    if (_decisionOptions.isEmpty || _isSpinning) return;
    setState(() {
      _isSpinning = true;
      _selectedDecisionResult = "Spinning...";
    });

    final random = Random();
    final double extraTurns = 3 + random.nextDouble() * 3;
    final double targetAngle = _wheelRotationAngle + (extraTurns * 2 * pi);

    setState(() {
      _wheelRotationAngle = targetAngle;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      final selectedIdx = random.nextInt(_decisionOptions.length);
      setState(() {
        _isSpinning = false;
        _selectedDecisionResult = _decisionOptions[selectedIdx];
      });
      _addXP(25);
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
                _buildTopHUDHeader(),
                if (_isOverlayActive) _buildLiveOverlayBanner(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedBottomIndex,
                    children: [
                      _buildOverlayDashboardTab(),
                      _buildSnippetVaultTab(),
                      _buildBillSplitterTab(),
                      _buildDecisionWheelTab(),
                      _buildHUDSystemSettingsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating Bubble HUD Overlay Simulator Component
          if (_isOverlayActive)
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubblePosition += details.delta;
                  });
                },
                onTap: () {
                  setState(() {
                    _isBubbleExpanded = !_isBubbleExpanded;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.widgets, color: Colors.white, size: 28),
                    ),
                    if (_isBubbleExpanded) _buildExpandedBubbleMenu(),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomIndex,
        onTap: (index) {
          setState(() {
            _selectedBottomIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'HUD Hub'),
          BottomNavigationBarItem(icon: Icon(Icons.content_copy), label: 'Vault'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Splitter'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Decide'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildTopHUDHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: const [
          BoxShadow(color: Colors.black87, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.bolt, color: Colors.tealAccent, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Flexible(
                      child: Text(
                        "OmniHUD Active",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "LIVE HUD",
                        style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Text(
                  "Level ${(_userXP / 100).floor()} • $_userXP XP • Streak: $_dailyStreak Days",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _isOverlayActive ? Icons.visibility : Icons.visibility_off,
              color: _isOverlayActive ? Colors.tealAccent : Colors.grey,
            ),
            tooltip: "Toggle Floating HUD Simulator",
            onPressed: () {
              setState(() {
                _isOverlayActive = !_isOverlayActive;
                _activeFloatingNotification = _isOverlayActive
                    ? "Floating HUD Overlay is ON • Displaying on screen"
                    : "Floating HUD Overlay Suspended";
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLiveOverlayBanner() {
    return Container(
      width: double.infinity,
      color: Colors.teal.withOpacity(0.15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: Colors.tealAccent, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _activeFloatingNotification,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedBubbleMenu() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0FF1E2430),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.tealAccent, width: 1.5),
        boxShadow: const [
          BoxShadow(color: Colors.black87, blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          IconButton(
            icon: const Icon(Icons.content_copy, color: Colors.white, size: 20),
            tooltip: "Quick Copy Pin",
            onPressed: () {
              if (_snippets.isNotEmpty) {
                _copyToClipboard(_snippets.first.content, _snippets.first.title);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.calculate, color: Colors.white, size: 20),
            tooltip: "Quick Math Split",
            onPressed: () {
              setState(() {
                _selectedBottomIndex = 2;
                _isBubbleExpanded = false;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.casino, color: Colors.white, size: 20),
            tooltip: "Random Picker",
            onPressed: () {
              _spinDecisionWheel();
            },
          ),
        ],
      ),
    );
  }

  // --- TAB 1: OVERLAY DASHBOARD HUB ---
  Widget _buildOverlayDashboardTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Quick HUD Tools & Micro Helpers", Icons.flash_on),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAxisAlignment.start,
              children: [
                _buildQuickHUDCard(
                  title: "Clip Vault",
                  subtitle: "${_snippets.length} Items saved",
                  icon: Icons.content_copy,
                  color: Colors.teal,
                  onTap: () => setState(() => _selectedBottomIndex = 1),
                ),
                _buildQuickHUDCard(
                  title: "Bill Splitter",
                  subtitle: "Instant tip & tax",
                  icon: Icons.monetization_on,
                  color: Colors.indigo,
                  onTap: () => setState(() => _selectedBottomIndex = 2),
                ),
                _buildQuickHUDCard(
                  title: "Decision Wheel",
                  subtitle: "Solve dilemmas",
                  icon: Icons.stars,
                  color: Colors.purple,
                  onTap: () => setState(() => _selectedBottomIndex = 3),
                ),
                _buildQuickHUDCard(
                  title: "System HUD",
                  subtitle: "Permission & Theme",
                  icon: Icons.tune,
                  color: Colors.orange,
                  onTap: () => setState(() => _selectedBottomIndex = 4),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionHeader("Active Quick Snippet Shortcuts", Icons.star),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _snippets.length,
              itemBuilder: (context, index) {
                final item = _snippets[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.withOpacity(0.2),
                      child: Icon(
                        item.isPinned ? Icons.push_pin : Icons.note,
                        color: Colors.tealAccent,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      item.content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy, color: Colors.tealAccent),
                      onPressed: () => _copyToClipboard(item.content, item.title),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            _buildEngagementCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickHUDCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final width = (MediaQuery.of(context).size.width - 44) / 2;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.4), width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade800, Colors.indigo.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield, color: Colors.tealAccent, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Daily HUD Mastery",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Keep floating HUD open for daily speed productivity",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LinearProgressIndicator(
            value: (_userXP % 100) / 100,
            backgroundColor: Colors.white70,
            color: Colors.tealAccent,
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Completed $_actionsPerformed Micro Tasks",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                "${100 - (_userXP % 100)} XP to Next Level",
                style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- TAB 2: SNIPPET & CLIPBOARD VAULT ---
  Widget _buildSnippetVaultTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Clipboard Vault",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                  label: const Text("New Clip", style: TextStyle(color: Colors.white)),
                  onPressed: () => _showAddSnippetDialog(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Keep frequently used texts, passwords, and links ready for 1-tap overlay copying.",
              style: TextStyle(color: Colors.grey, fontSize: 13),
              softWrap: true,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _snippets.length,
              itemBuilder: (context, index) {
                final snippet = _snippets[index];
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                snippet.category,
                                style: const TextStyle(color: Colors.tealAccent, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                snippet.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                                color: snippet.isPinned ? Colors.tealAccent : Colors.grey,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  snippet.isPinned = !snippet.isPinned;
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                              onPressed: () {
                                setState(() {
                                  _snippets.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          snippet.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? const Color(0FF121620)
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            snippet.content,
                            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                            softWrap: true,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.teal),
                            ),
                            icon: const Icon(Icons.copy, size: 16, color: Colors.tealAccent),
                            label: const Text("Copy Snippet To Clipboard", style: TextStyle(color: Colors.tealAccent)),
                            onPressed: () => _copyToClipboard(snippet.content, snippet.title),
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
      ),
    );
  }

  void _showAddSnippetDialog() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    final catCtrl = TextEditingController(text: "General");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add New Clip Snippet"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: "Snippet Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: catCtrl,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Content / Text / Link",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text("Save Snippet", style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                setState(() {
                  _snippets.add(
                    SnippetItem(
                      id: DateTime.now().toString(),
                      title: titleCtrl.text,
                      content: contentCtrl.text,
                      category: catCtrl.text,
                    ),
                  );
                });
                _addXP(20);
                Navigator.of(ctx).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  // --- TAB 3: SMART BILL & TIP SPLITTER ---
  Widget _buildBillSplitterTab() {
    final double billTotal = double.tryParse(_billAmountController.text) ?? 0.0;
    final double taxAmount = (billTotal * _taxPercentage) / 100;
    final double tipAmount = (billTotal * _tipPercentage) / 100;
    final double grandTotal = billTotal + taxAmount + tipAmount;
    final double perPersonTotal = _splitPeopleCount > 0 ? (grandTotal / _splitPeopleCount) : 0.0;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Instant Bill & Tip Splitter",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            const Text(
              "Quickly split group expenses, coffee runs, and dinner bills with exact breakdown.",
              style: TextStyle(color: Colors.grey, fontSize: 13),
              softWrap: true,
            ),
            const SizedBox(height: 20),

            // Result Display Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.tealAccent, width: 1.5),
              ),
              child: Column(
                children: [
                  const Text("PER PERSON OWED", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "\$${perPersonTotal.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const Divider(color: Colors.white70, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMiniDetailText("Bill Base", "\$${billTotal.toStringAsFixed(2)}"),
                      _buildMiniDetailText("Tax (${_taxPercentage.toInt()}%)", "\$${taxAmount.toStringAsFixed(2)}"),
                      _buildMiniDetailText("Tip (${_tipPercentage.toInt()}%)", "\$${tipAmount.toStringAsFixed(2)}"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Controls Form
            TextField(
              controller: _billAmountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (val) => setState(() {}),
              decoration: const InputDecoration(
                labelText: "Total Bill Amount (\$) ",
                prefixIcon: Icon(Icons.monetization_on, color: Colors.teal),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Split Between:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.tealAccent),
                      onPressed: () {
                        if (_splitPeopleCount > 1) {
                          setState(() => _splitPeopleCount--);
                        }
                      },
                    ),
                    Text("$_splitPeopleCount People", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Colors.tealAccent),
                      onPressed: () {
                        setState(() => _splitPeopleCount++);
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text("Tip Percentage: ${_tipPercentage.toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _tipPercentage,
              min: 0,
              max: 30,
              divisions: 6,
              activeColor: Colors.tealAccent,
              onChanged: (val) {
                setState(() {
                  _tipPercentage = val;
                });
              },
            ),

            Text("Tax Percentage: ${_taxPercentage.toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _taxPercentage,
              min: 0,
              max: 20,
              divisions: 20,
              activeColor: Colors.teal,
              onChanged: (val) {
                setState(() {
                  _taxPercentage = val;
                });
              },
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.share, color: Colors.white),
                label: const Text("Copy Bill Summary To Share", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () {
                  final summaryText = "OmniHUD Bill Split Summary:\nTotal Bill: \$${grandTotal.toStringAsFixed(2)}\nSplit ($_splitPeopleCount people): \$${perPersonTotal.toStringAsFixed(2)} per person!";
                  _copyToClipboard(summaryText, "Bill Summary");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniDetailText(String title, String val) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  // --- TAB 4: MICRO DECISION WHEEL ---
  Widget _buildDecisionWheelTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Micro-Decision Wheel",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            const Text(
              "Stuck on a micro decision? Add your options and let the visual overlay wheel solve it instantly.",
              style: TextStyle(color: Colors.grey, fontSize: 13),
              softWrap: true,
            ),
            const SizedBox(height: 24),

            // Visual Spin Wheel Box
            Center(
              child: Column(
                children: [
                  AnimatedRotation(
                    turns: _wheelRotationAngle / (2 * pi),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.decelerate,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            Colors.teal,
                            Colors.indigo,
                            Colors.purple,
                            Colors.orange,
                            Colors.teal,
                          ],
                        ),
                        boxShadow: const [
                          BoxShadow(color: Colors.black87, blurRadius: 12, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.star, size: 48, color: Colors.tealAccent),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_selectedDecisionResult.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.tealAccent),
                      ),
                      child: Text(
                        "RESULT: $_selectedDecisionResult",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.tealAccent),
                      ),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    icon: const Icon(Icons.play_arrow, color: Colors.white),
                    label: const Text("SPIN DECISION WHEEL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    onPressed: _spinDecisionWheel,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            _buildSectionHeader("Manage Decision Options", Icons.edit),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newOptionController,
                    decoration: const InputDecoration(
                      labelText: "New Option (e.g., Pizza, Work, Gym)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.tealAccent, size: 36),
                  onPressed: () {
                    if (_newOptionController.text.isNotEmpty) {
                      setState(() {
                        _decisionOptions.add(_newOptionController.text);
                        _newOptionController.clear();
                      });
                      _addXP(10);
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAxisAlignment.center,
              children: _decisionOptions.map((option) {
                return Chip(
                  label: Text(option),
                  backgroundColor: Colors.teal.withOpacity(0.15),
                  side: const BorderSide(color: Colors.teal),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () {
                    setState(() {
                      _decisionOptions.remove(option);
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 5: HUD SYSTEM & SETTINGS ---
  Widget _buildHUDSystemSettingsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "HUD System Controls",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            const Text(
              "Customize display themes, active floating HUD triggers, and stats.",
              style: TextStyle(color: Colors.grey, fontSize: 13),
              softWrap: true,
            ),
            const SizedBox(height: 20),

            _buildSectionHeader("Theme Preset Selection", Icons.color_lens),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAxisAlignment.center,
              children: [
                ActionChip(
                  avatar: const CircleAvatar(backgroundColor: Colors.tealAccent, radius: 8),
                  label: const Text("Cyber Dark"),
                  onPressed: () => widget.onThemeChange(ThemeMode.dark, Colors.tealAccent),
                ),
                ActionChip(
                  avatar: const CircleAvatar(backgroundColor: Colors.purpleAccent, radius: 8),
                  label: const Text("Neon Violet"),
                  onPressed: () => widget.onThemeChange(ThemeMode.dark, Colors.purpleAccent),
                ),
                ActionChip(
                  avatar: const CircleAvatar(backgroundColor: Colors.orangeAccent, radius: 8),
                  label: const Text("Sunset Amber"),
                  onPressed: () => widget.onThemeChange(ThemeMode.light, Colors.orangeAccent),
                ),
                ActionChip(
                  avatar: const CircleAvatar(backgroundColor: Colors.blueAccent, radius: 8),
                  label: const Text("Slate Light"),
                  onPressed: () => widget.onThemeChange(ThemeMode.light, Colors.blueAccent),
                ),
              ],
            ),

            const SizedBox(height: 24),
            _buildSectionHeader("Overlay Permissions & Status", Icons.build),
            const SizedBox(height: 12),

            SwitchListTile(
              title: const Text("Enable Floating Bubble Overlay"),
              subtitle: const Text("Keep instant quick utilities floating over active apps"),
              value: _isOverlayActive,
              activeColor: Colors.tealAccent,
              onChanged: (val) {
                setState(() {
                  _isOverlayActive = val;
                  _activeFloatingNotification = val
                      ? "Floating HUD Overlay Enabled"
                      : "Floating HUD Disabled";
                });
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.info, color: Colors.teal),
              title: const Text("App Version"),
              subtitle: const Text("OmniHUD v2.5 • Utility Engine Active"),
            ),
            ListTile(
              leading: const Icon(Icons.star, color: Colors.amber),
              title: const Text("Productivity XP Score"),
              subtitle: Text("$_userXP XP Earned across $_actionsPerformed micro tasks"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.tealAccent, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}