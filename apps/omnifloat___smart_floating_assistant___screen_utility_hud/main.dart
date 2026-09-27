import 'package:flutter/material.dart';

void main() {
  runApp(const OmniFloatApp());
}

class OmniFloatApp extends StatelessWidget {
  const OmniFloatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniFloat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F111A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.deepPurpleAccent,
          surface: Color(0xFF1A1D2C),
        ),
      ),
      home: const MainHUDPage(),
    );
  }
}

class MainHUDPage extends StatefulWidget {
  const MainHUDPage({super.key});

  @override
  State<MainHUDPage> createState() => _MainHUDPageState();
}

class _MainHUDPageState extends State<MainHUDPage> {
  int _activeTab = 0;
  bool _isOverlayActive = true;
  bool _isFloatingBubbleExpanded = false;
  Offset _bubblePosition = const Offset(20, 200);

  // Permission simulator toggles
  bool _permDisplayOverApps = true;
  bool _permNotifications = true;
  bool _permAccessibility = false;

  // Smart Clipboard Items
  final List<String> _clipboardHistory = [
    "Meeting code: https://zoom.us/j/987654321?pwd=abc - Call at 3 PM",
    "Customer contact: john.doe@email.com or +1-555-0192. Total bill \$145.50",
    "Shopping list: Milk, Eggs, Organic Coffee, Whole Wheat Bread, Avocados",
  ];
  String _activeProcessedText = "";

  // Decision Wheel Options
  final List<String> _decisionOptions = ["Pizza", "Sushi", "Tacos", "Burger", "Salad", "Pasta"];
  String _decisionResult = "Tap 'Spin' to Decides!";

  // Tip/Splitter state
  double _billAmount = 85.0;
  double _tipPercentage = 15.0;
  int _splitCount = 3;

  // Ambient Player state
  bool _isPlayingSound = false;
  String _activeSoundTrack = "Lo-Fi Rain & Chill";

  @override
  void initState() {
    super.initState();
    _activeProcessedText = _clipboardHistory.first;
  }

  // --- Helpers for Text Transformations ---
  void _extractEmails() {
    final RegExp emailRegex = RegExp(r'[a-zA-Z0-9.\-_]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    final matches = emailRegex.allMatches(_activeProcessedText);
    if (matches.isNotEmpty) {
      setState(() {
        _activeProcessedText = "Extracted Emails:\n" + matches.map((m) => m.group(0)).join("\n");
      });
    } else {
      _showMessage("No emails found in snippet");
    }
  }

  void _extractNumbers() {
    final RegExp numRegex = RegExp(r'\+?[0-9\-\(\)\.\$]+');
    final matches = numRegex.allMatches(_activeProcessedText);
    if (matches.isNotEmpty) {
      setState(() {
        _activeProcessedText = "Extracted Numbers & Values:\n" + matches.map((m) => m.group(0)).join("\n");
      });
    } else {
      _showMessage("No numbers found");
    }
  }

  void _cleanLinks() {
    final RegExp urlRegex = RegExp(r'https?://[^\s]+');
    setState(() {
      _activeProcessedText = _activeProcessedText.replaceAll(urlRegex, '[LINK REMOVED]');
    });
  }

  void _formatBulletPoints() {
    final items = _activeProcessedText.split(RegExp(r'[,;\n]'));
    final formatted = items.where((i) => i.trim().isNotEmpty).map((i) => "• " + i.trim()).join("\n");
    setState(() {
      _activeProcessedText = formatted;
    });
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Dashboard Body
            Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: IndexedStack(
                    index: _activeTab,
                    children: [
                      _buildOverlayControlTab(),
                      _buildSmartClipboardTab(),
                      _buildFloatingToolsTab(),
                      _buildAmbientHUDTab(),
                    ],
                  ),
                ),
              ],
            ),

            // Simulated Floating Widget Overlay (Draggable on Screen)
            if (_isOverlayActive)
              Positioned(
                left: _bubblePosition.dx,
                top: _bubblePosition.dy,
                child: GestureDetecorWidget(),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activeTab,
        onTap: (index) => setState(() => _activeTab = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF151824),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.layers), label: 'HUD Control'),
          BottomNavigationBarItem(icon: Icon(Icons.content_copy), label: 'Clipboard'),
          BottomNavigationBarItem(icon: Icon(Icons.widgets), label: 'Quick Tools'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Ambient Monitor'),
        ],
      ),
    );
  }

  Widget GestureDetecorWidget() {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _bubblePosition = Offset(
            (_bubblePosition.dx + details.delta.dx).clamp(0.0, MediaQuery.of(context).size.width - 70),
            (_bubblePosition.dy + details.delta.dy).clamp(0.0, MediaQuery.of(context).size.height - 180),
          );
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: _isFloatingBubbleExpanded ? 280 : 64,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF222638).withOpacity(0.95),
          borderRadius: BorderRadius.circular(_isFloatingBubbleExpanded ? 20 : 32),
          border: Border.all(color: Colors.tealAccent.withOpacity(0.6), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.tealAccent.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: _isFloatingBubbleExpanded ? _buildExpandedBubbleContent() : _buildCompactBubbleContent(),
      ),
    );
  }

  Widget _buildCompactBubbleContent() {
    return InkWell(
      onTap: () => setState(() => _isFloatingBubbleExpanded = true),
      child: Container(
        height: 48,
        alignment: Alignment.center,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.touch_app, color: Colors.tealAccent, size: 24),
            SizedBox(width: 4),
            Icon(Icons.tune, color: Colors.white70, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedBubbleContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.widgets, color: Colors.tealAccent, size: 18),
                SizedBox(width: 6),
                Text(
                  "Omni HUD Float",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: Colors.grey),
              onPressed: () => setState(() => _isFloatingBubbleExpanded = false),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const Divider(color: Colors.white70, height: 12),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _buildMiniActionButton(Icons.copy, "Extract Email", Colors.blue, () {
              _extractEmails();
              _showMessage("Emails Extracted via HUD!");
            }),
            _buildMiniActionButton(Icons.calculate, "Quick Tip", Colors.amber, () {
              setState(() => _activeTab = 2);
              _showMessage("Opened Tip Tool!");
            }),
            _buildMiniActionButton(Icons.casino, "Picker", Colors.purple, () {
              setState(() => _activeTab = 2);
              _showMessage("Opened Decision Picker!");
            }),
            _buildMiniActionButton(Icons.volume_up, "Ambient sound", Colors.green, () {
              setState(() => _isPlayingSound = !_isPlayingSound);
            }),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(_isPlayingSound ? Icons.graphic_eq : Icons.music_note, color: Colors.tealAccent, size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _isPlayingSound ? "Playing: $_activeTrackShort" : "Ambient Sound Paused",
                  style: const TextStyle(fontSize: 10, color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  String get _activeTrackShort => _activeSoundTrack.length > 18 ? _activeSoundTrack.substring(0, 18) + "..." : _activeSoundTrack;

  Widget _buildMiniActionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF151824),
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
                  color: Colors.tealAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.tune, color: Colors.tealAccent, size: 22),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "OmniFloat HUD",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    "Active Ambient Companion",
                    style: TextStyle(fontSize: 11, color: Colors.tealAccent),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const Text("Overlay", style: TextStyle(fontSize: 12, color: Colors.white70)),
              Switch(
                value: _isOverlayActive,
                activeColor: Colors.tealAccent,
                onChanged: (val) {
                  setState(() {
                    _isOverlayActive = val;
                  });
                  _showMessage(val ? "Floating HUD Bubble Enabled!" : "Floating HUD Disabled");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- TAB 1: OVERLAY CONTROLS & PERMISSIONS ---
  Widget _buildOverlayControlTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeroBanner(),
        const SizedBox(height: 16),
        const Text(
          "Required App Permissions",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        _buildPermissionCard(
          "Display Over Other Apps",
          "Allows OmniFloat floating bubble to render over YouTube, Social Apps & Web Browsers.",
          Icons.layers,
          _permDisplayOverApps,
          (v) => setState(() => _permDisplayOverApps = v),
        ),
        _buildPermissionCard(
          "Notification HUD Access",
          "Shows ambient floating banner updates for instant 1-tap micro tasks.",
          Icons.notifications_active,
          _permNotifications,
          (v) => setState(() => _permNotifications = v),
        ),
        _buildPermissionCard(
          "Accessibility Floating Dock",
          "Enables quick side-swipe gesture drawer from any active mobile application.",
          Icons.touch_app,
          _permAccessibility,
          (v) => setState(() => _permAccessibility = v),
        ),
        const SizedBox(height: 16),
        const Text(
          "HUD Customization Options",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D2C),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white70),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Floating Bubble Transparency", style: TextStyle(color: Colors.white)),
                  Text("${(_bubblePosition.dx / 3).round()}%", style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: 0.85,
                backgroundColor: Colors.white70,
                color: Colors.tealAccent,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Auto-Dock to Screen Edge", style: TextStyle(color: Colors.white)),
                  Switch(
                    value: true,
                    onChanged: (v) {},
                    activeColor: Colors.tealAccent,
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade900, const Color(0xFF1A1D2C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bolt, color: Colors.amberAccent, size: 30),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Never Switch Apps Again!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  "Use the floating bubble on any screen to clean links, format text, decide meals, and calculate bills on the fly.",
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                  softWrap: true,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPermissionCard(String title, String desc, IconData icon, bool val, ValueChanged<bool> onChanged) {
    return Card(
      color: const Color(0xFF1A1D2C),
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.white70)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: val ? Colors.tealAccent : Colors.grey, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(desc, style: const TextStyle(fontSize: 10, color: Colors.white70), softWrap: true),
                ],
              ),
            ),
            Switch(
              value: val,
              onChanged: onChanged,
              activeColor: Colors.tealAccent,
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 2: SMART CLIPBOARD TRANSFORMER ---
  Widget _buildSmartClipboardTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Smart Clipboard Engine",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),
        const Text(
          "Automatic 1-click text cleaner and extractor for copied phone clipboard content.",
          style: TextStyle(fontSize: 11, color: Colors.white70),
        ),
        const SizedBox(height: 14),

        // Active Editable Snippet
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D2C),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.tealAccent.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Active Snippet Content", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                  IconButton(
                    icon: const Icon(Icons.share, size: 18, color: Colors.white70),
                    onPressed: () => _showMessage("Copied cleaned text to phone clipboard!"),
                  )
                ],
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _activeProcessedText,
                  style: const TextStyle(fontSize: 12, color: Colors.white, height: 1.4),
                  softWrap: true,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTransformChip("Extract Emails", Icons.email, Colors.blue, _extractEmails),
                  _buildTransformChip("Extract Numbers", Icons.phone, Colors.green, _extractNumbers),
                  _buildTransformChip("Clean Links", Icons.link_off, Colors.orange, _cleanLinks),
                  _buildTransformChip("Bullet List", Icons.format_list_bulleted, Colors.purple, _formatBulletPoints),
                ],
              )
            ],
          ),
        ),

        const SizedBox(height: 20),
        const Text("Clipboard History", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),

        ..._clipboardHistory.map((item) {
          return Card(
            color: const Color(0xFF1A1D2C),
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(item, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.white70)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.tealAccent),
              onTap: () {
                setState(() {
                  _activeProcessedText = item;
                });
                _showMessage("Loaded snippet into Smart Transformer!");
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTransformChip(String label, IconData icon, Color color, VoidCallback onTap) {
    return ActionChip(
      avatar: Icon(icon, size: 14, color: Colors.white),
      label: Text(label, style: const TextStyle(fontSize: 11, color: Colors.white)),
      backgroundColor: color.withOpacity(0.25),
      side: BorderSide(color: color.withOpacity(0.5)),
      onPressed: onTap,
    );
  }

  // --- TAB 3: FLOATING MULTI-TOOLS (DECISION WHEEL & TIP SPLITTER) ---
  Widget _buildFloatingToolsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Tool 1: Floating Decision Matrix
        _buildSectionHeader("Micro Decision Maker", "Can't decide? Let the overlay picker spin for you!"),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D2C),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.purpleAccent.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.purpleAccent.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.purpleAccent, width: 2),
                ),
                child: const Icon(Icons.casino, size: 40, color: Colors.purpleAccent),
              ),
              const SizedBox(height: 12),
              Text(
                _decisionResult,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: _decisionOptions
                    .map((opt) => Chip(
                          label: Text(opt, style: const TextStyle(fontSize: 10, color: Colors.white)),
                          backgroundColor: Colors.white70,
                          padding: EdgeInsets.zero,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 42),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text("Spin Random Decision", style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  final randomOpt = (_decisionOptions..shuffle()).first;
                  setState(() {
                    _decisionResult = "Selected: " + randomOpt;
                  });
                },
              )
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Tool 2: Tip & Bill Splitter Widget
        _buildSectionHeader("Quick Floating Bill Splitter", "Calculates tip & per-person split anywhere on screen."),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D2C),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.amberAccent.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Bill Amount", style: TextStyle(color: Colors.white70)),
                  Text("\$${_billAmount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
                ],
              ),
              Slider(
                value: _billAmount,
                min: 5.0,
                max: 300.0,
                activeColor: Colors.amberAccent,
                onChanged: (val) => setState(() => _billAmount = val),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tip: ${_tipPercentage.toInt()}%", style: const TextStyle(color: Colors.white70)),
                  Text("People: $_splitCount", style: const TextStyle(color: Colors.white70)),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _tipPercentage,
                      min: 0,
                      max: 30,
                      activeColor: Colors.tealAccent,
                      onChanged: (val) => setState(() => _tipPercentage = val),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.white70),
                    onPressed: _splitCount > 1 ? () => setState(() => _splitCount--) : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.tealAccent),
                    onPressed: () => setState(() => _splitCount++),
                  ),
                ],
              ),
              const Divider(color: Colors.white70, height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCalcSummaryCard("Tip Total", "\$${((_billAmount * _tipPercentage) / 100).toStringAsFixed(2)}", Colors.tealAccent),
                  _buildCalcSummaryCard("Per Person", "\$${((_billAmount * (1 + _tipPercentage / 100)) / _splitCount).toStringAsFixed(2)}", Colors.amberAccent),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCalcSummaryCard(String title, String val, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          const SizedBox(height: 4),
          Text(val, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  // --- TAB 4: AMBIENT MONITOR & SOUNDSCAPE HUD ---
  Widget _buildAmbientHUDTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader("Live Device Ambient HUD", "Real-time system telemetry preview overlay"),
        const SizedBox(height: 12),

        // System Gauges
        Row(
          children: [
            Expanded(child: _buildGaugeCard("Battery Health", "88% Charged", Icons.battery_charging_full, Colors.greenAccent, 0.88)),
            const SizedBox(width: 10),
            Expanded(child: _buildGaugeCard("RAM Usage", "3.2 GB / 8 GB", Icons.memory, Colors.blueAccent, 0.42)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildGaugeCard("Storage Space", "64% Used", Icons.sd_storage, Colors.orangeAccent, 0.64)),
            const SizedBox(width: 10),
            Expanded(child: _buildGaugeCard("FPS Refresh", "60 FPS Active", Icons.speed, Colors.purpleAccent, 1.0)),
          ],
        ),

        const SizedBox(height: 24),
        _buildSectionHeader("Ambient Sound Equalizer", "Background sound generator to stay focused while using overlay"),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D2C),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _isPlayingSound ? Colors.tealAccent : Colors.grey.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isPlayingSound ? Icons.volume_up : Icons.volume_off,
                      color: _isPlayingSound ? Colors.black : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _activeSoundTrack,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                        ),
                        Text(
                          _isPlayingSound ? "Playing background ambience..." : "Tap play to start ambient audio",
                          style: const TextStyle(fontSize: 10, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    iconSize: 36,
                    icon: Icon(_isPlayingSound ? Icons.pause_circle_filled : Icons.play_circle_fill, color: Colors.tealAccent),
                    onPressed: () {
                      setState(() {
                        _isPlayingSound = !_isPlayingSound;
                      });
                    },
                  )
                ],
              ),
              const SizedBox(height: 16),

              // Visual Equalizer Animation Mockup
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(12, (index) {
                  final heights = [12.0, 24.0, 36.0, 18.0, 30.0, 42.0, 20.0, 38.0, 14.0, 28.0, 32.0, 16.0];
                  final h = _isPlayingSound ? heights[index] : 8.0;
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300 + (index * 50)),
                    width: 8,
                    height: h,
                    decoration: BoxDecoration(
                      color: _isPlayingSound ? Colors.tealAccent : Colors.white70,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16),
              const Divider(color: Colors.white70),
              const SizedBox(height: 8),

              // Sound Track Selector
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTrackChoice("Lo-Fi Rain & Chill", Icons.water_drop),
                    _buildTrackChoice("Ocean Waves", Icons.waves),
                    _buildTrackChoice("Cafe Ambiance", Icons.local_cafe),
                    _buildTrackChoice("Deep Focus Noise", Icons.graphic_eq),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrackChoice(String name, IconData icon) {
    final isSelected = _activeSoundTrack == name;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        avatar: Icon(icon, size: 14, color: isSelected ? Colors.black : Colors.tealAccent),
        label: Text(name, style: TextStyle(fontSize: 11, color: isSelected ? Colors.black : Colors.white)),
        selected: isSelected,
        selectedColor: Colors.tealAccent,
        backgroundColor: Colors.white70,
        onSelected: (val) {
          if (val) {
            setState(() {
              _activeSoundTrack = name;
              _isPlayingSound = true;
            });
          }
        },
      ),
    );
  }

  Widget _buildGaugeCard(String title, String val, IconData icon, Color color, double progress) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 10, color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white70,
            color: color,
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
      ],
    );
  }
}