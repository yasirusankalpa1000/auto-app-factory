import 'package:flutter/material.dart';

void main() {
  runApp(const FloatDeckApp());
}

class FloatDeckApp extends StatelessWidget {
  const FloatDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatDeck Overlay Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FE),
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
  
  // Floating overlay state
  bool _isOverlayEnabled = true;
  Offset _bubblePosition = const Offset(20, 200);
  bool _isBubbleExpanded = false;
  
  // Permissions status
  bool _hasOverlayPermission = true;
  bool _hasNotificationPermission = true;

  // Pinned Quick Note
  String _pinnedNote = "Tap 'Pin Note' to store quick text here!";
  
  // Quick link cleaner input
  final TextEditingController _linkController = TextEditingController();
  String _cleanedLink = "";

  // Quick Currency Converter state
  final TextEditingController _amountController = TextEditingController(text: "100");
  double _exchangeRate = 325.50; // Dynamic sample rate
  String _convertedResult = "\$100.00 = 32,550.00 LKR";

  @override
  void dispose() {
    _linkController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _cleanLink() {
    final raw = _linkController.text.trim();
    if (raw.isEmpty) {
      setState(() => _cleanedLink = "Please paste a link first!");
      return;
    }
    try {
      final uri = Uri.parse(raw);
      // Strip common tracking parameters
      final cleanQueryParams = Map<String, String>.from(uri.queryParameters)
        ..removeWhere((key, value) =>
            key.startsWith('utm_') ||
            key == 'fbclid' ||
            key == 'igshid' ||
            key == 'gclid' ||
            key == 'si');
      
      final cleanUri = Uri(
        scheme: uri.scheme,
        host: uri.host,
        path: uri.path,
        queryParameters: cleanQueryParams.isEmpty ? null : cleanQueryParams,
      );

      setState(() {
        _cleanedLink = cleanUri.toString();
      });
    } catch (e) {
      setState(() {
        _cleanedLink = "Invalid URL format. Please check the text.";
      });
    }
  }

  void _calculateCurrency() {
    final val = double.tryParse(_amountController.text) ?? 0.0;
    final total = val * _exchangeRate;
    setState(() {
      _convertedResult = "\$${val.toStringAsFixed(2)} USD = ${total.toStringAsFixed(2)} Local Currency";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Body Tabs
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildDashboardTab(),
                _buildLinkScrubberTab(),
                _buildWidgetStudioTab(),
                _buildPermissionsTab(),
              ],
            ),
          ),

          // Simulated System Floating Overlay Head (Draggable)
          if (_isOverlayEnabled)
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetectingOverlayBubble(
                onPanUpdate: (details) {
                  setState(() {
                    final size = MediaQuery.of(context).size;
                    double newX = _bubblePosition.dx + details.delta.dx;
                    double newY = _bubblePosition.dy + details.delta.dy;
                    // Keep within screen boundaries
                    newX = newX.clamp(10.0, size.width - 70.0);
                    newY = newY.clamp(50.0, size.height - 120.0);
                    _bubblePosition = Offset(newX, newY);
                  });
                },
                onTap: () {
                  _showFloatingQuickMenu(context);
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.space_dashboard_outlined),
            selectedIcon: Icon(Icons.space_dashboard, color: Colors.deepPurple),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.cleaning_services_outlined),
            selectedIcon: Icon(Icons.cleaning_services, color: Colors.deepPurple),
            label: 'Link Clean',
          ),
          NavigationDestination(
            icon: Icon(Icons.widgets_outlined),
            selectedIcon: Icon(Icons.widgets, color: Colors.deepPurple),
            label: 'Studio',
          ),
          NavigationDestination(
            icon: Icon(Icons.security_outlined),
            selectedIcon: Icon(Icons.security, color: Colors.deepPurple),
            label: 'Permissions',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: DASHBOARD ---
  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBanner(),
          const SizedBox(height: 16),
          _buildOverlayToggleCard(),
          const SizedBox(height: 16),
          _buildPinnedNoteCard(),
          const SizedBox(height: 16),
          _buildQuickConverterCard(),
          const SizedBox(height: 16),
          _buildUsageAnalyticsCard(),
        ],
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.deepPurple, Colors.indigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white70,
            child: Icon(Icons.layers, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'FloatDeck active',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Drag the purple dynamic bubble anywhere on screen to trigger overlay micro-tools!',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayToggleCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.touch_app, color: Colors.deepPurple),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Floating Bubble Head',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Simulate system draw overlay over all screen apps',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Switch(
              value: _isOverlayEnabled,
              activeColor: Colors.deepPurple,
              onChanged: (val) {
                setState(() {
                  _isOverlayEnabled = val;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      val ? 'Floating Overlay Enabled!' : 'Floating Overlay Disabled!',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinnedNoteCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.pin_drop, color: Colors.amber, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Floating Sticky Scratchpad',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20, color: Colors.grey),
                  onPressed: () => _showEditNoteDialog(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Text(
                _pinnedNote,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickConverterCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.calculate, color: Colors.teal),
                SizedBox(width: 8),
                Text(
                  'Quick Currency Micro-Calc',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount (\$) USD',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _calculateCurrency,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  child: const Text('Convert'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _convertedResult,
                style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageAnalyticsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Time Saved with FloatDeck',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricItem('14 Swaps', 'App switches saved', Icons.swap_horizontal_circle),
              _buildMetricItem('8 Links', 'Trackers cleaned', Icons.cleaning_services),
              _buildMetricItem('12 Mins', 'Active daily use', Icons.timer),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 11),
        ),
      ],
    );
  }

  // --- TAB 2: LINK SCRUBBER ---
  Widget _buildLinkScrubberTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Link Tracker Scrubber',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Strip analytics bloat, utm parameters, and tracking scripts from messy URLs instantly.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _linkController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Paste raw link here (e.g. https://example.com/item?utm_source=fb&igshid=xyz123...)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _linkController.clear();
                            setState(() => _cleanedLink = "");
                          },
                          icon: const Icon(Icons.clear),
                          label: const Text('Clear'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _cleanLink,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.cleaning_services),
                          label: const Text('Sanitize Link'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_cleanedLink.isNotEmpty) ...[
            const Text(
              'Sanitized Clean URL:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    _cleanedLink,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Clean link copied to clipboard!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(110, 36),
                      ),
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Copy Link'),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          _buildSampleLinksPreset(),
        ],
      ),
    );
  }

  Widget _buildSampleLinksPreset() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Try Quick Test Links',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              ActionChip(
                avatar: const Icon(Icons.link, size: 16),
                label: const Text('Amazon product link with UTM'),
                onPressed: () {
                  _linkController.text =
                      'https://www.amazon.com/dp/B08N5WRWNW?utm_source=social&utm_medium=facebook&igshid=abc12345';
                  _cleanLink();
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.play_arrow, size: 16),
                label: const Text('YouTube tracking link'),
                onPressed: () {
                  _linkController.text =
                      'https://youtu.be/dQw4w9WgXcQ?si=abcdef123456&fbclid=IwAR2XYZ';
                  _cleanLink();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- TAB 3: WIDGET STUDIO ---
  Widget _buildWidgetStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Widget Studio',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Customize your floating dynamic bubble style and active contextual tools.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          _buildThemeSelectorCard(),
          const SizedBox(height: 16),
          _buildActiveToolsSelector(),
        ],
      ),
    );
  }

  Widget _buildThemeSelectorCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bubble Appearance',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildColorBubbleChoice('Purple', Colors.deepPurple, true),
                _buildColorBubbleChoice('Teal', Colors.teal, false),
                _buildColorBubbleChoice('Indigo', Colors.indigo, false),
                _buildColorBubbleChoice('Amber', Colors.amber, false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorBubbleChoice(String name, Color color, bool selected) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: color,
          child: selected ? const Icon(Icons.check, color: Colors.white) : null,
        ),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildActiveToolsSelector() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Floating Bubble Menu Tools',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildToolSwitchTile('Link Cleaner', 'Sanitize copied links', Icons.cleaning_services, true),
            const Divider(height: 1),
            _buildToolSwitchTile('Sticky Note Pin', 'Keep text on screen', Icons.pin_drop, true),
            const Divider(height: 1),
            _buildToolSwitchTile('Currency Convert', 'Instant price estimations', Icons.calculate, true),
            const Divider(height: 1),
            _buildToolSwitchTile('Text Formatter', 'Uppercase/lowercase scrubber', Icons.text_fields, false),
          ],
        ),
      ),
    );
  }

  Widget _buildToolSwitchTile(String title, String subtitle, IconData icon, bool value) {
    return SwitchListTile(
      value: value,
      activeColor: Colors.deepPurple,
      onChanged: (val) {},
      secondary: Icon(icon, color: Colors.deepPurple),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
    );
  }

  // --- TAB 4: PERMISSIONS ---
  Widget _buildPermissionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Permissions',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'FloatDeck requires specific overlay permissions to stay active over other mobile apps.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          _buildPermissionTile(
            title: 'Display over other apps',
            description: 'Allows the floating bubble to stay visible over WhatsApp, Browsers, and Social Media.',
            icon: Icons.layers,
            isEnabled: _hasOverlayPermission,
            onToggle: (val) => setState(() => _hasOverlayPermission = val),
          ),
          const SizedBox(height: 12),
          _buildPermissionTile(
            title: 'Floating Notification Controller',
            description: 'Maintains background service status to prevent Android system from closing the floating bubble.',
            icon: Icons.notifications_active,
            isEnabled: _hasNotificationPermission,
            onToggle: (val) => setState(() => _hasNotificationPermission = val),
          ),
          const SizedBox(height: 20),
          _buildPermissionHelpBox(),
        ],
      ),
    );
  }

  Widget _buildPermissionTile({
    required String title,
    required String description,
    required IconData icon,
    required bool isEnabled,
    required ValueChanged<bool> onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEnabled ? Colors.deepPurple.withOpacity(0.3) : Colors.grey.shade300,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: isEnabled ? Colors.deepPurple.withOpacity(0.1) : Colors.grey.shade100,
            child: Icon(icon, color: isEnabled ? Colors.deepPurple : Colors.grey),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  softWrap: true,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      isEnabled ? Icons.check_circle : Icons.warning,
                      color: isEnabled ? Colors.green : Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isEnabled ? 'Granted' : 'Action Required',
                      style: TextStyle(
                        color: isEnabled ? Colors.green : Colors.amber.shade900,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            activeColor: Colors.deepPurple,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionHelpBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          Icon(Icons.info, color: Colors.indigo),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your privacy is 100% safe. FloatDeck processes all cleaned links, text transformations, and notes locally on your device.',
              style: TextStyle(color: Colors.indigo, fontSize: 12, fontWeight: FontWeight.w500),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  // --- FLOATING OVERLAY QUICK MENU ---
  void _showFloatingQuickMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Icon(Icons.bolt, color: Colors.deepPurple),
                    SizedBox(width: 8),
                    Text(
                      'FloatDeck Copilot Overlay Tools',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildOverlayMenuButton(
                      icon: Icons.cleaning_services,
                      label: 'Sanitize Clipboard Link',
                      color: Colors.deepPurple,
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() => _currentIndex = 1);
                      },
                    ),
                    _buildOverlayMenuButton(
                      icon: Icons.pin_drop,
                      label: 'Quick Scratchpad',
                      color: Colors.amber.shade800,
                      onTap: () {
                        Navigator.pop(ctx);
                        _showEditNoteDialog();
                      },
                    ),
                    _buildOverlayMenuButton(
                      icon: Icons.calculate,
                      label: 'Micro Converter',
                      color: Colors.teal,
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() => _currentIndex = 0);
                      },
                    ),
                    _buildOverlayMenuButton(
                      icon: Icons.settings,
                      label: 'Studio Config',
                      color: Colors.indigo,
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() => _currentIndex = 2);
                      },
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

  Widget _buildOverlayMenuButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditNoteDialog() {
    final controller = TextEditingController(text: _pinnedNote);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Floating Sticky Note'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter text to keep pinned on screen...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _pinnedNote = controller.text.trim().isEmpty
                    ? 'No pinned note available'
                    : controller.text.trim();
              });
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save Note'),
          ),
        ],
      ),
    );
  }
}

// Custom Floating Overlay Bubble Widget
class GestureDetectingOverlayBubble extends StatelessWidget {
  final GestureDragUpdateCallback onPanUpdate;
  final VoidCallback onTap;

  const GestureDetectingOverlayBubble({
    super.key,
    required onPanUpdate,
    required onTap,
  })  : onPanUpdate = onPanUpdate,
        onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onPanUpdate,
      onTap: onTap,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Colors.deepPurple, Colors.indigo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.layers, color: Colors.white, size: 26),
            Positioned(
              right: 4,
              top: 4,
              child: CircleAvatar(
                radius: 5,
                backgroundColor: Colors.greenAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}