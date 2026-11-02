import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const OmniHUDApp());
}

class OmniHUDApp extends StatelessWidget {
  const OmniHUDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniHUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.indigoAccent,
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const MainHUDOverlayScreen(),
    );
  }
}

class SnippetItem {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime createdAt;

  SnippetItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
  });
}

class NotificationAlert {
  final String id;
  final String title;
  final String message;
  final IconData icon;
  final DateTime time;

  NotificationAlert({
    required this.id,
    required this.title,
    required this.message,
    required this.icon,
    required this.time,
  });
}

class MainHUDOverlayScreen extends StatefulWidget {
  const MainHUDOverlayScreen({super.key});

  @override
  State<MainHUDOverlayScreen> createState() => _MainHUDOverlayScreenState();
}

class _MainHUDOverlayScreenState extends State<MainHUDOverlayScreen> {
  int _currentTabIndex = 0;
  
  // Floating Bubble Position & State
  Offset _bubbleOffset = const Offset(20, 180);
  bool _isMiniWindowOpen = false;
  
  // Permissions & Settings Toggles
  bool _overlayPermissionGranted = true;
  bool _notificationAccessGranted = true;
  bool _autoCopyEnabled = true;

  // Active Snippets Data
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: '1',
      title: 'WiFi Guest Password',
      content: 'GuestPass_2025!\$',
      category: 'Quick Info',
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    SnippetItem(
      id: '2',
      title: 'Meeting Link',
      content: 'https://meet.jit.si/daily-sync-room',
      category: 'Links',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    SnippetItem(
      id: '3',
      title: 'Standard Email Sign-off',
      content: 'Best regards,\nSent from OmniHUD Smart Assist',
      category: 'Templates',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  // Micro Dilemma Tool State
  final List<String> _dilemmaOptions = ['Order Pizza', 'Cook Pasta', 'Salad Bowl', 'Sushi Box'];
  final TextEditingController _dilemmaInputController = TextEditingController();
  String _selectedDilemmaResult = '';
  bool _isSpinning = false;

  // Notification Queue & Dynamic Banner
  final List<NotificationAlert> _alertQueue = [];
  NotificationAlert? _activeBannerAlert;

  @override
  void initState() {
    super.initState();
    _pushNotification('OmniHUD Active', 'Floating companion overlay is ready!', Icons.bubble_chart);
  }

  void _pushNotification(String title, String message, IconData icon) {
    final alert = NotificationAlert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      icon: icon,
      time: DateTime.now(),
    );

    setState(() {
      _alertQueue.insert(0, alert);
      _activeBannerAlert = alert;
    });

    // Auto dismiss active toast banner after 3.5 seconds
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted && _activeBannerAlert?.id == alert.id) {
        setState(() {
          _activeBannerAlert = null;
        });
      }
    });
  }

  void _addNewSnippet(String title, String content, String category) {
    if (content.trim().isEmpty) return;
    setState(() {
      _snippets.insert(
        0,
        SnippetItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title.isEmpty ? 'Untitled Snippet' : title,
          content: content,
          category: category,
          createdAt: DateTime.now(),
        ),
      );
    });
    _pushNotification('Snippet Saved', 'Copied to OmniHUD Vault', Icons.content_paste);
  }

  void _resolveDilemma() {
    if (_dilemmaOptions.isEmpty) return;
    setState(() {
      _isSpinning = true;
      _selectedDilemmaResult = 'Analyzing choices...';
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      final random = Random();
      final index = random.nextInt(_dilemmaOptions.length);
      setState(() {
        _selectedDilemmaResult = _dilemmaOptions[index];
        _isSpinning = false;
      });
      _pushNotification('Decision Resolved!', 'Selected: ${_dilemmaOptions[index]}', Icons.psychology);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Main Body Navigator
          SafeArea(
            child: IndexedStack(
              index: _currentTabIndex,
              children: [
                _buildSnippetVaultTab(),
                _buildDilemmaResolverTab(),
                _buildNotificationCenterTab(),
                _buildOverlaySettingsTab(),
              ],
            ),
          ),

          // Floating Top Banner Toast Alert Simulator
          if (_activeBannerAlert != null)
            Positioned(
              top: 45,
              left: 16,
              right: 16,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _activeBannerAlert != null ? 1.0 : 0.0,
                child: Material(
                  color: Colors.transparent,
                  elevation: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.tealAccent, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.tealAccent.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(_activeBannerAlert!.icon, color: Colors.tealAccent, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _activeBannerAlert!.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                _activeBannerAlert!.message,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _activeBannerAlert = null;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Draggable Floating HUD Mini Assistant Window (If expanded)
          if (_isMiniWindowOpen)
            Positioned(
              left: min(max(10, _bubbleOffset.dx - 120), screenSize.width - 270),
              top: min(max(80, _bubbleOffset.dy + 60), screenSize.height - 250),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 260,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A).withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.indigoAccent, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      )
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
                              Icon(Icons.flash_on, color: Colors.amber, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'OmniHUD Quick Panel',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isMiniWindowOpen = false;
                              });
                            },
                            child: const Icon(Icons.close, color: Colors.grey, size: 18),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white70, height: 16),
                      const Text(
                        'Recent Snippet Quick Copy:',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _snippets.isNotEmpty ? _snippets.first.content : 'No snippets saved yet',
                          style: const TextStyle(color: Colors.tealAccent, fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {
                                if (_snippets.isNotEmpty) {
                                  _pushNotification('Copied!', 'Snippet copied to clipboard', Icons.check_circle);
                                }
                              },
                              icon: const Icon(Icons.content_copy, size: 14),
                              label: const Text('Copy Top', style: TextStyle(fontSize: 11)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigoAccent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {
                                _resolveDilemma();
                              },
                              icon: const Icon(Icons.auto_awesome, size: 14),
                              label: const Text('Decide', style: TextStyle(fontSize: 11)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Draggable Floating HUD Bubble Icon
          Positioned(
            left: _bubbleOffset.dx,
            top: _bubbleOffset.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _bubbleOffset += details.delta;
                });
              },
              onTap: () {
                setState(() {
                  _isMiniWindowOpen = !_isMiniWindowOpen;
                });
              },
              child: Material(
                elevation: 10,
                shape: const CircleBorder(),
                color: Colors.transparent,
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Colors.tealAccent, Colors.indigoAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.tealAccent.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.bubble_chart, color: Color(0xFF0F172A), size: 30),
                        if (_alertQueue.isNotEmpty)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.deepOrange,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${_alertQueue.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: 'Snippet Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Decider',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: 'Floating Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'HUD Config',
          ),
        ],
      ),
    );
  }

  // TAB 1: SNIPPET & CLIPBOARD VAULT
  Widget _buildSnippetVaultTab() {
    return SingleChildScrollView(
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
                    'OmniHUD Clipboard Vault',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Instant micro-notes & float access',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.tealAccent, size: 30),
                onPressed: () => _showAddSnippetDialog(),
              )
            ],
          ),
          const SizedBox(height: 16),
          // Statistics Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade800, Colors.teal.shade900],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Saved Snippets', '${_snippets.length}', Icons.layers),
                Container(height: 30, width: 1, color: Colors.white70),
                _buildStatItem('Floating HUD', _overlayPermissionGranted ? 'ACTIVE' : 'OFF', Icons.bubble_chart),
                Container(height: 30, width: 1, color: Colors.white70),
                _buildStatItem('Quick Copy', 'Enabled', Icons.flash_on),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Your Saved Snippets',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          const SizedBox(height: 12),
          if (_snippets.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: const [
                    Icon(Icons.inbox, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('No snippets saved yet.', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _snippets.length,
              itemBuilder: (context, index) {
                final snippet = _snippets[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white70),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              snippet.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.tealAccent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              snippet.category,
                              style: const TextStyle(color: Colors.tealAccent, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        snippet.content,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${snippet.createdAt.hour}:${snippet.createdAt.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 18),
                                onPressed: () {
                                  setState(() {
                                    _snippets.removeAt(index);
                                  });
                                  _pushNotification('Deleted', 'Snippet removed', Icons.delete);
                                },
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.tealAccent,
                                  foregroundColor: const Color(0xFF0F172A),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  _pushNotification('Copied!', '"${snippet.title}" ready to paste', Icons.content_copy);
                                },
                                icon: const Icon(Icons.copy, size: 14),
                                label: const Text('Copy', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // TAB 2: MICRO-DILEMMA RESOLVER
  Widget _buildDilemmaResolverTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Dilemma Resolver',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'Can\'t decide what to eat, buy, or do? Let OmniHUD choose!',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigoAccent.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _dilemmaInputController,
                        decoration: const InputDecoration(
                          hintText: 'Add an option (e.g. Tacos)...',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      ),
                      onPressed: () {
                        final text = _dilemmaInputController.text.trim();
                        if (text.isNotEmpty) {
                          setState(() {
                            _dilemmaOptions.add(text);
                            _dilemmaInputController.clear();
                          });
                        }
                      },
                      child: const Icon(Icons.add, size: 20),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAxisAlignment.center,
                  children: _dilemmaOptions.map((opt) {
                    return Chip(
                      label: Text(opt, style: const TextStyle(color: Colors.white, fontSize: 12)),
                      backgroundColor: const Color(0xFF0F172A),
                      deleteIcon: const Icon(Icons.cancel, size: 14, color: Colors.grey),
                      onDeleted: () {
                        setState(() {
                          _dilemmaOptions.remove(opt);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                      foregroundColor: const Color(0xFF0F172A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _isSpinning || _dilemmaOptions.isEmpty ? null : _resolveDilemma,
                    icon: _isSpinning
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0F172A)),
                          )
                        : const Icon(Icons.auto_awesome),
                    label: Text(
                      _isSpinning ? 'Resolving Dilemma...' : 'RESOLVE MY DILEMMA NOW',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (_selectedDilemmaResult.isNotEmpty)
            Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.tealAccent.withOpacity(0.2), Colors.indigoAccent.withOpacity(0.2)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.tealAccent),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.stars, color: Colors.amber, size: 36),
                    const SizedBox(height: 8),
                    const Text('DECISION RESULT:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(
                      _selectedDilemmaResult,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // TAB 3: FLOATING NOTIFICATION CENTER
  Widget _buildNotificationCenterTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Alerts Feed',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'Simulated overlay toast history & dynamic alert triggers',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          // Test Notification Triggers
          const Text('Trigger Quick Toast Test:', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                avatar: const Icon(Icons.lightbulb, size: 16, color: Colors.amber),
                label: const Text('Quick Tip'),
                onPressed: () {
                  _pushNotification('Daily Tip', 'Double tap the floating HUD bubble anytime!', Icons.lightbulb);
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.monetization_on, size: 16, color: Colors.green),
                label: const Text('Micro-Log'),
                onPressed: () {
                  _pushNotification('Expense Log', 'Logged \$12.50 Lunch via HUD', Icons.monetization_on);
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.security, size: 16, color: Colors.tealAccent),
                label: const Text('Security Ping'),
                onPressed: () {
                  _pushNotification('Clipboard Secure', 'No sensitive leaks detected', Icons.security);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Alert Logs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              if (_alertQueue.isNotEmpty)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _alertQueue.clear();
                    });
                  },
                  child: const Text('Clear All', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                )
            ],
          ),
          const SizedBox(height: 8),
          if (_alertQueue.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('No active notification logs', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _alertQueue.length,
              itemBuilder: (context, index) {
                final item = _alertQueue[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(item.icon, color: Colors.tealAccent, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
                            Text(item.message, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                          ],
                        ),
                      ),
                      Text(
                        '${item.time.hour}:${item.time.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // TAB 4: HUD OVERLAY SETTINGS & PERMISSIONS
  Widget _buildOverlaySettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'HUD & System Settings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'Configure floating bubble behavior and overlay permissions',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Display Over Other Apps', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Allows floating HUD bubble to stay visible on screen', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  value: _overlayPermissionGranted,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() {
                      _overlayPermissionGranted = val;
                    });
                    _pushNotification('HUD Permission', val ? 'Display over apps enabled' : 'Display over apps disabled', Icons.layers);
                  },
                ),
                const Divider(color: Colors.white70),
                SwitchListTile(
                  title: const Text('Floating Notifications', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Show dynamic mini banner toasts on active clip events', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  value: _notificationAccessGranted,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() {
                      _notificationAccessGranted = val;
                    });
                  },
                ),
                const Divider(color: Colors.white70),
                SwitchListTile(
                  title: const Text('Auto-Catch Clipboard', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Automatically offer to save copied text in vault', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  value: _autoCopyEnabled,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() {
                      _autoCopyEnabled = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.tealAccent, size: 20),
                    SizedBox(width: 8),
                    Text('How to use Floating HUD', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  '1. Drag the floating teal bubble anywhere on screen to reposition.\n'
                  '2. Tap the bubble to open the Quick Command Panel.\n'
                  '3. Add items to Snippet Vault to access them instantly from any view.\n'
                  '4. Use Micro-Dilemma decider to resolve quick daily choices instantly.',
                  style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.tealAccent, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }

  void _showAddSnippetDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String category = 'Quick Info';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text('Add Quick Snippet', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title (e.g. WiFi Code)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Snippet Content / Note',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: const Color(0xFF0F172A)),
              onPressed: () {
                _addNewSnippet(titleController.text, contentController.text, category);
                Navigator.pop(context);
              },
              child: const Text('Save Snippet', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}