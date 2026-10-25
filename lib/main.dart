import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ClipDeckApp());
}

class ClipDeckApp extends StatelessWidget {
  const ClipDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClipDeck Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
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

  // Floating Overlay State
  bool _isOverlayEnabled = true;
  Offset _bubblePosition = const Offset(20, 200);
  bool _isExpandedDock = false;

  // Stats
  int _clipsProcessed = 14;
  int _secondsSaved = 420;
  int _snippetsUsed = 28;

  // Working text input
  final TextEditingController _inputController = TextEditingController(
    text: "Check out this deal! https://shop.example.com/product/992?utm_source=facebook&utm_medium=cpc&affiliate_id=98765 Price is \$49.99! Call +1 555-0199 for inquiry.",
  );

  // Extracted Data
  String _cleanedUrl = "";
  List<String> _extractedPhones = [];
  List<String> _extractedEmails = [];
  List<String> _extractedPrices = [];

  // Quick Snippets
  final List<Map<String, String>> _snippets = [
    {
      "title": "Delivery Address",
      "category": "Personal",
      "content": "742 Evergreen Terrace, Springfield, OR 97477"
    },
    {
      "title": "Quick Reply: Busy",
      "category": "Work",
      "content": "In a meeting right now. Will call you back in 30 minutes!"
    },
    {
      "title": "Bank Transfer Info",
      "category": "Finance",
      "content": "Bank: Global Apex | Acc: 4092-8810-1123 | Routing: 021000089"
    },
    {
      "title": "Freelance Pitch Tagline",
      "category": "Work",
      "content": "High-conversion Flutter developer & UI designer available for sprint projects!"
    },
  ];

  // Micro Calc State
  double _origPrice = 100.0;
  double _discountPercent = 20.0;
  double _taxPercent = 8.0;

  @override
  void initState() {
    super.initState();
    _analyzeText(_inputController.text);
  }

  void _analyzeText(String text) {
    setState(() {
      // Clean URLs (Remove utm_ & tracking params)
      final urlRegExp = RegExp(r'https?://[^\s]+');
      final match = urlRegExp.firstMatch(text);
      if (match != null) {
        String rawUrl = match.group(0)!;
        Uri? uri = Uri.tryParse(rawUrl);
        if (uri != null) {
          _cleanedUrl = "${uri.scheme}://${uri.host}${uri.path}";
        } else {
          _cleanedUrl = rawUrl;
        }
      } else {
        _cleanedUrl = "No URL found in text";
      }

      // Extract Phone Numbers
      final phoneRegExp = RegExp(r'\+?\d[\d\s\-]{8,}\d');
      _extractedPhones = phoneRegExp.allMatches(text).map((m) => m.group(0)!).toList();

      // Extract Emails
      final emailRegExp = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
      _extractedEmails = emailRegExp.allMatches(text).map((m) => m.group(0)!).toList();

      // Extract Prices
      final priceRegExp = RegExp(r'\$\d+(\.\d{2})?');
      _extractedPrices = priceRegExp.allMatches(text).map((m) => m.group(0)!).toList();
    });
  }

  void _copyToClipboard(String content, String label) {
    Clipboard.setData(ClipboardData(text: content));
    setState(() {
      _clipsProcessed++;
      _secondsSaved += 15;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Copied $label to clipboard!"),
        backgroundColor: Colors.indigo,
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
            // Main Indexed Navigation Page
            Positioned.fill(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  _buildClipboardStudioTab(),
                  _buildFloatingOverlayTab(),
                  _buildSnippetVaultTab(),
                  _buildMicroToolsTab(),
                ],
              ),
            ),

            // Simulated Floating Interactive Bubble Dock Overlay (Always active when enabled)
            if (_isOverlayEnabled) _buildInteractiveFloatingOverlay(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarThemeData().type == BottomNavigationBarType.fixed
              ? BottomNavigationBarItem(
                  icon: Icon(Icons.content_paste_go),
                  label: "Clip Studio",
                )
              : BottomNavigationBarItem(
                  icon: Icon(Icons.content_paste_go),
                  label: "Clip Studio",
                ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: "Floating Dock",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: "Snippets",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: "Quick Tools",
          ),
        ],
      ),
    );
  }

  // ================= TAB 1: CLIPBOARD STUDIO =================
  Widget _buildClipboardStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader("Smart Clipboard Studio", "Inspect, clean links & extract actionable micro-data"),
          const SizedBox(height: 16),
          _buildUsageBanner(),
          const SizedBox(height: 20),

          // Input Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Live Text Inspector",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        ClipboardData? data = await Clipboard.getData('text/plain');
                        if (data != null && data.text != null) {
                          _inputController.text = data.text!;
                          _analyzeText(data.text!);
                        }
                      },
                      icon: const Icon(Icons.paste, size: 16),
                      label: const Text("Paste Clip"),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _inputController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  onChanged: (val) => _analyzeText(val),
                  decoration: InputDecoration(
                    hintText: "Paste any text, product link, or contact payload here...",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "Extracted Micro Actions",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),

          // Clean URL Action
          _buildExtractorCard(
            title: "Clean Tracking-Free URL",
            icon: Icons.link,
            color: Colors.tealAccent,
            value: _cleanedUrl,
            actionLabel: "Copy Clean URL",
            onAction: () => _copyToClipboard(_cleanedUrl, "Clean URL"),
          ),

          const SizedBox(height: 12),

          // Extracted Phone Numbers
          _buildExtractorCard(
            title: "Detected Phone Numbers",
            icon: Icons.phone,
            color: Colors.greenAccent,
            value: _extractedPhones.isNotEmpty ? _extractedPhones.join(", ") : "No phones detected",
            actionLabel: "Copy Phone",
            onAction: _extractedPhones.isNotEmpty
                ? () => _copyToClipboard(_extractedPhones.first, "Phone Number")
                : null,
          ),

          const SizedBox(height: 12),

          // Extracted Prices
          _buildExtractorCard(
            title: "Detected Price Tags",
            icon: Icons.monetization_on,
            color: Colors.amberAccent,
            value: _extractedPrices.isNotEmpty ? _extractedPrices.join(", ") : "No prices detected",
            actionLabel: "Copy Price",
            onAction: _extractedPrices.isNotEmpty
                ? () => _copyToClipboard(_extractedPrices.first, "Price")
                : null,
          ),

          const SizedBox(height: 20),
          _buildQuickTransformChips(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ================= TAB 2: FLOATING OVERLAY STUDIO =================
  Widget _buildFloatingOverlayTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader("Floating Dock Manager", "Enable floating overlay controls above all your apps"),
          const SizedBox(height: 16),

          // Toggle Overlay Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  _isOverlayEnabled ? Icons.visibility : Icons.visibility_off,
                  color: _isOverlayEnabled ? Colors.tealAccent : Colors.grey,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "System Floating Widget",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        _isOverlayEnabled
                            ? "Active: Floating quick-dock visible"
                            : "Disabled: Enable to show floating helper",
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isOverlayEnabled,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() {
                      _isOverlayEnabled = val;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "Interactive Simulation Viewport",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text(
            "Drag the floating bubble around the screen below to test system gesture response!",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Simulated Phone Frame
          Container(
            height: 320,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF020617),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.indigoAccent.withOpacity(0.5), width: 2),
            ),
            child: Stack(
              children: [
                // Mock app background
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 48, color: Colors.blueGrey.withOpacity(0.4)),
                      const SizedBox(height: 8),
                      Text(
                        "Simulated WhatsApp / Web Browser",
                        style: TextStyle(color: Colors.blueGrey.withOpacity(0.7), fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "ClipDeck floats directly on top of your live apps",
                        style: TextStyle(color: Colors.blueGrey.withOpacity(0.5), fontSize: 11),
                      ),
                    ],
                  ),
                ),

                // Helper tag
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Overlay Permission: GRANTED",
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            "Floating Deck Capabilities",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          _buildFeatureTile(
            icon: Icons.cleaning_services,
            title: "Auto-Clean Link Tracker",
            subtitle: "Strips affiliate & UTM tracking params immediately upon copying",
          ),
          _buildFeatureTile(
            icon: Icons.calculate,
            title: "Shopping Micro Discount Calculator",
            subtitle: "Computes 15% off + local sales tax with a single floating tap",
          ),
          _buildFeatureTile(
            icon: Icons.bookmark_border,
            title: "One-Tap Snippet Stash",
            subtitle: "Instantly pastes addresses, bank info, and generic replies",
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ================= TAB 3: SNIPPET VAULT =================
  Widget _buildSnippetVaultTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader("Quick Snippet Vault", "Store daily messages, addresses & bank info for instant copy"),
          const SizedBox(height: 16),

          // Add New Snippet Trigger Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _showAddSnippetDialog(),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Create New Snippet Card", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),

          const SizedBox(height: 20),

          // Snippet Cards List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _snippets.length,
            itemBuilder: (context, index) {
              final snip = _snippets[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            snip["title"] ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.indigo.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            snip["category"] ?? "General",
                            style: const TextStyle(color: Colors.tealAccent, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snip["content"] ?? "",
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _snippets.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
                          label: const Text("Delete", style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          onPressed: () {
                            _snippetsUsed++;
                            _copyToClipboard(snip["content"] ?? "", snip["title"] ?? "Snippet");
                          },
                          icon: const Icon(Icons.content_copy, size: 14),
                          label: const Text("Copy Now"),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ================= TAB 4: MICRO TOOLS & UTILITIES =================
  Widget _buildMicroToolsTab() {
    double discountAmount = _origPrice * (_discountPercent / 100.0);
    double afterDiscount = _origPrice - discountAmount;
    double taxAmount = afterDiscount * (_taxPercent / 100.0);
    double finalPrice = afterDiscount + taxAmount;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader("Shopping & Live Tools", "Micro calculators optimized for instant live decisions"),
          const SizedBox(height: 16),

          // Instant Discount & Tax Calculator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.discount, color: Colors.amberAccent),
                    SizedBox(width: 8),
                    Text(
                      "Shopping Fast Discount Calc",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Original Price Slider
                Text("Original Price: \$${_origPrice.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                Slider(
                  value: _origPrice,
                  min: 5.0,
                  max: 500.0,
                  divisions: 99,
                  activeColor: Colors.amberAccent,
                  onChanged: (val) => setState(() => _origPrice = val),
                ),

                // Discount Slider
                Text("Discount: ${_discountPercent.toInt()}% Off",
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                Slider(
                  value: _discountPercent,
                  min: 0.0,
                  max: 90.0,
                  divisions: 18,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) => setState(() => _discountPercent = val),
                ),

                // Sales Tax Slider
                Text("Sales Tax: ${_taxPercent.toStringAsFixed(1)}%",
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                Slider(
                  value: _taxPercent,
                  min: 0.0,
                  max: 20.0,
                  divisions: 20,
                  activeColor: Colors.indigoAccent,
                  onChanged: (val) => setState(() => _taxPercent = val),
                ),

                const Divider(color: Colors.grey),
                const SizedBox(height: 8),

                // Results Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Final Payable Price", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text(
                          "\$${finalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                      onPressed: () {
                        _copyToClipboard("\$${finalPrice.toStringAsFixed(2)}", "Final Deal Price");
                      },
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text("Copy Result"),
                    )
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Productivity Stats Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your ClipDeck Efficiency Score",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem("Clips Processed", "$_clipsProcessed", Icons.paste),
                    _buildStatItem("Time Saved", "${(_secondsSaved / 60).toStringAsFixed(1)} m", Icons.timer),
                    _buildStatItem("Snippets Used", "$_snippetsUsed", Icons.bookmark),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ================= FLOATING INTERACTIVE BUBBLE WIDGET =================
  Widget _buildInteractiveFloatingOverlay() {
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
          elevation: 10,
          borderRadius: BorderRadius.circular(28),
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(_isExpandedDock ? 12 : 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withOpacity(0.95),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.tealAccent, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.tealAccent.withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                )
              ],
            ),
            child: _isExpandedDock ? _buildExpandedDockContent() : _buildMiniBubbleHeader(),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniBubbleHeader() {
    return InkWell(
      onTap: () => setState(() => _isExpandedDock = true),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Colors.tealAccent,
            radius: 18,
            child: Icon(Icons.bolt, color: Colors.black, size: 20),
          ),
          SizedBox(width: 8),
          Text(
            "ClipDeck",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          SizedBox(width: 6),
          Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 18),
        ],
      ),
    );
  }

  Widget _buildExpandedDockContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bolt, color: Colors.tealAccent, size: 18),
            const SizedBox(width: 6),
            const Text(
              "Quick Overlay Dock",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(width: 16),
            InkWell(
              onTap: () => setState(() => _isExpandedDock = false),
              child: const Icon(Icons.close, color: Colors.grey, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            _buildDockActionButton(
              label: "Clean Link",
              icon: Icons.cleaning_services,
              color: Colors.tealAccent,
              onTap: () {
                _copyToClipboard(_cleanedUrl, "Clean URL");
                setState(() => _isExpandedDock = false);
              },
            ),
            _buildDockActionButton(
              label: "Copy Phone",
              icon: Icons.phone,
              color: Colors.greenAccent,
              onTap: () {
                if (_extractedPhones.isNotEmpty) {
                  _copyToClipboard(_extractedPhones.first, "Phone");
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No phone detected in active text")),
                  );
                }
                setState(() => _isExpandedDock = false);
              },
            ),
            _buildDockActionButton(
              label: "Quick Calc",
              icon: Icons.calculate,
              color: Colors.amberAccent,
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                  _isExpandedDock = false;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDockActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  // ================= HELPER WIDGETS =================
  Widget _buildHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildUsageBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.indigo.withOpacity(0.4)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Colors.indigoAccent, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Copy any raw shopping link or text snippet in WhatsApp or Chrome. ClipDeck automatically strips tracking parameters & extracts phones!",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtractorCard({
    required String title,
    required IconData icon,
    required Color color,
    required String value,
    required String actionLabel,
    required VoidCallback? onAction,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            radius: 18,
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: onAction != null ? color : Colors.grey.shade800,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
            onPressed: onAction,
            child: Text(actionLabel, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTransformChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Text Formatters",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              backgroundColor: const Color(0xFF1E293B),
              label: const Text("UPPERCASE", style: TextStyle(color: Colors.tealAccent, fontSize: 12)),
              onPressed: () {
                _inputController.text = _inputController.text.toUpperCase();
                _analyzeText(_inputController.text);
              },
            ),
            ActionChip(
              backgroundColor: const Color(0xFF1E293B),
              label: const Text("lowercase", style: TextStyle(color: Colors.tealAccent, fontSize: 12)),
              onPressed: () {
                _inputController.text = _inputController.text.toLowerCase();
                _analyzeText(_inputController.text);
              },
            ),
            ActionChip(
              backgroundColor: const Color(0xFF1E293B),
              label: const Text("Remove Spaces", style: TextStyle(color: Colors.tealAccent, fontSize: 12)),
              onPressed: () {
                _inputController.text = _inputController.text.replaceAll(" ", "");
                _analyzeText(_inputController.text);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.tealAccent, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.tealAccent, size: 22),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }

  void _showAddSnippetDialog() {
    final titleCtrl = TextEditingController();
    final catCtrl = TextEditingController(text: "General");
    final contentCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("Add New Snippet Card", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Title (e.g. Home Address)",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: catCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Category",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: contentCtrl,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Snippet Content",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            onPressed: () {
              if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                setState(() {
                  _snippets.add({
                    "title": titleCtrl.text,
                    "category": catCtrl.text,
                    "content": contentCtrl.text,
                  });
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text("Save Snippet", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}