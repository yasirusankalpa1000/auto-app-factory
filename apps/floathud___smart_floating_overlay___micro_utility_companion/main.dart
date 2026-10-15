import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const FloatHudApp());
}

class FloatHudApp extends StatelessWidget {
  const FloatHudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatHUD Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      home: const MainHudScreen(),
    );
  }
}

class MainHudScreen extends StatefulWidget {
  const MainHudScreen({super.key});

  @override
  State<MainHudScreen> createState() => _MainHudScreenState();
}

class _MainHudScreenState extends State<MainHudScreen> {
  int _currentTabIndex = 0;
  bool _isOverlayEnabled = true;
  bool _showFloatingNotes = true;
  bool _showQuickClipboard = true;
  bool _showImpulseShield = true;
  bool _showDecisionWheel = false;

  // Floating Bubble Position Simulation
  Offset _bubblePosition = const Offset(20, 180);

  // Impulse Tracker State
  double _totalDollarsSaved = 145.50;
  int _totalMinutesSaved = 320;
  int _urgeResistedCount = 18;
  final List<String> _impulseLogs = [
    "Resisted buying \$85 shoes online",
    "Avoided 45 min social doomscroll",
    "Skipped \$15 fast-food snack call",
  ];

  // Snippets/Clipboard State
  final List<Map<String, String>> _snippets = [
    {
      "id": "1",
      "title": "Delivery Address",
      "content": "742 Evergreen Terrace, Sector 4, CA 90210",
      "tag": "Address"
    },
    {
      "id": "2",
      "title": "Zoom Meeting Passcode",
      "content": "8842-9901-SECURE",
      "tag": "Work"
    },
    {
      "id": "3",
      "title": "Wi-Fi Password Guest",
      "content": "FloatHUD_FastNet_2025!",
      "tag": "Home"
    },
  ];

  // Decision Tool State
  final List<String> _decisionOptions = ["Option A", "Option B", "Option C"];
  String _selectedDecision = "Tap 'Pick For Me' to decide!";
  final TextEditingController _decisionInputController = TextEditingController();

  // Micro Bubble Pop Game State
  int _poppedBubbles = 0;
  final List<bool> _bubbleState = List.generate(12, (_) => false);

  @override
  void dispose() {
    _decisionInputController.dispose();
    super.dispose();
  }

  void _toggleOverlay(bool val) {
    setState(() {
      _isOverlayEnabled = val;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          val ? "Floating HUD Enabled on Screen!" : "Floating HUD Paused",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: val ? Colors.indigo : Colors.grey.shade700,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addImpulseLog(String item, double price, int mins) {
    setState(() {
      _totalDollarsSaved += price;
      _totalMinutesSaved += mins;
      _urgeResistedCount += 1;
      _impulseLogs.insert(0, "Resisted: $item (Saved \$${price.toStringAsFixed(2)})");
    });
  }

  void _addSnippet(String title, String content, String tag) {
    if (title.isEmpty || content.isEmpty) return;
    setState(() {
      _snippets.insert(0, {
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
        "title": title,
        "content": content,
        "tag": tag.isEmpty ? "General" : tag,
      });
    });
  }

  void _pickDecision() {
    if (_decisionOptions.isEmpty) return;
    final random = Random();
    setState(() {
      _selectedDecision = _decisionOptions[random.nextInt(_decisionOptions.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.layers, color: Colors.indigo),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                "FloatHUD Companion",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: FilterChip(
              avatar: Icon(
                _isOverlayEnabled ? Icons.visibility : Icons.visibility_off,
                size: 16,
                color: _isOverlayEnabled ? Colors.white : Colors.indigo,
              ),
              label: Text(
                _isOverlayEnabled ? "HUD Active" : "HUD Off",
                style: TextStyle(
                  color: _isOverlayEnabled ? Colors.white : Colors.indigo,
                  fontWeight: FontWeight.w600,
                ),
              ),
              selected: _isOverlayEnabled,
              selectedColor: Colors.indigo,
              backgroundColor: Colors.indigo.shade50,
              onSelected: (val) => _toggleOverlay(val),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: IndexedStack(
              index: _currentTabIndex,
              children: [
                _buildHudDashboardTab(),
                _buildImpulseInterceptorTab(),
                _buildClipboardPinboardTab(),
                _buildDecisionSuiteTab(),
              ],
            ),
          ),
          if (_isOverlayEnabled) _buildSimulatedFloatingWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) => setState(() => _currentTabIndex = index),
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarThemeData().selectedIconTheme != null
              ? BottomNavigationBarItem(
                  icon: Icon(Icons.widgets), label: "HUD Controls")
              : BottomNavigationBarItem(
                  icon: Icon(Icons.widgets), label: "HUD Controls"),
          BottomNavigationBarItem(
              icon: Icon(Icons.psychology), label: "Impulse Saver"),
          BottomNavigationBarItem(
              icon: Icon(Icons.content_paste), label: "Pinboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.touch_app), label: "Decision HUD"),
        ],
      ),
    );
  }

  // Floating Overlay Bubble Simulator
  Widget _buildSimulatedFloatingWidget() {
    return Positioned(
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
          borderRadius: BorderRadius.circular(30),
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.indigo.shade900.withOpacity(0.92),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.indigo.shade200, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.drag_indicator, color: Colors.white70, size: 18),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.indigo,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.widgets, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "FloatHUD Quick Bar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "\$${_totalDollarsSaved.toStringAsFixed(0)} Saved | ${_snippets.length} Pins",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.flash_on, color: Colors.amber, size: 18),
                  onPressed: () {
                    _showQuickHudModal(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // TAB 1: HUD Controls Dashboard
  Widget _buildHudDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBannerCard(),
          const SizedBox(height: 16),
          const Text(
            "Active Floating Micro-Widgets",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildWidgetToggleCard(
            title: "Floating Clipboard Snip Bar",
            subtitle: "Hover over shopping/chat apps to instantly paste snippets",
            icon: Icons.content_paste,
            value: _showQuickClipboard,
            onChanged: (v) => setState(() => _showQuickClipboard = v),
          ),
          _buildWidgetToggleCard(
            title: "Impulse Delay Interceptor",
            subtitle: "Pause 15s before opening shopping cart or scrolling",
            icon: Icons.shield,
            value: _showImpulseShield,
            onChanged: (v) => setState(() => _showImpulseShield = v),
          ),
          _buildWidgetToggleCard(
            title: "Quick Floating Sticky Pin",
            subtitle: "Keep passwords, codes, and addresses floating on top",
            icon: Icons.push_pin,
            value: _showFloatingNotes,
            onChanged: (v) => setState(() => _showFloatingNotes = v),
          ),
          _buildWidgetToggleCard(
            title: "Decision Wheel Quick Trigger",
            subtitle: "Resolve micro choices instantly without switching apps",
            icon: Icons.tune,
            value: _showDecisionWheel,
            onChanged: (v) => setState(() => _showDecisionWheel = v),
          ),
          const SizedBox(height: 20),
          _buildQuickActionGrid(),
        ],
      ),
    );
  }

  Widget _buildBannerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade800, Colors.purple.shade700],
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.layers, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Screen Companion Active",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "FloatHUD stays visible over your daily apps. Drag the floating bubble anywhere on screen to access saved notes, decision triggers, and urge breakers in 1-tap.",
            softWrap: true,
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                backgroundColor: Colors.white.withOpacity(0.15),
                side: BorderSide.none,
                avatar: const Icon(Icons.savings, color: Colors.amber, size: 16),
                label: Text(
                  "Saved \$${_totalDollarsSaved.toStringAsFixed(0)}",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              Chip(
                backgroundColor: Colors.white.withOpacity(0.15),
                side: BorderSide.none,
                avatar: const Icon(Icons.timer, color: Colors.lightBlueAccent, size: 16),
                label: Text(
                  "${_totalMinutesSaved}m Saved",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetToggleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        secondary: CircleAvatar(
          backgroundColor: value ? Colors.indigo.shade50 : Colors.grey.shade200,
          child: Icon(icon, color: value ? Colors.indigo : Colors.grey),
        ),
        title: Text(
          title,
          softWrap: true,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          subtitle,
          softWrap: true,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.indigo,
      ),
    );
  }

  Widget _buildQuickActionGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Micro-Utility Tools",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.4,
          children: [
            _buildGridTile(
              title: "15s Urge Pause",
              desc: "Stop shopping impulse",
              icon: Icons.shield_outlined,
              color: Colors.deepOrange,
              onTap: () => setState(() => _currentTabIndex = 1),
            ),
            _buildGridTile(
              title: "Quick Pinboard",
              desc: "Access copied text",
              icon: Icons.copy,
              color: Colors.teal,
              onTap: () => setState(() => _currentTabIndex = 2),
            ),
            _buildGridTile(
              title: "Micro Decider",
              desc: "Solve decision paralysis",
              icon: Icons.shuffle,
              color: Colors.purple,
              onTap: () => setState(() => _currentTabIndex = 3),
            ),
            _buildGridTile(
              title: "Tactile Detox",
              desc: "Pop micro bubbles",
              icon: Icons.bubble_chart,
              color: Colors.blue,
              onTap: () => _showTactilePopDialog(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGridTile({
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text(
              desc,
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: Impulse Interceptor & Urge Saver
  Widget _buildImpulseInterceptorTab() {
    final TextEditingController itemController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController minsController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.orange.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.orange.shade100,
                    child: const Icon(Icons.shield, color: Colors.deepOrange, size: 28),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Impulse Interceptor",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Intercept spending or doomscrolling before you confirm!",
                          softWrap: true,
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatBox(
                  title: "Money Saved",
                  value: "\$${_totalDollarsSaved.toStringAsFixed(2)}",
                  icon: Icons.monetization_on,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatBox(
                  title: "Time Saved",
                  value: "${_totalMinutesSaved}m",
                  icon: Icons.access_time,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatBox(
                  title: "Urges Defeated",
                  value: "$_urgeResistedCount",
                  icon: Icons.check_circle,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Log Resisted Impulse",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                TextField(
                  controller: itemController,
                  decoration: const InputDecoration(
                    labelText: "What did you almost buy or scroll?",
                    hintText: "e.g., \$50 jacket or 30m social app",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Price Saved (\$) ",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: minsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Minutes Saved",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text("Record Defeated Urge"),
                    onPressed: () {
                      final item = itemController.text.trim();
                      final price = double.tryParse(priceController.text) ?? 0.0;
                      final mins = int.tryParse(minsController.text) ?? 0;
                      if (item.isNotEmpty) {
                        _addImpulseLog(item, price, mins);
                        itemController.clear();
                        priceController.clear();
                        minsController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Logged! Victory recorded!")),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Recent Urge Log",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _impulseLogs.length,
            itemBuilder: (context, idx) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green.shade50,
                    child: Icon(Icons.star, color: Colors.green, size: 20),
                  ),
                  title: Text(
                    _impulseLogs[idx],
                    softWrap: true,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  trailing: const Icon(Icons.check, color: Colors.green, size: 18),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // TAB 3: Clipboard & Snippet Pinboard
  Widget _buildClipboardPinboardTab() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    final tagCtrl = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "Floating Clipboard Snippets",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text("New Pin"),
                onPressed: () {
                  _showAddSnippetDialog(context, titleCtrl, contentCtrl, tagCtrl);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Pinned snippets will show in your floating HUD so you can paste without app switching.",
            softWrap: true,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 14),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _snippets.length,
            itemBuilder: (context, index) {
              final snip = _snippets[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Chip(
                            padding: EdgeInsets.zero,
                            labelStyle: const TextStyle(fontSize: 10),
                            backgroundColor: Colors.indigo.shade50,
                            label: Text(
                              snip["tag"] ?? "General",
                              style: const TextStyle(color: Colors.indigo),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.copy, size: 18),
                                color: Colors.indigo,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Copied '${snip['title']}' to clipboard!"),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 18),
                                color: Colors.red.shade400,
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
                      Text(
                        snip["title"] ?? "",
                        softWrap: true,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          snip["content"] ?? "",
                          softWrap: true,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: Colors.black87,
                          ),
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

  void _showAddSnippetDialog(
    BuildContext context,
    TextEditingController titleCtrl,
    TextEditingController contentCtrl,
    TextEditingController tagCtrl,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Pin New Snippet"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: "Title (e.g., Home Address)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Text Content / Code / Link",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: tagCtrl,
                decoration: const InputDecoration(
                  labelText: "Tag (Work, Personal, Code)",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            onPressed: () {
              _addSnippet(titleCtrl.text, contentCtrl.text, tagCtrl.text);
              titleCtrl.clear();
              contentCtrl.clear();
              tagCtrl.clear();
              Navigator.pop(ctx);
            },
            child: const Text("Save Pin", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // TAB 4: Micro Decision Suite
  Widget _buildDecisionSuiteTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.purple.shade100,
                  child: const Icon(Icons.shuffle, color: Colors.purple, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Micro-Decision Resolver",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Eliminate daily decision fatigue instantly.",
                        softWrap: true,
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Decision Result Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.purple.shade200, width: 2),
            ),
            child: Column(
              children: [
                const Text(
                  "DECISION RESULT",
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedDecision,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.touch_app),
                  label: const Text("Pick For Me!"),
                  onPressed: _pickDecision,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _decisionInputController,
                  decoration: const InputDecoration(
                    hintText: "Add option (e.g. Pizza, Salad)",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: () {
                  final text = _decisionInputController.text.trim();
                  if (text.isNotEmpty) {
                    setState(() {
                      _decisionOptions.add(text);
                      _decisionInputController.clear();
                    });
                  }
                },
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Current Options Matrix",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _decisionOptions
                .map(
                  (opt) => Chip(
                    label: Text(opt),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      setState(() {
                        _decisionOptions.remove(opt);
                      });
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  // Quick Floating Action Sheet Triggered from Floating Overlay Bubble
  void _showQuickHudModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.flash_on, color: Colors.amber),
                          SizedBox(width: 6),
                          Text(
                            "FloatHUD Quick Actions",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(),
                  const Text(
                    "Pinned Quick Snippets",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Column(
                    children: _snippets
                        .map(
                          (s) => ListTile(
                            dense: true,
                            leading: const Icon(Icons.pin_end, color: Colors.indigo),
                            title: Text(s["title"] ?? "", softWrap: true),
                            subtitle: Text(s["content"] ?? "", softWrap: true),
                            trailing: IconButton(
                              icon: const Icon(Icons.copy, size: 16),
                              onPressed: () {
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Copied '${s['title']}'!"),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.shield, color: Colors.white, size: 20),
                    ),
                    title: const Text("Quick 15s Urge Pause"),
                    subtitle: const Text("Hold off shopping for 15 seconds"),
                    onTap: () {
                      Navigator.pop(ctx);
                      _showUrgePauseDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showUrgePauseDialog(BuildContext context) {
    int countdown = 15;
    Timer? timer;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            timer ??= Timer.periodic(const Duration(seconds: 1), (t) {
              if (countdown > 0) {
                setModalState(() {
                  countdown--;
                });
              } else {
                t.cancel();
              }
            });

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Row(
                children: [
                  Icon(Icons.shield, color: Colors.deepOrange),
                  SizedBox(width: 8),
                  Text("Impulse Interceptor"),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Take a deep breath. Is this purchase or scroll session essential right now?",
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.deepOrange.shade100,
                    child: Text(
                      "$countdown",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    countdown > 0 ? "Pause timer running..." : "Pause complete! You are in control.",
                    style: TextStyle(
                      fontSize: 12,
                      color: countdown > 0 ? Colors.grey : Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              actions: [
                if (countdown == 0)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      timer?.cancel();
                      Navigator.pop(ctx);
                      _addImpulseLog("15-Sec Delay Urge", 12.0, 15);
                    },
                    child: const Text("I Resisted! (+12 Saved)", style: TextStyle(color: Colors.white)),
                  ),
                TextButton(
                  onPressed: () {
                    timer?.cancel();
                    Navigator.pop(ctx);
                  },
                  child: const Text("Close"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showTactilePopDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Tactile Bubble Detox"),
                  Text(
                    "Popped: $_poppedBubbles",
                    style: const TextStyle(fontSize: 12, color: Colors.indigo),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Pop bubbles to dissipate stress and urge intensity.",
                      style: TextStyle(fontSize: 12),
                      softWrap: true,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: List.generate(12, (index) {
                        final popped = _bubbleState[index];
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              _bubbleState[index] = !_bubbleState[index];
                              if (_bubbleState[index]) {
                                _poppedBubbles++;
                              }
                            });
                          },
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: popped ? Colors.grey.shade300 : Colors.indigo.shade400,
                            child: Icon(
                              popped ? Icons.check : Icons.bubble_chart,
                              color: popped ? Colors.grey.shade600 : Colors.white,
                              size: 20,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setModalState(() {
                      for (int i = 0; i < _bubbleState.length; i++) {
                        _bubbleState[i] = false;
                      }
                    });
                  },
                  child: const Text("Reset Bubbles"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Done"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}