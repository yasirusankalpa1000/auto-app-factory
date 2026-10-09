import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const OmniDockApp());
}

class OmniDockApp extends StatelessWidget {
  const OmniDockApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'OmniDock Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        cardTheme: CardTheme(
          color: const Color(0xFF1E293B),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const MainDockScreen(),
    );
  }
}

class MainDockScreen extends StatefulWidget {
  const MainDockScreen({Key? key}) : super(key: key);

  @override
  State<MainDockScreen> createState() => _MainDockScreenState();
}

class _MainDockScreenState extends State<MainDockScreen> {
  int _currentTabIndex = 0;

  // Floating Overlay Bubble State
  double _bubbleX = 20.0;
  double _bubbleY = 180.0;
  bool _isBubbleExpanded = false;

  // Simulated Overlay System Permissions Toggles
  bool _overlayPermGranted = true;
  bool _notificationPermGranted = true;
  bool _autoCleanClipboard = true;

  // Stats Counters to keep users engaged
  int _tasksCompletedToday = 14;
  int _timeSavedMinutes = 38;
  int _clipsProcessed = 29;

  // Notification Banner Floating Simulation
  bool _showFloatingBanner = false;
  String _bannerTitle = '';
  String _bannerMessage = '';

  void _triggerFloatingBanner(String title, String message) {
    setState(() {
      _bannerTitle = title;
      _bannerMessage = message;
      _showFloatingBanner = true;
      _tasksCompletedToday++;
      _timeSavedMinutes += 2;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showFloatingBanner = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Main Body Screen Content based on selected tab
          SafeArea(
            child: IndexedStack(
              index: _currentTabIndex,
              children: [
                _buildFloatingDockHub(screenSize),
                _buildTextAndClipboardsHub(),
                _buildMicroCalculatorsHub(),
                _buildMicroDecisionAndStatsHub(),
              ],
            ),
          ),

          // Floating System Banner Simulation (Notification Overlay)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutBack,
            top: _showFloatingBanner ? 50.0 : -120.0,
            left: 16.0,
            right: 16.0,
            child: Material(
              elevation: 12,
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFF312E81),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
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
                      child: const Icon(Icons.bolt, color: Colors.amber, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _bannerTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _bannerMessage,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70, size: 18),
                      onPressed: () {
                        setState(() {
                          _showFloatingBanner = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Interactive Draggable Floating Assist Bubble (Overlay Simulator)
          Positioned(
            left: _bubbleX,
            top: _bubbleY,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _bubbleX = (_bubbleX + details.delta.dx).clamp(10.0, screenSize.width - 70.0);
                  _bubbleY = (_bubbleY + details.delta.dy).clamp(60.0, screenSize.height - 140.0);
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
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.indigoAccent, Colors.purpleAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purpleAccent.withOpacity(0.5),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        _isBubbleExpanded ? Icons.close : Icons.widgets,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),

                  // Floating Quick Palette when Bubble tapped
                  if (_isBubbleExpanded) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: 170,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1B4B),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.indigoAccent, width: 1.5),
                        boxShadow: const [
                          BoxShadow(color: Colors.black87, blurRadius: 10),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Instant Dock Utility",
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(color: Colors.white70, height: 12),
                          _buildBubbleActionItem(
                            icon: Icons.cleaning_services,
                            label: "Quick Clean Text",
                            onTap: () {
                              _triggerFloatingBanner("Clipboard Cleaned", "Removed HTML tags and excess spacing!");
                              setState(() => _isBubbleExpanded = false);
                            },
                          ),
                          _buildBubbleActionItem(
                            icon: Icons.calculate,
                            label: "Split Bill Quick",
                            onTap: () {
                              setState(() {
                                _currentTabIndex = 2;
                                _isBubbleExpanded = false;
                              });
                            },
                          ),
                          _buildBubbleActionItem(
                            icon: Icons.psychology,
                            label: "Decide For Me",
                            onTap: () {
                              setState(() {
                                _currentTabIndex = 3;
                                _isBubbleExpanded = false;
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

      // Bottom Navigation Bar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTabIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentTabIndex = index;
            _isBubbleExpanded = false;
          });
        },
        backgroundColor: const Color(0xFF0F172A),
        indicatorColor: Colors.indigo,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.layers, color: Colors.white70),
            selectedIcon: Icon(Icons.layers, color: Colors.amber),
            label: 'Overlay Dock',
          ),
          NavigationDestination(
            icon: Icon(Icons.cleaning_services, color: Colors.white70),
            selectedIcon: Icon(Icons.cleaning_services, color: Colors.amber),
            label: 'Text & Clips',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate, color: Colors.white70),
            selectedIcon: Icon(Icons.calculate, color: Colors.amber),
            label: 'Micro Calcs',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome, color: Colors.white70),
            selectedIcon: Icon(Icons.auto_awesome, color: Colors.amber),
            label: 'Decision Hub',
          ),
        ],
      ),
    );
  }

  Widget _buildBubbleActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.tealAccent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: Floating Overlay Control & System Dock
  Widget _buildFloatingDockHub(Size screenSize) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF311B92), Color(0xFF1A237E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.indigoAccent.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.touch_app, color: Colors.amber, size: 28),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "OmniDock Assist Active",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Drag floating bubble anywhere on screen",
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildHeaderBadge(Icons.timer, "\$ saved: Unlimited"),
                    _buildHeaderBadge(Icons.bolt, "Tasks: $_tasksCompletedToday done"),
                    _buildHeaderBadge(Icons.shield, "Permissions: Active"),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            "System Overlay & Dock Settings",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          // Permissions Controls
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: _overlayPermGranted,
                  activeColor: Colors.tealAccent,
                  title: const Text("Display Over Other Apps", style: TextStyle(fontSize: 14)),
                  subtitle: const Text("Keep smart bubble on screen while using any app", style: TextStyle(fontSize: 11, color: Colors.grey)),
                  onChanged: (val) {
                    setState(() => _overlayPermGranted = val);
                    _triggerFloatingBanner("Overlay Status Changed", val ? "Floating Dock Overlay Enabled" : "Floating Overlay Hidden");
                  },
                ),
                const Divider(height: 1, color: Colors.white70),
                SwitchListTile(
                  value: _notificationPermGranted,
                  activeColor: Colors.tealAccent,
                  title: const Text("Dynamic Floating Notification Trigger", style: TextStyle(fontSize: 14)),
                  subtitle: const Text("Push instant banner alerts for pinned clips & quick tasks", style: TextStyle(fontSize: 11, color: Colors.grey)),
                  onChanged: (val) {
                    setState(() => _notificationPermGranted = val);
                  },
                ),
                const Divider(height: 1, color: Colors.white70),
                SwitchListTile(
                  value: _autoCleanClipboard,
                  activeColor: Colors.tealAccent,
                  title: const Text("Auto-Sanitize Messy Copy Clips", style: TextStyle(fontSize: 14)),
                  subtitle: const Text("Strips HTML tags & extra whitespace automatically", style: TextStyle(fontSize: 11, color: Colors.grey)),
                  onChanged: (val) {
                    setState(() => _autoCleanClipboard = val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            "Floating Banner Launcher Test",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Test high-priority dynamic banners that appear while multitasking:",
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.notifications_active, size: 16),
                        label: const Text("Trigger Price Alert"),
                        onPressed: () => _triggerFloatingBanner("Price Drop Detected!", "Item on Amazon dropped by \$15.00 now!"),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text("Pinned Text Clip"),
                        onPressed: () => _triggerFloatingBanner("Pinned Clip Ready", "Saved Email: john.doe@example.com (Copied!)"),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.local_offer, size: 16),
                        label: const Text("Discount Summary"),
                        onPressed: () => _triggerFloatingBanner("Stacked Savings Saved", "Final Price: \$42.50 (You saved \$17.50)"),
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

  Widget _buildHeaderBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.tealAccent),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }

  // TAB 2: Text Sanitizer & Smart Clip Transformer
  Widget _buildTextAndClipboardsHub() {
    return const TextTransformerWidget();
  }

  // TAB 3: Micro Calculators Suite
  Widget _buildMicroCalculatorsHub() {
    return const MicroCalculatorsWidget();
  }

  // TAB 4: Decision Hub & User Efficiency Matrix
  Widget _buildMicroDecisionAndStatsHub() {
    return DecisionAndStatsWidget(
      completedCount: _tasksCompletedToday,
      timeSaved: _timeSavedMinutes,
      clipsProcessed: _clipsProcessed,
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 2 IMPLEMENTATION: SMART TEXT SANITIZER & EXPANDER SHORTCUTS
// -----------------------------------------------------------------------------
class TextTransformerWidget extends StatefulWidget {
  const TextTransformerWidget({Key? key}) : super(key: key);

  @override
  State<TextTransformerWidget> createState() => _TextTransformerWidgetState();
}

class _TextTransformerWidgetState extends State<TextTransformerWidget> {
  final TextEditingController _inputController = TextEditingController(
    text: "   Hello  <b>World</b>! Contact support at support@omnidock.app or call +18005550199.  Check https://omnidock.app  ",
  );

  String _extractedEmails = '';
  String _extractedPhones = '';
  String _extractedUrls = '';
  String _cleanedResult = '';

  final List<String> _savedClips = [
    "OmniDock Pro License Code: OMNI-8892-X12",
    "john.developer@service.io",
    "Please find attached invoice for \$120.00 USD",
  ];

  @override
  void initState() {
    super.initState();
    _analyzeText();
  }

  void _analyzeText() {
    final raw = _inputController.text;

    // Email regex
    final emailRegExp = RegExp(r'[a-zA-Z0-9.\_%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    final emails = emailRegExp.allMatches(raw).map((m) => m.group(0)).whereType<String>().toList();

    // Phone regex
    final phoneRegExp = RegExp(r'\+?[0-9]{10,14}');
    final phones = phoneRegExp.allMatches(raw).map((m) => m.group(0)).whereType<String>().toList();

    // URL regex
    final urlRegExp = RegExp(r'https?://[^\s]+');
    final urls = urlRegExp.allMatches(raw).map((m) => m.group(0)).whereType<String>().toList();

    setState(() {
      _extractedEmails = emails.isNotEmpty ? emails.join(', ') : 'None found';
      _extractedPhones = phones.isNotEmpty ? phones.join(', ') : 'None found';
      _extractedUrls = urls.isNotEmpty ? urls.join(', ') : 'None found';
      _cleanedResult = raw;
    });
  }

  void _stripHtml() {
    final exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    setState(() {
      _cleanedResult = _inputController.text.replaceAll(exp, '');
      _inputController.text = _cleanedResult;
    });
    _analyzeText();
  }

  void _cleanWhitespace() {
    setState(() {
      _cleanedResult = _inputController.text.replaceAll(RegExp(r'\s+'), ' ').trim();
      _inputController.text = _cleanedResult;
    });
    _analyzeText();
  }

  void _convertCase(String mode) {
    String txt = _inputController.text;
    if (mode == 'UPPER') txt = txt.toUpperCase();
    if (mode == 'lower') txt = txt.toLowerCase();
    if (mode == 'Title') {
      txt = txt.split(' ').map((word) {
        if (word.isEmpty) return '';
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join(' ');
    }
    setState(() {
      _cleanedResult = txt;
      _inputController.text = txt;
    });
    _analyzeText();
  }

  void _saveCurrentClip() {
    if (_inputController.text.trim().isNotEmpty) {
      setState(() {
        _savedClips.insert(0, _inputController.text.trim());
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Clip pinned to OmniDock Stack!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Smart Clipboard & Text Sanitizer",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            "Clean messy web text, strip HTML, extract emails & numbers instantly.",
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 14),

          // Text Input Box
          TextField(
            controller: _inputController,
            maxLines: 4,
            style: const TextStyle(fontSize: 13, color: Colors.white),
            onChanged: (_) => _analyzeText(),
            decoration: InputDecoration(
              hintText: "Paste messy text here...",
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.indigoAccent),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Action Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                avatar: const Icon(Icons.code, size: 14, color: Colors.amber),
                label: const Text("Strip HTML Tags"),
                onPressed: _stripHtml,
              ),
              ActionChip(
                avatar: const Icon(Icons.cleaning_services, size: 14, color: Colors.tealAccent),
                label: const Text("Fix Spaces & Lines"),
                onPressed: _cleanWhitespace,
              ),
              ActionChip(
                avatar: const Icon(Icons.text_fields, size: 14, color: Colors.lightBlueAccent),
                label: const Text("UPPERCASE"),
                onPressed: () => _convertCase('UPPER'),
              ),
              ActionChip(
                avatar: const Icon(Icons.text_format, size: 14, color: Colors.lightGreenAccent),
                label: const Text("Title Case"),
                onPressed: () => _convertCase('Title'),
              ),
              ActionChip(
                avatar: const Icon(Icons.push_pin, size: 14, color: Colors.orangeAccent),
                label: const Text("Pin to Stack"),
                onPressed: _saveCurrentClip,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Extracted Regex Data View
          const Text(
            "Auto-Extracted Data Streams",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.amber),
          ),
          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  _buildExtractorRow(Icons.email, "Emails Detected", _extractedEmails),
                  const Divider(color: Colors.white70),
                  _buildExtractorRow(Icons.phone, "Phone Numbers", _extractedPhones),
                  const Divider(color: Colors.white70),
                  _buildExtractorRow(Icons.link, "URLs & Web Links", _extractedUrls),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Pinned Clipboard Stack
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Pinned Clips Stack",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                "${_savedClips.length} items",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _savedClips.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                color: const Color(0xFF1E1B4B),
                child: ListTile(
                  dense: true,
                  title: Text(
                    _savedClips[index],
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18, color: Colors.tealAccent),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Copied: ${_savedClips[index]}")),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18, color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            _savedClips.removeAt(index);
                          });
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

  Widget _buildExtractorRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.indigoAccent),
        const SizedBox(width: 10),
        SizedBox(
          width: 120,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: value.contains('None') ? Colors.grey : Colors.tealAccent,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 3 IMPLEMENTATION: VISUAL MICRO CALCULATORS SUITE
// -----------------------------------------------------------------------------
class MicroCalculatorsWidget extends StatefulWidget {
  const MicroCalculatorsWidget({Key? key}) : super(key: key);

  @override
  State<MicroCalculatorsWidget> createState() => _MicroCalculatorsWidgetState();
}

class _MicroCalculatorsWidgetState extends State<MicroCalculatorsWidget> {
  int _selectedCalcMode = 0; // 0: Bill Splitter, 1: Discount Stack, 2: Unit Quick Ratio

  // Splitter fields
  final TextEditingController _billAmountController = TextEditingController(text: "85.00");
  double _tipPercent = 15.0;
  int _personCount = 3;

  // Discount fields
  final TextEditingController _origPriceController = TextEditingController(text: "120.00");
  double _discount1 = 20.0;
  double _discount2 = 10.0; // Stacked extra promo
  double _taxPercent = 8.0;

  // Unit converter fields
  final TextEditingController _unitValueController = TextEditingController(text: "10");
  String _unitCategory = 'Length (m to ft)';
  double _unitResult = 32.8084;

  void _recalculateUnits() {
    double val = double.tryParse(_unitValueController.text) ?? 0.0;
    setState(() {
      if (_unitCategory == 'Length (m to ft)') {
        _unitResult = val * 3.28084;
      } else if (_unitCategory == 'Weight (kg to lbs)') {
        _unitResult = val * 2.20462;
      } else if (_unitCategory == 'Data (GB to MB)') {
        _unitResult = val * 1024.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Micro-Utility Studio",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            "Zero-friction calculators designed for instant daily micro-decisions.",
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 14),

          // Calc Mode Segment Selector
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Text("Split Bill & Tip", style: TextStyle(fontSize: 11)),
                  selected: _selectedCalcMode == 0,
                  selectedColor: Colors.indigo,
                  onSelected: (val) => setState(() => _selectedCalcMode = 0),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ChoiceChip(
                  label: const Text("Discount Stack", style: TextStyle(fontSize: 11)),
                  selected: _selectedCalcMode == 1,
                  selectedColor: Colors.indigo,
                  onSelected: (val) => setState(() => _selectedCalcMode = 1),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ChoiceChip(
                  label: const Text("Unit Quick Ratio", style: TextStyle(fontSize: 11)),
                  selected: _selectedCalcMode == 2,
                  selectedColor: Colors.indigo,
                  onSelected: (val) => setState(() => _selectedCalcMode = 2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (_selectedCalcMode == 0) _buildSplitterSection(),
          if (_selectedCalcMode == 1) _buildDiscountSection(),
          if (_selectedCalcMode == 2) _buildUnitSection(),
        ],
      ),
    );
  }

  Widget _buildSplitterSection() {
    double bill = double.tryParse(_billAmountController.text) ?? 0.0;
    double totalTip = bill * (_tipPercent / 100);
    double totalBill = bill + totalTip;
    double perPerson = _personCount > 0 ? totalBill / _personCount : totalBill;

    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _billAmountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: "Total Bill Amount (\$) ",
                    labelStyle: TextStyle(color: Colors.amber),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tip Percentage: ${_tipPercent.toInt()}%", style: const TextStyle(color: Colors.white)),
                    Text("Tip: \$${totalTip.toStringAsFixed(2)}", style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: _tipPercent,
                  min: 0,
                  max: 35,
                  divisions: 35,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) => setState(() => _tipPercent = val),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Split Among People: $_personCount", style: const TextStyle(color: Colors.white)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.amber),
                          onPressed: () {
                            if (_personCount > 1) setState(() => _personCount--);
                          },
                        ),
                        Text("$_personCount", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.amber),
                          onPressed: () => setState(() => _personCount++),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Split Summary Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF065F46), Color(0xFF047857)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const Text("EACH PERSON PAYS", style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1.2)),
              const SizedBox(height: 6),
              FittedBox(
                child: Text(
                  "\$${perPerson.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Total with Tip: \$${totalBill.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountSection() {
    double orig = double.tryParse(_origPriceController.text) ?? 0.0;
    double afterDisc1 = orig * (1 - _discount1 / 100);
    double afterDisc2 = afterDisc1 * (1 - _discount2 / 100);
    double finalPrice = afterDisc2 * (1 + _taxPercent / 100);
    double totalSaved = orig - afterDisc2;

    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _origPriceController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: "Original Item Price (\$) ",
                    labelStyle: TextStyle(color: Colors.amber),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Text("Primary Discount: ${_discount1.toInt()}%", style: const TextStyle(color: Colors.white)),
                Slider(
                  value: _discount1,
                  min: 0,
                  max: 90,
                  divisions: 18,
                  activeColor: Colors.amber,
                  onChanged: (val) => setState(() => _discount1 = val),
                ),
                Text("Extra Stacked Promo Coupon: ${_discount2.toInt()}%", style: const TextStyle(color: Colors.white)),
                Slider(
                  value: _discount2,
                  min: 0,
                  max: 50,
                  divisions: 10,
                  activeColor: Colors.purpleAccent,
                  onChanged: (val) => setState(() => _discount2 = val),
                ),
                Text("Estimated Sales Tax: ${_taxPercent.toStringAsFixed(1)}%", style: const TextStyle(color: Colors.white)),
                Slider(
                  value: _taxPercent,
                  min: 0,
                  max: 20,
                  divisions: 20,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) => setState(() => _taxPercent = val),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Discount Results Box
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF831843), Color(0xFF9D174D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("FINAL OUT-OF-POCKET PRICE:", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text(
                    "\$${finalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.amber, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(color: Colors.white70, height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("TOTAL DISCOUNT SAVED:", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text(
                    "\$${totalSaved.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.tealAccent, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUnitSection() {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: _unitCategory,
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Select Conversion Dock",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Length (m to ft)', child: Text('Length (Meters -> Feet)')),
                    DropdownMenuItem(value: 'Weight (kg to lbs)', child: Text('Weight (Kilograms -> Pounds)')),
                    DropdownMenuItem(value: 'Data (GB to MB)', child: Text('Data Storage (GB -> MB)')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _unitCategory = val;
                      });
                      _recalculateUnits();
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _unitValueController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  onChanged: (_) => _recalculateUnits(),
                  decoration: const InputDecoration(
                    labelText: "Input Quantity",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1B4B),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.indigoAccent),
          ),
          child: Column(
            children: [
              const Text("CONVERTED EQUIVALENT", style: TextStyle(color: Colors.grey, fontSize: 11, letterSpacing: 1.1)),
              const SizedBox(height: 8),
              FittedBox(
                child: Text(
                  _unitResult.toStringAsFixed(2),
                  style: const TextStyle(color: Colors.tealAccent, fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _unitCategory,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 4 IMPLEMENTATION: MICRO DECISION RANDOMIZER & ENGAGEMENT HUB
// -----------------------------------------------------------------------------
class DecisionAndStatsWidget extends StatefulWidget {
  final int completedCount;
  final int timeSaved;
  final int clipsProcessed;

  const DecisionAndStatsWidget({
    Key? key,
    required this.completedCount,
    required this.timeSaved,
    required this.clipsProcessed,
  }) : super(key: key);

  @override
  State<DecisionAndStatsWidget> createState() => _DecisionAndStatsWidgetState();
}

class _DecisionAndStatsWidgetState extends State<DecisionAndStatsWidget> {
  final List<String> _decisionOptions = [
    "Do Task Now (5 Min Rule)",
    "Delegate or Postpone",
    "Take 10 Min Power Break",
    "Quick Hydrate & Water Reset",
    "Archive and Skip",
  ];

  String _currentDecision = "Tap 'Spin Decision Wheel' below!";
  bool _isSpinning = false;

  void _spinWheel() {
    setState(() {
      _isSpinning = true;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        final rand = math.Random();
        setState(() {
          _currentDecision = _decisionOptions[rand.nextInt(_decisionOptions.length)];
          _isSpinning = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Micro-Decision & Productivity Hub",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            "Eliminate decision paralysis with instant wheel resolution & dynamic metrics.",
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 16),

          // Micro Decision Wheel Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF311B92), Color(0xFF4A148C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.purpleAccent.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                const Icon(Icons.psychology, size: 36, color: Colors.amber),
                const SizedBox(height: 8),
                const Text(
                  "Indecision Resolver Wheel",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withOpacity(0.6)),
                  ),
                  child: Text(
                    _isSpinning ? "Spinning micro-choices..." : _currentDecision,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _isSpinning ? Colors.grey : Colors.amber,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text("Spin Decision Wheel", style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: _isSpinning ? null : _spinWheel,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // User Lifetime Efficiency Dashboard
          const Text(
            "Your Daily Efficiency Impact",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.bolt,
                  title: "Micro-Tasks",
                  value: "${widget.completedCount}",
                  subtitle: "Completed Today",
                  color: Colors.amber,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.timer,
                  title: "Time Saved",
                  value: "${widget.timeSaved}m",
                  subtitle: "Workflow Boost",
                  color: Colors.tealAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.content_paste,
                  title: "Clips Cleaned",
                  value: "${widget.clipsProcessed}",
                  subtitle: "Sans HTML / Spaces",
                  color: Colors.lightBlueAccent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.monetization_on,
                  title: "Micro Calcs",
                  value: "\$14.20",
                  subtitle: "Avg Split Tip Saved",
                  color: Colors.lightGreenAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }
}