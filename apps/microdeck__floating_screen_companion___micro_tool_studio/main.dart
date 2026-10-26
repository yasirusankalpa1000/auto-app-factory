import 'package:flutter/material.dart';

void main() {
  runApp(const MicroDeckApp());
}

class MicroDeckApp extends StatelessWidget {
  const MicroDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MicroDeck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFAFAFAF),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
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
  bool _overlayEnabled = true;
  bool _notificationAccess = true;
  
  // Floating bubble dynamic position
  double _bubbleX = 20.0;
  double _bubbleY = 180.0;
  bool _isDockOpen = false;

  // Clipboard & Micro Tools Data
  final List<Map<String, String>> _clipboardStash = [
    {
      'id': '1',
      'text': 'Check out this product price: \$49.99 with 20% discount coupon code OFF20',
      'tag': 'Shopping',
      'type': 'price',
      'time': '10 mins ago'
    },
    {
      'id': '2',
      'text': '+18005550199 - Customer Support Hotline for immediate delivery inquiry',
      'tag': 'Contact',
      'type': 'phone',
      'time': '32 mins ago'
    },
    {
      'id': '3',
      'text': 'Meeting notes: Send updated budget proposals before 5 PM today.',
      'tag': 'Work',
      'type': 'note',
      'time': '2 hours ago'
    },
  ];

  final TextEditing`Controller _clipInputController = TextEditingController();
  final TextEditingController _whatsappPhoneController = TextEditingController();
  final TextEditingController _whatsappMessageController = TextEditingController();

  // Calculator State
  double _billAmount = 85.00;
  double _discountPercent = 15.0;
  double _tipPercent = 10.0;
  int _splitPeople = 3;

  // Micro Decision Wheel Options
  final List<String> _decisionOptions = [
    'Order Pizza 🍕',
    'Cook at Home 🥗',
    'Go for a Walk 🚶',
    'Read a Book 📖',
    'Watch Movie 🎬',
    'Power Nap 💤'
  ];
  String _selectedDecision = 'Tap spin to decide!';

  @override
  void dispose() {
    _clipInputController.dispose();
    _whatsappPhoneController.dispose();
    _whatsappMessageController.dispose();
    super.dispose();
  }

  void _addNewClip(String text, String tag) {
    if (text.trim().isEmpty) return;
    String type = 'general';
    if (text.contains(RegExp(r'\+?[0-9]{8,15}'))) {
      type = 'phone';
    } else if (text.contains('\$') || text.toLowerCase().contains('off') || text.contains('%')) {
      type = 'price';
    }

    setState(() {
      _clipboardStash.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'text': text,
        'tag': tag,
        'type': type,
        'time': 'Just now',
      });
      _clipInputController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saved to Floating Clipboard Stash!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteClip(String id) {
    setState(() {
      _clipboardStash.removeWhere((item) => item['id'] == id);
    });
  }

  void _spinDecisionWheel() {
    setState(() {
      _selectedDecision = (_decisionOptions..shuffle()).first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.widgets,
                color: theme.colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'MicroDeck',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _overlayEnabled ? Icons.layers : Icons.layers_clear,
              color: _overlayEnabled ? Colors.green : Colors.grey,
            ),
            tooltip: 'Toggle Overlay Service',
            onPressed: () {
              setState(() {
                _overlayEnabled = !_overlayEnabled;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _overlayEnabled
                        ? 'Floating Overlay Companion Activated'
                        : 'Floating Overlay Deactivated',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.security),
            tooltip: 'Permissions & Settings',
            onPressed: () => _showPermissionDialog(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main App Navigation Pages wrapped safely
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildDashboardTab(theme),
                _buildClipboardStashTab(theme),
                _buildMicroToolsTab(theme),
                _buildDecisionHubTab(theme),
              ],
            ),
          ),

          // SIMULATED FLOATING SCREEN COMPANION OVERLAY (DISPLAY OVER APPS)
          if (_overlayEnabled)
            Positioned(
              left: _bubbleX,
              top: _bubbleY,
              child: GestureDetectingOverlayBubble(
                isOpen: _isDockOpen,
                onTapBubble: () {
                  setState(() {
                    _isDockOpen = !_isDockOpen;
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    _bubbleX += details.delta.dx;
                    _bubbleY += details.delta.dy;
                    // Clamp screen limits
                    final size = MediaQuery.of(context).size;
                    _bubbleX = _bubbleX.clamp(10.0, size.width - 70.0);
                    _bubbleY = _bubbleY.clamp(50.0, size.height - 180.0);
                  });
                },
                onQuickAction: (action) {
                  setState(() {
                    _isDockOpen = false;
                  });
                  _handleFloatingQuickAction(action);
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Companion',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_paste_outlined),
            selectedIcon: Icon(Icons.content_paste),
            label: 'Clip Stash',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Micro Tools',
          ),
          NavigationDestination(
            icon: Icon(Icons.touch_app_outlined),
            selectedIcon: Icon(Icons.touch_app),
            label: 'Decider',
          ),
        ],
      ),
    );
  }

  // Handle actions triggered directly from the Floating Screen Overlay Dock
  void _handleFloatingQuickAction(String action) {
    if (action == 'calc') {
      setState(() => _currentIndex = 2);
    } else if (action == 'clip') {
      setState(() => _currentIndex = 1);
    } else if (action == 'whatsapp') {
      _showDirectWhatsAppModal(context);
    } else if (action == 'decide') {
      setState(() => _currentIndex = 3);
    }
  }

  // 1. DASHBOARD TAB
  Widget _buildDashboardTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Status Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.bolt,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Floating Overlay Active',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Screen Companion is live on your display',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _overlayEnabled,
                      activeColor: Colors.amber,
                      onChanged: (val) {
                        setState(() {
                          _overlayEnabled = val;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white70, height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Saved Clips', '${_clipboardStash.length}', Icons.copy),
                    _buildStatItem('Micro-Tools', '8 Ready', Icons.build),
                    _buildStatItem('Time Saved', '~45 mins', Icons.schedule),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            'Interactive Drag & Test Zone',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Drag the purple floating bubble anywhere on your screen. Tap it to expand context tools while browsing social feeds, shopping, or reading.',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Simulated Background Phone Screen Frame
          Container(
            height: 220,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.touch_app, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text(
                      'Simulated App Background',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text(
                        _isDockOpen ? 'Overlay Open' : 'Overlay Docked',
                        style: const TextStyle(fontSize: 11),
                      ),
                      backgroundColor: _isDockOpen
                          ? theme.colorScheme.primaryContainer
                          : theme.colorScheme.surface,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 12,
                              child: Icon(Icons.person, size: 14),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Sample Chat & Social Post',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '“Hey, please split the dinner bill. Total was \$85.00 for 3 people. Also call support at +18005550199!”',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Wrap(
                          spacing: 8,
                          children: [
                            ActionChip(
                              avatar: const Icon(Icons.calculate, size: 14),
                              label: const Text('Split Bill (\$85)', style: TextStyle(fontSize: 11)),
                              onPressed: () => setState(() => _currentIndex = 2),
                            ),
                            ActionChip(
                              avatar: const Icon(Icons.phone, size: 14),
                              label: const Text('Direct Call', style: TextStyle(fontSize: 11)),
                              onPressed: () {
                                _whatsappPhoneController.text = '+18005550199';
                                _showDirectWhatsAppModal(context);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            'Quick Utility Shortcuts',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildShortcutCard(
                theme,
                'Direct WhatsApp',
                'No contact saving',
                Icons.chat,
                Colors.green,
                () => _showDirectWhatsAppModal(context),
              ),
              _buildShortcutCard(
                theme,
                'Discount Calc',
                'Price & tips splitter',
                Icons.monetization_on,
                Colors.teal,
                () => setState(() => _currentIndex = 2),
              ),
              _buildShortcutCard(
                theme,
                'Clip Generator',
                'Extract text & links',
                Icons.content_paste,
                Colors.indigo,
                () => setState(() => _currentIndex = 1),
              ),
              _buildShortcutCard(
                theme,
                'Decision Wheel',
                'Fast micro choices',
                Icons.flare,
                Colors.deepOrange,
                () => setState(() => _currentIndex = 3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildShortcutCard(
    ThemeData theme,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. CLIPBOARD STASH TAB
  Widget _buildClipboardStashTab(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Smart Clip Stash',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Auto-categorized micro text, links & phone clips',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddClipDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Clip'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Clipboard input quick add
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                const Icon(Icons.content_paste_go, color: Colors.grey),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _clipInputController,
                    decoration: const InputDecoration(
                      hintText: 'Paste any text, price or phone number...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (text) => _addNewClip(text, 'Quick Clip'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: () => _addNewClip(_clipInputController.text, 'Quick Clip'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: _clipboardStash.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.content_paste_off, size: 64, color: theme.colorScheme.outline),
                        const SizedBox(height: 12),
                        const Text(
                          'No clips in stash yet!',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Copy text while using other apps to view them here.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _clipboardStash.length,
                    itemBuilder: (context, index) {
                      final item = _clipboardStash[index];
                      final isPhone = item['type'] == 'phone';
                      final isPrice = item['type'] == 'price';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: Border.all(
                            color: theme.colorScheme.outlineVariant.withOpacity(0.6),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Chip(
                                    visualDensity: VisualDensity.compact,
                                    avatar: Icon(
                                      isPhone
                                          ? Icons.phone
                                          : (isPrice ? Icons.monetization_on : Icons.bookmark),
                                      size: 14,
                                      color: theme.colorScheme.primary,
                                    ),
                                    label: Text(
                                      item['tag'] ?? 'Note',
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    item['time'] ?? '',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 18),
                                    onPressed: () => _deleteClip(item['id']!),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item['text'] ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),

                              // Instant Dynamic Context Action Chips
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  if (isPhone)
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        visualDensity: VisualDensity.compact,
                                        foregroundColor: Colors.green,
                                      ),
                                      icon: const Icon(Icons.chat, size: 14),
                                      label: const Text('WhatsApp Direct', style: TextStyle(fontSize: 11)),
                                      onPressed: () {
                                        _whatsappPhoneController.text = item['text']!;
                                        _showDirectWhatsAppModal(context);
                                      },
                                    ),
                                  if (isPrice)
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        visualDensity: VisualDensity.compact,
                                        foregroundColor: Colors.teal,
                                      ),
                                      icon: const Icon(Icons.calculate, size: 14),
                                      label: const Text('Calc Discount', style: TextStyle(fontSize: 11)),
                                      onPressed: () {
                                        setState(() {
                                          _currentIndex = 2;
                                        });
                                      },
                                    ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    icon: const Icon(Icons.copy, size: 14),
                                    label: const Text('Copy Text', style: TextStyle(fontSize: 11)),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Copied to system clipboard!'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.share, size: 18),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Preparing text share...'),
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
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // 3. MICRO TOOLS TAB (DISCOUNT & BILL SPLITTER + DIRECT WHATSAPP)
  Widget _buildMicroToolsTab(ThemeData theme) {
    final double discountAmount = _billAmount * (_discountPercent / 100);
    final double priceAfterDiscount = _billAmount - discountAmount;
    final double tipAmount = priceAfterDiscount * (_tipPercent / 100);
    final double totalFinal = priceAfterDiscount + tipAmount;
    final double perPerson = _splitPeople > 0 ? totalFinal / _splitPeople : totalFinal;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Micro-Calculator',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Instant discount, tip & split bill calculator over any app',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Result Summary Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Final Pay:'),
                    Text(
                      '\$${totalFinal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Per Person Share', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text(
                          '\$${perPerson.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('You Saved', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text(
                          '-\$${discountAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Bill Amount Input Slider
          Text(
            'Original Bill: \$${_billAmount.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Slider(
            value: _billAmount,
            min: 5.0,
            max: 500.0,
            divisions: 99,
            label: '\$${_billAmount.toStringAsFixed(2)}',
            onChanged: (val) {
              setState(() {
                _billAmount = val;
              });
            },
          ),

          // Discount Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discount Code: ${_discountPercent.round()}%',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                '-\$${discountAmount.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Slider(
            value: _discountPercent,
            min: 0.0,
            max: 75.0,
            divisions: 15,
            activeColor: Colors.teal,
            label: '${_discountPercent.round()}%',
            onChanged: (val) {
              setState(() {
                _discountPercent = val;
              });
            },
          ),

          // Tip & People Split
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tip: ${_tipPercent.round()}%', style: const TextStyle(fontWeight: FontWeight.w600)),
                    Slider(
                      value: _tipPercent,
                      min: 0.0,
                      max: 30.0,
                      divisions: 6,
                      onChanged: (val) => setState(() => _tipPercent = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Split between: $_splitPeople people', style: const TextStyle(fontWeight: FontWeight.w600)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: _splitPeople > 1
                              ? () => setState(() => _splitPeople--)
                              : null,
                        ),
                        Text(
                          '$_splitPeople',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => setState(() => _splitPeople++),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),

          // WhatsApp Direct Messaging Tool Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.green.withOpacity(0.08),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.chat, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'Direct WhatsApp Chat Launcher',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Chat directly with any number without saving them in phone contacts!',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.send),
                    label: const Text('Launch WhatsApp Direct Window'),
                    onPressed: () => _showDirectWhatsAppModal(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 4. MICRO DECISION HUB TAB (Engaging user retention feature)
  Widget _buildDecisionHubTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Daily Micro-Decision Helper',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Stuck making trivial micro-decisions? Let MicroDeck decide for you!',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Decision Display Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.tertiaryContainer, theme.colorScheme.primaryContainer],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.flare, size: 48, color: Colors.deepOrange),
                const SizedBox(height: 16),
                Text(
                  _selectedDecision,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    'SPIN & DECIDE NOW',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: _spinDecisionWheel,
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Current Decision Pool',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _decisionOptions.map((opt) {
              return Chip(
                label: Text(opt, style: const TextStyle(fontSize: 12)),
                backgroundColor: theme.colorScheme.surfaceVariant,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Floating Permission Status Settings Dialog
  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.security, color: Colors.deepPurple),
            SizedBox(width: 8),
            Text('Overlay & System Access'),
          ],
        ),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Display Over Apps', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('Draw floating companion over active apps', style: TextStyle(fontSize: 11)),
                  value: _overlayEnabled,
                  onChanged: (val) {
                    setDialogState(() => _overlayEnabled = val);
                    setState(() => _overlayEnabled = val);
                  },
                ),
                SwitchListTile(
                  title: const Text('Notification Companion', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('Capture copied snippets automatically', style: TextStyle(fontSize: 11)),
                  value: _notificationAccess,
                  onChanged: (val) {
                    setDialogState(() => _notificationAccess = val);
                    setState(() => _notificationAccess = val);
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Direct WhatsApp Modal Sheet
  void _showDirectWhatsAppModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.chat, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'WhatsApp Direct Launcher',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Enter phone number with country code (e.g., +18005550199)',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _whatsappPhoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _whatsappMessageController,
              decoration: const InputDecoration(
                labelText: 'Optional Quick Message',
                prefixIcon: Icon(Icons.message),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open Direct WhatsApp Chat'),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Opening WhatsApp chat for ${_whatsappPhoneController.text}...',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog to manually add clips
  void _showAddClipDialog(BuildContext context) {
    final TextEditingController dialogController = TextEditingController();
    String selectedTag = 'Shopping';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Custom Clip'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: dialogController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter text, link, code, or phone number...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            StatefulBuilder(
              builder: (context, setTagState) {
                return DropdownButton<String>(
                  value: selectedTag,
                  isExpanded: true,
                  items: ['Shopping', 'Contact', 'Work', 'Code', 'Reference']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setTagState(() => selectedTag = val);
                  },
                );
              },
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
              if (dialogController.text.isNotEmpty) {
                _addNewClip(dialogController.text, selectedTag);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save Clip'),
          ),
        ],
      ),
    );
  }
}

// DRAGGABLE INTERACTIVE FLOATING OVERLAY BUBBLE & DOCK WIDGET
class GestureDetectingOverlayBubble extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onTapBubble;
  final Function(DragUpdateDetails) onPanUpdate;
  final Function(String) onQuickAction;

  const GestureDetectingOverlayBubble({
    super.key,
    required this.isOpen,
    required this.onTapBubble,
    required this.onPanUpdate,
    required this.onQuickAction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onPanUpdate,
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Floating Bubble Circle
            InkWell(
              onTap: onTapBubble,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.deepPurple, Colors.indigo],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  isOpen ? Icons.close : Icons.widgets,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),

            // Floating Semi-transparent Quick Dock Drawer
            if (isOpen) ...[
              const SizedBox(height: 8),
              Container(
                width: 210,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black87,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.white70),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.bolt, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'MicroDeck Floating Tools',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: Colors.white70, height: 1),
                    const SizedBox(height: 8),

                    _buildDockItem(
                      Icons.chat,
                      'WhatsApp Direct',
                      Colors.green,
                      () => onQuickAction('whatsapp'),
                    ),
                    _buildDockItem(
                      Icons.calculate,
                      'Discount & Split Calc',
                      Colors.teal,
                      () => onQuickAction('calc'),
                    ),
                    _buildDockItem(
                      Icons.content_paste,
                      'Clipboard Stash',
                      Colors.lightBlue,
                      () => onQuickAction('clip'),
                    ),
                    _buildDockItem(
                      Icons.flare,
                      'Micro Decider',
                      Colors.orange,
                      () => onQuickAction('decide'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDockItem(
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}