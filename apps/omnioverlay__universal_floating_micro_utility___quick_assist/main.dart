import 'package:flutter/material.dart';

void main() {
  runApp(const OmniOverlayApp());
}

class OmniOverlayApp extends StatelessWidget {
  const OmniOverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniOverlay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainOverlayScreen(),
    );
  }
}

class ClipboardItem {
  final String id;
  final String text;
  final String category;
  final DateTime timestamp;

  ClipboardItem({
    required this.id,
    required this.text,
    required this.category,
    required this.timestamp,
  });
}

class MainOverlayScreen extends StatefulWidget {
  const MainOverlayScreen({super.key});

  @override
  State<MainOverlayScreen> createState() => _MainOverlayScreenState();
}

class _MainOverlayScreenState extends State<MainOverlayScreen> {
  int _activeTabIndex = 0;

  // Floating Overlay Bubble Position
  double _bubbleX = 20.0;
  double _bubbleY = 180.0;
  bool _isOverlayActive = true;
  bool _isExpandedBubble = false;
  String _activeFloatingTool = 'menu'; // 'menu', 'clipboard', 'calc', 'note'

  // Permissions State (Simulated System Settings)
  bool _permDisplayAbove = true;
  bool _permNotifications = true;
  bool _permAutoClipboard = false;

  // Multi-Clipboard Stack
  final List<ClipboardItem> _clipboardStack = [
    ClipboardItem(
      id: '1',
      text: 'Shipping Address: 742 Evergreen Terrace, Springfield',
      category: 'Address',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    ClipboardItem(
      id: '2',
      text: 'Promo Code: SAVE25NOW',
      category: 'Promo',
      timestamp: DateTime.now().subtract(const Duration(minutes: 42)),
    ),
    ClipboardItem(
      id: '3',
      text: 'Meeting Notes: Review Q3 product designs and AdMob integrations',
      category: 'Work',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  // Floating Calculator State
  double _origPrice = 89.99;
  double _discountPercent = 20.0;
  double _taxPercent = 8.0;

  // Sticky Note State
  String _floatingNote = 'Quick Note: Buy groceries & check package delivery status!';
  double _noteOpacity = 0.85;

  // Notification Banner Simulation
  String? _bannerNotification;

  // Analytics Stats
  int _toolsUsedToday = 28;
  int _minutesSaved = 45;

  void _showNotification(String message) {
    setState(() {
      _bannerNotification = message;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _bannerNotification = null;
        });
      }
    });
  }

  void _addClipboardSnippet(String text, String category) {
    if (text.trim().isEmpty) return;
    setState(() {
      _clipboardStack.insert(
        0,
        ClipboardItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text.trim(),
          category: category,
          timestamp: DateTime.now(),
        ),
      );
      _toolsUsedToday++;
    });
    _showNotification('Saved to Overlay Multi-Clipboard!');
  }

  double _calculateFinalPrice() {
    double discounted = _origPrice - (_origPrice * (_discountPercent / 100.0));
    double finalPrice = discounted + (discounted * (_taxPercent / 100.0));
    return finalPrice < 0 ? 0 : finalPrice;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Dashboard View
            Column(
              children: [
                _buildHeader(),
                if (_bannerNotification != null) _buildLiveNotificationBanner(),
                Expanded(
                  child: IndexedStack(
                    index: _activeTabIndex,
                    children: [
                      _buildDashboardTab(),
                      _buildClipboardTab(),
                      _buildCalculatorTab(),
                      _buildSettingsTab(),
                    ],
                  ),
                ),
              ],
            ),

            // SIMULATED SYSTEM FLOATING OVERLAY BUBBLE & HUD
            if (_isOverlayActive)
              Positioned(
                left: _bubbleX,
                top: _bubbleY,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _bubbleX += details.delta.dx;
                      _bubbleY += details.delta.dy;
                      // Keep within bounds
                      if (_bubbleX < 0) _bubbleX = 0;
                      if (_bubbleY < 50) _bubbleY = 50;
                      if (_bubbleX > screenSize.width - 70) {
                        _bubbleX = screenSize.width - 70;
                      }
                      if (_bubbleY > screenSize.height - 150) {
                        _bubbleY = screenSize.height - 150;
                      }
                    });
                  },
                  child: _buildFloatingBubbleHUD(),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activeTabIndex,
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.white70,
        backgroundColor: const Color(0xFF1E293B),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _activeTabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Hub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy),
            label: 'Clipboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Quick Calc',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Overlay Mode',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(
          bottom: BorderSide(color: Colors.white70, width: 1.0),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.layers, color: Colors.tealAccent, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'OmniOverlay',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Floating Utility & Screen Assistant',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _isOverlayActive ? Icons.flash_on : Icons.flash_off,
              color: _isOverlayActive ? Colors.tealAccent : Colors.grey,
            ),
            tooltip: 'Toggle Floating Bubble',
            onPressed: () {
              setState(() {
                _isOverlayActive = !_isOverlayActive;
              });
              _showNotification(
                _isOverlayActive
                    ? 'Floating Overlay Activated!'
                    : 'Floating Overlay Suspended',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLiveNotificationBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.tealAccent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.tealAccent.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: Colors.tealAccent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _bannerNotification ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 1: HUB DASHBOARD ---
  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade700, const Color(0xFF0F172A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.bolt, color: Colors.amberAccent, size: 20),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'ACTIVE SCREEN ASSISTANT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.amberAccent,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Floating Tools Enabled & Ready',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  softWrap: true,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Drag the green bubble anywhere on screen to trigger instant multi-clipboard, shopping discount math, or transparent sticky notes.',
                  style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.4),
                  softWrap: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Productivity Stats Row
          const Text(
            'Daily Engagement & Savings',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Micro Tools Used',
                  value: '$_toolsUsedToday times',
                  icon: Icons.speed,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: 'App Switch Time Saved',
                  value: '$_minutesSaved mins',
                  icon: Icons.schedule,
                  color: Colors.tealAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Quick Action Tools Launcher
          const Text(
            'Quick Overlay Launchers',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          _buildLauncherTile(
            title: 'Floating Multi-Clipboard Stack',
            subtitle: 'Access saved addresses, promo codes, and texts instantly over any app.',
            icon: Icons.content_copy,
            color: Colors.indigoAccent,
            onTap: () {
              setState(() {
                _isOverlayActive = true;
                _isExpandedBubble = true;
                _activeFloatingTool = 'clipboard';
              });
            },
          ),
          const SizedBox(height: 10),
          _buildLauncherTile(
            title: 'Instant Shopping Discount & Tax Calc',
            subtitle: 'Calculate final prices with discounts & taxes while shopping online.',
            icon: Icons.monetization_on,
            color: Colors.greenAccent,
            onTap: () {
              setState(() {
                _isOverlayActive = true;
                _isExpandedBubble = true;
                _activeFloatingTool = 'calc';
              });
            },
          ),
          const SizedBox(height: 10),
          _buildLauncherTile(
            title: 'Transparent Floating Sticky Note',
            subtitle: 'Overlay reference text or reading prompts with customizable transparency.',
            icon: Icons.note,
            color: Colors.orangeAccent,
            onTap: () {
              setState(() {
                _isOverlayActive = true;
                _isExpandedBubble = true;
                _activeFloatingTool = 'note';
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: Colors.white70),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLauncherTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white70),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    softWrap: true,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 14),
          ],
        ),
      ),
    );
  }

  // --- TAB 2: MULTI-CLIPBOARD MANAGER ---
  Widget _buildClipboardTab() {
    final TextEditingController newSnippetController = TextEditingController();
    String selectedCategory = 'General';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Multi-Clipboard Memory Stack',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'Keep multiple copied texts ready to paste anytime without losing previous clipboard data.',
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 16),

          // Add Snippet Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              children: [
                TextField(
                  controller: newSnippetController,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(
                    hintText: 'Enter text, link, address, or promo code...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['General', 'Address', 'Promo', 'Work'].map((cat) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: ChoiceChip(
                                label: Text(cat, style: const TextStyle(fontSize: 11)),
                                selected: selectedCategory == cat,
                                onSelected: (val) {
                                  setState(() {
                                    selectedCategory = cat;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Save Snippet'),
                      onPressed: () {
                        _addClipboardSnippet(newSnippetController.text, selectedCategory);
                        newSnippetController.clear();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Clipboard Stack List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Saved Snippets (${_clipboardStack.length})',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              TextButton.icon(
                icon: const Icon(Icons.delete_sweep, size: 16, color: Colors.white70),
                label: const Text('Clear All', style: TextStyle(color: Colors.white70, fontSize: 12)),
                onPressed: () {
                  setState(() {
                    _clipboardStack.clear();
                  });
                  _showNotification('Clipboard stack cleared');
                },
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (_clipboardStack.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('No saved clips yet. Add one above!', style: TextStyle(color: Colors.white70)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _clipboardStack.length,
              itemBuilder: (context, index) {
                final item = _clipboardStack[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white70),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.category,
                          style: const TextStyle(color: Colors.tealAccent, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.text,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.content_copy, color: Colors.tealAccent, size: 18),
                        tooltip: 'Copy',
                        onPressed: () {
                          _showNotification('Copied: "${item.text}"');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white70, size: 18),
                        tooltip: 'Delete',
                        onPressed: () {
                          setState(() {
                            _clipboardStack.removeAt(index);
                          });
                        },
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

  // --- TAB 3: SHOPPING DISCOUNT & TAX CALCULATOR ---
  Widget _buildCalculatorTab() {
    double finalPrice = _calculateFinalPrice();
    double totalDiscount = _origPrice * (_discountPercent / 100.0);
    double totalTax = (_origPrice - totalDiscount) * (_taxPercent / 100.0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Instant Shopping Price Calculator',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'Calculates final checkout price while browsing online stores, applying discount percentages and local taxes.',
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 16),

          // Result Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade800, const Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigoAccent.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                const Text('ESTIMATED FINAL CHECKOUT PRICE', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  '\$${finalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                ),
                const SizedBox(height: 12),
                const Divider(color: Colors.white70),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Original', style: TextStyle(color: Colors.white70, fontSize: 11)),
                        const SizedBox(height: 2),
                        Text('\$${_origPrice.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('You Save', style: TextStyle(color: Colors.white70, fontSize: 11)),
                        const SizedBox(height: 2),
                        Text('-\$${totalDiscount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Tax Added', style: TextStyle(color: Colors.white70, fontSize: 11)),
                        const SizedBox(height: 2),
                        Text('+\$${totalTax.toStringAsFixed(2)}', style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Sliders & Controls
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Original Tag Price: \$${_origPrice.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Slider(
                  value: _origPrice,
                  min: 1.0,
                  max: 500.0,
                  activeColor: Colors.tealAccent,
                  inactiveColor: Colors.white70,
                  onChanged: (val) {
                    setState(() {
                      _origPrice = val;
                    });
                  },
                ),
                const SizedBox(height: 12),

                Text(
                  'Discount: ${_discountPercent.toStringAsFixed(0)}%',
                  style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Slider(
                  value: _discountPercent,
                  min: 0.0,
                  max: 90.0,
                  divisions: 18,
                  activeColor: Colors.amberAccent,
                  inactiveColor: Colors.white70,
                  onChanged: (val) {
                    setState(() {
                      _discountPercent = val;
                    });
                  },
                ),
                const SizedBox(height: 12),

                Text(
                  'Sales Tax / VAT: ${_taxPercent.toStringAsFixed(1)}%',
                  style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Slider(
                  value: _taxPercent,
                  min: 0.0,
                  max: 30.0,
                  divisions: 30,
                  activeColor: Colors.orangeAccent,
                  inactiveColor: Colors.white70,
                  onChanged: (val) {
                    setState(() {
                      _taxPercent = val;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: OVERLAY PERMISSIONS & SETTINGS ---
  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Overlay Controls',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'Configure floating bubble permissions and transparency settings.',
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 16),

          // Permission Switches
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Display Over Other Apps', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Allows floating bubble HUD above browsers & apps', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  value: _permDisplayAbove,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() {
                      _permDisplayAbove = val;
                      _isOverlayActive = val;
                    });
                    _showNotification(val ? 'Display Over Apps Enabled' : 'Display Over Apps Disabled');
                  },
                ),
                const Divider(color: Colors.white70),
                SwitchListTile(
                  title: const Text('System Notification Access', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Show quick pop-up alerts when copying text', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  value: _permNotifications,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() {
                      _permNotifications = val;
                    });
                  },
                ),
                const Divider(color: Colors.white70),
                SwitchListTile(
                  title: const Text('Auto-Sync Background Clipboard', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Automatically capture copied texts into stack', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  value: _permAutoClipboard,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() {
                      _permAutoClipboard = val;
                    });
                    _showNotification(val ? 'Clipboard Listener Active' : 'Clipboard Listener Paused');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Sticky Note Transparency Setting
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overlay Sticky Note Opacity: ${(_noteOpacity * 100).toInt()}%',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                const Text('Adjust how see-through the floating note is over other apps.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                Slider(
                  value: _noteOpacity,
                  min: 0.2,
                  max: 1.0,
                  activeColor: Colors.tealAccent,
                  inactiveColor: Colors.white70,
                  onChanged: (val) {
                    setState(() {
                      _noteOpacity = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.all(14),
              ),
              icon: const Icon(Icons.notifications_active, color: Colors.white),
              label: const Text('Test Floating Alert Notification', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () {
                _showNotification('OmniOverlay is active in the background!');
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- FLOATING OVERLAY HUD & BUBBLE WIDGET ---
  Widget _buildFloatingBubbleHUD() {
    if (!_isExpandedBubble) {
      // MINIMIZED FLOATING BUBBLE
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.teal.shade600,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.tealAccent.withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isExpandedBubble = true;
            });
          },
          child: const Icon(Icons.layers, color: Colors.white, size: 28),
        ),
      );
    }

    // EXPANDED FLOATING OVERLAY TOOL WINDOW
    return Container(
      width: 290,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(_noteOpacity),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.tealAccent, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 16,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.flash_on, color: Colors.tealAccent, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    _activeFloatingTool == 'clipboard'
                        ? 'Quick Clips'
                        : _activeFloatingTool == 'calc'
                            ? 'Price Calc'
                            : _activeFloatingTool == 'note'
                                ? 'Sticky Note'
                                : 'Overlay Launcher',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.widgets, color: Colors.white70, size: 16),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      setState(() {
                        _activeFloatingTool = 'menu';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70, size: 16),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      setState(() {
                        _isExpandedBubble = false;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const Divider(color: Colors.white70, height: 12),

          // Dynamic Content based on selected floating tool
          if (_activeFloatingTool == 'menu') _buildFloatingMenuContent(),
          if (_activeFloatingTool == 'clipboard') _buildFloatingClipboardContent(),
          if (_activeFloatingTool == 'calc') _buildFloatingCalcContent(),
          if (_activeFloatingTool == 'note') _buildFloatingNoteContent(),
        ],
      ),
    );
  }

  Widget _buildFloatingMenuContent() {
    return Column(
      children: [
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.content_copy, color: Colors.indigoAccent, size: 20),
          title: const Text('Multi-Clipboard Stack', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          subtitle: Text('${_clipboardStack.length} clips stored', style: const TextStyle(color: Colors.white70, fontSize: 10)),
          onTap: () {
            setState(() {
              _activeFloatingTool = 'clipboard';
            });
          },
        ),
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.monetization_on, color: Colors.greenAccent, size: 20),
          title: const Text('Shopping Price & Tax Calc', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          subtitle: Text('Final: \$${_calculateFinalPrice().toStringAsFixed(2)}', style: const TextStyle(color: Colors.white70, fontSize: 10)),
          onTap: () {
            setState(() {
              _activeFloatingTool = 'calc';
            });
          },
        ),
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.note, color: Colors.orangeAccent, size: 20),
          title: const Text('Transparent Sticky Note', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          subtitle: const Text('Quick reference overlay', style: TextStyle(color: Colors.white70, fontSize: 10)),
          onTap: () {
            setState(() {
              _activeFloatingTool = 'note';
            });
          },
        ),
      ],
    );
  }

  Widget _buildFloatingClipboardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_clipboardStack.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text('No clipboard items.', style: TextStyle(color: Colors.white70, fontSize: 11)),
          )
        else
          Container(
            constraints: const BoxConstraints(maxHeight: 140),
            child: SingleChildScrollView(
              child: Column(
                children: _clipboardStack.map((clip) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            clip.text,
                            style: const TextStyle(color: Colors.white, fontSize: 11),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.content_copy, color: Colors.tealAccent, size: 14),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            _showNotification('Copied snippet!');
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFloatingCalcContent() {
    double finalPrice = _calculateFinalPrice();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Final Price:', style: TextStyle(color: Colors.white70, fontSize: 12)),
            Text(
              '\$${finalPrice.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Tag: \$', style: TextStyle(color: Colors.white70, fontSize: 11)),
            SizedBox(
              width: 50,
              height: 30,
              child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontSize: 11),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                ),
                controller: TextEditingController(text: _origPrice.toStringAsFixed(0)),
                onChanged: (val) {
                  double? parsed = double.tryParse(val);
                  if (parsed != null) {
                    setState(() {
                      _origPrice = parsed;
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            const Text('Off: ', style: TextStyle(color: Colors.white70, fontSize: 11)),
            SizedBox(
              width: 40,
              height: 30,
              child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontSize: 11),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                ),
                controller: TextEditingController(text: _discountPercent.toStringAsFixed(0)),
                onChanged: (val) {
                  double? parsed = double.tryParse(val);
                  if (parsed != null) {
                    setState(() {
                      _discountPercent = parsed;
                    });
                  }
                },
              ),
            ),
            const Text('%', style: TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ],
    );
  }

  Widget _buildFloatingNoteContent() {
    final TextEditingController noteController = TextEditingController(text: _floatingNote);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: noteController,
          maxLines: 3,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          decoration: const InputDecoration(
            hintText: 'Type reference note here...',
            hintStyle: TextStyle(color: Colors.white70),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(8),
          ),
          onChanged: (val) {
            _floatingNote = val;
          },
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Opacity:', style: TextStyle(color: Colors.white70, fontSize: 10)),
            Expanded(
              child: Slider(
                value: _noteOpacity,
                min: 0.2,
                max: 1.0,
                activeColor: Colors.tealAccent,
                onChanged: (val) {
                  setState(() {
                    _noteOpacity = val;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}