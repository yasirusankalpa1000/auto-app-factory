import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FloatXApp());
}

class FloatXApp extends StatelessWidget {
  const FloatXApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatX HUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
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
  int _selectedNavIndex = 0;
  
  // Floating overlay state
  bool _isOverlayActive = true;
  bool _isMenuExpanded = false;
  Offset _bubblePosition = const Offset(20.0, 200.0);

  // Clipboard & Text state
  String _clipboardText = "Sample string: Call +94 77 123 4567 or visit https://example.com for \$49.99 deal!";
  String _processedText = "";
  final TextEditingController _textInputController = TextEditingController();

  // Quick Direct Chat state
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _customMessageController = TextEditingController();
  String _selectedTemplate = "Hello! I am reaching out regarding your listing.";

  // Quick Snippets State
  final List<Map<String, String>> _snippets = [
    {
      "title": "Home Address",
      "content": "No. 42, Main Street, Colombo 03, Sri Lanka",
      "tag": "Personal"
    },
    {
      "title": "Bank Details",
      "content": "Acc: 1000-8839-2201 | Commercial Bank | Main Branch",
      "tag": "Finance"
    },
    {
      "title": "Tax ID / NIC",
      "content": "951820493V",
      "tag": "Official"
    },
    {
      "title": "Wi-Fi Key",
      "content": "GuestPass@2025!",
      "tag": "Home"
    },
  ];

  final TextEditingController _snippetTitleController = TextEditingController();
  final TextEditingController _snippetContentController = TextEditingController();

  // Floating Calculator State
  String _calcDisplay = "0";
  double _firstNum = 0.0;
  String _operation = "";
  bool _shouldResetCalc = false;

  @override
  void initState() {
    super.initState();
    _textInputController.text = _clipboardText;
    _processedText = _clipboardText;
  }

  @override
  void dispose() {
    _textInputController.dispose();
    _phoneController.dispose();
    _customMessageController.dispose();
    _snippetTitleController.dispose();
    _snippetContentController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _readFromClipboard() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null && data.text!.isNotEmpty) {
      setState(() {
        _clipboardText = data.text!;
        _textInputController.text = _clipboardText;
        _processedText = _clipboardText;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pasted latest clipboard data!"),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  // Text Processing Utilities
  void _cleanPhoneNumber() {
    RegExp phoneRegex = RegExp(r'(\+?\d[\d\s\-\(\)]{7,\d})');
    Match? match = phoneRegex.firstMatch(_textInputController.text);
    if (match != null) {
      String raw = match.group(0)!;
      String cleaned = raw.replaceAll(RegExp(r'[^\d+]'), '');
      setState(() {
        _processedText = cleaned;
      });
    } else {
      String cleaned = _textInputController.text.replaceAll(RegExp(r'[^\d+]'), '');
      setState(() {
        _processedText = cleaned.isEmpty ? "No valid digits found" : cleaned;
      });
    }
  }

  void _extractLinks() {
    RegExp urlRegex = RegExp(r'(https?://[^\s]+)');
    Iterable<Match> matches = urlRegex.allMatches(_textInputController.text);
    List<String> urls = matches.map((m) => m.group(0)!).toList();
    setState(() {
      _processedText = urls.isEmpty ? "No HTTP/HTTPS URLs detected" : urls.join("\n");
    });
  }

  void _removeLineBreaks() {
    String cleaned = _textInputController.text.replaceAll(RegExp(r'[\r\n]+'), ' ').replaceAll(RegExp(r'\s+'), ' ');
    setState(() {
      _processedText = cleaned;
    });
  }

  void _changeCase(String type) {
    String current = _textInputController.text;
    if (type == "UPPER") {
      setState(() => _processedText = current.toUpperCase());
    } else if (type == "LOWER") {
      setState(() => _processedText = current.toLowerCase());
    } else if (type == "TITLE") {
      List<String> words = current.split(' ');
      String titleCase = words.map((w) {
        if (w.isEmpty) return "";
        return w[0].toUpperCase() + w.substring(1).toLowerCase();
      }).join(' ');
      setState(() => _processedText = titleCase);
    }
  }

  // Calculator logic
  void _onCalcBtnPress(String val) {
    setState(() {
      if (val == "C") {
        _calcDisplay = "0";
        _firstNum = 0.0;
        _operation = "";
        _shouldResetCalc = false;
      } else if (val == "+" || val == "-" || val == "×" || val == "÷") {
        _firstNum = double.tryParse(_calcDisplay) ?? 0.0;
        _operation = val;
        _shouldResetCalc = true;
      } else if (val == "=") {
        double secondNum = double.tryParse(_calcDisplay) ?? 0.0;
        double result = 0.0;
        if (_operation == "+") result = _firstNum + secondNum;
        if (_operation == "-") result = _firstNum - secondNum;
        if (_operation == "×") result = _firstNum * secondNum;
        if (_operation == "÷") result = secondNum != 0 ? _firstNum / secondNum : 0.0;
        
        _calcDisplay = result % 1 == 0 ? result.toInt().toString() : result.toStringAsFixed(2);
        _operation = "";
      } else {
        if (_calcDisplay == "0" || _shouldResetCalc) {
          _calcDisplay = val;
          _shouldResetCalc = false;
        } else {
          _calcDisplay += val;
        }
      }
    });
  }

  void _addNewSnippet() {
    if (_snippetTitleController.text.isEmpty || _snippetContentController.text.isEmpty) {
      return;
    }
    setState(() {
      _snippets.add({
        "title": _snippetTitleController.text,
        "content": _snippetContentController.text,
        "tag": "Custom"
      });
      _snippetTitleController.clear();
      _snippetContentController.clear();
    });
    Navigator.pop(context);
  }

  void _showAddSnippetDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("New Quick Snippet", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _snippetTitleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Title (e.g. Bank Account)",
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _snippetContentController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Content / Details",
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: _addNewSnippet,
            child: const Text("Save Snippet", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Navigation View
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _selectedNavIndex == 0
                      ? _buildFloatingDockTab()
                      : _selectedNavIndex == 1
                          ? _buildSmartClipboardTab()
                          : _selectedNavIndex == 2
                              ? _buildDirectChatTab()
                              : _buildSnippetsTab(),
                ),
              ],
            ),

            // Real Simulated Floating Overlay HUD Widget
            if (_isOverlayActive)
              Positioned(
                left: _bubblePosition.dx,
                top: _bubblePosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      double newX = _bubblePosition.dx + details.delta.dx;
                      double newY = _bubblePosition.dy + details.delta.dy;
                      // Keep within boundaries
                      newX = newX.clamp(0.0, screenSize.width - 70.0);
                      newY = newY.clamp(0.0, screenSize.height - 180.0);
                      _bubblePosition = Offset(newX, newY);
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Expanded Quick Action Dock
                        if (_isMenuExpanded)
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(color: Colors.black87, blurRadius: 10, offset: Offset(0, 4))
                              ],
                              border: Border.all(color: Colors.teal, width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("FloatX HUD Active", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 12)),
                                    GestureDetector(
                                      onTap: () => setState(() => _isMenuExpanded = false),
                                      child: const Icon(Icons.close, size: 16, color: Colors.grey),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _buildOverlayToolChip("Paste Last", Icons.content_paste, () {
                                      _readFromClipboard();
                                      setState(() => _isMenuExpanded = false);
                                    }),
                                    _buildOverlayToolChip("Clean Number", Icons.phone, () {
                                      _cleanPhoneNumber();
                                      _copyToClipboard(_processedText, "Cleaned phone copied!");
                                      setState(() => _isMenuExpanded = false);
                                    }),
                                    _buildOverlayToolChip("Quick Chat", Icons.message, () {
                                      setState(() {
                                        _selectedNavIndex = 2;
                                        _isMenuExpanded = false;
                                      });
                                    }),
                                    _buildOverlayToolChip("Upper Text", Icons.text_fields, () {
                                      _changeCase("UPPER");
                                      _copyToClipboard(_processedText, "Uppercase copied!");
                                      setState(() => _isMenuExpanded = false);
                                    }),
                                  ],
                                )
                              ],
                            ),
                          ),

                        // Main Floating Bubble Button
                        FloatingActionButton.extended(
                          heroTag: "floatingHUD",
                          backgroundColor: Colors.teal,
                          elevation: 8,
                          onPressed: () {
                            setState(() {
                              _isMenuExpanded = !_isMenuExpanded;
                            });
                          },
                          icon: Icon(_isMenuExpanded ? Icons.close : Icons.widgets, color: Colors.white),
                          label: Text(
                            _isMenuExpanded ? "Close" : "Float HUD",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) => setState(() => _selectedNavIndex = index),
        backgroundColor: const Color(0xFF0F172A),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.widgets), label: 'HUD Dock'),
          BottomNavigationBarItem(icon: Icon(Icons.content_paste), label: 'Clipboard'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Direct Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.file_copy), label: 'Snippets'),
        ],
      ),
    );
  }

  Widget _buildOverlayToolChip(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.teal.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.teal.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.tealAccent),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(bottom: BorderSide(color: Color(0xFF334155), width: 1)),
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
                child: const Icon(Icons.widgets, color: Colors.tealAccent, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "FloatX HUD Engine",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Smart Floating Dock & Context Utility",
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const Text("Overlay:", style: TextStyle(color: Colors.grey, fontSize: 12)),
              Switch(
                value: _isOverlayActive,
                activeColor: Colors.teal,
                onChanged: (val) {
                  setState(() {
                    _isOverlayActive = val;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  // TAB 1: Floating Dock & Multi-Tool HUD
  Widget _buildFloatingDockTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overlay HUD Status Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade900.withOpacity(0.6), const Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Icon(
                  _isOverlayActive ? Icons.notifications_active : Icons.notifications_off,
                  color: _isOverlayActive ? Colors.tealAccent : Colors.grey,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isOverlayActive ? "Floating Context Dock Active" : "Floating Overlay Disabled",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isOverlayActive
                            ? "Drag the floating teal bubble on screen for quick multi-tool actions anytime!"
                            : "Enable switch above to launch floating overlay widget.",
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            "Quick Dock Actions",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),

          // Utility Action Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _buildDockCard(
                title: "Paste & Clean Phone",
                subtitle: "Extracts pure digits",
                icon: Icons.phone,
                color: Colors.blue,
                onTap: () {
                  _readFromClipboard();
                  _cleanPhoneNumber();
                  _copyToClipboard(_processedText, "Cleaned phone copied!");
                },
              ),
              _buildDockCard(
                title: "Extract Links",
                subtitle: "Isolates URLs from text",
                icon: Icons.open_in_new,
                color: Colors.purple,
                onTap: () {
                  _readFromClipboard();
                  _extractLinks();
                  _copyToClipboard(_processedText, "Extracted links copied!");
                },
              ),
              _buildDockCard(
                title: "Remove Line Breaks",
                subtitle: "Single paragraph text",
                icon: Icons.swap_horiz,
                color: Colors.orange,
                onTap: () {
                  _readFromClipboard();
                  _removeLineBreaks();
                  _copyToClipboard(_processedText, "Cleaned text copied!");
                },
              ),
              _buildDockCard(
                title: "Quick Direct Chat",
                subtitle: "Message without saving",
                icon: Icons.message,
                color: Colors.green,
                onTap: () {
                  setState(() => _selectedNavIndex = 2);
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Floating Mini Calculator Card
          const Text(
            "Micro HUD Calculator",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              children: [
                // Calc Display
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.centerRight,
                  child: Text(
                    _calcDisplay,
                    style: const TextStyle(color: Colors.tealAccent, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                // Calc Grid
                Column(
                  children: [
                    Row(
                      children: [
                        _buildCalcBtn("7"), _buildCalcBtn("8"), _buildCalcBtn("9"), _buildCalcBtn("÷", isOp: true),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildCalcBtn("4"), _buildCalcBtn("5"), _buildCalcBtn("6"), _buildCalcBtn("×", isOp: true),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildCalcBtn("1"), _buildCalcBtn("2"), _buildCalcBtn("3"), _buildCalcBtn("-", isOp: true),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildCalcBtn("C", isOp: true), _buildCalcBtn("0"), _buildCalcBtn("=", isOp: true), _buildCalcBtn("+", isOp: true),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDockCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalcBtn(String label, {bool isOp = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isOp ? Colors.teal.shade800 : const Color(0xFF334155),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => _onCalcBtnPress(label),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  // TAB 2: Smart Clipboard Inspector & Transformations
  Widget _buildSmartClipboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Smart Clipboard Inspector",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: _readFromClipboard,
                icon: const Icon(Icons.content_paste, size: 16, color: Colors.white),
                label: const Text("Paste System", style: TextStyle(color: Colors.white, fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 12),

          // Raw Input Field
          TextField(
            controller: _textInputController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            onChanged: (val) {
              setState(() {
                _processedText = val;
              });
            },
            decoration: const InputDecoration(
              hintText: "Paste or type text here...",
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Color(0xFF1E293B),
              border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            "Transform & Extract Actions",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),

          // Action Chips Bar
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                backgroundColor: const Color(0xFF1E293B),
                avatar: const Icon(Icons.phone, size: 16, color: Colors.tealAccent),
                label: const Text("Clean Phone", style: TextStyle(color: Colors.white, fontSize: 12)),
                onPressed: _cleanPhoneNumber,
              ),
              ActionChip(
                backgroundColor: const Color(0xFF1E293B),
                avatar: const Icon(Icons.link, size: 16, color: Colors.tealAccent),
                label: const Text("Extract URLs", style: TextStyle(color: Colors.white, fontSize: 12)),
                onPressed: _extractLinks,
              ),
              ActionChip(
                backgroundColor: const Color(0xFF1E293B),
                avatar: const Icon(Icons.wrap_text, size: 16, color: Colors.tealAccent),
                label: const Text("Remove Breaks", style: TextStyle(color: Colors.white, fontSize: 12)),
                onPressed: _removeLineBreaks,
              ),
              ActionChip(
                backgroundColor: const Color(0xFF1E293B),
                avatar: const Icon(Icons.text_fields, size: 16, color: Colors.tealAccent),
                label: const Text("UPPERCASE", style: TextStyle(color: Colors.white, fontSize: 12)),
                onPressed: () => _changeCase("UPPER"),
              ),
              ActionChip(
                backgroundColor: const Color(0xFF1E293B),
                avatar: const Icon(Icons.text_fields, size: 16, color: Colors.tealAccent),
                label: const Text("lowercase", style: TextStyle(color: Colors.white, fontSize: 12)),
                onPressed: () => _changeCase("LOWER"),
              ),
              ActionChip(
                backgroundColor: const Color(0xFF1E293B),
                avatar: const Icon(Icons.title, size: 16, color: Colors.tealAccent),
                label: const Text("Title Case", style: TextStyle(color: Colors.white, fontSize: 12)),
                onPressed: () => _changeCase("TITLE"),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Processed Output View
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Processed Output:", style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.tealAccent, size: 18),
                      onPressed: () => _copyToClipboard(_processedText, "Processed text copied to clipboard!"),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                SelectableText(
                  _processedText.isEmpty ? "No output generated" : _processedText,
                  style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // TAB 3: Direct Messaging Engine
  Widget _buildDirectChatTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Direct Message Unsaved Contact",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            "Send WhatsApp or SMS messages directly without adding contacts to your address book.",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Phone input
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Phone Number (With Country Code)",
              hintText: "+94771234567",
              labelStyle: const TextStyle(color: Colors.grey),
              hintStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
              suffixIcon: IconButton(
                icon: const Icon(Icons.content_paste, color: Colors.teal),
                onPressed: () async {
                  ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
                  if (data != null && data.text != null) {
                    String cleaned = data.text!.replaceAll(RegExp(r'[^\d+]'), '');
                    setState(() {
                      _phoneController.text = cleaned;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            "Quick Message Templates",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),

          // Quick Templates Selector
          Column(
            children: [
              _buildTemplateTile("Listing Inquiry", "Hello! I am reaching out regarding your listing."),
              _buildTemplateTile("Location Request", "Hi! Could you please share your exact location/address?"),
              _buildTemplateTile("Payment Confirmation", "Hi! Payment has been processed. Attached is the receipt."),
              _buildTemplateTile("Call Request", "Hello! Please let me know when you are free for a quick call."),
            ],
          ),

          const SizedBox(height: 12),

          // Custom message body
          TextField(
            controller: _customMessageController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: _selectedTemplate,
              hintStyle: const TextStyle(color: Colors.grey),
              labelText: "Message Body",
              labelStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    String phone = _phoneController.text.trim();
                    if (phone.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter a valid phone number!")),
                      );
                      return;
                    }
                    String msg = _customMessageController.text.isNotEmpty
                        ? _customMessageController.text
                        : _selectedTemplate;
                    String waUrl = "https://wa.me/${phone.replaceAll('+', '')}?text=${Uri.encodeComponent(msg)}";
                    _copyToClipboard(waUrl, "WhatsApp Direct Chat link copied!");
                  },
                  icon: const Icon(Icons.share, color: Colors.white),
                  label: const Text("Copy WA Direct Link", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTemplateTile(String title, String body) {
    bool isSelected = _selectedTemplate == body;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: isSelected ? Colors.teal.withOpacity(0.2) : const Color(0xFF1E293B),
        leading: Icon(
          isSelected ? Icons.check_circle : Icons.circle_outlined,
          color: isSelected ? Colors.tealAccent : Colors.grey,
          size: 20,
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
        subtitle: Text(body, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        onTap: () {
          setState(() {
            _selectedTemplate = body;
            _customMessageController.text = body;
          });
        },
      ),
    );
  }

  // TAB 4: Frequently Used Info Snippets Shelf
  Widget _buildSnippetsTab() {
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
                    "Quick Snippets Shelf",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "1-tap copy for high-frequency user data",
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: _showAddSnippetDialog,
                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                label: const Text("Add New", style: TextStyle(color: Colors.white, fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _snippets.length,
            itemBuilder: (context, index) {
              final snippet = _snippets[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                snippet["title"]!,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.teal.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  snippet["tag"]!,
                                  style: const TextStyle(color: Colors.tealAccent, fontSize: 10, fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            snippet["content"]!,
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.tealAccent),
                      onPressed: () => _copyToClipboard(snippet["content"]!, "${snippet["title"]} copied!"),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
                      onPressed: () {
                        setState(() {
                          _snippets.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}