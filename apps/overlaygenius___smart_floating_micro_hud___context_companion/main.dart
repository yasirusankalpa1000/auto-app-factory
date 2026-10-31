import 'package:flutter/material.dart';

void main() {
  runApp(const OverlayGeniusApp());
}

class OverlayGeniusApp extends StatelessWidget {
  const OverlayGeniusApp({super.key});

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'OverlayGenius',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> meState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentTab = 0;

  final List<Widget> _screens = const [
    FloatingStudioScreen(),
    ClipboardVaultScreen(),
    DecisionEngineScreen(),
    SettingsPermissionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentTab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTab,
        onDestinationSelected: (int index) {
          setState(() {
            _currentTab = index;
          });
        },
        backgroundColor: const Color(0xFF1E293B),
        indicatorColor: Colors.indigo.shade600,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.widgets_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.widgets, color: Colors.white),
            label: 'Floating HUD',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_copy_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.content_copy, color: Colors.white),
            label: 'Clip Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.touch_app_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.touch_app, color: Colors.white),
            label: 'Decision Wheel',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.settings, color: Colors.white),
            label: 'Permissions',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SCREEN 1: Floating HUD Interactive Studio & Live Canvas Demo
// -----------------------------------------------------------------------------
class FloatingStudioScreen extends StatefulWidget {
  const FloatingStudioScreen({super.key});

  @override
  State<FloatingStudioScreen> createState() => _FloatingStudioScreenState();
}

class _FloatingStudioScreenState extends State<FloatingStudioScreen> {
  bool _hudServiceActive = true;
  bool _showClipboardBubble = true;
  bool _showNoteBubble = true;
  bool _showDecisionBubble = true;

  // Interactive Drag Positions
  Offset _bubble1Pos = const Offset(20, 160);
  Offset _bubble2Pos = const Offset(20, 240);
  Offset _bubble3Pos = const Offset(20, 320);

  // Floating Window Toggle
  String _activeFloatingWindow = 'none';
  String _stickyNoteText = "Bank Account:\n1234-5678-9012\nSWIFT: GENIUSUS33";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OverlayGenius Studio',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          Switch(
            value: _hudServiceActive,
            onChanged: (val) {
              setState(() {
                _hudServiceActive = val;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    val ? 'Floating Overlay Engine Enabled' : 'Overlay Engine Paused',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            activeColor: Colors.tealAccent,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Background Dashboard
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusBanner(),
                  const SizedBox(height: 16),
                  const Text(
                    'Active Floating Micro-Widgets',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Toggle widgets below and test dragging their interactive bubbles anywhere on your screen!',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  _buildWidgetToggleCard(
                    title: 'Floating Clipboard Vault',
                    subtitle: 'One-tap paste for account info, phone numbers & templates',
                    icon: Icons.assignment_outlined,
                    color: Colors.indigo,
                    value: _showClipboardBubble,
                    onChanged: (val) => setState(() => _showClipboardBubble = val),
                  ),
                  const SizedBox(height: 10),
                  _buildWidgetToggleCard(
                    title: 'Floating Sticky Note',
                    subtitle: 'Quick floating micro-pad visible over Instagram, WhatsApp & Web',
                    icon: Icons.note_alt_outlined,
                    color: Colors.amber.shade700,
                    value: _showNoteBubble,
                    onChanged: (val) => setState(() => _showNoteBubble = val),
                  ),
                  const SizedBox(height: 10),
                  _buildWidgetToggleCard(
                    title: 'Floating Decision Spinner',
                    subtitle: 'Instant random picker when stuck between daily options',
                    icon: Icons.casino_outlined,
                    color: Colors.purple,
                    value: _showDecisionBubble,
                    onChanged: (val) => setState(() => _showDecisionBubble = val),
                  ),
                  const SizedBox(height: 20),
                  _buildTipsCard(),
                  const SizedBox(height: 100), // Spacing for floating overlays
                ],
              ),
            ),

            // LIVE INTERACTIVE FLOATING OVERLAY HEADS (DRAGGABLE)
            if (_hudServiceActive && _showClipboardBubble)
              Positioned(
                left: _bubble1Pos.dx,
                top: _bubble1Pos.dy,
                child: Draggable(
                  feedback: _buildBubbleIcon(Icons.content_copy, Colors.indigo, isDragging: true),
                  childWhenDragging: const SizedBox.shrink(),
                  onDragEnd: (details) {
                    setState(() {
                      _bubble1Pos = details.offset;
                    });
                  },
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _activeFloatingWindow =
                            _activeFloatingWindow == 'clip' ? 'none' : 'clip';
                      });
                    },
                    child: _buildBubbleIcon(Icons.content_copy, Colors.indigo),
                  ),
                ),
              ),

            if (_hudServiceActive && _showNoteBubble)
              Positioned(
                left: _bubble2Pos.dx,
                top: _bubble2Pos.dy,
                child: Draggable(
                  feedback: _buildBubbleIcon(Icons.edit_note, Colors.amber.shade700, isDragging: true),
                  childWhenDragging: const SizedBox.shrink(),
                  onDragEnd: (details) {
                    setState(() {
                      _bubble2Pos = details.offset;
                    });
                  },
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _activeFloatingWindow =
                            _activeFloatingWindow == 'note' ? 'none' : 'note';
                      });
                    },
                    child: _buildBubbleIcon(Icons.edit_note, Colors.amber.shade700),
                  ),
                ),
              ),

            if (_hudServiceActive && _showDecisionBubble)
              Positioned(
                left: _bubble3Pos.dx,
                top: _bubble3Pos.dy,
                child: Draggable(
                  feedback: _buildBubbleIcon(Icons.casino, Colors.purple, isDragging: true),
                  childWhenDragging: const SizedBox.shrink(),
                  onDragEnd: (details) {
                    setState(() {
                      _bubble3Pos = details.offset;
                    });
                  },
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _activeFloatingWindow =
                            _activeFloatingWindow == 'decision' ? 'none' : 'decision';
                      });
                    },
                    child: _buildBubbleIcon(Icons.casino, Colors.purple),
                  ),
                ),
              ),

            // EXPANDED FLOATING WINDOW SIMULATORS
            if (_hudServiceActive && _activeFloatingWindow == 'clip')
              Positioned(
                left: 60,
                top: 180,
                child: _buildFloatingClipWindow(),
              ),

            if (_hudServiceActive && _activeFloatingWindow == 'note')
              Positioned(
                left: 60,
                top: 220,
                child: _buildFloatingNoteWindow(),
              ),

            if (_hudServiceActive && _activeFloatingWindow == 'decision')
              Positioned(
                left: 60,
                top: 250,
                child: _buildFloatingDecisionWindow(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _hudServiceActive
              ? [Colors.teal.shade800, Colors.indigo.shade900]
              : [Colors.grey.shade800, Colors.grey.shade900],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black87, blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Icon(
            _hudServiceActive ? Icons.sensors_sharp : Icons.sensors_off,
            size: 36,
            color: _hudServiceActive ? Colors.tealAccent : Colors.grey,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _hudServiceActive ? 'Overlay Engine ACTIVE' : 'Overlay Engine PAUSED',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _hudServiceActive
                      ? 'Floating HUD is active on top of display'
                      : 'Enable to show drag-and-drop bubbles',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetToggleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
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
              activeColor: Colors.indigoAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.indigo.shade900.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.indigo.shade700),
      ),
      child: const Row(
        children: [
          Icon(Icons.lightbulb_outline, color: Colors.amber),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'PRO TIP: Long-press any floating bubble to dock it to screen edge or open instant quick settings!',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubbleIcon(IconData icon, Color bg, {bool isDragging = false}) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: bg.withOpacity(0.5),
            blurRadius: isDragging ? 16 : 8,
            spreadRadius: isDragging ? 4 : 1,
          )
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 26),
    );
  }

  // Floating Window 1: Smart Clipboard Stash
  Widget _buildFloatingClipWindow() {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigoAccent, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black87, blurRadius: 16, offset: Offset(0, 6))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.content_copy, color: Colors.indigoAccent, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Quick Vault Stash',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => setState(() => _activeFloatingWindow = 'none'),
                child: const Icon(Icons.close, color: Colors.grey, size: 18),
              ),
            ],
          ),
          const Divider(color: Colors.white70, height: 16),
          _buildQuickClipItem('Home Address', '742 Evergreen Terrace, Springfield'),
          const SizedBox(height: 6),
          _buildQuickClipItem('Paypal Link', 'paypal.me/geniususer'),
          const SizedBox(height: 6),
          _buildQuickClipItem('WiFi Pass', 'GeniusGuest@2025!'),
        ],
      ),
    );
  }

  Widget _buildQuickClipItem(String title, String val) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.indigoAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  val,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, color: Colors.tealAccent, size: 16),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Copied: $val to clipboard!'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  // Floating Window 2: Dynamic Sticky Note
  Widget _buildFloatingNoteWindow() {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF27272A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade600, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black87, blurRadius: 16, offset: Offset(0, 6))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.edit_note, color: Colors.amber.shade400, size: 20),
                  const SizedBox(width: 6),
                  const Text(
                    'Floating Sticky Note',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => setState(() => _activeFloatingWindow = 'none'),
                child: const Icon(Icons.close, color: Colors.grey, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: TextEditingController(text: _stickyNoteText),
            maxLines: 4,
            style: const TextStyle(color: Colors.amberAccent, fontSize: 12),
            onChanged: (val) => _stickyNoteText = val,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(8),
              fillColor: Color(0xFF18181B),
              filled: true,
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Floating note saved!')),
                );
              },
              icon: const Icon(Icons.check, size: 14, color: Colors.amberAccent),
              label: const Text('Save Note', style: TextStyle(color: Colors.amberAccent, fontSize: 11)),
            ),
          )
        ],
      ),
    );
  }

  // Floating Window 3: Quick Decision Wheel
  Widget _buildFloatingDecisionWindow() {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B4B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purpleAccent, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black87, blurRadius: 16, offset: Offset(0, 6))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.casino, color: Colors.purpleAccent, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Quick Decision',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => setState(() => _activeFloatingWindow = 'none'),
                child: const Icon(Icons.close, color: Colors.grey, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Should I buy this now?',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purpleAccent,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              final options = ['YES! Do it!', 'NO! Wait 24 Hours', 'Ask a friend first', 'Flip a Coin!'];
              final randomPick = (options..shuffle()).first;
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: const Color(0xFF1E293B),
                  title: const Text('Decision Result', style: TextStyle(color: Colors.purpleAccent)),
                  content: Text(randomPick, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('OK', style: TextStyle(color: Colors.tealAccent)),
                    )
                  ],
                ),
              );
            },
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Spin Choice', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SCREEN 2: Smart Clipboard Vault Manager
// -----------------------------------------------------------------------------
class ClipboardVaultScreen extends StatefulWidget {
  const ClipboardVaultScreen({super.key});

  @override
  State<ClipboardVaultScreen> createState() => _ClipboardVaultScreenState();
}

class _ClipboardVaultScreenState extends State<ClipboardVaultScreen> {
  final List<Map<String, String>> _vaultItems = [
    {
      'title': 'Bank IBAN Account',
      'content': 'US98 4321 9988 1100 2299 01',
      'category': 'Finance',
    },
    {
      'title': 'Office Delivery Address',
      'content': 'Building B, 5th Floor, Tech Park Central, Sector 4',
      'category': 'Address',
    },
    {
      'title': 'Standard Support Reply',
      'content': 'Hi there! Thank you for contacting us. We will get back to you shortly.',
      'category': 'Templates',
    },
    {
      'title': 'Tax Registration ID',
      'content': 'TX-998102-X',
      'category': 'Finance',
    },
  ];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedCategory = 'Finance';

  void _addNewVaultItem() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Snippet to Vault',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Snippet Title (e.g. Bank Account)',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contentController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Snippet Content',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: ['Finance', 'Address', 'Templates', 'General'].map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: Colors.indigo,
                    onSelected: (val) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    if (_titleController.text.isNotEmpty &&
                        _contentController.text.isNotEmpty) {
                      setState(() {
                        _vaultItems.add({
                          'title': _titleController.text,
                          'content': _contentController.text,
                          'category': _selectedCategory,
                        });
                        _titleController.clear();
                        _contentController.clear();
                      });
                      Navigator.pop(ctx);
                    }
                  },
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text('Save to Floating Vault', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Smart Clipboard Vault',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.tealAccent, size: 28),
            onPressed: _addNewVaultItem,
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Stored Quick Snippets',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'These items automatically sync with your floating overlay clipboard bubble for instant pasting.',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _vaultItems.length,
                  itemBuilder: (ctx, index) {
                    final item = _vaultItems[index];
                    return Card(
                      color: const Color(0xFF1E293B),
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo.shade900,
                          child: Icon(
                            item['category'] == 'Finance'
                                ? Icons.monetization_on
                                : item['category'] == 'Address'
                                    ? Icons.location_on
                                    : Icons.article,
                            color: Colors.indigoAccent,
                          ),
                        ),
                        title: Row(
                          children: [
                            Flexible(
                              child: Text(
                                item['title']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item['category']!,
                                style: const TextStyle(
                                  color: Colors.tealAccent,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            item['content']!,
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.copy, color: Colors.tealAccent),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Copied: ${item['title']}'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () {
                                setState(() {
                                  _vaultItems.removeAt(index);
                                });
                              },
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
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SCREEN 3: Interactive Floating Decision Engine & Micro Choice Spinner
// -----------------------------------------------------------------------------
class DecisionEngineScreen extends StatefulWidget {
  const DecisionEngineScreen({super.key});

  @override
  State<DecisionEngineScreen> createState() => _DecisionEngineScreenState();
}

class _DecisionEngineScreenState extends State<DecisionEngineScreen> {
  final List<String> _choices = ['Option A', 'Option B', 'Option C'];
  final TextEditingController _choiceInput = TextEditingController();
  String _selectedResult = '';

  void _spinChoice() {
    if (_choices.isNotEmpty) {
      setState(() {
        final list = List<String>.from(_choices)..shuffle();
        _selectedResult = list.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Micro Decision Engine',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Solve Daily Choice Paralysis',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Add options below or use standard templates when stuck on micro decisions.',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _choiceInput,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Add Custom Choice',
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.all(16),
                    ),
                    onPressed: () {
                      if (_choiceInput.text.trim().isNotEmpty) {
                        setState(() {
                          _choices.add(_choiceInput.text.trim());
                          _choiceInput.clear();
                        });
                      }
                    },
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Active Wheel Choices:',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _choices.map((choice) {
                  return Chip(
                    backgroundColor: const Color(0xFF1E293B),
                    label: Text(choice, style: const TextStyle(color: Colors.white)),
                    deleteIcon: const Icon(Icons.cancel, size: 18, color: Colors.grey),
                    onDeleted: () {
                      setState(() {
                        _choices.remove(choice);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _spinChoice,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.purple.shade600, Colors.indigo.shade600],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.4),
                              blurRadius: 16,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.touch_app, size: 40, color: Colors.white),
                            SizedBox(height: 4),
                            Text(
                              'TAP TO SPIN',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_selectedResult.isNotEmpty) ...[
                      const Text(
                        'DECISION RESULT:',
                        style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.tealAccent),
                        ),
                        child: Text(
                          _selectedResult,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SCREEN 4: Settings & Permissions Companion Dashboard
// -----------------------------------------------------------------------------
class SettingsPermissionScreen extends StatefulWidget {
  const SettingsPermissionScreen({super.key});

  @override
  State<SettingsPermissionScreen> createState() => _SettingsPermissionScreenState();
}

class _SettingsPermissionScreenState extends State<SettingsPermissionScreen> {
  bool _displayOverOtherApps = true;
  bool _backgroundService = true;
  bool _quickClipboardListen = true;
  bool _hapticFeedback = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Overlay & Permissions',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'System Integration Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'OverlayGenius relies on system permissions to stay visible while you browse social media, play games, or view bank apps.',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 20),
              _buildSettingTile(
                title: 'Display Over Other Apps',
                subtitle: 'Required to draw floating micro bubbles over external apps',
                value: _displayOverOtherApps,
                onChanged: (val) => setState(() => _displayOverOtherApps = val),
              ),
              const Divider(color: Colors.white70),
              _buildSettingTile(
                title: 'Persistent Background Companion',
                subtitle: 'Keeps HUD bubbles ready without getting cleared by OS',
                value: _backgroundService,
                onChanged: (val) => setState(() => _backgroundService = val),
              ),
              const Divider(color: Colors.white70),
              _buildSettingTile(
                title: 'Smart Clipboard Auto-Catch',
                subtitle: 'Detects copied text and offers instant floating snippet save',
                value: _quickClipboardListen,
                onChanged: (val) => setState(() => _quickClipboardListen = val),
              ),
              const Divider(color: Colors.white70),
              _buildSettingTile(
                title: 'Bubble Haptic Vibration',
                subtitle: 'Vibrate when dragging or snapping floating windows to edge',
                value: _hapticFeedback,
                onChanged: (val) => setState(() => _hapticFeedback = val),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.teal.shade700),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.shield_outlined, color: Colors.tealAccent),
                        SizedBox(width: 10),
                        Text(
                          'Privacy & Battery Friendly',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'All your snippet data and sticky notes remain 100% offline on your device storage. No cloud tracking or background data usage.',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
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
}