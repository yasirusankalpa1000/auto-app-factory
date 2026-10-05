import 'package:flutter/material.dart';

void main() {
  runApp(const PeekShieldApp());
}

class PeekShieldApp extends StatelessWidget {
  const PeekShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PeekShield',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.teal,
          secondary: Colors.amber,
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;

  // Active permissions simulation
  bool _overlayPermissionGranted = true;
  bool _notificationPermissionGranted = true;
  bool _clipboardPermissionGranted = true;

  // Floating Privacy Shield Controls
  bool _isShieldActive = true;
  double _shieldOpacity = 0.80;
  double _shieldHeight = 160.0;
  Color _shieldColor = Colors.black;
  String _shieldColorName = 'Obsidian Black';

  // Floating Bubble Widget Sandbox State
  Offset _bubbleOffset = const Offset(20, 240);
  bool _isBubbleExpanded = false;

  // Clipboard Memory Stack
  final List<String> _clipboardItems = [
    'NIC: 199410294821',
    'Bank Account: 800492104921',
    'Address: No 45, Galle Road, Colombo 03',
    'Promo Code: PROMO2025FREE',
  ];

  // Quick Notes Vault
  final List<Map<String, String>> _quickNotes = [
    {
      'title': 'Bus Route Schedule',
      'body': 'Express Bus #138 leaves at 5:15 PM Gate 4'
    },
    {
      'title': 'Meeting Gate Pass Code',
      'body': 'SECURITY-AUTH-9921 (Show at entrance)'
    },
  ];

  // Disguise Screen Mode
  bool _isShowingDisguise = false;
  String _activeDisguiseType = 'Update';

  void _showAddSnippetDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Add Floating Clipboard Snippet',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Type snippet, account, or private text...',
            hintStyle: TextStyle(color: Colors.white70),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _clipboardItems.insert(0, controller.text.trim());
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save Snippet', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Create Floating Quick Note',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Note Title',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bodyController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Details',
                labelStyle: TextStyle(color: Colors.white70),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                setState(() {
                  _quickNotes.insert(0, {
                    'title': titleController.text.trim(),
                    'body': bodyController.text.trim(),
                  });
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save Note', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isShowingDisguise) {
      return _buildDisguiseScreenView();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.shield, color: Colors.teal, size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'PeekShield Overlay',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Anti-Peeping & Floating Utility Hub',
                    style: TextStyle(fontSize: 11, color: Colors.tealAccent),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isShieldActive ? Icons.security : Icons.security_sharp,
              color: _isShieldActive ? Colors.tealAccent : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isShieldActive = !_isShieldActive;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isShieldActive
                        ? 'Privacy Shield Activated globally!'
                        : 'Privacy Shield Paused.',
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
          SafeArea(
            child: _buildBodyForIndex(_selectedNavIndex),
          ),
          if (_isShieldActive) _buildLivePrivacyCurtainOverlay(),
          _buildDraggableFloatingBubble(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (idx) => setState(() => _selectedNavIndex = idx),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1E293B),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarThemeData().type == null
              ? BottomNavigationBarItem(
                  icon: Icon(Icons.touch_app),
                  label: 'Overlay Hub',
                )
              : BottomNavigationBarItem(
                  icon: Icon(Icons.touch_app),
                  label: 'Overlay Hub',
                ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Shade Studio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy),
            label: 'Clipboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: 'Disguise',
          ),
        ],
      ),
    );
  }

  Widget _buildBodyForIndex(int index) {
    switch (index) {
      case 0:
        return _buildOverlayHubTab();
      case 1:
        return _buildShadeStudioTab();
      case 2:
        return _buildClipboardTab();
      case 3:
        return _buildDisguiseTab();
      default:
        return _buildOverlayHubTab();
    }
  }

  // TAB 1: OVERLAY HUB & PERMISSIONS
  Widget _buildOverlayHubTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active Service Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isShieldActive
                    ? [const Color(0xFF0D9488), const Color(0xFF0F766E)]
                    : [Colors.grey.shade800, Colors.grey.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black87,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _isShieldActive
                          ? Icons.verified_user
                          : Icons.gpp_maybe,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isShieldActive
                                ? 'Floating Privacy Engine Active'
                                : 'Floating Service Paused',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            _isShieldActive
                                ? 'Display over apps running. Anti-peeking active.'
                                : 'Tap power toggle top-right to enable floating protection.',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAxisAlignment.center,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.color_lens, size: 16, color: Colors.teal),
                      label: Text('Tint: $_shieldColorName', style: const TextStyle(fontSize: 11)),
                      backgroundColor: Colors.black87,
                    ),
                    Chip(
                      avatar: const Icon(Icons.opacity, size: 16, color: Colors.amber),
                      label: Text('Opacity: ${(_shieldOpacity * 100).toInt()}%', style: const TextStyle(fontSize: 11)),
                      backgroundColor: Colors.black87,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'System Overlay Permissions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),

          _buildPermissionTile(
            title: 'Display Over Other Apps',
            subtitle: 'Allows floating bubble & screen mask over WhatsApp, Banking, and Browser apps.',
            icon: Icons.layers,
            value: _overlayPermissionGranted,
            onChanged: (val) => setState(() => _overlayPermissionGranted = val),
          ),
          _buildPermissionTile(
            title: 'Floating Notification Shield',
            subtitle: 'Hides incoming sensitive message popups when sitting next to strangers.',
            icon: Icons.notifications_active,
            value: _notificationPermissionGranted,
            onChanged: (val) => setState(() => _notificationPermissionGranted = val),
          ),
          _buildPermissionTile(
            title: 'Clipboard Memory Stack',
            subtitle: 'Remembers up to 10 pasted snippets for instant 1-tap pasting from the bubble.',
            icon: Icons.content_paste,
            value: _clipboardPermissionGranted,
            onChanged: (val) => setState(() => _clipboardPermissionGranted = val),
          ),

          const SizedBox(height: 20),
          const Text(
            'Interactive Sandbox Controls',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),

          Card(
            color: const Color(0xFF1E293B),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.touch_app, color: Colors.amber),
                    title: Text(
                      'Drag Floating Bubble Anywhere!',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    subtitle: Text(
                      'Tap the teal floating circle on your screen to open quick actions, notepad, and clipboard vault instantly.',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _bubbleOffset = const Offset(20, 200);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Floating Bubble position reset to top left.')),
                          );
                        },
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Reset Bubble Position'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // TAB 2: SHADE STUDIO (Customizing Privacy Curtain)
  Widget _buildShadeStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Privacy Curtain Customizer',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Adjust shade dimensions and opacity to block screen peeping in buses, trains & offices.',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 20),

          // Height Slider
          Card(
            color: const Color(0xFF1E293B),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Shield Band Height',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        '${_shieldHeight.toInt()} px',
                        style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Slider(
                    value: _shieldHeight,
                    min: 60.0,
                    max: 380.0,
                    activeColor: Colors.teal,
                    inactiveColor: Colors.grey.shade800,
                    onChanged: (val) {
                      setState(() {
                        _shieldHeight = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Opacity Slider
          Card(
            color: const Color(0xFF1E293B),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Shade Darkening Level',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        '${(_shieldOpacity * 100).toInt()}%',
                        style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Slider(
                    value: _shieldOpacity,
                    min: 0.20,
                    max: 0.98,
                    activeColor: Colors.amber,
                    inactiveColor: Colors.grey.shade800,
                    onChanged: (val) {
                      setState(() {
                        _shieldOpacity = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Text(
            'Security Tint Themes',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildColorThemeCard('Obsidian Black', Colors.black),
              _buildColorThemeCard('Matrix Dark Green', const Color(0xFF064E3B)),
              _buildColorThemeCard('Midnight Blue', const Color(0xFF1E1B4B)),
              _buildColorThemeCard('Smoky Grey', const Color(0xFF334155)),
            ],
          ),

          const SizedBox(height: 24),
          // Privacy Test Simulator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.lightBlue),
            ),
            child: Row(
              children: const [
                Icon(Icons.info, color: Colors.lightBlue, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tip: Drag the privacy curtain stripe up or down on screen using the handle when sitting next to anyone who might peek at your private chats!',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildColorThemeCard(String name, Color color) {
    bool isSelected = _shieldColorName == name;
    return GestureDetector(
      onTap: () {
        setState(() {
          _shieldColor = color;
          _shieldColorName = name;
        });
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 44) / 2,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.tealAccent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white70),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: Colors.white,
                ),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 3: SMART CLIPBOARD & QUICK NOTES
  Widget _buildClipboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Floating Clipboard Stack',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: _showAddSnippetDialog,
                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                label: const Text('Add Snippet', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Snippets stored here can be pasted with 1-tap from your floating overlay bubble.',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 12),

          if (_clipboardItems.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Text('No snippets added yet. Tap Add Snippet!', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _clipboardItems.length,
              itemBuilder: (ctx, idx) {
                final item = _clipboardItems[idx];
                return Card(
                  color: const Color(0xFF1E293B),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.content_paste, color: Colors.tealAccent),
                    title: Text(
                      item,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      softWrap: true,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy, color: Colors.amber, size: 20),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Copied "$item" to active clipboard!')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                          onPressed: () {
                            setState(() {
                              _clipboardItems.removeAt(idx);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Quick Floating Memo Vault',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                onPressed: _showAddNoteDialog,
                icon: const Icon(Icons.note_add, size: 16, color: Colors.white),
                label: const Text('Add Note', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _quickNotes.length,
            itemBuilder: (ctx, idx) {
              final note = _quickNotes[idx];
              return Card(
                color: const Color(0xFF1E293B),
                margin: const EdgeInsets.only(bottom: 8),
                child: ExpansionTile(
                  leading: const Icon(Icons.note_alt, color: Colors.amber),
                  title: Text(
                    note['title'] ?? '',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              note['body'] ?? '',
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                              softWrap: true,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                            onPressed: () {
                              setState(() {
                                _quickNotes.removeAt(idx);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // TAB 4: DISGUISE SCREEN & PRIVACY TOOLS
  Widget _buildDisguiseTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Instant Screen Disguise Triggers',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Trigger a realistic fake screen with 1-tap from your floating bubble to instantly discourage nosy people!',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 16),

          Card(
            color: const Color(0xFF1E293B),
            child: RadioListTile<String>(
              value: 'Update',
              groupValue: _activeDisguiseType,
              activeColor: Colors.tealAccent,
              onChanged: (val) => setState(() => _activeDisguiseType = val!),
              title: const Text('Fake System Security Update Screen', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: const Text('Shows "Installing Critical OS Update... Do not turn off device"', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ),
          ),

          Card(
            color: const Color(0xFF1E293B),
            child: RadioListTile<String>(
              value: 'Battery',
              groupValue: _activeDisguiseType,
              activeColor: Colors.tealAccent,
              onChanged: (val) => setState(() => _activeDisguiseType = val!),
              title: const Text('Fake Low Battery Shutdown Warning', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: const Text('Shows "Battery 0% Shutting Down in 3 seconds..."', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ),
          ),

          Card(
            color: const Color(0xFF1E293B),
            child: RadioListTile<String>(
              value: 'Blackout',
              groupValue: _activeDisguiseType,
              activeColor: Colors.tealAccent,
              onChanged: (val) => setState(() => _activeDisguiseType = val!),
              title: const Text('Total Screen Blackout Disguise', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: const Text('Makes phone look completely turned off. Double tap anywhere to restore.', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ),
          ),

          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  setState(() {
                    _isShowingDisguise = true;
                  });
                },
                icon: const Icon(Icons.play_circle_fill, size: 24),
                label: const Text('TEST DISGUISE MODE NOW', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ),

          const SizedBox(height: 30),
          const Text('Privacy Analytics & Guard Score', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Protection Level', '98%', Colors.tealAccent),
                _buildStatItem('Snippets Saved', '${_clipboardItems.length}', Colors.amber),
                _buildStatItem('Peeks Blocked', '24 Today', Colors.lightBlueAccent),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
      ],
    );
  }

  // PERMISSION TILE WIDGET
  Widget _buildPermissionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        activeColor: Colors.tealAccent,
        value: value,
        onChanged: onChanged,
        secondary: Icon(icon, color: value ? Colors.tealAccent : Colors.grey),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ),
    );
  }

  // FLOATING PRIVACY CURTAIN OVERLAY ON SCREEN
  Widget _buildLivePrivacyCurtainOverlay() {
    return Positioned(
      top: 140,
      left: 0,
      right: 0,
      child: Container(
        height: _shieldHeight,
        decoration: BoxDecoration(
          color: _shieldColor.withOpacity(_shieldOpacity),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 4,
              color: Colors.tealAccent.withOpacity(0.8),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.lock, color: Colors.white70, size: 16),
                SizedBox(width: 6),
                Text(
                  'PEEKSHIELD ANTI-SPY ZONE ACTIVE',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              height: 4,
              color: Colors.tealAccent.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }

  // INTERACTIVE DRAGGABLE FLOATING BUBBLE
  Widget _buildDraggableFloatingBubble() {
    return Positioned(
      left: _bubbleOffset.dx,
      top: _bubbleOffset.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubbleOffset += details.delta;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isBubbleExpanded = !_isBubbleExpanded;
                });
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D9488), Color(0xFF0284C7)],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black87,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  _isBubbleExpanded ? Icons.close : Icons.shield,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            if (_isBubbleExpanded) _buildFloatingQuickMenu(),
          ],
        ),
      ),
    );
  }

  // EXPANDED QUICK ACTIONS PANEL FROM BUBBLE
  Widget _buildFloatingQuickMenu() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Floating Quick Stack',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.tealAccent),
          ),
          const Divider(color: Colors.white70),

          ListTile(
            dense: true,
            padding: EdgeInsets.zero,
            leading: const Icon(Icons.copy, color: Colors.amber, size: 18),
            title: Text(
              _clipboardItems.isNotEmpty ? _clipboardItems.first : 'No items',
              style: const TextStyle(color: Colors.white, fontSize: 11),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: const Text('Tap to copy last snippet', style: TextStyle(color: Colors.white70, fontSize: 9)),
            onTap: () {
              if (_clipboardItems.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Copied "${_clipboardItems.first}"')),
                );
              }
            },
          ),

          ListTile(
            dense: true,
            padding: EdgeInsets.zero,
            leading: const Icon(Icons.visibility_off, color: Colors.deepOrange, size: 18),
            title: const Text('Trigger Disguise Now', style: TextStyle(color: Colors.white, fontSize: 11)),
            onTap: () {
              setState(() {
                _isBubbleExpanded = false;
                _isShowingDisguise = true;
              });
            },
          ),

          ListTile(
            dense: true,
            padding: EdgeInsets.zero,
            leading: Icon(_isShieldActive ? Icons.pause_circle : Icons.play_circle, color: Colors.tealAccent, size: 18),
            title: Text(_isShieldActive ? 'Hide Shade Strip' : 'Show Shade Strip', style: const TextStyle(color: Colors.white, fontSize: 11)),
            onTap: () {
              setState(() {
                _isShieldActive = !_isShieldActive;
              });
            },
          ),
        ],
      ),
    );
  }

  // FAKE DISGUISE SCREEN VIEW
  Widget _buildDisguiseScreenView() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onDoubleTap: () {
          setState(() {
            _isShowingDisguise = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Disguise mode deactivated.')),
          );
        },
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: _buildDisguiseContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDisguiseContent() {
    if (_activeDisguiseType == 'Battery') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.battery_0_bar, size: 80, color: Colors.red),
          SizedBox(height: 20),
          Text(
            'Shutting down...',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Battery level critical (0%). Connect charger.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Text('(Double tap screen to exit disguise)', style: TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      );
    } else if (_activeDisguiseType == 'Blackout') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('(Double tap screen to awaken device)', style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      );
    } else {
      // Default: Fake Update Screen
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(color: Colors.blue),
          SizedBox(height: 30),
          Text(
            'Installing System Update...',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            '27% Complete. Do not turn off your device.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 40),
          Text('(Double tap anywhere to exit disguise mode)', style: TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      );
    }
  }
}