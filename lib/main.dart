import 'package:flutter/material.dart';

void main() {
  runApp(const OmniHudApp());
}

class OmniHudApp extends StatelessWidget {
  const OmniHudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniHUD - Dynamic Floating Dock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainHudScreen(),
    );
  }
}

class MainHudScreen extends StatefulWidget {
  const MainHudScreen({super.key});

  @override
  State<MainHudScreen> createState() => _MainHudScreenState();
}

class _MainHudScreenState extends State<MainHudScreen> {
  int _currentIndex = 0;

  // Global App States
  bool _isOverlayEnabled = true;
  bool _isNotificationAccessGranted = true;
  bool _isAccessibilityEnabled = false;
  bool _isFloatingOrbExpanded = false;

  Offset _orbPosition = const Offset(280, 240);
  Color _hudThemeColor = Colors.indigo;

  // Clipboard Vault
  final List<String> _clipboardVault = [
    'Order ID: #ORD-998231',
    'Delivery Address: 742 Evergreen Terrace',
    'Wi-Fi Password: GuestPass2025!',
    'Zoom Link: https://zoom.us/j/987654321',
  ];
  final TextEditingController _clipController = TextEditingController();

  // Floating Quick Notes
  final List<String> _hudNotes = [
    'Buy fresh avocado and whole wheat bread',
    'Call doctor at 3:00 PM for prescription',
  ];
  final TextEditingController _noteController = TextEditingController();

  // Micro Calculator State
  double _billAmount = 45.0;
  double _tipPercentage = 15.0;
  int _splitPeople = 2;

  // Ambient Ticker State
  String _tickerMessage = "🔥 Dynamic Floating Notification Ticker Active!";
  final TextEditingController _tickerController = TextEditingController();

  @override
  void dispose() {
    _clipController.dispose();
    _noteController.dispose();
    _tickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 2,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _hudThemeColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.widgets, color: _hudThemeColor, size: 22),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'OmniHUD Floating Assist',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isOverlayEnabled ? Icons.visibility : Icons.visibility_off,
              color: _isOverlayEnabled ? Colors.green : Colors.grey,
            ),
            tooltip: 'Toggle Overlay Dock',
            onPressed: () {
              setState(() {
                _isOverlayEnabled = !_isOverlayEnabled;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isOverlayEnabled
                        ? 'Floating Overlay Dock Activated!'
                        : 'Floating Overlay Dock Hidden.',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main Tab Views
          IndexedStack(
            index: _currentIndex,
            children: [
              _buildCanvasTab(),
              _buildMicroToolsTab(),
              _buildTickerTab(),
              _buildPermissionsTab(),
            ],
          ),

          // Interactive Draggable Floating Orb Simulation (Visible over screens)
          if (_isOverlayEnabled) _buildDraggableFloatingOrb(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        backgroundColor: const Color(0xFF1E293B),
        indicatorColor: _hudThemeColor.withOpacity(0.3),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.touch_app, color: Colors.white70),
            selectedIcon: Icon(Icons.touch_app, color: Colors.white),
            label: 'HUD Dock',
          ),
          NavigationDestination(
            icon: Icon(Icons.build, color: Colors.white70),
            selectedIcon: Icon(Icons.build, color: Colors.white),
            label: 'Micro Tools',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications, color: Colors.white70),
            selectedIcon: Icon(Icons.notifications, color: Colors.white),
            label: 'Ambient Ticker',
          ),
          NavigationDestination(
            icon: Icon(Icons.security, color: Colors.white70),
            selectedIcon: Icon(Icons.security, color: Colors.white),
            label: 'Overlay Status',
          ),
        ],
      ),
    );
  }

  // ================= TAB 1: DOCK CANVAS & PLAYGROUND =================
  Widget _buildCanvasTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isOverlayEnabled
                      ? Colors.teal.withOpacity(0.5)
                      : Colors.grey.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        _isOverlayEnabled ? Colors.green : Colors.grey,
                    radius: 10,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isOverlayEnabled
                              ? 'Active Screen Floating Dock'
                              : 'Floating Dock Paused',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Drag the glowing orb anywhere on your screen. Tap it to reveal instant HUD tools!',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Live Ticker Preview Ribbon
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _hudThemeColor.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Icon(Icons.stars, color: _hudThemeColor, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _tickerMessage,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Theme & Style Selector
            const Text(
              'HUD Accent Color',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAxisAlignment.center,
              children: [
                _buildColorChip('Indigo', Colors.indigo),
                _buildColorChip('Teal', Colors.teal),
                _buildColorChip('Orange', Colors.deepOrange),
                _buildColorChip('Purple', Colors.purple),
                _buildColorChip('Blue', Colors.blue),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Dock Shortcuts Visualizer
            const Text(
              'Active Dock Quick Slots',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.2,
              children: [
                _buildDockSlotCard(
                  'Clipboard Vault',
                  '${_clipboardVault.length} items pinned',
                  Icons.copy,
                  Colors.blue,
                ),
                _buildDockSlotCard(
                  'Quick Notes',
                  '${_hudNotes.length} pending memo',
                  Icons.edit,
                  Colors.amber,
                ),
                _buildDockSlotCard(
                  'Tip & Split Math',
                  'Instant floating calc',
                  Icons.calculate,
                  Colors.teal,
                ),
                _buildDockSlotCard(
                  'Screen Ruler',
                  'Quick On-Screen Measure',
                  Icons.straighten,
                  Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tips Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info, color: Colors.indigo, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'OmniHUD runs unobtrusively while you use social media, web browsers, or chat apps to save you precious micro-seconds every day!',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorChip(String label, Color color) {
    final isSelected = _hudThemeColor.value == color.value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: color,
      backgroundColor: const Color(0xFF1E293B),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.white70,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (val) {
        if (val) {
          setState(() {
            _hudThemeColor = color;
          });
        }
      },
    );
  }

  Widget _buildDockSlotCard(
      String title, String subtitle, IconData icon, Color accent) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: accent.withOpacity(0.2),
            radius: 18,
            child: Icon(icon, color: accent, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= TAB 2: MICRO TOOLS (CLIPBOARD & MATH) =================
  Widget _buildMicroToolsTab() {
    double tipAmount = (_billAmount * _tipPercentage) / 100;
    double totalAmount = _billAmount + tipAmount;
    double perPerson = _splitPeople > 0 ? totalAmount / _splitPeople : totalAmount;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Clipboard Section
            const Text(
              'Floating Clipboard Vault',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _clipController,
                    decoration: const InputDecoration(
                      hintText: 'Add snippet to dynamic HUD...',
                      hintStyle: TextStyle(color: Colors.white70, fontSize: 13),
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _hudThemeColor,
                    padding: const EdgeInsets.all(14),
                  ),
                  onPressed: () {
                    if (_clipController.text.trim().isNotEmpty) {
                      setState(() {
                        _clipboardVault.insert(0, _clipController.text.trim());
                        _clipController.clear();
                      });
                    }
                  },
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _clipboardVault.length,
              itemBuilder: (context, index) {
                final item = _clipboardVault[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    dense: true,
                    leading: const Icon(Icons.copy, color: Colors.teal, size: 18),
                    title: Text(
                      item,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share,
                              color: Colors.white70, size: 18),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Copied snippet: "$item"'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.redAccent, size: 18),
                          onPressed: () {
                            setState(() {
                              _clipboardVault.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Quick Calculator Section (Tip & Split)
            const Text(
              'Instant Floating Calculator (Tip & Split)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.teal.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Bill Amount:',
                          style: TextStyle(color: Colors.white70)),
                      Text(
                        '\$${_billAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _billAmount,
                    min: 5.0,
                    max: 300.0,
                    divisions: 59,
                    activeColor: Colors.teal,
                    onChanged: (val) {
                      setState(() {
                        _billAmount = val;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tip (${_tipPercentage.toInt()}%):',
                          style: const TextStyle(color: Colors.white70)),
                      Text(
                        '\$${tipAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _tipPercentage,
                    min: 0.0,
                    max: 30.0,
                    divisions: 6,
                    activeColor: Colors.amber,
                    onChanged: (val) {
                      setState(() {
                        _tipPercentage = val;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Split Between ($_splitPeople people):',
                          style: const TextStyle(color: Colors.white70)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.white70),
                            onPressed: () {
                              if (_splitPeople > 1) {
                                setState(() => _splitPeople--);
                              }
                            },
                          ),
                          Text('$_splitPeople',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          IconButton(
                            icon: const Icon(Icons.add_circle,
                                color: Colors.white70),
                            onPressed: () {
                              setState(() => _splitPeople++);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white70),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Each Person Pays:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '\$${perPerson.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                          fontSize: 18,
                        ),
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

  // ================= TAB 3: AMBIENT TICKER & QUICK NOTES =================
  Widget _buildTickerTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ambient Notification Ticker Customizer',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Customize the live floating message ticker that overlays on top of screen apps.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _tickerController,
              decoration: const InputDecoration(
                labelText: 'New Ticker Message',
                labelStyle: TextStyle(color: Colors.white70),
                hintText: 'Type alert or reminder text...',
                hintStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _hudThemeColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  'Update Live Ticker',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (_tickerController.text.trim().isNotEmpty) {
                    setState(() {
                      _tickerMessage = _tickerController.text.trim();
                      _tickerController.clear();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Floating Ticker Message Updated!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 24),

            // Floating Quick Notes Section
            const Text(
              'HUD Quick Notes & Memos',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      hintText: 'Add quick memo...',
                      hintStyle: TextStyle(color: Colors.white70, fontSize: 13),
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.all(14),
                  ),
                  onPressed: () {
                    if (_noteController.text.trim().isNotEmpty) {
                      setState(() {
                        _hudNotes.insert(0, _noteController.text.trim());
                        _noteController.clear();
                      });
                    }
                  },
                  child: const Icon(Icons.add, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _hudNotes.length,
              itemBuilder: (context, idx) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.edit, color: Colors.amber, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _hudNotes[idx],
                          style:
                              const TextStyle(color: Colors.white, fontSize: 13),
                          softWrap: true,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.check,
                            color: Colors.greenAccent, size: 20),
                        onPressed: () {
                          setState(() {
                            _hudNotes.removeAt(idx);
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
      ),
    );
  }

  // ================= TAB 4: PERMISSIONS & SYSTEM OVERLAY =================
  Widget _buildPermissionsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'System & Floating Permissions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage device overlay permissions to enable OmniHUD floating widgets over all applications.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 16),
            _buildPermissionTile(
              'Display Over Apps Permission',
              'Required to render the dynamic orb & ticker on top of other mobile apps.',
              Icons.open_in_new,
              _isOverlayEnabled,
              (val) => setState(() => _isOverlayEnabled = val),
            ),
            _buildPermissionTile(
              'Notification Listener Access',
              'Allows dynamic floating ticker to mirror incoming notifications.',
              Icons.notifications,
              _isNotificationAccessGranted,
              (val) => setState(() => _isNotificationAccessGranted = val),
            ),
            _buildPermissionTile(
              'Accessibility Gesture Helper',
              'Enables 1-tap floating back button and home shortcut gestures.',
              Icons.touch_app,
              _isAccessibilityEnabled,
              (val) => setState(() => _isAccessibilityEnabled = val),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.indigo.withOpacity(0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacy & System Guarantee',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'OmniHUD processes clipboard data and screen tools 100% locally on your device memory. No data is stored or transmitted externally.',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionTile(
    String title,
    String desc,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        secondary: CircleAvatar(
          backgroundColor: value ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
          child: Icon(icon, color: value ? Colors.green : Colors.grey),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          desc,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
        value: value,
        activeColor: Colors.teal,
        onChanged: onChanged,
      ),
    );
  }

  // ================= FLOATING ORB SIMULATOR (DRAGGABLE & EXPANDABLE) =================
  Widget _buildDraggableFloatingOrb() {
    return Positioned(
      left: _orbPosition.dx,
      top: _orbPosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _orbPosition += details.delta;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Expanded HUD Radial Shortcut Menu
            if (_isFloatingOrbExpanded)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _hudThemeColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'OmniHUD Quick Menu',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAxisAlignment.center,
                      children: [
                        _buildOrbQuickAction(
                          Icons.copy,
                          'Clip (${_clipboardVault.length})',
                          Colors.teal,
                          () {
                            _showQuickDialog(
                              'Clipboard Vault',
                              _clipboardVault.isNotEmpty
                                  ? _clipboardVault.first
                                  : 'Vault Empty',
                            );
                          },
                        ),
                        _buildOrbQuickAction(
                          Icons.edit,
                          'Notes (${_hudNotes.length})',
                          Colors.amber,
                          () {
                            _showQuickDialog(
                              'Quick Note',
                              _hudNotes.isNotEmpty
                                  ? _hudNotes.first
                                  : 'No active notes',
                            );
                          },
                        ),
                        _buildOrbQuickAction(
                          Icons.calculate,
                          'Calc',
                          Colors.blue,
                          () {
                            _showQuickDialog(
                              'Split Math',
                              'Bill: \$${_billAmount.toStringAsFixed(2)} | Split: $_splitPeople',
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // Main Trigger Orb Floating Widget
            InkWell(
              onTap: () {
                setState(() {
                  _isFloatingOrbExpanded = !_isFloatingOrbExpanded;
                });
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _hudThemeColor,
                  boxShadow: [
                    BoxShadow(
                      color: _hudThemeColor.withOpacity(0.6),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    _isFloatingOrbExpanded ? Icons.close : Icons.widgets,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrbQuickAction(
      IconData icon, String label, Color bg, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: bg.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: bg.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: bg, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(content, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }
}