import 'package:flutter/material.dart';

void main() {
  runApp(const PocketDockApp());
}

class PocketDockApp extends StatelessWidget {
  const PocketDockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PocketDock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF12141D),
        primaryColor: Colors.indigo,
        colorScheme: const ColorScheme.dark(
          primary: Colors.indigoAccent,
          secondary: Colors.tealAccent,
          surface: Color(0xFF1E2230),
        ),
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
  
  // App State & Permissions Simulation
  bool _overlayPermission = true;
  bool _notificationPermission = true;
  bool _dockActive = true;
  bool _showFloatingBubble = true;

  // Stats
  int _dockTouches = 142;
  double _hoursSaved = 4.8;
  int _snippetsStashed = 18;

  // Draggable Bubble Position
  double _bubbleX = 20.0;
  double _bubbleY = 180.0;

  // Stashed snippets
  final List<Map<String, String>> _snippets = [
    {
      'title': 'Bank Account (Commercial)',
      'content': 'ACC: 8009123490 - John Doe (Branch: City Center)',
      'category': 'Finance',
      'pinned': 'true',
    },
    {
      'title': 'Delivery Address',
      'content': 'No 45/2, Lotus Road, Green Park Avenue, Ward 07',
      'category': 'Personal',
      'pinned': 'true',
    },
    {
      'title': 'Wi-Fi Password',
      'content': 'GuestConnect@2025#Secure',
      'category': 'Quick Copy',
      'pinned': 'false',
    },
  ];

  // Micro Tools State
  final TextEditingController _hourlyWageController = TextEditingController(text: "15");
  final TextEditingController _itemPriceController = TextEditingController(text: "85");
  double _calculatedHoursToWork = 5.67;

  final TextEditingController _billAmountController = TextEditingController(text: "42.00");
  double _tipPercentage = 15.0;
  int _splitPeople = 2;

  @override
  void dispose() {
    _hourlyWageController.dispose();
    _itemPriceController.dispose();
    _billAmountController.dispose();
    super.dispose();
  }

  void _calculateImpulse() {
    final wage = double.tryParse(_hourlyWageController.text) ?? 1.0;
    final price = double.tryParse(_itemPriceController.text) ?? 0.0;
    setState(() {
      _calculatedHoursToWork = price / (wage > 0 ? wage : 1.0);
    });
  }

  void _addSnippet(String title, String content, String category) {
    setState(() {
      _snippets.insert(0, {
        'title': title,
        'content': content,
        'category': category,
        'pinned': 'false',
      });
      _snippetsStashed++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content Area
            Column(
              children: [
                // Top Simulated Active Notification Bar
                _buildActiveNotificationTray(),
                
                // Screen Pages
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      _buildOverlayDockTab(),
                      _buildSmartStashTab(),
                      _buildImpulseGuardTab(),
                      _buildStatsAndSettingsTab(),
                    ],
                  ),
                ),
              ],
            ),

            // Dynamic Simulated Overlay Floating Bubble Widget
            if (_showFloatingBubble && _dockActive)
              Positioned(
                left: _bubbleX,
                top: _bubbleY,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _bubbleX += details.delta.dx;
                      _bubbleY += details.delta.dy;
                    });
                  },
                  onTap: () {
                    setState(() {
                      _dockTouches++;
                    });
                    _showQuickBubbleModal(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.indigoAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.5),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.widgets,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E2230),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Floating Dock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy),
            label: 'Quick Stash',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Impulse Guard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }

  // Active Notification Tray Simulation Widget
  Widget _buildActiveNotificationTray() {
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.bolt, color: Colors.amber, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'POCKET DOCK ACTIVE OVERLAY',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                Text(
                  _dockActive ? 'Floating Assistant Running • Tap bubble to launch' : 'Dock Paused',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Switch(
            value: _dockActive,
            activeColor: Colors.tealAccent,
            onChanged: (val) {
              setState(() {
                _dockActive = val;
              });
            },
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating Overlay Dock Settings & Live Controls
  Widget _buildOverlayDockTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(
            title: 'Always-On Screen Floating Assistant',
            subtitle: 'Access text clips, bill splitters & wage calculators over any application.',
            icon: Icons.layers,
            color: Colors.indigo,
          ),
          const SizedBox(height: 20),
          const Text(
            'System Permissions & Overlay Controls',
            style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          _buildPermissionTile(
            title: 'Display Over Other Apps',
            subtitle: 'Allows floating widget bubble on home screen and inside apps',
            icon: Icons.phone_android,
            value: _overlayPermission,
            onChanged: (v) => setState(() => _overlayPermission = v),
          ),
          const SizedBox(height: 10),
          _buildPermissionTile(
            title: 'Floating Notification Bar',
            subtitle: 'Keep quick stash pinned inside status bar drawer',
            icon: Icons.notifications_active,
            value: _notificationPermission,
            onChanged: (v) => setState(() => _notificationPermission = v),
          ),
          const SizedBox(height: 10),
          _buildPermissionTile(
            title: 'Show Draggable Floating Bubble',
            subtitle: 'Simulate on-screen touch bubble in this app',
            icon: Icons.widgets,
            value: _showFloatingBubble,
            onChanged: (v) => setState(() => _showFloatingBubble = v),
          ),
          const SizedBox(height: 24),
          const Text(
            'Pinned Quick Dock Actions',
            style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildActionButton(
                label: 'Bank Card Floating Overlay',
                icon: Icons.monetization_on,
                color: Colors.teal,
                onTap: () => _showQuickBubbleModal(context),
              ),
              _buildActionButton(
                label: 'Quick Stash Snippet',
                icon: Icons.content_copy,
                color: Colors.indigoAccent,
                onTap: () => setState(() => _currentIndex = 1),
              ),
              _buildActionButton(
                label: 'Work-Hour Converter',
                icon: Icons.schedule,
                color: Colors.amber,
                onTap: () => setState(() => _currentIndex = 2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TAB 2: Smart Clipboard & Floating Text Stash
  Widget _buildSmartStashTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Quick Text Stash',
                  style: TextStyle(fontSize: 20, FontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                ),
                onPressed: () => _showAddSnippetDialog(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Stash', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Stash account numbers, Wi-Fi keys, and text for 1-tap floating access.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
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
                  color: const Color(0xFF1E2230),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: item['pinned'] == 'true' ? Colors.tealAccent.withOpacity(0.4) : Colors.transparent,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.indigo.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item['category'] ?? 'General',
                            style: const TextStyle(fontSize: 11, color: Colors.indigoAccent, FontWeight: FontWeight.bold),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            item['pinned'] == 'true' ? Icons.star : Icons.star_border,
                            color: item['pinned'] == 'true' ? Colors.amber : Colors.grey,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              item['pinned'] = item['pinned'] == 'true' ? 'false' : 'true';
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                          onPressed: () {
                            setState(() {
                              _snippets.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['title'] ?? '',
                      style: const TextStyle(fontSize: 15, FontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      item['content'] ?? '',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.tealAccent),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Copied: ${item['title']} to clipboard!'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.content_copy, size: 14, color: Colors.tealAccent),
                          label: const Text('Copy Now', style: TextStyle(color: Colors.tealAccent, fontSize: 12)),
                        ),
                      ],
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

  // TAB 3: Impulse Buyer Guard & Micro Utility Tools
  Widget _buildImpulseGuardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(
            title: 'Impulse Purchase Guard',
            subtitle: 'Converts item prices into hours of your life worked to stop unnecessary buying!',
            icon: Icons.shield,
            color: Colors.teal,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2230),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.tealAccent.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _hourlyWageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Your Hourly Wage (\$)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => _calculateImpulse(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _itemPriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Item Price (\$)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => _calculateImpulse(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'THIS ITEM COSTS YOU',
                        style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1),
                      ),
                      const SizedBox(height: 6),
                      FittedBox(
                        child: Text(
                          '${_calculatedHoursToWork.toStringAsFixed(1)} WORK HOURS',
                          style: const TextStyle(
                            fontSize: 26,
                            FontWeight: FontWeight.bold,
                            color: Colors.tealAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _calculatedHoursToWork > 8
                            ? '⚠️ Equivalent to ${(_calculatedHoursToWork / 8).toStringAsFixed(1)} full work days!'
                            : '💡 Think twice: Will this item bring persistent value?',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.amber, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Instant Bill & Tip Splitter Overlay Tool',
            style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2230),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _billAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Total Bill Amount (\$)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tip: ${_tipPercentage.toInt()}%', style: const TextStyle(color: Colors.white)),
                    Text('Split between: $_splitPeople people', style: const TextStyle(color: Colors.white)),
                  ],
                ),
                Slider(
                  value: _tipPercentage,
                  min: 0,
                  max: 30,
                  divisions: 6,
                  activeColor: Colors.indigoAccent,
                  onChanged: (val) => setState(() => _tipPercentage = val),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.grey),
                      onPressed: () {
                        if (_splitPeople > 1) setState(() => _splitPeople--);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '$_splitPeople',
                        style: const TextStyle(fontSize: 18, FontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.tealAccent),
                      onPressed: () => setState(() => _splitPeople++),
                    ),
                  ],
                ),
                const Divider(color: Colors.white70, height: 24),
                _buildSplitSummary(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 4: Dashboard & Time-Saved Statistics
  Widget _buildStatsAndSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(
            title: 'Productivity & Screen Time Saved',
            subtitle: 'PocketDock minimizes continuous app switching and impulse spending.',
            icon: Icons.stars,
            color: Colors.amber,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Est. Hours Saved',
                  value: '${_hoursSaved.toStringAsFixed(1)} hrs',
                  icon: Icons.schedule,
                  color: Colors.tealAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: 'Floating Dock Touches',
                  value: '$_dockTouches',
                  icon: Icons.widgets,
                  color: Colors.indigoAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Clips & Snippets',
                  value: '$_snippetsStashed items',
                  icon: Icons.content_copy,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: 'Impulse Avoided',
                  value: '\$145.00',
                  icon: Icons.shield,
                  color: Colors.greenAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Quick Dock Theme Customizer',
            style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2230),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.palette, color: Colors.tealAccent),
                  title: const Text('Floating Bubble Accent Color'),
                  trailing: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.indigoAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const Divider(color: Colors.white70),
                ListTile(
                  leading: const Icon(Icons.vibration, color: Colors.tealAccent),
                  title: const Text('Haptic Feedback on Dock Touch'),
                  trailing: Switch(
                    value: true,
                    activeColor: Colors.tealAccent,
                    onChanged: (v) {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets & Dialogs ---

  Widget _buildHeaderCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2230),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, FontWeight: FontWeight.bold, color: Colors.white),
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
        ],
      ),
    );
  }

  Widget _buildPermissionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2230),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: value ? Colors.tealAccent : Colors.grey),
        title: Text(title, style: const TextStyle(fontSize: 14, FontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.white70)),
        trailing: Switch(
          value: value,
          activeColor: Colors.tealAccent,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2230),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontSize: 13, color: Colors.white, FontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2230),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplitSummary() {
    final totalBill = double.tryParse(_billAmountController.text) ?? 0.0;
    final tipAmount = totalBill * (_tipPercentage / 100);
    final grandTotal = totalBill + tipAmount;
    final perPerson = grandTotal / (_splitPeople > 0 ? _splitPeople : 1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            const Text('Total + Tip', style: TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 2),
            Text(
              '\$${grandTotal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, FontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        Container(width: 1, height: 30, color: Colors.white70),
        Column(
          children: [
            const Text('Each Person Pays', style: TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 2),
            Text(
              '\$${perPerson.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, FontWeight: FontWeight.bold, color: Colors.tealAccent),
            ),
          ],
        ),
      ],
    );
  }

  void _showQuickBubbleModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E2230),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.widgets, color: Colors.tealAccent, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Floating Pocket Overlay Preview',
                      style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Quick Copy Pinned Snippets:',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 10),
                ..._snippets.take(2).map((s) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                Text(s['content'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 11), overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.content_copy, color: Colors.tealAccent, size: 18),
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Copied ${s['title']}!')),
                              );
                            },
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddSnippetDialog() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    String category = 'Quick Copy';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E2230),
          title: const Text('Add Quick Stash Snippet'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Title (e.g. Bank Account)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Text Content to Copy',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black),
              onPressed: () {
                if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                  _addSnippet(titleCtrl.text, contentCtrl.text, category);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Stash'),
            ),
          ],
        );
      },
    );
  }
}