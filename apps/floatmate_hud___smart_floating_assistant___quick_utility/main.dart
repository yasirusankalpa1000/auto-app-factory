import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const FloatMateApp());
}

class FloatMateApp extends StatelessWidget {
  const FloatMateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatMate HUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0E17),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class SnippetItem {
  final String id;
  final String title;
  final String content;
  final String category;
  final IconData icon;

  SnippetItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.icon,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentTab = 0;
  bool _overlayEnabled = true;
  bool _notificationAccess = true;
  bool _autoCleanClipboard = true;

  // Floating Bubble Position & Style Settings
  Offset _bubblePosition = const Offset(20, 150);
  Color _bubbleColor = Colors.deepPurple;
  IconData _bubbleIcon = Icons.auto_awesome;
  double _bubbleOpacity = 0.9;
  double _bubbleSize = 58.0;

  // Text Scrubber State
  final TextEditingController _scrubberController = TextEditingController();
  String _scrubberOutput = "";
  String _extractedPhone = "None detected";
  String _extractedLinks = "None detected";

  // Quick Calculator State
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  String _finalPriceResult = "\$0.00";
  String _savingsResult = "\$0.00";

  // Snippets Data
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: '1',
      title: 'Primary Bank Account',
      content: 'Sampath Bank\nAcc: 1200 8945 3321\nBranch: Colombo Central',
      category: 'Payment',
      icon: Icons.monetization_on,
    ),
    SnippetItem(
      id: '2',
      title: 'Home Delivery Address',
      content: 'No. 45/A, Palm Grove Road, Nawala, Rajagiriya.',
      category: 'Address',
      icon: Icons.home,
    ),
    SnippetItem(
      id: '3',
      title: 'Standard Business Reply',
      content: 'Hello! Thanks for contacting us. We will get back to you within 30 minutes.',
      category: 'Work',
      icon: Icons.chat_bubble,
    ),
    SnippetItem(
      id: '4',
      title: 'Tax Registration ID',
      content: 'TIN-994827103-V',
      category: 'Personal',
      icon: Icons.assignment,
    ),
  ];

  final TextEditingController _newTitleController = TextEditingController();
  final TextEditingController _newContentController = TextEditingController();
  String _selectedCategory = 'Personal';

  void _processScrubberText(String input) {
    if (input.trim().isEmpty) {
      setState(() {
        _scrubberOutput = "";
        _extractedPhone = "None detected";
        _extractedLinks = "None detected";
      });
      return;
    }

    // Clean extra whitespace
    String cleaned = input.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Extract phone numbers regex
    RegExp phoneRegex = RegExp(r'(\+?\d{1,4}?[\s-]?\(?\d{1,3}?\)?[\s-]?\d{3,4}[\s-]?\d{3,4})');
    Match? phoneMatch = phoneRegex.firstMatch(input);
    String foundPhone = phoneMatch != null ? phoneMatch.group(0) ?? "None" : "None detected";

    // Extract links regex
    RegExp urlRegex = RegExp(r'(https?:\/\/[^\s]+)');
    Match? urlMatch = urlRegex.firstMatch(input);
    String foundUrl = urlMatch != null ? urlMatch.group(0) ?? "None" : "None detected";

    setState(() {
      _scrubberOutput = cleaned;
      _extractedPhone = foundPhone;
      _extractedLinks = foundUrl;
    });
  }

  void _calculateDiscount() {
    double price = double.tryParse(_priceController.text) ?? 0.0;
    double discount = double.tryParse(_discountController.text) ?? 0.0;

    if (price > 0) {
      double savings = price * (discount / 100.0);
      double finalPrice = price - savings;
      setState(() {
        _finalPriceResult = "\$${finalPrice.toStringAsFixed(2)}";
        _savingsResult = "\$${savings.toStringAsFixed(2)}";
      });
    } else {
      setState(() {
        _finalPriceResult = "\$0.00";
        _savingsResult = "\$0.00";
      });
    }
  }

  void _addNewSnippet() {
    if (_newTitleController.text.trim().isEmpty || _newContentController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _snippets.insert(
        0,
        SnippetItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _newTitleController.text.trim(),
          content: _newContentController.text.trim(),
          category: _selectedCategory,
          icon: _selectedCategory == 'Payment'
              ? Icons.monetization_on
              : _selectedCategory == 'Address'
                  ? Icons.home
                  : _selectedCategory == 'Work'
                      ? Icons.work
                      : Icons.star,
        ),
      );
      _newTitleController.clear();
      _newContentController.clear();
    });
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Snippet pinned to FloatMate Vault!')),
    );
  }

  void _showAddSnippetDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1C2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            top: 24,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Pin New Fast Snippet",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _newTitleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Title (e.g., Bank Acc, Wi-Fi Password)",
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _newContentController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Content to Copy",
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                StatefulBuilder(
                  builder: (context, setModalState) {
                    return Wrap(
                      spacing: 8,
                      children: ['Payment', 'Address', 'Work', 'Personal'].map((cat) {
                        final isSel = _selectedCategory == cat;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSel,
                          selectedColor: Colors.deepPurple,
                          onSelected: (selected) {
                            if (selected) {
                              setModalState(() {
                                _selectedCategory = cat;
                              });
                            }
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _addNewSnippet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Save & Pin Snippet", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showQuickOverlayDrawer() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161522),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(_bubbleIcon, color: _bubbleColor),
                      const SizedBox(width: 10),
                      const Text(
                        "FloatMate Live Assistant Overlay",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Quick Actions:", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildQuickActionButton(
                        icon: Icons.cleaning_services,
                        label: "Clean Text",
                        onTap: () {
                          Navigator.pop(ctx);
                          setState(() => _currentTab = 1);
                        },
                      ),
                      _buildQuickActionButton(
                        icon: Icons.inventory_2,
                        label: "Vault Snippets",
                        onTap: () {
                          Navigator.pop(ctx);
                          setState(() => _currentTab = 0);
                        },
                      ),
                      _buildQuickActionButton(
                        icon: Icons.calculate,
                        label: "Discount Calc",
                        onTap: () {
                          Navigator.pop(ctx);
                          setState(() => _currentTab = 2);
                        },
                      ),
                      _buildQuickActionButton(
                        icon: Icons.palette,
                        label: "Style HUD",
                        onTap: () {
                          Navigator.pop(ctx);
                          setState(() => _currentTab = 3);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.deepPurpleAccent, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "FloatMate is dynamically overlaying on top of your screen for immediate instant utility.",
                            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF232136),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white70),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.tealAccent, size: 18),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Top Custom Header & System Controls
                _buildHeader(),

                // Sub Header Control Switch Bar
                _buildPermissionBar(),

                // Main Content View
                Expanded(
                  child: IndexedStack(
                    index: _currentTab,
                    children: [
                      _buildSnippetsTab(),
                      _buildScrubberTab(),
                      _buildQuickToolsTab(),
                      _buildHUDStudioTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Simulated Dynamic System Overlay Floating Bubble
          if (_overlayEnabled)
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubblePosition += details.delta;
                  });
                },
                onTap: _showQuickOverlayDrawer,
                child: Opacity(
                  opacity: _bubbleOpacity,
                  child: Container(
                    width: _bubbleSize,
                    height: _bubbleSize,
                    decoration: BoxDecoration(
                      color: _bubbleColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _bubbleColor.withOpacity(0.5),
                          blurRadius: 16,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Icon(_bubbleIcon, color: Colors.white, size: _bubbleSize * 0.5),
                  ),
                ),
              ),
            ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF161522),
          border: Border(top: BorderSide(color: Colors.white70)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentTab,
          onTap: (index) => setState(() => _currentTab = index),
          backgroundColor: const Color(0xFF161522),
          selectedItemColor: Colors.tealAccent,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2),
              label: 'Vault',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cleaning_services),
              label: 'Scrubber',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate),
              label: 'Calc & Tools',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.palette),
              label: 'HUD Studio',
            ),
          ],
        ),
      ),
      floatingActionButton: _currentTab == 0
          ? FloatingActionButton.extended(
              onPressed: _showAddSnippetDialog,
              backgroundColor: Colors.tealAccent,
              icon: const Icon(Icons.add, color: Colors.black),
              label: const Text("New Snippet", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF161522),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.layers, color: Colors.tealAccent, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "FloatMate HUD",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "Smart Screen Overlay & Micro-Toolbox",
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _overlayEnabled ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _overlayEnabled ? Colors.green : Colors.red,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 4,
                  backgroundColor: _overlayEnabled ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 6),
                Text(
                  _overlayEnabled ? "HUD LIVE" : "OFFLINE",
                  style: TextStyle(
                    color: _overlayEnabled ? Colors.green : Colors.red,
                    fontSize: 10,
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

  Widget _buildPermissionBar() {
    return Container(
      color: const Color(0xFF1E1C2A),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildSwitchChip(
              label: "Display Above Apps",
              icon: Icons.layers,
              value: _overlayEnabled,
              onChanged: (val) => setState(() => _overlayEnabled = val),
            ),
            const SizedBox(width: 8),
            _buildSwitchChip(
              label: "Float Notifications",
              icon: Icons.notifications,
              value: _notificationAccess,
              onChanged: (val) => setState(() => _notificationAccess = val),
            ),
            const SizedBox(width: 8),
            _buildSwitchChip(
              label: "Auto-Clean Clip",
              icon: Icons.content_paste_go,
              value: _autoCleanClipboard,
              onChanged: (val) => setState(() => _autoCleanClipboard = val),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchChip({
    required String label,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2A283E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.tealAccent, size: 14),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          const SizedBox(width: 4),
          Transform.scale(
            scale: 0.7,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.tealAccent,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 1: SNIPPETS VAULT ---
  Widget _buildSnippetsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pinned Snippets Vault",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            "Tap any snippet for instant 1-second copying across any application.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _snippets.length,
            itemBuilder: (context, index) {
              final item = _snippets[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1C2A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white70),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.deepPurple.withOpacity(0.3),
                          child: Icon(item.icon, color: Colors.tealAccent, size: 16),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                item.category,
                                style: const TextStyle(color: Colors.tealAccent, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, color: Colors.grey, size: 18),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: item.content));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Copied "${item.title}" to clipboard!')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                          onPressed: () {
                            setState(() {
                              _snippets.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white70, height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.content,
                        style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace'),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- TAB 2: TEXT SCRUBBER ---
  Widget _buildScrubberTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Smart Clipboard Scrubber",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            "Strips messy formatting, extracts phone numbers, and cleans copy-paste junk.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _scrubberController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            onChanged: _processScrubberText,
            decoration: InputDecoration(
              hintText: "Paste messy text, SMS details, or copied numbers here...",
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF1E1C2A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.paste, color: Colors.tealAccent),
                onPressed: () async {
                  ClipboardData? data = await Clipboard.getData('text/plain');
                  if (data != null && data.text != null) {
                    _scrubberController.text = data.text!;
                    _processScrubberText(data.text!);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Output Container
          if (_scrubberOutput.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1C2A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Cleaned Output", style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.tealAccent, size: 18),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _scrubberOutput));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cleaned text copied!')),
                          );
                        },
                      )
                    ],
                  ),
                  Text(
                    _scrubberOutput,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Extracted Phone & Links Info Cards
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1C2A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.phone, color: Colors.amber, size: 14),
                          SizedBox(width: 4),
                          Text("Extracted Phone", style: TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _extractedPhone,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1C2A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.link, color: Colors.blueAccent, size: 14),
                          SizedBox(width: 4),
                          Text("Extracted Link", style: TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _extractedLinks,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- TAB 3: QUICK TOOLS & DISCOUNT CALC ---
  Widget _buildQuickToolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Shopping Discount Micro-Calc",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            "Quickly calculate real price tags while browsing online or shopping.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1C2A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Original Price (\$)",
                          labelStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.black87,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onChanged: (_) => _calculateDiscount(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _discountController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Discount (%)",
                          labelStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.black87,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onChanged: (_) => _calculateDiscount(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text("Final Payable Price", style: TextStyle(color: Colors.grey, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text(
                            _finalPriceResult,
                            style: const TextStyle(color: Colors.tealAccent, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(height: 30, width: 1, color: Colors.white70),
                      Column(
                        children: [
                          const Text("You Save", style: TextStyle(color: Colors.grey, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text(
                            _savingsResult,
                            style: const TextStyle(color: Colors.amberAccent, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Quick Text Case Converters",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildConverterChip("UPPERCASE", () {
                if (_scrubberController.text.isNotEmpty) {
                  setState(() {
                    _scrubberController.text = _scrubberController.text.toUpperCase();
                    _scrubberOutput = _scrubberController.text;
                  });
                }
              }),
              _buildConverterChip("lowercase", () {
                if (_scrubberController.text.isNotEmpty) {
                  setState(() {
                    _scrubberController.text = _scrubberController.text.toLowerCase();
                    _scrubberOutput = _scrubberController.text;
                  });
                }
              }),
              _buildConverterChip("Title Case", () {
                if (_scrubberController.text.isNotEmpty) {
                  setState(() {
                    _scrubberController.text = _scrubberController.text
                        .split(' ')
                        .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '')
                        .join(' ');
                    _scrubberOutput = _scrubberController.text;
                  });
                }
              }),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildConverterChip(String label, VoidCallback onTap) {
    return ActionChip(
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: const Color(0xFF1E1C2A),
      onPressed: onTap,
    );
  }

  // --- TAB 4: HUD STUDIO ---
  Widget _buildHUDStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Floating Overlay Customizer Studio",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            "Personalize the floating bubble widget to match your setup.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Bubble Color Picker
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1C2A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Bubble Accent Color", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  children: [
                    Colors.deepPurple,
                    Colors.teal,
                    Colors.indigo,
                    Colors.amber,
                    Colors.red,
                    Colors.green,
                  ].map((color) {
                    return GestureDetector(
                      onTap: () => setState(() => _bubbleColor = color),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: color,
                        child: _bubbleColor == color ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Text("Bubble Size (${_bubbleSize.toInt()} px)", style: const TextStyle(color: Colors.white)),
                Slider(
                  value: _bubbleSize,
                  min: 40,
                  max: 80,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) => setState(() => _bubbleSize = val),
                ),
                const SizedBox(height: 10),
                Text("Opacity (${(_bubbleOpacity * 100).toInt()}%)", style: const TextStyle(color: Colors.white)),
                Slider(
                  value: _bubbleOpacity,
                  min: 0.3,
                  max: 1.0,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) => setState(() => _bubbleOpacity = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Icon Selection
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1C2A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Bubble Icon", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  children: [
                    Icons.auto_awesome,
                    Icons.layers,
                    Icons.flash_on,
                    Icons.widgets,
                    Icons.center_focus_strong,
                  ].map((iconData) {
                    return IconButton(
                      icon: Icon(iconData, color: _bubbleIcon == iconData ? Colors.tealAccent : Colors.grey),
                      onPressed: () => setState(() => _bubbleIcon = iconData),
                    );
                  }).toList(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}