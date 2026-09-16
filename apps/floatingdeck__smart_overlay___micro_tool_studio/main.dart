import 'package:flutter/material.dart';

void main() {
  runApp(const FloatingDeckApp());
}

class FloatingDeckApp extends StatelessWidget {
  const FloatingDeckApp({super.key});

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'FloatingDeck Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
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

  // Floating Overlay Bubble State
  Offset _bubblePosition = const Offset(280, 160);
  bool _isOverlayEnabled = true;
  bool _isOverlayOpen = false;

  // Notification Sticky Permissions Simulation
  bool _hasOverlayPermission = true;
  bool _hasNotificationPermission = true;

  // Clip Vault items
  final List<Map<String, String>> _clipVault = [
    {
      'title': 'Wi-Fi Password',
      'content': 'Home_5G_Secure#8821',
      'category': 'Tech'
    },
    {
      'title': 'Bank Account Swift',
      'content': 'ACCT: 0049-8812-9920 (Commercial Bank)',
      'category': 'Finance'
    },
    {
      'title': 'Standard Reply - Meeting',
      'content':
          'Hi! I am currently in a meeting. I will call you back in 30 minutes.',
      'category': 'Chat'
    },
    {
      'title': 'Delivery Address',
      'content': 'No 45, Flower Road, Colombo 03, Sri Lanka',
      'category': 'Personal'
    },
  ];

  // Sticky Notifications Pin List
  final List<Map<String, dynamic>> _pinnedNotifications = [
    {
      'title': 'Quick Clipboard Listener',
      'subtitle': 'Tap to paste copied snippet into chat',
      'icon': Icons.content_paste,
      'active': true
    },
    {
      'title': 'Emergency Alert Trigger',
      'subtitle': 'One-tap location broadcast ready',
      'icon': Icons.warning_amber,
      'active': false
    },
    {
      'title': 'Live Decision Picker',
      'subtitle': 'Need quick choice? Tap to spin decision wheel',
      'icon': Icons.casino,
      'active': true
    },
  ];

  // Text Refiner Inputs
  final TextEditingController _refinerController = TextEditingController(
    text:
        "hey bro im running late today will be there in 20 mins sorry for delay",
  );
  String _selectedTone = 'Professional';
  String _refinedOutput = '';
  int _engagementScore = 85;

  @override
  void initState() {
    super.initState();
    _processTextRefining();
  }

  void _processTextRefining() {
    String original = _refinerController.text.trim();
    if (original.isEmpty) {
      setState(() {
        _refinedOutput = 'Please enter text above to refine.';
        _engagementScore = 0;
      });
      return;
    }

    if (_selectedTone == 'Professional') {
      _refinedOutput =
          "Dear recipient, I am writing to inform you that I am running approximately 20 minutes behind schedule. I sincerely apologize for any inconvenience caused.";
      _engagementScore = 92;
    } else if (_selectedTone == 'Casual & Friendly') {
      _refinedOutput =
          "Hey there! 🏃‍♂️ Quick heads up - running about 20 mins late today! So sorry about that, see you very soon! 🙌";
      _engagementScore = 88;
    } else if (_selectedTone == 'Viral Social') {
      _refinedOutput =
          "Running late ⏳ but making an entrance! 🚀 See you all in 20 minutes! Stay tuned! 🔥✨";
      _engagementScore = 96;
    } else {
      _refinedOutput = "Delayed by 20 mins. Apologies.";
      _engagementScore = 70;
    }
    setState(() {});
  }

  void _addClipItem(String title, String content, String category) {
    setState(() {
      _clipVault.insert(0, {
        'title': title,
        'content': content,
        'category': category,
      });
    });
  }

  void _toggleNotificationPin(int index) {
    setState(() {
      _pinnedNotifications[index]['active'] =
          !_pinnedNotifications[index]['active'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Main Body Tabs
          SafeArea(
            child: Column(
              children: [
                _buildHeaderBar(),
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      _buildOverlayStudioTab(screenSize),
                      _buildTextRefinerTab(),
                      _buildClipVaultTab(),
                      _buildStatusDockTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Interactive Floating Overlay Bubble Simulation
          if (_isOverlayEnabled)
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    double newX = _bubblePosition.dx + details.delta.dx;
                    double newY = _bubblePosition.dy + details.delta.dy;

                    // Boundary checks
                    newX = newX.clamp(10.0, screenSize.width - 70.0);
                    newY = newY.clamp(50.0, screenSize.height - 120.0);

                    _bubblePosition = Offset(newX, newY);
                  });
                },
                onTap: () {
                  setState(() {
                    _isOverlayOpen = !_isOverlayOpen;
                  });
                },
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      _isOverlayOpen ? Icons.close : Icons.layers,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),

          // Expanded Floating Micro Panel Widget
          if (_isOverlayEnabled && _isOverlayOpen)
            Positioned(
              left: (_bubblePosition.dx > screenSize.width / 2)
                  ? (_bubblePosition.dx - 220).clamp(10.0, screenSize.width - 240)
                  : (_bubblePosition.dx + 65).clamp(10.0, screenSize.width - 240),
              top: _bubblePosition.dy.clamp(60.0, screenSize.height - 320),
              child: Container(
                width: 220,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black87,
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                  border: Border.all(color: Colors.indigo.shade100, width: 1.5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bolt, color: Colors.indigo, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Quick Desk Tools',
                            style: TextStyle(
                              color: Colors.indigo.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 12),
                    _buildOverlayActionItem(
                      icon: Icons.copy,
                      label: 'Paste Top Snippet',
                      color: Colors.blue,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Pasted: "Home_5G_Secure#8821" to screen active field',
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        setState(() => _isOverlayOpen = false);
                      },
                    ),
                    _buildOverlayActionItem(
                      icon: Icons.auto_awesome,
                      label: 'Refine Active Text',
                      color: Colors.teal,
                      onTap: () {
                        setState(() {
                          _currentIndex = 1;
                          _isOverlayOpen = false;
                        });
                      },
                    ),
                    _buildOverlayActionItem(
                      icon: Icons.casino,
                      label: 'Random Decision',
                      color: Colors.amber.shade800,
                      onTap: () {
                        _showDecisionDialog();
                        setState(() => _isOverlayOpen = false);
                      },
                    ),
                    _buildOverlayActionItem(
                      icon: Icons.shield,
                      label: 'Privacy Guard On',
                      color: Colors.green,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Screen privacy shield activated!',
                            ),
                          ),
                        );
                        setState(() => _isOverlayOpen = false);
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.touch_app_outlined),
            selectedIcon: Icon(Icons.touch_app, color: Colors.indigo),
            label: 'Overlay Dock',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome, color: Colors.indigo),
            label: 'Text Refiner',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_special_outlined),
            selectedIcon: Icon(Icons.folder_special, color: Colors.indigo),
            label: 'Clip Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_active_outlined),
            selectedIcon:
                Icon(Icons.notifications_active, color: Colors.indigo),
            label: 'Status Pins',
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.layers_sharp, color: Colors.indigo),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FloatingDeck',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Always-On Multi-Tasking Assistant',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _isOverlayEnabled
                  ? Colors.green.shade50
                  : Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isOverlayEnabled
                    ? Colors.green.shade300
                    : Colors.red.shade300,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 8,
                  color: _isOverlayEnabled ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 6),
                Text(
                  _isOverlayEnabled ? 'Overlay Active' : 'Overlay Disabled',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _isOverlayEnabled
                        ? Colors.green.shade800
                        : Colors.red.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: OVERLAY DOCK CONTROLLER
  Widget _buildOverlayStudioTab(Size screenSize) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade800, Colors.indigo.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.touch_app, color: Colors.amber, size: 22),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Floating Assist Controller',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'The floating bubble stays accessible over WhatsApp, Chrome, YouTube, or Games so you can copy, refine text, and run shortcuts instantly.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black87,
                        ),
                        onPressed: () {
                          setState(() {
                            _isOverlayEnabled = !_isOverlayEnabled;
                          });
                        },
                        icon: Icon(
                          _isOverlayEnabled
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 16,
                        ),
                        label: Text(
                          _isOverlayEnabled
                              ? 'Hide Floating Bubble'
                              : 'Enable Floating Bubble',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white70),
                        ),
                        onPressed: () {
                          setState(() {
                            _bubblePosition = const Offset(150, 200);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Floating bubble position reset!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Reset Position'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Required System Permissions',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            _buildPermissionCard(
              title: 'Display Over Other Apps',
              subtitle: 'Allows the floating bubble to overlay active apps',
              icon: Icons.layers,
              value: _hasOverlayPermission,
              onChanged: (val) {
                setState(() => _hasOverlayPermission = val);
              },
            ),
            const SizedBox(height: 10),
            _buildPermissionCard(
              title: 'Notification Bar Access',
              subtitle: 'Enables quick sticky tools in system status bar',
              icon: Icons.notifications,
              value: _hasNotificationPermission,
              onChanged: (val) {
                setState(() => _hasNotificationPermission = val);
              },
            ),

            const SizedBox(height: 20),
            const Text(
              'Quick Action Hub Controls',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.4,
              children: [
                _buildQuickHubTile(
                  icon: Icons.casino,
                  title: 'Decision Spinner',
                  desc: 'Can\'t decide? Pick instantly',
                  color: Colors.amber.shade700,
                  onTap: _showDecisionDialog,
                ),
                _buildQuickHubTile(
                  icon: Icons.speed,
                  title: 'Speed Clean Clip',
                  desc: 'Remove formatted junk text',
                  color: Colors.teal,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Clipboard sanitized and trimmed!'),
                      ),
                    );
                  },
                ),
                _buildQuickHubTile(
                  icon: Icons.security,
                  title: 'Secret Text Lock',
                  desc: 'Conceal text with secret PIN',
                  color: Colors.purple,
                  onTap: _showSecretLockDialog,
                ),
                _buildQuickHubTile(
                  icon: Icons.share,
                  title: 'Quick SOS SMS',
                  desc: 'Preset quick emergency drop',
                  color: Colors.red,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Emergency quick broadcast ready for tap!',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.indigo, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: Colors.indigo,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickHubTile({
    required IconData icon,
    required String title,
    required String desc,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              desc,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: SMART TEXT REFINER
  Widget _buildTextRefinerTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.teal),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Refine draft messages, chat replies & emails before sending. Fixes tone & adds viral formatting!',
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Input Draft Message:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _refinerController,
              maxLines: 3,
              style: const TextStyle(fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'Type or paste message here...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
              onChanged: (_) => _processTextRefining(),
            ),
            const SizedBox(height: 14),

            const Text(
              'Select Desired Tone:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'Professional',
                'Casual & Friendly',
                'Viral Social',
                'Ultra Short'
              ].map((tone) {
                final isSelected = _selectedTone == tone;
                return ChoiceChip(
                  label: Text(
                    tone,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: Colors.indigo,
                  backgroundColor: Colors.grey.shade200,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        _selectedTone = tone;
                      });
                      _processTextRefining();
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Output Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.indigo.shade100, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Refined Output',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Impact Score: $_engagementScore%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  SelectableText(
                    _refinedOutput,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Refined text copied to clipboard!'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('Copy Refined Text'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                        ),
                        onPressed: () {
                          _addClipItem(
                            'Refined: $_selectedTone',
                            _refinedOutput,
                            'Refined',
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Saved to Clip Vault!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.bookmark_add,
                            color: Colors.indigo),
                        tooltip: 'Save to Vault',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 3: CLIPBOARD VAULT
  Widget _buildClipVaultTab() {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Clipboard Vault',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '1-Tap copy snippets for fast messaging',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _showAddClipDialog,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Snippet'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _clipVault.length,
              itemBuilder: (context, index) {
                final item = _clipVault[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade50,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item['category'] ?? 'General',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo.shade800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item['title'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  size: 18, color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  _clipVault.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['content'] ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Copied: "${item['content']}"',
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.copy, size: 14),
                              label: const Text('Copy Now'),
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
      ),
    );
  }

  // TAB 4: STATUS BAR NOTIFICATION DOCK
  Widget _buildStatusDockTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.shade100),
              ),
              child: const Row(
                children: [
                  Icon(Icons.notifications_active, color: Colors.indigo),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Pin micro-tools directly into your mobile notification drawer for instant zero-click access anytime.',
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Active Status Bar Dock Pins',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _pinnedNotifications.length,
              itemBuilder: (context, index) {
                final pin = _pinnedNotifications[index];
                final bool isActive = pin['active'];

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isActive
                          ? Colors.indigo.shade200
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isActive
                          ? Colors.indigo.shade100
                          : Colors.grey.shade200,
                      child: Icon(
                        pin['icon'] as IconData,
                        color: isActive ? Colors.indigo : Colors.grey,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      pin['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: isActive ? Colors.black87 : Colors.grey,
                      ),
                    ),
                    subtitle: Text(
                      pin['subtitle'],
                      style: const TextStyle(fontSize: 11),
                    ),
                    trailing: Switch(
                      value: isActive,
                      activeColor: Colors.indigo,
                      onChanged: (val) => _toggleNotificationPin(index),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Live Preview Card of Status Bar Notification
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.phone_android,
                          color: Colors.white70, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Live Notification Drawer Preview',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white70, height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.layers,
                            color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FloatingDeck Dock Active',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '3 active tools ready in status bar',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildNotificationChip('📋 Copy Wi-Fi'),
                      _buildNotificationChip('⚡ Quick Refine'),
                      _buildNotificationChip('🎲 Spin Choice'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white70),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
    );
  }

  // DIALOGS & ACTION HANDLERS
  void _showDecisionDialog() {
    final options = ['Option A', 'Option B', 'Option C'];
    String result = (options..shuffle()).first;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.casino, color: Colors.indigo),
            SizedBox(width: 8),
            Text('Quick Choice Spinner'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Facing hesitation? Let FloatingDeck pick for you:',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Result: $result 🎯',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSecretLockDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Secret Text Concealer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Convert confidential text into encoded symbols:',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter sensitive text...',
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
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Encrypted snippet copied to clipboard!'),
                ),
              );
            },
            child: const Text('Encrypt & Copy'),
          ),
        ],
      ),
    );
  }

  void _showAddClipDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String category = 'General';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Vault Snippet'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Snippet Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Snippet Content',
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
              if (titleController.text.isNotEmpty &&
                  contentController.text.isNotEmpty) {
                _addClipItem(
                  titleController.text,
                  contentController.text,
                  category,
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}