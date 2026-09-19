import 'package:flutter/material.dart';

void main() {
  runApp(const SmartAssistApp());
}

class SmartAssistApp extends StatelessWidget {
  const SmartAssistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floating Hub: Smart Assist Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
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

  // Global Interactive Floating State
  Offset _bubblePosition = const Offset(20, 180);
  bool _isBubbleExpanded = false;
  bool _isOverlayEnabled = true;
  bool _showFloatingBanner = true;
  String _activeNotificationText = "Smart Assist Active: Tap bubble for fast clip & tools";

  // Clipboard Data
  final List<Map<String, String>> _clipboardVault = [
    {
      'title': 'Meeting Zoom Link',
      'content': 'https://zoom.us/j/9876543210?pwd=samplepasscode123',
      'tag': 'Link'
    },
    {
      'title': 'Client Quick Reply',
      'content': 'Hey! Thanks for reaching out. I am currently reviewing your inquiry and will update you shortly.',
      'tag': 'Reply'
    },
    {
      'title': 'WiFi Password',
      'content': 'SecureHomeNet#2025!',
      'tag': 'Key'
    },
  ];

  // Text Transformer Controller
  final TextEditingController _textTransformController = TextEditingController();
  String _transformedResult = "";

  // Micro Calc State
  String _calcInput = "";
  String _calcResult = "0";
  final List<String> _calcHistory = [];

  // Dynamic Sticky Notes
  final List<Map<String, String>> _stickyNotes = [
    {'title': 'Pay Utility Bills', 'desc': 'Electricity & Internet due tomorrow', 'color': 'amber'},
    {'title': 'Groceries List', 'desc': 'Milk, Coffee beans, Almonds, Fruits', 'color': 'teal'},
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildFloatingOverlayStudioPage(),
      _buildClipboardVaultPage(),
      _buildTextTransformerPage(),
      _buildMicroCalcPage(),
      _buildStickyDockPage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Page Content
            pages[_currentIndex],

            // Simulated Floating Banner Notification
            if (_isOverlayEnabled && _showFloatingBanner)
              Positioned(
                top: 10,
                left: 12,
                right: 12,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.indigo.shade900,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.indigoAccent.shade100, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_active, color: Colors.amber, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _activeNotificationText,
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70, size: 18),
                          onPressed: () {
                            setState(() {
                              _showFloatingBanner = false;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

            // Simulated Interactive Draggable Floating Bubble Overlay
            if (_isOverlayEnabled)
              Positioned(
                left: _bubblePosition.dx,
                top: _bubblePosition.dy,
                child: GestureDetecorOverlayBall(
                  isExpanded: _isBubbleExpanded,
                  onPanUpdate: (details) {
                    setState(() {
                      _bubblePosition += details.delta;
                    });
                  },
                  onTapBubble: () {
                    setState(() {
                      _isBubbleExpanded = !_isBubbleExpanded;
                    });
                  },
                  onActionSelected: (actionName) {
                    setState(() {
                      _isBubbleExpanded = false;
                      _activeNotificationText = "Executed: $actionName";
                      _showFloatingBanner = true;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.indigoAccent,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.widgets), label: 'Overlay'),
          BottomNavigationBarItem(icon: Icon(Icons.content_paste), label: 'Clip Vault'),
          BottomNavigationBarItem(icon: Icon(Icons.text_format), label: 'Text Tools'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Quick Calc'),
          BottomNavigationBarItem(icon: Icon(Icons.note_alt), label: 'Sticky Dock'),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // TAB 1: OVERLAY STUDIO & INTERACTIVE SIMULATOR
  // ----------------------------------------------------
  Widget _buildFloatingOverlayStudioPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 70, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBadge('LIVE OVERLAY DECK', Icons.layers, Colors.indigoAccent),
          const SizedBox(height: 10),
          const Text(
            'Interactive Screen Companion',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'Drag the floating bubble anywhere on screen. Tap to launch micro contextual tools without leaving your primary app.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Master Controls Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.smart_button, color: Colors.teal),
                        SizedBox(width: 10),
                        Text('Enable Floating Overlay Ball', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Switch(
                      value: _isOverlayEnabled,
                      activeColor: Colors.teal,
                      onChanged: (val) {
                        setState(() {
                          _isOverlayEnabled = val;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(color: Colors.white70, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.notifications_active, color: Colors.amber),
                        SizedBox(width: 10),
                        Text('Floating Status Bar Banner', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Switch(
                      value: _showFloatingBanner,
                      activeColor: Colors.amber,
                      onChanged: (val) {
                        setState(() {
                          _showFloatingBanner = val;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Quick Action Launch Grid Simulation
          const Text(
            'Quick Overlay Trigger Shortcuts',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildQuickTriggerCard(
                'Auto Paste Snippet',
                'Instantly grabs latest dynamic clip',
                Icons.copy,
                Colors.blue,
                () {
                  _triggerOverlayBanner('Clipboard content copied to active text buffer!');
                },
              ),
              _buildQuickTriggerCard(
                'Speed Clean Text',
                'Strips whitespace and formats',
                Icons.cleaning_services,
                Colors.green,
                () {
                  _triggerOverlayBanner('Active text formatted & cleaned instantly.');
                },
              ),
              _buildQuickTriggerCard(
                'Quick Note Overlay',
                'Spawns quick floating note pin',
                Icons.push_pin,
                Colors.amber,
                () {
                  _triggerOverlayBanner('Sticky note pinned to floating overlay workspace.');
                },
              ),
              _buildQuickTriggerCard(
                'Screen Calc Pad',
                'Launches interactive mini split calc',
                Icons.calculate,
                Colors.purple,
                () {
                  _triggerOverlayBanner('Screen Calculator active in quick dock.');
                },
              ),
            ],
          ),

          const SizedBox(height: 24),
          // User Engagement Screen Stats Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF312E81), Color(0xFF1E1B4B)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: Colors.amber, size: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Active Overlay Status: READY',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Bubble Position: (${_bubblePosition.dx.toInt()}, ${_bubblePosition.dy.toInt()})',
                        style: const TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _bubblePosition = const Offset(20, 180);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                  child: const Text('Reset Ball', style: TextStyle(color: Colors.white, fontSize: 11)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _triggerOverlayBanner(String message) {
    setState(() {
      _activeNotificationText = message;
      _showFloatingBanner = true;
    });
  }

  Widget _buildQuickTriggerCard(
      String title, String desc, IconData icon, Color color, VoidCallback onTap) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 44) / 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
              const SizedBox(height: 4),
              Text(
                desc,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // TAB 2: SMART CLIPBOARD VAULT
  // ----------------------------------------------------
  Widget _buildClipboardVaultPage() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 70, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBadge('CLIPBOARD VAULT', Icons.content_paste, Colors.blueAccent),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Persistent Clip Storage',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _showAddClipDialog(titleController, contentController);
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Clip'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Keep frequently used snippets, templates, zoom links, and micro-replies ready for 1-tap pasting.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 18),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _clipboardVault.length,
            itemBuilder: (context, index) {
              final clip = _clipboardVault[index];
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            clip['tag'] ?? 'Clip',
                            style: const TextStyle(color: Colors.blueAccent, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.copy, size: 18, color: Colors.tealAccent),
                              onPressed: () {
                                _triggerOverlayBanner('Copied to clipboard: ${clip['title']}');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Copied "${clip['title']}" to clipboard!')),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 18, color: Colors.redAccent),
                              onPressed: () {
                                setState(() {
                                  _clipboardVault.removeAt(index);
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                    Text(
                      clip['title'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    SelectableText(
                      clip['content'] ?? '',
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
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

  void _showAddClipDialog(TextEditingController titleCtrl, TextEditingController contentCtrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Add Dynamic Clip', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Clip Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Snippet Content',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                setState(() {
                  _clipboardVault.add({
                    'title': titleCtrl.text,
                    'content': contentCtrl.text,
                    'tag': 'Custom',
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save Clip'),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // TAB 3: TEXT TRANSFORMER & METRICS
  // ----------------------------------------------------
  Widget _buildTextTransformerPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 70, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBadge('SMART TEXT TRANSFORMER', Icons.text_format, Colors.teal),
          const SizedBox(height: 10),
          const Text(
            'Instant Text Refiner',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'Paste dirty draft messages or articles to clean spacing, change casing, build hashtags, or strip line breaks.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _textTransformController,
            maxLines: 4,
            style: const TextStyle(fontSize: 13),
            decoration: const InputDecoration(
              hintText: 'Paste or type text here...',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Color(0xFF1E293B),
            ),
            onChanged: (val) {
              setState(() {
                _transformedResult = val;
              });
            },
          ),
          const SizedBox(height: 14),

          // Action Transformer Buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTransformChip('Clean Spaces', () {
                setState(() {
                  _transformedResult = _textTransformController.text.replaceAll(RegExp(r'\s+'), ' ').trim();
                });
              }),
              _buildTransformChip('UPPERCASE', () {
                setState(() {
                  _transformedResult = _textTransformController.text.toUpperCase();
                });
              }),
              _buildTransformChip('lowercase', () {
                setState(() {
                  _transformedResult = _textTransformController.text.toLowerCase();
                });
              }),
              _buildTransformChip('Title Case', () {
                setState(() {
                  _transformedResult = _textTransformController.text
                      .split(' ')
                      .map((str) => str.isNotEmpty ? '${str[0].toUpperCase()}${str.substring(1).toLowerCase()}' : '')
                      .join(' ');
                });
              }),
              _buildTransformChip('Hashtagify', () {
                setState(() {
                  _transformedResult = _textTransformController.text
                      .split(' ')
                      .where((w) => w.isNotEmpty)
                      .map((w) => '#${w.replaceAll(RegExp(r'\W+'), '')}')
                      .join(' ');
                });
              }),
              _buildTransformChip('Remove Breaks', () {
                setState(() {
                  _transformedResult = _textTransformController.text.replaceAll('\n', ' ');
                });
              }),
            ],
          ),

          const SizedBox(height: 18),
          const Text('Live Result Preview:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  _transformedResult.isEmpty ? 'Your transformed text will appear here...' : _transformedResult,
                  style: TextStyle(color: _transformedResult.isEmpty ? Colors.grey : Colors.white, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Chars: ${_transformedResult.length} | Words: ${_transformedResult.trim().isEmpty ? 0 : _transformedResult.trim().split(RegExp(r'\s+')).length}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _triggerOverlayBanner('Transformed text copied!');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Result copied to clipboard!')),
                        );
                      },
                      icon: const Icon(Icons.copy, size: 14),
                      label: const Text('Copy Output', style: TextStyle(fontSize: 11)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTransformChip(String label, VoidCallback onTap) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 11, color: Colors.white)),
      backgroundColor: const Color(0xFF334155),
      onPressed: onTap,
    );
  }

  // ----------------------------------------------------
  // TAB 4: MICRO CALC & QUICK CONVERTER
  // ----------------------------------------------------
  Widget _buildMicroCalcPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 70, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBadge('SPEED MATH & SPLIT CALC', Icons.calculate, Colors.purpleAccent),
          const SizedBox(height: 10),
          const Text(
            'Floating Quick Pad',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'Calculate micro split expenses and copy output directly into your active messaging chats.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.purple.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_calcInput.isEmpty ? '0' : _calcInput, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                  _calcResult,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.purpleAccent),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Keypad Buttons
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildCalcBtn('C', color: Colors.redAccent, onTap: () {
                setState(() {
                  _calcInput = "";
                  _calcResult = "0";
                });
              }),
              _buildCalcBtn('(', color: Colors.grey, onTap: () => _onCalcKey('(')),
              _buildCalcBtn(')', color: Colors.grey, onTap: () => _onCalcKey(')')),
              _buildCalcBtn('/', color: Colors.amber, onTap: () => _onCalcKey('/')),

              _buildCalcBtn('7', onTap: () => _onCalcKey('7')),
              _buildCalcBtn('8', onTap: () => _onCalcKey('8')),
              _buildCalcBtn('9', onTap: () => _onCalcKey('9')),
              _buildCalcBtn('*', color: Colors.amber, onTap: () => _onCalcKey('*')),

              _buildCalcBtn('4', onTap: () => _onCalcKey('4')),
              _buildCalcBtn('5', onTap: () => _onCalcKey('5')),
              _buildCalcBtn('6', onTap: () => _onCalcKey('6')),
              _buildCalcBtn('-', color: Colors.amber, onTap: () => _onCalcKey('-')),

              _buildCalcBtn('1', onTap: () => _onCalcKey('1')),
              _buildCalcBtn('2', onTap: () => _onCalcKey('2')),
              _buildCalcBtn('3', onTap: () => _onCalcKey('3')),
              _buildCalcBtn('+', color: Colors.amber, onTap: () => _onCalcKey('+')),

              _buildCalcBtn('0', onTap: () => _onCalcKey('0')),
              _buildCalcBtn('.', onTap: () => _onCalcKey('.')),
              _buildCalcBtn('Copy', color: Colors.teal, onTap: () {
                _triggerOverlayBanner('Calculated total \$$_calcResult copied!');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Copied \$$_calcResult to clipboard!')),
                );
              }),
              _buildCalcBtn('=', color: Colors.purpleAccent, onTap: _evalCalc),
            ],
          ),

          const SizedBox(height: 16),
          if (_calcHistory.isNotEmpty) ...[
            const Text('Recent Calculation Log:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _calcHistory.reversed.take(4).map((item) {
                return Chip(
                  label: Text(item, style: const TextStyle(fontSize: 10, color: Colors.white70)),
                  backgroundColor: const Color(0xFF1E293B),
                );
              }).toList(),
            )
          ]
        ],
      ),
    );
  }

  void _onCalcKey(String val) {
    setState(() {
      _calcInput += val;
    });
  }

  void _evalCalc() {
    try {
      // Simple expression evaluator
      String input = _calcInput;
      if (input.contains('+')) {
        var parts = input.split('+');
        double res = double.parse(parts[0]) + double.parse(parts[1]);
        _calcResult = res.toStringAsFixed(2);
      } else if (input.contains('-')) {
        var parts = input.split('-');
        double res = double.parse(parts[0]) - double.parse(parts[1]);
        _calcResult = res.toStringAsFixed(2);
      } else if (input.contains('*')) {
        var parts = input.split('*');
        double res = double.parse(parts[0]) * double.parse(parts[1]);
        _calcResult = res.toStringAsFixed(2);
      } else if (input.contains('/')) {
        var parts = input.split('/');
        double res = double.parse(parts[0]) / double.parse(parts[1]);
        _calcResult = res.toStringAsFixed(2);
      } else {
        _calcResult = input;
      }
      setState(() {
        _calcHistory.add('$_calcInput = \$$_calcResult');
      });
    } catch (e) {
      setState(() {
        _calcResult = "Error";
      });
    }
  }

  Widget _buildCalcBtn(String label, {Color color = const Color(0xFF334155), required VoidCallback onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  // ----------------------------------------------------
  // TAB 5: FLOATING STICKY DOCK
  // ----------------------------------------------------
  Widget _buildStickyDockPage() {
    final noteTitleController = TextEditingController();
    final noteDescController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 70, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBadge('FLOATING STICKY DOCK', Icons.note_alt, Colors.amber),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pinned Sticky Notes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _showAddStickyDialog(noteTitleController, noteDescController);
                },
                icon: const Icon(Icons.push_pin, size: 16),
                label: const Text('Pin Note'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade700),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Keep critical micro reminders floating visually on screen so you never forget micro tasks.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 18),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.95,
            ),
            itemCount: _stickyNotes.length,
            itemBuilder: (context, index) {
              final note = _stickyNotes[index];
              Color cardColor = note['color'] == 'amber' ? Colors.amber.shade800 : Colors.teal.shade800;

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardColor.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: cardColor, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.push_pin, size: 16, color: Colors.amberAccent),
                        IconButton(
                          icon: const Icon(Icons.close, size: 16, color: Colors.white70),
                          onPressed: () {
                            setState(() {
                              _stickyNotes.removeAt(index);
                            });
                          },
                        )
                      ],
                    ),
                    Text(
                      note['title'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        note['desc'] ?? '',
                        style: const TextStyle(fontSize: 11, color: Colors.white70),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void _showAddStickyDialog(TextEditingController titleCtrl, TextEditingController descCtrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('New Sticky Pin', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Note Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Reminder Details',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                setState(() {
                  _stickyNotes.add({
                    'title': titleCtrl.text,
                    'desc': descCtrl.text,
                    'color': 'amber',
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Pin to Overlay'),
          ),
        ],
      ),
    );
  }

  // Common Header Badge Helper
  Widget _buildHeaderBadge(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// INTERACTIVE DRAGGABLE FLOATING BALL OVERLAY WIDGET
// ----------------------------------------------------
class GestureDetecorOverlayBall extends StatelessWidget {
  final bool isExpanded;
  final Function(DragUpdateDetails) onPanUpdate;
  final VoidCallback onTapBubble;
  final Function(String) onActionSelected;

  const GestureDetecorOverlayBall({
    super.key,
    required this.isExpanded,
    required this.onPanUpdate,
    required this.onTapBubble,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onPanUpdate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bubble Ball Icon
          InkWell(
            onTap: onTapBubble,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Colors.indigoAccent, Colors.purpleAccent],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigoAccent.withOpacity(0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Icon(
                isExpanded ? Icons.close : Icons.widgets,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),

          // Expanded Floating Menu Deck
          if (isExpanded)
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(10),
              width: 180,
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.indigoAccent, width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black87,
                    blurRadius: 16,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFloatingMenuItem(
                    Icons.content_paste,
                    'Quick Clip',
                    Colors.blueAccent,
                    () => onActionSelected('Quick Clip Pasted'),
                  ),
                  _buildFloatingMenuItem(
                    Icons.cleaning_services,
                    'Clean Draft',
                    Colors.teal,
                    () => onActionSelected('Draft Spaces Cleaned'),
                  ),
                  _buildFloatingMenuItem(
                    Icons.calculate,
                    'Speed Calc',
                    Colors.purpleAccent,
                    () => onActionSelected('Speed Calc Docked'),
                  ),
                  _buildFloatingMenuItem(
                    Icons.push_pin,
                    'Sticky Pad',
                    Colors.amber,
                    () => onActionSelected('Sticky Pin Dropped'),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _buildFloatingMenuItem(IconData icon, String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}