import 'package:flutter/material.dart';

void main() {
  runApp(const FloatifyApp());
}

class FloatifyApp extends StatelessWidget {
  const FloatifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floatify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      home: const FloatifyMainScreen(),
    );
  }
}

class FloatifyMainScreen extends StatefulWidget {
  const FloatifyMainScreen({super.key});

  @override
  State<FloatifyMainScreen> createState() => _FloatifyMainScreenState();
}

class _FloatifyMainScreenState extends State<FloatifyMainScreen> {
  int _selectedTabIndex = 0;

  // Floating Overlay Bubble Position & State
  double _bubbleX = 20.0;
  double _bubbleY = 160.0;
  bool _isBubbleExpanded = false;
  bool _isOverlayEnabled = true;

  // Gamification & User Stats
  int _userPoints = 280;
  int _streakDays = 5;
  double _totalMoneySaved = 142.50;
  int _impulsePasses = 8;

  // Notification Alert Banner State
  String? _floatingBannerMessage;

  // Form Controllers for Impulse Calculator
  final TextEditingController _wageController = TextEditingController(text: '18.50');
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  // Custom Data Structures
  final List<Map<String, dynamic>> _impulseLogs = [
    {'item': 'Wireless Earbuds', 'cost': 49.99, 'hours': 2.7, 'passed': true, 'date': 'Today'},
    {'item': 'Designer Jacket', 'cost': 89.00, 'hours': 4.8, 'passed': true, 'date': 'Yesterday'},
    {'item': 'Fast Food Meal', 'cost': 14.50, 'hours': 0.8, 'passed': false, 'date': '3 days ago'},
  ];

  final List<Map<String, String>> _snippets = [
    {'title': 'Work Email', 'content': 'alex.pro.dev@example.com', 'category': 'Personal'},
    {'title': 'IBAN / Bank Code', 'content': 'US89370001234567891011', 'category': 'Finance'},
    {'title': 'Shipping Address', 'content': '742 Evergreen Terrace, Springfield', 'category': 'Shopping'},
    {'title': 'Standard Reply', 'content': 'Thanks for reaching out! I will check and reply shortly.', 'category': 'Quick Message'},
  ];

  final List<String> _scratchpadNotes = [
    'Confirm meeting agenda for 3 PM',
    'Verify subscription renewal date',
    'Check store discount code: SAVE20',
  ];

  final TextEditingController _newSnippetTitleController = TextEditingController();
  final TextEditingController _newSnippetContentController = TextEditingController();
  final TextEditingController _newNoteController = TextEditingController();

  void _showNotification(String message) {
    setState(() {
      _floatingBannerMessage = message;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _floatingBannerMessage = null;
        });
      }
    });
  }

  void _calculateImpulseFriction() {
    final double wage = double.tryParse(_wageController.text) ?? 0.0;
    final double cost = double.tryParse(_costController.text) ?? 0.0;
    final String item = _itemController.text.trim().isEmpty ? 'Item' : _itemController.text.trim();

    if (wage <= 0 || cost <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid wage and item price.')),
      );
      return;
    }

    final double hoursNeeded = cost / wage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shield_outlined, color: Colors.indigo, size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Impulse Reality Check',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade300),
                  ),
                  child: Column(
                    children: [
                      FittedBox(
                        child: Text(
                          '${hoursNeeded.toStringAsFixed(1)} HOURS',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'You must work ${hoursNeeded.toStringAsFixed(1)} hours of your life to buy "$item" (\$$cost).',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Is this item worth trading ${hoursNeeded.toStringAsFixed(1)} hours of your effort?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  softWrap: true,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _impulsePasses++;
                            _totalMoneySaved += cost;
                            _userPoints += 25;
                            _impulseLogs.insert(0, {
                              'item': item,
                              'cost': cost,
                              'hours': hoursNeeded,
                              'passed': true,
                              'date': 'Just now',
                            });
                          });
                          _itemController.clear();
                          _costController.clear();
                          _showNotification('🎉 Smart Move! You saved \$$cost and earned +25 pts!');
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Pass & Save'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.grey),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _impulseLogs.insert(0, {
                              'item': item,
                              'cost': cost,
                              'hours': hoursNeeded,
                              'passed': false,
                              'date': 'Just now',
                            });
                          });
                          _itemController.clear();
                          _costController.clear();
                          _showNotification('Logged purchase for "$item". Stay mindful next time!');
                        },
                        icon: const Icon(Icons.shopping_bag_outlined),
                        label: const Text('Bought It'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addNewSnippet() {
    final String title = _newSnippetTitleController.text.trim();
    final String content = _newSnippetContentController.text.trim();
    if (title.isEmpty || content.isEmpty) return;

    setState(() {
      _snippets.add({
        'title': title,
        'content': content,
        'category': 'Custom',
      });
      _newSnippetTitleController.clear();
      _newSnippetContentController.clear();
    });
    Navigator.pop(context);
    _showNotification('New snippet "$title" added to Float Clipboard!');
  }

  void _addNewNote() {
    final String note = _newNoteController.text.trim();
    if (note.isEmpty) return;

    setState(() {
      _scratchpadNotes.insert(0, note);
      _newNoteController.clear();
    });
    Navigator.pop(context);
    _showNotification('Quick scratchpad note saved!');
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bubble_chart, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Floatify',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '$_userPoints pts',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _isOverlayEnabled ? Icons.visibility : Icons.visibility_off,
              color: _isOverlayEnabled ? Colors.indigo : Colors.grey,
            ),
            tooltip: 'Toggle Overlay Widget',
            onPressed: () {
              setState(() {
                _isOverlayEnabled = !_isOverlayEnabled;
              });
              _showNotification(_isOverlayEnabled
                  ? 'Floating dynamic overlay bubble enabled!'
                  : 'Floating bubble hidden.');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Body Content based on active navigation tab
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Floating Banner Notification Simulator
                    if (_floatingBannerMessage != null) ...[
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade900,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: Colors.black87, blurRadius: 6, offset: Offset(0, 3)),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.notifications_active, color: Colors.amber, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _floatingBannerMessage!,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13),
                                softWrap: true,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _floatingBannerMessage = null;
                                });
                              },
                              child: const Icon(Icons.close, color: Colors.white70, size: 18),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Tab Views
                    if (_selectedTabIndex == 0) _buildOverviewDashboard(),
                    if (_selectedTabIndex == 1) _buildImpulseGuardTab(),
                    if (_selectedTabIndex == 2) _buildClipboardTab(),
                    if (_selectedTabIndex == 3) _buildScratchpadTab(),
                    if (_selectedTabIndex == 4) _buildHabitStreakTab(),
                  ],
                ),
              ),
            ),

            // INTERACTIVE DRAGGABLE FLOATING OVERLAY BUBBLE (Simulating Draw-Over-Apps / Floating HUD)
            if (_isOverlayEnabled) ...[
              Positioned(
                left: _bubbleX,
                top: _bubbleY,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _bubbleX += details.delta.dx;
                      _bubbleY += details.delta.dy;

                      // Screen boundaries safety clip
                      if (_bubbleX < 0) _bubbleX = 0;
                      if (_bubbleX > screenSize.width - 70) _bubbleX = screenSize.width - 70;
                      if (_bubbleY < 50) _bubbleY = 50;
                      if (_bubbleY > screenSize.height - 150) _bubbleY = screenSize.height - 150;
                    });
                  },
                  onTap: () {
                    setState(() {
                      _isBubbleExpanded = !_isBubbleExpanded;
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Floating Action Bubble Container
                      Material(
                        elevation: 8,
                        shape: const CircleBorder(),
                        color: Colors.indigo,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.indigo, Colors.blue],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Icon(
                            _isBubbleExpanded ? Icons.close : Icons.bubble_chart,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),

                      // Expanded Floating Quick Controls Card
                      if (_isBubbleExpanded) ...[
                        const SizedBox(height: 8),
                        Material(
                          elevation: 12,
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          child: Container(
                            width: 220,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.indigo.shade100),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.widgets_outlined, size: 16, color: Colors.indigo),
                                    const SizedBox(width: 6),
                                    const Expanded(
                                      child: Text(
                                        'Float HUD Menu',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.indigo),
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 12),
                                _buildFloatingMenuItem(
                                  icon: Icons.shield_outlined,
                                  title: 'Impulse Check',
                                  subtitle: 'Calculate cost in work hours',
                                  onTap: () {
                                    setState(() {
                                      _isBubbleExpanded = false;
                                      _selectedTabIndex = 1;
                                    });
                                  },
                                ),
                                _buildFloatingMenuItem(
                                  icon: Icons.content_paste_go,
                                  title: 'Quick Snippets',
                                  subtitle: 'Copy saved email/IBAN',
                                  onTap: () {
                                    setState(() {
                                      _isBubbleExpanded = false;
                                      _selectedTabIndex = 2;
                                    });
                                  },
                                ),
                                _buildFloatingMenuItem(
                                  icon: Icons.edit_note,
                                  title: 'Scratchpad',
                                  subtitle: 'Quick floating micro-note',
                                  onTap: () {
                                    setState(() {
                                      _isBubbleExpanded = false;
                                      _selectedTabIndex = 3;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTabIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedTabIndex = index;
            _isBubbleExpanded = false;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Colors.indigo),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield, color: Colors.indigo),
            label: 'Impulse',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_paste_outlined),
            selectedIcon: Icon(Icons.content_paste, color: Colors.indigo),
            label: 'Clipboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.note_alt_outlined),
            selectedIcon: Icon(Icons.note_alt, color: Colors.indigo),
            label: 'Scratchpad',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_outline),
            selectedIcon: Icon(Icons.star, color: Colors.indigo),
            label: 'Streaks',
          ),
        ],
      ),
    );
  }

  // WIDGET BUILDERS FOR TABS & COMPONENTS

  Widget _buildFloatingMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.indigo),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Floating Status Indicator Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.indigo, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _isOverlayEnabled ? Colors.greenAccent : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isOverlayEnabled ? 'FLOAT OVERLAY ACTIVE' : 'OVERLAY PAUSED',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _isOverlayEnabled,
                    activeColor: Colors.white,
                    activeTrackColor: Colors.teal,
                    onChanged: (val) {
                      setState(() {
                        _isOverlayEnabled = val;
                      });
                      _showNotification(val ? 'Floating Overlay activated!' : 'Floating Overlay disabled.');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Drag the floating bubble anywhere on your screen for instant impulse checks and micro-paste shortcuts.',
                style: TextStyle(color: Colors.white70, fontSize: 13),
                softWrap: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Quick Stats Metric Cards
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Saved Cash',
                value: '\$${_totalMoneySaved.toStringAsFixed(2)}',
                icon: Icons.monetization_on_outlined,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMetricCard(
                title: 'Passes',
                value: '$_impulsePasses items',
                icon: Icons.shield_outlined,
                color: Colors.indigo,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Quick Actions Widget Hub
        const Text(
          'Quick Utility Launchers',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAxisAlignment.center,
          children: [
            _buildQuickActionChip(
              icon: Icons.add_shopping_cart,
              label: 'Check Impulse Item',
              onTap: () => setState(() => _selectedTabIndex = 1),
            ),
            _buildQuickActionChip(
              icon: Icons.content_paste_sharp,
              label: 'Copy Snippet',
              onTap: () => setState(() => _selectedTabIndex = 2),
            ),
            _buildQuickActionChip(
              icon: Icons.edit,
              label: 'Add Floating Note',
              onTap: () => setState(() => _selectedTabIndex = 3),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Recent Impulse Logs Summary Card
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Decisions',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _selectedTabIndex = 1),
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const Divider(height: 8),
                ..._impulseLogs.take(3).map((log) {
                  final bool passed = log['passed'] as bool;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: passed ? Colors.green.shade100 : Colors.red.shade100,
                      child: Icon(
                        passed ? Icons.check : Icons.shopping_bag,
                        color: passed ? Colors.green : Colors.red,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      log['item'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      softWrap: true,
                    ),
                    subtitle: Text(
                      'Cost: \$${(log['cost'] as double).toStringAsFixed(2)} • ${(log['hours'] as double).toStringAsFixed(1)} hrs work',
                      style: const TextStyle(fontSize: 12),
                      softWrap: true,
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: passed ? Colors.green.shade50 : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        passed ? 'PASSED' : 'BOUGHT',
                        style: TextStyle(
                          color: passed ? Colors.green.shade900 : Colors.red.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                FittedBox(
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ActionChip(
      avatar: Icon(icon, size: 16, color: Colors.indigo),
      label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.indigo.shade100),
      onPressed: onTap,
    );
  }

  Widget _buildImpulseGuardTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Impulse Purchase Friction Guard',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'Calculate how much labor time an item costs you before buying online.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
          softWrap: true,
        ),
        const SizedBox(height: 16),

        // Inputs Container
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _wageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Your Hourly Wage (\$ / hour)',
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _itemController,
                decoration: const InputDecoration(
                  labelText: 'Item Name (e.g., Headphones)',
                  prefixIcon: Icon(Icons.shopping_bag_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _costController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Item Price (\$)',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _calculateImpulseFriction,
                icon: const Icon(Icons.calculate_outlined),
                label: const Text('Calculate Labor Cost', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Impulse Decision History',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        if (_impulseLogs.isEmpty) ...[
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('No decision logs yet.', textAlign: TextAlign.center),
          ),
        ] else ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _impulseLogs.length,
            itemBuilder: (context, index) {
              final log = _impulseLogs[index];
              final bool passed = log['passed'] as bool;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: Icon(
                    passed ? Icons.verified : Icons.remove_shopping_cart,
                    color: passed ? Colors.green : Colors.orange,
                  ),
                  title: Text(
                    log['item'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    softWrap: true,
                  ),
                  subtitle: Text(
                    'Cost: \$${(log['cost'] as double).toStringAsFixed(2)} (${(log['hours'] as double).toStringAsFixed(1)} hrs work)',
                    style: const TextStyle(fontSize: 12),
                    softWrap: true,
                  ),
                  trailing: Text(
                    log['date'] as String,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildClipboardTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smart Float Clipboard',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    softWrap: true,
                  ),
                  Text(
                    'Tap to instant-copy snippets while using other apps.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.indigo, size: 28),
              onPressed: () => _showAddSnippetDialog(),
            ),
          ],
        ),
        const SizedBox(height: 14),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _snippets.length,
          itemBuilder: (context, index) {
            final snippet = _snippets[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            snippet['category'] ?? 'General',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.indigo),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _snippets.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      snippet['title'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      softWrap: true,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(8),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        snippet['content'] ?? '',
                        style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                        onPressed: () {
                          _showNotification('Copied "${snippet['title']}" to float buffer!');
                        },
                        icon: const Icon(Icons.copy, size: 14),
                        label: const Text('Copy Snippet', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showAddSnippetDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add Snippet to Float Clipboard'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _newSnippetTitleController,
                decoration: const InputDecoration(
                  labelText: 'Title (e.g. Work Email)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _newSnippetContentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Snippet Content',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _addNewSnippet,
              child: const Text('Save Snippet'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildScratchpadTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Floating Scratchpad',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    softWrap: true,
                  ),
                  Text(
                    'Instant micro-notes pinned to your floating dynamic HUD.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.indigo, size: 28),
              onPressed: () => _showAddNoteDialog(),
            ),
          ],
        ),
        const SizedBox(height: 14),

        if (_scratchpadNotes.isEmpty) ...[
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Scratchpad is empty.'),
            ),
          ),
        ] else ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _scratchpadNotes.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(Icons.edit_note, color: Colors.indigo),
                  title: Text(
                    _scratchpadNotes[index],
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    softWrap: true,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                      setState(() {
                        _scratchpadNotes.removeAt(index);
                      });
                      _showNotification('Note completed!');
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('New Scratchpad Note'),
          content: TextField(
            controller: _newNoteController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Enter quick note...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _addNewNote,
              child: const Text('Add Note'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHabitStreakTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.indigo.shade900,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Icon(Icons.workspace_premium, color: Colors.amber, size: 48),
              const SizedBox(height: 8),
              Text(
                '$_streakDays DAYS STREAK',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Level 4: Mindful Buyer',
                style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: 0.7,
                backgroundColor: Colors.white70,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
              const SizedBox(height: 6),
              const Text(
                '120 pts to reach Level 5 (Frugal Master)',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Daily Smart Habits',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        _buildHabitTile(
          title: 'Pass 1 Impulse Purchase',
          subtitle: 'Resist buying an unnecessary item online',
          points: '+25 pts',
          isDone: true,
        ),
        _buildHabitTile(
          title: 'Keep Float Overlay Enabled',
          subtitle: 'Active background floating assistant widget',
          points: '+15 pts',
          isDone: _isOverlayEnabled,
        ),
        _buildHabitTile(
          title: 'Store 3 Clipboard Snippets',
          subtitle: 'Save time typing standard messages',
          points: '+20 pts',
          isDone: _snippets.length >= 3,
        ),
      ],
    );
  }

  Widget _buildHabitTile({
    required String title,
    required String subtitle,
    required String points,
    required bool isDone,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(
          isDone ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isDone ? Colors.green : Colors.grey,
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          softWrap: true,
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11),
          softWrap: true,
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            points,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.amber.shade900,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}