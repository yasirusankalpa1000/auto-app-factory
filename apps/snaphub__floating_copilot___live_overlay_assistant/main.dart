import 'package:flutter/material.dart';

void main() {
  runApp(const SnapHubApp());
}

class SnapHubApp extends StatelessWidget {
  const SnapHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapHub Copilot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0E17),
        cardTheme: const CardTheme(
          color: Color(0xFF1D1B2A),
          elevation: 4,
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
  int _currentIndex = 0;

  // Global App States
  bool _overlayPermission = true;
  bool _floatingNotification = true;
  bool _quickDockActive = true;
  bool _floatingBubbleVisible = true;
  
  // Draggable Floating Bubble Position
  Offset _bubblePosition = const Offset(20, 180);

  // Clipboard Tools State
  final TextEditingController _clipboardController = TextEditingController(
    text: "SnapHub Floating Utility makes daily multitasking effortless! #productivity #tech",
  );
  String _formattedText = "";

  // Dynamic Floating Sticky Notes
  final List<FloatingNoteItem> _notes = [
    FloatingNoteItem(
      id: '1',
      title: 'Shopping List',
      content: '1. Organic Milk\n2. Espresso Beans\n3. Avocados',
      color: Colors.amber,
      position: const Offset(40, 100),
      isPinned: true,
    ),
    FloatingNoteItem(
      id: '2',
      title: 'Meeting Code',
      content: 'Passcode: 884-902-11\nLink: snaphub.app/room',
      color: Colors.teal,
      position: const Offset(60, 260),
      isPinned: false,
    ),
  ];

  // Quick Calc States
  double _billAmount = 85.0;
  int _splitPeople = 3;
  double _tipPercentage = 15.0;
  
  double _usdInput = 50.0;
  final double _exchangeRate = 3.67; // Mock rate USD to AED/Local

  // Trigger floating alert banner
  void _showFloatingNotification(String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 70, left: 16, right: 16),
        backgroundColor: const Color(0xFF2A273E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: color, width: 1.5),
        ),
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "SnapHub Floating Assistant",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override.dart
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildDashboardTab(),
                _buildClipboardStudioTab(),
                _buildFloatingCalcTab(),
                _buildStickyNotesCanvasTab(),
                _buildOverlaySettingsTab(),
              ],
            ),
          ),
          
          // Simulated System Wide Floating Assistive Bubble Engine
          if (_floatingBubbleVisible)
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetec.dart
              child: Draggable(
                feedback: _buildFloatingBubbleIcon(isDragging: true),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: _buildFloatingBubbleIcon(),
                ),
                onDragEnd: (details) {
                  setState(() {
                    // Restrict bubble within screen bounds safely
                    double x = details.offset.dx.clamp(10.0, MediaQuery.of(context).size.width - 70.0);
                    double y = details.offset.dy.clamp(50.0, MediaQuery.of(context).size.height - 120.0);
                    _bubblePosition = Offset(x, y);
                  });
                },
                child: InkWell(
                  onTap: () => _showFloatingQuickMenu(),
                  child: _buildFloatingBubbleIcon(),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF2E2B44), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: const Color(0xFF13111C),
          selectedItemColor: Colors.deepPurpleAccent,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Hub Dock',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.copy_all_rounded),
              label: 'Clip Studio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate_rounded),
              label: 'Quick Calc',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.layers_rounded),
              label: 'Overlays',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tune_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingBubbleIcon({bool isDragging = false}) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.deepPurpleAccent, Colors.indigoAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurpleAccent.withOpacity(isDragging ? 0.6 : 0.4),
            blurRadius: isDragging ? 16 : 10,
            spreadRadius: 2,
          )
        ],
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
      ),
      child: const Center(
        child: Icon(Icons.bolt_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  void _showFloatingQuickMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1D1B2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "SnapHub Floating Drawer",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(ctx),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildQuickMenuChip(
                    icon: Icons.content_copy,
                    label: "Quick Clip",
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() => _currentIndex = 1);
                      _showFloatingNotification("Opened Clipboard Studio", Icons.content_copy, Colors.blue);
                    },
                  ),
                  _buildQuickMenuChip(
                    icon: Icons.note_add_rounded,
                    label: "New Overlay",
                    color: Colors.amber,
                    onTap: () {
                      Navigator.pop(ctx);
                      _addFloatingNote();
                    },
                  ),
                  _buildQuickMenuChip(
                    icon: Icons.calculate_outlined,
                    label: "Fast Split",
                    color: Colors.teal,
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() => _currentIndex = 2);
                      _showFloatingNotification("Opened Fast Split Calculator", Icons.calculate, Colors.teal);
                    },
                  ),
                  _buildQuickMenuChip(
                    icon: Icons.cleaning_services_rounded,
                    label: "Clean Text",
                    color: Colors.purpleAccent,
                    onTap: () {
                      Navigator.pop(ctx);
                      _formatClipboardText('clean');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickMenuChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 100,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.4), width: 1.5),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TAB 1: DASHBOARD & FLOATING HUB DOCK
  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Banner
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "SnapHub Dock",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Live Floating Multi-Tool & Copilot",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.circle, color: Colors.green, size: 10),
                    SizedBox(width: 6),
                    Text(
                      "ACTIVE",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Permissions Status Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.shield_rounded, color: Colors.indigoAccent, size: 22),
                      SizedBox(width: 10),
                      Text(
                        "Overlay Engine Permissions",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildPermissionToggleRow(
                    title: "Display Over Other Apps",
                    subtitle: "Allows floating sticky notes & mini calculator overlays",
                    value: _overlayPermission,
                    onChanged: (val) {
                      setState(() => _overlayPermission = val);
                      _showFloatingNotification(
                        val ? "Display Over Apps Enabled" : "Display Over Apps Disabled",
                        Icons.layers,
                        val ? Colors.green : Colors.orange,
                      );
                    },
                  ),
                  const Divider(color: Color(0xFF2E2B44)),
                  _buildPermissionToggleRow(
                    title: "Floating Toast Notifications",
                    subtitle: "Instant non-intrusive status updates",
                    value: _floatingNotification,
                    onChanged: (val) {
                      setState(() => _floatingNotification = val);
                      _showFloatingNotification(
                        val ? "Floating Notifications Active" : "Notifications Muted",
                        Icons.notifications,
                        val ? Colors.green : Colors.orange,
                      );
                    },
                  ),
                  const Divider(color: Color(0xFF2E2B44)),
                  _buildPermissionToggleRow(
                    title: "Quick Action Assistant Bubble",
                    subtitle: "Draggable floating widget on home screen",
                    value: _floatingBubbleVisible,
                    onChanged: (val) {
                      setState(() => _floatingBubbleVisible = val);
                      _showFloatingNotification(
                        val ? "Assistive Bubble Visible" : "Assistive Bubble Hidden",
                        Icons.bolt,
                        val ? Colors.deepPurpleAccent : Colors.grey,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "Live Quick Actions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // Action Cards Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.25,
            children: [
              _buildActionCard(
                title: "Instant Text Format",
                subtitle: "Auto-clean spaces & hashtags",
                icon: Icons.auto_fix_high,
                color: Colors.teal,
                onTap: () => setState(() => _currentIndex = 1),
              ),
              _buildActionCard(
                title: "Create Memo Overlay",
                subtitle: "Pin quick notes on top",
                icon: Icons.note_add_rounded,
                color: Colors.amber,
                onTap: _addFloatingNote,
              ),
              _buildActionCard(
                title: "Quick Split Bill",
                subtitle: "Calculate tips & shares",
                icon: Icons.restaurant,
                color: Colors.orangeAccent,
                onTap: () => setState(() => _currentIndex = 2),
              ),
              _buildActionCard(
                title: "Trigger Live Alert",
                subtitle: "Test floating banner",
                icon: Icons.notification_important,
                color: Colors.purpleAccent,
                onTap: () {
                  _showFloatingNotification(
                    "SnapHub floating widget active & synchronized!",
                    Icons.stars,
                    Colors.purpleAccent,
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 20),
          // User Productivity Stats
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            color: const Color(0xFF161426),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem("Saved Time", "18 Mins", Icons.timer),
                  Container(height: 35, width: 1, color: Colors.grey.withOpacity(0.3)),
                  _buildStatItem("Active Memos", "${_notes.length}", Icons.sticky_note_2),
                  Container(height: 35, width: 1, color: Colors.grey.withOpacity(0.3)),
                  _buildStatItem("Copilot Status", "Ready", Icons.check_circle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: Colors.deepPurpleAccent,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.deepPurpleAccent, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // TAB 2: SMART CLIPBOARD STUDIO
  Widget _buildClipboardStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Smart Clipboard Studio",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Transform & format text instantly while multi-tasking",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 18),

          // Input Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Clipboard Text Buffer",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear_rounded, color: Colors.grey, size: 20),
                        onPressed: () {
                          _clipboardController.clear();
                          setState(() => _formattedText = "");
                        },
                      ),
                    ],
                  ),
                  TextField(
                    controller: _clipboardController,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Type or paste dynamic text here...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF13111C),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Text(
            "Instant Floating Transformers",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTransformBtn("UPPERCASE", Icons.format_size, () => _formatClipboardText('upper')),
              _buildTransformBtn("lowercase", Icons.text_fields, () => _formatClipboardText('lower')),
              _buildTransformBtn("Title Case", Icons.title, () => _formatClipboardText('title')),
              _buildTransformBtn("Clean Extra Spaces", Icons.space_bar, () => _formatClipboardText('clean')),
              _buildTransformBtn("Extract Hashtags", Icons.tag, () => _formatClipboardText('hashtags')),
              _buildTransformBtn("URL Encoded", Icons.link, () => _formatClipboardText('url')),
            ],
          ),

          if (_formattedText.isNotEmpty) ...[
            const SizedBox(height: 20),
            Card(
              color: const Color(0xFF152238),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.blueAccent, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Transformed Result",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, color: Colors.blueAccent, size: 20),
                          onPressed: () {
                            _showFloatingNotification(
                              "Result copied to floating clipboard!",
                              Icons.check_circle,
                              Colors.blueAccent,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    SelectableText(
                      _formattedText,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
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

  Widget _buildTransformBtn(String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF262338),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _formatClipboardText(String mode) {
    String text = _clipboardController.text;
    if (text.isEmpty) {
      _showFloatingNotification("Please enter text in clipboard buffer", Icons.warning_amber, Colors.orange);
      return;
    }

    setState(() {
      switch (mode) {
        case 'upper':
          _formattedText = text.toUpperCase();
          break;
        case 'lower':
          _formattedText = text.toLowerCase();
          break;
        case 'title':
          _formattedText = text.split(' ').map((str) {
            if (str.isEmpty) return str;
            return str[0].toUpperCase() + str.substring(1).toLowerCase();
          }).join(' ');
          break;
        case 'clean':
          _formattedText = text.replaceAll(RegExp(r'\s+'), ' ').trim();
          break;
        case 'hashtags':
          List<String> words = text.split(RegExp(r'\s+'));
          List<String> tags = words.where((w) => w.startsWith('#')).toList();
          _formattedText = tags.isNotEmpty ? tags.join(' ') : "No #hashtags found in text";
          break;
        case 'url':
          _formattedText = Uri.encodeComponent(text);
          break;
      }
    });

    _showFloatingNotification("Text transformed successfully", Icons.bolt, Colors.green);
  }

  // TAB 3: FLOATING QUICK CALC & MULTI-TOOL
  Widget _buildFloatingCalcTab() {
    double totalTip = (_billAmount * _tipPercentage) / 100;
    double totalBill = _billAmount + totalTip;
    double perPerson = _splitPeople > 0 ? totalBill / _splitPeople : totalBill;

    double localCurrencyResult = _usdInput * _exchangeRate;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Quick Floating Calculators",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Instant micro-computations without opening full calc apps",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 18),

          // Split Bill Calculator Widget
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.restaurant, color: Colors.orangeAccent, size: 22),
                      SizedBox(width: 8),
                      Text(
                        "Split Bill & Tip Floating Tool",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Bill Amount (\$):", style: TextStyle(color: Colors.grey, fontSize: 13)),
                      Text(
                        "\$${_billAmount.toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  Slider(
                    value: _billAmount,
                    min: 5.0,
                    max: 500.0,
                    divisions: 99,
                    activeColor: Colors.orangeAccent,
                    onChanged: (val) => setState(() => _billAmount = val),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tip Percentage (${_tipPercentage.toInt()}%):", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      Text("\$${totalTip.toStringAsFixed(2)}", style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: _tipPercentage,
                    min: 0.0,
                    max: 30.0,
                    divisions: 6,
                    activeColor: Colors.orangeAccent,
                    onChanged: (val) => setState(() => _tipPercentage = val),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Split Between People:", style: TextStyle(color: Colors.grey, fontSize: 13)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.orangeAccent),
                            onPressed: _splitPeople > 1 ? () => setState(() => _splitPeople--) : null,
                          ),
                          Text("$_splitPeople", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Colors.orangeAccent),
                            onPressed: () => setState(() => _splitPeople++),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Divider(color: Color(0xFF2E2B44)),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Each Person Pays:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text(
                          "\$${perPerson.toStringAsFixed(2)}",
                          style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Fast Foreign Currency Estimator
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.currency_exchange_rounded, color: Colors.tealAccent, size: 22),
                      SizedBox(width: 8),
                      Text(
                        "Quick Foreign Currency Estimator",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("USD Amount (\$):", style: TextStyle(color: Colors.grey, fontSize: 13)),
                      Text("\$${_usdInput.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  Slider(
                    value: _usdInput,
                    min: 5.0,
                    max: 1000.0,
                    divisions: 199,
                    activeColor: Colors.tealAccent,
                    onChanged: (val) => setState(() => _usdInput = val),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.tealAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Estimated Local Value:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text(
                          "${localCurrencyResult.toStringAsFixed(2)} AED",
                          style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 18),
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

  // TAB 4: FLOATING STICKY NOTES CANVAS
  Widget _buildStickyNotesCanvasTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Floating Overlay Memos",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      "Pin translucent notes over your screen",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              FloatingActionButton.small(
                onPressed: _addFloatingNote,
                backgroundColor: Colors.deepPurpleAccent,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        ),
        Expanded(
          child: _notes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.sticky_note_2_outlined, color: Colors.grey, size: 48),
                      SizedBox(height: 12),
                      Text("No active floating memos", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final note = _notes[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: note.isPinned ? note.color : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 12,
                          height: 40,
                          decoration: BoxDecoration(
                            color: note.color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        title: Text(
                          note.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        subtitle: Text(
                          note.content,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                                color: note.isPinned ? note.color : Colors.grey,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  note.isPinned = !note.isPinned;
                                });
                                _showFloatingNotification(
                                  note.isPinned ? "Memo Pinned to Overlay Screen" : "Memo Unpinned",
                                  Icons.push_pin,
                                  note.color,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                              onPressed: () {
                                setState(() {
                                  _notes.removeAt(index);
                                });
                                _showFloatingNotification("Overlay Memo Deleted", Icons.delete, Colors.redAccent);
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
    );
  }

  void _addFloatingNote() {
    setState(() {
      _notes.add(
        FloatingNoteItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: "Quick Memo #${_notes.length + 1}",
          content: "Tap to edit dynamic floating content...",
          color: Colors.purpleAccent,
          position: const Offset(50, 150),
          isPinned: true,
        ),
      );
    });
    _showFloatingNotification("New Overlay Memo Created!", Icons.note_add, Colors.purpleAccent);
  }

  // TAB 5: OVERLAY SETTINGS & CUSTOMIZATION
  Widget _buildOverlaySettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Copilot Engine Settings",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            "Customize floating dock behavior & appearance",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 18),

          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.touch_app_rounded, color: Colors.deepPurpleAccent),
                  title: const Text("Edge Dock Snap Behavior", style: TextStyle(color: Colors.white, fontSize: 14)),
                  subtitle: const Text("Auto-snap bubble to nearest edge on drag release", style: TextStyle(color: Colors.grey, fontSize: 11)),
                  trailing: Switch(
                    value: _quickDockActive,
                    activeColor: Colors.deepPurpleAccent,
                    onChanged: (val) => setState(() => _quickDockActive = val),
                  ),
                ),
                const Divider(color: Color(0xFF2E2B44), height: 1),
                ListTile(
                  leading: const Icon(Icons.opacity_rounded, color: Colors.tealAccent),
                  title: const Text("Overlay Translucency", style: TextStyle(color: Colors.white, fontSize: 14)),
                  subtitle: const Text("Adjust background opacity for overlay cards", style: TextStyle(color: Colors.grey, fontSize: 11)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 14),
                  onTap: () {
                    _showFloatingNotification("Opacity level calibrated to 85%", Icons.opacity, Colors.tealAccent);
                  },
                ),
                const Divider(color: Color(0xFF2E2B44), height: 1),
                ListTile(
                  leading: const Icon(Icons.restart_alt_rounded, color: Colors.orangeAccent),
                  title: const Text("Reset Floating Bubble Position", style: TextStyle(color: Colors.white, fontSize: 14)),
                  subtitle: const Text("Center floating assistant on mobile viewport", style: TextStyle(color: Colors.grey, fontSize: 11)),
                  onTap: () {
                    setState(() {
                      _bubblePosition = const Offset(20, 180);
                    });
                    _showFloatingNotification("Floating Bubble reset to default position", Icons.refresh, Colors.orangeAccent);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Card(
            color: const Color(0xFF1B192A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: const [
                  Icon(Icons.stars_rounded, color: Colors.amber, size: 36),
                  SizedBox(height: 8),
                  Text(
                    "SnapHub Pro Assistant v1.0",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Designed for high-engagement, daily multi-tasking productivity.",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FloatingNoteItem {
  final String id;
  String title;
  String content;
  Color color;
  Offset position;
  bool isPinned;

  FloatingNoteItem({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.position,
    this.isPinned = false,
  });
}