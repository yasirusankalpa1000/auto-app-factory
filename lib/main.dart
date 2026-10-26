import 'package:flutter/material.dart';

void main() {
  runApp(const DynamicDockApp());
}

class DynamicDockApp extends StatelessWidget {
  const DynamicDockApp({super.key});

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'DynamicDock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121218),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> meCreateState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentTabIndex = 0;

  // Floating Overlay State Variables
  bool _isOverlayEnabled = true;
  bool _showNotchStyle = true;
  bool _autoCleanClipboard = true;
  String _hudNotificationText = "DynamicDock active in background";
  
  // Unit Deal Calculator State
  final TextEditingController _item1PriceController = TextEditingController(text: "4.50");
  final TextEditingController _item1QtyController = TextEditingController(text: "400");
  final TextEditingController _item2PriceController = TextEditingController(text: "7.20");
  final TextEditingController _item2QtyController = TextEditingController(text: "750");

  // Text Sanitizer State
  final TextEditingController _textInputController = TextEditingController();
  String _sanitizedResult = "";

  // Quick Snippets State
  final List<String> _snippets = [
    "Meeting link: https://meet.example.com/xyz",
    "WiFi Pass: SecureGuest2025!",
  ];

  // Decision Tool State
  final TextEditingController _decisionController = TextEditingController();
  final List<String> _decisionOptions = ["Option A", "Option B"];
  String _pickedDecision = "";

  @override
  void dispose() {
    _item1PriceController.dispose();
    _item1QtyController.dispose();
    _item2PriceController.dispose();
    _item2QtyController.dispose();
    _textInputController.dispose();
    _decisionController.dispose();
    super.dispose();
  }

  void _sanitizeText(String mode) {
    String original = _textInputController.text;
    if (original.isEmpty) return;

    setState(() {
      if (mode == "strip_urls") {
        // Strip query params from URLs
        _sanitizedResult = original.replaceAll(RegExp(r'\?utm_[^&\s]+'), '')
                                  .replaceAll(RegExp(r'\?si=[^&\s]+'), '')
                                  .replaceAll(RegExp(r'&fbclid=[^&\s]+'), '');
      } else if (mode == "uppercase") {
        _sanitizedResult = original.toUpperCase();
      } else if (mode == "lowercase") {
        _sanitizedResult = original.toLowerCase();
      } else if (mode == "bullets") {
        List<String> lines = original.split('\n');
        _sanitizedResult = lines.map((l) => l.trim().startsWith('•') ? l : "• ${l.trim()}").join('\n');
      }
    });
  }

  void _addSnippet(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _snippets.insert(0, text.trim());
      _textInputController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Saved to Dynamic Clip Deck!")),
    );
  }

  void _makeDecision() {
    if (_decisionOptions.isEmpty) return;
    setState(() {
      final randomIndex = (DateTime.now().millisecondsSinceEpoch) % _decisionOptions.length;
      _pickedDecision = _decisionOptions[randomIndex];
    });
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
                Expanded(
                  child: IndexedStack(
                    index: _currentTabIndex,
                    children: [
                      _buildFloatingHudTab(),
                      _buildUnitCalculatorTab(),
                      _buildTextSanitizerTab(),
                      _buildDecisionMatrixTab(),
                    ],
                  ),
                ),
              ],
            ),
            if (_isOverlayEnabled) _buildSimulatedFloatingPill(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1E1E28),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'HUD Deck',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Deal Finder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: 'Clip Sanitizer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Decide Now',
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E28),
        border: Border(bottom: BorderSide(color: Colors.white70, width: 1.0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Icon(Icons.widgets, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "DynamicDock",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "Floating Utility & Context Assistant",
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _isOverlayEnabled ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isOverlayEnabled ? Colors.green : Colors.red,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 4,
                  backgroundColor: _isOverlayEnabled ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 6),
                Text(
                  _isOverlayEnabled ? "HUD Active" : "Disabled",
                  style: TextStyle(
                    color: _isOverlayEnabled ? Colors.green : Colors.red,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulatedFloatingPill() {
    return Positioned(
      top: 10,
      left: 20,
      right: 20,
      child: Material(
        elevation: 8,
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A38),
            borderRadius: BorderRadius.circular(_showNotchStyle ? 25 : 12),
            border: Border.all(color: Colors.deepPurpleAccent, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.bolt, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _hudNotificationText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _hudNotificationText = "Clip deck synced!";
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Quick Sync",
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingHudTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Overlay & Dock System Controls",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            "Configure floating notifications and quick-access permissions for system overlay simulation.",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Permissions Status Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E28),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              children: [
                _buildPermissionRow(
                  icon: Icons.layers,
                  title: "Display Over Other Apps",
                  subtitle: "Allows HUD widgets to stay on top while shopping or chatting",
                  value: _isOverlayEnabled,
                  onChanged: (val) {
                    setState(() {
                      _isOverlayEnabled = val;
                    });
                  },
                ),
                const Divider(color: Colors.white70, height: 20),
                _buildPermissionRow(
                  icon: Icons.notifications_active,
                  title: "Floating Active Banner",
                  subtitle: "Displays instant clipboard and deal action alerts",
                  value: _showNotchStyle,
                  onChanged: (val) {
                    setState(() {
                      _showNotchStyle = val;
                    });
                  },
                ),
                const Divider(color: Colors.white70, height: 20),
                _buildPermissionRow(
                  icon: Icons.content_paste,
                  title: "Auto-Sanitize Clipboard",
                  subtitle: "Automatically strips tracking params when copying links",
                  value: _autoCleanClipboard,
                  onChanged: (val) {
                    setState(() {
                      _autoCleanClipboard = val;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "Floating Notification Banner Test",
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _hudNotificationText = "Deal Alert: Item A is 18.5% cheaper!";
                  });
                },
                icon: const Icon(Icons.monetization_on, size: 16),
                label: const Text("Simulate Deal Alert"),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _hudNotificationText = "Clipboard Cleaned: 1 tracking link stripped";
                  });
                },
                icon: const Icon(Icons.cleaning_services, size: 16),
                label: const Text("Simulate Link Clean"),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _hudNotificationText = "Decision Ready: Option A selected!";
                  });
                },
                icon: const Icon(Icons.psychology, size: 16),
                label: const Text("Simulate Decision"),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Text(
            "Active Dynamic Deck Snippets",
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (_snippets.isEmpty)
            const Text("No saved snippets yet. Add from the Clip Sanitizer tab!", style: TextStyle(color: Colors.grey, fontSize: 12))
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _snippets.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color(0xFF1E1E28),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    dense: true,
                    leading: const Icon(Icons.bookmark, color: Colors.deepPurpleAccent, size: 18),
                    title: Text(
                      _snippets[index],
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey, size: 18),
                      onPressed: () {
                        setState(() {
                          _snippets.removeAt(index);
                        });
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

  Widget _buildPermissionRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurpleAccent, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11), softWrap: true),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.deepPurpleAccent,
        ),
      ],
    );
  }

  Widget _buildUnitCalculatorTab() {
    double p1 = double.tryParse(_item1PriceController.text) ?? 0.0;
    double q1 = double.tryParse(_item1QtyController.text) ?? 1.0;
    double p2 = double.tryParse(_item2PriceController.text) ?? 0.0;
    double q2 = double.tryParse(_item2QtyController.text) ?? 1.0;

    double unit1 = q1 > 0 ? (p1 / q1) : 0.0;
    double unit2 = q2 > 0 ? (p2 / q2) : 0.0;

    String resultText = "Enter prices and quantities to compare";
    Color resultColor = Colors.grey;

    if (unit1 > 0 && unit2 > 0) {
      if (unit1 < unit2) {
        double diff = ((unit2 - unit1) / unit2) * 100;
        resultText = "Option A is ${diff.toStringAsFixed(1)}% cheaper per unit!";
        resultColor = Colors.green;
      } else if (unit2 < unit1) {
        double diff = ((unit1 - unit2) / unit1) * 100;
        resultText = "Option B is ${diff.toStringAsFixed(1)}% cheaper per unit!";
        resultColor = Colors.green;
      } else {
        resultText = "Both options have equal unit cost!";
        resultColor = Colors.blue;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Smart Deal & Unit Cost Finder",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Instantly solve grocery & shopping pricing tricks (e.g., 500g vs 750g pack).",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(child: _buildItemCard("Option A", _item1PriceController, _item1QtyController, unit1)),
              const SizedBox(width: 12),
              Expanded(child: _buildItemCard("Option B", _item2PriceController, _item2QtyController, unit2)),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E28),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: resultColor, width: 1.5),
            ),
            child: Column(
              children: [
                Icon(Icons.stars, color: resultColor, size: 28),
                const SizedBox(height: 8),
                Text(
                  resultText,
                  style: TextStyle(color: resultColor, fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Option A Unit: \$${unit1.toStringAsFixed(4)} / unit\nOption B Unit: \$${unit2.toStringAsFixed(4)} / unit",
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(
    String title,
    TextEditingController priceCtrl,
    TextEditingController qtyCtrl,
    double unitPrice,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E28),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          TextField(
            controller: priceCtrl,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: const InputDecoration(
              labelText: "Price (\$)",
              labelStyle: TextStyle(color: Colors.grey, fontSize: 11),
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: qtyCtrl,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: const InputDecoration(
              labelText: "Qty / Weight (g/ml)",
              labelStyle: TextStyle(color: Colors.grey, fontSize: 11),
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 10),
          Text(
            "Unit: \$${unitPrice.toStringAsFixed(4)}",
            style: const TextStyle(color: Colors.deepPurpleAccent, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTextSanitizerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Clipboard Sanitizer & Formatter",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Strip annoying URL tracking codes, convert text styles, or quickly format lists.",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _textInputController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: const InputDecoration(
              hintText: "Paste link or text block here...",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
              border: OutlineInputBorder(),
              fillColor: Color(0xFF1E1E28),
              filled: true,
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                onPressed: () => _sanitizeText("strip_urls"),
                icon: const Icon(Icons.cleaning_services, size: 14),
                label: const Text("Clean Tracking URLs"),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                onPressed: () => _sanitizeText("bullets"),
                icon: const Icon(Icons.format_list_bulleted, size: 14),
                label: const Text("Make Bullet List"),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white),
                onPressed: () => _sanitizeText("uppercase"),
                icon: const Icon(Icons.text_fields, size: 14),
                label: const Text("UPPERCASE"),
              ),
            ],
          ),

          const SizedBox(height: 20),

          if (_sanitizedResult.isNotEmpty) ...[
            const Text("Sanitized Output:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E28),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.deepPurpleAccent),
              ),
              child: SelectableText(
                _sanitizedResult,
                style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              onPressed: () => _addSnippet(_sanitizedResult),
              icon: const Icon(Icons.add, size: 16),
              label: const Text("Save to Clip Deck"),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDecisionMatrixTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "30-Second Decision Resolver",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Stuck on simple daily choices? Add choices and let the decision deck pick for you.",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _decisionController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(
                    hintText: "Add option (e.g. Pizza, Salad)",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                onPressed: () {
                  if (_decisionController.text.trim().isNotEmpty) {
                    setState(() {
                      _decisionOptions.add(_decisionController.text.trim());
                      _decisionController.clear();
                    });
                  }
                },
                child: const Text("Add"),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _decisionOptions.map((opt) {
              return Chip(
                backgroundColor: const Color(0xFF1E1E28),
                side: const BorderSide(color: Colors.white70),
                label: Text(opt, style: const TextStyle(color: Colors.white, fontSize: 12)),
                deleteIcon: const Icon(Icons.close, size: 14, color: Colors.grey),
                onDeleted: () {
                  setState(() {
                    _decisionOptions.remove(opt);
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _makeDecision,
              icon: const Icon(Icons.casino),
              label: const Text("Pick Decision Now", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),

          if (_pickedDecision.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E28),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber, width: 2),
              ),
              child: Column(
                children: [
                  const Icon(Icons.lightbulb, color: Colors.amber, size: 36),
                  const SizedBox(height: 8),
                  const Text("Selected Choice:", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    _pickedDecision,
                    style: const TextStyle(color: Colors.amber, fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}