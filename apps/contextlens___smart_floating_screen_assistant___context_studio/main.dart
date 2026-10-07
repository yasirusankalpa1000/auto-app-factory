import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ContextLensApp());
}

class ContextLensApp extends StatelessWidget {
  const ContextLensApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ContextLens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class PinNoteItem {
  final String id;
  String title;
  String content;
  Color accentColor;
  double opacity;
  bool isPinned;

  PinNoteItem({
    required this.id,
    required this.title,
    required this.content,
    required this.accentColor,
    this.opacity = 0.85,
    this.isPinned = true,
  });
}

class SmartExtractedItem {
  final String label;
  final String value;
  final IconData icon;
  final String actionName;

  SmartExtractedItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.actionName,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;

  // System & Permission states
  bool _overlayPermissionGranted = true;
  bool _floatingBubbleEnabled = true;
  bool _autoClipboardDetect = true;
  bool _floatingToastEnabled = true;

  // Interactive Floating Overlay Bubble offset state
  Offset _bubbleOffset = const Offset(20, 160);
  bool _isFloatingMenuOpen = false;
  String _activeToastBanner = "";

  // Smart Crafter State
  final TextEditingController _replyInputController = TextEditingController(
    text: "Macho can you check this report and call me back around 5 PM?",
  );
  String _selectedTone = 'Casual Singlish';
  String _selectedPlatform = 'WhatsApp';
  double _responseLength = 0.5;
  double _energyLevel = 0.7;
  List<String> _generatedReplies = [];

  // Clipboard Vault State
  final TextEditingController _clipboardInputController = TextEditingController(
    text: "Hey check this item at https://shop.example.com/item/402 or call support +94 77 123 4567. Price is \$49.99! Email refund@example.com",
  );
  List<SmartExtractedItem> _extractedItems = [];

  // Floating Pins Vault State
  final List<PinNoteItem> _pinnedNotes = [
    PinNoteItem(
      id: '1',
      title: 'WhatsApp Quick Ref',
      content: 'Meeting passcode: 884900 | Zoom ID: 402-120-99',
      accentColor: Colors.teal,
      opacity: 0.9,
    ),
    PinNoteItem(
      id: '2',
      title: 'Shopping Price Target',
      content: 'Limit budget to \$55.00 max for wireless earbuds.',
      accentColor: Colors.purple,
      opacity: 0.8,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _parseClipboardText(_clipboardInputController.text);
    _generateSmartReplies();
  }

  @override
  void dispose() {
    _replyInputController.dispose();
    _clipboardInputController.dispose();
    super.dispose();
  }

  void _showFloatingToast(String message) {
    setState(() {
      _activeToastBanner = message;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _activeToastBanner == message) {
        setState(() {
          _activeToastBanner = "";
        });
      }
    });
  }

  void _generateSmartReplies() {
    final input = _replyInputController.text.trim();
    if (input.isEmpty) {
      setState(() {
        _generatedReplies = ["Please enter a message to generate contextual replies."];
      });
      return;
    }

    List<String> replies = [];
    if (_selectedTone == 'Casual Singlish') {
      replies = [
        "Hari macho! I will check the report now and call you right around 5 PM.",
        "Ela bro, almost done reading it. Will phone you at 5 sharp!",
        "Poddak inna, text message eka dakka. 5 PM venakota call ekak dennam!"
      ];
    } else if (_selectedTone == 'Professional') {
      replies = [
        "Received with thanks. I am currently reviewing the document and will phone you at 5:00 PM.",
        "Acknowledged. I will examine the details carefully and reach out to you by 5 PM today.",
        "Thank you for sharing. I will analyze the report shortly and dial in at 5 PM."
      ];
    } else if (_selectedTone == 'Polite Reject') {
      replies = [
        "Thanks for sending! I am tied up in meetings till evening, but will review this early tomorrow.",
        "I won't be able to review this before 5 PM today, but I will get back to you as soon as I am free.",
        "Appreciate it! Schedule is packed today, can we discuss this over brief call tomorrow morning?"
      ];
    } else {
      // Friendly
      replies = [
        "Sure thing! Checking it right away and will call you at 5 PM!",
        "Got it! Let me glance through it real quick. Speak to you at 5!",
        "Sounds like a plan! Talk to you at 5 PM buddy."
      ];
    }

    setState(() {
      _generatedReplies = replies;
    });
  }

  void _parseClipboardText(String text) {
    List<SmartExtractedItem> items = [];

    // Extract Links
    final urlRegExp = RegExp(r'https?://[^\s]+');
    final urlMatches = urlRegExp.allMatches(text);
    for (var match in urlMatches) {
      items.add(SmartExtractedItem(
        label: 'Web Link',
        value: match.group(0) ?? '',
        icon: Icons.link,
        actionName: 'Open URL',
      ));
    }

    // Extract Phone Numbers
    final phoneRegExp = RegExp(r'\+?\d[\d\s-]{7,13}\d');
    final phoneMatches = phoneRegExp.allMatches(text);
    for (var match in phoneMatches) {
      items.add(SmartExtractedItem(
        label: 'Phone Contact',
        value: match.group(0) ?? '',
        icon: Icons.phone,
        actionName: 'Call / WhatsApp',
      ));
    }

    // Extract Emails
    final emailRegExp = RegExp(r'[\w-\.]+@([\w-]+\.)+[\w-]{2,4}');
    final emailMatches = emailRegExp.allMatches(text);
    for (var match in emailMatches) {
      items.add(SmartExtractedItem(
        label: 'Email Address',
        value: match.group(0) ?? '',
        icon: Icons.email,
        actionName: 'Draft Mail',
      ));
    }

    // Extract Currency / Monetary Values
    final priceRegExp = RegExp(r'(\$|Rs\.?|LKR)\s?\d+(\.\d{1,2})?');
    final priceMatches = priceRegExp.allMatches(text);
    for (var match in priceMatches) {
      items.add(SmartExtractedItem(
        label: 'Detected Price',
        value: match.group(0) ?? '',
        icon: Icons.monetization_on,
        actionName: 'Convert / Compare',
      ));
    }

    setState(() {
      _extractedItems = items;
    });
  }

  void _addNewPinDialog() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    Color selectedColor = Colors.teal;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E293B),
              title: const Text('New Floating Screen Pin', style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Pin Title',
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
                        labelText: 'Screen Note / Snippet',
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Color: ', style: TextStyle(color: Colors.white70)),
                        const SizedBox(width: 8),
                        Wrap(
                          spacing: 6,
                          children: [Colors.teal, Colors.indigo, Colors.purple, Colors.orange, Colors.red].map((c) {
                            return GestureDetector(
                              onTap: () {
                                setDialogState(() {
                                  selectedColor = c;
                                });
                              },
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: c,
                                child: selectedColor == c
                                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                                    : null,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      setState(() {
                        _pinnedNotes.add(PinNoteItem(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: titleController.text,
                          content: bodyController.text,
                          accentColor: selectedColor,
                        ));
                      });
                      _showFloatingToast("Pinned note hover card active!");
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Pin to Overlay', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Body Screen Views
          SafeArea(
            child: Column(
              children: [
                // Header Bar
                _buildTopAppBar(),

                // Active Tab View Content
                Expanded(
                  child: _buildSelectedTabBody(),
                ),
              ],
            ),
          ),

          // Floating System Toast Simulation Banner
          if (_activeToastBanner.isNotEmpty)
            Positioned(
              top: 70,
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _activeToastBanner.isNotEmpty ? 1.0 : 0.0,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.indigo.shade700,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.flash_on, color: Colors.amber, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _activeToastBanner,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70, size: 18),
                          onPressed: () {
                            setState(() {
                              _activeToastBanner = "";
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Interactive Draggable Floating Overlay Assistant Bubble Simulator
          if (_floatingBubbleEnabled)
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
                    _isFloatingMenuOpen = !_isFloatingMenuOpen;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade600,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.shade900.withOpacity(0.6),
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: const Icon(Icons.auto_awesome, color: Colors.amber, size: 28),
                    ),
                    if (_isFloatingMenuOpen) ...[
                      const SizedBox(height: 8),
                      Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFF1E293B),
                        child: Container(
                          width: 220,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.indigo.shade400, width: 1.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.layers, color: Colors.teal, size: 18),
                                  const SizedBox(width: 6),
                                  const Expanded(
                                    child: Text(
                                      'ContextLens Dock',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isFloatingMenuOpen = false;
                                      });
                                    },
                                    child: const Icon(Icons.close, color: Colors.grey, size: 16),
                                  ),
                                ],
                              ),
                              const Divider(color: Colors.white70, height: 16),
                              _buildOverlayMenuItem(
                                icon: Icons.chat,
                                label: 'Smart Reply Draft',
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = 1;
                                    _isFloatingMenuOpen = false;
                                  });
                                },
                              ),
                              _buildOverlayMenuItem(
                                icon: Icons.content_paste,
                                label: 'Parse Clipboard',
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = 2;
                                    _isFloatingMenuOpen = false;
                                  });
                                },
                              ),
                              _buildOverlayMenuItem(
                                icon: Icons.push_pin,
                                label: 'Active Pins (${_pinnedNotes.length})',
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = 3;
                                    _isFloatingMenuOpen = false;
                                  });
                                },
                              ),
                              _buildOverlayMenuItem(
                                icon: Icons.flash_on,
                                label: 'Trigger Floating Banner',
                                onTap: () {
                                  _showFloatingToast("Overlay active over background apps!");
                                  setState(() {
                                    _isFloatingMenuOpen = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0F172A),
        selectedItemColor: Colors.indigo.shade300,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Overlay Dock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'Smart Reply',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: 'Clip Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.push_pin),
            label: 'Screen Pins',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(bottom: BorderSide(color: Colors.white70)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo.shade700,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.layers, color: Colors.amber, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ContextLens Studio',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Floating Screen Assistant & Context Engine',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _overlayPermissionGranted ? Colors.teal.shade900 : Colors.red.shade900,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _overlayPermissionGranted ? Colors.teal : Colors.red,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _overlayPermissionGranted ? Icons.check : Icons.info,
                  color: Colors.white,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  _overlayPermissionGranted ? 'OVERLAY ON' : 'OFF',
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: Colors.indigo.shade200, size: 16),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedTabBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildOverlayDockHome();
      case 1:
        return _buildSmartReplyCrafter();
      case 2:
        return _buildClipboardVaultView();
      case 3:
        return _buildScreenPinsView();
      case 4:
        return _buildSettingsView();
      default:
        return _buildOverlayDockHome();
    }
  }

  // TAB 1: OVERLAY DOCK HOME
  Widget _buildOverlayDockHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Status Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade800, Colors.purple.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.stars, color: Colors.amber, size: 24),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Floating Assistant Active',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'ContextLens hovers directly on your screen. Tap the glowing purple lens icon anytime to generate quick replies, read active clipboards, or hover pinned screen memos over social apps!',
                  style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        _showFloatingToast("Simulating foreground overlay assistant!");
                      },
                      icon: const Icon(Icons.flash_on, size: 16),
                      label: const Text('Test Overlay Toast', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white70),
                      ),
                      onPressed: () {
                        setState(() {
                          _floatingBubbleEnabled = !_floatingBubbleEnabled;
                        });
                      },
                      icon: Icon(_floatingBubbleEnabled ? Icons.visibility_off : Icons.visibility, size: 16),
                      label: Text(_floatingBubbleEnabled ? 'Hide Bubble' : 'Show Bubble'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Quick Feature Tools',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Tools Grid Cards
          Row(
            children: [
              Expanded(
                child: _buildQuickToolCard(
                  title: 'Smart Reply Crafter',
                  subtitle: 'Tone-matched instant response generator',
                  icon: Icons.auto_awesome,
                  color: Colors.teal,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickToolCard(
                  title: 'Clipboard Vault',
                  subtitle: 'Auto parser for links, phone, prices',
                  icon: Icons.content_paste,
                  color: Colors.purple,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickToolCard(
                  title: 'Screen Pins Studio',
                  subtitle: 'Hover glassmorphism sticky cards',
                  icon: Icons.push_pin,
                  color: Colors.orange,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 3;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickToolCard(
                  title: 'Overlay Permissions',
                  subtitle: 'Configure display over apps & toasts',
                  icon: Icons.build,
                  color: Colors.indigo,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 4;
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Text(
            'Active Hover Screen Pins Preview',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          if (_pinnedNotes.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'No pinned screen notes yet. Go to Screen Pins tab to add hover cards!',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            )
          else
            Column(
              children: _pinnedNotes.map((note) => _buildPinnedNotePreviewCard(note)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickToolCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white70),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: SMART REPLY CRAFTER
  Widget _buildSmartReplyCrafter() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.shade700),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Context-Aware Smart Reply Engine: Paste any message or chat text to craft optimal localized replies.',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Received Message / Situation Context',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _replyInputController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Paste WhatsApp message, email excerpt, or chat text here...',
              hintStyle: const TextStyle(color: Colors.white70, fontSize: 12),
              fillColor: const Color(0xFF1E293B),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white70),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Tone Selection Chips
          const Text(
            'Select Target Tone',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: ['Casual Singlish', 'Friendly', 'Professional', 'Polite Reject'].map((tone) {
              final isSelected = _selectedTone == tone;
              return ChoiceChip(
                label: Text(
                  tone,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
                selected: isSelected,
                selectedColor: Colors.indigo,
                backgroundColor: const Color(0xFF1E293B),
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      _selectedTone = tone;
                    });
                    _generateSmartReplies();
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // Target App Platform
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Target Platform:',
                  style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              DropdownButton<String>(
                value: _selectedPlatform,
                dropdownColor: const Color(0xFF1E293B),
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                items: ['WhatsApp', 'Instagram', 'Email', 'Telegram', 'Work Slack'].map((p) {
                  return DropdownMenuItem(value: p, child: Text(p));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedPlatform = val;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Sliders for Length & Energy
          Row(
            children: [
              const Text('Response Length: ', style: TextStyle(color: Colors.white70, fontSize: 11)),
              Expanded(
                child: Slider(
                  value: _responseLength,
                  activeColor: Colors.indigo,
                  onChanged: (val) {
                    setState(() {
                      _responseLength = val;
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.all(14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _generateSmartReplies,
              icon: const Icon(Icons.auto_awesome, color: Colors.amber, size: 18),
              label: const Text(
                'Craft Dynamic Responses',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Generated Smart Options',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),

          Column(
            children: _generatedReplies.asMap().entries.map((entry) {
              final idx = entry.key;
              final reply = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white70),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.indigo,
                          child: Text('${idx + 1}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Option ${idx + 1} ($_selectedTone)',
                            style: const TextStyle(color: Colors.indigoAccent, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      reply,
                      style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
                      softWrap: true,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            foregroundColor: Colors.tealAccent,
                            side: const BorderSide(color: Colors.teal),
                          ),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: reply));
                            _showFloatingToast("Copied to clipboard! Ready to paste.");
                          },
                          icon: const Icon(Icons.copy, size: 14),
                          label: const Text('Copy Text', style: TextStyle(fontSize: 11)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          ),
                          onPressed: () {
                            setState(() {
                              _pinnedNotes.add(PinNoteItem(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                title: 'Reply Snippet #${idx + 1}',
                                content: reply,
                                accentColor: Colors.teal,
                              ));
                            });
                            _showFloatingToast("Pinned reply to screen hover card!");
                          },
                          icon: const Icon(Icons.push_pin, color: Colors.white, size: 14),
                          label: const Text('Pin to Screen', style: TextStyle(color: Colors.white, fontSize: 11)),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // TAB 3: CLIPBOARD VAULT & PARSER
  Widget _buildClipboardVaultView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Clipboard Text Analyzer',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 6),
          const Text(
            'Automatically extracts actionable web URLs, phone numbers, email addresses, and price quotes.',
            style: TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _clipboardInputController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            onChanged: (val) {
              _parseClipboardText(val);
            },
            decoration: InputDecoration(
              fillColor: const Color(0xFF1E293B),
              filled: true,
              labelText: 'Input / Clipboard Stream',
              labelStyle: const TextStyle(color: Colors.white70),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple.shade700),
                  onPressed: () {
                    _parseClipboardText(_clipboardInputController.text);
                    _showFloatingToast("Re-analyzed clipboard input!");
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white, size: 16),
                  label: const Text('Analyze Stream', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Colors.white70),
                ),
                onPressed: () {
                  _clipboardInputController.clear();
                  setState(() {
                    _extractedItems.clear();
                  });
                },
                icon: const Icon(Icons.delete, size: 16),
                label: const Text('Clear', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Text(
            'Extracted Smart Items (${_extractedItems.length})',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),

          if (_extractedItems.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'No actionable items detected yet. Type or paste links, phone numbers, or monetary values above!',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            Column(
              children: _extractedItems.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white70),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item.icon, color: Colors.purple.shade200, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.label,
                              style: const TextStyle(color: Colors.purpleAccent, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.value,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: item.value));
                          _showFloatingToast("Copied ${item.label} to clipboard!");
                        },
                        child: Text(
                          item.actionName,
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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

  // TAB 4: SCREEN PINS STUDIO
  Widget _buildScreenPinsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
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
                      'Floating Memo Pins Studio',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Hover notes that stay visible over active app tasks',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: _addNewPinDialog,
                icon: const Icon(Icons.add, color: Colors.white, size: 16),
                label: const Text('New Pin', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (_pinnedNotes.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'No floating memo cards created. Click "New Pin" above to create sticky notes on your screen overlay!',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            Column(
              children: _pinnedNotes.map((note) => _buildFullNoteCard(note)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildPinnedNotePreviewCard(PinNoteItem note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: note.accentColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: note.accentColor.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.push_pin, color: note.accentColor, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${note.title}: ${note.content}',
              style: const TextStyle(color: Colors.white, fontSize: 11),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullNoteCard(PinNoteItem note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: note.accentColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 6,
                backgroundColor: note.accentColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  note.title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.grey, size: 18),
                onPressed: () {
                  setState(() {
                    _pinnedNotes.removeWhere((item) => item.id == note.id);
                  });
                  _showFloatingToast("Removed pinned screen memo.");
                },
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            note.content,
            style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.3),
            softWrap: true,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Hover Transparency: ${(note.opacity * 100).toInt()}%',
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
              const Spacer(),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: note.content));
                  _showFloatingToast("Copied note text to clipboard!");
                },
                icon: const Icon(Icons.copy, size: 12),
                label: const Text('Copy', style: TextStyle(fontSize: 10)),
              ),
            ],
          )
        ],
      ),
    );
  }

  // TAB 5: SETTINGS & PERMISSION CONTROL CENTER
  Widget _buildSettingsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overlay Settings & Permissions',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          const Text(
            'Manage display over apps permissions, haptics, and system toast triggers.',
            style: TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 16),

          _buildSwitchSettingTile(
            title: 'Display Over Apps Permission',
            subtitle: 'Allows floating assistant lens to stay on screen over background apps',
            icon: Icons.layers,
            value: _overlayPermissionGranted,
            onChanged: (val) {
              setState(() {
                _overlayPermissionGranted = val;
              });
              _showFloatingToast(val ? "Overlay permission granted!" : "Overlay permission disabled!");
            },
          ),
          _buildSwitchSettingTile(
            title: 'Floating Assistant Bubble Widget',
            subtitle: 'Show draggable quick lens bubble dock on screen',
            icon: Icons.auto_awesome,
            value: _floatingBubbleEnabled,
            onChanged: (val) {
              setState(() {
                _floatingBubbleEnabled = val;
              });
            },
          ),
          _buildSwitchSettingTile(
            title: 'Auto Clipboard Monitor',
            subtitle: 'Detect web links and contacts copied from other apps',
            icon: Icons.content_paste,
            value: _autoClipboardDetect,
            onChanged: (val) {
              setState(() {
                _autoClipboardDetect = val;
              });
            },
          ),
          _buildSwitchSettingTile(
            title: 'Floating Glass Banner Toast',
            subtitle: 'Display foreground floating status notifications',
            icon: Icons.notifications,
            value: _floatingToastEnabled,
            onChanged: (val) {
              setState(() {
                _floatingToastEnabled = val;
              });
            },
          ),

          const SizedBox(height: 20),
          const Text(
            'Usage Statistics Studio',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white70),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('42', 'Replies Crafted'),
                Container(height: 30, width: 1, color: Colors.white70),
                _buildStatColumn('128', 'Items Parsed'),
                Container(height: 30, width: 1, color: Colors.white70),
                _buildStatColumn('${_pinnedNotes.length}', 'Active Pins'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchSettingTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.indigo.shade200, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: Colors.indigoAccent,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String val, String label) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }
}