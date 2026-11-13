import 'package:flutter/material.dart';

void main() {
  runApp(const MicroPulseApp());
}

class MicroPulseApp extends StatelessWidget {
  const MicroPulseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MicroPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF0F0E17),
        colorScheme: const ColorScheme.dark(
          primary: Colors.deepPurpleAccent,
          secondary: Colors.amber,
          surface: Color(0xFF1F1D2B),
          background: Color(0xFF0F0E17),
        ),
      ),
      home: const MainDashboardScreen(),
    );
  }
}

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({Key? key}) : super(key: key);

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _currentIndex = 0;
  bool _isFloatingHudEnabled = true;
  Offset _hudPosition = const Offset(20, 150);
  bool _isHudExpanded = false;

  // App statistics for user retention engagement
  int _dailyStreak = 5;
  int _timeSpentSeconds = 142;
  double _savedMoney = 185.50;

  final List<Map<String, String>> _snippets = [
    {'title': 'Home Address', 'content': '742 Evergreen Terrace, Springfield'},
    {'title': 'Tax ID / SSN Snippet', 'content': 'XXX-YY-9821'},
    {'title': 'Work Email Signature', 'content': 'Best regards,\nAlex Vance | Tech Lead'},
  ];

  final List<Map<String, dynamic>> _activeNotifications = [
    {
      'title': '⚡ MicroPulse Active HUD',
      'body': 'Tap to launch quick buyer decision wheel',
      'icon': Icons.bolt,
      'enabled': true,
    },
    {
      'title': '🛡️ Impulse Guard Shield',
      'body': 'Monitoring Amazon & E-commerce apps',
      'icon': Icons.shield,
      'enabled': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: [
                _buildFloatingHudTab(),
                _buildImpulseInterceptorTab(),
                _buildNotificationBuilderTab(),
                _buildMicroVaultTab(),
                _buildEngagementHubTab(),
              ],
            ),
            if (_isFloatingHudEnabled) _buildDraggableFloatingHud(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF161522),
        indicatorColor: Colors.deepPurpleAccent.withOpacity(0.4),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.widgets),
            label: 'HUD',
          ),
          NavigationDestination(
            icon: Icon(Icons.shield),
            label: 'Impulse',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_active),
            label: 'Notifs',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_paste),
            label: 'Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.stars),
            label: 'Rewards',
          ),
        ],
      ),
    );
  }

  // Floating Dynamic HUD Widget Overlay (Simulated System Display Over Apps)
  Widget _buildDraggableFloatingHud() {
    return Positioned(
      left: _hudPosition.dx,
      top: _hudPosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _hudPosition = Offset(
              (_hudPosition.dx + details.delta.dx).clamp(10.0, MediaQuery.of(context).size.width - 90.0),
              (_hudPosition.dy + details.delta.dy).clamp(50.0, MediaQuery.of(context).size.height - 150.0),
            );
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _isHudExpanded ? 240 : 65,
          height: _isHudExpanded ? 180 : 65,
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.95),
            borderRadius: BorderRadius.circular(_isHudExpanded ? 20 : 35),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurpleAccent.withOpacity(0.5),
                blurRadius: 12,
                spreadRadius: 2,
              )
            ],
            border: Border.all(color: Colors.amber, width: 1.5),
          ),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _isHudExpanded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.bolt, color: Colors.amber, size: 18),
                                SizedBox(width: 4),
                                Text(
                                  'Pulse HUD',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 16, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _isHudExpanded = false;
                                });
                              },
                            )
                          ],
                        ),
                        const Divider(height: 1, color: Colors.white70),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _buildMiniHudButton('Calc Hour', Icons.calculate, () {
                              _showQuickHourDialog();
                            }),
                            _buildMiniHudButton('Save \$', Icons.monetization_on, () {
                              _showQuickSaveDialog();
                            }),
                            _buildMiniHudButton('Vault', Icons.lock, () {
                              setState(() => _currentIndex = 3);
                            }),
                            _buildMiniHudButton('Streak', Icons.local_fire_department, () {
                              setState(() => _currentIndex = 4);
                            }),
                          ],
                        ),
                      ],
                    )
                  : IconButton(
                      icon: const Icon(Icons.touch_app, color: Colors.amber, size: 30),
                      onPressed: () {
                        setState(() {
                          _isHudExpanded = true;
                        });
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniHudButton(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.amber),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: Floating HUD Dashboard & System Overlay Control
  Widget _buildFloatingHudTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Floating Smart HUD', 'System-wide micro helper widget preview'),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFF1F1D2B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: Colors.amber,
                    title: const Text(
                      'Enable Floating Screen Widget',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'Overlay stays visible over other apps to prevent impulse buying.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    value: _isFloatingHudEnabled,
                    onChanged: (val) {
                      setState(() {
                        _isFloatingHudEnabled = val;
                      });
                    },
                  ),
                  const Divider(color: Colors.white70),
                  const ListTile(
                    leading: Icon(Icons.display_settings, color: Colors.teal),
                    title: Text('Display Above Apps Permission'),
                    subtitle: Text('Granted (Active Overlay Mode)', style: TextStyle(color: Colors.green, fontSize: 12)),
                    trailing: Icon(Icons.check_circle, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Quick Action Widgets',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildFeatureCard('Impulse Interceptor', 'Calculate cost in working hours', Icons.shield, Colors.deepPurpleAccent, () {
                setState(() => _currentIndex = 1);
              }),
              _buildFeatureCard('Active Notif Bar', 'Sticky persistent shortcuts', Icons.notifications, Colors.orange, () {
                setState(() => _currentIndex = 2);
              }),
              _buildFeatureCard('Micro Vault', 'Copy snippets in 1-tap', Icons.content_paste, Colors.teal, () {
                setState(() => _currentIndex = 3);
              }),
              _buildFeatureCard('Time-Value Hub', 'Earn points while focused', Icons.monetization_on, Colors.amber, () {
                setState(() => _currentIndex = 4);
              }),
            ],
          ),
        ],
      ),
    );
  }

  // TAB 2: Impulse Interceptor & Work Hour Calculator
  Widget _buildImpulseInterceptorTab() {
    final TextEditingController itemController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController wageController = TextEditingController(text: '25');

    double hoursNeeded = 0.0;
    double futureValue = 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: StatefulBuilder(
        builder: (context, setSubState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader('Impulse Buyer Interceptor', 'Convert price into exact life-hours spent working'),
              const SizedBox(height: 16),
              Card(
                color: const Color(0xFF1F1D2B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: itemController,
                        decoration: const InputDecoration(
                          labelText: 'Item You Want to Buy',
                          hintText: 'e.g., Wireless Headphones',
                          prefixIcon: Icon(Icons.shopping_bag),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Price (\$)',
                                hintText: '120.00',
                                prefixIcon: Icon(Icons.attach_money),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: wageController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Hourly Wage (\$)',
                                hintText: '25.00',
                                prefixIcon: Icon(Icons.work),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        icon: const Icon(Icons.calculate),
                        label: const Text('INTERCEPT & EVALUATE', style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          final double price = double.tryParse(priceController.text) ?? 0.0;
                          final double wage = double.tryParse(wageController.text) ?? 1.0;

                          setSubState(() {
                            hoursNeeded = price / (wage > 0 ? wage : 1);
                            futureValue = price * 1.61; // Estimated 5-year investment growth multiplier
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (hoursNeeded > 0) ...[
                Card(
                  color: Colors.deepPurple.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.amber, width: 1.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'REAL COST BREAKDOWN',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        FittedBox(
                          child: Text(
                            '${hoursNeeded.toStringAsFixed(1)} Hours',
                            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        Text(
                          'You must work ${hoursNeeded.toStringAsFixed(1)} hours of your life to pay for this.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.trending_up, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'If invested instead, this would grow to \$${futureValue.toStringAsFixed(2)} in 5 years!',
                                  style: const TextStyle(fontSize: 12, color: Colors.greenAccent),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                onPressed: () {
                                  final double price = double.tryParse(priceController.text) ?? 0.0;
                                  setState(() {
                                    _savedMoney += price;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Great job! Saved \$${price.toStringAsFixed(2)}!')),
                                  );
                                },
                                child: const Text('I skipped buying!'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  // TAB 3: Persistent Notification Bar Builder
  Widget _buildNotificationBuilderTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Sticky Notification HUD', 'Custom system notifications for instant lockscreen access'),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFF1F1D2B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Active System Notifications',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber),
                  ),
                  const SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _activeNotifications.length,
                    separatorBuilder: (context, index) => const Divider(color: Colors.white70),
                    itemBuilder: (context, index) {
                      final notif = _activeNotifications[index];
                      return SwitchListTile(
                        value: notif['enabled'],
                        activeColor: Colors.amber,
                        onChanged: (val) {
                          setState(() {
                            notif['enabled'] = val;
                          });
                        },
                        secondary: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: Icon(notif['icon'] as IconData, color: Colors.amber, size: 20),
                        ),
                        title: Text(notif['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text(notif['body'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
            ),
            icon: const Icon(Icons.add_alert),
            label: const Text('CREATE NEW PERSISTENT NOTIFICATION', style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              _showAddNotificationDialog();
            },
          ),
        ],
      ),
    );
  }

  // TAB 4: Micro-Vault & Clipboard Shortcuts
  Widget _buildMicroVaultTab() {
    final TextEditingController titleCtrl = TextEditingController();
    final TextEditingController contentCtrl = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Micro-Vault & Shortcuts', 'Store quick snippet texts for 1-tap fast access'),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _snippets.length,
            itemBuilder: (context, index) {
              final item = _snippets[index];
              return Card(
                color: const Color(0xFF1F1D2B),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.copy, color: Colors.white, size: 18),
                  ),
                  title: Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item['content']!, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: const Icon(Icons.content_copy, color: Colors.amber),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Copied "${item['title']}" to clipboard!')),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Card(
            color: const Color(0xFF161522),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add Quick Snippet', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: contentCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Content to copy',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                    onPressed: () {
                      if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                        setState(() {
                          _snippets.add({
                            'title': titleCtrl.text,
                            'content': contentCtrl.text,
                          });
                        });
                        titleCtrl.clear();
                        contentCtrl.clear();
                      }
                    },
                    child: const Text('Save Snippet'),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // TAB 5: Engagement, Rewards & Time Value
  Widget _buildEngagementHubTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Daily Rewards & Value', 'Earn points and track total money saved from impulse buys'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Daily Streak', '$_dailyStreak Days', Icons.local_fire_department, Colors.orange),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Total Saved', '\$${_savedMoney.toStringAsFixed(0)}', Icons.savings, Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFF1F1D2B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Active App Usage Session',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Time Active Today:'),
                      Text('$_timeSpentSeconds sec', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const LinearProgressIndicator(
                    value: 0.65,
                    backgroundColor: Colors.white70,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Stay active to unlock custom HUD color themes & lower impulse alert threshold!',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Monetization Slot Simulation Ready for AdMob Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70, style: BorderStyle.solid),
            ),
            child: const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.stars, color: Colors.amber, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'SPONSORED PARTNER CONTENT',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  'Grow your savings 8% APY with Smart Vault',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amberAccent),
                ),
                Text(
                  'Ad Placement Zone - Ready for Google AdMob',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // UI Helpers
  Widget _buildHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1F1D2B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1D2B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showQuickHourDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quick Hours Calculator'),
        content: const Text('Enter any price on screen to quickly see work hours cost from your floating overlay.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  void _showQuickSaveDialog() {
    setState(() {
      _savedMoney += 20.0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quick Saved \$20.00! Keep up the smart choices!')),
    );
  }

  void _showAddNotificationDialog() {
    final TextEditingController nTitle = TextEditingController();
    final TextEditingController nBody = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Persistent Notification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nTitle,
              decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nBody,
              decoration: const InputDecoration(labelText: 'Subtitle', border: OutlineInputBorder()),
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
              if (nTitle.text.isNotEmpty) {
                setState(() {
                  _activeNotifications.add({
                    'title': nTitle.text,
                    'body': nBody.text.isEmpty ? 'Tap to open shortcut' : nBody.text,
                    'icon': Icons.bolt,
                    'enabled': true,
                  });
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }
}