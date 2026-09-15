import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const OverlayPulseApp());
}

class OverlayPulseApp extends StatefulWidget {
  const OverlayPulseApp({super.key});

  @override
  State<OverlayPulseApp> createState() => _OverlayPulseAppState();
}

class _OverlayPulseAppState extends State<OverlayPulseApp> {
  bool _isDarkMode = true;
  Color _themeColor = Colors.teal;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _changeThemeColor(Color color) {
    setState(() {
      _themeColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlayPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: _themeColor,
        scaffoldBackgroundColor: _isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: _themeColor,
          brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        ),
      ),
      home: MainStudioScreen(
        isDarkMode: _isDarkMode,
        themeColor: _themeColor,
        onToggleTheme: _toggleTheme,
        onChangeColor: _changeThemeColor,
      ),
    );
  }
}

class MainStudioScreen extends StatefulWidget {
  final bool isDarkMode;
  final Color themeColor;
  final VoidCallback onToggleTheme;
  final ValueChanged<Color> onChangeColor;

  const MainStudioScreen({
    super.key,
    required this.isDarkMode,
    required this.themeColor,
    required this.onToggleTheme,
    required this.onChangeColor,
  });

  @override
  State<MainStudioScreen> createState() => _MainStudioScreenState();
}

class _MainStudioScreenState extends State<MainStudioScreen> {
  int _selectedIndex = 0;

  // Floating Overlay Bubble Position Simulation
  Offset _bubblePosition = const Offset(20, 200);
  bool _isOverlayActive = true;
  bool _isBubbleExpanded = false;
  bool _displayPermissionGranted = true;
  bool _notificationPermissionGranted = true;

  // Real-time app usage dynamic ticker (keeps user engaged)
  int _activeSeconds = 142;
  late Timer _usageTimer;

  // Floating Sticky Notes
  final List<String> _floatingNotes = [
    '🛒 Target price comparison: \$24.99 vs \$19.99',
    '💬 Quick reply: "I will check and reply shortly!"',
    '🔑 Promo Code: DISCOUNT20',
  ];
  final TextEditingController _noteController = TextEditingController();

  // Smart Micro-Decision Tool Data
  final TextEditingController _priceOriginalController = TextEditingController(text: '120.00');
  final TextEditingController _priceDiscountController = TextEditingController(text: '25');
  double _calculatedFinalPrice = 90.00;
  double _calculatedSaved = 30.00;

  // Quick Decision Wheel
  final List<String> _decisionItems = ['Buy Now', 'Wait 24 Hours', 'Find Discount', 'Skip'];
  String _decisionResult = 'Tap to Pick!';

  // Notification Banner Simulator Trigger
  String? _activeBannerMessage;

  @override
  void initState() {
    super.initState();
    _usageTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _activeSeconds++;
        });
      }
    });
  }

  @override
  void dispose() {
    _usageTimer.cancel();
    _noteController.dispose();
    _priceOriginalController.dispose();
    _priceDiscountController.dispose();
    super.dispose();
  }

  void _calculateDiscount() {
    double orig = double.tryParse(_priceOriginalController.text) ?? 0.0;
    double disc = double.tryParse(_priceDiscountController.text) ?? 0.0;
    setState(() {
      _calculatedSaved = orig * (disc / 100.0);
      _calculatedFinalPrice = orig - _calculatedSaved;
    });
  }

  void _pickRandomDecision() {
    _decisionItems.shuffle();
    setState(() {
      _decisionResult = _decisionItems.first;
    });
    _triggerNotification('Smart Decision Picked: $_decisionResult');
  }

  void _triggerNotification(String message) {
    setState(() {
      _activeBannerMessage = message;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _activeBannerMessage = null;
        });
      }
    });
  }

  void _addNote() {
    if (_noteController.text.trim().isNotEmpty) {
      setState(() {
        _floatingNotes.insert(0, _noteController.text.trim());
        _noteController.clear();
      });
      _triggerNotification('New floating sticky note pinned!');
    }
  }

  String _formatTime(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.layers, color: Colors.teal),
            SizedBox(width: 8),
            Text('OverlayPulse Studio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: const Icon(Icons.bolt, color: Colors.amber),
            onPressed: () {
              _triggerNotification('Overlay Assistant Active & Listening');
            },
            tooltip: 'Ping Floating HUD',
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Tab Content
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 90.0, left: 16.0, right: 16.0, top: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Dynamic Usage Status Card
                  _buildUsageHeaderCard(),
                  const SizedBox(height: 16),

                  // Dynamic Body according to Tab Index
                  if (_selectedIndex == 0) _buildFloatingStudioTab(),
                  if (_selectedIndex == 1) _buildMicroDecisionToolsTab(),
                  if (_selectedIndex == 2) _buildStickyNotesTab(),
                  if (_selectedIndex == 3) _buildSettingsAndPermissionsTab(),
                ],
              ),
            ),

            // Top Floating Notification Banner Simulator
            if (_activeBannerMessage != null)
              Positioned(
                top: 10,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.indigo,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_active, color: Colors.amber),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _activeBannerMessage!,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70, size: 18),
                          onPressed: () {
                            setState(() {
                              _activeBannerMessage = null;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

            // Interactive Simulated Floating Overlay Bubble (Draggable over app UI)
            if (_isOverlayActive)
              Positioned(
                left: _bubblePosition.dx,
                top: _bubblePosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _bubblePosition += details.delta;
                    });
                  },
                  onTap: () {
                    setState(() {
                      _isBubbleExpanded = !_isBubbleExpanded;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.all(_isBubbleExpanded ? 12 : 8),
                    decoration: BoxDecoration(
                      color: widget.themeColor,
                      shape: _isBubbleExpanded ? BoxShape.rectangle : BoxShape.circle,
                      borderRadius: _isBubbleExpanded ? BorderRadius.circular(20) : null,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black87,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _isBubbleExpanded
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.widgets, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Floating HUD',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isBubbleExpanded = false;
                                      });
                                    },
                                    child: const Icon(Icons.close, color: Colors.white70, size: 16),
                                  )
                                ],
                              ),
                              const Divider(color: Colors.white70, height: 12),
                              Wrap(
                                spacing: 8,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.calculate, color: Colors.white, size: 20),
                                    onPressed: () {
                                      _triggerNotification('Quick Deal Helper Activated');
                                    },
                                    tooltip: 'Discount Calc',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.content_copy, color: Colors.white, size: 20),
                                    onPressed: () {
                                      _triggerNotification('Copied top note to clipboard');
                                    },
                                    tooltip: 'Copy Top Clip',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.touch_app, color: Colors.white, size: 20),
                                    onPressed: _pickRandomDecision,
                                    tooltip: 'Quick Pick',
                                  ),
                                ],
                              )
                            ],
                          )
                        : const Icon(Icons.flash_on, color: Colors.white, size: 28),
                  ),
                ),
              ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_customize),
            label: 'Overlay Studio',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Micro Tools',
          ),
          NavigationDestination(
            icon: Icon(Icons.sticky_note_2),
            label: 'Floating Notes',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune),
            label: 'Controls',
          ),
        ],
      ),
    );
  }

  // 1. Top Usage & Engagement Header
  Widget _buildUsageHeaderCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.themeColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.speed, color: widget.themeColor, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Active Assistant Runtime',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    _formatTime(_activeSeconds),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Switch(
              value: _isOverlayActive,
              activeColor: widget.themeColor,
              onChanged: (val) {
                setState(() {
                  _isOverlayActive = val;
                });
                _triggerNotification(val ? 'Floating Overlay Enabled!' : 'Floating Overlay Hidden');
              },
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: Floating Overlay Customization & Live Studio
  Widget _buildFloatingStudioTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Floating Widget Customizer',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text(
          'Drag the floating flash icon anywhere on your screen. Tap it to expand micro-actions over any app.',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 16),

        // Color Picker Grid
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.color_lens, size: 20, color: Colors.teal),
                    SizedBox(width: 8),
                    Text('Overlay Accent Theme', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    _colorChip(Colors.teal),
                    _colorChip(Colors.blue),
                    _colorChip(Colors.purple),
                    _colorChip(Colors.orange),
                    _colorChip(Colors.indigo),
                    _colorChip(Colors.red),
                    _colorChip(Colors.green),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Quick Controls Grid
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.open_in_new, color: Colors.blue),
                title: const Text('Display Above Other Apps Permission'),
                subtitle: Text(_displayPermissionGranted ? 'Active & Running' : 'Permission Required'),
                trailing: Icon(
                  _displayPermissionGranted ? Icons.check_circle : Icons.warning,
                  color: _displayPermissionGranted ? Colors.green : Colors.orange,
                ),
                onTap: () {
                  setState(() {
                    _displayPermissionGranted = !_displayPermissionGranted;
                  });
                  _triggerNotification('System Floating Permission Toggled');
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.notifications_active, color: Colors.amber),
                title: const Text('Floating Sticky Controller Notification'),
                subtitle: Text(_notificationPermissionGranted ? 'Active in notification bar' : 'Disabled'),
                trailing: Icon(
                  _notificationPermissionGranted ? Icons.check_circle : Icons.circle_outlined,
                  color: _notificationPermissionGranted ? Colors.green : Colors.grey,
                ),
                onTap: () {
                  setState(() {
                    _notificationPermissionGranted = !_notificationPermissionGranted;
                  });
                  _triggerNotification('Notification HUD updated');
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // AdMob Placeholder Banner Container (For high user retention & ad revenue)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: const Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.monetization_on, size: 16, color: Colors.grey),
                  SizedBox(width: 6),
                  Text(
                    'SPONSORED SMART TOOL BANNER',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'Get 50% discount on context tools with Pro Unlock',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _colorChip(Color color) {
    bool isSelected = widget.themeColor.value == color.value;
    return GestureDetector(
      onTap: () => widget.onChangeColor(color),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: isSelected
              ? [const BoxShadow(color: Colors.black87, blurRadius: 6)]
              : null,
        ),
        child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
      ),
    );
  }

  // TAB 2: Micro Decision & Price/Discount Comparison Workspace
  Widget _buildMicroDecisionToolsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Micro-Decision Studio',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'Quick decision helpers to solve everyday micro-paralysis while shopping or browsing.',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 16),

        // Live Deal & Discount Calculator
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.calculate, color: Colors.teal),
                    SizedBox(width: 8),
                    Text('Instant Discount & Savings Helper', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _priceOriginalController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Price (\$) =',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => _calculateDiscount(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _priceDiscountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Discount %',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => _calculateDiscount(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.themeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Final Price', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(
                            '\$${_calculatedFinalPrice.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: widget.themeColor),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('You Save', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(
                            '\$${_calculatedSaved.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Decision Picker Wheel Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.touch_app, color: Colors.amber),
                    SizedBox(width: 8),
                    Text('Shopping & Choice Randomizer', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.amber, width: 1.5),
                        ),
                        child: Text(
                          _decisionResult,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _pickRandomDecision,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Pick Random Action'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.themeColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  // TAB 3: Floating Sticky Notes & Clipboard Stack
  Widget _buildStickyNotesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Floating Sticky Notes Stack',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'Pin quick texts, promo codes, or chat templates to access them over any active application.',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  hintText: 'Type text or promo code to pin...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _addNote,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(backgroundColor: widget.themeColor),
            )
          ],
        ),
        const SizedBox(height: 16),

        if (_floatingNotes.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(
              child: Text('No floating sticky notes. Pin one above!', style: TextStyle(color: Colors.grey)),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _floatingNotes.length,
            itemBuilder: (context, index) {
              final note = _floatingNotes[index];
              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.push_pin, color: Colors.teal, size: 20),
                  title: Text(note, style: const TextStyle(fontSize: 14)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.content_copy, size: 18),
                        onPressed: () {
                          _triggerNotification('Copied to clipboard!');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _floatingNotes.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  // TAB 4: Controls & Permissions
  Widget _buildSettingsAndPermissionsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'System & Overlay Controls',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'Configure permissions, float sensitivity, and active background runtime.',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 16),

        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Display Above Other Apps'),
                subtitle: const Text('Allows overlay tools to appear on top of WhatsApp, Chrome, etc.'),
                value: _displayPermissionGranted,
                activeColor: widget.themeColor,
                onChanged: (val) {
                  setState(() {
                    _displayPermissionGranted = val;
                  });
                },
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Persistent Notification Panel'),
                subtitle: const Text('Keep quick action notification controls in status bar.'),
                value: _notificationPermissionGranted,
                activeColor: widget.themeColor,
                onChanged: (val) {
                  setState(() {
                    _notificationPermissionGranted = val;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('About OverlayPulse', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'OverlayPulse version 1.0.4 - Designed for power users who multi-task across shopping, social media, and messaging apps.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    _triggerNotification('Simulating App Store Rating Prompt...');
                  },
                  icon: const Icon(Icons.star, color: Colors.amber),
                  label: const Text('Rate OverlayPulse 5-Stars'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 42),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}