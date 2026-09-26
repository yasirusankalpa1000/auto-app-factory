import 'package:flutter/material.dart';

void main() {
  runApp(const FloatDeckApp());
}

class FloatDeckApp extends StatefulWidget {
  const FloatDeckApp({Key? key}) : super(key: key);

  @override
  State<FloatDeckApp> createState() => _FloatDeckAppState();
}

class _FloatDeckAppState extends State<FloatDeckApp> {
  bool _isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatDeck Pro',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFA5B4FC),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.indigoAccent,
          secondary: Colors.tealAccent,
          surface: Color(0xFF1E293B),
        ),
      ),
      home: FloatDeckHomeScreen(
        isDarkMode: _isDarkMode,
        onToggleTheme: () {
          setState(() {
            _isDarkMode = !_isDarkMode;
          });
        },
      ),
    );
  }
}

class FloatDeckHomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const FloatDeckHomeScreen({
    Key? key,
    required this.isDarkMode,
    required this.onToggleTheme,
  }) : super(key: key);

  @override
  State<FloatDeckHomeScreen> createState() => _FloatDeckHomeScreenState();
}

class _FloatDeckHomeScreenState extends State<FloatDeckHomeScreen> {
  int _selectedTabIndex = 0;

  // Floating Overlay State Simulation
  bool _isOverlayEnabled = true;
  bool _isNotificationBarActive = true;
  Offset _bubblePosition = const Offset(280.0, 320.0);
  bool _isBubbleExpanded = false;
  String _activeHUDMode = 'Multi-Clip';

  // Smart Clipboards Data
  final List<Map<String, String>> _clipboardItems = [
    {
      'title': 'National ID / NIC',
      'category': 'Identity',
      'value': '199530401822',
      'icon': 'security'
    },
    {
      'title': 'Primary Bank Account',
      'category': 'Finance',
      'value': 'Commercial Bank - 8009281721',
      'icon': 'monetization_on'
    },
    {
      'title': 'Home Delivery Address',
      'category': 'Personal',
      'value': 'No 45/2, Main Street, Colombo 03',
      'icon': 'place'
    },
    {
      'title': 'Work Email Signature',
      'category': 'Work',
      'value': 'Best regards,\nKasun Perera\nSenior Lead',
      'icon': 'email'
    },
  ];

  // Micro-Calculators State
  final TextEditingController _amountController = TextEditingController(text: '1500');
  final TextEditingController _peopleController = TextEditingController(text: '3');
  final TextEditingController _discountController = TextEditingController(text: '15');
  double _splitResult = 500.0;
  double _discountedTotal = 1275.0;

  // Active Simulated Notifications
  final List<String> _simulatedNotifications = [
    '⚡ FloatDeck Floating Action Hub Active',
    '📋 4 Quick Clips Ready in Sticky Tray',
    '💡 Quick Calc: Split \$1500 among 3 = \$500 each',
  ];

  // Quick Reply Generator State
  String _customerName = 'Nimal';
  String _delayMinutes = '10';
  String _generatedReply = '';

  @override
  void initState() {
    super.initState();
    _updateCalculations();
    _generateQuickReply();
  }

  void _updateCalculations() {
    double total = double.tryParse(_amountController.text) ?? 0.0;
    int people = int.tryParse(_peopleController.text) ?? 1;
    if (people < 1) people = 1;
    double discountPct = double.tryParse(_discountController.text) ?? 0.0;

    setState(() {
      _splitResult = total / people;
      _discountedTotal = total - (total * (discountPct / 100.0));
    });
  }

  void _generateQuickReply() {
    setState(() {
      _generatedReply =
          'Hello $_customerName! I am currently in a meeting. I will call you back in $_delayMinutes minutes. Thanks for your patience!';
    });
  }

  void _copyToClipboard(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to Clipboard: "$text"'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addNewClipDialog() {
    final titleCtrl = TextEditingController();
    final valueCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Quick Clip Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Clip Label (e.g. Bank Account)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: valueCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Text Content to Copy',
                  border: OutlineInputBorder(),
                ),
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
              if (titleCtrl.text.isNotEmpty && valueCtrl.text.isNotEmpty) {
                setState(() {
                  _clipboardItems.add({
                    'title': titleCtrl.text,
                    'category': 'Custom',
                    'value': valueCtrl.text,
                    'icon': 'widgets',
                  });
                });
                Navigator.pop(ctx);
                _copyToClipboard('Clip Added Successfully!');
              }
            },
            child: const Text('Save Clip'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.layers, color: Colors.tealAccent),
            SizedBox(width: 8),
            Text(
              'FloatDeck Pro',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.amber,
            ),
            onPressed: widget.onToggleTheme,
            tooltip: 'Toggle Theme Mode',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              _copyToClipboard('FloatDeck Pro - Download daily utility overlay assistant!');
            },
            tooltip: 'Share App',
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Tab Content Area
            IndexedStack(
              index: _selectedTabIndex,
              children: [
                _buildOverlayStudioTab(),
                _buildClipboardVaultTab(),
                _buildMicroToolsTab(),
                _buildNotificationHubTab(),
              ],
            ),

            // Draggable Simulated Floating Overlay Bubble Engine
            if (_isOverlayEnabled) _buildDraggableFloatingBubble(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Overlay Studio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy),
            label: 'Clip Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Quick Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Sticky Bar',
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating Overlay Studio & Live Interactive Mock Screen
  Widget _buildOverlayStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Fixed wrap/alignment syntax
        children: [
          // Banner Status Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Display Over Other Apps',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isOverlayEnabled
                                  ? 'Active: Floating Bubble & HUD running over screen'
                                  : 'Disabled: Enable to show ambient quick launcher',
                              style: TextStyle(
                                color: _isOverlayEnabled ? Colors.green : Colors.redAccent,
                                fontSize: 13,
                              ),
                              softWrap: true,
                            ),
                          ],
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
                  const Divider(height: 24),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildPermissionChip('Display Overlay', _isOverlayEnabled),
                      _buildPermissionChip('Sticky Notification', _isNotificationBarActive),
                      _buildPermissionChip('Clipboard Sync', true),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // HUD Mode Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Active Overlay Mode',
                style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold),
              ),
              Text(
                'Drag bubble below!',
                style: TextStyle(fontSize: 12, color: Colors.tealAccent),
              ),
            ],
          ),
          const SizedBox(height: 10),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildHUDModeChip('Multi-Clip', Icons.content_copy),
                _buildHUDModeChip('Quick Calc', Icons.calculate),
                _buildHUDModeChip('Auto Reply', Icons.chat),
                _buildHUDModeChip('Sticky Bar', Icons.notifications),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Phone Mockup Area simulating system wide screen behavior
          Container(
            height: 380,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.indigo.withOpacity(0.5), width: 2),
            ),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.touch_app,
                          size: 48,
                          color: Colors.indigoAccent,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Interactive Screen Sandbox',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'The floating bubble can be dragged anywhere on this screen simulation. Tap the bubble to expand quick context tools without leaving your current task!',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _bubblePosition = const Offset(120.0, 180.0);
                              _isBubbleExpanded = true;
                            });
                          },
                          icon: const Icon(Icons.flash_on, size: 18),
                          label: const Text('Test Open Overlay Widget'),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Daily Screen Engagement:',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '🔥 Active (42 mins saved)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.tealAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Daily Value Callout
          Card(
            color: Colors.indigo.withOpacity(0.2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'FloatDeck stays active in the background, keeping your high-frequency tools 1-tap away across all social and chat apps.',
                      style: const TextStyle(fontSize: 12),
                      softWrap: true,
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

  // TAB 2: Smart Clipboard & Snippet Vault
  Widget _buildClipboardVaultTab() {
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).cardColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Smart Quick-Clip Vault',
                      style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'One tap copies instantly to system clipboard',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _addNewClipDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Item'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _clipboardItems.length,
              itemBuilder: (context, index) {
                final item = _clipboardItems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.withOpacity(0.2),
                      child: Icon(
                        _getIconData(item['icon'] ?? 'widgets'),
                        color: Colors.indigoAccent,
                      ),
                    ),
                    title: Text(
                      item['title'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        item['value'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    trailing: Wrap(
                      spacing: 4,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.content_copy, color: Colors.tealAccent),
                          onPressed: () => _copyToClipboard(item['value'] ?? ''),
                          tooltip: 'Copy to Clipboard',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            setState(() {
                              _clipboardItems.removeAt(index);
                            });
                          },
                          tooltip: 'Delete Clip',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // TAB 3: Micro Quick Action Utility Engine
  Widget _buildMicroToolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Instant Split & Discount Engine',
            style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Calculate bill splits and discounts instantly while texting or paying',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Total Bill Amount (\$)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.monetization_on),
                          ),
                          onChanged: (_) => _updateCalculations(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _peopleController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'People Count',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          onChanged: (_) => _updateCalculations(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _discountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Discount Percentage (%)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calculate),
                    ),
                    onChanged: (_) => _updateCalculations(),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.teal.withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('Per Person Share', style: TextStyle(fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(
                              '\$${_splitResult.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.tealAccent,
                              ),
                            ),
                          ],
                        ),
                        Container(height: 30, width: 1, color: Colors.grey),
                        Column(
                          children: [
                            const Text('After Discount', style: TextStyle(fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(
                              '\$${_discountedTotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.amberAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        _copyToClipboard(
                          'Bill Breakdown: Total \$${_amountController.text}, Split among ${_peopleController.text} people = \$${_splitResult.toStringAsFixed(2)} each.',
                        );
                      },
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('Copy Calculation Summary'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Smart Quick Reply Message Generator
          const Text(
            'Smart WhatsApp / SMS Template Builder',
            style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Generate dynamic quick replies for ongoing calls and incoming chats',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Recipient Name',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            _customerName = val.isEmpty ? 'Friend' : val;
                            _generateQuickReply();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Delay (Mins)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            _delayMinutes = val.isEmpty ? '5' : val;
                            _generateQuickReply();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _generatedReply,
                      style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _copyToClipboard(_generatedReply),
                    icon: const Icon(Icons.content_copy, size: 18),
                    label: const Text('Copy Generated Reply'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 4: Sticky Notification Bar Controls
  Widget _buildNotificationHubTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: Icon(Icons.notifications_active, color: Colors.black),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Sticky Notification Tray',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Persistent quick actions available directly in your phone status bar',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isNotificationBarActive,
                    activeColor: Colors.tealAccent,
                    onChanged: (val) {
                      setState(() {
                        _isNotificationBarActive = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Active Status Bar Triggers',
            style: TextStyle(fontSize: 16, FontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _simulatedNotifications.length,
            itemBuilder: (context, idx) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.flash_on, color: Colors.tealAccent),
                  title: Text(
                    _simulatedNotifications[idx],
                    style: const TextStyle(fontSize: 13),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                      _copyToClipboard(_simulatedNotifications[idx]);
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: () {
              setState(() {
                _simulatedNotifications.add(
                  '⚡ Quick Clip: NIC #${DateTime.now().millisecondsSinceEpoch.toString().substring(5)} Saved',
                );
              });
            },
            icon: const Icon(Icons.add_alert),
            label: const Text('Push New Action to Notification Bar'),
          ),
        ],
      ),
    );
  }

  // Interactive Floating Overlay Bubble Engine Widget
  Widget _buildDraggableFloatingBubble() {
    return Positioned(
      left: _bubblePosition.dx,
      top: _bubblePosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubblePosition += details.delta;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (_isBubbleExpanded)
              Container(
                width: 240,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                  border: Border.all(color: Colors.tealAccent.withOpacity(0.5)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.widgets, size: 16, color: Colors.tealAccent),
                            SizedBox(width: 6),
                            Text(
                              'FloatDeck Quick HUD',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isBubbleExpanded = false;
                            });
                          },
                          child: const Icon(Icons.close, size: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    const Divider(height: 16, color: Colors.grey),
                    const Text(
                      'Tap to quick copy:',
                      style: TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _clipboardItems.take(3).map((item) {
                        return ActionChip(
                          visualDensity: VisualDensity.compact,
                          backgroundColor: Colors.indigo.withOpacity(0.4),
                          label: Text(
                            item['title'] ?? '',
                            style: const TextStyle(fontSize: 10, color: Colors.white),
                          ),
                          onPressed: () {
                            _copyToClipboard(item['value'] ?? '');
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                        ),
                        onPressed: () {
                          setState(() {
                            _isBubbleExpanded = false;
                            _selectedTabIndex = 2; // Jump to calculations
                          });
                        },
                        child: const Text('Open Quick Split Calc', style: TextStyle(fontSize: 11)),
                      ),
                    ),
                  ],
                ),
              ),

            // The main draggable floating action bubble
            FloatingActionButton.small(
              heroTag: 'float_deck_bubble',
              backgroundColor: _isBubbleExpanded ? Colors.tealAccent : Colors.indigoAccent,
              foregroundColor: Colors.black,
              onPressed: () {
                setState(() {
                  _isBubbleExpanded = !_isBubbleExpanded;
                });
              },
              child: Icon(
                _isBubbleExpanded ? Icons.close : Icons.layers,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget Builders
  Widget _buildPermissionChip(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: active ? Colors.teal.withOpacity(0.2) : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? Colors.tealAccent : Colors.redAccent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            active ? Icons.check : Icons.close,
            size: 14,
            color: active ? Colors.tealAccent : Colors.redAccent,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: active ? Colors.tealAccent : Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHUDModeChip(String title, IconData icon) {
    bool isSelected = _activeHUDMode == title;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        selected: isSelected,
        showCheckmark: false,
        avatar: Icon(
          icon,
          size: 16,
          color: isSelected ? Colors.black : Colors.tealAccent,
        ),
        label: Text(title),
        selectedColor: Colors.tealAccent,
        onSelected: (val) {
          setState(() {
            _activeHUDMode = title;
          });
        },
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'security':
        return Icons.security;
      case 'monetization_on':
        return Icons.monetization_on;
      case 'place':
        return Icons.place;
      case 'email':
        return Icons.email;
      default:
        return Icons.widgets;
    }
  }
}