import 'package:flutter/material.dart';

void main() {
  runApp(const FloatMateApp());
}

class FloatMateApp extends StatefulWidget {
  const FloatMateApp({super.key});

  @override
  State<FloatMateApp> createState() => _FloatMateAppState();
}

class _FloatMateAppState extends State<FloatMateApp> {
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatMate',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF12141D),
      ),
      home: HomeScreen(
        isDarkMode: _isDarkMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Floating Overlay State Controls
  bool _overlayEnabled = true;
  bool _floatingPillActive = true;
  bool _clipboardAutoSync = true;
  bool _floatingNotificationBanner = true;

  // Permissions State Mock
  bool _permDisplayAbove = true;
  bool _permNotifications = true;
  bool _permAccessibility = false;

  // Simulated Floating Bubble Text
  String _activeFloatingText = "Quick Dynamic Note: Call client at 4 PM";

  // Clipboard Data
  final List<Map<String, String>> _clipboardItems = [
    {
      "type": "Code",
      "title": "AdMob Unit ID",
      "content": "ca-app-pub-3940256099942544/6300978111"
    },
    {
      "type": "URL",
      "title": "Flutter Documentation",
      "content": "https://docs.flutter.dev"
    },
    {
      "type": "Note",
      "title": "Grocery Budget",
      "content": "Limit spending to \$45.50 for total fresh produce."
    },
    {
      "type": "Phone",
      "title": "Emergency Support",
      "content": "+1 (800) 555-0199"
    },
  ];

  void _addClipItem(String type, String title, String content) {
    setState(() {
      _clipboardItems.insert(0, {
        "type": type,
        "title": title,
        "content": content,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = widget.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1A1D2A) : Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.layers, color: Colors.indigo),
            ),
            const SizedBox(width: 10),
            const Text(
              "FloatMate",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.amber : Colors.indigo,
            ),
            onPressed: widget.onToggleTheme,
            tooltip: "Toggle Theme",
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Floating Dynamic Banner Preview
            if (_floatingNotificationBanner) _buildSimulatedFloatingBanner(),

            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  _buildOverlayStudioTab(),
                  _buildClipboardVaultTab(),
                  _buildMicroToolsTab(),
                  _buildIdleBrainDockTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.widgets),
            selectedIcon: Icon(Icons.widgets, color: Colors.indigo),
            label: 'Overlay',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_copy),
            selectedIcon: Icon(Icons.content_copy, color: Colors.indigo),
            label: 'Clipboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.build_circle),
            selectedIcon: Icon(Icons.build_circle, color: Colors.indigo),
            label: 'MicroTools',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_esports),
            selectedIcon: Icon(Icons.sports_esports, color: Colors.indigo),
            label: 'Brain Boost',
          ),
        ],
      ),
    );
  }

  // Floating Dynamic Banner (Simulated Overlay)
  Widget _buildSimulatedFloatingBanner() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.indigo.shade700,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.white70,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_active,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _activeFloatingText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.close, color: Colors.white70, size: 18),
            onPressed: () {
              setState(() {
                _floatingNotificationBanner = false;
              });
            },
          ),
        ],
      ),
    );
  }

  // TAB 1: OVERLAY STUDIO & SYSTEM PERMISSIONS
  Widget _buildOverlayStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Active Floating Controls", Icons.touch_app),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: Colors.indigo,
                    title: const Text("Enable System Floating Bubble",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text(
                        "Show dynamic persistent quick tools over other apps"),
                    value: _overlayEnabled,
                    onChanged: (val) => setState(() => _overlayEnabled = val),
                  ),
                  const Divider(),
                  SwitchListTile(
                    activeColor: Colors.indigo,
                    title: const Text("Smart Clipboard Auto-Capture"),
                    subtitle: const Text(
                        "Automatically save copied text to float clipboard"),
                    value: _clipboardAutoSync,
                    onChanged: (val) =>
                        setState(() => _clipboardAutoSync = val),
                  ),
                  const Divider(),
                  SwitchListTile(
                    activeColor: Colors.indigo,
                    title: const Text("Floating Notch Dynamic Bar"),
                    subtitle: const Text(
                        "Display floating status pill on screen top"),
                    value: _floatingPillActive,
                    onChanged: (val) => setState(() {
                      _floatingPillActive = val;
                      _floatingNotificationBanner = val;
                    }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionHeader("System Permissions Setup", Icons.security),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                _buildPermissionRow(
                  title: "Display Over Other Apps",
                  subtitle: "Required for floating bubble & overlay tools",
                  icon: Icons.layers,
                  granted: _permDisplayAbove,
                  onToggle: (v) => setState(() => _permDisplayAbove = v),
                ),
                const Divider(height: 1),
                _buildPermissionRow(
                  title: "Notification Access",
                  subtitle: "Enables floating live banner alerts",
                  icon: Icons.notifications,
                  granted: _permNotifications,
                  onToggle: (v) => setState(() => _permNotifications = v),
                ),
                const Divider(height: 1),
                _buildPermissionRow(
                  title: "Accessibility Service",
                  subtitle: "Provides smart auto-fill & dynamic action shortcuts",
                  icon: Icons.accessibility,
                  granted: _permAccessibility,
                  onToggle: (v) => setState(() => _permAccessibility = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionHeader("Quick Floating Note Preset", Icons.edit_note),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Dynamic Floating Note Text",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.pin),
                    ),
                    onChanged: (text) {
                      setState(() {
                        _activeFloatingText = text.isEmpty
                            : text;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.add, size: 16),
                        label: const Text("Set: Call Client"),
                        onPressed: () => setState(() => _activeFloatingText =
                            "Quick Dynamic Note: Call client at 4 PM"),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.shopping_cart, size: 16),
                        label: const Text("Set: Buy Grocery"),
                        onPressed: () => setState(() => _activeFloatingText =
                            "Quick Dynamic Note: Buy milk & fresh produce"),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.star, size: 16),
                        label: const Text("Set: Meeting Code"),
                        onPressed: () => setState(() => _activeFloatingText =
                            "Quick Dynamic Note: Zoom Passcode - 889210"),
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

  // TAB 2: SMART CLIPBOARD VAULT
  Widget _buildClipboardVaultTab() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedType = "Note";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader("Clipboard Vault", Icons.folder_special),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text("New Clip"),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Add New Clip"),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: titleController,
                              decoration: const InputDecoration(
                                labelText: "Title / Label",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: contentController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                labelText: "Content / Text",
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
                          onPressed: () {
                            if (contentController.text.isNotEmpty) {
                              _addClipItem(
                                selectedType,
                                titleController.text.isEmpty
                                    ? "Saved Snippet"
                                    : titleController.text,
                                contentController.text,
                              );
                              Navigator.pop(ctx);
                            }
                          },
                          child: const Text("Save Clip"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _clipboardItems.length,
            itemBuilder: (context, index) {
              final item = _clipboardItems[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: ListTile,
              );
            },
          ),
        ],
      ),
    );
  }

  // TAB 3: MICRO TOOLS MATRIX
  Widget _buildMicroToolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Everyday Micro Utilities", Icons.handyman),
          const SizedBox(height: 12),
          
          // Tool 1: Text Inspector & Converter
          const _TextAnalyzerWidget(),
          const SizedBox(height: 16),

          // Tool 2: Instant QR Code Simulator Generator
          const _QuickQrWidget(),
          const SizedBox(height: 16),

          // Tool 3: Screen Pixel Ruler
          const _ScreenRulerWidget(),
          const SizedBox(height: 16),

          // Tool 4: Unit Micro-Converter
          const _UnitConverterWidget(),
        ],
      ),
    );
  }

  // TAB 4: IDLE BRAIN DOCK (RETENTION GAME)
  Widget _buildIdleBrainDockTab() {
    return const _IdleBrainDockWidget();
  }

  // HELPER COMPONENTS
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionRow({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool granted,
    required ValueChanged<bool> onToggle,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: granted
              ? Colors.green.withOpacity(0.15)
              : Colors.amber.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(
          granted ? Icons.check_circle : Icons.warning,
          color: granted ? Colors.green : Colors.amber.shade800,
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: Switch(
        value: granted,
        activeColor: Colors.green,
        onChanged: onToggle,
      ),
    );
  }
}

// TEXT ANALYZER SUB-WIDGET
class _TextAnalyzerWidget extends StatefulWidget {
  const _TextAnalyzerWidget();

  @override
  State<_TextAnalyzerWidget> createState() => _TextAnalyzerWidgetState();
}

class _TextAnalyzerWidgetState extends State<_TextAnalyzerWidget> {
  final TextEditingController _controller = TextEditingController();
  int _wordCount = 0;
  int _charCount = 0;

  void _analyzeText(String text) {
    setState(() {
      _charCount = text.length;
      _wordCount =
          text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.analytics, color: Colors.indigo),
                SizedBox(width: 8),
                Text("Text Inspector & Case Transformer",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Type or paste text to analyze...",
                border: OutlineInputBorder(),
              ),
              onChanged: _analyzeText,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatChip("Characters", "$_charCount"),
                _buildStatChip("Words", "$_wordCount"),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _controller.text = _controller.text.toUpperCase();
                    _analyzeText(_controller.text);
                  },
                  child: const Text("UPPERCASE"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controller.text = _controller.text.toLowerCase();
                    _analyzeText(_controller.text);
                  },
                  child: const Text("lowercase"),
                ),
                OutlinedButton(
                  onPressed: () {
                    _controller.clear();
                    _analyzeText("");
                  },
                  child: const Text("Clear"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String val) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(val,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.indigo)),
          Text(label,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}

// QUICK QR SUB-WIDGET
class _QuickQrWidget extends StatefulWidget {
  const _QuickQrWidget();

  @override
  State<_QuickQrWidget> createState() => _QuickQrWidgetState();
}

class _QuickQrWidgetState extends State<_QuickQrWidget> {
  final TextEditingController _qrController =
      TextEditingController(text: "https://floatmate.app");

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.qr_code_2, color: Colors.indigo),
                SizedBox(width: 8),
                Text("Instant QR Code Preview",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _qrController,
              decoration: const InputDecoration(
                labelText: "URL or Text for QR Code",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
              onChanged: (val) => setState(() {}),
            ),
            const SizedBox(height: 14),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.qr_code_2, size: 100, color: Colors.black),
                    const SizedBox(height: 6),
                    Text(
                      _qrController.text.isEmpty
                          : _qrController.text,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
}

// SCREEN RULER SUB-WIDGET
class _ScreenRulerWidget extends StatefulWidget {
  const _ScreenRulerWidget();

  @override
  State<_ScreenRulerWidget> createState() => _ScreenRulerWidgetState();
}

class _ScreenRulerWidgetState extends State<_ScreenRulerWidget> {
  double _rulerPos = 150.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.straighten, color: Colors.indigo),
                SizedBox(width: 8),
                Text("Screen Pixel Ruler",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Drag slider to measure screen width: ${_rulerPos.round()} px",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Slider(
              min: 50,
              max: 350,
              value: _rulerPos,
              activeColor: Colors.indigo,
              onChanged: (val) => setState(() => _rulerPos = val),
            ),
            Center(
              child: Container(
                height: 30,
                width: _rulerPos,
                decoration: BoxDecoration(
                  color: Colors.amber.shade700,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    "${_rulerPos.round()} px",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// UNIT CONVERTER SUB-WIDGET
class _UnitConverterWidget extends StatefulWidget {
  const _UnitConverterWidget();

  @override
  State<_UnitConverterWidget> createState() => _UnitConverterWidgetState();
}

class _UnitConverterWidgetState extends State<_UnitConverterWidget> {
  double _inputVal = 1.0;
  String _mode = "KM to Miles";

  double get _convertedValue {
    switch (_mode) {
      case "KM to Miles":
        return _inputVal * 0.621371;
      case "Miles to KM":
        return _inputVal * 1.60934;
      case "KG to LBS":
        return _inputVal * 2.20462;
      case "LBS to KG":
        return _inputVal * 0.453592;
      default:
        return _inputVal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.swap_horiz, color: Colors.indigo),
                SizedBox(width: 8),
                Text("Quick Unit Micro-Converter",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Value",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _inputVal = double.tryParse(val) ?? 0.0;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _mode,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: "KM to Miles", child: Text("KM -> Miles")),
                      DropdownMenuItem(
                          value: "Miles to KM", child: Text("Miles -> KM")),
                      DropdownMenuItem(
                          value: "KG to LBS", child: Text("KG -> LBS")),
                      DropdownMenuItem(
                          value: "LBS to KG", child: Text("LBS -> KG")),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _mode = val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Result: ${_convertedValue.toStringAsFixed(3)}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// IDLE BRAIN DOCK WIDGET (HIGH USER RETENTION GAME ENGINE)
class _IdleBrainDockWidget extends StatefulWidget {
  const _IdleBrainDockWidget();

  @override
  State<_IdleBrainDockWidget> createState() => _IdleBrainDockWidgetState();
}

class _IdleBrainDockWidgetState extends State<_IdleBrainDockWidget> {
  int _score = 0;
  int _highScore = 12;
  int _activeTarget = 0;
  bool _gameStarted = false;

  void _startGame() {
    setState(() {
      _score = 0;
      _gameStarted = true;
      _nextRound();
    });
  }

  void _nextRound() {
    setState(() {
      _activeTarget = (DateTime.now().millisecondsSinceEpoch % 6);
    });
  }

  void _handleTap(int index) {
    if (!_gameStarted) return;
    if (index == _activeTarget) {
      setState(() {
        _score++;
        if (_score > _highScore) _highScore = _score;
      });
      _nextRound();
    } else {
      setState(() {
        _gameStarted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology, color: Colors.indigo, size: 24),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "Focus & Brain Reflex Booster",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "Quick anti-boredom reflex trainer. Tap the highlighted active dynamic tile!",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildScoreBoard("Current Score", "$_score"),
                      _buildScoreBoard("Best Score", "$_highScore"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, idx) {
                      final isActive = _gameStarted && (idx == _activeTarget);
                      return GestureDetector(
                        onTap: () => _handleTap(idx),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.indigo
                                : Colors.indigo.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: Colors.indigo.withOpacity(0.5),
                                      blurRadius: 10,
                                    )
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Icon(
                              isActive ? Icons.bolt : Icons.circle_outlined,
                              color: isActive ? Colors.amber : Colors.indigo,
                              size: 32,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(_gameStarted ? Icons.refresh : Icons.play_arrow),
                    label: Text(
                      _gameStarted ? "Restart Challenge" : "Start Speed Game",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _startGame,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBoard(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.indigo)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}