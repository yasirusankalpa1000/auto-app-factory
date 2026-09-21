import 'package:flutter/material.dart';

void main() {
  runApp(const BubbleDeskApp());
}

class BubbleDeskApp extends StatelessWidget {
  const BubbleDeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BubbleDesk Overlay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF12121A),
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
  int _selectedIndex = 0;

  // Floating Widget Overlay Controls
  bool _isOverlayActive = true;
  Offset _bubblePosition = const Offset(20, 200);
  bool _isOverlayExpanded = false;
  String _activeWidgetMode = 'Clipboard'; // Clipboard, Notes, Teleprompter, QuickReply

  // Simulated Overlay Permissions
  bool _overlayPermissionGranted = true;
  bool _notificationPermissionGranted = true;

  // Clipboard History Data
  final List<Map<String, String>> _clipboardDeck = [
    {
      'title': 'Bank Account details',
      'content': 'Account: 8004123981 | Commercial Bank | Branch: Colombo',
      'tag': 'Finance',
      'time': 'Just now'
    },
    {
      'title': 'Delivery Address',
      'content': 'No. 45/2, Galle Road, Colombo 03, Sri Lanka',
      'tag': 'Address',
      'time': '10 mins ago'
    },
    {
      'title': 'Promo Code',
      'content': 'DISCOUNT50OFF',
      'tag': 'Code',
      'time': '1 hour ago'
    },
  ];

  // Quick Notes Data
  final List<Map<String, dynamic>> _floatingNotes = [
    {
      'title': 'Shopping List',
      'content': 'Milk, Eggs, Coffee powder, Bread, Oats',
      'color': Colors.amber,
      'isPinned': true,
    },
    {
      'title': 'Meeting Scratchpad',
      'content': 'Ask team about API response time and UI responsiveness.',
      'color': Colors.cyan,
      'isPinned': false,
    },
  ];

  // Quick Replies Data
  final List<String> _quickReplies = [
    'I am currently busy, will call you back shortly!',
    'Please send me the details via WhatsApp.',
    'Payment has been sent successfully. Please confirm!',
    'Location shared: Near the central station.',
  ];

  // Dynamic Teleprompter Text
  String _teleprompterText =
      'Welcome to BubbleDesk Dynamic Reader. Keep this floating over your camera app while recording videos or hosting live streams. Scroll effortlessly without losing eye contact!';
  double _teleprompterFontSize = 16.0;

  // Notification Builder Dynamic Counter
  int _activeNotificationCount = 2;
  final List<String> _simulatedNotifications = [
    '⚡ BubbleDesk Companion is Active on Display',
    '📋 Clipboard Deck synchronized (3 items stored)',
  ];

  void _addNewClipboardItem(String title, String content, String tag) {
    setState(() {
      _clipboardDeck.insert(0, {
        'title': title.isEmpty ? 'Quick Clip' : title,
        'content': content,
        'tag': tag.isEmpty ? 'General' : tag,
        'time': 'Just now',
      });
    });
  }

  void _addNewNote(String title, String content, Color color) {
    setState(() {
      _floatingNotes.insert(0, {
        'title': title.isEmpty ? 'Quick Note' : title,
        'content': content,
        'color': color,
        'isPinned': false,
      });
    });
  }

  void _addNewNotification(String text) {
    setState(() {
      _simulatedNotifications.insert(0, text);
      _activeNotificationCount = _simulatedNotifications.length;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification pushed: $text'),
        backgroundColor: Colors.deepPurple,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main App Body Navigation
          SafeArea(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildDashboardTab(),
                _buildClipboardDeckTab(),
                _buildNotesTab(),
                _buildTeleprompterTab(),
                _buildSettingsTab(),
              ],
            ),
          ),

          // SIMULATED DISPLAY OVER OTHER APPS FLOATING OVERLAY BUBBLE
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
                child: Material(
                  elevation: 12,
                  borderRadius: BorderRadius.circular(28),
                  color: Colors.transparent,
                  child: Container(
                    width: _isOverlayExpanded ? 290 : 64,
                    height: _isOverlayExpanded ? 340 : 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2C).withOpacity(0.95),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.deepPurpleAccent.withOpacity(0.8),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurpleAccent.withOpacity(0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: _isOverlayExpanded
                        ? _buildExpandedOverlayView()
                        : _buildCollapsedOverlayBubble(),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF181824),
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.space_dashboard),
            label: 'Desk HUD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.copy_all),
            label: 'Clipboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.slideshow),
            label: 'Prompter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Control',
          ),
        ],
      ),
    );
  }

  // --- COLLAPSED FLOATING BUBBLE ---
  Widget _buildCollapsedOverlayBubble() {
    return InkWell(
      onTap: () {
        setState(() {
          _isOverlayExpanded = true;
        });
      },
      borderRadius: BorderRadius.circular(24),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.layers,
              color: Colors.white,
              size: 30,
            ),
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bolt,
                  color: Colors.black,
                  size: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- EXPANDED FLOATING OVERLAY HUD ---
  Widget _buildExpandedOverlayView() {
    return Column(
      children: [
        // Header Drag Bar & Navigation
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: const BoxDecoration(
            color: Color(0xFF28283D),
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: Row(
            children: [
              const Icon(Icons.drag_indicator, color: Colors.grey, size: 18),
              const SizedBox(width: 4),
              const Expanded(
                child: Text(
                  'BubbleDesk Companion',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _isOverlayExpanded = false;
                  });
                },
                child: const Icon(Icons.close, color: Colors.white70, size: 18),
              ),
            ],
          ),
        ),

        // Quick Mode Selector Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: ['Clipboard', 'Notes', 'Teleprompter', 'QuickReply'].map((mode) {
              final isSelected = _activeWidgetMode == mode;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: Text(
                    mode,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? Colors.black : Colors.white,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: Colors.cyanAccent,
                  backgroundColor: const Color(0xFF32324A),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _activeWidgetMode = mode;
                      });
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),

        const Divider(height: 1, color: Colors.white70),

        // Active Overlay Widget Body
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildOverlayContentWidget(),
          ),
        ),
      ],
    );
  }

  Widget _buildOverlayContentWidget() {
    switch (_activeWidgetMode) {
      case 'Clipboard':
        return ListView.builder(
          itemCount: _clipboardDeck.length,
          itemBuilder: (context, index) {
            final item = _clipboardDeck[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF28283D),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['content']!,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 16, color: Colors.white),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Copied: ${item['title']}'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );

      case 'Notes':
        return ListView.builder(
          itemCount: _floatingNotes.length,
          itemBuilder: (context, index) {
            final note = _floatingNotes[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (note['color'] as Color).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: note['color'] as Color, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note['title'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: note['color'],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    note['content'],
                    style: const TextStyle(fontSize: 11, color: Colors.white),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        );

      case 'Teleprompter':
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _teleprompterText,
                style: TextStyle(
                  fontSize: _teleprompterFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.amberAccent,
                  height: 1.4,
                ),
              ),
            ],
          ),
        );

      case 'QuickReply':
        return ListView.builder(
          itemCount: _quickReplies.length,
          itemBuilder: (context, index) {
            final reply = _quickReplies[index];
            return InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Quick Reply copied to Clipboard!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.deepPurpleAccent),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.send_rounded,
                        size: 14, color: Colors.deepPurpleAccent),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        reply,
                        style: const TextStyle(fontSize: 11, color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );

      default:
        return const Center(child: Text('Select Tool'));
    }
  }

  // --- TAB 1: DESK HUD DASHBOARD ---
  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Title Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.widgets_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BubbleDesk PRO',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Smart Overlay & Companion Desk',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Switch(
                value: _isOverlayActive,
                activeColor: Colors.cyanAccent,
                onChanged: (val) {
                  setState(() {
                    _isOverlayActive = val;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Active Permissions & Status Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2A1B4E), Color(0xFF1E2640)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _isOverlayActive
                          ? Icons.check_circle
                          : Icons.pause_circle_filled,
                      color: _isOverlayActive ? Colors.greenAccent : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isOverlayActive
                          ? 'Floating HUD Active & Ready'
                          : 'Floating Overlay Disabled',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'BubbleDesk stays as a dynamic widget on your screen. Access scripts, multi-clipboard slots, and floating notes while using WhatsApp, Banking, TikTok, YouTube, or PDF readers.',
                  style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildStatusChip(
                      label: 'Display Over Apps',
                      isGranted: _overlayPermissionGranted,
                      onTap: () {
                        setState(() {
                          _overlayPermissionGranted = !_overlayPermissionGranted;
                        });
                      },
                    ),
                    _buildStatusChip(
                      label: 'Persistent Notification',
                      isGranted: _notificationPermissionGranted,
                      onTap: () {
                        setState(() {
                          _notificationPermissionGranted =
                              !_notificationPermissionGranted;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Dynamic Stats Grid
          const Text(
            'Desk Activity Overview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatTile(
                  title: 'Saved Clips',
                  count: '${_clipboardDeck.length}',
                  icon: Icons.copy_all,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatTile(
                  title: 'Active Notes',
                  count: '${_floatingNotes.length}',
                  icon: Icons.note_alt,
                  color: Colors.amberAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatTile(
                  title: 'Quick Replies',
                  count: '${_quickReplies.length}',
                  icon: Icons.chat_bubble_outline,
                  color: Colors.pinkAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatTile(
                  title: 'Notifications',
                  count: '$_activeNotificationCount Active',
                  icon: Icons.notifications_active,
                  color: Colors.greenAccent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Live Interactive System Notification Simulator
          const Text(
            'Live Notification Launcher',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Push custom status alerts directly into your mobile notification tray for instant high-frequency access.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.add_alert),
            label: const Text('Push Quick Sticky Alert to Notification Bar'),
            onPressed: () {
              _addNewNotification(
                '📌 Quick Snap: Task updated at ${DateTime.now().hour}:${DateTime.now().minute}',
              );
            },
          ),
          const SizedBox(height: 12),
          Column(
            children: _simulatedNotifications.map((notif) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2C),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white70),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.circle_notifications,
                        color: Colors.cyanAccent, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        notif,
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip({
    required String label,
    required bool isGranted,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isGranted ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isGranted ? Colors.greenAccent : Colors.redAccent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isGranted ? Icons.check : Icons.lock_open,
              size: 12,
              color: isGranted ? Colors.greenAccent : Colors.redAccent,
            ),
            const SizedBox(width: 4),
            Text(
              '$label: ${isGranted ? "ON" : "OFF"}',
              style: TextStyle(
                fontSize: 11,
                color: isGranted ? Colors.greenAccent : Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: CLIPBOARD DECK ---
  Widget _buildClipboardDeckTab() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final tagController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                    'Clipboard Deck',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Multi-slot dynamic copy & paste board',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.add_box, color: Colors.cyanAccent),
                onPressed: () {
                  _showAddClipDialog(
                      context, titleController, contentController, tagController);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _clipboardDeck.length,
              itemBuilder: (context, index) {
                final item = _clipboardDeck[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2C),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white70),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.cyan.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item['tag']!,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.cyanAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            item['time']!,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['title']!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['content']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete,
                                size: 18, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _clipboardDeck.removeAt(index);
                              });
                            },
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                            ),
                            icon: const Icon(Icons.copy, size: 14),
                            label: const Text('Copy Slot',
                                style: TextStyle(fontSize: 11)),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Copied: ${item['title']}'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddClipDialog(
    BuildContext context,
    TextEditingController titleCtrl,
    TextEditingController contentCtrl,
    TextEditingController tagCtrl,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          title: const Text('Add Item to Clipboard Deck',
              style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Title / Reference',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contentCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Content / Text Snippet',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: tagCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Tag (e.g., Bank, Work, Address)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (contentCtrl.text.isNotEmpty) {
                  _addNewClipboardItem(
                    titleCtrl.text,
                    contentCtrl.text,
                    tagCtrl.text,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Clip'),
            ),
          ],
        );
      },
    );
  }

  // --- TAB 3: FLOATING STICKY NOTES ---
  Widget _buildNotesTab() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                    'Floating Sticky Notes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Keep essential info ready for screen overlay',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.note_add, color: Colors.amber),
                onPressed: () {
                  _showAddNoteDialog(context, titleCtrl, contentCtrl);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _floatingNotes.length,
              itemBuilder: (context, index) {
                final note = _floatingNotes[index];
                final Color noteColor = note['color'] as Color;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: noteColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: noteColor.withOpacity(0.6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            note['title'],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: noteColor,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              note['isPinned']
                                  ? Icons.push_pin
                                  : Icons.push_pin_outlined,
                              color: noteColor,
                              size: 18,
                            ),
                            onPressed: () {
                              setState(() {
                                note['isPinned'] = !note['isPinned'];
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        note['content'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog(
    BuildContext context,
    TextEditingController titleCtrl,
    TextEditingController contentCtrl,
  ) {
    Color selectedColor = Colors.amber;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E2C),
              title: const Text('New Floating Sticky Note',
                  style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Note Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: contentCtrl,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Note Body Details',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Colors.amber,
                        Colors.cyan,
                        Colors.pinkAccent,
                        Colors.lightGreenAccent
                      ].map((col) {
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedColor = col;
                            });
                          },
                          child: CircleAvatar(
                            backgroundColor: col,
                            radius: selectedColor == col ? 16 : 12,
                            child: selectedColor == col
                                ? const Icon(Icons.check,
                                    size: 14, color: Colors.black)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (contentCtrl.text.isNotEmpty) {
                      _addNewNote(
                        titleCtrl.text,
                        contentCtrl.text,
                        selectedColor,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Note'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- TAB 4: FLOATING TELEPROMPTER ---
  Widget _buildTeleprompterTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Teleprompter Script',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            'Read your speech or notes over camera or streaming apps',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Size Control Slider
          Row(
            children: [
              const Text('Font Size:', style: TextStyle(color: Colors.white)),
              Expanded(
                child: Slider(
                  value: _teleprompterFontSize,
                  min: 12,
                  max: 28,
                  activeColor: Colors.cyanAccent,
                  onChanged: (val) {
                    setState(() {
                      _teleprompterFontSize = val;
                    });
                  },
                ),
              ),
              Text(
                '${_teleprompterFontSize.round()} pt',
                style: const TextStyle(color: Colors.cyanAccent),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Script Editor Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white70),
              ),
              child: TextFormField(
                initialValue: _teleprompterText,
                maxLines: null,
                style: TextStyle(
                  fontSize: _teleprompterFontSize,
                  color: Colors.white,
                  height: 1.4,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type or paste script text here...',
                ),
                onChanged: (val) {
                  setState(() {
                    _teleprompterText = val;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 46),
            ),
            icon: const Icon(Icons.fullscreen),
            label: const Text('Enable Reader Overlay Window',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              setState(() {
                _isOverlayActive = true;
                _isOverlayExpanded = true;
                _activeWidgetMode = 'Teleprompter';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Teleprompter dynamic overlay enabled!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- TAB 5: CONTROL & SETTINGS ---
  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overlay Controls & Preferences',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            'Configure app behaviors and floating HUD options',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Settings List Cards
          _buildSettingsSwitchTile(
            title: 'Always Keep Bubble On Screen',
            subtitle: 'Prevent system from removing floating widget',
            value: true,
            onChanged: (val) {},
          ),
          _buildSettingsSwitchTile(
            title: 'Auto-Sync Clipboard Snippets',
            subtitle: 'Automatically import fresh text copied into memory',
            value: true,
            onChanged: (val) {},
          ),
          _buildSettingsSwitchTile(
            title: 'Haptic Feedback on Drag',
            subtitle: 'Vibrate when dragging the overlay bubble',
            value: false,
            onChanged: (val) {},
          ),

          const SizedBox(height: 20),
          const Text(
            'Engagement & Desk Utility Info',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white70),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Why Users Love BubbleDesk:',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '• Never close your active game, video, or chat to copy details.\n'
                  '• Floating teleprompter makes online recording effortless.\n'
                  '• Keep bank accounts, delivery details & promo codes floating safely.\n'
                  '• Highly customizable visual HUD design with real-time response.',
                  style:
                      TextStyle(fontSize: 12, color: Colors.white70, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white70),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(
              fontSize: 14, FontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        value: value,
        activeColor: Colors.deepPurpleAccent,
        onChanged: onChanged,
      ),
    );
  }
}