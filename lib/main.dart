import 'package:flutter/material.dart';

void main() {
  runApp(const ContextPulseApp());
}

class ContextPulseApp extends StatelessWidget {
  const ContextPulseApp({super.key});

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'ContextPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5FA),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  // Floating overlay simulation state
  bool _isOverlayEnabled = true;
  bool _isFloatingExpanded = false;
  double _bubblePositionX = 20.0;
  double _bubblePositionY = 200.0;
  
  // Stats tracking
  int _decisionsMade = 14;
  double _totalMoneySaved = 38.50;
  int _quickCopiesUsed = 29;

  // Notification simulation state
  bool _notificationsAllowed = true;
  bool _drawOverAppsAllowed = true;

  // Vault data
  final List<Map<String, String>> _vaultItems = [
    {
      'title': 'Delivery Address',
      'content': '124 Lotus Avenue, Suite 4B, Colombo 03',
      'category': 'Address'
    },
    {
      'title': 'Business Tax ID / TIN',
      'content': 'TIN-987654321-V',
      'category': 'Work'
    },
    {
      'title': 'Frequent Flyer Number',
      'content': 'FF-88392019-X',
      'category': 'Travel'
    },
    {
      'title': 'WiFi Password (Home)',
      'content': 'HyperSpeed@2025!',
      'category': 'Personal'
    },
  ];

  void _addNewVaultSnippet(String title, String content, String category) {
    setState(() {
      _vaultItems.insert(0, {
        'title': title,
        'content': content,
        'category': category,
      });
      _quickCopiesUsed++;
    });
  }

  void _showNotificationBanner(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.amber),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
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
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildDashboardView(),
                _buildBargainComparatorView(),
                _buildQuickCopyVaultView(),
                _buildBillSplitterView(),
                _buildSettingsAndPermissionsView(),
              ],
            ),
          ),
          
          // Simulated Floating Overlay Bubble
          if (_isOverlayEnabled)
            Positioned(
              left: _bubblePositionX,
              top: _bubblePositionY,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubblePositionX = (_bubblePositionX + details.delta.dx)
                        .clamp(10.0, screenSize.width - 70.0);
                    _bubblePositionY = (_bubblePositionY + details.delta.dy)
                        .clamp(50.0, screenSize.height - 120.0);
                  });
                },
                onTap: () {
                  setState(() {
                    _isFloatingExpanded = !_isFloatingExpanded;
                  });
                },
                child: Material(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  color: Colors.deepPurple,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.bolt,
                          color: Colors.amber,
                          size: 26,
                        ),
                        if (_isFloatingExpanded) ...[
                          const SizedBox(width: 8),
                          Flexible(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.calculate, color: Colors.white, size: 20),
                                    onPressed: () {
                                      setState(() => _currentIndex = 1);
                                      _showNotificationBanner('Opened Instant Bargain Calc');
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.content_copy, color: Colors.white, size: 20),
                                    onPressed: () {
                                      setState(() => _currentIndex = 2);
                                      _showNotificationBanner('Opened Quick Snippets');
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.splitscreen, color: Colors.white, size: 20),
                                    onPressed: () {
                                      setState(() => _currentIndex = 3);
                                      _showNotificationBanner('Opened Bill Splitter');
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                                    onPressed: () {
                                      setState(() => _isFloatingExpanded = false);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Hub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Bargain',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: 'Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Split',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Overlay',
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------
  // TAB 1: DASHBOARD HUB
  // ------------------------------------------------------------------
  Widget _buildDashboardView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.deepPurple, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black87,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'ContextPulse Floating Hub',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _isOverlayEnabled ? Colors.green : Colors.redAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isOverlayEnabled ? Icons.check_circle : Icons.pause_circle,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _isOverlayEnabled ? 'ACTIVE' : 'OFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your real-life daily micro-decision assistant. Quick calculations, floating copy snippets, and bargain scanners ready at any moment.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isOverlayEnabled = !_isOverlayEnabled;
                        });
                        _showNotificationBanner(_isOverlayEnabled
                            ? 'Floating Assistant Activated!'
                            : 'Floating Assistant Disabled');
                      },
                      icon: Icon(_isOverlayEnabled ? Icons.visibility_off : Icons.widgets),
                      label: Text(_isOverlayEnabled ? 'Hide Floating Overlay' : 'Enable Overlay Bubble'),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Daily Micro-Value Impact',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          // 3 Metric Cards
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Money Saved',
                  value: '\$${_totalMoneySaved.toStringAsFixed(2)}',
                  icon: Icons.savings,
                  iconColor: Colors.green,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricCard(
                  title: 'Decisions',
                  value: '$_decisionsMade',
                  icon: Icons.lightbulb,
                  iconColor: Colors.amber,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricCard(
                  title: 'Quick Copies',
                  value: '$_quickCopiesUsed',
                  icon: Icons.content_paste,
                  iconColor: Colors.blue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Text(
            'Instant Action Tools',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          _buildQuickActionTile(
            title: 'Bargain Unit-Price Comparator',
            subtitle: 'Find whether 500g for \$4.99 beats 750g for \$7.29 instantly.',
            icon: Icons.shopping_cart,
            color: Colors.teal,
            onTap: () => setState(() => _currentIndex = 1),
          ),
          const SizedBox(height: 10),
          _buildQuickActionTile(
            title: 'Floating Snippet Vault',
            subtitle: '1-tap access to addresses, tax IDs, codes without opening heavy apps.',
            icon: Icons.content_copy,
            color: Colors.indigo,
            onTap: () => setState(() => _currentIndex = 2),
          ),
          const SizedBox(height: 10),
          _buildQuickActionTile(
            title: 'Instant Bill & Tip Splitter',
            subtitle: 'Fair bill share calculation with custom tip percentages.',
            icon: Icons.payments,
            color: Colors.orange,
            onTap: () => setState(() => _currentIndex = 3),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
            softWrap: true,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionTile({
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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    softWrap: true,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // TAB 2: BARGAIN UNIT-PRICE COMPARATOR
  // ------------------------------------------------------------------
  final TextEditingController _item1PriceCtrl = TextEditingController(text: '4.99');
  final TextEditingController _item1QtyCtrl = TextEditingController(text: '500');
  final TextEditingController _item2PriceCtrl = TextEditingController(text: '7.20');
  final TextEditingController _item2QtyCtrl = TextEditingController(text: '750');
  String _selectedUnit = 'grams (g)';

  Widget _buildBargainComparatorView() {
    final double p1 = double.tryParse(_item1PriceCtrl.text) ?? 0.0;
    final double q1 = double.tryParse(_item1QtyCtrl.text) ?? 0.0;
    final double p2 = double.tryParse(_item2PriceCtrl.text) ?? 0.0;
    final double q2 = double.tryParse(_item2QtyCtrl.text) ?? 0.0;

    final double rate1 = (q1 > 0) ? (p1 / q1) : 0.0;
    final double rate2 = (q2 > 0) ? (p2 / q2) : 0.0;

    int bestItem = 0;
    double savingsPercent = 0.0;
    if (rate1 > 0 && rate2 > 0) {
      if (rate1 < rate2) {
        bestItem = 1;
        savingsPercent = ((rate2 - rate1) / rate2) * 100;
      } else if (rate2 < rate1) {
        bestItem = 2;
        savingsPercent = ((rate1 - rate2) / rate1) * 100;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shopping_bag, color: Colors.teal, size: 28),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Bargain Price-Per-Unit Scanner',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Never get tricked by grocery store packaging! Compare exact unit value.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Unit Selector
          Row(
            children: [
              const Text('Unit of measure: ', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _selectedUnit,
                items: ['grams (g)', 'ml / Liters', 'pcs / items', 'kg / lbs']
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedUnit = val);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Item 1 Card
          _buildItemInputCard(
            itemNumber: 1,
            priceCtrl: _item1PriceCtrl,
            qtyCtrl: _item1QtyCtrl,
            rate: rate1,
            isWinner: bestItem == 1,
            unitLabel: _selectedUnit,
          ),
          const SizedBox(height: 16),

          // Item 2 Card
          _buildItemInputCard(
            itemNumber: 2,
            priceCtrl: _item2PriceCtrl,
            qtyCtrl: _item2QtyCtrl,
            rate: rate2,
            isWinner: bestItem == 2,
            unitLabel: _selectedUnit,
          ),
          const SizedBox(height: 20),

          // Result Summary Banner
          if (bestItem > 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.shade300),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.stars, color: Colors.teal),
                      const SizedBox(width: 8),
                      Text(
                        'OPTION $bestItem IS THE BETTER DEAL!',
                        style: TextStyle(
                          color: Colors.teal.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'You save approximately ${savingsPercent.toStringAsFixed(1)}% per unit by choosing Option $bestItem.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.teal.shade800, fontSize: 13),
                    softWrap: true,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _decisionsMade++;
                        _totalMoneySaved += 1.25;
                      });
                      _showNotificationBanner('Saved bargain decision to daily stats!');
                    },
                    icon: const Icon(Icons.bookmark_add),
                    label: const Text('Log Smart Choice'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildItemInputCard({
    required int itemNumber,
    required TextEditingController priceCtrl,
    required TextEditingController qtyCtrl,
    required double rate,
    required bool isWinner,
    required String unitLabel,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isWinner ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isWinner ? Colors.green : Colors.grey.shade300,
          width: isWinner ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Option $itemNumber',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              if (isWinner)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'BEST VALUE',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: priceCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Price (\$)',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  ),
                  onChanged: (val) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: qtyCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    suffixText: unitLabel.split(' ').first,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  ),
                  onChanged: (val) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Unit Cost: \$${(rate * 100).toStringAsFixed(3)} per 100 ${unitLabel.split(' ').first}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isWinner ? Colors.green.shade900 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------
  // TAB 3: QUICK COPY VAULT
  // ------------------------------------------------------------------
  final TextEditingController _newTitleCtrl = TextEditingController();
  final TextEditingController _newContentCtrl = TextEditingController();
  String _selectedCategory = 'Personal';

  Widget _buildQuickCopyVaultView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.content_paste_sharp, color: Colors.indigo, size: 28),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Floating Quick-Copy Vault',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.indigo, size: 28),
                onPressed: () => _showAddSnippetDialog(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Keep your frequently typed snippets, numbers & notes ready for 1-tap copy.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _vaultItems.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 10),
            itemBuilder: (ctx, index) {
              final item = _vaultItems[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.indigo.shade50,
                      child: const Icon(Icons.notes, color: Colors.indigo),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  item['title'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item['category'] ?? '',
                                  style: const TextStyle(fontSize: 10, color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['content'] ?? '',
                            style: const TextStyle(color: Colors.black87, fontSize: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      onPressed: () {
                        setState(() {
                          _quickCopiesUsed++;
                        });
                        _showNotificationBanner('Copied "${item['title']}" to clipboard!');
                      },
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Copy'),
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

  void _showAddSnippetDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Quick Snippet'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _newTitleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Title (e.g. Work Address)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _newContentCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Text Content to Copy',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Category: '),
                        DropdownButton<String>(
                          value: _selectedCategory,
                          items: ['Personal', 'Work', 'Address', 'Travel', 'Banking']
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() => _selectedCategory = val);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_newTitleCtrl.text.isNotEmpty && _newContentCtrl.text.isNotEmpty) {
                      _addNewVaultSnippet(
                        _newTitleCtrl.text.trim(),
                        _newContentCtrl.text.trim(),
                        _selectedCategory,
                      );
                      _newTitleCtrl.clear();
                      _newContentCtrl.clear();
                      Navigator.pop(ctx);
                      _showNotificationBanner('New snippet added to Vault!');
                    }
                  },
                  child: const Text('Save Snippet'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ------------------------------------------------------------------
  // TAB 4: INSTANT BILL & TIP SPLITTER
  // ------------------------------------------------------------------
  double _totalBillAmount = 85.00;
  int _personCount = 3;
  double _tipPercentage = 15.0;

  Widget _buildBillSplitterView() {
    final double tipAmount = (_totalBillAmount * _tipPercentage) / 100;
    final double grandTotal = _totalBillAmount + tipAmount;
    final double perPersonAmount = (_personCount > 0) ? (grandTotal / _personCount) : grandTotal;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long, color: Colors.orange, size: 28),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Visual Bill & Tip Splitter',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Instantly calculate exact group splits with visual breakdown.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Total Per Person Highlight Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  'EACH PERSON PAYS',
                  style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '\$${perPersonAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Bill: \$${_totalBillAmount.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      'Tip: \$${tipAmount.toStringAsFixed(2)} (${_tipPercentage.toInt()}%)',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      'Total: \$${grandTotal.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Bill Amount Slider
          const Text('Total Bill Amount (\$)', style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _totalBillAmount,
            min: 5.0,
            max: 500.0,
            divisions: 99,
            activeColor: Colors.orange,
            label: '\$${_totalBillAmount.toStringAsFixed(0)}',
            onChanged: (val) {
              setState(() {
                _totalBillAmount = val;
              });
            },
          ),

          // People count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Number of People', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      if (_personCount > 1) {
                        setState(() => _personCount--);
                      }
                    },
                  ),
                  Text(
                    '$_personCount',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      setState(() => _personCount++);
                    },
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          // Tip selector chips
          const Text('Tip Percentage', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [0.0, 10.0, 15.0, 18.0, 20.0, 25.0].map((t) {
              final isSel = (_tipPercentage == t);
              return ChoiceChip(
                label: Text('${t.toInt()}%'),
                selected: isSel,
                selectedColor: Colors.orange,
                labelStyle: TextStyle(
                  color: isSel ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _tipPercentage = t);
                  }
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () {
              setState(() {
                _decisionsMade++;
              });
              _showNotificationBanner(
                  'Bill split calculated: \$${perPersonAmount.toStringAsFixed(2)} per person!');
            },
            icon: const Icon(Icons.share),
            label: const Text('Share Split Summary'),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------
  // TAB 5: OVERLAY SETTINGS & SYSTEM PERMISSIONS
  // ------------------------------------------------------------------
  Widget _buildSettingsAndPermissionsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune, color: Colors.deepPurple, size: 28),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Overlay & System Settings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Configure floating bubble appearance, app permissions, and simulated notifications.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Switch 1: Floating Overlay Toggle
          SwitchListTile(
            title: const Text('Enable Floating Overlay Bubble'),
            subtitle: const Text('Show floating icon over app screens for instant access'),
            value: _isOverlayEnabled,
            activeColor: Colors.deepPurple,
            onChanged: (val) {
              setState(() {
                _isOverlayEnabled = val;
              });
              _showNotificationBanner(val ? 'Overlay Enabled' : 'Overlay Disabled');
            },
          ),
          const Divider(),

          // Switch 2: Display Above Other Apps Simulation
          SwitchListTile(
            title: const Text('Display Above Apps Permission'),
            subtitle: const Text('Simulates Android SYSTEM_ALERT_WINDOW floating bubble permissions'),
            value: _drawOverAppsAllowed,
            activeColor: Colors.deepPurple,
            onChanged: (val) {
              setState(() {
                _drawOverAppsAllowed = val;
              });
              _showNotificationBanner(val
                  ? 'Display over apps permission granted'
                  : 'Display permission revoked');
            },
          ),
          const Divider(),

          // Switch 3: Floating Head Notifications
          SwitchListTile(
            title: const Text('Simulate Floating Notifications'),
            subtitle: const Text('Show quick pop-up alerts for copied items and bargain tips'),
            value: _notificationsAllowed,
            activeColor: Colors.deepPurple,
            onChanged: (val) {
              setState(() {
                _notificationsAllowed = val;
              });
            },
          ),
          const Divider(),

          const SizedBox(height: 12),
          const Text('Overlay Bubble Test Controls', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _bubblePositionX = 20.0;
                    _bubblePositionY = 200.0;
                    _isOverlayEnabled = true;
                  });
                  _showNotificationBanner('Floating bubble reset to top left!');
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reset Bubble Position'),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  _showNotificationBanner('Simulated Background Service Active!');
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Trigger Test Notification'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.purple.shade200),
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: Colors.deepPurple),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'ContextPulse runs lightweight background micro-tasks ensuring seamless floating accessibility without draining battery.',
                    style: TextStyle(fontSize: 12, color: Colors.deepPurple),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}