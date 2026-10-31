import 'package:flutter/material.dart';

void main() {
  runApp(const OverlayHUDApp());
}

class OverlayHUDApp extends StatelessWidget {
  const OverlayHUDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlayHUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyan,
          secondary: Colors.teal,
          surface: Color(0xFF1E293B),
          background: Color(0xFF0F172A),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1E293B),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const MainHUDDeskScreen(),
    );
  }
}

class MainHUDDeskScreen extends StatefulWidget {
  const MainHUDDeskScreen({super.key});

  @override
  State<MainHUDDeskScreen> createState() => _MainHUDDeskScreenState();
}

class _MainHUDDeskScreenState extends State<MainHUDDeskScreen> {
  int _currentIndex = 0;

  // Floating Overlay States
  bool _overlayEnabled = true;
  bool _floatingBubbleActive = true;
  bool _dynamicBarActive = true;
  bool _notificationAlertsEnabled = true;

  // Dummy Clipboard / Context History
  final List<String> _clipboardHistory = [
    'https://example.com/product?ref=12345&utm_source=ad&tracker=999',
    'Meeting notes: Call client at +1 555 0192 regarding project launch.',
    'Total budget constraint: \$1,250.00 split across 4 team members.',
  ];

  // Floating Notes State
  final List<String> _quickNotes = [
    'Check store discount codes',
    'Verify app permissions status',
  ];
  final TextEditingController _noteInputController = TextEditingController();

  // Micro Calculator State
  double _calcVal1 = 120.0;
  double _taxPercent = 15.0;
  double _splitPeople = 3.0;

  // Dynamic Island simulation message
  String _activeHUDMessage = 'System Ready • Floating Desk Active';

  @override
  void dispose() {
    _noteInputController.dispose();
    super.dispose();
  }

  void _addQuickNote() {
    if (_noteInputController.text.trim().isNotEmpty) {
      setState(() {
        _quickNotes.add(_noteInputController.text.trim());
        _noteInputController.clear();
        _activeHUDMessage = 'New quick note pinned to Floating Desk!';
      });
    }
  }

  void _cleanAndAddClipboard(String text) {
    // Basic URL cleaning logic if it starts with http
    String processed = text;
    if (text.contains('http') && text.contains('?')) {
      processed = text.split('?')[0];
    }
    setState(() {
      _clipboardHistory.insert(0, processed);
      _activeHUDMessage = 'Clipboard text formatted and pinned!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content Area based on selected Tab
            Column(
              children: [
                // Persistent Dynamic HUD Bar top banner
                if (_dynamicBarActive) _buildTopDynamicHUDBar(),

                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      _buildFloatingOverlayHubTab(),
                      _buildClipboardContextTab(),
                      _buildMicroDeskToolsTab(),
                      _buildPermissionsSettingsTab(),
                    ],
                  ),
                ),
              ],
            ),

            // Simulated Floating Overlay Head (Can be dragged or tapped)
            if (_overlayEnabled && _floatingBubbleActive)
              Positioned(
                right: 16,
                bottom: 90,
                child: Draggable(
                  feedback: _buildFloatingHeadWidget(isDragging: true),
                  childWhenDragging: const SizedBox.shrink(),
                  child: _buildFloatingHeadWidget(isDragging: false),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0F172A),
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Overlay Hub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.copy),
            label: 'Clipboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Micro-Desk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Controls',
          ),
        ],
      ),
    );
  }

  // --- Dynamic HUD Bar Simulation Widget ---
  Widget _buildTopDynamicHUDBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.cyan.withOpacity(0.4), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.cyan,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.stars, color: Colors.black, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _activeHUDMessage,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              setState(() {
                _activeHUDMessage = 'Dynamic HUD refreshed at ${TimeOfDay.now().format(context)}';
              });
            },
            child: const Icon(Icons.refresh, color: Colors.cyan, size: 20),
          ),
        ],
      ),
    );
  }

  // --- Interactive Floating Head Widget ---
  Widget _buildFloatingHeadWidget({required bool isDragging}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: const Color(0xFF1E293B),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (context) => _buildFloatingQuickActionSheet(),
          );
        },
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isDragging ? Colors.teal : Colors.cyan,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.cyan.withOpacity(0.5),
                blurRadius: 12,
                spreadRadius: 2,
              )
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.dashboard,
              color: Colors.black,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  // --- Quick Action Modal Bottom Sheet ---
  Widget _buildFloatingQuickActionSheet() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: const [
                Icon(Icons.widgets, color: Colors.cyan),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Floating Desk Quick Tray',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 0, height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.note_add, size: 18, color: Colors.cyan),
                  label: const Text('Add Quick Note'),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => _currentIndex = 2);
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.cleaning_services, size: 18, color: Colors.cyan),
                  label: const Text('Clean URL Link'),
                  onPressed: () {
                    Navigator.pop(context);
                    _cleanAndAddClipboard('https://example.org/item?track=abc&source=viral');
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.calculate, size: 18, color: Colors.cyan),
                  label: const Text('Quick Split Calc'),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => _currentIndex = 2);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Active Context Notes:',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ..._quickNotes.map((note) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.teal, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          note,
                          style: const TextStyle(color: Colors.white),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // ================= TAB 1: FLOATING OVERLAY HUB =================
  Widget _buildFloatingOverlayHubTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating HUD & Active Overlays',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            softWrap: true,
          ),
          const SizedBox(height: 4),
          const Text(
            'Keep essential micro-tools active over your screen without app context switching.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          // Main Master Toggle Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.cyan.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.layers, color: Colors.cyan, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Master Floating Mode',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              softWrap: true,
                            ),
                            Text(
                              'Draw interactive HUD elements',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _overlayEnabled,
                        onChanged: (val) {
                          setState(() {
                            _overlayEnabled = val;
                            _activeHUDMessage = val
                                ? 'Floating Master HUD Enabled'
                                : 'Floating Master HUD Disabled';
                          });
                        },
                        activeColor: Colors.cyan,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Active Floating Mini-Widgets',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          // Toggles Grid / Column
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Floating Bubble Action Head'),
                  subtitle: const Text('Draggable quick action shortcut on screen edge'),
                  value: _floatingBubbleActive,
                  onChanged: _overlayEnabled
                      ? (val) => setState(() => _floatingBubbleActive = val)
                      : null,
                  activeColor: Colors.cyan,
                  secondary: const Icon(Icons.bubble_chart, color: Colors.teal),
                ),
                const Divider(height: 1, color: Colors.grey),
                SwitchListTile(
                  title: const Text('Dynamic Top Notification Bar'),
                  subtitle: const Text('Real-time notification & status banner HUD'),
                  value: _dynamicBarActive,
                  onChanged: (val) => setState(() => _dynamicBarActive = val),
                  activeColor: Colors.cyan,
                  secondary: const Icon(Icons.notifications_active, color: Colors.amber),
                ),
                const Divider(height: 1, color: Colors.grey),
                SwitchListTile(
                  title: const Text('Notification Smart Alerts'),
                  subtitle: const Text('Instant alert popups for copied links and notes'),
                  value: _notificationAlertsEnabled,
                  onChanged: (val) => setState(() => _notificationAlertsEnabled = val),
                  activeColor: Colors.cyan,
                  secondary: const Icon(Icons.add_alert, color: Colors.cyan),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Live Quick Context Action Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.cyan.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.bolt, color: Colors.amber),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Instant Micro Action Test',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Trigger a simulated system overlay alert to test real-time HUD reactivity.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                  softWrap: true,
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _activeHUDMessage =
                              'Live HUD Test Triggered at ${TimeOfDay.now().format(context)}';
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Simulated Dynamic HUD Banner updated!'),
                            backgroundColor: Colors.teal,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow, size: 18),
                      label: const Text('Test HUD Alert'),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.cyan,
                        side: const BorderSide(color: Colors.cyan),
                      ),
                      onPressed: () {
                        _cleanAndAddClipboard(
                            'https://store.example.com/item/88?referral=user99&campaign=spring');
                      },
                      icon: const Icon(Icons.cleaning_services, size: 18),
                      label: const Text('Simulate URL Clean'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= TAB 2: SMART CLIPBOARD & CONTEXT MANAGER =================
  Widget _buildClipboardContextTab() {
    final TextEditingController inputController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Clipboard Context',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            softWrap: true,
          ),
          const SizedBox(height: 4),
          const Text(
            'Auto-format snippets, strip tracking code from URLs, and extract quick values.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          // Add New Snippet Box
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  TextField(
                    controller: inputController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'Paste messy URL, notes, or text here...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          if (inputController.text.isNotEmpty) {
                            _cleanAndAddClipboard(inputController.text);
                            inputController.clear();
                          }
                        },
                        icon: const Icon(Icons.cleaning_services, color: Colors.cyan),
                        label: const Text(
                          'Clean & Store',
                          style: TextStyle(color: Colors.cyan),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Saved Context History',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  softWrap: true,
                ),
              ),
              if (_clipboardHistory.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_sweep, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _clipboardHistory.clear();
                      _activeHUDMessage = 'Clipboard history cleared';
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 8),

          if (_clipboardHistory.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'No context items stored yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _clipboardHistory.length,
              itemBuilder: (context, index) {
                final item = _clipboardHistory[index];
                final bool isUrl = item.startsWith('http');

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isUrl ? Icons.link : Icons.short_text,
                              color: isUrl ? Colors.cyan : Colors.teal,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                isUrl ? 'Clean Link' : 'Text Snippet',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 18, color: Colors.white70),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Copied to system clipboard!'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Text(
                          item,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          softWrap: true,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            Chip(
                              padding: EdgeInsets.zero,
                              labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                              backgroundColor: Colors.black87,
                              label: Text(
                                '${item.length} chars',
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ),
                            if (isUrl)
                              Chip(
                                padding: EdgeInsets.zero,
                                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                                backgroundColor: Colors.teal.withOpacity(0.2),
                                label: const Text(
                                  'Cleaned Tracker',
                                  style: TextStyle(fontSize: 11, color: Colors.teal),
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ================= TAB 3: MICRO-DESK PRODUCTIVITY TOOLS =================
  Widget _buildMicroDeskToolsTab() {
    // Math logic calculation
    final double taxAmount = _calcVal1 * (_taxPercent / 100.0);
    final double totalWithTax = _calcVal1 + taxAmount;
    final double perPerson = _splitPeople > 0 ? totalWithTax / _splitPeople : totalWithTax;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Desk Utility Kit',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            softWrap: true,
          ),
          const SizedBox(height: 4),
          const Text(
            'Fast persistent scratchpad notes and instant price/tax splitter for daily micro-decisions.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          // Persistent Quick Notes Box
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.edit_note, color: Colors.cyan),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Floating Scratchpad Notes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _noteInputController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Type micro note...',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          foregroundColor: Colors.black,
                        ),
                        icon: const Icon(Icons.add),
                        onPressed: _addQuickNote,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_quickNotes.isEmpty)
                    const Text(
                      'No floating notes pinned.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    )
                  else
                    Column(
                      children: _quickNotes.asMap().entries.map((entry) {
                        final int idx = entry.key;
                        final String noteText = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.push_pin, color: Colors.teal, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  noteText,
                                  style: const TextStyle(color: Colors.white),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _quickNotes.removeAt(idx);
                                  });
                                },
                                child: const Icon(Icons.close, color: Colors.grey, size: 18),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Quick Price & Split Tax Micro Calculator
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.monetization_on, color: Colors.teal),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Quick Tax & Split Calculator',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Base Amount Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Base Amount:', style: TextStyle(color: Colors.grey)),
                      Text(
                        '\$${_calcVal1.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.cyan,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _calcVal1,
                    min: 0,
                    max: 500,
                    divisions: 100,
                    activeColor: Colors.cyan,
                    onChanged: (val) => setState(() => _calcVal1 = val),
                  ),

                  // Tax Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tax Rate:', style: TextStyle(color: Colors.grey)),
                      Text(
                        '${_taxPercent.toInt()}%',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _taxPercent,
                    min: 0,
                    max: 30,
                    divisions: 30,
                    activeColor: Colors.amber,
                    onChanged: (val) => setState(() => _taxPercent = val),
                  ),

                  // Split Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Split People:', style: TextStyle(color: Colors.grey)),
                      Text(
                        '${_splitPeople.toInt()} person(s)',
                        style: const TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _splitPeople,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    activeColor: Colors.teal,
                    onChanged: (val) => setState(() => _splitPeople = val),
                  ),

                  const Divider(color: Colors.grey),
                  const SizedBox(height: 8),

                  // Result Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total + Tax',
                                style: TextStyle(color: Colors.grey, fontSize: 11),
                              ),
                              const SizedBox(height: 4),
                              FittedBox(
                                child: Text(
                                  '\$${totalWithTax.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.cyan.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.cyan.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Per Person',
                                style: TextStyle(color: Colors.cyan, fontSize: 11),
                              ),
                              const SizedBox(height: 4),
                              FittedBox(
                                child: Text(
                                  '\$${perPerson.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.cyan,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= TAB 4: PERMISSIONS & SYSTEM CONTROLS =================
  Widget _buildPermissionsSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System & Overlay Controls',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            softWrap: true,
          ),
          const SizedBox(height: 4),
          const Text(
            'Manage device overlay permissions and background HUD responsiveness settings.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          // Permission Cards
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.display_settings, color: Colors.cyan),
                  title: const Text('Display Over Other Apps'),
                  subtitle: const Text('Required to draw floating heads over screens'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'GRANTED',
                      style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Divider(height: 1, color: Colors.grey),
                ListTile(
                  leading: const Icon(Icons.notifications_active, color: Colors.teal),
                  title: const Text('Notification Access'),
                  subtitle: const Text('Allows live dynamic island updates on status bar'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'ACTIVE',
                      style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Divider(height: 1, color: Colors.grey),
                ListTile(
                  leading: const Icon(Icons.content_paste, color: Colors.amber),
                  title: const Text('Clipboard Auto-Read'),
                  subtitle: const Text('Detect copied links automatically'),
                  trailing: Switch(
                    value: true,
                    onChanged: (val) {},
                    activeColor: Colors.cyan,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Info / Help Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.info_outline, color: Colors.cyan),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Why OverlayHUD keeps users engaged',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'By combining floating screen widgets, live link formatters, and scratchpad micro-calculators into one lightweight utility, users return to the app constantly throughout the day to interact with their persistent workspace.',
                  style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}