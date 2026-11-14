import 'package:flutter/material.dart';

void main() {
  runApp(const FloatingDeckApp());
}

class FloatingDeckApp extends StatelessWidget {
  const FloatingDeckApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatingDeck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF12181F),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class DynamicClipboardItem {
  final String id;
  final String content;
  final String category;
  final DateTime timestamp;
  bool isPinned;

  DynamicClipboardItem({
    required this.id,
    required this.content,
    required this.category,
    required this.timestamp,
    this.isPinned = false,
  });
}

class FloatingNote {
  final String id;
  String title;
  String body;
  Color color;
  DateTime updatedAt;

  FloatingNote({
    required this.id,
    required this.title,
    required this.body,
    required this.color,
    required this.updatedAt,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedTabIndex = 0;

  // Floating Overlay Bubble Position Simulation
  double _bubbleX = 20.0;
  double _bubbleY = 180.0;
  bool _isOverlayActive = true;
  bool _isFloatingMenuOpen = false;
  String _activeNotificationMessage = '';
  bool _showNotificationBanner = false;

  // Simulated Clipboard Items
  final List<DynamicClipboardItem> _clipboardVault = [
    DynamicClipboardItem(
      id: '1',
      content: 'Discount Promo Code: SAVE20NOW',
      category: 'Promo Code',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      isPinned: true,
    ),
    DynamicClipboardItem(
      id: '2',
      content: 'https://maps.example.com/location/meeting-point',
      category: 'URL Link',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    DynamicClipboardItem(
      id: '3',
      content: 'Total Budget: \$450.00 for hardware components',
      category: 'Finance',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];

  // Floating Notes
  final List<FloatingNote> _floatingNotes = [
    FloatingNote(
      id: 'n1',
      title: 'Quick Groceries',
      body: 'Milk, Eggs, Whole Wheat Bread, Olive Oil',
      color: Colors.amber,
      updatedAt: DateTime.now(),
    ),
    FloatingNote(
      id: 'n2',
      title: 'Meeting Highlights',
      body: 'Review user retention metrics and AdMob placement strategy.',
      color: Colors.teal,
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Quick Currency / Unit Converter state
  double _inputAmount = 100.0;
  String _fromUnit = 'USD (\$)';
  String _toUnit = 'EUR (€)';

  // Text Summarizer Simulation
  final TextEditingController _summarizerController = TextEditingController();
  String _summarizedOutput = '';
  bool _isSummarizing = false;

  @override
  void dispose() {
    _summarizerController.dispose();
    super.dispose();
  }

  void _triggerFloatingNotification(String message) {
    setState(() {
      _activeNotificationMessage = message;
      _showNotificationBanner = true;
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showNotificationBanner = false;
        });
      }
    });
  }

  void _addClipboardSnippet(String text, String category) {
    if (text.trim().isEmpty) return;
    setState(() {
      _clipboardVault.insert(
        0,
        DynamicClipboardItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: text.trim(),
          category: category,
          timestamp: DateTime.now(),
        ),
      );
    });
    _triggerFloatingNotification('New snippet auto-saved to Floating Vault!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main App Content Tab view
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedTabIndex,
                    children: [
                      _buildOverlaySimulatorTab(),
                      _buildClipboardVaultTab(),
                      _buildSmartSummarizerTab(),
                      _buildQuickUtilitiesTab(),
                      _buildSettingsTab(),
                    ],
                  ),
                ),
              ],
            ),

            // Top Floating Notification Banner Simulation
            if (_showNotificationBanner)
              Positioned(
                top: 10,
                left: 15,
                right: 15,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.teal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.notifications, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _activeNotificationMessage,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 18),
                          onPressed: () {
                            setState(() {
                              _showNotificationBanner = false;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

            // Interactive Simulated Floating Screen Bubble
            if (_isOverlayActive)
              Positioned(
                left: _bubbleX,
                top: _bubbleY,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _bubbleX += details.delta.dx;
                      _bubbleY += details.delta.dy;
                    });
                  },
                  onTap: () {
                    setState(() {
                      _isFloatingMenuOpen = !_isFloatingMenuOpen;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ],
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          _isFloatingMenuOpen ? Icons.close : Icons.widgets,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      if (!_isFloatingMenuOpen)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Drag Me',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        )
                    ],
                  ),
                ),
              ),

            // Expanded Floating Quick Actions Radial/Drawer Popup
            if (_isOverlayActive && _isFloatingMenuOpen)
              Positioned(
                left: _bubbleX > 150 ? _bubbleX - 160 : _bubbleX + 60,
                top: _bubbleY,
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFF1E2834),
                  child: Container(
                    width: 180,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2834),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.teal, width: 1.5),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Floating Quick Hub',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const Divider(color: Colors.white70, height: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                          ),
                          onPressed: () {
                            _addClipboardSnippet('Quick Screen Shot Clip #${_clipboardVault.length + 1}', 'Screen Note');
                            setState(() {
                              _isFloatingMenuOpen = false;
                            });
                          },
                          icon: const Icon(Icons.content_copy, size: 16),
                          label: const Text('Capture Clip', style: TextStyle(fontSize: 11)),
                        ),
                        const SizedBox(height: 6),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                          ),
                          onPressed: () {
                            _showQuickNoteModal(context);
                            setState(() {
                              _isFloatingMenuOpen = false;
                            });
                          },
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Quick Note', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 6),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                          ),
                          onPressed: () {
                            _triggerFloatingNotification('Simulated Unit Swap: \$100 = €92.50');
                            setState(() {
                              _isFloatingMenuOpen = false;
                            });
                          },
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('Convert \$ -> €', style: TextStyle(fontSize: 11)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF161D26),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Overlay Studio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Clip Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt),
            label: 'Summarizer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Utilities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Color(0xFF161D26),
        border: Border(
          bottom: BorderSide(color: Colors.white70, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.layers, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FloatingDeck',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  _isOverlayActive ? 'Floating Assistant: ACTIVE' : 'Floating Assistant: PAUSED',
                  style: TextStyle(
                    color: _isOverlayActive ? Colors.teal : Colors.grey,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isOverlayActive,
            activeColor: Colors.teal,
            onChanged: (val) {
              setState(() {
                _isOverlayActive = val;
              });
              _triggerFloatingNotification(
                val ? 'System floating bubble activated!' : 'Floating deck hidden.',
              );
            },
          ),
        ],
      ),
    );
  }

  // TAB 1: OVERLAY SIMULATOR / SCREEN DEMO
  Widget _buildOverlaySimulatorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.stars, color: Colors.amber, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Universal Screen Floating Dock',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'FloatingDeck works over any app (Social, Shopping, News, Browsers). Drag the floating widget bubble anywhere on your screen to trigger instant notes, clipboard saves, or conversions.',
                  style: TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
                  softWrap: true,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.teal,
                      ),
                      onPressed: () {
                        _triggerFloatingNotification('Test floating toast banner notification trigger!');
                      },
                      icon: const Icon(Icons.notifications, size: 16),
                      label: const Text('Test Banner Toast', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                      onPressed: () {
                        setState(() {
                          _bubbleX = 30.0;
                          _bubbleY = 160.0;
                        });
                        _triggerFloatingNotification('Floating bubble reset to top-left anchor.');
                      },
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Reset Bubble', style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Simulated Live Background Apps',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 6),
          const Text(
            'See how FloatingDeck overlays smoothly on top of normal phone apps:',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 12),
          _buildSimulatedAppCard(
            title: 'E-Commerce Store Preview',
            subtitle: 'Browsing item listed at \$299.99',
            icon: Icons.monetization_on,
            iconColor: Colors.green,
            actionLabel: 'Convert Price',
            onTap: () {
              _triggerFloatingNotification('Converted \$299.99 USD = €277.50 EUR');
            },
          ),
          const SizedBox(height: 10),
          _buildSimulatedAppCard(
            title: 'News Article Preview',
            subtitle: 'Long story regarding international market trends...',
            icon: Icons.info,
            iconColor: Colors.blue,
            actionLabel: 'Summarize Text',
            onTap: () {
              setState(() {
                _selectedTabIndex = 2; // Jump to summarizer
              });
            },
          ),
          const SizedBox(height: 10),
          _buildSimulatedAppCard(
            title: 'Social Chat Feed',
            subtitle: 'Friend sent address: 742 Evergreen Terrace',
            icon: Icons.share,
            iconColor: Colors.purple,
            actionLabel: 'Copy & Vault',
            onTap: () {
              _addClipboardSnippet('742 Evergreen Terrace', 'Address');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSimulatedAppCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required String actionLabel,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2631),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.2),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onTap,
            child: Text(
              actionLabel,
              style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          )
        ],
      ),
    );
  }

  // TAB 2: SMART CLIPBOARD VAULT
  Widget _buildClipboardVaultTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Smart Clipboard Vault',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                onPressed: () {
                  _showAddClipModal(context);
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Clip', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Auto-catches and organizes your copied text, codes, links, and text snippets.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),
          if (_clipboardVault.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: const Text('No clipboard items saved yet.', style: TextStyle(color: Colors.grey)),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _clipboardVault.length,
              itemBuilder: (context, index) {
                final item = _clipboardVault[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2631),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: item.isPinned ? Colors.amber : Colors.white70,
                      width: item.isPinned ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.category,
                              style: const TextStyle(color: Colors.teal, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              item.isPinned ? Icons.star : Icons.star_border,
                              color: item.isPinned ? Colors.amber : Colors.grey,
                              size: 18,
                            ),
                            onPressed: () {
                              setState(() {
                                item.isPinned = !item.isPinned;
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.grey, size: 18),
                            onPressed: () {
                              setState(() {
                                _clipboardVault.removeAt(index);
                              });
                              _triggerFloatingNotification('Clip removed from vault.');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.content,
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                        softWrap: true,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.teal,
                              side: const BorderSide(color: Colors.teal, width: 1),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            ),
                            onPressed: () {
                              _triggerFloatingNotification('Copied snippet to OS Clipboard!');
                            },
                            icon: const Icon(Icons.content_copy, size: 12),
                            label: const Text('Copy Quick', style: TextStyle(fontSize: 10)),
                          ),
                        ],
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

  // TAB 3: SMART TEXT SUMMARIZER & PARSER
  Widget _buildSmartSummarizerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Smart Summarizer',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Paste long messages, terms of service, or news articles to extract core takeaways without reading whole paragraphs.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _summarizerController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: const InputDecoration(
              hintText: 'Paste long text here to summarize...',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
              filled: true,
              fillColor: Color(0xFF1E2631),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Colors.teal),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _isSummarizing
                      ? null
                      : () {
                          if (_summarizerController.text.trim().isEmpty) {
                            _triggerFloatingNotification('Please paste or type text to summarize!');
                            return;
                          }
                          setState(() {
                            _isSummarizing = true;
                          });

                          Future.delayed(const Duration(milliseconds: 900), () {
                            if (mounted) {
                              final raw = _summarizerController.text.trim();
                              final words = raw.split(' ');
                              final keyPoint = words.length > 5 ? words.sublist(0, 5).join(' ') : raw;

                              setState(() {
                                _isSummarizing = false;
                                _summarizedOutput =
                                    '• Key Takeaway: "$keyPoint..."\n• Reading Time Saved: ~${(words.length / 40).ceil()} min\n• Sentiment: Informative / Neutral\n• Actionable Points: Check constraints & copy parameters into Floating Deck.';
                              });
                              _triggerFloatingNotification('Summary ready!');
                            }
                          });
                        },
                  icon: _isSummarizing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.bolt, size: 18),
                  label: Text(_isSummarizing ? 'Processing...' : 'Summarize Instantly', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                style: IconButton.styleFrom(backgroundColor: const Color(0xFF1E2631)),
                icon: const Icon(Icons.refresh, color: Colors.grey),
                onPressed: () {
                  _summarizerController.clear();
                  setState(() {
                    _summarizedOutput = '';
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_summarizedOutput.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2D37),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.teal, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Smart Summary Result',
                        style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white70, height: 16),
                  Text(
                    _summarizedOutput,
                    style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.5),
                    softWrap: true,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                      onPressed: () {
                        _addClipboardSnippet(_summarizedOutput, 'Summary');
                      },
                      icon: const Icon(Icons.content_copy, size: 14),
                      label: const Text('Save to Clip Vault', style: TextStyle(fontSize: 11)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // TAB 4: QUICK UTILITIES (Currency Swap & Floating Notes)
  Widget _buildQuickUtilitiesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Micro-Utilities',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Instant quick tools ready to trigger on screen over any application.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Instant Currency/Unit Swapper Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2631),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Instant Currency / Unit Swap',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                          prefixText: '\$ ',
                          prefixStyle: const TextStyle(color: Colors.teal),
                          filled: true,
                          fillColor: const Color(0xFF12181F),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _inputAmount = double.tryParse(val) ?? 0.0;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF12181F),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white70),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Converted Value', style: TextStyle(color: Colors.grey, fontSize: 10)),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '€${(_inputAmount * 0.925).toStringAsFixed(2)} EUR',
                                style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 15),
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

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sticky Floating Notes',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.amber, size: 24),
                onPressed: () {
                  _showQuickNoteModal(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _floatingNotes.length,
            itemBuilder: (context, idx) {
              final note = _floatingNotes[idx];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2631),
                  borderRadius: BorderRadius.circular(12),
                  border: Border(
                    left: BorderSide(color: note.color, width: 4),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            note.body,
                            style: const TextStyle(color: Colors.grey, fontSize: 11),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey, size: 18),
                      onPressed: () {
                        setState(() {
                          _floatingNotes.removeAt(idx);
                        });
                        _triggerFloatingNotification('Sticky note removed.');
                      },
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

  // TAB 5: SYSTEM SETTINGS & PERMISSIONS
  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating System Preferences',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          const Text(
            'Configure floating window permissions, sound effects, and monetization preferences.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          _buildSettingTile(
            title: 'Display Above Other Apps',
            subtitle: 'SYSTEM_ALERT_WINDOW active. Allows floating deck to sit over mobile screen.',
            icon: Icons.layers,
            trailing: const Icon(Icons.check_circle, color: Colors.teal),
          ),
          _buildSettingTile(
            title: 'Auto Clipboard Monitor',
            subtitle: 'Automatically copy new clipboard items directly into Floating Vault.',
            icon: Icons.content_copy,
            trailing: Switch(
              value: true,
              activeColor: Colors.teal,
              onChanged: (v) {},
            ),
          ),
          _buildSettingTile(
            title: 'Interactive Toast Banners',
            subtitle: 'Show floating quick notification updates at top of active apps.',
            icon: Icons.notifications,
            trailing: Switch(
              value: _showNotificationBanner,
              activeColor: Colors.teal,
              onChanged: (v) {
                setState(() {
                  _showNotificationBanner = v;
                });
              },
            ),
          ),
          _buildSettingTile(
            title: 'Monetization & AdMob Integration',
            subtitle: 'Simulated passive AdMob banner placement for future monetization.',
            icon: Icons.monetization_on,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(6)),
              child: const Text('READY', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2631),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.teal.withOpacity(0.15),
            child: Icon(icon, color: Colors.teal, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                  softWrap: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          trailing,
        ],
      ),
    );
  }

  // Quick Modal Dialogs
  void _showAddClipModal(BuildContext context) {
    final controller = TextEditingController();
    String category = 'General';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF161D26),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Snippet to Vault',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 3,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Enter promo code, URL, or text note...',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF1E2631),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size(double.infinity, 44),
                ),
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    _addClipboardSnippet(controller.text, category);
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Save Snippet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showQuickNoteModal(BuildContext context) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF161D26),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Sticky Floating Note',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Note Title',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF1E2631),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: bodyController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Note Details...',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF1E2631),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 44),
                ),
                onPressed: () {
                  if (titleController.text.isNotEmpty || bodyController.text.isNotEmpty) {
                    setState(() {
                      _floatingNotes.add(
                        FloatingNote(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: titleController.text.isEmpty ? 'Untitled Note' : titleController.text,
                          body: bodyController.text,
                          color: Colors.amber,
                          updatedAt: DateTime.now(),
                        ),
                      );
                    });
                    _triggerFloatingNotification('Sticky Note added to deck!');
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Add Sticky Note', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }
}