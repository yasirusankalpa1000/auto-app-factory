import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const FloatEdgeApp());
}

class FloatEdgeApp extends StatelessWidget {
  const FloatEdgeApp({super.key});

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'FloatEdge Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.teal,
          secondary: Colors.cyan,
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> meState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentTabIndex = 0;
  
  // Floating overlay state
  double _floatX = 20.0;
  double _floatY = 160.0;
  bool _isFloatExpanded = false;
  bool _displayOverAppsEnabled = true;
  bool _dynamicNotchEnabled = true;
  
  // Notification Ticker State
  String _activeTickerText = "FloatEdge dynamic floating overlay is active & ready.";
  
  // Quick Floating Note
  final TextEditingController _floatingNoteController = TextEditingController(text: "Quick meeting note: Check layout specs.");
  
  // Snippet Vault State
  final List<Map<String, String>> _snippets = [
    {"title": "Quick Reply - Busy", "content": "Hey! I'm in the middle of something right now, will get back to you shortly.", "category": "Chat"},
    {"title": "Standard Bank Details", "content": "Bank: Chase | Account: 9876543210 | Wire Code: CHSEUS33", "category": "Finance"},
    {"title": "Home Address Template", "content": "124 Innovation Way, Suite 400, San Francisco, CA 94107", "category": "Address"},
    {"title": "Email Signature", "content": "Best regards,\nAlex Vance\nProduct Lead | FloatEdge Systems", "category": "Email"},
  ];
  final TextEditingController _searchSnippetController = TextEditingController();
  String _selectedCategory = "All";
  
  // Text Transformer State
  final TextEditingController _textTransformerController = TextEditingController(
    text: "  WELCOME  to floatEdge!   This  tool cleans up   messy   text, strips  extra spaces, and calculates   word counts automatically.  ",
  );
  
  // Decision Wheel State
  final List<String> _decisionOptions = ["Option A: Coffee Break", "Option B: Deep Work Focus", "Option C: Quick Walk", "Option D: Team Sync"];
  final TextEditingController _newOptionController = TextEditingController();
  String _spinResult = "Tap 'Spin Wheel' to decide!";
  bool _isSpinning = false;
  
  // Bill Splitter State
  final TextEditingController _billAmountController = TextEditingController(text: "84.50");
  double _tipPercentage = 15.0;
  int _splitPeopleCount = 3;

  void _showToast(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _spinDecision() {
    if (_decisionOptions.isEmpty) return;
    setState(() {
      _isSpinning = true;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      final random = Random();
      final winner = _decisionOptions[random.nextInt(_decisionOptions.length)];
      if (mounted) {
        setState(() {
          _spinResult = winner;
          _isSpinning = false;
          _activeTickerText = "Decision Made: $winner";
        });
      }
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
                // Dynamic Floating Notch Status Bar
                if (_dynamicNotchEnabled) _buildDynamicNotchBar(),
                
                // Top App Header
                _buildHeader(),
                
                // Body View by Selected Tab
                Expanded(
                  child: IndexedStack(
                    index: _currentTabIndex,
                    children: [
                      _buildFloatingOverlayTab(),
                      _buildSnippetVaultTab(),
                      _buildTextTransformerTab(),
                      _buildMicroDecisionAndSplitterTab(),
                    ],
                  ),
                ),
              ],
            ),
            
            // Interactive Floating Bubble Overlay
            if (_displayOverAppsEnabled) _buildDraggableFloatingOverlay(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.widgets), label: 'Overlay'),
          BottomNavigationBarItem(icon: Icon(Icons.content_copy), label: 'Vault'),
          BottomNavigationBarItem(icon: Icon(Icons.cleaning_services), label: 'Text Tools'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Decision & Split'),
        ],
      ),
    );
  }

  // Header Banner
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.layers, color: Colors.teal, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "FloatEdge Utility",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 2),
                Text(
                  "Dynamic Floating Assistant & Quick Tools",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(_displayOverAppsEnabled ? Icons.visibility : Icons.visibility_off, color: Colors.teal),
            onPressed: () {
              setState(() {
                _displayOverAppsEnabled = !_displayOverAppsEnabled;
              });
              _showToast(_displayOverAppsEnabled ? "Floating Overlay Enabled" : "Floating Overlay Hidden");
            },
          ),
        ],
      ),
    );
  }

  // Dynamic Notch Status Indicator
  Widget _buildDynamicNotchBar() {
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.teal,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _activeTickerText,
              style: const TextStyle(fontSize: 11, color: Colors.teal, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _activeTickerText = "FloatEdge background status sync active.";
              });
            },
            child: const Icon(Icons.refresh, color: Colors.grey, size: 14),
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating Overlay Hub & Customization
  Widget _buildFloatingOverlayTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Status Card
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.touch_app, color: Colors.teal, size: 30),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Interactive Dynamic Bubble", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("Drag the teal bubble anywhere on screen to open instant quick actions.", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24, color: Colors.grey),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Display Over Other Apps", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      Switch(
                        value: _displayOverAppsEnabled,
                        activeColor: Colors.teal,
                        onChanged: (val) {
                          setState(() {
                            _displayOverAppsEnabled = val;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Show Dynamic Status Notch", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      Switch(
                        value: _dynamicNotchEnabled,
                        activeColor: Colors.teal,
                        onChanged: (val) {
                          setState(() {
                            _dynamicNotchEnabled = val;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text("Quick Floating Sticky Notes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          TextField(
            controller: _floatingNoteController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Type floating note here...",
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    _showToast("Sticky note saved to dynamic floating bubble!");
                    setState(() {
                      _activeTickerText = "Sticky Note Updated: ${_floatingNoteController.text}";
                    });
                  },
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text("Save Floating Note"),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  _floatingNoteController.clear();
                },
                child: const Text("Clear", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Floating Shortcut Grid
          const Text("Active Overlay Quick Actions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
            children: [
              _buildShortcutCard("Copy Vault", Icons.content_copy, () {
                setState(() => _currentTabIndex = 1);
              }),
              _buildShortcutCard("Text Format", Icons.cleaning_services, () {
                setState(() => _currentTabIndex = 2);
              }),
              _buildShortcutCard("Spin Decision", Icons.casino, () {
                setState(() => _currentTabIndex = 3);
              }),
              _buildShortcutCard("Bill Splitter", Icons.calculate, () {
                setState(() => _currentTabIndex = 3);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutCard(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.teal.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.teal, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: Smart Snippet & Clipboard Vault
  Widget _buildSnippetVaultTab() {
    final filteredSnippets = _snippets.where((item) {
      final matchesCategory = _selectedCategory == "All" || item["category"] == _selectedCategory;
      final matchesSearch = item["title"]!.toLowerCase().contains(_searchSnippetController.text.toLowerCase()) ||
          item["content"]!.toLowerCase().contains(_searchSnippetController.text.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Input
              TextField(
                controller: _searchSnippetController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: "Search snippets...",
                  prefixIcon: const Icon(Icons.search, color: Colors.teal),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ["All", "Chat", "Finance", "Address", "Email"].map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(cat),
                        selectedColor: Colors.teal,
                        backgroundColor: const Color(0xFF1E293B),
                        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey),
                        onSelected: (val) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: filteredSnippets.isEmpty
              ? const Center(child: Text("No matching snippets found", style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredSnippets.length,
                  itemBuilder: (context, index) {
                    final item = filteredSnippets[index];
                    return Card(
                      color: const Color(0xFF1E293B),
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item["title"]!,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.teal),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item["category"]!,
                                    style: const TextStyle(fontSize: 10, color: Colors.teal, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item["content"]!,
                              style: const TextStyle(fontSize: 13, color: Colors.white70),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  style: TextButton.styleFrom(foregroundColor: Colors.teal),
                                  onPressed: () {
                                    _showToast("Copied to clipboard: ${item['title']}");
                                    setState(() {
                                      _activeTickerText = "Copied: ${item['title']}";
                                    });
                                  },
                                  icon: const Icon(Icons.content_copy, size: 16),
                                  label: const Text("Instant Copy"),
                                ),
                              ],
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

  // TAB 3: Instant Text Transformer
  Widget _buildTextTransformerTab() {
    final rawText = _textTransformerController.text;
    final wordCount = rawText.trim().isEmpty ? 0 : rawText.trim().split(RegExp(r'\s+')).length;
    final charCount = rawText.length;
    final readingTimeSec = (wordCount / 3.5).ceil();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Live Text Magic & Cleaner", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          TextField(
            controller: _textTransformerController,
            maxLines: 5,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: "Paste raw messy text here...",
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          // Live Stats Bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem("Words", "$wordCount"),
                _buildStatItem("Chars", "$charCount"),
                _buildStatItem("Est. Read", "${readingTimeSec}s"),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text("Quick Transform Actions", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                avatar: const Icon(Icons.cleaning_services, size: 16, color: Colors.teal),
                label: const Text("Trim Extra Spaces"),
                backgroundColor: const Color(0xFF1E293B),
                onPressed: () {
                  setState(() {
                    _textTransformerController.text = rawText.replaceAll(RegExp(r'\s+'), ' ').trim();
                  });
                  _showToast("Extra spaces cleaned up!");
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.text_fields, size: 16, color: Colors.teal),
                label: const Text("UPPERCASE"),
                backgroundColor: const Color(0xFF1E293B),
                onPressed: () {
                  setState(() {
                    _textTransformerController.text = rawText.toUpperCase();
                  });
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.text_format, size: 16, color: Colors.teal),
                label: const Text("lowercase"),
                backgroundColor: const Color(0xFF1E293B),
                onPressed: () {
                  setState(() {
                    _textTransformerController.text = rawText.toLowerCase();
                  });
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.format_list_bulleted, size: 16, color: Colors.teal),
                label: const Text("Convert to Bullet Points"),
                backgroundColor: const Color(0xFF1E293B),
                onPressed: () {
                  final lines = rawText.split('\n');
                  final bulleted = lines.map((line) => line.trim().startsWith('•') ? line : '• ${line.trim()}').join('\n');
                  setState(() {
                    _textTransformerController.text = bulleted;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              _showToast("Transformed text copied to dynamic overlay!");
              setState(() {
                _activeTickerText = "Formatted Text Ready: $wordCount words";
              });
            },
            icon: const Icon(Icons.content_copy),
            label: const Text("Copy Transformed Text"),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  // TAB 4: Micro Decision Spinner & Bill Splitter
  Widget _buildMicroDecisionAndSplitterTab() {
    // Bill Calculation Logic
    final billVal = double.tryParse(_billAmountController.text) ?? 0.0;
    final tipVal = billVal * (_tipPercentage / 100.0);
    final grandTotal = billVal + tipVal;
    final perPerson = _splitPeopleCount > 0 ? grandTotal / _splitPeopleCount : grandTotal;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Decision Wheel Section
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.casino, color: Colors.teal, size: 24),
                      SizedBox(width: 8),
                      Text("Instant Micro-Decision Spinner", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.teal.withOpacity(0.4)),
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _isSpinning
                            ? const CircularProgressIndicator(color: Colors.teal)
                            : Text(
                                _spinResult,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _isSpinning ? null : _spinDecision,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Spin Wheel"),
                  ),
                  const SizedBox(height: 12),
                  // Add options input
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _newOptionController,
                          decoration: InputDecoration(
                            hintText: "Add custom option...",
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            filled: true,
                            fillColor: const Color(0xFF0F172A),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.teal),
                        onPressed: () {
                          if (_newOptionController.text.trim().isNotEmpty) {
                            setState(() {
                              _decisionOptions.add(_newOptionController.text.trim());
                              _newOptionController.clear();
                            });
                            _showToast("Option added to wheel!");
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Micro Bill & Tip Splitter Section
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.monetization_on, color: Colors.teal, size: 24),
                      SizedBox(width: 8),
                      Text("Instant Micro-Bill & Tip Splitter", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _billAmountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: "Total Bill Amount (\$) ",
                      prefixIcon: const Icon(Icons.attach_money, color: Colors.teal),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tip: ${_tipPercentage.toInt()}%", style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text("Tip Amount: \$${tipVal.toStringAsFixed(2)}", style: const TextStyle(color: Colors.teal)),
                    ],
                  ),
                  Slider(
                    value: _tipPercentage,
                    min: 0,
                    max: 30,
                    divisions: 6,
                    activeColor: Colors.teal,
                    label: "${_tipPercentage.toInt()}%",
                    onChanged: (val) {
                      setState(() {
                        _tipPercentage = val;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Split Between:", style: TextStyle(fontWeight: FontWeight.w600)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                            onPressed: () {
                              if (_splitPeopleCount > 1) {
                                setState(() => _splitPeopleCount--);
                              }
                            },
                          ),
                          Text("$_splitPeopleCount People", style: const TextStyle(fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Colors.teal),
                            onPressed: () {
                              setState(() => _splitPeopleCount++);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Per Person Total:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        Text(
                          "\$${perPerson.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
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

  // Interactive Draggable Floating Overlay Widget
  Widget _buildDraggableFloatingOverlay() {
    return Positioned(
      left: _floatX,
      top: _floatY,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _floatX += details.delta.dx;
            _floatY += details.delta.dy;
          });
        },
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _isFloatExpanded = !_isFloatExpanded;
                });
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  _isFloatExpanded ? Icons.close : Icons.layers,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            if (_isFloatExpanded)
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 180,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.teal, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "FloatEdge Overlay",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                    const Divider(height: 12, color: Colors.grey),
                    _buildOverlayMenuItem(Icons.content_copy, "Quick Copy", () {
                      _showToast("Quick snippet vault ready!");
                      setState(() {
                        _currentTabIndex = 1;
                        _isFloatExpanded = false;
                      });
                    }),
                    _buildOverlayMenuItem(Icons.casino, "Random Spin", () {
                      _spinDecision();
                      setState(() {
                        _isFloatExpanded = false;
                      });
                    }),
                    _buildOverlayMenuItem(Icons.cleaning_services, "Clean Text", () {
                      setState(() {
                        _currentTabIndex = 2;
                        _isFloatExpanded = false;
                      });
                    }),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlayMenuItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.teal),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}