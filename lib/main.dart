import 'package:flutter/material.dart';

void main() {
  runApp(const OmniDockApp());
}

class OmniDockApp extends StatelessWidget {
  const OmniDockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniDock Assist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainDockScreen(),
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

class MainDockScreen extends StatefulWidget {
  const MainDockScreen({super.key});

  @override
  State<MainDockScreen> createState() => _MainDockScreenState();
}

class _MainDockScreenState extends State<MainDockScreen> {
  int _currentIndex = 0;
  bool _isFloatingServiceActive = true;
  bool _showFloatingOverlay = true;
  Offset _bubbleOffset = const Offset(20, 200);

  // Initial mock data for everyday utility
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: '1',
      title: 'Primary Bank Account',
      content: 'ACC: 9876-5432-1098 | IFSC/Swift: OMNI0004',
      category: 'Finance',
      icon: Icons.monetization_on,
    ),
    SnippetItem(
      id: '2',
      title: 'Home Delivery Address',
      content: '42 Lotus Avenue, 3rd Floor, Tech Park District, NY 10001',
      category: 'Personal',
      icon: Icons.home,
    ),
    SnippetItem(
      id: '3',
      title: 'Quick WhatsApp Response',
      content: 'Hey! I am currently busy in a meeting. I will call you back shortly.',
      category: 'Templates',
      icon: Icons.chat,
    ),
    SnippetItem(
      id: '4',
      title: 'Promo Discount Code',
      content: 'SAVE20NOW',
      category: 'Shopping',
      icon: Icons.discount,
    ),
  ];

  String _searchQuery = '';
  String _selectedCategory = 'All';

  // Shopping Calc controllers
  final TextEditingController _priceController = TextEditingController(text: '150');
  final TextEditingController _discountController = TextEditingController(text: '15');
  final TextEditingController _taxController = TextEditingController(text: '8');

  double _finalPrice = 0.0;
  double _savedAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateShopping();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _discountController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  void _calculateShopping() {
    final double originalPrice = double.tryParse(_priceController.text) ?? 0.0;
    final double discountPercent = double.tryParse(_discountController.text) ?? 0.0;
    final double taxPercent = double.tryParse(_taxController.text) ?? 0.0;

    final double discountVal = originalPrice * (discountPercent / 100);
    final double priceAfterDiscount = originalPrice - discountVal;
    final double taxVal = priceAfterDiscount * (taxPercent / 100);

    setState(() {
      _savedAmount = discountVal;
      _finalPrice = priceAfterDiscount + taxVal;
    });
  }

  void _copyToClipboard(String text, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Copied $label to clipboard!',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addNewSnippetModal() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    String category = 'Personal';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Quick Snippet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Snippet Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contentCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Content / Text to copy',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                StatefulBuilder(
                  builder: (context, setModalState) {
                    return Wrap(
                      spacing: 8,
                      children: ['Personal', 'Finance', 'Shopping', 'Templates'].map((cat) {
                        final isSelected = category == cat;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setModalState(() {
                                category = cat;
                              });
                            }
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Save Snippet'),
                    onPressed: () {
                      if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                        setState(() {
                          _snippets.insert(
                            0,
                            SnippetItem(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              title: titleCtrl.text,
                              content: contentCtrl.text,
                              category: category,
                              icon: category == 'Finance'
                                  ? Icons.monetization_on
                                  : category == 'Shopping'
                                      ? Icons.discount
                                      : category == 'Templates'
                                          ? Icons.chat
                                          : Icons.bookmark,
                            ),
                          );
                        });
                        Navigator.pop(ctx);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Screen Body by Navigation Index
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      _buildDashboardTab(),
                      _buildSnippetVaultTab(),
                      _buildShoppingCalcTab(),
                      _buildFloatingOverlaySettingsTab(),
                    ],
                  ),
                ),
              ],
            ),

            // Interactive Simulated Floating Overlay Bubble (Display Above Apps preview)
            if (_showFloatingOverlay && _isFloatingServiceActive)
              Positioned(
                left: _bubbleOffset.dx,
                top: _bubbleOffset.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _bubbleOffset += details.delta;
                    });
                  },
                  onTap: () {
                    _showFloatingMenuDialog();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.tealAccent, width: 1.5),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bolt, color: Colors.amber, size: 20),
                        SizedBox(width: 6),
                        Text(
                          'OmniDock',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.touch_app, color: Colors.white70, size: 14),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Assist Hub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy),
            label: 'Snippets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Quick Calc',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Overlay Dock',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF1E293B),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.widgets, color: Colors.tealAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'OmniDock Assist',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _isFloatingServiceActive ? 'Screen Overlay: ACTIVE' : 'Screen Overlay: INACTIVE',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isFloatingServiceActive ? Colors.greenAccent : Colors.orangeAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isFloatingServiceActive,
            activeColor: Colors.tealAccent,
            onChanged: (val) {
              setState(() {
                _isFloatingServiceActive = val;
              });
            },
          ),
        ],
      ),
    );
  }

  // TAB 1: Dashboard & Active Floating Status
  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.indigo, Color(0xFF312E81)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.verified_user, color: Colors.tealAccent),
                    SizedBox(width: 8),
                    Text(
                      'Universal Ambient Assistant',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Never leave your app to switch texts, check standard details, or compute discounts while messaging or online shopping.',
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.check, size: 16, color: Colors.tealAccent),
                      label: const Text('Floating Dock Ready', style: TextStyle(fontSize: 11)),
                      backgroundColor: Colors.black87,
                    ),
                    Chip(
                      avatar: const Icon(Icons.shield, size: 16, color: Colors.amberAccent),
                      label: const Text('Local Data Secured', style: TextStyle(fontSize: 11)),
                      backgroundColor: Colors.black87,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Quick Action Dock Widgets',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),

          // Grid of Quick Actions
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _buildWidgetCard(
                title: 'Copy Bank ID',
                subtitle: '1-Tap clipboard paste',
                icon: Icons.monetization_on,
                color: Colors.teal,
                onTap: () {
                  _copyToClipboard('ACC: 9876-5432-1098', 'Bank Details');
                },
              ),
              _buildWidgetCard(
                title: 'Copy Address',
                subtitle: 'Delivery location',
                icon: Icons.home,
                color: Colors.purple,
                onTap: () {
                  _copyToClipboard('42 Lotus Avenue, 3rd Floor, NY', 'Address');
                },
              ),
              _buildWidgetCard(
                title: 'Instant Calc',
                subtitle: 'Discount & tax floating matrix',
                icon: Icons.calculate,
                color: Colors.blue,
                onTap: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
              ),
              _buildWidgetCard(
                title: 'Text Vault',
                subtitle: '${_snippets.length} Saved Snippets',
                icon: Icons.snippet_folder,
                color: Colors.deepOrange,
                onTap: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Notification Style Status Pill
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Row(
              children: [
                const Icon(Icons.notifications_active, color: Colors.amber),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Floating Notification Pill Active',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _showFloatingOverlay
                            ? 'Simulated persistent overlay widget visible on screen.'
                            : 'Overlay icon hidden. Enable from Overlay Dock settings.',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showFloatingOverlay = !_showFloatingOverlay;
                    });
                  },
                  child: Text(_showFloatingOverlay ? 'Hide' : 'Show'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetCard({
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(icon, color: color, size: 18),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 12),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: Snippet Vault
  Widget _buildSnippetVaultTab() {
    final filteredSnippets = _snippets.where((s) {
      final matchesSearch = s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.content.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || s.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Column(
      children: [
        // Search & Add Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search snippets...',
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFF1E293B),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addNewSnippetModal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.all(14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Icon(Icons.add, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Category Filter Pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Finance', 'Personal', 'Shopping', 'Templates'].map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: Colors.indigo,
                        backgroundColor: const Color(0xFF1E293B),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (selected) {
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

        // Snippet List
        Expanded(
          child: filteredSnippets.isEmpty
              ? const Center(
                  child: Text(
                    'No snippets found. Tap + to create one!',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredSnippets.length,
                  itemBuilder: (ctx, index) {
                    final item = filteredSnippets[index];
                    return Card(
                      color: const Color(0xFF1E293B),
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.white70),
                      ),
                      child: ListTile,
                    );
                  },
                ),
        ),
      ],
    );
  }

  // Extension helper for ListTile formatting in Snippet Tab
  Widget _buildSnippetCard(SnippetItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white70),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(item.icon, color: Colors.tealAccent, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.category,
                    style: const TextStyle(fontSize: 10, color: Colors.tealAccent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.content,
              style: const TextStyle(fontSize: 13, color: Colors.white70),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                  onPressed: () {
                    setState(() {
                      _snippets.removeWhere((element) => element.id == item.id);
                    });
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  icon: const Icon(Icons.content_copy, size: 16),
                  label: const Text('1-Tap Copy', style: TextStyle(fontSize: 12)),
                  onPressed: () {
                    _copyToClipboard(item.content, item.title);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // TAB 3: Quick Shopping Discount & Tax Calculator Matrix
  Widget _buildShoppingCalcTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.shopping_bag, color: Colors.amber),
                    SizedBox(width: 8),
                    Text(
                      'Live Discount & Tax Matrix',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Instantly compute real item price while shopping on Amazon, eBay, or store apps.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                // Input fields
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateShopping(),
                  decoration: const InputDecoration(
                    labelText: 'Original Price (\$)',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _discountController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _calculateShopping(),
                        decoration: const InputDecoration(
                          labelText: 'Discount %',
                          suffixText: '%',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _taxController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _calculateShopping(),
                        decoration: const InputDecoration(
                          labelText: 'Tax %',
                          suffixText: '%',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Result Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF047857), Color(0xFF065F46)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'You Save:',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    Text(
                      '\$${_savedAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.amberAccent,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white70, height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Final Payable Price:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    FittedBox(
                      child: Text(
                        '\$${_finalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white70),
                    ),
                    icon: const Icon(Icons.content_copy, size: 16),
                    label: Text('Copy Payable \$${_finalPrice.toStringAsFixed(2)}'),
                    onPressed: () {
                      _copyToClipboard('\$${_finalPrice.toStringAsFixed(2)}', 'Final Price');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 4: Overlay & Dock Customizer Settings
  Widget _buildFloatingOverlaySettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Service & Permissions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Display Above Other Apps', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Simulates persistent floating pill over home screen', style: TextStyle(fontSize: 12)),
                  value: _isFloatingServiceActive,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() {
                      _isFloatingServiceActive = val;
                    });
                  },
                ),
                const Divider(height: 1, color: Colors.white70),
                SwitchListTile(
                  title: const Text('Show Bubble Preview In App', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Draggable floating button on current screen', style: TextStyle(fontSize: 12)),
                  value: _showFloatingOverlay,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() {
                      _showFloatingOverlay = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Quick Notification Priority Bar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),

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
                const Row(
                  children: [
                    Icon(Icons.tune, color: Colors.indigoAccent),
                    SizedBox(width: 8),
                    Text(
                      'System Tray Quick Pin',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Keep 1-tap copy snippets directly inside Android/iOS pull-down notification status bar for instant paste.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.notifications_active, size: 16),
                      label: const Text('Pin Bank Snippet to Status Bar'),
                      onPressed: () {
                        _copyToClipboard('Bank Details Pinned to Notifications', 'Notification Bar');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Floating menu dialog triggered when user clicks the active floating bubble preview
  void _showFloatingMenuDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.bolt, color: Colors.amber),
              SizedBox(width: 8),
              Text('OmniDock Quick Action', style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.monetization_on, color: Colors.tealAccent),
                title: const Text('Copy Bank Account', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  _copyToClipboard('ACC: 9876-5432-1098', 'Bank Account');
                },
              ),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.purpleAccent),
                title: const Text('Copy Delivery Address', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  _copyToClipboard('42 Lotus Avenue, NY 10001', 'Address');
                },
              ),
              ListTile(
                leading: const Icon(Icons.discount, color: Colors.orangeAccent),
                title: const Text('Copy Promo Code', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  _copyToClipboard('SAVE20NOW', 'Promo Code');
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Helper method inside state to render snippet cards without overflow
  Widget _buildSnippetVaultTabList() {
    final filtered = _snippets.where((s) {
      final matchesSearch = s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.content.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCat = _selectedCategory == 'All' || s.category == _selectedCategory;
      return matchesSearch && matchesCat;
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filtered.length,
      itemBuilder: (context, i) {
        return _buildSnippetCard(filtered[i]);
      },
    );
  }
}