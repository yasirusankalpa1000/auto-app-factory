import 'package:flutter/material.dart';

void main() {
  runApp(const FloatDockApp());
}

class FloatDockApp extends StatelessWidget {
  const FloatDockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatDock Studio',
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

  // Floating Overlay State Simulation
  bool _isOverlayEnabled = true;
  bool _isBubbleExpanded = false;
  Offset _bubblePosition = const Offset(20.0, 180.0);
  Color _hudThemeColor = Colors.teal;
  double _bubbleOpacity = 0.9;

  // Clipboard Stack State
  final List<Map<String, String>> _clipboardItems = [
    {
      'type': 'Link',
      'content': 'https://store.example.com/product-item-8823',
      'tag': 'Shopping',
    },
    {
      'type': 'Price',
      'content': 'Special Offer: \$149.99 (Discount 20%)',
      'tag': 'Deal',
    },
    {
      'type': 'Phone',
      'content': '+1 (555) 234-5678 - Support Helpline',
      'tag': 'Contact',
    },
    {
      'type': 'Code',
      'content': 'PROMO_SAVE_2025_VIP',
      'tag': 'Coupon',
    },
  ];

  final TextEditingController _rawTextController = TextEditingController(
    text: "Contact us at support@service.io or call +1 800 555 0199. Product price is \$89.50 with shipping. Visit https://service.io/checkout for details.",
  );

  // Compare Matrix State
  final TextEditingController _itemA PriceController = TextEditingController(text: "49.99");
  final TextEditingController _itemA QtyController = TextEditingController(text: "2");
  final TextEditingController _itemB PriceController = TextEditingController(text: "89.99");
  final TextEditingController _itemB QtyController = TextEditingController(text: "4");

  // Audio Reader Simulation
  bool _isPlayingSpeech = false;
  double _speechSpeed = 1.0;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.layers, color: Colors.tealAccent),
            SizedBox(width: 10),
            Text('FloatDock Studio', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            icon: Icon(
              _isOverlayEnabled ? Icons.visibility : Icons.visibility_off,
              color: _isOverlayEnabled ? Colors.tealAccent : Colors.grey,
            ),
            tooltip: 'Toggle Floating Dock HUD',
            onPressed: () {
              setState(() {
                _isOverlayEnabled = !_isOverlayEnabled;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isOverlayEnabled ? 'Floating HUD Dock Activated!' : 'Floating HUD Dock Hidden'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: [
              _buildFloatingHudTab(),
              _buildClipboardExtractorTab(),
              _buildCompareMatrixTab(),
              _buildAudioReaderTab(),
            ],
          ),
          if (_isOverlayEnabled) _buildDraggableFloatingBubble(screenSize),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Floating HUD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy),
            label: 'Smart Clips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare),
            label: 'Deal Matrix',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volume_up),
            label: 'Speech Dock',
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating HUD & Dynamic Controls
  Widget _buildFloatingHudTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(
              title: "Interactive Floating Dock HUD",
              subtitle: "Keep utilities floating over active screen tasks for quick context actions.",
              icon: Icons.dashboard_customize,
              badgeText: "System Active",
              badgeColor: Colors.teal,
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Overlay Permission & Status",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            "Display Above Other Apps Permission Granted",
                            style: TextStyle(color: Colors.white70, fontSize: 13),
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
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 8),
                    const Text(
                      "HUD Theme Preset",
                      style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildColorChip("Neon Teal", Colors.teal),
                        _buildColorChip("Sunset Amber", Colors.amber),
                        _buildColorChip("Electric Blue", Colors.blue),
                        _buildColorChip("Purple Pulse", Colors.purple),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Bubble Opacity", style: TextStyle(color: Colors.white70)),
                        Text("${(_bubbleOpacity * 100).toInt()}%", style: const TextStyle(color: Colors.tealAccent)),
                      ],
                    ),
                    Slider(
                      value: _bubbleOpacity,
                      min: 0.3,
                      max: 1.0,
                      activeColor: Colors.tealAccent,
                      onChanged: (val) {
                        setState(() {
                          _bubbleOpacity = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Quick Floating Tools Launcher",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildQuickLauncherCard("Floating Calc", Icons.calculate, Colors.blue, () {
                  _showFloatingNotification("Floating Calculator HUD Opened");
                }),
                _buildQuickLauncherCard("Text Formatter", Icons.text_fields, Colors.purple, () {
                  _showFloatingNotification("Dynamic Text Sanitizer Attached");
                }),
                _buildQuickLauncherCard("Sticky Bubble Note", Icons.lightbulb, Colors.amber, () {
                  _showFloatingNotification("New Sticky Note Floating Bubble Created");
                }),
                _buildQuickLauncherCard("Quick OCR Reader", Icons.center_focus_strong, Colors.green, () {
                  _showFloatingNotification("Screen OCR Extractor Active");
                }),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              color: const Color(0xFF1E293B),
              child: ListTile(
                leading: const Icon(Icons.notifications_active, color: Colors.amber),
                title: const Text("Simulate Floating Notification Header", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                subtitle: const Text("Tests heads-up screen alerts when app is minimized.", style: TextStyle(color: Colors.white70, fontSize: 12)),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () {
                    _showFloatingNotification("Floating Clip Captured: \$149.99 Product Deal");
                  },
                  child: const Text("Test Alert", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: Smart Clipboard & Regex Pattern Extractor
  Widget _buildClipboardExtractorTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(
              title: "Pattern & Clipboard Extractor",
              subtitle: "Paste any unstructured document or text to extract links, prices, numbers, and cleans format.",
              icon: Icons.cleaning_services,
              badgeText: "${_clipboardItems.length} Saved Clips",
              badgeColor: Colors.blue,
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Raw Context Input Area", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _rawTextController,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: "Paste raw text containing emails, prices ($XX), numbers or links...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                          icon: const Icon(Icons.search, size: 16, color: Colors.white),
                          label: const Text("Extract Patterns", style: TextStyle(color: Colors.white, fontSize: 12)),
                          onPressed: _runPatternExtractor,
                        ),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.space_bar, size: 16, color: Colors.tealAccent),
                          label: const Text("Remove Extra Spaces", style: TextStyle(color: Colors.tealAccent, fontSize: 12)),
                          onPressed: () {
                            setState(() {
                              _rawTextController.text = _rawTextController.text.replaceAll(RegExp(r'\s+'), ' ').trim();
                            });
                          },
                        ),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.uppercase, size: 16, color: Colors.amberAccent),
                          label: const Text("UPPERCASE", style: TextStyle(color: Colors.amberAccent, fontSize: 12)),
                          onPressed: () {
                            setState(() {
                              _rawTextController.text = _rawTextController.text.toUpperCase();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Clipboard Cards Stack", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 16, color: Colors.tealAccent),
                  label: const Text("Add Clip", style: TextStyle(color: Colors.tealAccent)),
                  onPressed: () {
                    _showAddClipDialog();
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _clipboardItems.length,
              itemBuilder: (context, index) {
                final item = _clipboardItems[index];
                return Card(
                  color: const Color(0xFF1E293B),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getClipTagColor(item['tag'] ?? 'General'),
                      child: Icon(_getClipIcon(item['type'] ?? ''), color: Colors.white, size: 18),
                    ),
                    title: Text(
                      item['content'] ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(item['tag'] ?? '', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                          ),
                          const SizedBox(width: 8),
                          Text(item['type'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy, color: Colors.tealAccent, size: 18),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Copied to system clipboard!"), duration: Duration(seconds: 1)),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
                          onPressed: () {
                            setState(() {
                              _clipboardItems.removeAt(index);
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
      ),
    );
  }

  // TAB 3: Side-by-Side Product Deal Compare Matrix
  Widget _buildCompareMatrixTab() {
    final double priceA = double.tryParse(_itemA PriceController.text) ?? 0.0;
    final double qtyA = double.tryParse(_itemA QtyController.text) ?? 1.0;
    final double priceB = double.tryParse(_itemB PriceController.text) ?? 0.0;
    final double qtyB = double.tryParse(_itemB QtyController.text) ?? 1.0;

    final double unitCostA = qtyA > 0 ? priceA / qtyA : 0.0;
    final double unitCostB = qtyB > 0 ? priceB / qtyB : 0.0;

    String winnerText = "Equal Value";
    Color winnerColor = Colors.grey;

    if (unitCostA > 0 && unitCostB > 0) {
      if (unitCostA < unitCostB) {
        winnerText = "Option A is ${((1 - unitCostA / unitCostB) * 100).toStringAsFixed(1)}% CHEAPER per unit!";
        winnerColor = Colors.greenAccent;
      } else if (unitCostB < unitCostA) {
        winnerText = "Option B is ${((1 - unitCostB / unitCostA) * 100).toStringAsFixed(1)}% CHEAPER per unit!";
        winnerColor = Colors.amberAccent;
      }
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(
              title: "Side-by-Side Deal Matrix",
              subtitle: "Compare unit prices, specifications, and savings while shopping across screen apps.",
              icon: Icons.compare_arrows,
              badgeText: "Smart Deal Engine",
              badgeColor: Colors.amber,
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: winnerColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: winnerColor),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.emoji_events, color: winnerColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              winnerText,
                              style: TextStyle(color: winnerColor, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Option A
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.tealAccent.withOpacity(0.5)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Option A (Pack 1)", style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _itemA PriceController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: Colors.white, fontSize: 13),
                                  onChanged: (_) => setState(() {}),
                                  decoration: const InputDecoration(
                                    labelText: "Price (\$)",
                                    labelStyle: TextStyle(color: Colors.grey, fontSize: 11),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _itemA QtyController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: Colors.white, fontSize: 13),
                                  onChanged: (_) => setState(() {}),
                                  decoration: const InputDecoration(
                                    labelText: "Quantity/Units",
                                    labelStyle: TextStyle(color: Colors.grey, fontSize: 11),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Unit Rate: \$${unitCostA.toStringAsFixed(2)} / unit",
                                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Option B
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.amberAccent.withOpacity(0.5)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Option B (Pack 2)", style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _itemB PriceController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: Colors.white, fontSize: 13),
                                  onChanged: (_) => setState(() {}),
                                  decoration: const InputDecoration(
                                    labelText: "Price (\$)",
                                    labelStyle: TextStyle(color: Colors.grey, fontSize: 11),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _itemB QtyController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: Colors.white, fontSize: 13),
                                  onChanged: (_) => setState(() {}),
                                  decoration: const InputDecoration(
                                    labelText: "Quantity/Units",
                                    labelStyle: TextStyle(color: Colors.grey, fontSize: 11),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Unit Rate: \$${unitCostB.toStringAsFixed(2)} / unit",
                                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Quick Discount Calculator", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildDiscountButton(10),
                        const SizedBox(width: 8),
                        _buildDiscountButton(15),
                        const SizedBox(width: 8),
                        _buildDiscountButton(20),
                        const SizedBox(width: 8),
                        _buildDiscountButton(30),
                      ],
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

  // TAB 4: Audio Reader Companion
  Widget _buildAudioReaderTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(
              title: "Speech & Audio Dock Companion",
              subtitle: "Listen to long snippets, articles or study notes hands-free in overlay mode.",
              icon: Icons.record_voice_over,
              badgeText: "Audio Engine",
              badgeColor: Colors.purple,
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _rawTextController.text.isNotEmpty
                            ? _rawTextController.text
                            : "No active text loaded. Paste text in Smart Clips tab to read aloud.",
                        style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 36,
                          icon: Icon(
                            _isPlayingSpeech ? Icons.pause_circle_filled : Icons.play_circle_fill,
                            color: Colors.tealAccent,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPlayingSpeech = !_isPlayingSpeech;
                            });
                          },
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          iconSize: 28,
                          icon: const Icon(Icons.stop_circle, color: Colors.redAccent),
                          onPressed: () {
                            setState(() {
                              _isPlayingSpeech = false;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Speech Speed Rate", style: TextStyle(color: Colors.white70, fontSize: 12)),
                        Text("${_speechSpeed.toStringAsFixed(1)}x", style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                      value: _speechSpeed,
                      min: 0.5,
                      max: 2.0,
                      divisions: 6,
                      activeColor: Colors.tealAccent,
                      onChanged: (val) {
                        setState(() {
                          _speechSpeed = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color(0xFF1E293B),
              child: ListTile(
                leading: const Icon(Icons.timer, color: Colors.tealAccent),
                title: const Text("Reading Time Estimator", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                subtitle: Text(
                  "Estimated read time: ~${(_rawTextController.text.split(' ').length / 150).ceil()} min (${_rawTextController.text.split(' ').length} words)",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FLOATING INTERACTIVE BUBBLE (Simulates System Screen Overlay)
  Widget _buildDraggableFloatingBubble(Size screenSize) {
    return Positioned(
      left: _bubblePosition.dx,
      top: _bubblePosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubblePosition += details.delta;
            // Keep bubble within screen bounds
            _bubblePosition = Offset(
              _bubblePosition.dx.clamp(0.0, screenSize.width - 70.0),
              _bubblePosition.dy.clamp(50.0, screenSize.height - 150.0),
            );
          });
        },
        onTap: () {
          setState(() {
            _isBubbleExpanded = !_isBubbleExpanded;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(_isBubbleExpanded ? 12 : 8),
          decoration: BoxDecoration(
            color: _hudThemeColor.withOpacity(_bubbleOpacity),
            borderRadius: BorderRadius.circular(_isBubbleExpanded ? 16 : 30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
          child: _isBubbleExpanded
              ? SizedBox(
                  width: 220,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.widgets, color: Colors.white, size: 16),
                              SizedBox(width: 6),
                              Text("FloatDock HUD", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _isBubbleExpanded = false;
                              });
                            },
                            child: const Icon(Icons.close, color: Colors.white70, size: 16),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white70),
                      _buildFloatingActionRow(Icons.content_paste, "Copy Stack (${_clipboardItems.length})", () {
                        _showFloatingNotification("Pasted top clip from dock!");
                      }),
                      _buildFloatingActionRow(Icons.calculate, "Quick Calc HUD", () {
                        _showFloatingNotification("Calc HUD triggered!");
                      }),
                      _buildFloatingActionRow(Icons.volume_up, "Speak Reader", () {
                        setState(() {
                          _isPlayingSpeech = !_isPlayingSpeech;
                        });
                        _showFloatingNotification(_isPlayingSpeech ? "Speech Started" : "Speech Paused");
                      }),
                    ],
                  ),
                )
              : const CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.layers, color: Colors.white, size: 24),
                ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionRow(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 14),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // HELPER WIDGETS
  Widget _buildHeaderCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String badgeText,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: badgeColor.withOpacity(0.2),
            child: Icon(icon, color: badgeColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        badgeText,
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorChip(String label, Color color) {
    final bool isSelected = _hudThemeColor == color;
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 11, color: Colors.white)),
      selected: isSelected,
      selectedColor: color,
      backgroundColor: const Color(0xFF0F172A),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _hudThemeColor = color;
          });
        }
      },
    );
  }

  Widget _buildQuickLauncherCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountButton(double percent) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0F172A),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        onPressed: () {
          final double pA = double.tryParse(_itemA PriceController.text) ?? 0.0;
          if (pA > 0) {
            final double discounted = pA * (1 - percent / 100);
            _showFloatingNotification("${percent.toInt()}% Off Option A: \$${discounted.toStringAsFixed(2)}");
          }
        },
        child: Text("-${percent.toInt()}%", style: const TextStyle(color: Colors.tealAccent, fontSize: 12)),
      ),
    );
  }

  // PATTERN EXTRACTOR LOGIC
  void _runPatternExtractor() {
    final String text = _rawTextController.text;
    final RegExp priceRegex = RegExp(r'\$\d+(\.\d{1,2})?');
    final RegExp emailRegex = RegExp(r'[\w\.-]+@[\w\.-]+\.\w+');
    final RegExp phoneRegex = RegExp(r'\+?\d[\d\s\-\(\)]{8,}\d');

    final prices = priceRegex.allMatches(text).map((m) => m.group(0)).toList();
    final emails = emailRegex.allMatches(text).map((m) => m.group(0)).toList();
    final phones = phoneRegex.allMatches(text).map((m) => m.group(0)).toList();

    int addedCount = 0;
    setState(() {
      for (var p in prices) {
        if (p != null) {
          _clipboardItems.insert(0, {'type': 'Price', 'content': p, 'tag': 'Extracted'});
          addedCount++;
        }
      }
      for (var e in emails) {
        if (e != null) {
          _clipboardItems.insert(0, {'type': 'Email', 'content': e, 'tag': 'Contact'});
          addedCount++;
        }
      }
      for (var ph in phones) {
        if (ph != null) {
          _clipboardItems.insert(0, {'type': 'Phone', 'content': ph, 'tag': 'Contact'});
          addedCount++;
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Extracted $addedCount items into Clipboard Stack!"), duration: const Duration(seconds: 2)),
    );
  }

  void _showAddClipDialog() {
    final TextEditingController clipController = TextEditingController();
    String selectedTag = 'General';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text("Add New Clip", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: clipController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Enter text snippet...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                if (clipController.text.isNotEmpty) {
                  setState(() {
                    _clipboardItems.insert(0, {
                      'type': 'Custom',
                      'content': clipController.text,
                      'tag': selectedTag,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Save Clip", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showFloatingNotification(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _hudThemeColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 70, left: 20, right: 20),
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getClipTagColor(String tag) {
    switch (tag) {
      case 'Shopping':
      case 'Deal':
        return Colors.amber;
      case 'Contact':
        return Colors.teal;
      case 'Coupon':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  IconData _getClipIcon(String type) {
    switch (type) {
      case 'Link':
        return Icons.link;
      case 'Price':
        return Icons.monetization_on;
      case 'Phone':
        return Icons.phone;
      case 'Code':
        return Icons.qr_code;
      default:
        return Icons.notes;
    }
  }
}