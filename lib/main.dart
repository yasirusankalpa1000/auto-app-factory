import 'package:flutter/material.dart';

void main() {
  runApp(const BubbleDockApp());
}

class BubbleDockApp extends StatelessWidget {
  const BubbleDockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BubbleDock Utility',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
          primary: Colors.indigo,
          secondary: Colors.cyan,
          surface: const Color(0xFFF4F6FA),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 2),
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

  // Global App States
  bool _overlayPermissionGranted = true;
  bool _floatingNotificationActive = true;
  bool _clipboardListenerActive = true;
  
  // Floating Position for Bubble Simulation
  Offset _bubblePosition = const Offset(120, 200);

  // Multi-Clipboard Vault
  final TextEditingController _clipboardInputController = TextEditingController();
  final List<Map<String, String>> _vaultClips = [
    {
      'id': '1',
      'title': 'Wi-Fi Password & Router IP',
      'content': 'SSID: Home_Guest_5G | Pass: SecurePass2025! | IP: 192.168.1.1',
      'tag': 'Credentials'
    },
    {
      'id': '2',
      'title': 'Delivery Address Snippet',
      'content': '124, Station Road, Apartment 4B, Central District, Phone: +1 555-0199',
      'tag': 'Address'
    },
  ];

  // Floating Sticky Notes System
  final List<String> _stickyNotes = [
    "📌 Order grocery pick-up at 5 PM",
    "⚡ Gate Code: 8842#",
  ];
  final TextEditingController _newStickyController = TextEditingController();

  // Split Bill Calculations
  final TextEditingController _billAmountController = TextEditingController(text: "120.00");
  final TextEditingController _peopleCountController = TextEditingController(text: "4");
  final TextEditingController _tipPercentController = TextEditingController(text: "10");
  double _totalPerPerson = 33.00;
  double _tipTotal = 12.00;

  // Decision Engine Options
  final TextEditingController _decisionTopicController = TextEditingController();
  final List<Map<String, dynamic>> _decisionOptions = [
    {'name': 'Option A: Cook at Home', 'score': 8},
    {'name': 'Option B: Order Takeout', 'score': 5},
  ];
  String _decisionResult = "Add options and calculate best micro-choice!";

  @override
  void dispose() {
    _clipboardInputController.dispose();
    _newStickyController.dispose();
    _billAmountController.dispose();
    _peopleCountController.dispose();
    _tipPercentController.dispose();
    _decisionTopicController.dispose();
    super.dispose();
  }

  void _recalculateBill() {
    final double bill = double.tryParse(_billAmountController.text) ?? 0.0;
    final int people = int.tryParse(_peopleCountController.text) ?? 1;
    final double tip = double.tryParse(_tipPercentController.text) ?? 0.0;

    if (people > 0) {
      setState(() {
        _tipTotal = bill * (tip / 100);
        _totalPerPerson = (bill + _tipTotal) / (people <= 0 ? 1 : people);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.widgets, color: Colors.indigo),
            SizedBox(width: 10),
            Text(
              "BubbleDock",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _floatingNotificationActive ? Icons.notifications_active : Icons.notifications_off,
              color: _floatingNotificationActive ? Colors.green : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _floatingNotificationActive = !_floatingNotificationActive;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_floatingNotificationActive
                      ? "Floating Notification Bar Activated!"
                      : "Floating Notification Bar Paused."),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            tooltip: "Toggle Floating Notification HUD",
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildFloatingDockHub(),
                _buildMultiClipboardTab(),
                _buildDecisionEngineTab(),
                _buildQuickSplitTab(),
                _buildFloatingStickyHUDTab(),
              ],
            ),
          ),
          
          // Simulated Draggable System Overlay Floating Bubble
          if (_overlayPermissionGranted)
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetectingOverlayBubble(
                onPanUpdate: (details) {
                  setState(() {
                    _bubblePosition += details.delta;
                  });
                },
                onTap: () {
                  _showQuickOverlaySheet(context);
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.layers),
            selectedIcon: Icon(Icons.layers, color: Colors.indigo),
            label: 'Overlay Dock',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_paste_search),
            selectedIcon: Icon(Icons.content_paste_search, color: Colors.indigo),
            label: 'Text Clip Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology),
            selectedIcon: Icon(Icons.psychology, color: Colors.indigo),
            label: 'Decision Wheel',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate),
            selectedIcon: Icon(Icons.calculate, color: Colors.indigo),
            label: 'Quick Split',
          ),
          NavigationDestination(
            icon: Icon(Icons.push_pin),
            selectedIcon: Icon(Icons.push_pin, color: Colors.indigo),
            label: 'Sticky HUD',
          ),
        ],
      ),
    );
  }

  // 1. FLOATING DOCK HUB SCREEN
  Widget _buildFloatingDockHub() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Status
          Card(
            color: Colors.indigo,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.auto_awesome, color: Colors.amber),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Floating Assistant Active",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "BubbleDock stays ready over any app. Touch the floating bubble on screen anytime for instant actions!",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        avatar: Icon(
                          _overlayPermissionGranted ? Icons.check_circle : Icons.error,
                          color: Colors.green,
                          size: 18,
                        ),
                        label: const Text("Display Above Apps: ON"),
                        backgroundColor: Colors.white,
                      ),
                      Chip(
                        avatar: Icon(
                          _floatingNotificationActive ? Icons.check_circle : Icons.pause_circle,
                          color: _floatingNotificationActive ? Colors.green : Colors.grey,
                          size: 18,
                        ),
                        label: const Text("Floating Bar: Active"),
                        backgroundColor: Colors.white,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Floating Controls Settings
          const Text(
            "System Overlay Settings",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 10),

          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: _overlayPermissionGranted,
                  activeColor: Colors.indigo,
                  title: const Text("Floating Desktop Bubble"),
                  subtitle: const Text("Show interactive quick floating bubble over all apps"),
                  onChanged: (val) {
                    setState(() {
                      _overlayPermissionGranted = val;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: _floatingNotificationActive,
                  activeColor: Colors.indigo,
                  title: const Text("Persistent Floating Banner HUD"),
                  subtitle: const Text("Keep active sticky notes pinned to top notification bar"),
                  onChanged: (val) {
                    setState(() {
                      _floatingNotificationActive = val;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: _clipboardListenerActive,
                  activeColor: Colors.indigo,
                  title: const Text("Smart Clipboard Text Extractor"),
                  subtitle: const Text("Auto-detect copied emails, URLs and numbers instantly"),
                  onChanged: (val) {
                    setState(() {
                      _clipboardListenerActive = val;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "Live Notification Bar Preview",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 10),

          // Simulated Top Notification Bar Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.bubble_chart, color: Colors.cyan, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      "BubbleDock Notification Bar",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "LIVE",
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _stickyNotes.isNotEmpty ? _stickyNotes.first : "No active pinned notes.",
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        setState(() {
                          _currentIndex = 4; // Navigate to Sticky HUD
                        });
                      },
                      child: const Text("Manage", style: TextStyle(fontSize: 11)),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. MULTI-CLIPBOARD & TEXT TRANSFORMER TAB
  Widget _buildMultiClipboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Smart Clipboard & Text Sanitizer",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Paste raw, unformatted text to sanitize spaces, extract numbers/emails, or format instantly.",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: _clipboardInputController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: "Paste text, rough thoughts, email drafts or messy lists here...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Text Action Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.cleaning_services, size: 16),
                        label: const Text("Clean Spaces"),
                        onPressed: () {
                          if (_clipboardInputController.text.isNotEmpty) {
                            setState(() {
                              _clipboardInputController.text =
                                  _clipboardInputController.text.replaceAll(RegExp(r'\s+'), ' ').trim();
                            });
                          }
                        },
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.format_list_bulleted, size: 16),
                        label: const Text("Bullet List"),
                        onPressed: () {
                          if (_clipboardInputController.text.isNotEmpty) {
                            final lines = _clipboardInputController.text.split('\n');
                            final bulleted = lines
                                .where((l) => l.trim().isNotEmpty)
                                .map((l) => '• ${l.trim()}')
                                .join('\n');
                            setState(() {
                              _clipboardInputController.text = bulleted;
                            });
                          }
                        },
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.mail_outline, size: 16),
                        label: const Text("Extract Emails/Phones"),
                        onPressed: () {
                          final text = _clipboardInputController.text;
                          final emailRegExp = RegExp(r'[a-zA-Z0-9.\-_]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
                          final phoneRegExp = RegExp(r'\+?\d[\d\-\s]{7,}\d');
                          
                          final emails = emailRegExp.allMatches(text).map((m) => m.group(0)).toList();
                          final phones = phoneRegExp.allMatches(text).map((m) => m.group(0)).toList();

                          final result = "Extracted Details:\nEmails: ${emails.isEmpty ? 'None' : emails.join(', ')}\nPhones: ${phones.isEmpty ? 'None' : phones.join(', ')}";

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result)),
                          );
                        },
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save_alt, size: 16),
                        label: const Text("Save Clip"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          if (_clipboardInputController.text.trim().isNotEmpty) {
                            setState(() {
                              _vaultClips.insert(0, {
                                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                                'title': 'Saved Clip #${_vaultClips.length + 1}',
                                'content': _clipboardInputController.text.trim(),
                                'tag': 'General'
                              });
                              _clipboardInputController.clear();
                            });
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "Saved Text Vault",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _vaultClips.length,
            itemBuilder: (context, index) {
              final clip = _vaultClips[index];
              return Card(
                child: ListTile(
                  title: Text(
                    clip['title'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      clip['content'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.indigo, size: 20),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Clip copied to system clipboard!")),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        onPressed: () {
                          setState(() {
                            _vaultClips.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  // 3. MICRO-DECISION ENGINE TAB
  Widget _buildDecisionEngineTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Micro-Decision Wheel & Choice Evaluator",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Stop overthinking minor everyday choices. Add options, assign quick scores, and let BubbleDock decide!",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          Card(
            color: Colors.indigo.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.psychology_alt, size: 40, color: Colors.indigo),
                  const SizedBox(height: 8),
                  Text(
                    _decisionResult,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text("Calculate Best Choice"),
                    onPressed: () {
                      if (_decisionOptions.isEmpty) return;
                      _decisionOptions.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
                      final winner = _decisionOptions.first;
                      setState(() {
                        _decisionResult = "💡 Winner: ${winner['name']} (Score: ${winner['score']}/10)";
                      });
                    },
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Dilemma Options",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.indigo),
                onPressed: () {
                  _showAddOptionDialog();
                },
              )
            ],
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _decisionOptions.length,
            itemBuilder: (context, index) {
              final option = _decisionOptions[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.shade100,
                    child: Text(
                      "${option['score']}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                  ),
                  title: Text(option['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _decisionOptions.removeAt(index);
                      });
                    },
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void _showAddOptionDialog() {
    final TextEditingController nameCtrl = TextEditingController();
    double scoreVal = 5.0;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Add Option to Decision"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: "Option Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text("Preference Score: ${scoreVal.round()}/10"),
                  Slider(
                    value: scoreVal,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    activeColor: Colors.indigo,
                    onChanged: (val) {
                      setDialogState(() {
                        scoreVal = val;
                      });
                    },
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                  onPressed: () {
                    if (nameCtrl.text.trim().isNotEmpty) {
                      setState(() {
                        _decisionOptions.add({
                          'name': nameCtrl.text.trim(),
                          'score': scoreVal.round(),
                        });
                      });
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 4. QUICK SPLIT & UTILITY TAB
  Widget _buildQuickSplitTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Instant Bill Split & Share Generator",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Calculate per-person shares with tax & tip instantly, then copy output directly into group chats.",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _billAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Total Bill Amount (\$) ",
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _recalculateBill(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _peopleCountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "People Count",
                            prefixIcon: Icon(Icons.people),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => _recalculateBill(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _tipPercentController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Tip %",
                            prefixIcon: Icon(Icons.percent),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => _recalculateBill(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            color: Colors.teal.shade700,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    "EACH PERSON PAYS",
                    style: TextStyle(color: Colors.white70, letterSpacing: 1.2, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "\$${_totalPerPerson.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.white70),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Tip: \$${_tipTotal.toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.teal.shade900,
                        ),
                        icon: const Icon(Icons.share, size: 16),
                        label: const Text("Copy Summary"),
                        onPressed: () {
                          final summary = "🧾 Bill Split Summary:\nTotal: \$${_billAmountController.text}\nPeople: ${_peopleCountController.text}\nTip: ${_tipPercentController.text}%\n👉 Each Person Pays: \$${_totalPerPerson.toStringAsFixed(2)}";
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Formatted summary copied:\n$summary")),
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // 5. FLOATING STICKY NOTES & HUD TAB
  Widget _buildFloatingStickyHUDTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Persistent Sticky Notes HUD",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Pinned notes stay visible inside the top simulated Floating Notification Bar for rapid access.",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _newStickyController,
                      decoration: const InputDecoration(
                        hintText: "New pinned note (e.g., Gate Pass, Code, Grocery)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    ),
                    onPressed: () {
                      if (_newStickyController.text.trim().isNotEmpty) {
                        setState(() {
                          _stickyNotes.insert(0, "📌 ${_newStickyController.text.trim()}");
                          _newStickyController.clear();
                        });
                      }
                    },
                    child: const Icon(Icons.pin_end),
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "Active Pinned HUD Notes",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _stickyNotes.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.push_pin, color: Colors.indigo),
                  title: Text(_stickyNotes[index], style: const TextStyle(fontWeight: FontWeight.w600)),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _stickyNotes.removeAt(index);
                      });
                    },
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  // Quick Overlay Bottom Sheet Simulation
  void _showQuickOverlaySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.widgets, color: Colors.indigo),
                  SizedBox(width: 8),
                  Text(
                    "BubbleDock Quick Floating Companion",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.content_paste, color: Colors.indigo),
                title: const Text("Paste & Sanitize Text"),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _currentIndex = 1);
                },
              ),
              ListTile(
                leading: const Icon(Icons.psychology, color: Colors.indigo),
                title: const Text("Make Micro-Decision"),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _currentIndex = 2);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calculate, color: Colors.indigo),
                title: const Text("Quick Split Bill"),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _currentIndex = 3);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// Simulated Draggable Floating Overlay Widget
class GestureDetectingOverlayBubble extends StatelessWidget {
  final Function(DragUpdateDetails) onPanUpdate;
  final VoidCallback onTap;

  const GestureDetectingOverlayBubble({
    super.key,
    required this.onPanUpdate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onPanUpdate,
      onTap: onTap,
      child: Material(
        elevation: 8,
        shape: const CircleBorder(),
        color: Colors.transparent,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Colors.indigo, Colors.cyan],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(2, 4),
              )
            ],
          ),
          child: const Icon(
            Icons.widgets,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}