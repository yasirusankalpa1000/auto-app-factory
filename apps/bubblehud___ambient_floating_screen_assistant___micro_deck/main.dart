import 'package:flutter/material.dart';

void main() {
  runApp(const BubbleHUDApp());
}

class BubbleHUDApp extends StatelessWidget {
  const BubbleHUDApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BubbleHUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF12131C),
        primaryColor: Colors.teal,
        colorScheme: const ColorScheme.dark(
          primary: Colors.teal,
          secondary: Colors.cyan,
          surface: Color(0xFF1E1F2E),
        ),
        useMaterial3: true,
      ),
      home: const MainHUDOverlayScreen(),
    );
  }
}

class MainHUDOverlayScreen extends StatefulWidget {
  const MainHUDOverlayScreen({Key? key}) : super(key: key);

  @override
  State<MainHUDOverlayScreen> createState() => _MainHUDOverlayScreenState();
}

class _MainHUDOverlayScreenState extends State<MainHUDOverlayScreen> {
  int _currentNavIndex = 0;
  
  // Floating Bubble State
  Offset _bubblePosition = const Offset(20, 200);
  bool _isBubbleExpanded = false;
  bool _isFloatingEnabled = true;
  
  // Tint Overlay State
  bool _isEyeShieldActive = false;
  double _eyeShieldOpacity = 0.25;
  Color _eyeShieldColor = Colors.amber;

  // Floating Notes Memory
  final List<String> _pinnedNotes = [
    "Wi-Fi Code: GuestPass@2025",
    "Order #849202 - Pickup 5 PM",
    "Account IBAN: US94 8830 1920 382"
  ];
  final TextEditingController _newNoteController = TextEditingController();

  // Price Comparer State
  final TextEditingController _itemAPriceController = TextEditingController(text: "12.50");
  final TextEditingController _itemAQtyController = TextEditingController(text: "300");
  final TextEditingController _itemBPriceController = TextEditingController(text: "18.00");
  final TextEditingController _itemBQtyController = TextEditingController(text: "500");
  String _comparisonResult = "Enter values to compare best deal";

  @override
  void dispose() {
    _newNoteController.dispose();
    _itemAPriceController.dispose();
    _itemAQtyController.dispose();
    _itemBPriceController.dispose();
    _itemBQtyController.dispose();
    super.dispose();
  }

  void _calculatePriceComparison() {
    final double? priceA = double.tryParse(_itemAPriceController.text);
    final double? qtyA = double.tryParse(_itemAQtyController.text);
    final double? priceB = double.tryParse(_itemBPriceController.text);
    final double? qtyB = double.tryParse(_itemBQtyController.text);

    if (priceA != null && qtyA != null && priceB != null && qtyB != null && qtyA > 0 && qtyB > 0) {
      final double unitA = priceA / qtyA;
      final double unitB = priceB / qtyB;

      setState(() {
        if (unitA < unitB) {
          final double diff = ((unitB - unitA) / unitB) * 100;
          _comparisonResult = "Option A is ${diff.toStringAsFixed(1)}% CHEAPER!\n(\$${unitA.toStringAsFixed(4)} / unit vs \$${unitB.toStringAsFixed(4)} / unit)";
        } else if (unitB < unitA) {
          final double diff = ((unitA - unitB) / unitA) * 100;
          _comparisonResult = "Option B is ${diff.toStringAsFixed(1)}% CHEAPER!\n(\$${unitB.toStringAsFixed(4)} / unit vs \$${unitA.toStringAsFixed(4)} / unit)";
        } else {
          _comparisonResult = "Both options offer the EXACT SAME value!";
        }
      });
    } else {
      setState(() {
        _comparisonResult = "Please enter valid numerical prices and quantities.";
      });
    }
  }

  void _showNotificationBanner(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.widgets, color: Colors.cyan, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2A2C3D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // MAIN APP TABS CONTENT
          SafeArea(
            child: Column(
              children: [
                _buildHeaderBar(),
                Expanded(
                  child: IndexedStack(
                    index: _currentNavIndex,
                    children: [
                      _buildDashboardTab(screenSize),
                      _buildPriceComparerTab(),
                      _buildFloatingDeckTab(),
                      _buildSettingsAndAdTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // AMBIENT EYE SHIELD OVERLAY (Simulated System Tint)
          if (_isEyeShieldActive)
            IgnorePointer(
              child: Container(
                width: screenSize.width,
                height: screenSize.height,
                color: _eyeShieldColor.withOpacity(_eyeShieldOpacity),
              ),
            ),

          // DRAGGABLE FLOATING HUD BUBBLE (Simulated System Floating Widget)
          if (_isFloatingEnabled)
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    double newX = _bubblePosition.dx + details.delta.dx;
                    double newY = _bubblePosition.dy + details.delta.dy;

                    // Keep bubble bounded inside screen limits
                    newX = newX.clamp(10.0, screenSize.width - 70.0);
                    newY = newY.clamp(50.0, screenSize.height - 120.0);

                    _bubblePosition = Offset(newX, newY);
                  });
                },
                onTap: () {
                  setState(() {
                    _isBubbleExpanded = !_isBubbleExpanded;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: _isBubbleExpanded ? 280 : 60,
                  height: _isBubbleExpanded ? 320 : 60,
                  padding: EdgeInsets.all(_isBubbleExpanded ? 12 : 0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _isBubbleExpanded
                          ? [const Color(0xFF202336), const Color(0xFF181A28)]
                          : [Colors.teal, Colors.cyan],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(_isBubbleExpanded ? 24 : 30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: _isBubbleExpanded
                      ? _buildExpandedBubbleContent()
                      : const Center(
                          child: Icon(
                            Icons.widgets,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
        backgroundColor: const Color(0xFF181926),
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'HUD Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_rounded),
            label: 'Compare',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers_rounded),
            label: 'Clip Deck',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune_rounded),
            label: 'Control',
          ),
        ],
      ),
    );
  }

  // --- TOP HEADER BAR ---
  Widget _buildHeaderBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF181926),
        border: Border(bottom: BorderSide(color: Color(0xFF2A2C3D), width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.widgets, color: Colors.cyan, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BubbleHUD System',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Active Overlay Assistant',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Switch(
            value: _isFloatingEnabled,
            activeColor: Colors.cyan,
            onChanged: (val) {
              setState(() {
                _isFloatingEnabled = val;
                if (!val) _isBubbleExpanded = false;
              });
              _showNotificationBanner(
                val ? "Floating HUD Bubble Enabled" : "Floating Overlay Hidden",
              );
            },
          ),
        ],
      ),
    );
  }

  // --- TAB 1: HUD DASHBOARD ---
  Widget _buildDashboardTab(Size screenSize) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Status Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1F283D), Color(0xFF151B29)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.cyan, size: 32),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Floating Assistant Active',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isFloatingEnabled
                            ? 'Drag the bubble on screen. Tap to expand micro-tools while using other apps.'
                            : 'Floating bubble is currently turned off.',
                        style: const TextStyle(fontSize: 12, color: Colors.white70),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Quick Overlay Assistants',
            style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),

          // Eye Shield Mode Control Card
          _buildQuickAssistantCard(
            title: 'Ambient Eye Shield Tint',
            subtitle: 'Overlays a warm comfort reading shield over your daily activities.',
            icon: Icons.light_mode,
            iconColor: Colors.amber,
            trailingWidget: Switch(
              value: _isEyeShieldActive,
              activeColor: Colors.amber,
              onChanged: (val) {
                setState(() {
                  _isEyeShieldActive = val;
                });
                _showNotificationBanner(val ? "Reading Eye Shield ON" : "Reading Eye Shield OFF");
              },
            ),
            child: _isEyeShieldActive
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text('Shield Intensity:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Slider(
                        value: _eyeShieldOpacity,
                        min: 0.1,
                        max: 0.6,
                        activeColor: Colors.amber,
                        onChanged: (val) {
                          setState(() {
                            _eyeShieldOpacity = val;
                          });
                        },
                      ),
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildColorChip('Warm Gold', Colors.amber),
                          _buildColorChip('Soft Amber', Colors.deepOrange),
                          _buildColorChip('Midnight Blue', Colors.indigo),
                        ],
                      )
                    ],
                  )
                : null,
          ),
          const SizedBox(height: 14),

          // Shopping Assistant Quick Access
          _buildQuickAssistantCard(
            title: 'Unit Price Micro-Comparer',
            subtitle: 'Stop getting fooled by bulk packaging. Quickly check price per gram or unit.',
            icon: Icons.shopping_cart,
            iconColor: Colors.cyan,
            trailingWidget: IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.cyan),
              onPressed: () {
                setState(() {
                  _currentNavIndex = 1;
                });
              },
            ),
          ),
          const SizedBox(height: 14),

          // Persistent Clipboard Deck Card
          _buildQuickAssistantCard(
            title: 'Floating Clip Deck',
            subtitle: 'Hold persistent text snippets, OTP codes, and reference links on screen.',
            icon: Icons.content_copy,
            iconColor: Colors.teal,
            trailingWidget: IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal),
              onPressed: () {
                setState(() {
                  _currentNavIndex = 2;
                });
              },
            ),
          ),
          const SizedBox(height: 20),

          // Daily Tip Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2030),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber, size: 24),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Pro Tip: Leave BubbleHUD enabled while online shopping or studying to access floating tools in 1 tap!',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorChip(String label, Color color) {
    final bool isSelected = _eyeShieldColor == color;
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 11, color: Colors.white)),
      selected: isSelected,
      selectedColor: color.withOpacity(0.8),
      backgroundColor: const Color(0xFF2A2C3D),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _eyeShieldColor = color;
          });
        }
      },
    );
  }

  Widget _buildQuickAssistantCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    Widget? trailingWidget,
    Widget? child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1F2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2C3D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              if (trailingWidget != null) trailingWidget,
            ],
          ),
          if (child != null) child,
        ],
      ),
    );
  }

  // --- TAB 2: SHOPPING PRICE-PER-UNIT COMPARER ---
  Widget _buildPriceComparerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Unit Price Micro-Comparer',
            style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Calculate which product option gives you more value per gram, ml, or item count.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          // Option A Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1F2E),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.teal.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.shopping_bag_outlined, color: Colors.teal, size: 18),
                    SizedBox(width: 6),
                    Text('Option A (e.g. Small Pack)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _itemAPriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Price (\$)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _itemAQtyController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Qty (g / ml / pcs)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Option B Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1F2E),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.cyan.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.shopping_bag_outlined, color: Colors.cyan, size: 18),
                    SizedBox(width: 6),
                    Text('Option B (e.g. Family Pack)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.cyan)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _itemBPriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Price (\$)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _itemBQtyController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Qty (g / ml / pcs)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _calculatePriceComparison,
              icon: const Icon(Icons.calculate, color: Colors.white),
              label: const Text('Compare Best Value', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Result Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF25283B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.amber.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified, color: Colors.amber, size: 20),
                    SizedBox(width: 6),
                    Text('DEAL ANALYSIS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _comparisonResult,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 3: FLOATING CLIPBOARD DECK ---
  Widget _buildFloatingDeckTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Floating Clipboard Deck',
              style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            const Text(
              'Keep important strings pinned so you can copy them in 1-tap while browsing.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              softWrap: true,
            ),
            const SizedBox(height: 14),

            // Input to add new snippet
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newNoteController,
                    decoration: const InputDecoration(
                      hintText: 'Add snippet (e.g. Code, Address)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: () {
                    if (_newNoteController.text.trim().isNotEmpty) {
                      setState(() {
                        _pinnedNotes.add(_newNoteController.text.trim());
                        _newNoteController.clear();
                      });
                      _showNotificationBanner("Snippet added to Clip Deck!");
                    }
                  },
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(backgroundColor: Colors.teal),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // List of pinned snippets
            Expanded(
              child: _pinnedNotes.isEmpty
                  ? const Center(
                      child: Text('No pinned snippets yet.', style: TextStyle(color: Colors.grey)),
                    )
                  : ListView.builder(
                      itemCount: _pinnedNotes.length,
                      itemBuilder: (context, index) {
                        final snippet = _pinnedNotes[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1F2E),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF2A2C3D)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.pin_drop, color: Colors.cyan, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  snippet,
                                  style: const TextStyle(color: Colors.white, fontSize: 13),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy, color: Colors.teal, size: 18),
                                onPressed: () {
                                  _showNotificationBanner("Copied to clipboard: '$snippet'");
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                                onPressed: () {
                                  setState(() {
                                    _pinnedNotes.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 4: SYSTEM CONTROLS & ADMOB PREVIEW ---
  Widget _buildSettingsAndAdTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Controls & Settings',
            style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),

          // Floating Permission Simulator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1F2E),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF2A2C3D)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'System Permissions Status',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                ),
                const SizedBox(height: 12),
                _buildPermissionRow('Display Over Other Apps', true),
                const Divider(color: Color(0xFF2A2C3D)),
                _buildPermissionRow('Floating Notifications Badge', true),
                const Divider(color: Color(0xFF2A2C3D)),
                _buildPermissionRow('Background Activity Optimization', false),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ADMOB MONETIZATION INTEGRATION BANNER
          const Text(
            'Sponsor & Ambient Ad Bar',
            style: TextStyle(fontSize: 14, FontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF281F3D), Color(0xFF1E182E)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.purple.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('AD', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'AdMob Banner Zone Activated',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'High retention floating overlay apps naturally generate top eCPM revenue via continuous active screen time.',
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                  softWrap: true,
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    _showNotificationBanner("Rewarded Ad Triggered - Premium Themes Unlocked!");
                  },
                  icon: const Icon(Icons.star, color: Colors.amber, size: 16),
                  label: const Text('Unlock Custom Themes (Watch Ad)', style: TextStyle(color: Colors.amber, fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.amber),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRow(String title, bool isGranted) {
    return Row(
      children: [
        Icon(
          isGranted ? Icons.check_circle : Icons.warning_amber_rounded,
          color: isGranted ? Colors.teal : Colors.amber,
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 13, color: Colors.white),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          isGranted ? 'GRANTED' : 'ENABLE',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isGranted ? Colors.teal : Colors.amber,
          ),
        ),
      ],
    );
  }

  // --- EXPANDED MINI BUBBLE CONTENT ---
  Widget _buildExpandedBubbleContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.widgets, color: Colors.cyan, size: 18),
                SizedBox(width: 6),
                Text(
                  'BubbleHUD Mini',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isBubbleExpanded = false;
                });
              },
              child: const Icon(Icons.close, color: Colors.grey, size: 18),
            ),
          ],
        ),
        const Divider(color: Color(0xFF2A2C3D)),
        const SizedBox(height: 4),

        const Text('Quick Clipboard Deck:', style: TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 6),
        Expanded(
          child: _pinnedNotes.isEmpty
              ? const Center(child: Text('No notes', style: TextStyle(fontSize: 11, color: Colors.grey)))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _pinnedNotes.length,
                  itemBuilder: (context, i) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF282A3E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _pinnedNotes[i],
                              style: const TextStyle(fontSize: 11, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _showNotificationBanner("Copied: ${_pinnedNotes[i]}");
                            },
                            child: const Icon(Icons.copy, color: Colors.cyan, size: 14),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),

        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isEyeShieldActive = !_isEyeShieldActive;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _isEyeShieldActive ? Colors.amber : const Color(0xFF2A2C3D),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                _isEyeShieldActive ? 'Tint ON' : 'Tint OFF',
                style: const TextStyle(fontSize: 11, color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isBubbleExpanded = false;
                  _currentNavIndex = 1;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Compare', style: TextStyle(fontSize: 11, color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }
}