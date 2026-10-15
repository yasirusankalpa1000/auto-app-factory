import 'package:flutter/material.dart';

void main() {
  runApp(const FloatDeckApp());
}

class FloatDeckApp extends StatelessWidget {
  const FloatDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatDeck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
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
  int _currentTabIndex = 0;
  bool _isOverlayEnabled = true;
  bool _displayAboveAppsPermission = true;
  bool _floatingNotificationPermission = true;
  
  // Stats
  int _timeSavedMinutes = 42;
  int _snippetsCaptured = 18;
  int _quickActionsTriggered = 64;

  // Simulator State
  String _activeSimApp = 'Chat & Social'; // 'Chat & Social', 'Online Store', 'Article Reader'
  bool _isFloatingDeckOpen = false;
  Offset _dockPosition = const Offset(20, 250);

  // Clipboard Vault Data
  final List<Map<String, String>> _clipboardVault = [
    {
      'title': 'Delivery Address Snippet',
      'content': 'No. 45, Flower Road, Colombo 07, Apt 3B',
      'tag': 'Personal',
      'time': '10 mins ago',
    },
    {
      'title': 'Bank Wire Transfer Details',
      'content': 'Account: 8829-1002-4411 | Branch: City Center',
      'tag': 'Finance',
      'time': '1 hour ago',
    },
    {
      'title': 'Meeting Agenda Draft',
      'content': '1. Q3 Roadmap review 2. Budget approval 3. AdMob integration',
      'tag': 'Work',
      'time': '3 hours ago',
    },
  ];

  // Smart Tone Polisher Controllers
  final TextEditingController _draftTextController = TextEditingController();
  String _selectedTone = 'Professional & Polite';
  List<String> _polishedOutputs = [];

  // Quick Calc Controllers
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _discountPercentController = TextEditingController();
  final TextEditingController _splitPeopleController = TextEditingController();
  double _finalCalculatedTotal = 0.0;
  double _perPersonSplit = 0.0;

  @override
  void dispose() {
    _draftTextController.dispose();
    _itemPriceController.dispose();
    _discountPercentController.dispose();
    _splitPeopleController.dispose();
    super.dispose();
  }

  void _generatePolishedReplies() {
    final text = _draftTextController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _polishedOutputs = [];
      });
      return;
    }

    setState(() {
      if (_selectedTone == 'Professional & Polite') {
        _polishedOutputs = [
          'Hello, thank you for reaching out. $text. Please let me know how you wish to proceed.',
          'Dear Sir/Madam, regarding your inquiry: $text. Best regards.',
          'Thank you for your patience. $text. I appreciate your quick support.'
        ];
      } else if (_selectedTone == 'Friendly & Casual') {
        _polishedOutputs = [
          'Hey there! Just wanted to share that $text. Hope you are doing great! 😊',
          'Hi! Quick update for you: $text. Chat soon!',
          'Hey! $text. Let me know what you think 👍'
        ];
      } else {
        _polishedOutputs = [
          'Please note: $text. Urgent attention required.',
          'Important update: $text. Kindly confirm receipt.',
          'Action Required: $text. Please respond at your earliest convenience.'
        ];
      }
      _quickActionsTriggered++;
    });
  }

  void _calculateSplit() {
    final double price = double.tryParse(_itemPriceController.text) ?? 0.0;
    final double discount = double.tryParse(_discountPercentController.text) ?? 0.0;
    final int people = int.tryParse(_splitPeopleController.text) ?? 1;

    final double discounted = price - (price * (discount / 100.0));
    final int validPeople = people > 0 ? people : 1;

    setState(() {
      _finalCalculatedTotal = discounted;
      _perPersonSplit = discounted / validPeople;
      _quickActionsTriggered++;
    });
  }

  void _copyToClipboard(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to FloatDeck Clipboard: "$content"'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.layers, color: Colors.indigo),
            SizedBox(width: 8),
            Text(
              'FloatDeck Studio',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isOverlayEnabled ? Icons.visibility : Icons.visibility_off,
              color: _isOverlayEnabled ? Colors.green : Colors.grey,
            ),
            tooltip: 'Toggle Overlay Deck',
            onPressed: () {
              setState(() {
                _isOverlayEnabled = !_isOverlayEnabled;
              });
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentTabIndex,
          children: [
            _buildHomeDashboardTab(),
            _buildOverlaySimulatorTab(),
            _buildTonePolisherTab(),
            _buildQuickCalcTab(),
            _buildClipboardVaultTab(),
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
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_button_outlined),
            activeIcon: Icon(Icons.smart_button),
            label: 'Float Dock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_outlined),
            activeIcon: Icon(Icons.auto_awesome),
            label: 'Polisher',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
            activeIcon: Icon(Icons.calculate),
            label: 'Split Calc',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste_outlined),
            activeIcon: Icon(Icons.content_paste_go),
            label: 'Vault',
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 1: HOME DASHBOARD
  // ---------------------------------------------------------------------------
  Widget _buildHomeDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Permission Alert Card
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.indigo, Colors.indigoAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.bolt, color: Colors.amber, size: 28),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'FloatDeck System Active',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'FloatDeck overlay widget is attached and listening for quick text operations across your apps.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildPermissionChip(
                      'Display Over Apps',
                      _displayAboveAppsPermission,
                      () {
                        setState(() {
                          _displayAboveAppsPermission = !_displayAboveAppsPermission;
                        });
                      },
                    ),
                    _buildPermissionChip(
                      'Floating Banner',
                      _floatingNotificationPermission,
                      () {
                        setState(() {
                          _floatingNotificationPermission = !_floatingNotificationPermission;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Daily Stats
          const Text(
            'Daily Efficiency Tracker',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Time Saved',
                  '$_timeSavedMinutes mins',
                  Icons.timer,
                  Colors.teal,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  'Snippets Pinned',
                  '$_snippetsCaptured',
                  Icons.push_pin,
                  Colors.deepOrange,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  'Float Triggers',
                  '$_quickActionsTriggered',
                  Icons.touch_app,
                  Colors.purple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Quick Action Launchers
          const Text(
            'Quick Utility Launchers',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 12),

          _buildQuickLauncherTile(
            icon: Icons.smart_button,
            color: Colors.blue,
            title: 'Interactive Floating Dock Simulator',
            subtitle: 'Test overlay bubble over Chat, Shopping, and Articles',
            onTap: () => setState(() => _currentTabIndex = 1),
          ),
          const SizedBox(height: 10),
          _buildQuickLauncherTile(
            icon: Icons.auto_awesome,
            color: Colors.purple,
            title: 'Smart Message & Tone Polisher',
            subtitle: 'Transform raw notes into polite, professional messages',
            onTap: () => setState(() => _currentTabIndex = 2),
          ),
          const SizedBox(height: 10),
          _buildQuickLauncherTile(
            icon: Icons.calculate,
            color: Colors.teal,
            title: 'Instant Multi-Price & Split Calculator',
            subtitle: 'Calculate discounts, taxes, and friend bill splits on the fly',
            onTap: () => setState(() => _currentTabIndex = 3),
          ),
          const SizedBox(height: 10),
          _buildQuickLauncherTile(
            icon: Icons.content_paste,
            color: Colors.orange,
            title: 'Clipboard History & Pinboard Vault',
            subtitle: 'Access and organize your copied phone clipboard items',
            onTap: () => setState(() => _currentTabIndex = 4),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionChip(String label, bool isGranted, VoidCallback onToggle) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isGranted ? Colors.white : Colors.white70,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isGranted ? Icons.check_circle : Icons.warning_amber,
              color: isGranted ? Colors.indigo : Colors.amberAccent,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              '$label: ${isGranted ? "Allowed" : "Tap to Grant"}',
              style: TextStyle(
                color: isGranted ? Colors.indigo : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLauncherTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),