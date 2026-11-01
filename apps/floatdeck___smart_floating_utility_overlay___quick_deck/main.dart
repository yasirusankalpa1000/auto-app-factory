import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const FloatDeckApp());
}

class FloatDeckApp extends StatelessWidget {
  const FloatDeckApp({super.key});

  @override
  Widget build(BuildContext me) {
    return MaterialApp(
      title: 'FloatDeck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainDeckScreen(),
    );
  }
}

class MainDeckScreen extends StatefulWidget {
  const MainDeckScreen({super.key});

  @override
  State<MainDeckScreen> createState() => _MainDeckScreenState();
}

class _MainDeckScreenState extends State<MainDeckScreen> {
  int _currentIndex = 0;

  // Floating Bubble Drag Position
  double _bubbleX = 20.0;
  double _bubbleY = 150.0;
  bool _isBubbleVisible = true;

  // System Permissions Simulation State
  bool _drawOverAppsEnabled = true;
  bool _floatingNotificationsEnabled = true;
  bool _ambientHudEnabled = false;

  // Clipboard Vault Data
  final List<Map<String, String>> _clipboardItems = [
    {
      'title': 'WIFI Router Password',
      'content': 'SkyNet_5G_Secure#8821',
      'tag': 'Passwords',
      'time': '10 mins ago'
    },
    {
      'title': 'Bank Reference ID',
      'content': 'REF-994021-TXN',
      'tag': 'Finance',
      'time': '1 hour ago'
    },
    {
      'title': 'Delivery Address',
      'content': '742 Evergreen Terrace, Sector 4, Suite 12B',
      'tag': 'Address',
      'time': '3 hours ago'
    },
  ];

  // Active Session Metrics Simulator
  int _activeMinutes = 42;
  double _simulatedSpeed = 14.2;
  late Timer _metricTimer;

  @override
  void initState() {
    super.initState();
    _metricTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _simulatedSpeed = 8.0 + (18.0 * (DateTime.now().second % 5) / 5.0);
        });
      }
    });
  }

  @override
  void dispose() {
    _metricTimer.cancel();
    super.dispose();
  }

  void _addClipboardItem(String title, String content, String tag) {
    setState(() {
      _clipboardItems.insert(0, {
        'title': title.isEmpty ? 'Quick Note' : title,
        'content': content,
        'tag': tag,
        'time': 'Just now',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main App Content Screen
            IndexedStack(
              index: _currentIndex,
              children: [
                _buildFloatHubTab(size),
                _buildClipboardVaultTab(),
                _buildMicroToolsTab(),
                _buildAnalyticsTab(),
              ],
            ),

            // Draggable Interactive Floating Head Overlay (Simulated System Bubble)
            if (_isBubbleVisible)
              Positioned(
                left: _bubbleX,
                top: _bubbleY,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _bubbleX += details.delta.dx;
                      _bubbleY += details.delta.dy;
                      // Keep within screen bounds safely
                      if (_bubbleX < 0) _bubbleX = 0;
                      if (_bubbleX > size.width - 60) _bubbleX = size.width - 60;
                      if (_bubbleY < 0) _bubbleY = 0;
                      if (_bubbleY > size.height - 140) _bubbleY = size.height - 140;
                    });
                  },
                  onTap: () {
                    _showFloatingQuickActionMenu(context);
                  },
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colors.indigo, Colors.teal],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.layers,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white70, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: const Color(0xFF0F172A),
          selectedItemColor: Colors.tealAccent,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Float Hub',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.content_paste),
              label: 'Vault',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              label: 'Float Tools',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: 'Engagement',
            ),
          ],
        ),
      ),
    );
  }

  // HUB TAB: Floating Head Controls & Permission Toggles
  Widget _buildFloatHubTab(Size size) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'FloatDeck OS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Always-on Smart System Overlay',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.tealAccent),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'ACTIVE',
                      style: TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Interactive Drag Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade900, Colors.deepPurple.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigoAccent.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.touch_app, color: Colors.tealAccent, size: 36),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Interactive Floating Bubble',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Drag the floating bubble anywhere on screen. Tap it to launch overlay micro-apps without switching context.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Permission & System Toggles Section
          const Text(
            'SYSTEM PERMISSIONS & SERVICES',
            style: TextStyle(
              color: Colors.tealAccent,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),

          _buildPermissionTile(
            title: 'Display Over Other Apps',
            subtitle: 'Allows floating heads & quick-drawers to appear on any app screen.',
            icon: Icons.layers,
            value: _drawOverAppsEnabled,
            onChanged: (val) {
              setState(() {
                _drawOverAppsEnabled = val;
                _isBubbleVisible = val;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(val
                      ? 'Display Over Apps permission enabled!'
                      : 'Display Over Apps disabled.'),
                ),
              );
            },
          ),
          const SizedBox(height: 10),

          _buildPermissionTile(
            title: 'Floating Dynamic Notifications',
            subtitle: 'Pushes quick action sticky bars into system notification area.',
            icon: Icons.notifications,
            value: _floatingNotificationsEnabled,
            onChanged: (val) {
              setState(() {
                _floatingNotificationsEnabled = val;
              });
            },
          ),
          const SizedBox(height: 10),

          _buildPermissionTile(
            title: 'Ambient Net & Battery HUD',
            subtitle: 'Shows subtle network speed & thermal meter on floating bubble.',
            icon: Icons.speed,
            value: _ambientHudEnabled,
            onChanged: (val) {
              setState(() {
                _ambientHudEnabled = val;
              });
            },
          ),
          const SizedBox(height: 20),

          // Live Device Telemetry Preview Card
          const Text(
            'LIVE AMBIENT DECK METRICS',
            style: TextStyle(
              color: Colors.tealAccent,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Net Speed',
                  value: '\$${_simulatedSpeed.toStringAsFixed(1)} MB/s',
                  icon: Icons.wifi,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: 'Float Session',
                  value: '$_activeMinutes mins',
                  icon: Icons.schedule,
                  color: Colors.tealAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // CLIPBOARD VAULT TAB
  Widget _buildClipboardVaultTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Smart Vault',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Instant copied snippets & floating notes',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddSnippetDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Snippet'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search clipboard items...',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Snippet List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _clipboardItems.length,
            itemBuilder: (context, index) {
              final item = _clipboardItems[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white70),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.copy, color: Colors.tealAccent, size: 20),
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
                                  item['title']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.indigo.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item['tag']!,
                                  style: const TextStyle(
                                    color: Colors.indigoAccent,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['content']!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['time']!,
                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.content_copy, color: Colors.grey, size: 20),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Copied "${item['title']}" to clipboard!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
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

  // MICRO TOOLS TAB
  Widget _buildMicroToolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Utility Drawer',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Instant calculation & quick tools accessible on overlay',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Quick Calculator Micro Card
          _buildToolContainer(
            title: 'Floating Quick Math',
            icon: Icons.calculate,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.centerRight,
                  child: const Text(
                    '125 * 18 = 2,250',
                    style: TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['7', '8', '9', '/', '4', '5', '6', '*', '1', '2', '3', '=']
                      .map((val) => SizedBox(
                            width: 60,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF334155),
                                padding: EdgeInsets.zero,
                              ),
                              child: Text(
                                val,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Quick Unit Converter Micro Card
          _buildToolContainer(
            title: 'Instant Currency & Unit Swap',
            icon: Icons.monetization_on,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'USD (\$) ',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(text: '100'),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.refresh, color: Colors.tealAccent),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF334155),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '€ 92.40 EUR',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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

  // ENGAGEMENT & REWARDS TAB
  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deck Engagement & Status',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Track your active saved context time daily',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Engagement Score Radial Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade900, Colors.slate.shade900],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.teal.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                const Icon(Icons.stars, color: Colors.amber, size: 48),
                const SizedBox(height: 10),
                const Text(
                  'Context Saver Rating',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 6),
                const Text(
                  'HIGH EFFICIENCY',
                  style: TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'You saved ~35 minutes today by using FloatDeck overlay tools instead of switching apps 42 times!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Unlocked Themes / Badges Section
          const Text(
            'UNLOCKED FLOATING THEMES',
            style: TextStyle(
              color: Colors.tealAccent,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildThemeBadge('Cyber Teal', Colors.teal, true),
              _buildThemeBadge('Neon Purple', Colors.purple, true),
              _buildThemeBadge('Amber Gold', Colors.amber, false),
              _buildThemeBadge('Emerald Dark', Colors.green, false),
            ],
          ),
        ],
      ),
    );
  }

  // HELPER WIDGETS
  Widget _buildPermissionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.tealAccent, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                  softWrap: true,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.tealAccent,
          ),
        ],
      ),
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
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolContainer({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.tealAccent, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildThemeBadge(String name, Color accent, bool unlocked) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: unlocked ? accent : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(backgroundColor: accent, radius: 6),
          const SizedBox(width: 8),
          Text(
            name,
            style: TextStyle(
              color: unlocked ? Colors.white : Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            unlocked ? Icons.check_circle : Icons.security,
            color: unlocked ? Colors.tealAccent : Colors.grey,
            size: 14,
          ),
        ],
      ),
    );
  }

  // DIALOGS & OVERLAYS
  void _showAddSnippetDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedTag = 'General';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('New Smart Snippet', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Snippet Title (e.g., Wifi Password)',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Text content to save...',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (contentController.text.isNotEmpty) {
                _addClipboardItem(
                  titleController.text,
                  contentController.text,
                  selectedTag,
                );
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text('Save Snippet', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showFloatingQuickActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.layers, color: Colors.tealAccent),
                SizedBox(width: 10),
                Text(
                  'FloatDeck Quick Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.content_paste, color: Colors.tealAccent),
              title: const Text('Paste Last Vault Item', style: TextStyle(color: Colors.white)),
              subtitle: const Text('SkyNet_5G_Secure#8821', style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pasted to active background buffer!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calculate, color: Colors.indigoAccent),
              title: const Text('Launch Overlay Calculator', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.redAccent),
              title: const Text('Hide Floating Bubble', style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _isBubbleVisible = false;
                  _drawOverAppsEnabled = false;
                });
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }
}