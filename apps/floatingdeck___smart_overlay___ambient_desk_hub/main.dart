import 'package:flutter/material.dart';

void main() {
  runApp(const FloatingDeckApp());
}

class FloatingDeckApp extends StatelessWidget {
  const FloatingDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatingDeck',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF10131A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.amberAccent,
          surface: Color(0xFF1B1E29),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1B1E29),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
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

  // Floating Overlay Bubble Position
  Offset _bubblePosition = const Offset(20, 200);
  bool _isOverlayEnabled = true;
  bool _isBubbleExpanded = false;

  // Permission States
  bool _overlayPermission = true;
  bool _notificationPermission = true;

  // Clipboard & Sticky Data
  final List<String> _clipStack = [
    'Account Details: 8004-1928-3310 (Savings)',
    'Delivery Address: 42/B Lotus Road, Colombo 03',
    'Meeting Notes: Review Q3 product launch timeline with dev team.'
  ];

  final List<String> _pinnedNotes = [
    'Wi-Fi Code: Office_Guest_5G@2025',
    'Project ID: #FLUTTER-DECK-99'
  ];

  void _addClipItem(String text) {
    if (text.trim().isNotEmpty) {
      setState(() {
        _clipStack.insert(0, text);
      });
    }
  }

  void _addPinnedNote(String text) {
    if (text.trim().isNotEmpty) {
      setState(() {
        _pinnedNotes.insert(0, text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Screen Body
            IndexedStack(
              index: _currentIndex,
              children: [
                _buildOverlayHubTab(),
                _buildClipStackTab(),
                _buildDraftStudioTab(),
                _buildAmbientDeskTab(),
              ],
            ),

            // Simulated Draggable Floating Overlay Dock
            if (_isOverlayEnabled)
              Positioned(
                left: _bubblePosition.dx,
                top: _bubblePosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      double newX = _bubblePosition.dx + details.delta.dx;
                      double newY = _bubblePosition.dy + details.delta.dy;
                      // Clamp boundaries
                      newX = newX.clamp(10.0, mediaSize.width - 70.0);
                      newY = newY.clamp(10.0, mediaSize.height - 150.0);
                      _bubblePosition = Offset(newX, newY);
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    width: _isBubbleExpanded ? 240 : 60,
                    height: _isBubbleExpanded ? 220 : 60,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF262B3D).withOpacity(0.95),
                      borderRadius: BorderRadius.circular(_isBubbleExpanded ? 20 : 30),
                      border: Border.all(color: Colors.tealAccent, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.tealAccent.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: _isBubbleExpanded
                        ? _buildExpandedBubbleContent()
                        : _buildCollapsedBubbleContent(),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        backgroundColor: const Color(0xFF161922),
        indicatorColor: Colors.tealAccent.withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.layers_outlined),
            selectedIcon: Icon(Icons.layers, color: Colors.tealAccent),
            label: 'Overlay Dock',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_copy),
            selectedIcon: Icon(Icons.content_copy, color: Colors.tealAccent),
            label: 'Multi-Clip',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome, color: Colors.tealAccent),
            label: 'Tone Studio',
          ),
          NavigationDestination(
            icon: Icon(Icons.desktop_windows_outlined),
            selectedIcon: Icon(Icons.desktop_windows, color: Colors.amberAccent),
            label: 'Ambient Desk',
          ),
        ],
      ),
    );
  }

  // --- FLOATING BUBBLE INNER WIDGETS ---
  Widget _buildCollapsedBubbleContent() {
    return InkWell(
      onTap: () => setState(() => _isBubbleExpanded = true),
      child: const Center(
        child: Icon(
          Icons.dashboard,
          color: Colors.tealAccent,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildExpandedBubbleContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.flash_on, color: Colors.amberAccent, size: 18),
                  SizedBox(width: 4),
                  Text(
                    'Quick HUD',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => setState(() => _isBubbleExpanded = false),
                child: const Icon(Icons.close, color: Colors.grey, size: 18),
              )
            ],
          ),
          const Divider(color: Colors.white70, height: 12),
          const Text(
            'Latest Clip:',
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
          Text(
            _clipStack.isNotEmpty ? _clipStack.first : 'No items copied',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent.withOpacity(0.2),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Quick Stash Copied to Floating Bar!')),
                  );
                },
                icon: const Icon(Icons.copy, size: 12, color: Colors.tealAccent),
                label: const Text('Copy All', style: TextStyle(fontSize: 10, color: Colors.tealAccent)),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amberAccent.withOpacity(0.2),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  _showQuickAddNoteDialog();
                },
                icon: const Icon(Icons.pin, size: 12, color: Colors.amberAccent),
                label: const Text('Pin Note', style: TextStyle(fontSize: 10, color: Colors.amberAccent)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- TAB 1: OVERLAY HUD DASHBOARD ---
  Widget _buildOverlayHubTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.tealAccent.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.layers, color: Colors.tealAccent, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'FloatingDeck Hub',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Universal Multi-Tasking & Quick Dock',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Main Toggle Card
          Card(
            color: const Color(0xFF222736),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Floating HUD Widget',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Access multi-clipboard & notes over any app',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isOverlayEnabled,
                        activeColor: Colors.tealAccent,
                        onChanged: (val) {
                          setState(() {
                            _isOverlayEnabled = val;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // System Permissions Box
          const Text(
            'SYSTEM INTEGRATION PERMISSIONS',
            style: TextStyle(
              color: Colors.tealAccent,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.open_in_new, color: Colors.amberAccent),
                  title: const Text('Display Over Other Apps'),
                  subtitle: const Text('Renders floating bubble over social apps'),
                  value: _overlayPermission,
                  onChanged: (val) => setState(() => _overlayPermission = val),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_active, color: Colors.tealAccent),
                  title: const Text('Smart Notification Listener'),
                  subtitle: const Text('Captures quick clips & dynamic text triggers'),
                  value: _notificationPermission,
                  onChanged: (val) => setState(() => _notificationPermission = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Quick Action Cards
          const Text(
            'ACTIVE SHORTCUTS',
            style: TextStyle(
              color: Colors.tealAccent,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildShortcutCard(
                  icon: Icons.add_link,
                  title: 'Quick Stash',
                  subtitle: 'Save text link',
                  color: Colors.tealAccent,
                  onTap: _showAddClipDialog,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildShortcutCard(
                  icon: Icons.push_pin,
                  title: 'Pin Floating',
                  subtitle: 'Always on screen',
                  color: Colors.amberAccent,
                  onTap: _showQuickAddNoteDialog,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Live Quick Preview Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.tealAccent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: Colors.tealAccent),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tip: Drag the glowing floating bubble anywhere on screen while browsing or chatting for instant multi-copying!',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildShortcutCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1E29),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white70),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 2: MULTI-CLIPBOARD STACK ---
  Widget _buildClipStackTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Multi-Clip Stack',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Stitch & copy multiple texts without losing history',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.tealAccent, size: 30),
                onPressed: _showAddClipDialog,
              )
            ],
          ),
          const SizedBox(height: 16),

          // Action Toolbar
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent.withOpacity(0.15),
                  foregroundColor: Colors.tealAccent,
                ),
                onPressed: () {
                  final combined = _clipStack.join('\n---\n');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Stitched & Copied ${_clipStack.length} items to Clipboard!')),
                  );
                },
                icon: const Icon(Icons.layers, size: 16),
                label: const Text('Stitch & Copy All'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _clipStack.clear();
                  });
                },
                icon: const Icon(Icons.delete_sweep, size: 16, color: Colors.redAccent),
                label: const Text('Clear History', style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Clip List
          if (_clipStack.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: const Column(
                children: [
                  Icon(Icons.content_paste_off, color: Colors.grey, size: 48),
                  SizedBox(height: 12),
                  Text('No copied items in stack.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _clipStack.length,
              itemBuilder: (context, index) {
                final clip = _clipStack[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.tealAccent.withOpacity(0.1),
                      child: Text(
                        '#${index + 1}',
                        style: const TextStyle(
                          color: Colors.tealAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    title: Text(
                      clip,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18, color: Colors.white70),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied item to Clipboard!')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _clipStack.removeAt(index);
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
      ),
    );
  }

  // --- TAB 3: SMART DRAFT & TONE REFINER ---
  Widget _buildDraftStudioTab() {
    final TextEditingController inputController = TextEditingController();
    String refinedOutput = "";

    return StatefulBuilder(
      builder: (context, setStudioState) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tone & Draft Studio',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Instantly transform casual messages into formal, clean, or quick replies',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 16),

              // Input Box
              TextField(
                controller: inputController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Paste or type quick text here (e.g. "machan call me later urgent")',
                  border: OutlineInputBorder(),
                  fillColor: Color(0xFF1B1E29),
                  filled: true,
                ),
              ),
              const SizedBox(height: 12),

              // Preset Buttons
              const Text(
                'SELECT TRANSFORM TONE',
                style: TextStyle(color: Colors.tealAccent, fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.business, size: 14, color: Colors.tealAccent),
                    label: const Text('Formal Email'),
                    onPressed: () {
                      setStudioState(() {
                        final raw = inputController.text.trim();
                        refinedOutput = raw.isEmpty
                            ? 'Please provide text first.'
                            : 'Dear Recipient,\n\nI am writing regarding the following matter: "$raw". Please let me know your availability to discuss further.\n\nBest regards,\nSent via FloatingDeck Studio';
                      });
                    },
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.chat_bubble, size: 14, color: Colors.amberAccent),
                    label: const Text('Polite WhatsApp Reply'),
                    onPressed: () {
                      setStudioState(() {
                        final raw = inputController.text.trim();
                        refinedOutput = raw.isEmpty
                            ? 'Please provide text first.'
                            : 'Hi there! Just following up on this: "$raw". Thanks a lot!';
                      });
                    },
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.cleaning_services, size: 14, color: Colors.purpleAccent),
                    label: const Text('Bullet Points'),
                    onPressed: () {
                      setStudioState(() {
                        final raw = inputController.text.trim();
                        refinedOutput = raw.isEmpty
                            ? 'Please provide text first.'
                            : raw.split(' ').map((e) => '• $e').join('\n');
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Output Box
              if (refinedOutput.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2333),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.tealAccent.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'REFINED OUTPUT',
                            style: TextStyle(
                              color: Colors.tealAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 18, color: Colors.tealAccent),
                            onPressed: () {
                              _addClipItem(refinedOutput);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Copied refined text to Multi-Clip Stack!')),
                              );
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        refinedOutput,
                        style: const TextStyle(fontSize: 13, color: Colors.white),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // --- TAB 4: AMBIENT DESK HUD MODE (High Screen-Time Feature) ---
  Widget _buildAmbientDeskTab() {
    return Container(
      color: const Color(0xFF0B0D12),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Desk Status Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'AMBIENT DESK COMPANION ACTIVE',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Desk Glowing Clock / Stats Widget
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.tealAccent.withOpacity(0.15),
                    Colors.amberAccent.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.tealAccent.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  const Text(
                    '10:42 AM',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.calendar_today, size: 12, color: Colors.amberAccent),
                      SizedBox(width: 6),
                      Text(
                        'Thursday, October 24 | Desk Focus Mode',
                        style: TextStyle(color: Colors.amberAccent, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Pinned Floating Notes Stack
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PINNED DESK CARDS',
                  style: TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: _showQuickAddNoteDialog,
                  icon: const Icon(Icons.add, size: 14, color: Colors.tealAccent),
                  label: const Text('Add Pin', style: TextStyle(color: Colors.tealAccent, fontSize: 12)),
                )
              ],
            ),
            const SizedBox(height: 8),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _pinnedNotes.length,
              itemBuilder: (context, idx) {
                return Card(
                  color: const Color(0xFF161A24),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.push_pin, color: Colors.amberAccent, size: 20),
                    title: Text(
                      _pinnedNotes[idx],
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _pinnedNotes.removeAt(idx);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Active Clipboard Desk Ticker
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF161A24),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.style, color: Colors.tealAccent, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Top Clipboard Item',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _clipStack.isNotEmpty ? _clipStack.first : 'Stack is empty',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- HELPER DIALOGS ---
  void _showAddClipDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B1E29),
        title: const Text('Add to Clip Stack', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Enter text or paste item...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent),
            onPressed: () {
              _addClipItem(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Add Item', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showQuickAddNoteDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B1E29),
        title: const Text('Pin Desk Note', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g. Wi-Fi Pass, Order Code...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amberAccent),
            onPressed: () {
              _addPinnedNote(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Pin Card', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}